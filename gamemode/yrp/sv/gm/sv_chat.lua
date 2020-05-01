--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #CHAT

util.AddNetworkString("ShowAlert")
local alerts = {}

function AddAlert(str)
	table.insert(alerts, str)
end

local d = 0
hook.Add("Think", "yrp_alerts", function()
	if d < CurTime() then
		if net.BytesLeft() != nil then
			return
		end

		if table.Count(alerts) > 0 then
			local first = table.GetFirstValue(alerts)

			d = CurTime() + math.Clamp(string.len(tostring(first)) / 2, 3, 10)

			SetGlobalDString("yrp_alert", first)

			local result = table.RemoveByValue(alerts, first)
		else
			SetGlobalDString("yrp_alert", "")
		end
	end
end)

util.AddNetworkString("yrp_player_say")

util.AddNetworkString("startchat")
net.Receive("startchat", function(len, ply)
	ply:SetDBool("istyping", true)
end)

util.AddNetworkString("finishchat")
net.Receive("finishchat", function(len, ply)
	ply:SetDBool("istyping", false)
end)

function print_help(sender)
	sender:ChatPrint("")
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
	sender:ChatPrint("sleep - sleep or wake up")
	sender:ChatPrint("tag_ug - show usergroup tag")
	sender:ChatPrint("tag_immortal - shows immortal tag")
	if sender:HasAccess() then
		sender:ChatPrint("ADMIN ONLY:")

		sender:ChatPrint("addmoney NAME AMOUNT - adds money to NAME")
		sender:ChatPrint("setmoney NAME AMOUNT - sets money of NAME")

		sender:ChatPrint("addlevel NAME AMOUNT - adds level to NAME")
		sender:ChatPrint("setlevel NAME AMOUNT - sets level of NAME")

		sender:ChatPrint("addxp NAME AMOUNT - adds xp to NAME")

		sender:ChatPrint("givelicense NAME LICENSENAME")

		sender:ChatPrint("revive NAME")
	end
	sender:ChatPrint("")
	return ""
end

function roll_number(sender)
	local number = math.Round(math.Rand(0, 100))
	return number
end

function drop_weapon(sender)
	if ea(sender) then
		local _weapon = sender:GetActiveWeapon()
		if _weapon != nil and PlayersCanDropWeapons() then
			if ea(_weapon) then
				sender:DropSWEP(_weapon:GetClass())
			end
		else
			printGM("note", sender:YRPName() .. " drop weapon is disabled!")
		end
	end
	return ""
end

function drop_money(sender, text)
	local _table = string.Explode(" ", text)
	local _money = tonumber(_table[2])
	if isnumber(_money) then
		local _moneyAmount = math.abs(_money)
		if sender:canAfford(_moneyAmount) then
			local emoney = ents.Create("yrp_money")
			sender:addMoney(-_moneyAmount)
			local tr = util.TraceHull({
				start = sender:GetPos() + sender:GetUp() * 74,
				endpos = sender:GetPos() + sender:GetUp() * 74 + sender:GetForward() * 64,
				filter = sender,
				mins = Vector(-10, -10, -10),
				maxs = Vector(10, 10, 10),
				mask = MASK_SHOT_HULL
			})
			if tr.Hit then
				local tr2 = util.TraceHull({
					start = sender:GetPos() + sender:GetUp() * 74,
					endpos = sender:GetPos() + sender:GetUp() * 74 - sender:GetForward() * 64,
					filter = sender,
					mins = Vector(-10, -10, -10),
					maxs = Vector(10, 10, 10),
					mask = MASK_SHOT_HULL
				})
				if tr2.Hit then
					emoney:SetPos(sender:GetPos() + sender:GetUp() * 74)
				else
					emoney:SetPos(sender:GetPos() + sender:GetUp() * 74 - sender:GetForward() * 64)
				end
			else
				emoney:SetPos(sender:GetPos() + sender:GetUp() * 74 + sender:GetForward() * 64)
			end
			emoney:Spawn()
			emoney:SetMoney(_moneyAmount)
			printGM("note", sender:Nick() .. " dropped " .. _moneyAmount .. " money")
			return ""
		else
			printGM("note", sender:Nick() .. " can't afford to dropmoney (" .. _moneyAmount .. ")")
		end
	else
		printGM("note", "Failed dropmoney")
	end
	sender:ChatPrint("\nCommand-FAILED")
