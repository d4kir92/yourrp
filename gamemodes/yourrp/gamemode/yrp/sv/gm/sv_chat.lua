--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #CHAT

util.AddNetworkString( "ShowAlert" )
local alerts = {}

function AddAlert(str)
	table.insert( alerts, str)
end

YRPAlertsHOOKED = YRPAlertsHOOKED or false
if !YRPAlertsHOOKED then
	YRPAlertsHOOKED = true
	
	local d = 0

	local function YRPSetAlerts()
		if d < CurTime() then
			if net.BytesLeft() != nil then
				return
			end
			
			if table.Count( alerts) > 0 then
				local first = table.GetFirstValue( alerts)
				d = CurTime() + math.Clamp(string.len(tostring(first) ) / 2, 3, 10)

				SetGlobalYRPString( "yrp_alert", first)

				local result = table.RemoveByValue( alerts, first)
			elseif GetGlobalYRPString( "yrp_alert" ) != "" then
				SetGlobalYRPString( "yrp_alert", "" )
			end
		end
		timer.Simple( 0.1, YRPSetAlerts )
	end
	YRPSetAlerts()
end

util.AddNetworkString( "yrp_player_say" )

util.AddNetworkString( "startchat" )
net.Receive( "startchat", function(len, ply)
	ply:SetYRPBool( "istyping", true)
end)

util.AddNetworkString( "finishchat" )
net.Receive( "finishchat", function(len, ply)
	ply:SetYRPBool( "istyping", false)
end)

function print_help(sender)
	sender:ChatPrint( "--- --- ---" )
	sender:ChatPrint( "[HELP] (/help or !help) Any command can start with / or !" )
	sender:ChatPrint( "afk - Away from keyboard" )
	sender:ChatPrint( "dnd - Do not disturb" )
	sender:ChatPrint( "me - Emote chat" )
	sender:ChatPrint( "yell - Yell locally" )
	sender:ChatPrint( "general - General chat (global)" )
	sender:ChatPrint( "ooc or / - Out of character chat" )
	sender:ChatPrint( "looc or . - Local out of character chat" )
	sender:ChatPrint( "advert - Advert chat" )
	sender:ChatPrint( "service - Service chat" )
	sender:ChatPrint( "dropweapon - Drops the current weapon" )
	sender:ChatPrint( "dropmoney AMOUNT - drop money to ground" )
	sender:ChatPrint( "roll - roll a number between 0 and 100" )
	sender:ChatPrint( "kill - suicide" )
	--sender:ChatPrint( "sleep - sleep or wake up" )
	sender:ChatPrint( "tag_ug - show usergroup tag" )
	sender:ChatPrint( "tag_immortal - shows immortal tag" )
	if sender:HasAccess() then
		sender:ChatPrint( "ADMIN ONLY:" )

		sender:ChatPrint( "addmoney NAME AMOUNT - adds money to NAME" )
		sender:ChatPrint( "setmoney NAME AMOUNT - sets money of NAME" )

		sender:ChatPrint( "addlevel NAME AMOUNT - adds level to NAME" )
		sender:ChatPrint( "setlevel NAME AMOUNT - sets level of NAME" )

		sender:ChatPrint( "addxp NAME AMOUNT - adds xp to NAME" )

		sender:ChatPrint( "givelicense NAME LICENSENAME" )

		sender:ChatPrint( "revive NAME" )
	end
	sender:ChatPrint( "--- --- ---" )
	return ""
end

function drop_weapon(sender)
	if ea(sender) then
		local _weapon = sender:GetActiveWeapon()
		if _weapon != nil and PlayersCanDropWeapons() then
			if ea(_weapon) then
				sender:DropSWEP(_weapon:GetClass() )
			end
		else
			YRP.msg( "note", sender:YRPName() .. " drop weapon is disabled!" )
		end
	end
	return ""
end

