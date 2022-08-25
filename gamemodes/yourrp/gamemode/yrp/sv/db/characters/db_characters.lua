--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_characters"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT 'UNKNOWN'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "roleID", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "groupID", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_idstructure", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_idcardid", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "playermodelID", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "skin", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_birthday", "TEXT DEFAULT '01.01.2000'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_bodyheight", "INT DEFAULT 180" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_weight", "INT DEFAULT 80" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_eventchar", "INT DEFAULT 0" )

--[[ LEVEL ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_level", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_xp", "INT DEFAULT 0" )

for i = 0, 19 do
	YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bg" .. i, "INT DEFAULT 0" )
end

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "storage", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "keynrs", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "rpname", "TEXT DEFAULT 'ID_RPNAME'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "rpdescription", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "money", "TEXT DEFAULT '250'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "moneybank", "TEXT DEFAULT '500'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "position", "TEXT DEFAULT '0,0,0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "angle", "TEXT DEFAULT '0,0,0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "map", "TEXT DEFAULT 'gm_construct'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_warnings", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_violations", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_arrests", "INT DEFAULT 0" )

-- ATTRIBUTES
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_strength", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_agility", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_stamina", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_intellect", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_spirit", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_armor", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_playtime", "TEXT DEFAULT '0'" )

--[[ EQUIPMENT NEW ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_storageID", "TEXT DEFAULT '0'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_archived", "TEXT DEFAULT '0'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "lids", "TEXT DEFAULT ''" )

if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1" ) == nil then
	local _result = YRP_SQL_INSERT_INTO(DATABASE_NAME, "uniqueID", "1" )
end

-- SLOTS
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slot_primary", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slot_secondary", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slot_sidearm", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "slot_gadget", "TEXT DEFAULT ''" )

-- Specs
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_specializations", "TEXT DEFAULT ''" )

function YRPGetSteamIdByCharId( charId )
	if charId then
		local tab = YRP_SQL_SELECT( "yrp_characters", "uniqueID, SteamID", "uniqueID = '" .. charId .. "'" )
		if tab and tab[1] then
			tab = tab[1]

			return tab.SteamID
		end
	end
	return nil
end

function YRPUpdateCharSlot(ply, art, pri)
	local tab = {}
	for i, v in pairs(pri) do
		if !strEmpty( v) and !table.HasValue(tab, v) and #tab < GetGlobalYRPInt( "yrp_max_slots_" .. art, 0) then
			table.insert(tab, v)
		end
	end

	local sweps = table.concat( tab, "," )
	YRP_SQL_UPDATE(DATABASE_NAME, {["slot_" .. art] = sweps}, "uniqueID = '" .. ply:CharID() .. "'" )

	ply:SetYRPString( "slot_" .. art, sweps)
end

function YRPGetCharSWEPS(ply)
	local tab = {}

	local dbtab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. ply:CharID() .. "'" )
	if wk( dbtab) then
		dbtab = dbtab[1]

		tab["slot_primary"] = string.Explode( ",", dbtab.slot_primary)
		tab["slot_secondary"] = string.Explode( ",", dbtab.slot_secondary)
		tab["slot_sidearm"] = string.Explode( ",", dbtab.slot_sidearm)
		tab["slot_gadget"] = string.Explode( ",", dbtab.slot_gadget)

		ply:SetYRPString( "slot_primary", dbtab.slot_primary)
		ply:SetYRPString( "slot_secondary", dbtab.slot_secondary)
		ply:SetYRPString( "slot_sidearm", dbtab.slot_sidearm)
		ply:SetYRPString( "slot_gadget", dbtab.slot_gadget)
	end

	return tab
end

util.AddNetworkString( "yrp_get_sweps_role_art" )
net.Receive( "yrp_get_sweps_role_art", function(len, ply)
	local art = net.ReadString()

	local sweps = {}

	local rolTab = ply:YRPGetRoleTable()
	if wk( rolTab ) then
		for i, v in pairs(string.Explode( ",", rolTab.string_sweps) ) do
			local tab = YRP_SQL_SELECT( "yrp_weapon_slots", "*", "classname = '" .. v .. "'" )
			if wk(tab) then
				tab = tab[1]
				if tobool(tab["slot_" .. art]) then
					table.insert(sweps, v)
				end
			end
		end
	end

	local charid = ply:CharID()
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "string_specializations", "uniqueID = '" .. charid .. "'" )
	if wk(tab) then
		tab = tab[1]

		for i, v in pairs( string.Explode( ",", tab.string_specializations ) ) do
			local tabSpec = YRP_SQL_SELECT( "yrp_specializations", "*", "uniqueID = '" .. v .. "'" )
			if wk(tabSpec) then
				tabSpec = tabSpec[1]
		
				for i, v in pairs( string.Explode( ",", tabSpec.sweps ) ) do
					local tab = YRP_SQL_SELECT( "yrp_weapon_slots", "*", "classname = '" .. v .. "'" )
					if wk(tab) then
						tab = tab[1]
						if tobool(tab["slot_" .. art]) then
							table.insert( sweps, v )
						end
					end
				end
			end
		end
	end

	net.Start( "yrp_get_sweps_role_art" )
		net.WriteTable(sweps)
	net.Send(ply)
end)

function YRPHasWeapon(ply, cname)
	for i, v in pairs(ply:GetWeapons() ) do
		if v:GetClass() == cname then
			return true
		end
	end
	return false
end