end

function do_suicide(sender)
	if IsAllowedToSuicide(sender) then
		sender:Kill()
	end
	return ""
end

function show_tag_dev(sender)
	if !sender:GetDBool("tag_dev", false) then
		sender:SetDBool("tag_dev", true)
	else
		sender:SetDBool("tag_dev", false)
	end
	return ""
end
function show_tag_ug(sender)
	if !sender:GetDBool("tag_ug", false) then
		sender:SetDBool("tag_ug", true)
	else
		sender:SetDBool("tag_ug", false)
	end
	return ""
end

function set_money(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode(" ", text, false)
		local _name = _table[2]
		local _money = tonumber(_table[3])
		if isnumber(_money) then
			local ply = GetPlayerByName(_name)
			if ply != NULL then
				if ply.addMoney == nil then
					sender:ChatPrint("\nCommand-FAILED: Is not a Player")
					return ""
				end
				ply:SetMoney(_money)
				printGM("note", sender:Nick() .. " sets the money of " .. ply:Nick() .. " to " .. _money)
				return ""
			else
				printGM("note", "[set_money] Name: " .. tostring(_name) .. " not found!")
				return ""
			end
		end
		sender:ChatPrint("\nCommand-FAILED")
	else
		printGM("note", sender:YRPName() .. " tried to use setmoney!")
	end
end

function revive(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode(" ", text, false)
		local _name = _table[2]
		local ply = GetPlayerByName(_name)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:Alive() then
				sender:ChatPrint("\nCommand-FAILED: Player alive")
				return ""
			end
			ply:Revive(ply:GetPos())
			return ""
		else
			sender:ChatPrint("\nCommand-FAILED")
		end
	else
		printGM("note", sender:YRPName() .. " tried to use setmoney!")
	end
end

function add_money(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode(" ", text, false)
		local _name = _table[2]
		local _money = tonumber(_table[3])
		if isnumber(_money) then
			local ply = GetPlayerByName(_name)
			if ply != NULL then
				if ply.addMoney == nil then
					sender:ChatPrint("\nCommand-FAILED: Is not a Player")
					return ""
				end
				ply:addMoney(_money)
				printGM("note", sender:Nick() .. " adds " .. _money .. " to " .. ply:Nick())
				return ""
			else
				sender:ChatPrint("\nCommand-FAILED: Player not found")
			end
		end
	else
		printGM("note", sender:Nick() .. " tried to use addmoney!")
	end
end

function add_xp(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode(" ", text, false)
		local _name = _table[2]
		local _xp = tonumber(_table[3])
		if isnumber(_xp) then
			local _receiver = GetPlayerByName(_name)
			if worked(_receiver, "xp receiver not found!") then
				_receiver:AddXP(_xp)
				return ""
			else
				sender:ChatPrint("\nCommand-FAILED NAME not found")
			end
		end
	else
		printGM("note", sender:Nick() .. " tried to use addxp!")
	end
end

function add_level(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode(" ", text, false)
		local _name = _table[2]
		local _lvl = tonumber(_table[3])
		if isnumber(_lvl) then
			local _receiver = GetPlayerByName(_name)
			if wk(_receiver) and _receiver.AddLevel != nil then
				_receiver:AddLevel(_lvl)
				return ""
			else
				sender:ChatPrint("\nCommand-FAILED NAME not found")
			end
		end
	else
		printGM("note", sender:Nick() .. " tried to use addlevel!")
	end
end

function set_level(sender, text)
	if sender:HasAccess() then
		local _table = string.Explode(" ", text, false)
		local _name = _table[2]
		local _lvl = tonumber(_table[3])
		if isnumber(_lvl) then
			local _receiver = GetPlayerByName(_name)
			if worked(_receiver, "level receiver not found!") then
				_receiver:SetLevel(_lvl)
				return ""
			else
				sender:ChatPrint("\nCommand-FAILED NAME not found")
			end
		end
	else
		printGM("note", sender:Nick() .. " tried to use setlevel!")
	end
end

function do_sleep(sender)
	if sender:GetDBool("ragdolled", false) then
		DoUnRagdoll(sender)
	else
		DoRagdoll(sender)
	end
end

util.AddNetworkString("set_chat_mode")

net.Receive("set_chat_mode", function(len, ply)
	local _str = net.ReadString() or "say"
	ply:SetDString("chat_mode", string.lower(_str))
end)

util.AddNetworkString("sendanim")
function SendAnim(ply, slot, activity, loop)
	net.Start("sendanim")
		net.WriteEntity(ply)
		net.WriteInt(slot, 32)
		net.WriteInt(activity, 32)
		net.WriteBool(loop)
	net.Broadcast()
end

util.AddNetworkString("stopanim")
function StopAnim(ply, slot)
	net.Start("stopanim")
		net.WriteEntity(ply)
		net.WriteInt(slot, 32)
	net.Broadcast()
end

local Player = FindMetaTable("Player")
function Player:SetAFK(bo)
	self:SetDBool("isafk", bo)

	SendAnim(self, GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_SIT, false)
end

util.AddNetworkString("notafk")
net.Receive("notafk", function(len, ply)
	if ply:AFK() then
		ply:SetAFK(false)
		StopAnim(ply, GESTURE_SLOT_ATTACK_AND_RELOAD)
	end
end)

util.AddNetworkString("setafk")
net.Receive("setafk", function(len, ply)
	ply:SetAFK(true)
end)

function strTrimLeft(str, cha)
	local s, e = string.find(str, cha)
	return string.sub(str, 1, s - 1)
end

function strTrimRight(str, cha)
	local s, e = string.find(str, cha)
	return string.sub(str, s + 1)
end

function SendPM(sender, msg)
	local name = strTrimLeft(msg, " ")
	msg = strTrimRight(msg, " ")
	local target = GetPlayerByName(name)

	local pk = {}
	table.insert(pk, Color(255, 100, 255))
	table.insert(pk, "LID_to;")
	table.insert(pk, " ")
	table.insert(pk, target:RPName())
	table.insert(pk, ": ")
	table.insert(pk, msg)
	net.Start("yrp_player_say")
		net.WriteEntity(sender)
		net.WriteTable(pk)
	net.Send(sender)

	local pk2 = {}
	table.insert(pk2, Color(255, 100, 255))
	table.insert(pk2, "LID_from;")
	table.insert(pk2, " ")
	table.insert(pk2, sender:RPName())
	table.insert(pk2, ": ")
	table.insert(pk2, msg)
	net.Start("yrp_player_say")
		net.WriteEntity(target)
		net.WriteTable(pk2)
	net.Send(target)
end

function DoCommand(sender, command, text)
	command = string.lower(command)
	text = text or ""

	local purtext = text

	text = command .. " " .. text

	if command == "pm" or command == "w" then
		SendPM(sender, purtext)
	end

	if command == "afk" then
		sender:SetAFK(!sender:AFK())
		return ""
	end

	if command == "dnd" then
		sender:SetDBool("isdnd", !sender:GetDBool("isdnd", false))
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

	if command == "sleep" then
		do_sleep(sender)
		return ""
	end

	if command == "revive" then
		revive(sender, text)
		return ""
	end

	if command == "alert" then
		if sender:HasAccess() then
			AddAlert(string.sub(text, 8))
			return ""
		end
	end

	if command == "givelicense" then
		text = string.sub(text, 14)
		local args = string.Explode(" ", text)
		local name = args[1]
		local lname = args[2]
	
		local ply = GetPlayerByName(name)
	
		local lid = GetLicenseIDByName(lname)
	
		if IsValid(ply) and wk(lid) then
			GiveLicense(ply, lid)
		else
			YRP.msg("note", "[yrp_givelicense] Not found")
		end
	end

	if command == "rpname" or command == "name" or command == "nick" then
		if GetGlobalDBool("bool_characters_changeable_name", false) then
			sender:SetRPName(paket.text)
			return ""
		else
			sender:ChatPrint("SetRPName is not enabled.")
		end
	end
end

function RN(text)
	local cs, ce = string.find(text, "RN(", 1, true)
	if cs then
		local s, e = string.find(text, ")", cs, true)
		if e then
			local pre = string.sub(text, 1, cs - 1)
			local suf = string.sub(text, e + 1)
			local ex = string.sub(text, cs + 3, e - 1)

			ex = string.Explode(",", ex)

			local rn = math.random(ex[1], ex[2])

			text = pre .. rn .. suf
		end
	end
	return text
end

function GM:PlayerSay(sender, text, teamChat)
	local channel = "SAY"
	if string.StartWith(text, "!") or string.StartWith(text, "/") then
		local s, e = string.find(text, " ")
		if s then
			channel = string.sub(text, 2, s - 1)
			text = string.sub(text, s + 1)
		else
			channel = string.sub(text, 2)
			text = ""
		end
		channel = string.upper(channel)
	end

	local tab = SQL_SELECT("yrp_chat_channels", "*", "string_name = '" .. channel .. "'")
	if wk(tab) then
		tab = tab[1]
		
		tab.int_mode = tonumber(tab.int_mode)

		local result = tab.string_structure

		result = string.Replace(result, "%USERGROUP%", string.upper(sender:GetUserGroup()))
		result = string.Replace(result, "%STEAMNAME%", sender:SteamName())
		result = string.Replace(result, "%RPNAME%", sender:RPName())
		result = string.Replace(result, "%IDCARDID%", sender:IDCardID())

		result = string.Replace(result, "%FACTION%", sender:GetFactionName())
		result = string.Replace(result, "%GROUP%", sender:GetGroupName())
		result = string.Replace(result, "%ROLE%", sender:GetRoleName())

		result = string.Replace(result, "%TEXT%", text)

		result = RN(result)

		local pk = {}
		while(!strEmpty(result)) do
			local cs, ce = string.find(result, "Color(", 1, true)
			if cs == 1 then
				local s, e = string.find(result, ")", 1, true)
				if e then
					local color = string.sub(result, cs + 6, e - 1)
					color = string.Explode(",", color)
					table.insert(pk, Color(color[1], color[2], color[3]))

					result = string.sub(result, e + 1)
				end
			elseif cs then
				local tex = string.sub(result, 1, cs - 1)
				
				table.insert(pk, tex)

				result = string.sub(result, cs)
			else
				table.insert(pk, result)
				result = ""
			end
		end

		if text != "!help" and !strEmpty(text) then
			SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "', 'LID_chat', '" .. sender:SteamID64() .. "', '" .. SQL_STR_IN(text) .. "'")
		end

		if tab.int_mode == 0 then -- GLOBAL
			net.Start("yrp_player_say")
				net.WriteEntity(sender)
				net.WriteTable(pk)
			net.Broadcast()
			return ""
		elseif tab.int_mode == 1 then -- LOCAL
			for i, v in pairs(player.GetAll()) do
				if v:GetPos():Distance(sender:GetPos()) < GetGlobalDInt("int_yrp_chat_range_local", 400) then
					net.Start("yrp_player_say")
						net.WriteEntity(sender)
						net.WriteTable(pk)
					net.Send(v)
				end
			end
			return ""
		elseif tab.int_mode == 2 then -- FACTION
			for i, v in pairs(player.GetAll()) do
				if v:GetPos():Distance(sender:GetPos()) < GetGlobalDInt("int_yrp_chat_range_local", 400) then
					net.Start("yrp_player_say")
						net.WriteEntity(sender)
						net.WriteTable(pk)
					net.Send(v)
				end
			end
			return ""
		elseif tab.int_mode == 3 then -- GROUP
			for i, v in pairs(player.GetAll()) do
				if v:GetPos():Distance(sender:GetPos()) < GetGlobalDInt("int_yrp_chat_range_local", 400) then
					net.Start("yrp_player_say")
						net.WriteEntity(sender)
						net.WriteTable(pk)
					net.Send(v)
				end
			end
			return ""
		elseif tab.int_mode == 4 then -- ROLE
			for i, v in pairs(player.GetAll()) do
				if v:GetPos():Distance(sender:GetPos()) < GetGlobalDInt("int_yrp_chat_range_local", 400) then
					net.Start("yrp_player_say")
						net.WriteEntity(sender)
						net.WriteTable(pk)
					net.Send(v)
				end
			end
			return ""
		elseif tab.int_mode == 9 then -- Custom
			-- IN WORK :P
			return ""
		else
			DoCommand(sender, channel, text)
			return ""
		end
	else
		DoCommand(sender, channel, text)

		return ""
		--return channel .. " RPNAME : " .. text
	end
end