function YRPDropMoney( ply, amount )
	if ply and amount then
		local _moneyAmount = math.abs( amount )
		if ply:canAfford(_moneyAmount) then
			local emoney = ents.Create( "yrp_money" )
			ply:addMoney(-_moneyAmount)
			local tr = util.TraceHull({
				start = ply:GetPos() + ply:GetUp() * 74,
				endpos = ply:GetPos() + ply:GetUp() * 74 + ply:GetForward() * 64,
				filter = ply,
				mins = Vector(-10, -10, -10),
				maxs = Vector(10, 10, 10),
				mask = MASK_SHOT_HULL
			})
			if tr.Hit then
				local tr2 = util.TraceHull({
					start = ply:GetPos() + ply:GetUp() * 74,
					endpos = ply:GetPos() + ply:GetUp() * 74 - ply:GetForward() * 64,
					filter = ply,
					mins = Vector(-10, -10, -10),
					maxs = Vector(10, 10, 10),
					mask = MASK_SHOT_HULL
				})
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
			YRP.msg( "note", ply:Nick() .. " dropped " .. _moneyAmount .. " money" )
			return ""
		else
			YRP.msg( "note", ply:Nick() .. " can't afford to dropmoney ( " .. _moneyAmount .. " )" )
		end
	else
		YRP.msg( "note", "YRPDropMoney invalid input" )
	end
end

function drop_money(sender, text)
	local _table = string.Explode( " ", text)
	local _money = tonumber(_table[2])
	if isnumber(_money) then
		YRPDropMoney( sender, _money )
	else
		YRP.msg( "note", "Failed dropmoney" )
	end
	sender:ChatPrint( "\nCommand-FAILED" )
end

function do_suicide(sender)
	if IsAllowedToSuicide(sender) then
		sender:Kill()
	end
	return ""
end

function show_tag_dev(sender)
	if !sender:GetYRPBool( "tag_dev", false) then
		sender:SetYRPBool( "tag_dev", true)
	else
		sender:SetYRPBool( "tag_dev", false)
	end
	if sender:GetYRPBool( "tag_dev", false) then
		sender:ChatPrint( "[tag_dev] enabled" )
	else
		sender:ChatPrint( "[tag_dev] disabled" )
	end
	return ""
end

function show_tag_tra(sender)
	if !sender:GetYRPBool( "tag_tra", false) then
		sender:SetYRPBool( "tag_tra", true)
	else
		sender:SetYRPBool( "tag_tra", false)
	end
	if sender:GetYRPBool( "tag_tra", false) then
		sender:ChatPrint( "[tag_tra] enabled" )
	else
		sender:ChatPrint( "[tag_tra] disabled" )
	end
	return ""
end

function show_tag_ug(sender)
	if !sender:GetYRPBool( "tag_ug", false) then
		sender:SetYRPBool( "tag_ug", true)
	else
		sender:SetYRPBool( "tag_ug", false)
	end
	if sender:GetYRPBool( "tag_ug", false) then
		sender:ChatPrint( "[tag_ug] enabled" )
	else
		sender:ChatPrint( "[tag_ug] disabled" )
	end
	return ""
end