util.AddNetworkString( "yrp_slot_swep_add" )
net.Receive( "yrp_slot_swep_add", function(len, ply)
	local art = net.ReadString()
	local cname = net.ReadString()

	local currentsweps = ply:GetYRPString( "slot_" .. art, "" )

	local tab = string.Explode( ",", currentsweps)
	table.insert( tab, cname )

	if !YRPHasWeapon(ply, cname) then
		ply:Give( cname)
		YRPUpdateCharSlot(ply, art, tab)
	end
end)

util.AddNetworkString( "yrp_slot_swep_rem" )
net.Receive( "yrp_slot_swep_rem", function(len, ply)
	local art = net.ReadString()
	local cname = net.ReadString()

	local currentsweps = ply:GetYRPString( "slot_" .. art, "" )
	local tab = string.Explode( ",", currentsweps)
	table.RemoveByValue(tab, cname)

	ply:StripWeapon( cname)

	YRPUpdateCharSlot(ply, art, tab)
end)

function YRPSendCharCount( ply )
	if IsValid( ply ) then
		local count = 0
		local result = YRP_SQL_SELECT( DATABASE_NAME, "*", "SteamID = '" .. ply:YRPSteamID() .. "'" )
		if wk(result) then
			count = table.Count( result )
		end
		ply:SetYRPInt( "char_count", count )
	end
end

local Player = FindMetaTable( "Player" )
function Player:YRPUpdateAppearance()
	local chatab = self:YRPGetCharacterTable()

	if wk( chatab) then
		self:SetYRPInt( "pmid", tonumber( chatab.playermodelID ) )
		self:SetYRPInt( "skin", tonumber( chatab.skin ) )

		for i = 0, 19 do
			self:SetYRPInt( "bg" .. i, chatab["bg" .. i])
		end
	end
end

function Player:YRPCharacterLoadout()
	YRP.msg( "debug", "[CharacterLoadout] " .. self:YRPName() )
	local chatab = self:YRPGetCharacterTable()
	local plytab = self:GetPlyTab()

	self:YRPUpdateAppearance()

	if wk( chatab) then
		self:SetYRPInt( "int_xp", chatab.int_xp)
		self:SetYRPString( "int_level", chatab.int_level)

		self:SetYRPInt( "int_warnings", chatab.int_warnings)
		self:SetYRPInt( "int_violations", chatab.int_violations)
		self:SetYRPInt( "int_arrests", chatab.int_arrests)

		self:SetYRPString( "string_birthday", chatab.string_birthday)
		if GetGlobalYRPBool( "bool_characters_bodyheight", false) then
			self:SetYRPInt( "int_bodyheight", chatab.int_bodyheight)
		end
		if GetGlobalYRPBool( "bool_characters_weight", false) then
			self:SetYRPInt( "int_weight", chatab.int_weight)
		end

		local levelsystem = YRP_SQL_SELECT( "yrp_levelsystem", "*", nil)
		if wk(levelsystem) then
			levelsystem = levelsystem[1]
			self:SetYRPString( "int_xp_for_levelup", levelsystem.int_xp_for_levelup)
			self:SetYRPString( "float_multiplier", levelsystem.float_multiplier)
		end

		self:SetYRPString( "text_playtime", chatab.text_playtime)
	end
end

function Player:VisualEquipment(name, slot)
	if self:HasCharacterSelected() then
		local _charid = self:CharID()
		if wk(_charid) then
			local _uid = YRP_SQL_SELECT( "yrp_characters", slot, "uniqueID = '" .. _charid .. "'" )
			if wk(_uid) then
				_uid = _uid[1][slot]
				if wk(_uid) then
					local _item = YRP_SQL_SELECT( "yrp_items", "*", "storageID = '" .. _uid .. "'" )
					if wk(_item) then
						_item = _item[1]
						local _model = _item.WorldModel

						local _old = self:GetYRPEntity(name)
						if ea(_old) then
							_old:Remove()
						end
						self:SetYRPString(name, _model)
						local _visual = ents.Create( "prop_dynamic" )
						_visual:SetModel(_item.WorldModel)
						_visual:SetOwner(self)
						_visual:SetYRPBool( "isviewmodel", true)
						_visual:Spawn()

						self:SetYRPEntity(name, _visual)
						self:SetYRPString(name .. "ClassName", _item.ClassName)

						local _maxs = _visual:OBBMaxs()
						local _mins = _visual:OBBMins()

						local _x = _maxs.x - _mins.x
						local _y = _maxs.y - _mins.y
						local _z = _maxs.z - _mins.z

						local corax = 0
						local coray = 0
						local coraz = 0
						if _z >= _x and _y >= _x then
							corax = 0
							coray = -90
							coraz = 90
							self:SetYRPString(name .. "thick", _x)
						elseif _x >= _z and _y >= _z then
							corax = 0
							coray = 0
							coraz = 0
							self:SetYRPString(name .. "thick", _z)
						elseif _x >= _y and _z >= _y then
							corax = 90
							coray = 90
							coraz = 90
							self:SetYRPString(name .. "thick", _y)
						end
						self:SetYRPString(name .. "corax", corax)
						self:SetYRPString(name .. "coray", coray)
						self:SetYRPString(name .. "coraz", coraz)
					else
						local _old = self:GetYRPEntity(name)
						if ea(_old) then
							_old:Remove()
							self:SetYRPEntity(name, NULL)
							self:SetYRPString(name .. "ClassName", "" )
						end
					end
					return _item
				end
			end
		end
	end
end

function Player:UpdateBackpack()
	local _bp = self:VisualEquipment( "backpack", "eqbp" ) --, "ValveBiped.Bip01_Spine4", 1.3, Vector(-16, -7, 3.4), Angle(0, -90 -12, -90) )
	return _bp
