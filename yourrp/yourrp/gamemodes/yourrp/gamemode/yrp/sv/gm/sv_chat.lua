--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #CHAT
util.AddNetworkString("nws_yrp_showAlert")
local alerts = {}
function AddAlert(str)
	table.insert(alerts, str)
end

YRPAlertsHOOKED = YRPAlertsHOOKED or false
if not YRPAlertsHOOKED then
	YRPAlertsHOOKED = true
	local d = 0
	local function YRPSetAlerts()
		if d < CurTime() then
			if net.BytesLeft() ~= nil then return end
			if table.Count(alerts) > 0 then
				local first = table.GetFirstValue(alerts)
				d = CurTime() + math.Clamp(string.len(tostring(first)) / 2, 3, 10)
				SetGlobalYRPString("yrp_alert", first)
				table.RemoveByValue(alerts, first)
			elseif GetGlobalYRPString("yrp_alert") ~= "" then
				SetGlobalYRPString("yrp_alert", "")
			end
		end

		timer.Simple(0.1, YRPSetAlerts)
	end

	YRPSetAlerts()
end

util.AddNetworkString("nws_yrp_player_say")
util.AddNetworkString("nws_yrp_startchat")
net.Receive(
	"nws_yrp_startchat",
	function(len, ply)
		ply:SetYRPBool("istyping", true)
	end
)

util.AddNetworkString("nws_yrp_finishchat")
net.Receive(
	"nws_yrp_finishchat",
	function(len, ply)
		ply:SetYRPBool("istyping", false)
	end
)

function YRPHelpPrint(sender)
	sender:ChatPrint("--- --- ---")
	sender:ChatPrint("[HELP] (/help or !help) Any command can start with / or !")
	sender:ChatPrint("afk - Away from keyboard")
	sender:ChatPrint("dnd - Do not disturb")
	sender:ChatPrint("me - Emote chat")
	sender:ChatPrint("yell - Yell locally")
	sender:ChatPrint("general - General chat (global)")
	sender:ChatPrint("ooc or / - Out of character chat")
	sender:ChatPrint("looc or . - Local out of character chat")
	sender:ChatPrint("advert - Advert chat")
	sender:ChatPrint("service - Service chat")
	sender:ChatPrint("dropweapon - Drops the current weapon")
	sender:ChatPrint("dropmoney AMOUNT - drop money to ground")
	sender:ChatPrint("roll - roll a number between 0 and 100")
	sender:ChatPrint("kill - suicide")
	--sender:ChatPrint( "sleep - sleep or wake up" )
	sender:ChatPrint("tag_ug - show usergroup tag")
	sender:ChatPrint("tag_immortal - shows immortal tag")
	if sender:HasAccess("YRPHelpPrint", true) then
		sender:ChatPrint("ADMIN ONLY:")
		sender:ChatPrint("addmoney NAME AMOUNT - adds money to NAME")
		sender:ChatPrint("setmoney NAME AMOUNT - sets money of NAME")
		sender:ChatPrint("addlevel NAME AMOUNT - adds level to NAME")
		sender:ChatPrint("setlevel NAME AMOUNT - sets level of NAME")
		sender:ChatPrint("addxp NAME AMOUNT - adds xp to NAME")
		sender:ChatPrint("givelicense NAME LICENSENAME")
		sender:ChatPrint("revive NAME")
	end

	sender:ChatPrint("--- --- ---")
end

function YRPDropWeapon(sender)
	if YRPEntityAlive(sender) then
		local _weapon = sender:GetActiveWeapon()
		if _weapon ~= nil and PlayersCanDropWeapons() then
			if YRPEntityAlive(_weapon) then
				sender:DropSWEP(_weapon:GetClass())
			end
		else
			YRP.msg("note", sender:YRPName() .. " drop weapon is disabled!")
		end
	end
end