function set_money(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode( " ", text, false)
		local _name = _table[2]
		local _money = tonumber(_table[3])
		if isnumber(_money) then
			local ply = GetPlayerByName(_name)
			if ply != NULL then
				if ply.addMoney == nil then
					sender:ChatPrint( "\nCommand-FAILED: Is not a Player" )
					return ""
				end
				ply:SetMoney(_money)
				YRP.msg( "note", sender:Nick() .. " sets the money of " .. ply:Nick() .. " to " .. _money)
				return ""
			else
				YRP.msg( "note", "[set_money] Name: " .. tostring(_name) .. " not found!" )
				return ""
			end
		end
		sender:ChatPrint( "\nCommand-FAILED" )
	else
		YRP.msg( "note", sender:YRPName() .. " tried to use setmoney!" )
	end
end

function revive(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode( " ", text, false)
		local _name = _table[2]
		local ply = GetPlayerByName(_name)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:Alive() then
				sender:ChatPrint( "\nCommand-FAILED: Player alive" )
				return ""
			end
			local rd = ply:GetRagdollEntity()
			if IsValid( rd ) then
				ply:Revive(rd:GetPos() )
			else
				ply:Revive(ply:GetPos() )
			end
			return ""
		else
			sender:ChatPrint( "\nCommand-FAILED" )
		end
	else
		YRP.msg( "note", sender:YRPName() .. " tried to use setmoney!" )
	end
end

function add_money(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode( " ", text, false)
		local _name = _table[2]
		local _money = tonumber(_table[3])
		if isnumber(_money) then
			local ply = GetPlayerByName(_name)
			if ply != NULL then
				if ply.addMoney == nil then
					sender:ChatPrint( "\nCommand-FAILED: Is not a Player" )
					return ""
				end
				ply:addMoney(_money)
				YRP.msg( "note", sender:Nick() .. " adds " .. _money .. " to " .. ply:Nick() )
				return ""
			else
				sender:ChatPrint( "\nCommand-FAILED: Player not found" )
			end
		end
	else
		YRP.msg( "note", sender:Nick() .. " tried to use addmoney!" )
	end
end

function add_xp(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode( " ", text, false)
		local _name = _table[2]
		local _xp = tonumber(_table[3])
		if isnumber(_xp) then
			local _receiver = GetPlayerByName(_name)
			if ea(_receiver) then
				_receiver:AddXP(_xp)
				return ""
			else
				sender:ChatPrint( "\nCommand-FAILED NAME not found" )
			end
		end
	else
		YRP.msg( "note", sender:Nick() .. " tried to use addxp!" )
	end
end

function add_level(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode( " ", text, false)
		local _name = _table[2]
		local _lvl = tonumber(_table[3])
		if isnumber(_lvl) then
			local _receiver = GetPlayerByName(_name)
			if wk(_receiver) and _receiver.AddLevel != nil then
				_receiver:AddLevel(_lvl)
				return ""
			else
				sender:ChatPrint( "\nCommand-FAILED NAME not found" )
			end
		end
	else
		YRP.msg( "note", sender:Nick() .. " tried to use addlevel!" )
	end
end

function set_level(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode( " ", text, false)
		local _name = _table[2]
		local _lvl = tonumber(_table[3])
		if isnumber(_lvl) then
			local _receiver = GetPlayerByName(_name)
			if ea(_receiver) then
				_receiver:SetLevel(_lvl)
				return ""
			else
				sender:ChatPrint( "\nCommand-FAILED NAME not found" )
			end
		end
	else
		YRP.msg( "note", sender:Nick() .. " tried to use setlevel!" )
	end
end

util.AddNetworkString( "set_chat_mode" )
net.Receive( "set_chat_mode", function(len, ply)
	local _str = net.ReadString() or "say"
	ply:SetYRPString( "chat_mode", string.upper(_str) )
end)

util.AddNetworkString( "yrpsendanim" )
function YRPSendAnim(ply, slot, activity, loop)
	net.Start( "yrpsendanim" )
		net.WriteEntity(ply)
		net.WriteInt(slot, 32)
		net.WriteInt( activity, 32)
		net.WriteBool(loop)
	net.Broadcast()
end

util.AddNetworkString( "yrpstopanim" )
function YRPStopAnim(ply, slot)
	net.Start( "yrpstopanim" )
		net.WriteEntity(ply)
		net.WriteInt(slot, 32)
	net.Broadcast()
end

local Player = FindMetaTable( "Player" )
function Player:SetAFK( bo)
	self:SetYRPFloat( "afkts", CurTime() )
	self:SetYRPBool( "isafk", bo)
	
	YRPSendAnim(self, GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_SIT, false)
end

util.AddNetworkString( "notafk" )
net.Receive( "notafk", function(len, ply)
	if ply:AFK() then
		ply:SetAFK(false)
		YRPStopAnim(ply, GESTURE_SLOT_ATTACK_AND_RELOAD)
	end
end)

util.AddNetworkString( "setafk" )
net.Receive( "setafk", function(len, ply)
	ply:SetAFK(true)
end)

function strTrimLeft(str, cha)
	local s, e = string.find(str, cha)
	if s then
		return string.sub(str, 1, s - 1)
	else
		return ""
	end
end

function strTrimRight(str, cha)
	local s, e = string.find(str, cha)
	if s then
		return string.sub(str, s + 1)
	else
		return ""
	end
end

function DoCommand(sender, command, text)
	command = string.lower( command)
	text = text or ""

	local purtext = text

	text = command .. " " .. text

	if command == "afk" then
		sender:SetAFK(!sender:AFK() )
		return ""
	end

	if command == "dnd" then
		sender:SetYRPBool( "isdnd", !sender:GetYRPBool( "isdnd", false) )
		return ""
	end

	if command == "help" then
		print_help(sender)
		return ""
	end

	if command == "dropweapon" then
		drop_weapon(sender)
		return ""
	end

	if command == "dropmoney" then
		drop_money(sender, text)
		return ""
	end

	if command == "kill" then
		do_suicide(sender)
		return ""
	end

	if command == "tag_dev" then
		show_tag_dev(sender)
		return ""
	end

	if command == "tag_tra" then
		show_tag_tra(sender)
		return ""
	end

	if command == "tag_ug" then
		show_tag_ug(sender)
		return ""
	end

	if command == "setmoney" then
		set_money(sender, text)
		return ""
	end

	if command == "addmoney" then
		add_money(sender, text)
		return ""
	end

	if command == "addxp" then
		add_xp(sender, text)
		return ""
	end

	if command == "addlevel" then
		add_level(sender, text)
		return ""
	end

	if command == "setlevel" then
		set_level(sender, text)
		return ""
	end

	if command == "revive" then
		revive(sender, text)
		return ""
	end

	if command == "alert" then
		if sender:HasAccess() then
			AddAlert(string.sub(text, 7) )
			return ""
		end
	end

	if command == "givelicense" then
		text = string.sub(text, 14)
		local args = string.Explode( " ", text)
		local name = args[1]
		local lname = args[2]
	
		local ply = GetPlayerByName(name)
	
		local lid = GetLicenseIDByName(lname)
	
		if IsValid(ply) and wk(lid) then
			GiveLicense(ply, lid)
		else
			YRP.msg( "note", "[yrp_givelicense] Not found" )
		end
	end

	if command == "rpname" or command == "name" or command == "nick" then
		if GetGlobalYRPBool( "bool_characters_changeable_name", false) or sender:HasAccess() then
			local name = text

			name = string.Replace(name, "!rpname ", "" )
			name = string.Replace(name, "!name ", "" )
			name = string.Replace(name, "!nick ", "" )

			name = string.Replace(name, "/rpname ", "" )
			name = string.Replace(name, "/name ", "" )
			name = string.Replace(name, "/nick ", "" )

			name = string.Replace(name, "rpname ", "" )
			name = string.Replace(name, "name ", "" )
			name = string.Replace(name, "nick ", "" )

			local tab = string.Explode( " ", name)
			if string.find(name, "\"" ) then
				local newtab = string.Explode( "\"", name)
				tab = {}
				for i, v in pairs(newtab) do
					if !strEmpty( v) then
						v = string.Replace( v, "\"", "" )
						table.insert(tab, v)
					end
				end
			end

			local ply = GetPlayerByName(tab[1])

			if tab[#tab] != nil then
				name = tab[#tab]
				
				name = YRPCleanUpName( name )

				if ply != NULL then
					name = string.Replace(name, tab[1] .. " ", "" )
					ply:SetRPName(name, "chat command 1" )
				else
					if !strEmpty(name) then
						sender:SetRPName(name, "chat command 2" )
						return ""
					else
						sender:ChatPrint( "\nSetRPName need more text." )
					end
				end
			else
				sender:ChatPrint( "\ninvalid args." )
			end
		else
			sender:ChatPrint( "\nSetRPName is not enabled." )
		end
	end
end

timer.Simple(4, function() -- must be last hook
	hook.Add( "PlayerSay", "YRP_PlayerSay", function(sender, text, teamChat)
		local oldtext = text
		local channel = ""


		
		-- Find Channel
		if string.StartWith(text, "!" ) or string.StartWith(text, "/" ) or string.StartWith(text, "@" ) then
			local s, e = string.find(text, " " )
			if s then
				channel = string.sub(text, 2, s - 1)
				text = string.sub(text, s + 1)
			else
				channel = string.sub(text, 2)
				text = ""
			end
			channel = string.upper( channel)
		end
		if strEmpty(channel) then
			channel = "SAY"
		end

		-- TARGET
		local target = NULL
		local texttab = string.Explode( " ", text, false )
		if texttab[1] then
			local tar = GetPlayerByRPName( texttab[1] )
			if tar then
				target = tar
			end
		end



		-- Replace words with names
		text = YRPReplaceWithPlayerNames(text)



		-- Channels
		local tab = YRP_SQL_SELECT( "yrp_chat_channels", "*", "string_name = '" .. channel .. "'" )
		if wk(tab) then
			tab = tab[1]

			tab.int_mode = tonumber(tab.int_mode)

			local structure = tab.string_structure
			local structure2 = tab.string_structure2

			local pk = YRPChatReplaceCMDS(structure, sender, text)
			local pk2 = YRPChatReplaceCMDS(structure2, sender, text)

			if channel != "HELP" and !strEmpty(text) then
				YRP_SQL_INSERT_INTO( "yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "', 'LID_chat', '" .. sender:SteamID() .. "', " .. YRP_SQL_STR_IN(text) .. "" )
			end
			
			if !tobool(tab.bool_enabled) then
				return ""
			end

			if tab.int_mode == 0 then -- GLOBAL
				net.Start( "yrp_player_say" )
					net.WriteEntity(sender)
					net.WriteTable(pk)
				net.Broadcast()
				return ""
			elseif tab.int_mode == 1 then -- LOCAL
				for i, p in pairs(player.GetAll() ) do
					if tonumber(p:GetPos():Distance(sender:GetPos() )) < tonumber(GetGlobalYRPInt( "int_yrp_chat_range_local", 400) ) then
						net.Start( "yrp_player_say" )
							net.WriteEntity(sender)
							net.WriteTable(pk)
						net.Send(p)
					end
				end
				return ""
			elseif tab.int_mode == 2 then -- FACTION
				for i, v in pairs(player.GetAll() ) do
					if v:GetFactionUID() == sender:GetFactionUID() then
						net.Start( "yrp_player_say" )
							net.WriteEntity(sender)
							net.WriteTable(pk)
						net.Send( v)
					end
				end
				return ""
			elseif tab.int_mode == 3 then -- GROUP
				for i, v in pairs(player.GetAll() ) do
					if v:GetGroupUID() == sender:GetGroupUID() then
						net.Start( "yrp_player_say" )
							net.WriteEntity(sender)
							net.WriteTable(pk)
						net.Send( v)
					end
				end
				return ""
			elseif tab.int_mode == 4 then -- ROLE
				for i, v in pairs(player.GetAll() ) do
					if v:GetRoleUID() == sender:GetRoleUID() then
						net.Start( "yrp_player_say" )
							net.WriteEntity(sender)
							net.WriteTable(pk)
						net.Send( v)
					end
				end
				return ""
			elseif tab.int_mode == 5 then -- UserGroup
				for i, v in pairs(player.GetAll() ) do
					if v:GetUserGroup() == sender:GetUserGroup() then
						net.Start( "yrp_player_say" )
							net.WriteEntity(sender)
							net.WriteTable(pk)
						net.Send( v)
					end
				end
				return ""
			elseif tab.int_mode == 6 then -- Whisper
				if ea(target) then
					net.Start( "yrp_player_say" )
						net.WriteEntity(sender)
						net.WriteTable(pk2)
					net.Send(sender)

					net.Start( "yrp_player_say" )
						net.WriteEntity(target)
						net.WriteTable(pk)
					net.Send(target)
				elseif texttab[1] then
					pk2[2] = "\"" .. texttab[1] .. "\" is not on this server."
					net.Start( "yrp_player_say" )
						net.WriteEntity(sender)
						net.WriteTable(pk2)
					net.Send(sender)
				end
			elseif tab.int_mode == 9 then -- Custom
				-- IN WORK :P
				return ""
			else
				DoCommand(sender, channel, text)
			end
		else
			DoCommand(sender, channel, text)
		end

		-- RETURN NOTHING SO OTHER ADDONS CAN USE THIS ONE
		-- return oldtext --""
	end)
end)