end

function Player:SetRPName(str, from)
	if isstring(str) then
		str = YRPCleanUpName( str )

		local oldname = self:Nick()
		local newname = str
		YRP_SQL_UPDATE( "yrp_characters", {["rpname"] = newname}, "uniqueID = " .. self:CharID() )

		newname = newname
		self:SetYRPString( "rpname", newname)

		YRP.msg( "note", oldname .. " changed name to " .. newname, true)
	end
end

util.AddNetworkString( "update_backpack" )
net.Receive( "update_backpack", function(len, ply)
	if ea(ply) then
		local _bp = ply:UpdateBackpack()

		if _bp != nil then
			local _uid = _bp.intern_storageID

			local _stor = YRP_SQL_SELECT( "yrp_storages", "*", "uniqueID = '" .. _uid .. "'" )
			if _stor != nil then
				_stor = _stor[1]
				net.Start( "update_backpack" )
					net.WriteBool(true)
					net.WriteTable(_stor)
				net.Send(ply)
				return true
			end
		end

		net.Start( "update_backpack" )
			net.WriteBool(false)
		net.Send(ply)
		return false
	end
end)

util.AddNetworkString( "update_slot_backpack" )
net.Receive( "update_slot_backpack", function(len, ply)
	if ea(ply) then
		local _charid = ply:CharID()
		local _uid = YRP_SQL_SELECT(DATABASE_NAME, "eqbp", "uniqueID = '" .. _charid .. "'" )
		if _uid != nil then
			_uid = _uid[1].eqbp
			local _backpack_storage = YRP_SQL_SELECT( "yrp_storages", "*", "uniqueID = '" .. _uid .. "'" )
			if _backpack_storage == nil then
				_backpack_storage = CreateEquipmentStorage(ply, "eqbp", _charid, 1, 1)
				_backpack_storage = YRP_SQL_SELECT( "yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'" )
			end
			_backpack_storage = _backpack_storage[1]
			net.Start( "update_slot_backpack" )
				net.WriteTable(_backpack_storage)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString( "moneyreset" )
net.Receive( "moneyreset", function(len, ply)
	YRP.msg( "db", "<[MONEY RESET]>" )
	YRP_SQL_UPDATE( "yrp_characters", {["money"] = 0}, nil)
	YRP_SQL_UPDATE( "yrp_characters", {["moneybank"] = 0}, nil)
	for i, pl in pairs(player.GetAll() ) do
		pl:SetMoney(0)
		pl:SetMoneyBank(0)
	end
end)

util.AddNetworkString( "change_rpname" )
net.Receive( "change_rpname", function(len, ply)
	local _new_rp_name = net.ReadString()
	ply:SetRPName(_new_rp_name)
end)

util.AddNetworkString( "change_rpdescription" )
net.Receive( "change_rpdescription", function(len, ply)
	local _new_rp_description = net.ReadString()
	YRP_SQL_UPDATE( "yrp_characters", {["rpdescription"] = _new_rp_description}, "uniqueID = " .. ply:CharID() )
	ply:SetYRPString( "rpdescription", _new_rp_description)
	for i, v in pairs(string.Explode( "\n", _new_rp_description) ) do
		ply:SetYRPString( "rpdescription" .. i, v)
	end
end)

util.AddNetworkString( "change_birthday" )
net.Receive( "change_birthday", function(len, ply)
	local _new_birthday = net.ReadString()
	YRP_SQL_UPDATE( "yrp_characters", {["string_birthday"] = _new_birthday}, "uniqueID = " .. ply:CharID() )
	ply:SetYRPString( "string_birthday", _new_birthday)
end)
util.AddNetworkString( "change_bodyheight" )
net.Receive( "change_bodyheight", function(len, ply)
	local _new_bodyheight = net.ReadString()
	YRP_SQL_UPDATE( "yrp_characters", {["int_bodyheight"] = _new_bodyheight}, "uniqueID = " .. ply:CharID() )
	ply:SetYRPInt( "int_bodyheight", _new_bodyheight)
end)
util.AddNetworkString( "change_weight" )
net.Receive( "change_weight", function(len, ply)
	local _new_weight = net.ReadString()
	YRP_SQL_UPDATE( "yrp_characters", {["int_weight"] = _new_weight}, "uniqueID = " .. ply:CharID() )
	ply:SetYRPInt( "int_weight", _new_weight)
end)

util.AddNetworkString( "yrp_get_characters" )

util.AddNetworkString( "YRPDeleteCharacter" )
util.AddNetworkString( "YRPCreateCharacter" )

function GetPlayermodelsOfRole(ruid)
	local role = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = '" .. tonumber(ruid) .. "'" )
	if wk(role) then
		role = role[1]
		if role.string_playermodels then
			local rpms = string.Explode( ",", role.string_playermodels)
			local tab = {}
			for i, id in pairs(rpms) do
				local tmppms = YRP_SQL_SELECT( "yrp_playermodels", "*", "uniqueID = '" .. id .. "'" )
				if wk(tmppms) then
					tmppms = tmppms[1]
					tmppms = string.Explode( ",", tmppms.string_models)
					for x, pm in pairs(tmppms) do
						for y, xpm in pairs(string.Explode( ",", pm) ) do
							table.insert(tab, xpm)
						end
					end
				end
			end
			return table.concat(tab,"," )
		end
	end
	YRP.msg( "note", "role " .. ruid .. " has no playermodels" )
	return ""
end

function GetPlayermodelsOfCharacter(ply, ruid)
	local rpms = GetPlayermodelsOfRole(ruid)
	local spms = YRPGetSpecData(ply)

	local pms = {}
	for i, v in pairs( string.Explode( ",", rpms ) ) do
		if !strEmpty( v) and !table.HasValue(pms, v) then
			table.insert(pms, v)
		end
	end
	for i, v in pairs( string.Explode( ",", spms.pms ) ) do
		if !strEmpty( v) and !table.HasValue(pms, v) then
			table.insert(pms, v)
		end
	end

	return table.concat(pms, "," )
end

function GetPMTableOfRole(ruid)
	local role = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = '" .. tonumber(ruid) .. "'" )
	if wk(role) then
		role = role[1]
		local rpms = string.Explode( ",", role.string_playermodels)
		local tab = {}
		for i, id in pairs(rpms) do
			local tmppms = YRP_SQL_SELECT( "yrp_playermodels", "*", "uniqueID = '" .. id .. "'" )
			if wk(tmppms) then
				tmppms = tmppms[1]
				for x, pm in pairs(string.Explode( ",", tmppms.string_models) ) do
					for y, xpm in pairs(string.Explode( ",", pm) ) do
						local entry = {}
						entry.float_size_min = tmppms.float_size_min
						entry.float_size_max = tmppms.float_size_max
						entry.string_model = xpm
						table.insert(tab, entry)
					end
				end
			end
		end
		return tab
	else
		YRP.msg( "note", "role " .. ruid .. " has no playermodels" )
		return {}
	end
end

function GetPMsOfCharacter(ply, ruid)
	local rpms = GetPMTableOfRole(ruid)
	local spms = YRPGetSpecData(ply)

	for i, v in pairs( string.Explode( ",", spms.pms ) ) do
		local entry = {}
		entry.float_size_min = 1
		entry.float_size_max = 1
		entry.string_model = v
		table.insert(rpms, entry)
	end

	return rpms
end

util.AddNetworkString( "yrp_received_chars" )
net.Receive( "yrp_received_chars", function( len , ply )
	MsgC( YRPColGreen(), "Player Received Charlist", "\n")
	ply.receivedchars = true
end )

--[[ Server Send Characters to Client ]]--
function SendLoopCharacterList(ply, tab)
	if ply:IsBot() then
		return
	end
	ply:SetupCharID()

	local c = 1
	for i, char in pairs( tab ) do
		char.c = c
		timer.Simple( char.c * 0.25, function()
			if IsValid( ply ) and tab and char then
				local last = false
				local first = false
				if char.c == 1 then
					first = true
				end
				if char.c == table.Count(tab) then
					last = true
				end

				net.Start( "yrp_get_characters" )
					net.WriteBool( first )
					net.WriteTable( char ) // TODO WriteTable get rid off
					net.WriteBool( last )
				net.Send( ply )
				if last then
					net.Start( "yrp_received_chars" )
					net.Send( ply )
					--YRP.msg( "note", "Player Send Charlist: " .. tostring( char.c ) .. "/" .. tostring( #tab ) )
							
					timer.Simple( 10, function()
						if IsValid( ply ) and ply.receivedchars == nil then
							YRP.msg( "note", "[" .. ply:SteamName() .. "] not Received Charlist, retry: " .. tostring( char.c ) .. "/" .. tostring( #tab ) )
							SendLoopCharacterList( ply, tab )
						end
					end )
				end
			else
				if not tab then
					YRP.msg( "error", "[SendLoopCharacterList] tab is invalid: " .. tostring( tab ) )
				end
				if not char then
					YRP.msg( "error", "[SendLoopCharacterList] char is invalid: " .. tostring( char ) )
				end
			end
		end )
		c = c + 1
	end
end

util.AddNetworkString( "OpenCharacterCreation" )
function YRPSendCharacters(ply, from)
	if ply:IsBot() then
		return
	end

	YRPSendCharCount(ply)

	local netTable = {}

	local chaTab = YRP_SQL_SELECT( "yrp_characters", "*", "SteamID = '" .. ply:YRPSteamID() .. "'" )

	local _charCount = 0
	if wk( chaTab) then
		for k, v in pairs( chaTab) do
			if v.roleID != nil and v.groupID != nil then
				_charCount = _charCount + 1
				netTable[_charCount] = {}
				v.rpname = v.rpname
				netTable[_charCount].char = v

				netTable[_charCount].role = {}
				netTable[_charCount].group = {}
				netTable[_charCount].group.string_name = "INVALID GROUP"

				netTable[_charCount].faction = {}
				netTable[_charCount].faction.string_name = "INVALID FACTION"
				netTable[_charCount].faction.string_icon = ""

				local tmp = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tonumber( v.roleID) )
				if worked(tmp, "charGetCharacters role" ) then
					tmp = tmp[1]
					netTable[_charCount].role = tmp
				else
					local tmpDefault = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. "1" )
					if worked(tmpDefault, "charGetCharacters tmpDefault" ) then
						tmpDefault = tmpDefault[1]
						netTable[_charCount].role = tmpDefault
					end
					v.roleID = 1
				end

				netTable[_charCount].role.string_playermodels = GetPlayermodelsOfRole( v.roleID)

				local tmp2 = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = '" .. tonumber( v.roleID) .. "'" )
				if tmp2 != nil and tmp2 != false then
					tmp2 = tmp2[1]
					local tmp3 = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. tonumber(tmp2.int_groupID) .. "'" )
					if worked(tmp3, "charGetCharacters group" ) then
						tmp3 = tmp3[1]
						netTable[_charCount].group = tmp3
						netTable[_charCount].faction = GetFactionTable(tmp3.uniqueID)
					end
				end
			else
				YRP.msg( "note", "[YRPSendCharacters] roleid != nil or groupid != nil" )
			end
		end

		if ply.receivedchars then
			ply.receivedchars = nil
		end
		SendLoopCharacterList( ply, netTable )
	else
		net.Start( "OpenCharacterCreation" )
		net.Send(ply)
	end
end

--[[ Client ask for Characters ]]--
net.Receive( "yrp_get_characters", function(len, ply)
	--YRP.msg( "db", ply:YRPName() .. " ask for characters" )
	if ply:IsBot() then
		return
	end

	YRPSendCharacters( ply, "yrp_get_characters" )

	if !ply:Alive() then
		ply:SetYRPBool( "yrp_characterselection", true )
	end
end)

net.Receive( "YRPDeleteCharacter", function(len, ply)
	local charID = net.ReadString()

	if wk( charID) then
		local result = YRP_SQL_DELETE_FROM( "yrp_characters", "uniqueID = '" .. tonumber( charID) .. "'" )
		if result == nil then
			YRP.msg( "db", "DeleteCharacter: success"	)
			ply:OldKillSilent()
			local steamid = ply:YRPSteamID()
			if wk(steamid) then
				local _first_character = YRP_SQL_SELECT( "yrp_characters", "*", "SteamID = '" .. steamid .. "'" )
				if _first_character != nil then
					_first_character = _first_character[1]
					YRP_SQL_UPDATE( "yrp_players", {["CurrentCharacter"] = tonumber(_first_character.uniqueID)}, "SteamID = '" .. steamid .. "'" )
					YRP_SQL_SELECT( "yrp_players", "*", nil)
				end
			else
				YRP.msg( "error", "STEAMID FAILED => " .. tostring(steamid) .. " [" .. tostring(ply) .. "]" )
			end

			ply:Spawn()
		else
			YRP.msg( "note", "DeleteCharacter: fail" )
		end
		YRPSendCharacters( ply, "YRPDeleteCharacter" )
	end
end)

function YRPCreateCharacter( ply, tab )
	if tab then
		local role = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tonumber( tab.roleID ) )
		if wk(role) then
			local steamid = ply:YRPSteamID()
			local cols = "SteamID, rpname, roleID, groupID, playermodelID, money, moneybank, map, skin, rpdescription, string_birthday, int_bodyheight, int_weight, bool_eventchar"
			for i = 0, 19 do
				cols = cols .. ", bg" .. i
			end
			local vals = "'" .. steamid .. "', "
			vals = vals .. "" .. YRP_SQL_STR_IN( YRPCleanUpName( tab.rpname ) ) .. ", "
			vals = vals .. tonumber(role[1].uniqueID) .. ", "
			vals = vals .. tonumber(role[1].int_groupID) .. ", "
			vals = vals .. tonumber(tab.playermodelID) .. ", "
			vals = vals .. GetGlobalYRPString( "text_characters_money_start", 0) .. ", "
			vals = vals .. 0 .. ", "
			vals = vals .. "'" .. GetMapNameDB() .. "', "
			vals = vals .. tonumber(tab.skin) .. ", "
			vals = vals .. "" .. YRP_SQL_STR_IN( tostring(tab.rpdescription) ) .. ", "
			
			vals = vals .. "" .. YRP_SQL_STR_IN( tostring(tab.birt) ) .. ", "
			vals = vals .. "" .. YRP_SQL_STR_IN( tostring(tab.bohe) ) .. ", "
			vals = vals .. "" .. YRP_SQL_STR_IN( tostring(tab.weig) ) .. ", "
			vals = vals .. "'" .. btn(tab.create_eventchar) .. "'"

			for i = 0, 19 do
				vals = vals .. ", " .. tonumber(tab.bg[i])
			end
			local char = YRP_SQL_INSERT_INTO( "yrp_characters", cols, vals)
			if char == nil then
				local chars = YRP_SQL_SELECT( "yrp_characters", "*", nil)
				if worked( chars, "[YRPCreateCharacter] chars" ) then
					local charid = tonumber( chars[#chars].uniqueID )
					local result = YRP_SQL_UPDATE( "yrp_players", {["CurrentCharacter"] = charid}, "SteamID = '" .. ply:YRPSteamID() .. "'" )
					if result != nil then
						YRP.msg( "error", "[YRPCreateCharacter] failed @Update!" )
						return false
					else
						YRPSendCharacters( ply, "YRPCreateCharacter" )
						return charid
					end
				else
					YRP.msg( "note", "[YRPCreateCharacter] chars failed: " .. tostring( chars) )
					return false
				end
			else
				YRP.msg( "error", "[YRPCreateCharacter] failed - char: " .. tostring( char) .. " LastError: " .. YRP_SQL_Show_Last_Error() )
				return false
			end
		else
			YRP.msg( "note", "[YRPCreateCharacter] role not found!" )
			return false
		end
		YRPCreateCharacterStorages()
	end
	return false
end

net.Receive( "YRPCreateCharacter", function(len, ply)
	local tab = net.ReadTable()

	if tab.rpname == nil then
		YRP.msg( "note", "[YRPCreateCharacter] FAILED, RPNAME is INVALID!" )

		net.Start( "YRPCreateCharacter" )
			net.WriteBool(false)
			net.WriteBool(true)
		net.Send(ply)
		return
	end

	local namealreadyinuse = false

	local allchars = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	for i, v in pairs( allchars) do
		if string.lower( v.rpname) == string.lower(tab.rpname) then
			namealreadyinuse = true
		end
	end
	
	if namealreadyinuse then
		net.Start( "YRPCreateCharacter" )
			net.WriteBool(false)
			net.WriteBool(false)
		net.Send(ply)
	else
		YRPCreateCharacter(ply, tab)
		net.Start( "YRPCreateCharacter" )
			net.WriteBool(true)
			net.WriteBool(false)
		net.Send(ply)
	end
end)

util.AddNetworkString( "YRP_LogOut" )
net.Receive( "YRP_LogOut", function(len, ply)
	ply:SetYRPBool( "yrp_reset_charloadout", true )

	ply:OldKillSilent()
	if ply:Alive() then
		ply:Kill()
	end

	timer.Simple(0.1, function()
		if IsValid( ply ) then
			net.Start( "YRP_LogOut" )
			net.Send( ply )
		end
	end )
end)

util.AddNetworkString( "YRPResetCharLoadout" )
net.Receive( "YRPResetCharLoadout", function(len, ply)
	ply:SetYRPBool( "yrp_reset_charloadout", true )
end )

util.AddNetworkString( "YRP_EnterWorld" )
net.Receive( "YRP_EnterWorld", function(len, ply)
	local cuid = net.ReadString()

	if ply:Alive() then
		ply:OldKillSilent()
	end
	
	YRPSpawnAsCharacter(ply, cuid, false)
end)

function SendBodyGroups(ply)
	local charid = ply:CharID()
	if wk( charid) then
		local _result = YRP_SQL_SELECT( "yrp_characters", "bg0, bg1, bg2, bg3, bg4, bg5, bg6, bg7, skin, playermodelID", "uniqueID = " .. tonumber( charid) )

		if wk(_result) then
			_result = _result[1]
			local _role = ply:YRPGetRoleTable()
			if wk(_role) then
				local ruid = _role.uniqueID
				_result.string_playermodels = GetPlayermodelsOfCharacter(ply, ruid)

				if _result.string_playermodels != "" then
					net.Start( "get_menu_bodygroups" )
						net.WriteTable(_result)
					net.Send(ply)
				else
					net.Start( "get_menu_bodygroups" )
						net.WriteTable({})
					net.Send(ply)
				end
			end
		else
			YRP.msg( "note", "get_menu_bodygroups failed!" )
		end
	end
end

util.AddNetworkString( "get_menu_bodygroups" )
net.Receive( "get_menu_bodygroups", function(len, ply)
	SendBodyGroups(ply)
end)

util.AddNetworkString( "inv_bg_up" )

net.Receive( "inv_bg_up", function(len, ply)
	local _cur = net.ReadInt(16)
	local _id = net.ReadInt(16)

	ply:SetBodygroup(_id, _cur)
	local _charid = ply:CharID()
	YRP_SQL_UPDATE( "yrp_characters", {["bg" .. tonumber(_id)] = tonumber(_cur)}, "uniqueID = " .. tonumber(_charid) )
end)

util.AddNetworkString( "inv_bg_do" )

net.Receive( "inv_bg_do", function(len, ply)
	local _cur = net.ReadInt(16)
	local _id = net.ReadInt(16)

	ply:SetBodygroup(_id, _cur)
	local _charid = ply:CharID()
	YRP_SQL_UPDATE( "yrp_characters", {["bg" .. tonumber(_id)] = tonumber(_cur)}, "uniqueID = " .. tonumber(_charid) )
end)

util.AddNetworkString( "inv_skin_up" )

net.Receive( "inv_skin_up", function(len, ply)
	local _cur = net.ReadInt(16)
	ply:SetSkin(_cur)
	ply:SetupHands()
	local _charid = ply:CharID()
	YRP_SQL_UPDATE( "yrp_characters", {["skin"] = tonumber(_cur)}, "uniqueID = " .. tonumber(_charid) )
end)

util.AddNetworkString( "inv_skin_do" )

net.Receive( "inv_skin_do", function(len, ply)
	local _cur = net.ReadInt(16)
	ply:SetSkin(_cur)
	ply:SetupHands()
	local _charid = ply:CharID()
	YRP_SQL_UPDATE( "yrp_characters", {["skin"] = tonumber(_cur)}, "uniqueID = " .. tonumber(_charid) )
end)

util.AddNetworkString( "inv_pm_up" )
net.Receive( "inv_pm_up", function(len, ply)
	local _cur = net.ReadInt(16)
	local _pms = string.Explode( ",", GetPlayermodelsOfCharacter( ply, ply:YRPGetRoleTable().uniqueID ) )
	if wk(_pms) then
		if wk(_pms[_cur]) then
			ply:SetYRPString( "string_playermodel", _pms[_cur])
			ply:SetYRPInt( "pmid", _cur)
			ply:SetModel(_pms[_cur])
			local _charid = ply:CharID()
			YRP_SQL_UPDATE( "yrp_characters", {["playermodelID"] = tonumber(_cur)}, "uniqueID = " .. tonumber(_charid) )
			ply:UpdateBackpack()
			SendBodyGroups(ply)
		end
	end
end)

util.AddNetworkString( "inv_pm_do" )
net.Receive( "inv_pm_do", function(len, ply)
	local _cur = net.ReadInt(16)
	local _pms = string.Explode( ",", GetPlayermodelsOfCharacter( ply, ply:YRPGetRoleTable().uniqueID ) )
	if wk(_pms) then
		if wk(_pms[_cur]) then
			ply:SetYRPString( "string_playermodel", _pms[_cur])
			ply:SetYRPInt( "pmid", _cur)
			ply:SetModel(_pms[_cur])
			local _charid = ply:CharID()
			YRP_SQL_UPDATE( "yrp_characters", {["playermodelID"] = tonumber(_cur)}, "uniqueID = " .. tonumber(_charid) )
			ply:UpdateBackpack()
			SendBodyGroups(ply)
		end
	end
end)

util.AddNetworkString( "warning_up" )
net.Receive( "warning_up", function(len, ply)
	local p = net.ReadEntity()
	if IsValid( p ) then
		local ptab = YRP_SQL_SELECT(DATABASE_NAME, "int_warnings", "uniqueID = '" .. p:CharID() .. "'" )
		if wk(ptab) then
			local int_warnings = ptab[1].int_warnings
			int_warnings = int_warnings + 1
			int_warnings = math.Clamp(int_warnings, 0, 10)

			YRP_SQL_UPDATE(DATABASE_NAME, {["int_warnings"] = int_warnings}, "uniqueID = '" .. p:CharID() .. "'" )

			p:SetYRPInt( "int_warnings", int_warnings)
		end
	end
end)

util.AddNetworkString( "warning_dn" )
net.Receive( "warning_dn", function(len, ply)
	local p = net.ReadEntity()
	if IsValid( p ) then
		local ptab = YRP_SQL_SELECT(DATABASE_NAME, "int_warnings", "uniqueID = '" .. p:CharID() .. "'" )
		if wk(ptab) then
			local int_warnings = ptab[1].int_warnings
			int_warnings = int_warnings - 1
			int_warnings = math.Clamp(int_warnings, 0, 10)

			YRP_SQL_UPDATE(DATABASE_NAME, {["int_warnings"] = int_warnings}, "uniqueID = '" .. p:CharID() .. "'" )

			p:SetYRPInt( "int_warnings", int_warnings)
		end
	end
end)

util.AddNetworkString( "violation_up" )
net.Receive( "violation_up", function(len, ply)
	local p = net.ReadEntity()
	if IsValid( p ) then
		local ptab = YRP_SQL_SELECT(DATABASE_NAME, "int_violations", "uniqueID = '" .. p:CharID() .. "'" )
		if wk(ptab) then
			local int_violations = ptab[1].int_violations
			int_violations = int_violations + 1
			int_violations = math.Clamp(int_violations, 0, 10)

			YRP_SQL_UPDATE(DATABASE_NAME, {["int_violations"] = int_violations}, "uniqueID = '" .. p:CharID() .. "'" )

			p:SetYRPInt( "int_violations", int_violations)
		end
	end
end)

util.AddNetworkString( "violation_dn" )
net.Receive( "violation_dn", function(len, ply)
	local p = net.ReadEntity()
	if IsValid( p ) then
		local ptab = YRP_SQL_SELECT(DATABASE_NAME, "int_violations", "uniqueID = '" .. p:CharID() .. "'" )
		if wk(ptab) then
			local int_violations = ptab[1].int_violations
			int_violations = int_violations - 1
			int_violations = math.Clamp(int_violations, 0, 10)

			YRP_SQL_UPDATE(DATABASE_NAME, {["int_violations"] = int_violations}, "uniqueID = '" .. p:CharID() .. "'" )

			p:SetYRPInt( "int_violations", int_violations)
		end
	end
end)

util.AddNetworkString( "set_rpname" )
net.Receive( "set_rpname", function(len, ply)
	local p = net.ReadEntity()
	if IsValid( p ) then
		local rpname = net.ReadString()

		rpname = YRPCleanUpName( rpname )

		p:SetRPName(rpname, "set_rpname" )
	end
end)

util.AddNetworkString( "set_idcardid" )
net.Receive( "set_idcardid", function(len, ply)
	local p = net.ReadEntity()
	if IsValid( p ) then
		local text_idcardid = net.ReadString()
		if wk(p:CharID() ) then
			local ptab = YRP_SQL_SELECT(DATABASE_NAME, "text_idcardid", "uniqueID = '" .. p:CharID() .. "'" )
			if wk(ptab) then
				YRP_SQL_UPDATE(DATABASE_NAME, {["text_idcardid"] = text_idcardid}, "uniqueID = '" .. p:CharID() .. "'" )
				p:SetYRPString( "idcardid", text_idcardid)
			end
		end
	end
end)

util.AddNetworkString( "removearrests" )
net.Receive( "removearrests", function(len, ply)
	local p = net.ReadEntity()
	if IsValid(p) and p:IsPlayer() and p.CharID and wk(p:CharID() ) then
		YRP_SQL_UPDATE(DATABASE_NAME, {["int_arrests"] = 0}, "uniqueID = '" .. p:CharID() .. "'" )
		p:SetYRPInt( "int_arrests", 0)
	end
end)

util.AddNetworkString( "get_licenses_player" )
net.Receive( "get_licenses_player", function(len, ply)
	local tab = YRP_SQL_SELECT( "yrp_licenses", "*", nil)
	if wk(tab) then
		net.Start( "get_licenses_player" )
			net.WriteTable(tab)
		net.Send(ply)
	end
end)

util.AddNetworkString( "givelicense" )
net.Receive( "givelicense", function(len, ply)
	if ply:HasAccess() then
		local target = net.ReadEntity()
		local uid = tonumber(net.ReadString() )
		if target and uid and uid > 0 then
			GiveLicense( target, uid )
		end
	end
end)

util.AddNetworkString( "removelicense" )
net.Receive( "removelicense", function(len, ply)
	if ply:HasAccess() then
		local target = net.ReadEntity()
		local uid = tonumber(net.ReadString() )
		if uid and uid > 0 then
			RemoveLicense(target, uid)
		end
	end
end)

function YRPSetAllCharsToDefaultRole(ply)
	if IsValid(ply) and GetGlobalYRPBool( "bool_players_start_with_default_role", false) then
		YRP_SQL_UPDATE(DATABASE_NAME, {["roleID"] = 1}, "SteamID = '" .. ply:YRPSteamID() .. "'" )

		YRP.msg( "note", "SET PLAYER TO DEFAULT ROLE -> players_start_with_default_role: enabled" )
	end
end

util.AddNetworkString( "setting_characters" )
net.Receive( "setting_characters", function(len, ply)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "SteamID, rpname, text_idcardid, rpdescription, groupID, roleID, money, moneybank, int_level, bool_eventchar, bool_archived", nil)
	if !wk(tab) then
		tab = {}
	end
	for i, chartab in pairs( tab ) do
		net.Start( "setting_characters" )
			net.WriteTable( chartab )
		net.Send(ply)
	end
end)

function YRPGetSpecData(ply)
	local charid = ply:CharID()
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "string_specializations", "uniqueID = '" .. charid .. "'" )
	
	local prefix = {}
	local suffix = {}

	local pms = {}

	if wk(tab) then
		tab = tab[1]

		ply:SetYRPString( "specializationIDs", tab.string_specializations )

		for i, v in pairs( string.Explode( ",", tab.string_specializations ) ) do
			local tabSpec = YRP_SQL_SELECT( "yrp_specializations", "*", "uniqueID = '" .. v .. "'" )
			if wk(tabSpec) then
				tabSpec = tabSpec[1]
		
				for i, v in pairs( string.Explode( ",", tabSpec.sweps ) ) do
					ply:Give( v)
				end

				if !strEmpty( tabSpec.pms ) then
					table.insert( pms, tabSpec.pms )
				end

				if !strEmpty(tabSpec.prefix) then
					table.insert( prefix, tabSpec.prefix )
				end
				if !strEmpty(tabSpec.suffix) then
					table.insert( suffix, tabSpec.suffix )
				end
			end
		end
	end

	pms = table.concat( pms, "," )

	prefix = table.concat( prefix, " " )
	suffix = table.concat( suffix, " " )

	local tab = {}
	tab.prefix = prefix
	tab.suffix = suffix
	tab.pms = pms

	return tab
end

function YRPGiveSpecs( ply )
	local tab = YRPGetSpecData( ply )

	ply:SetYRPString( "spec_prefix", tab.prefix )
	ply:SetYRPString( "spec_suffix", tab.suffix )

	ply:SetYRPString( "spec_pms", tab.pms )
end

util.AddNetworkString( "yrp_reopen_givespec" )

util.AddNetworkString( "char_add_spec" )
net.Receive( "char_add_spec", function(len, ply)
	local charid = net.ReadString()
	local specid = net.ReadString()
	local ruid = net.ReadString()

	charid = tonumber(charid)

	local newspecs = {}

	local tab = YRP_SQL_SELECT(DATABASE_NAME, "string_specializations", "uniqueID = '" .. charid .. "'" )
	if wk(tab) then
		tab = tab[1]
		for i, v in pairs( string.Explode( ",", tab.string_specializations ) ) do
			if !table.HasValue(newspecs, v) and !strEmpty( v) then
				table.insert(newspecs, v)
			end
		end
	end

	if !table.HasValue(newspecs, specid) and !strEmpty(specid) then
		table.insert(newspecs, specid)
	end
	newspecs = table.concat( newspecs, "," )

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_specializations"] = newspecs}, "uniqueID = '" .. charid .. "'" )

	local target = YRPGetPlayerByCharID( charid )
	if IsValid( target ) then
		YRPGiveSpecs( target )
	end

	timer.Simple( 0.1, function()
		if ply and charid then
			net.Start( "yrp_reopen_givespec" )
				net.WriteString( charid)
				net.WriteString(ruid)
			net.Send(ply)
		end
	end )
end)

util.AddNetworkString( "char_rem_spec" )
net.Receive( "char_rem_spec", function(len, ply)
	local charid = net.ReadString()
	local specid = net.ReadString()
	local ruid = net.ReadString()

	charid = tonumber(charid)

	local newspecs = {}

	local tab = YRP_SQL_SELECT(DATABASE_NAME, "string_specializations", "uniqueID = '" .. charid .. "'" )
	if wk(tab) then
		tab = tab[1]
		for i, v in pairs( string.Explode( ",", tab.string_specializations ) ) do
			if !table.HasValue(newspecs, v) and !strEmpty( v) then
				table.insert(newspecs, v)
			end
		end
	end

	if table.HasValue(newspecs, specid) and !strEmpty(specid) then
		table.RemoveByValue(newspecs, specid)
	end
	newspecs = table.concat( newspecs, "," )

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_specializations"] = newspecs}, "uniqueID = '" .. charid .. "'" )
	
	local target = YRPGetPlayerByCharID( charid )
	if IsValid( target ) then
		YRPGiveSpecs(target)
	end

	timer.Simple( 0.1, function()
		if ply and charid then
			net.Start( "yrp_reopen_givespec" )
				net.WriteString( charid)
				net.WriteString(ruid)
			net.Send(ply)
		end
	end )
end)
