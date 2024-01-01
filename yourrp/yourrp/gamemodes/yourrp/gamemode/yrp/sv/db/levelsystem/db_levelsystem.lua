--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_levelsystem"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_level_min", "INT DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_level_max", "INT DEFAULT 100")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_level_start", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_for_levelup", "INT DEFAULT 100")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_multiplier", "TEXT DEFAULT '1.5'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_per_kill", "TEXT DEFAULT '20'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_per_minute", "TEXT DEFAULT '10'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_per_revive", "TEXT DEFAULT '30'")
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "uniqueID", "'1'")
end

--[[ LOADOUT ]]
--
local Player = FindMetaTable("Player")
function Player:LevelSystemLoadout()
	local setting = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if IsNotNilAndNotFalse(setting) then
		setting = setting[1]
		self:SetYRPString("int_level_min", setting.int_level_min)
		self:SetYRPString("int_level_max", setting.int_level_max)
	end
end

util.AddNetworkString("nws_yrp_get_levelsystem_settings")
net.Receive(
	"nws_yrp_get_levelsystem_settings",
	function(len, ply)
		if ply:CanAccess("bool_levelsystem") then
			local setting = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
			if IsNotNilAndNotFalse(setting) then
				setting = setting[1]
				net.Start("nws_yrp_get_levelsystem_settings")
				net.WriteTable(setting)
				net.Send(ply)
			end
		end
	end
)

local yrp_levelsystem = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if IsNotNilAndNotFalse(yrp_levelsystem) then
	yrp_levelsystem = yrp_levelsystem[1]
	function YRP.XPPerMinute()
		return tonumber(yrp_levelsystem.int_xp_per_minute)
	end
end

util.AddNetworkString("nws_yrp_update_ls_int_level_min")
net.Receive(
	"nws_yrp_update_ls_int_level_min",
	function(len, ply)
		yrp_levelsystem.int_level_min = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_level_min"] = yrp_levelsystem.int_level_min
			}, "uniqueID = '1'"
		)
	end
)

util.AddNetworkString("nws_yrp_update_ls_int_level_max")
net.Receive(
	"nws_yrp_update_ls_int_level_max",
	function(len, ply)
		yrp_levelsystem.int_level_max = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_level_max"] = yrp_levelsystem.int_level_max
			}, "uniqueID = '1'"
		)
	end
)

util.AddNetworkString("nws_yrp_update_ls_int_level_start")
net.Receive(
	"nws_yrp_update_ls_int_level_start",
	function(len, ply)
		yrp_levelsystem.int_level_start = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_level_start"] = yrp_levelsystem.int_level_start
			}, "uniqueID = '1'"
		)
	end
)

util.AddNetworkString("nws_yrp_update_ls_float_multiplier")
net.Receive(
	"nws_yrp_update_ls_float_multiplier",
	function(len, ply)
		yrp_levelsystem.float_multiplier = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["float_multiplier"] = yrp_levelsystem.float_multiplier
			}, "uniqueID = '1'"
		)
	end
)

util.AddNetworkString("nws_yrp_update_ls_int_xp_for_levelup")
net.Receive(
	"nws_yrp_update_ls_int_xp_for_levelup",
	function(len, ply)
		yrp_levelsystem.int_xp_for_levelup = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_xp_for_levelup"] = yrp_levelsystem.int_xp_for_levelup
			}, "uniqueID = '1'"
		)
	end
)

util.AddNetworkString("nws_yrp_update_ls_int_xp_per_kill")
net.Receive(
	"nws_yrp_update_ls_int_xp_per_kill",
	function(len, ply)
		yrp_levelsystem.int_xp_per_kill = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_xp_per_kill"] = yrp_levelsystem.int_xp_per_kill
			}, "uniqueID = '1'"
		)
	end
)

util.AddNetworkString("nws_yrp_update_ls_int_xp_per_minute")
net.Receive(
	"nws_yrp_update_ls_int_xp_per_minute",
	function(len, ply)
		yrp_levelsystem.int_xp_per_minute = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_xp_per_minute"] = yrp_levelsystem.int_xp_per_minute
			}, "uniqueID = '1'"
		)
	end
)

util.AddNetworkString("nws_yrp_update_ls_int_xp_per_revive")
net.Receive(
	"nws_yrp_update_ls_int_xp_per_revive",
	function(len, ply)
		yrp_levelsystem.int_xp_per_revive = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_xp_per_revive"] = yrp_levelsystem.int_xp_per_revive
			}, "uniqueID = '1'"
		)
	end
)

function Player:ClearXP()
	if not self:Alive() then return end
	local charid = self:CharID()
	local result = YRP_SQL_UPDATE(
		"yrp_characters",
		{
			["int_xp"] = 0
		}, "uniqueID = '" .. charid .. "'"
	)

	if result ~= nil then
		YRP.msg("note", "ClearXP FAILED #1: " .. tostring(result))
	else
		self:SetYRPInt("int_xp", 0)
	end
end