function YRPDropMoney(ply, amount)
	if ply and amount then
		local _moneyAmount = math.abs(amount)
		if ply:canAfford(_moneyAmount) then
			local emoney = ents.Create("yrp_money")
			ply:addMoney(-_moneyAmount)
			local tr = util.TraceHull(
				{
					start = ply:GetPos() + ply:GetUp() * 74,
					endpos = ply:GetPos() + ply:GetUp() * 74 + ply:GetForward() * 64,
					filter = ply,
					mins = Vector(-10, -10, -10),
					maxs = Vector(10, 10, 10),
					mask = MASK_SHOT_HULL
				}
			)

			if tr.Hit then
				local tr2 = util.TraceHull(
					{
						start = ply:GetPos() + ply:GetUp() * 74,
						endpos = ply:GetPos() + ply:GetUp() * 74 - ply:GetForward() * 64,
						filter = ply,
						mins = Vector(-10, -10, -10),
						maxs = Vector(10, 10, 10),
						mask = MASK_SHOT_HULL
					}
				)

				if tr2.Hit then
					emoney:SetPos(ply:GetPos() + ply:GetUp() * 74)
				else
					emoney:SetPos(ply:GetPos() + ply:GetUp() * 74 - ply:GetForward() * 64)
				end
			else
				emoney:SetPos(ply:GetPos() + ply:GetUp() * 74 + ply:GetForward() * 64)
			end

			emoney:Spawn()
			emoney:SetMoney(_moneyAmount)
			YRP.msg("note", ply:Nick() .. " dropped " .. _moneyAmount .. " money")

			return ""
		else
			YRP.msg("note", ply:Nick() .. " can't afford to dropmoney ( " .. _moneyAmount .. " )")
		end
	else
		YRP.msg("note", "YRPDropMoney invalid input")
	end
end

function YRPDropMoneyChat(sender, text)
	local _table = string.Explode(" ", text)
	local _money = tonumber(_table[1])
	if isnumber(_money) then
		YRPDropMoney(sender, _money)
	else
		YRP.msg("note", "Failed dropmoney")
	end

	sender:ChatPrint("\nCommand-FAILED")
end

function YRPSuicide(sender)
	if IsAllowedToSuicide(sender) then
		sender:Kill()
	end
end

function show_tag_dev(sender)
	if not sender:GetYRPBool("tag_dev", false) then
		sender:SetYRPBool("tag_dev", true)
	else
		sender:SetYRPBool("tag_dev", false)
	end

	if sender:GetYRPBool("tag_dev", false) then
		sender:ChatPrint("[tag_dev] enabled")
	else
		sender:ChatPrint("[tag_dev] disabled")
	end
end

function show_tag_tra(sender)
	if not sender:GetYRPBool("tag_tra", false) then
		sender:SetYRPBool("tag_tra", true)
	else
		sender:SetYRPBool("tag_tra", false)
	end

	if sender:GetYRPBool("tag_tra", false) then
		sender:ChatPrint("[tag_tra] enabled")
	else
		sender:ChatPrint("[tag_tra] disabled")
	end
end

function show_tag_ug(sender)
	if not sender:GetYRPBool("tag_ug", false) then
		sender:SetYRPBool("tag_ug", true)
	else
		sender:SetYRPBool("tag_ug", false)
	end

	if sender:GetYRPBool("tag_ug", false) then
		sender:ChatPrint("[tag_ug] enabled")
	else
		sender:ChatPrint("[tag_ug] disabled")
	end
end

util.AddNetworkString("nws_yrp_set_chat_mode")
net.Receive(
	"nws_yrp_set_chat_mode",
	function(len, ply)
		local _str = net.ReadString() or "say"
		ply:SetYRPString("chat_mode", string.upper(_str))
	end
)

util.AddNetworkString("yrpsendanim")
function YRPSendAnim(ply, slot, activity, loop)
	net.Start("yrpsendanim")
	net.WriteEntity(ply)
	net.WriteInt(slot, 32)
	net.WriteInt(activity, 32)
	net.WriteBool(loop)
	net.Broadcast()
end

util.AddNetworkString("yrpstopanim")
function YRPStopAnim(ply, slot)
	net.Start("yrpstopanim")
	net.WriteEntity(ply)
	net.WriteInt(slot, 32)
	net.Broadcast()
end

local Player = FindMetaTable("Player")
function Player:SetAFK(bo)
	self:SetYRPFloat("afkts", CurTime())
	self:SetYRPBool("isafk", bo)
	YRPSendAnim(self, GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_SIT, false)
end

util.AddNetworkString("nws_yrp_notafk")
net.Receive(
	"nws_yrp_notafk",
	function(len, ply)
		if ply:AFK() then
			ply:SetAFK(false)
			YRPStopAnim(ply, GESTURE_SLOT_ATTACK_AND_RELOAD)
		end
	end
)

util.AddNetworkString("nws_yrp_setafk")
net.Receive(
	"nws_yrp_setafk",
	function(len, ply)
		ply:SetAFK(true)
	end
)

function YRPChatAfk(sender)
	sender:SetAFK(not sender:AFK())
end

function YRPChatDnd(sender)
	sender:SetYRPBool("isdnd", not sender:GetYRPBool("isdnd", false))
end

function YRPChatRenamePlayer(sender, text)
	if not YRPEntityAlive(sender) then return false end
	if GetGlobalYRPBool("bool_characters_changeable_name", false) or sender:HasAccess("YRPChatRenamePlayer", true) then
		local name, newname = text, nil
		if string.find(name, "\"", 1, true) then
			local newtab = string.Explode("\"", name)
			local tab = {}
			for i, v in pairs(newtab) do
				if not strEmpty(v) then
					v = string.Replace(v, "\"", "")
					table.insert(tab, v)
				end
			end

			local ply = YRPGetPlayerByName(tab[1])
			if tab[#tab] ~= nil then
				name = tab[#tab]
				name = YRPCleanUpName(name)
				if ply ~= NULL then
					name = string.Replace(name, tab[1] .. " ", "")
					ply:SetRPName(name, "chat command 2.1")
				else
					if not strEmpty(name) then
						sender:SetRPName(name, "chat command 2.2")

						return ""
					else
						sender:ChatPrint("\nSetRPName need more text.")
					end
				end
			else
				sender:ChatPrint("\ninvalid args.")
			end
		else
			local tab = string.Split(text, " ")
			name, newname = tab[1], tab[2]
			if name and newname then
				local ply = YRPGetPlayerByName(name)
				if ply ~= NULL then
					ply:SetRPName(newname, "chat command 2.3")
				end
			elseif name then
				sender:SetRPName(name, "chat command 2.4")
			else
				sender:ChatPrint("\nMissing Name.")
			end
		end
	else
		sender:ChatPrint("\nSetRPName is not enabled.")
	end
end

function YRPChatAlert(sender, text)
	if sender:HasAccess("YRPChatAlert", true) then
		AddAlert(text)

		return ""
	end
end

function YRPChatGiveLicense(sender, text)
	local args = string.Explode(" ", text)
	local name = args[1]
	local lname = args[2]
	local ply = YRPGetPlayerByName(name)
	local lid = GetLicenseIDByName(lname)
	if IsValid(ply) and IsNotNilAndNotFalse(lid) then
		GiveLicense(ply, lid)
	else
		YRP.msg("note", "[yrp_givelicense] Not found")
	end
end

function YRPSetMoney(sender, text)
	if sender:HasAccess("YRPSetMoney", true) then
		local _table = string.Explode(" ", text, false)
		local _name = _table[1]
		local _money = tonumber(_table[2])
		if isnumber(_money) then
			local ply = YRPGetPlayerByName(_name)
			if ply ~= NULL then
				if ply.addMoney == nil then
					sender:ChatPrint("\nCommand-FAILED: Is not a Player")

					return ""
				end

				ply:SetMoney(_money)
				YRP.msg("note", sender:Nick() .. " sets the money of " .. ply:Nick() .. " to " .. _money)

				return ""
			else
				YRP.msg("note", "[YRPSetMoney] Name: " .. tostring(_name) .. " not found!")

				return ""
			end
		end

		sender:ChatPrint("\nCommand-FAILED")
	else
		YRP.msg("note", sender:YRPName() .. " tried to use setmoney!")
	end
end

function YRPRevive(sender, text)
	if sender:HasAccess("YRPRevive", true) then
		local _table = string.Explode(" ", text, false)
		local _name = _table[1]
		local ply = YRPGetPlayerByName(_name)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:Alive() then
				sender:ChatPrint("\nCommand-FAILED: Player alive")

				return ""
			end

			local rd = ply:GetRagdollEntity()
			if IsValid(rd) then
				ply:YRPRevive(rd:GetPos())
			else
				ply:YRPRevive(ply:GetPos())
			end

			return ""
		else
			sender:ChatPrint("\nCommand-FAILED")
		end
	else
		YRP.msg("note", sender:YRPName() .. " tried to use setmoney!")
	end
end

function YRPAddMoneyChat(sender, text)
	if sender:HasAccess("YRPAddMoneyChat") then
		local _table = string.Explode(" ", text, false)
		local _name = _table[1]
		local _money = tonumber(_table[2])
		if isnumber(_money) then
			local ply = YRPGetPlayerByName(_name)
			if ply ~= NULL then
				if ply.addMoney == nil then
					sender:ChatPrint("\nCommand-FAILED: Is not a Player")

					return ""
				end

				ply:addMoney(_money)
				YRP.msg("note", sender:Nick() .. " adds " .. _money .. " to " .. ply:Nick())

				return ""
			else
				sender:ChatPrint("\nCommand-FAILED: Player not found")
			end
		else
			YRP.msg("note", "[AddMoney] wrong arguments!")
		end
	else
		YRP.msg("note", sender:Nick() .. " tried to use addmoney!")
	end
end

function YRPAddXPChat(sender, text)
	if sender:HasAccess("YRPAddXPChat") then
		local _table = string.Explode(" ", text, false)
		local _name = _table[1]
		local _xp = tonumber(_table[2])
		if isnumber(_xp) then
			local _receiver = YRPGetPlayerByName(_name)
			if YRPEntityAlive(_receiver) then
				_receiver:AddXP(_xp)

				return ""
			else
				sender:ChatPrint("\nCommand-FAILED NAME not found")
			end
		end
	else
		YRP.msg("note", sender:Nick() .. " tried to use addxp!")
	end
end

function YRPAddLevelChat(sender, text)
	if sender:HasAccess("YRPAddLevelChat") then
		local _table = string.Explode(" ", text, false)
		local _name = _table[1]
		local _lvl = tonumber(_table[2])
		if isnumber(_lvl) then
			local _receiver = YRPGetPlayerByName(_name)
			if IsNotNilAndNotFalse(_receiver) and _receiver.AddLevel ~= nil then
				_receiver:AddLevel(_lvl)

				return ""
			else
				sender:ChatPrint("\nCommand-FAILED NAME not found")
			end
		end
	else
		YRP.msg("note", sender:Nick() .. " tried to use addlevel!")
	end
end

function YRPSetLevelChat(sender, text)
	if sender:HasAccess("YRPSetLevelChat") then
		local _table = string.Explode(" ", text, false)
		local _name = _table[1]
		local _lvl = tonumber(_table[2])
		if isnumber(_lvl) then
			local _receiver = YRPGetPlayerByName(_name)
			if YRPEntityAlive(_receiver) then
				_receiver:SetLevel(_lvl)

				return ""
			else
				sender:ChatPrint("\nCommand-FAILED NAME not found")
			end
		end
	else
		YRP.msg("note", sender:Nick() .. " tried to use setlevel!")
	end
end

function YRPResetLevelsChat(sender, text)
	if sender:HasAccess("YRPResetLevelsChat") then
		local _table = string.Explode(" ", text, false)
		if _table[1] ~= nil then
			local _bool = tobool(_table[1])
			if _bool then
				YRPUpdateResetLevel(sender)
			end
		else
			YRP.msg("note", "missing true")
		end
	else
		YRP.msg("note", sender:Nick() .. " tried to use resetlevels!")
	end
end

local cmdsS = {}
cmdsS["help"] = YRPHelpPrint
cmdsS["dropweapon"] = YRPDropWeapon
cmdsS["kill"] = YRPSuicide
cmdsS["tag_dev"] = show_tag_dev
cmdsS["tag_tra"] = show_tag_tra
cmdsS["tag_ug"] = show_tag_ug
cmdsS["afk"] = YRPChatAfk
cmdsS["dnd"] = YRPChatDnd
local cmdsM = {}
cmdsM["dropmoney"] = YRPDropMoneyChat
cmdsM["setmoney"] = YRPSetMoney
cmdsM["addmoney"] = YRPAddMoneyChat
cmdsM["addxp"] = YRPAddXPChat
cmdsM["addlevel"] = YRPAddLevelChat
cmdsM["setlevel"] = YRPSetLevelChat
cmdsM["resetlevels"] = YRPResetLevelsChat
cmdsM["revive"] = YRPRevive
cmdsM["alert"] = YRPChatAlert
cmdsM["givelicense"] = YRPChatGiveLicense
cmdsM["rpname"] = YRPChatRenamePlayer
cmdsM["name"] = YRPChatRenamePlayer
cmdsM["nick"] = YRPChatRenamePlayer
function YRPRunCommand(sender, command, text)
	if not YRPIsChatCommandsEnabled() then return false end
	if not YRPEntityAlive(sender) then return false end
	if command == nil then return false end
	command = string.lower(command)
	text = text or ""
	if cmdsS[command] then
		cmdsS[command](sender)
	elseif cmdsM[command] then
		cmdsM[command](sender, text)
	end
end

local eGlobal = 0
local eLocal = 1
local eFaction = 2
local eGroup = 3
local eRole = 4
local eUsergroup = 5
local eWhisper = 6
local eCustom = 10
local oldDistLocal = 0
local distLocal = 0
--local oldtext = text
timer.Simple(
	0,
	function()
		if YRPIsChatCommandsEnabled() then
			hook.Add(
				"PlayerSay",
				"YRP_PlayerSay",
				function(sender, text, teamChat)
					local channel = ""
					if oldDistLocal ~= GetGlobalYRPInt("int_yrp_chat_range_local", 400) then
						oldDistLocal = GetGlobalYRPInt("int_yrp_chat_range_local", 400)
						distLocal = GetGlobalYRPInt("int_yrp_chat_range_local", 400) ^ 2
					end

					-- Find Channel
					if string.StartWith(text, "!") or string.StartWith(text, "/") or string.StartWith(text, "@") then
						local s, _ = string.find(text, " ", 1, true)
						if s then
							channel = string.sub(text, 2, s - 1)
							text = string.sub(text, s + 1)
						else
							channel = string.sub(text, 2)
							text = ""
						end

						channel = string.upper(channel)
					end

					if strEmpty(channel) then
						channel = "SAY"
					end

					-- TARGET
					local target = NULL
					local texttab = string.Explode(" ", text, false)
					if texttab[1] then
						local tar = YRPGetPlayerByRPName(texttab[1])
						if tar then
							target = tar
						end
					end

					-- Replace words with names
					text = YRPReplaceWithPlayerNames(text)
					-- Channels
					local tab = YRP_SQL_SELECT("yrp_chat_channels", "*", "string_name = '" .. channel .. "'")
					if IsNotNilAndNotFalse(tab) then
						tab = tab[1]
						tab.int_mode = tonumber(tab.int_mode)
						local structure = tab.string_structure
						local structure2 = tab.string_structure2
						local pk = YRPChatReplaceCMDS(structure, sender, text)
						local pk2 = YRPChatReplaceCMDS(structure2, sender, text)
						if channel ~= "HELP" and not strEmpty(text) then
							YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "', 'LID_chat', '" .. sender:SteamID() .. "', " .. YRP_SQL_STR_IN(text) .. "")
						end

						if not tobool(tab.bool_enabled) then return "" end
						if tab.int_mode == eGlobal then
							net.Start("nws_yrp_player_say")
							net.WriteTable(pk)
							net.Broadcast()

							return ""
						elseif tab.int_mode == eLocal then
							local plys = {}
							for i, p in pairs(player.GetAll()) do
								if p:GetPos():DistToSqr(sender:GetPos()) < distLocal then
									table.insert(plys, p)
								end
							end

							if #plys > 0 then
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk)
								net.Send(plys)
							end

							return ""
						elseif tab.int_mode == eFaction then
							local plys = {}
							for i, p in pairs(player.GetAll()) do
								if p:GetFactionUID() == sender:GetFactionUID() then
									table.insert(plys, p)
								end
							end

							if #plys > 0 then
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk)
								net.Send(plys)
							end

							return ""
						elseif tab.int_mode == eGroup then
							local plys = {}
							for i, p in pairs(player.GetAll()) do
								if p:GetGroupUID() == sender:GetGroupUID() then
									table.insert(plys, p)
								end
							end

							if #plys > 0 then
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk)
								net.Send(plys)
							end

							return ""
						elseif tab.int_mode == eRole then
							local plys = {}
							for i, p in pairs(player.GetAll()) do
								if p:GetRoleUID() == sender:GetRoleUID() then
									table.insert(plys, p)
								end
							end

							if #plys > 0 then
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk)
								net.Send(plys)
							end

							return ""
						elseif tab.int_mode == eUsergroup then
							local plys = {}
							for i, p in pairs(player.GetAll()) do
								if p:GetUserGroup() == sender:GetUserGroup() then
									table.insert(plys, p)
								end
							end

							if #plys > 0 then
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk)
								net.Send(plys)
							end

							return ""
						elseif tab.int_mode == eWhisper then
							-- Whisper
							if YRPEntityAlive(target) then
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk2)
								net.Send(sender)
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk)
								net.Send(target)
							elseif texttab[1] then
								pk2[2] = "\"" .. texttab[1] .. "\" is not on this server."
								net.Start("nws_yrp_player_say")
								net.WriteTable(pk2)
								net.Send(sender)
							end
						elseif tab.int_mode == eCustom then
							return ""
						elseif YRPEntityAlive(sender) then
							-- Custom -- May in the future
							YRPRunCommand(sender, channel, text) -- no return, it breaks custom chat addons, like atlas
						end
					elseif YRPEntityAlive(sender) then
						YRPRunCommand(sender, channel, text) -- no return, it breaks custom chat addons, like atlas
					end
				end
			)
		else
			YRP.msg("note", "YourRP - Chat Commands (and channels) are disabled - F8 General -> Yourrp Chat Commands")
		end
	end
)