function Player:AddLevel(level)
	if not self:Alive() then return end
	local charid = self:CharID()
	local curlvl = self:Level()
	local minlvl = self:GetMinLevel()
	local maxlvl = self:GetMaxLevel()
	if charid <= 0 and self:IsPlayer() and not self:IsBot() then
		YRP.msg("note", "AddLevel FAILED #3: charid <= 0: " .. tostring(charid) .. " ply: " .. self:YRPName())

		return
	end

	if level > 0 then
		level = level - 1
		local newlvl = curlvl + 1
		if newlvl <= maxlvl then
			local result = YRP_SQL_UPDATE(
				"yrp_characters",
				{
					["int_level"] = newlvl
				}, "uniqueID = '" .. charid .. "'"
			)

			timer.Simple(
				0.01,
				function()
					if result ~= nil then
						YRP.msg("error", "AddLevel FAILED #1: " .. tostring(result))
					elseif YRPEntityAlive(self) then
						self:SetYRPString("int_level", newlvl)
						self:AddLevel(level)
					end
				end
			)
		end
	elseif level < 0 then
		level = level + 1
		local newlvl = curlvl - 1
		if newlvl >= minlvl then
			local result = YRP_SQL_UPDATE(
				"yrp_characters",
				{
					["int_level"] = newlvl
				}, "uniqueID = '" .. charid .. "'"
			)

			timer.Simple(
				0.1,
				function()
					if result ~= nil then
						YRP.msg("error", "AddLevel FAILED #2: " .. tostring(result))
					elseif YRPEntityAlive(self) then
						self:SetYRPString("int_level", newlvl)
						self:AddLevel(level)
					end
				end
			)
		end
	end
end

function Player:SetLevel(level)
	if not self:Alive() then return end
	local curlvl = self:Level()
	self:ClearXP()
	self:AddLevel(level - curlvl)
end

function Player:AddXP(xp)
	if xp == nil then return end
	if not self:Alive() then return end
	xp = tonumber(xp)
	local lvltab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if lvltab and lvltab[1] then
		lvltab = lvltab[1]
		local chatab = self:YRPGetCharacterTable()
		local charid = self:CharID()
		if IsNotNilAndNotFalse(chatab) then
			local curxp = tonumber(chatab.int_xp)
			local lvl = tonumber(chatab.int_level)
			local lvlmulti = tonumber(lvltab.float_multiplier)
			local xpforlvl = tonumber(lvltab.int_xp_for_levelup)
			local maxxp = self:GetMaxXP()
			local curlvl = self:Level()
			local maxlvl = self:GetMaxLevel()
			if xp > 0 then
				local newxp = curxp + xp
				if curlvl < maxlvl then
					if newxp > maxxp then
						newxp = newxp - maxxp
						local result = YRP_SQL_UPDATE(
							"yrp_characters",
							{
								["int_xp"] = 0
							}, "uniqueID = '" .. charid .. "'"
						)

						if result ~= nil then
							YRP.msg("note", "AddXP FAILED #1: " .. tostring(result))
						else
							timer.Simple(
								0.01,
								function()
									if YRPEntityAlive(self) then
										self:AddLevel(1)
										self:AddXP(newxp)
									end
								end
							)
						end
					else
						local result = YRP_SQL_UPDATE(
							"yrp_characters",
							{
								["int_xp"] = newxp
							}, "uniqueID = '" .. charid .. "'"
						)

						if result ~= nil then
							YRP.msg("note", "AddXP FAILED #2: " .. tostring(result))
						else
							self:SetYRPInt("int_xp", newxp)
						end
					end
				elseif curlvl > maxlvl then
					self:SetLevel(maxlvl)
				elseif newxp > maxxp then
					local result = YRP_SQL_UPDATE(
						"yrp_characters",
						{
							["int_xp"] = maxxp
						}, "uniqueID = '" .. charid .. "'"
					)

					if result ~= nil then
						YRP.msg("note", "AddXP FAILED #5: " .. tostring(result))
					else
						self:SetYRPInt("int_xp", maxxp)
					end
				end
			elseif xp < 0 then
				local newxp = curxp + xp
				if curlvl > 1 then
					if newxp < 0 then
						maxxp = math.Round(math.pow(lvl - 1, lvlmulti), 0) + xpforlvl
						newxp = newxp + maxxp
						local result = YRP_SQL_UPDATE(
							"yrp_characters",
							{
								["int_xp"] = 0
							}, "uniqueID = '" .. charid .. "'"
						)

						if result ~= nil then
							YRP.msg("note", "AddXP FAILED #3: " .. tostring(result))
						else
							timer.Simple(
								0.01,
								function()
									if YRPEntityAlive(self) then
										self:AddLevel(-1)
										self:AddXP(newxp)
									end
								end
							)
						end
					else
						local result = YRP_SQL_UPDATE(
							"yrp_characters",
							{
								["int_xp"] = newxp
							}, "uniqueID = '" .. charid .. "'"
						)

						if result ~= nil then
							YRP.msg("note", "AddXP FAILED #4: " .. tostring(result))
						else
							self:SetYRPInt("int_xp", newxp)
						end
					end
				end
			end
		end
	end
end

function Player:SetXP(xp)
	if xp == nil then return end
	if not self:Alive() then return end
	xp = tonumber(xp)
	if xp <= self:GetMaxXP() then
		self:SetYRPInt("int_xp", xp)
		if self:CharID() then
			YRP_SQL_UPDATE(
				"yrp_characters",
				{
					["int_xp"] = xp
				}, "uniqueID = '" .. self:CharID() .. "'"
			)
		end
	end
end

hook.Add(
	"PlayerDeath",
	"yrp_xp_playerdeath",
	function(victim, inflictor, attacker)
		if attacker:IsPlayer() then
			local setting = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
			if IsNotNilAndNotFalse(setting) then
				setting = setting[1]
				attacker:AddXP(setting.int_xp_per_kill)
			end
		end
	end
)

hook.Add(
	"OnNPCKilled",
	"yrp_xp_onnpckilled",
	function(npc, attacker, inflictor)
		if attacker:IsPlayer() then
			local setting = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
			if IsNotNilAndNotFalse(setting) then
				setting = setting[1]
				attacker:AddXP(setting.int_xp_per_kill)
			end
		end
	end
)