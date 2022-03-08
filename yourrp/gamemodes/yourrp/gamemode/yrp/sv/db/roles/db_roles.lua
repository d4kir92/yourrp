--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_ply_roles"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'NewRole'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_identifier", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_idstructure", "TEXT DEFAULT '!D!D!D!D-!D!D!D!D-!D!D!D!D'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT 'http://www.famfamfam.com/lab/icons/silk/icons/user.png'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_description", "TEXT DEFAULT '-'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_playermodels", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_salary", "INTEGER DEFAULT 50" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_groupID", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_ammos", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps_onspawn", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_ndsweps", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_ammunation", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_voteable", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_eventrole", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_adminonly", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_maxamount", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_amountpercentage", "INTEGER DEFAULT 100" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_hp", "INTEGER DEFAULT 100" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_hpmax", "INTEGER DEFAULT 100" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_hpup", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_ar", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_armax", "INTEGER DEFAULT 100" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_arup", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_st", "INTEGER DEFAULT 50" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_stmax", "INTEGER DEFAULT 100" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_stup", "TEXT DEFAULT '1'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_stdn", "TEXT DEFAULT '0.5'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_namelength", "INTEGER DEFAULT 20" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_hunger", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_thirst", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_stamina", "INTEGER DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_ability", "TEXT DEFAULT 'none'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_ab", "INTEGER DEFAULT 100" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_abmax", "INTEGER DEFAULT 100" )
--YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_abup", "TEXT DEFAULT '5'" )
--YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_abdn", "TEXT DEFAULT '5'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_speedwalk", "INTEGER DEFAULT 160" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_speedrun", "INTEGER DEFAULT 240" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_powerjump", "INTEGER DEFAULT 200" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_prerole", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_roleondeath", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_instructor", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_uses", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_salarytime", "INTEGER DEFAULT 120" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_securitylevel", "INTEGER DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_canbeagent", "INTEGER DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible_cc", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible_rm", "INTEGER DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_licenses", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_specializations", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_customflags", "TEXT DEFAULT ''" )

--YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_cooldown", "INTEGER DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INTEGER DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_dmgtype_burn", "TEXT DEFAULT '1.0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_dmgtype_bullet", "TEXT DEFAULT '1.0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_dmgtype_energybeam", "TEXT DEFAULT '1.0'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_hud", "TEXT DEFAULT 'serverdefault'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_hud_mask", "TEXT DEFAULT 'serverdefault'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_savebodygroups", "INTEGER DEFAULT 1" )

if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1" ) == nil then
	YRP.msg( "note", DATABASE_NAME .. " has not the default role" )
	local _result = YRP_SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_groupID, bool_removeable", "'1', 'Civilian', '0,0,255', '1', '0'" )
else
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_color"] = "0,0,0"}, "uniqueID = '1'" )
end

YRP_SQL_UPDATE(DATABASE_NAME, {["int_uses"] = 0}, nil)

function MoveUnusedGroups()
	local count = 0
	local all_groups = YRP_SQL_SELECT( "yrp_ply_groups", "*", nil)
	for i, group in pairs( all_groups) do
		group.int_parentgroup = tonumber(group.int_parentgroup)
		if group.int_parentgroup > 0 then
			local parentgroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'" )
			if parentgroup == nil then
				count = count + 1
				YRP.msg( "note", "Group is out of space: " .. group.string_name)
				YRP_SQL_UPDATE( "yrp_ply_groups", {["int_parentgroup"] = 1}, "uniqueID = '" .. group.uniqueID .. "'" )
			elseif group.uniqueID == parentgroup[1].int_parentgroup then
				YRP.msg( "note", "YOU MADE A LOOP IN PARENTGROUP!!!" )
				YRP_SQL_UPDATE( "yrp_ply_groups", {["int_parentgroup"] = 1}, "uniqueID = '" .. parentgroup[1].uniqueID .. "'" )
			end
		end
	end
	if count > 0 then
		MoveUnusedGroups()
	end
end

function MoveUnusedRolesToDefault()
	local changed = false
	local allroles = YRP_SQL_SELECT( "yrp_ply_roles", "uniqueID, string_name, int_prerole, int_groupID", nil)
	if wk( allroles) then
		for i, role in pairs( allroles) do
			-- If prerole not exists remove the prerole
			if tonumber(role.int_prerole) != 0 then
				local prerole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = '" .. role.int_prerole .. "'" )
				if !wk(prerole) then
					changed = true
					YRP_SQL_UPDATE(DATABASE_NAME, {["int_prerole"] = 0}, "uniqueID = '" .. role.uniqueID .. "'" )
				elseif role.uniqueID == prerole[1].int_prerole then
					YRP.msg( "note", "YOU MADE A LOOP in PREROLES!!!" )
					YRP_SQL_UPDATE(DATABASE_NAME, {["int_prerole"] = 0}, "uniqueID = '" .. prerole[1].uniqueID .. "'" )
				end
			end

			MoveUnusedGroups()
			-- if group not exists move it to default group
			local group = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. role.int_groupID .. "'" )
			if !wk(group) then
				changed = true
				YRP_SQL_UPDATE(DATABASE_NAME, {
					["int_groupID"] = 1,
					["int_prerole"] = 0
				},"uniqueID = '" .. role.uniqueID .. "'" )
			end
		end
	end
	if changed then
		YRP.msg( "note", "Moved unused roles to the default group" )
	end
end
MoveUnusedRolesToDefault()



-- CONVERTING
local wrongprerole = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '-1'" )
if wk(wrongprerole) then
	for i, role in pairs(wrongprerole) do
		YRP_SQL_UPDATE(DATABASE_NAME, {["int_prerole"] = 0}, "uniqueID = '" .. role.uniqueID .. "'" )
	end
end

local wrongmaxamount = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_maxamount = -1" )
if wk(wrongmaxamount) then
	for i, role in pairs(wrongmaxamount) do
		YRP_SQL_UPDATE(DATABASE_NAME, {["int_maxamount"] = 0}, "uniqueID = '" .. role.uniqueID .. "'" )
	end
end

local wrongpercentage = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_amountpercentage > 100" )
if wk(wrongpercentage) then
	for i, role in pairs(wrongpercentage) do
		YRP_SQL_UPDATE(DATABASE_NAME, {["int_amountpercentage"] = 100}, "uniqueID = '" .. role.uniqueID .. "'" )
	end
end

local wrongmainrole = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'" )
if wk(wrongmainrole) then
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_usergroups"] = "ALL"}, "uniqueID = '1'" )
	YRP_SQL_UPDATE(DATABASE_NAME, {["int_maxamount"] = 0}, "uniqueID = '1'" )
	YRP_SQL_UPDATE(DATABASE_NAME, {["int_amountpercentage"] = 100}, "uniqueID = '1'" )
	YRP_SQL_UPDATE(DATABASE_NAME, {["int_groupID"] = 1}, "uniqueID = '1'" )
	YRP_SQL_UPDATE(DATABASE_NAME, {["int_prerole"] = 0}, "uniqueID = '1'" )
	--YRP_SQL_UPDATE(DATABASE_NAME, {["bool_visible_rm"] = 1}, "uniqueID = '1'" )
	--YRP_SQL_UPDATE(DATABASE_NAME, {["bool_visible_cc"] = 1}, "uniqueID = '1'" )
	YRP_SQL_UPDATE(DATABASE_NAME, {["bool_locked"] = 0}, "uniqueID = '1'" )
	YRP_SQL_UPDATE(DATABASE_NAME, {["bool_whitelist"] = 0}, "uniqueID = '1'" )
end
-- CONVERTING

-- darkrp
jobByCmd = jobByCmd or {}

function YRPConvertToDarkRPJob(tab)
	local _job = YRPMakeJobTable( tonumber( tab.uniqueID ) )

	_job.team = tonumber(tab.uniqueID)
	
	_job.name = tab.string_name
	_job.identifier = tab.string_identifier
	local pms = GetPlayermodelsOfRole(tab.uniqueID)
	if string.find( pms, "," ) then
		pms = string.Explode( ",", pms )
	end
	if type(pms) == "string" and strEmpty(pms) then
		pms = { "models/player/skeleton.mdl" }
	elseif type(pms) == "string" then
		pms = { pms }
	end
	_job.model = pms
	_job.description = tab.string_description or ""
	local _weapons = {}
	if tab.string_sweps then
		_weapons = string.Explode( ",", tab.string_sweps )
	end
	_job.weapons = _weapons
	_job.max = tonumber(tab.int_maxamount)
	_job.salary = tonumber(tab.int_salary)
	_job.admin = tonumber(tab.bool_adminonly) or 0
	_job.vote = tobool(tab.bool_voteable)
	if tab.string_licenses != "" then
		_job.hasLicense = true
	else
		_job.hasLicense = false
	end
	_job.candemote = tobool(tab.bool_instructor) or false
	local gname = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. tab.int_groupID .. "'" )
	if wk(gname) then
		gname = gname[1].string_name
	end
	_job.category = gname or "invalid group"
	_job.command = YRPConvertToDarkRPJobName(tab.string_name)
	if !strEmpty( tab.string_identifier ) then
		_job.command = tab.string_identifier
	end
	--_job.RequiresVote = function() end

	-- YRP
	if tab.string_color then
		_job.color = string.Explode( ",", tab.string_color )
		if _job.color[1] and _job.color[2] and _job.color[3] then
			_job.color = Color(_job.color[1], _job.color[2], _job.color[3], _job.color[4] or 255)
		else
			YRP.msg( "error", "[ConvertToDarkRPJob] color FAIL: " .. tostring(tab.string_color) )
			YRPRepairSQLDB(true)
		end
	else
		_job.color = Color( 0, 0, 0, 255)
	end
	_job.uniqueID = tonumber(tab.uniqueID)
	_job.int_groupID = tab.int_groupID

	_job.fake = false

	return _job
end

local TEAMS = {}
function YRPBuildDarkrpTeams()
	local drp_allroles = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk( drp_allroles) then
		for i, role in pairs( drp_allroles) do
			local teamname = YRPConvertToDarkRPJobName(role.string_name)
			if !strEmpty( role.string_identifier ) then
				teamname = role.string_identifier
			end
			local darkrpjob = YRPConvertToDarkRPJob(role)
			local darkrpjobuid = darkrpjob.team
			TEAMS[teamname] = darkrpjob
			_G[string.upper(teamname)] = tonumber(role.uniqueID) --TEAMS["TEAM_" .. role.string_name]
			RPExtraTeams[darkrpjobuid] = darkrpjob
			jobByCmd[darkrpjob.command] = darkrpjobuid

			team.SetUp(role.uniqueID, role.string_name, darkrpjob.color)
		end
	end

	local TEMPRPExtraTeams = {}
	for i, v in pairs(RPExtraTeams) do
		if v.fake == false then
			TEMPRPExtraTeams[tonumber(i)] = v
		end
	end
	RPExtraTeams = TEMPRPExtraTeams
end
YRPBuildDarkrpTeams()

util.AddNetworkString( "YRP_Send_DarkRP_Jobs" )
local Player = FindMetaTable( "Player" )
local timerdelay = 0.26
function Player:DRPSendTeamsToPlayer()
	self.yrp_darkrp_index = 1
	for i, role in pairs(RPExtraTeams) do
		if IsValid(self) then
			if type( role.model ) == "string" then
				role.model = string.Explode( ",", role.model )
			end
			if type( role.weapons ) == "string" then
				role.weapons = string.Explode( ",", role.weapons )
			end
			net.Start( "YRP_Send_DarkRP_Jobs" )
				net.WriteUInt( role.admin, 2 )
				net.WriteBool( role.candemote )
				net.WriteString( role.category )
				net.WriteColor( role.color )
				net.WriteString( role.command )
				net.WriteString( role.description )
				net.WriteBool( role.fake )
				net.WriteBool( role.hasLicense )
				net.WriteUInt( role.int_groupID, 16 )
				net.WriteUInt( role.max, 8 )
				net.WriteTable( role.model )
				net.WriteString( role.name )
				net.WriteUInt( role.salary, 16 )
				net.WriteUInt( role.team, 16 )
				net.WriteUInt( role.uniqueID, 16 )
				net.WriteBool( role.vote )
				net.WriteTable( role.weapons )
			net.Send(self)
		end
	end
end

local drp_allgroups = YRP_SQL_SELECT( "yrp_ply_groups", "*", nil)
CATEGORIES = CATEGORIES or {}
CATEGORIES.jobs = {}
CATEGORIES.entities = {}
CATEGORIES.shipments = {}
CATEGORIES.weapons = {}
CATEGORIES.ammo = {}
CATEGORIES.vehicles = {}
if wk( drp_allgroups ) then
	for i, group in pairs( drp_allgroups) do
		local catname = group.string_name
		local tab = YRPConvertToDarkRPCategory( group, "jobs" )
	
		--CATEGORIES.jobs[catname] = tab -- break ipairs
		table.insert( CATEGORIES.jobs, tab )
	end

	for i, cat in pairs(CATEGORIES.jobs) do
		cat.members = {}
		for i, role in pairs(RPExtraTeams) do
			if role and cat and role.int_groupID == cat.uniqueID then
				table.insert( cat.members, role)
			end
		end
	end
end

util.AddNetworkString( "YRP_Send_DarkRP_Categories" )
util.AddNetworkString( "YRP_Combine_DarkRPTables" )
function Player:DRPSendCategoriesToPlayer()
	local count = 0
	for i, group in pairs(CATEGORIES.jobs) do
		if IsValid( self ) and i and group then
			local gro = YRPConvertToDarkRPCategory( group, "jobs" )
			count = count + 1
			net.Start( "YRP_Send_DarkRP_Categories" )
				net.WriteUInt( gro.uniqueID, 16 )
				net.WriteString( gro.name )
				net.WriteString( gro.categorises )
				net.WriteBool( gro.startExpanded )
				net.WriteColor( gro.color )
				net.WriteUInt( gro.sortOrder, 7 )
			net.Send( self )
		end
	end

	net.Start( "YRP_Combine_DarkRPTables" )
	net.Send(self)

	if wk(TEAMS) then
		for i, cat in pairs(CATEGORIES.jobs) do
			cat.members = {}
			for i, role in pairs(TEAMS) do
				if role.int_groupID == cat.uniqueID then
					table.insert( cat.members, role)
				end
			end
		end
	else
		YRP.msg( "note", "TEAMS not valid" )
	end
end
-- darkrp

function UpdatePrerolesGroupIDs(uid, gid)
	local preroles = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '" .. uid .. "'" )
	if wk(preroles) then
		for i, prerole in pairs(preroles) do
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_groupID"] = gid}, "uniqueID = '" .. prerole.uniqueID .. "'" )
			UpdatePrerolesGroupIDs(prerole.uniqueID, gid)
		end
	end
end

local yrp_ply_roles = {}
local _init_ply_roles = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'" )
if wk(_init_ply_roles) then
	yrp_ply_roles = _init_ply_roles[1]
end

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["roleslist"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}

for str, val in pairs(yrp_ply_roles) do
	if string.find(str, "string_" ) then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString() )
			local s = net.ReadString()
			tab.ply = ply
			tab.id = str
			tab.value = s
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateString(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastString(tab)
			if tab.netstr == "update_role_string_name" then
				util.AddNetworkString( "settings_role_update_name" )
				local puid = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_name"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_role_string_color" then
				util.AddNetworkString( "settings_role_update_color" )
				local puid = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_color"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_role_string_icon" then
				util.AddNetworkString( "settings_role_update_icon" )
				local puid = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_icon"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			end
		end)
	elseif string.find(str, "int_" ) then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString() )
			local int = tonumber(net.ReadString() )
			local cur = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
			tab.ply = ply
			tab.id = str
			tab.value = int
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateInt(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastInt(tab)
			if tab.netstr == "update_role_int_prerole" then
				if wk( cur) then
					cur = cur[1]
					SendRoleList(nil, tonumber( cur.int_groupID), tonumber( cur.int_prerole) )
				end
				SendRoleList(nil, tonumber( cur.int_groupID), 0)
			elseif tab.netstr == "update_role_int_groupID" then
				UpdatePrerolesGroupIDs(tab.uniqueID, tab.value)
			end
		end)
	elseif string.find(str, "float_" ) then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString() )
			local float = tonumber(net.ReadString() )
			local cur = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
			tab.ply = ply
			tab.id = str
			tab.value = float
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateFloat(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastFloat(tab)
			if tab.netstr == "update_role_int_prerole" then
				if wk( cur) then
					cur = cur[1]
					SendGroupList(tonumber( cur.float_parentrole) )
				end
				SendGroupList(float)
			end
		end)
	elseif string.find(str, "bool_" ) then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString() )
			local int = tonumber(net.ReadString() )
			local cur = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
			tab.ply = ply
			tab.id = str
			tab.value = int
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateInt(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastInt(tab)
			if tab.netstr == "update_role_int_prerole" then
				if wk( cur) then
					cur = cur[1]
					SendGroupList(tonumber( cur.int_parentrole) )
				end
				SendGroupList(int)
			end
		end)
	end
end

function SubscribeRoleList(ply, gro, pre)
	if HANDLER_GROUPSANDROLES["roleslist"][gro] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro] = {}
	end
	if HANDLER_GROUPSANDROLES["roleslist"][gro][pre] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro][pre] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply) then
		table.insert(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply)
	end
end

function UnsubscribeRoleList(ply, gro, pre)
	if HANDLER_GROUPSANDROLES["roleslist"][gro] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro] = {}
	end
	if HANDLER_GROUPSANDROLES["roleslist"][gro][pre] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro][pre] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply)
	end
end

function SubscribeRole(ply, uid)
	if HANDLER_GROUPSANDROLES["roles"][uid] == nil then
		HANDLER_GROUPSANDROLES["roles"][uid] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["roles"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["roles"][uid], ply)
	end
end

function UnsubscribeRole(ply, uid)
	if HANDLER_GROUPSANDROLES["roles"][uid] == nil then
		HANDLER_GROUPSANDROLES["roles"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["roles"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["roles"][uid], ply)
	end
end

function SortRoles(gro, pre)
	local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'" )

	if wk(siblings) then
		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 0
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. sibling.uniqueID .. "'" )
		end
	end
end

function SendRoleList(ply, gro, pre)
	gro = tonumber(gro)
	pre = tonumber(pre)
	if gro != nil and pre != nil then
		SortRoles(gro, pre)

		local tbl_roles = nil
		if pre > 0 then
			tbl_roles = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '" .. pre .. "'" )
		else
			tbl_roles = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'" )
		end

		if !wk(tbl_roles) then
			tbl_roles = {}
		end

		local headername = "NOT FOUND"
		if pre > 0 then
			headername = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'" )
			if worked(headername) then
				headername = headername[1].string_name
			end
		else
			headername = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. gro .. "'" )
			if worked(headername) then
				headername = headername[1].string_name
			end
		end

		if wk(headername) then
			if ply != nil then
				net.Start( "settings_subscribe_rolelist" )
					net.WriteTable(tbl_roles)
					net.WriteString(headername)
					net.WriteString(gro)
					net.WriteString(pre)
				net.Send(ply)
			elseif HANDLER_GROUPSANDROLES["roleslist"] and HANDLER_GROUPSANDROLES["roleslist"][gro] and HANDLER_GROUPSANDROLES["roleslist"][gro][pre] then
				local tbl_bc = HANDLER_GROUPSANDROLES["roleslist"][gro][pre] or {}
				for i, pl in pairs(tbl_bc) do
					net.Start( "settings_subscribe_rolelist" )
						net.WriteTable(tbl_roles)
						net.WriteString(headername)
						net.WriteString(gro)
						net.WriteString(pre)
					net.Send(pl)
				end
			end
		else
			YRP.msg( "note", "headername: " .. tostring(headername) )
		end
	else
		YRP.msg( "error", "SendRoleList( " .. tostring(gro) .. ", " .. tostring(pre) .. " )" )
	end
end

-- Duplicate
function DuplicateRole(ruid, guid)
	ruid = ruid or "-1"
	ruid = tonumber(ruid)

	if ruid > -1 then
		local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. ruid .. "'" )
		if wk(role) then
			role = role[1]

			guid = guid or role.int_groupID
			guid = tonumber(guid)

			local cols = {}
			local vals = {}
			for name, value in pairs(role) do
				if name != "uniqueID" and name != "int_removeable" then
					if name == "int_groupID" then
						value = guid
					end
					table.insert( cols, name)
					table.insert( vals, "'" .. value .. "'" )
				end
			end

			cols = table.concat( cols, ", " )
			vals = table.concat( vals, ", " )

			YRP_SQL_INSERT_INTO(DATABASE_NAME, cols, vals)
			
			if guid and role.int_prerole then
				SendRoleList(nil, guid, role.int_prerole)
			end
		else
			YRP.msg( "note", "Role [" .. ruid .. "] was deleted." )
		end
	end
end

util.AddNetworkString( "duplicated_role" )
net.Receive( "duplicated_role", function(len, ply)
	local ruid = tonumber(net.ReadString() )
	DuplicateRole(ruid)
end)

-- Role menu
util.AddNetworkString( "get_grp_roles" )
net.Receive( "get_grp_roles", function(len, ply)
	local _uid = net.ReadString()
	local _roles = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. _uid .. "'" )
	if wk(_roles) then
		for i, ro in pairs(_roles) do
			updateRoleUses(ro.uniqueID)
			ro.pms = GetPMTableOfRole(ro.uniqueID)
		end
		net.Start( "get_grp_roles" )
			net.WriteTable(_roles)
		net.Send(ply)
	else
		YRP.msg( "note", "Group [" .. _uid .. "] has no roles." )
	end
end)

util.AddNetworkString( "get_rol_prerole" )
net.Receive( "get_rol_prerole", function(len, ply)
	local _uid = net.ReadString()
	local _roles = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '" .. _uid .. "'" )

	if wk(_roles) then
		for i, ro in pairs(_roles) do
			ro.pms = GetPMTableOfRole(ro.uniqueID)
		end
		_roles = _roles[1]

		net.Start( "get_rol_prerole" )
			net.WriteTable(_roles)
		net.Send(ply)
	end
end)

-- Role Settings
util.AddNetworkString( "settings_subscribe_rolelist" )
net.Receive( "settings_subscribe_rolelist", function(len, ply)
	local gro = tonumber(net.ReadString() )
	local pre = tonumber(net.ReadString() )

	SubscribeRoleList(ply, gro, pre)
	SendRoleList(ply, gro, pre)
end)

util.AddNetworkString( "settings_subscribe_prerolelist" )
net.Receive( "settings_subscribe_prerolelist", function(len, ply)
	local gro = tonumber(net.ReadString() )
	local pre = tonumber(net.ReadString() )

	pre = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'" )
	if wk(pre) then
		pre = tonumber(pre[1].int_prerole)
		SubscribeRoleList(ply, gro, pre)
		SendRoleList(ply, gro, pre)
	end
end)

util.AddNetworkString( "settings_add_role" )
net.Receive( "settings_add_role", function(len, ply)
	local gro = tonumber(net.ReadString() )
	local pre = tonumber(net.ReadString() )

	local prerole = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'" )

	local has_prerole = false
	if pre > 0 then
		-- Has Prerole
		has_prerole = true
		if !wk(prerole) then
			YRP.msg( "note", "[settings_add_role] Prerole dont Exists anymore" )
			SendRoleList(nil, gro, pre)
			return
		end
	end

	YRP_SQL_INSERT_INTO(DATABASE_NAME, "int_groupID, int_prerole", "'" .. gro .. "', '" .. pre .. "'" )

	local roles = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'" )

	local count = tonumber(table.Count(roles) )
	local new_role = roles[count]
	if has_prerole then
		prerole = prerole[1]
		for name, value in pairs(prerole) do
			local except = {"uniqueID", "int_prerole", "int_position", "int_groupID"}
			if !table.HasValue(except, name) then
				YRP_SQL_UPDATE(DATABASE_NAME, {[name] = value}, "uniqueID = '" .. new_role.uniqueID .. "'" )
			end
		end
	end

	--local up = roles[count - 1]
	if count == 1 then
		YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. new_role.uniqueID .. "'" )
	else
		YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. new_role.uniqueID .. "'" )
		--YRP_SQL_UPDATE(DATABASE_NAME, {["int_dn"] = new_role.uniqueID}, "uniqueID = '" .. up.uniqueID .. "'" )
	end

	YRP.msg( "db", "Added new role: " .. new_role.uniqueID)

	SendRoleList(nil, gro, pre)
end)

util.AddNetworkString( "settings_role_position_up" )
net.Receive( "settings_role_position_up", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	role = role[1]

	role.int_position = tonumber(role.int_position)

	local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'" )

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == role.int_position - 1 then
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = role.int_position}, "uniqueID = '" .. sibling.uniqueID .. "'" )
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = sibling.int_position}, "uniqueID = '" .. uid .. "'" )
		end
	end

	role.int_groupID = tonumber(role.int_groupID)
	role.int_prerole = tonumber(role.int_prerole)
	SendRoleList(nil, role.int_groupID, role.int_prerole)
end)

util.AddNetworkString( "settings_role_position_dn" )
net.Receive( "settings_role_position_dn", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	role = role[1]

	role.int_position = tonumber(role.int_position)

	local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'" )

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == role.int_position + 1 then
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = role.int_position}, "uniqueID = '" .. sibling.uniqueID .. "'" )
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = sibling.int_position}, "uniqueID = '" .. uid .. "'" )
		end
	end

	role.int_groupID = tonumber(role.int_groupID)
	role.int_prerole = tonumber(role.int_prerole)
	SendRoleList(nil, role.int_groupID, role.int_prerole)
end)

util.AddNetworkString( "settings_subscribe_role" )
net.Receive( "settings_subscribe_role", function(len, ply)
	local uid = tonumber(net.ReadString() )
	SubscribeRole(ply, uid)

	local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	if !wk(role) then
		role = {}
	else
		role = role[1]
	end

	local roles = YRP_SQL_SELECT(DATABASE_NAME, "string_name, uniqueID, int_groupID", nil)
	if !wk(roles) then
		roles = {}
	end

	local usergroups = YRP_SQL_SELECT( "yrp_usergroups", "uniqueID, string_name", nil)

	local groups = YRP_SQL_SELECT( "yrp_ply_groups", "uniqueID, string_name", nil)

	local huds = YRPGetHUDs()

	local hudmasks = YRPGetHUDMasks()

	if wk(role) and wk(roles) and wk(usergroups) and wk(groups) and wk(huds) and wk(hudmasks) then
		net.Start( "settings_subscribe_role" )
			net.WriteTable(role)
			net.WriteTable(roles)
			net.WriteTable(usergroups)
			net.WriteTable(groups)
			net.WriteTable(huds)
			net.WriteTable(hudmasks)
		net.Send(ply)
	else
		YRP.msg( "error", "[settings_subscribe_role] " .. tostring( huds ) .. " " .. tostring( hudmasks ) )
	end
end)

util.AddNetworkString( "settings_unsubscribe_role" )
net.Receive( "settings_unsubscribe_role", function(len, ply)
	local uid = tonumber(net.ReadString() )
	UnsubscribeRole(ply, uid)
end)

util.AddNetworkString( "settings_unsubscribe_rolelist" )
net.Receive( "settings_unsubscribe_rolelist", function(len, ply)
	local gro = tonumber(net.ReadString() )
	local pre = tonumber(net.ReadString() )
	UnsubscribeRoleList(ply, gro, pre)
end)

util.AddNetworkString( "settings_delete_role" )
net.Receive( "settings_delete_role", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	if wk(role) then
		role = role[1]
		YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'" )

		local roledeleted = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
		if !wk(roledeleted) then
			YRP.msg( "note", "Role deleted (uid: " .. tostring( uid ) .. " )" )
		end

		local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'" )
		if wk(siblings) then
			for i, sibling in pairs(siblings) do
				sibling.int_position = tonumber(sibling.int_position)
			end
			local count = 0
			for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
				count = count + 1
				YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. sibling.uniqueID .. "'" )
			end
		end

		MoveUnusedRolesToDefault()
		
		role.int_groupID = tonumber(role.int_groupID)
		role.int_prerole = tonumber(role.int_prerole)
		SendRoleList(nil, role.int_groupID, role.int_prerole)
	end
end)

util.AddNetworkString( "getScoreboardGroups" )
net.Receive( "getScoreboardGroups", function(len, ply)
	local _tmpGroups = YRP_SQL_SELECT( "yrp_ply_groups", "*", nil)
	if wk(_tmpGroups) then
		net.Start( "getScoreboardGroups" )
			net.WriteTable(_tmpGroups)
		net.Broadcast()
	else
		YRP.msg( "note", "getScoreboardGroups failed!" )
		pFTab(_tmpGroups)
	end
end)

function GetRole(uid)
	local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	if wk(role) then
		return role[1]
	end
	return nil
end

function SendCustomFlags(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local flags = string.Explode( ",", role.string_customflags)
		for i, val in pairs(flags) do
			local flag = YRP_SQL_SELECT( "yrp_flags", "*", "uniqueID = '" .. val .. "'" )
			if wk(flag) then
				flag = flag[1]
				local entry = {}
				entry.uniqueID = flag.uniqueID
				entry.string_name = flag.string_name
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start( "get_role_customflags" )
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString( "get_role_customflags" )
net.Receive( "get_role_customflags", function(len, ply)
	local uid = net.ReadInt(32)
	SendCustomFlags(uid)
end)

util.AddNetworkString( "get_all_role_customflags" )
net.Receive( "get_all_role_customflags", function(len, ply)
	local allflags = YRP_SQL_SELECT( "yrp_flags", "*", "string_type = 'role'" )
	if !wk( allflags) then
		allflags = {}
	end

	net.Start( "get_all_role_customflags" )
		net.WriteTable( allflags)
	net.Send(ply)
end)

util.AddNetworkString( "add_role_flag" )
net.Receive( "add_role_flag", function(len, ply)
	local ruid = net.ReadInt(32)
	local fuid = net.ReadInt(32)
	local role = GetRole(ruid)

	local customflags = string.Explode( ",", role.string_customflags)
	if !table.HasValue( customflags, tostring(fuid) ) then
		local oldflags = {}
		for i, v in pairs( customflags) do
			if v != "" then
				table.insert(oldflags, v)
			end
		end

		local newflags = oldflags
		table.insert(newflags, fuid)
		newflags = string.Implode( ",", newflags)

		YRP_SQL_UPDATE(DATABASE_NAME, {["string_customflags"] = newflags}, "uniqueID = '" .. ruid .. "'" )
		SendCustomFlags(ruid)
	end
end)

util.AddNetworkString( "rem_role_flag" )
net.Receive( "rem_role_flag", function(len, ply)
	local ruid = net.ReadInt(32)
	local fuid = net.ReadInt(32)
	local role = GetRole(ruid)

	local customflags = string.Explode( ",", role.string_customflags)
	local oldflags = {}
	for i, v in pairs( customflags) do
		if v != "" then
			table.insert(oldflags, v)
		end
	end

	local newflags = oldflags
	table.RemoveByValue(newflags, tostring(fuid) )
	newflags = string.Implode( ",", newflags)

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_customflags"] = newflags}, "uniqueID = '" .. ruid .. "'" )
	SendCustomFlags(ruid)
end)

function SendPlayermodels(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local flags = string.Explode( ",", role.string_playermodels)
		for i, val in pairs(flags) do
			local pms = YRP_SQL_SELECT( "yrp_playermodels", "*", "uniqueID = '" .. val .. "'" )

			if wk(pms) then
				pms = pms[1]
				local entry = {}
				entry.uniqueID = pms.uniqueID
				local name = pms.string_name
				if name == "" or	name == " " then
					name = pms.string_models
				end
				entry.string_name = name
				entry.string_models = pms.string_models
				table.insert(nettab, entry)
			end
		end

		if HANDLER_GROUPSANDROLES and HANDLER_GROUPSANDROLES["roles"] and HANDLER_GROUPSANDROLES["roles"][uid] then
			for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
				net.Start( "get_role_playermodels" )
					net.WriteTable(nettab)
				net.Send(pl)
			end
		end
	end
end

util.AddNetworkString( "get_role_playermodels" )
net.Receive( "get_role_playermodels", function(len, ply)
	local uid = net.ReadInt(32)
	SendPlayermodels(uid)
end)

util.AddNetworkString( "get_all_playermodels" )
net.Receive( "get_all_playermodels", function(len, ply)
	local allpms = YRP_SQL_SELECT( "yrp_playermodels", "*", nil)
	if !wk( allpms) then
		allpms = {}
	end
	for x, pm in pairs( allpms) do
		pm.uses = 0

		pm.string_models = pm.string_models

		-- Count uses
		local roles = YRP_SQL_SELECT( "yrp_ply_roles", "uniqueID, string_name, string_playermodels", "string_playermodels LIKE '%" .. pm.uniqueID .. "%'" )
		if roles then
			for y, role in pairs(roles) do
				local rolepms = string.Explode( ",", role.string_playermodels)
				if rolepms then
					for z, rolepm in pairs(rolepms) do
						if pm.uniqueID == rolepm then
							pm.uses = pm.uses + 1
						end
					end
				end
			end
		end
	end

	if wk( allpms ) then
		for i, v in pairs( allpms ) do
			net.Start( "get_all_playermodels" )
				net.WriteTable( v )
			net.Send( ply )
		end
	end
end)

function AddPlayermodelToRole(ruid, muid)
	local role = GetRole(ruid)
	local pms = string.Explode( ",", role.string_playermodels)
	if !table.HasValue(pms, tostring(muid) ) then
		local oldpms = {}
		for i, pm in pairs(pms) do
			if !strEmpty(pm) then
				table.insert(oldpms, pm)
			end
		end

		local newpms = oldpms
		table.insert(newpms, tostring(muid) )
		newpms = string.Implode( ",", newpms)

		YRP_SQL_UPDATE(DATABASE_NAME, {["string_playermodels"] = newpms}, "uniqueID = '" .. ruid .. "'" )
		SendPlayermodels(ruid)
	end
end

util.AddNetworkString( "add_role_playermodel" )
net.Receive( "add_role_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = net.ReadInt(32)

	AddPlayermodelToRole(ruid, muid)
end)

function YRPAddPlayermodelsToRole( pms, name, min, max, ruid )
	for i, v in pairs( pms ) do
		if string.find( v, "'" ) then
			YRP.msg( "note", "!!! MODEL HAS > ' < in its path/file -> " .. tostring( v ) )
			YRP.msg( "note", "!!! CONTACT THE DEVELOPER TO CHANGE THIS" )
			return
		end
	end

	pms = table.concat(pms, "," )

	YRP_SQL_INSERT_INTO( "yrp_playermodels", "string_models, string_name, float_size_min, float_size_max", "" .. YRP_SQL_STR_IN( pms ) .. ", " .. YRP_SQL_STR_IN( name ) .. ", '" .. min .. "', '" .. max .. "'" )

	local lastentry = YRP_SQL_SELECT( "yrp_playermodels", "*", nil)
	lastentry = lastentry[table.Count(lastentry)]
	AddPlayermodelToRole(ruid, lastentry.uniqueID)
end

util.AddNetworkString( "add_playermodels" )
net.Receive( "add_playermodels", function(len, ply)
	local ruid = net.ReadInt(32)
	local pms = net.ReadTable()
	local name = net.ReadString()
	local min = net.ReadString()
	local max = net.ReadString()

	YRPAddPlayermodelsToRole( pms, name, min, max, ruid )
end)

function RemPlayermodelFromRole(ruid, muid)
	local role = GetRole(ruid)
	local pms = string.Explode( ",", role.string_playermodels)
	local oldpms = {}
	for i, v in pairs(pms) do
		if !strEmpty( v) then
			table.insert(oldpms, v)
		end
	end

	local newpms = oldpms
	table.RemoveByValue(newpms, tostring(muid) )
	newpms = string.Implode( ",", newpms)

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_playermodels"] = newpms}, "uniqueID = '" .. ruid .. "'" )
	SendPlayermodels(ruid)
end

util.AddNetworkString( "rem_role_playermodel" )
net.Receive( "rem_role_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = net.ReadInt(32)

	local pms = muid

	local test = YRP_SQL_SELECT( "yrp_playermodels", "*", "uniqueID = '" .. muid .. "'" )

	if wk(test) then
		pms = test[1].string_models
	end

	YRP.log( ply:RPName() .. " removed playermodels ( " .. pms .. " ) from Role " .. ruid )

	RemPlayermodelFromRole(ruid, muid)
end)

function SendSweps(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local sweps = string.Explode( ",", role.string_sweps)
		for i, swep in pairs(sweps) do
			if !strEmpty(swep) then
				table.insert(nettab, swep)
			end
		end
		
		if HANDLER_GROUPSANDROLES and HANDLER_GROUPSANDROLES["roles"] and HANDLER_GROUPSANDROLES["roles"][uid] then
			for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
				net.Start( "get_role_sweps" )
					net.WriteTable(nettab)
				net.Send(pl)
			end
		end
	else
		YRP.msg( "note", "Role not Found" )
	end
end

util.AddNetworkString( "get_role_sweps" )
net.Receive( "get_role_sweps", function(len, ply)
	local uid = net.ReadInt(32)
	SendSweps(uid)
end)

function AddSwepToRole(ruid, swepcn)
	local role = GetRole(ruid)
	if wk(role) then
		local sweps = string.Explode( ",", role.string_sweps)
		if !table.HasValue(sweps, tostring(swepcn) ) then
			local oldsweps = {}
			for i, v in pairs(sweps) do
				if !strEmpty( v) then
					table.insert(oldsweps, v)
				end
			end

			local newsweps = oldsweps
			table.insert(newsweps, tostring(swepcn) )
			newsweps = string.Implode( ",", newsweps)

			YRP_SQL_UPDATE(DATABASE_NAME, {["string_sweps"] = newsweps}, "uniqueID = '" .. ruid .. "'" )
			SendSweps(ruid)
		end
	else
		YRP.msg( "note", "Role not found" )
	end
end

util.AddNetworkString( "add_role_swep" )
net.Receive( "add_role_swep", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadTable()

	for i, swep in pairs(swepcn) do
		AddSwepToRole(ruid, swep)
	end
end)

function RemSwepFromRole(ruid, swepcn)
	local role = GetRole(ruid)
	local sweps = string.Explode( ",", role.string_sweps)
	local oldsweps = {}
	for i, v in pairs(sweps) do
		if !strEmpty( v) then
			table.insert(oldsweps, v)
		end
	end

	local newsweps = oldsweps
	table.RemoveByValue(newsweps, tostring(swepcn) )
	newsweps = string.Implode( ",", newsweps)

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_sweps"] = newsweps}, "uniqueID = '" .. ruid .. "'" )
	SendSweps(ruid)
end

util.AddNetworkString( "rem_role_swep" )
net.Receive( "rem_role_swep", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadString()

	RemSwepFromRole(ruid, swepcn)
end)



-- sweps on spawn
function SendSwepsOnSpawn(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local sweps = string.Explode( ",", role.string_sweps_onspawn)
		for i, swep in pairs(sweps) do
			if !strEmpty(swep) then
				local entry = YRPGetSlotsOfSWEP(swep)
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start( "get_role_sweps_onspawn" )
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString( "get_role_sweps_onspawn" )
net.Receive( "get_role_sweps_onspawn", function(len, ply)
	local uid = net.ReadInt(32)
	SendSwepsOnSpawn(uid)
end)

function AddSwepToRoleOnSpawn(ruid, swepcn)
	local role = GetRole(ruid)
	if wk(role) then
		local sweps = string.Explode( ",", role.string_sweps_onspawn)
		if !table.HasValue(sweps, tostring(swepcn) ) then
			local oldsweps = {}
			for i, v in pairs(sweps) do
				if !strEmpty( v) then
					table.insert(oldsweps, v)
				end
			end

			local newsweps = oldsweps
			table.insert(newsweps, tostring(swepcn) )
			newsweps = string.Implode( ",", newsweps)

			YRP_SQL_UPDATE(DATABASE_NAME, {["string_sweps_onspawn"] = newsweps}, "uniqueID = '" .. ruid .. "'" )
			SendSwepsOnSpawn(ruid)
		end
	end
end

util.AddNetworkString( "add_role_swep_onspawn" )
net.Receive( "add_role_swep_onspawn", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadTable()

	for i, swep in pairs(swepcn) do
		AddSwepToRoleOnSpawn(ruid, swep)
	end
end)

function RemSwepFromRoleOnSpawn(ruid, swepcn)
	local role = GetRole(ruid)
	local sweps = string.Explode( ",", role.string_sweps_onspawn)
	local oldsweps = {}
	for i, v in pairs(sweps) do
		if !strEmpty( v) then
			table.insert(oldsweps, v)
		end
	end

	local newsweps = oldsweps
	table.RemoveByValue(newsweps, tostring(swepcn) )
	newsweps = string.Implode( ",", newsweps)

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_sweps_onspawn"] = newsweps}, "uniqueID = '" .. ruid .. "'" )
	SendSwepsOnSpawn(ruid)
end

util.AddNetworkString( "rem_role_swep_onspawn" )
net.Receive( "rem_role_swep_onspawn", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadString()

	RemSwepFromRoleOnSpawn(ruid, swepcn)
end)



--not droppable sweps
function SendNDSweps(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local ndsweps = string.Explode( ",", role.string_ndsweps)
		for i, ndswep in pairs(ndsweps) do
			if !strEmpty(ndswep) then
				table.insert(nettab, ndswep)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start( "get_role_ndsweps" )
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString( "get_role_ndsweps" )
net.Receive( "get_role_ndsweps", function(len, ply)
	local uid = net.ReadInt(32)
	SendNDSweps(uid)
end)

function AddNDSwepToRole(ruid, ndswepcn)
	local role = GetRole(ruid)
	local ndsweps = string.Explode( ",", role.string_ndsweps)
	if !table.HasValue(ndsweps, tostring(ndswepcn) ) then
		local oldndsweps = {}
		for i, v in pairs(ndsweps) do
			if !strEmpty( v) then
				table.insert(oldndsweps, v)
			end
		end

		local newndsweps = oldndsweps
		table.insert(newndsweps, tostring(ndswepcn) )
		newndsweps = string.Implode( ",", newndsweps)

		YRP_SQL_UPDATE(DATABASE_NAME, {["string_ndsweps"] = newndsweps}, "uniqueID = '" .. ruid .. "'" )
		SendNDSweps(ruid)
	end
end

util.AddNetworkString( "add_role_ndswep" )
net.Receive( "add_role_ndswep", function(len, ply)
	local ruid = net.ReadInt(32)
	local ndswepcn = net.ReadString()

	AddNDSwepToRole(ruid, ndswepcn)
end)

function RemNDSwepFromRole(ruid, ndswepcn)
	local role = GetRole(ruid)
	local ndsweps = string.Explode( ",", role.string_ndsweps)
	local oldndsweps = {}
	for i, v in pairs(ndsweps) do
		if !strEmpty( v) then
			table.insert(oldndsweps, v)
		end
	end

	local newndsweps = oldndsweps
	table.RemoveByValue(newndsweps, tostring(ndswepcn) )
	newndsweps = string.Implode( ",", newndsweps)

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_ndsweps"] = newndsweps}, "uniqueID = '" .. ruid .. "'" )
	SendNDSweps(ruid)
end

util.AddNetworkString( "rem_role_ndswep" )
net.Receive( "rem_role_ndswep", function(len, ply)
	local ruid = net.ReadInt(32)
	local ndswepcn = net.ReadString()

	RemNDSwepFromRole(ruid, ndswepcn)
end)

--licenses
function SendLicenses(ruid)
	local role = GetRole(ruid)
	if wk(role) then
		local nettab = {}
		local licenses = string.Explode( ",", role.string_licenses)
		for i, val in pairs(licenses) do
			local li = YRP_SQL_SELECT( "yrp_licenses", "*", "uniqueID = '" .. val .. "'" )
			if wk(li) then
				li = li[1]
				local entry = {}
				entry.uniqueID = li.uniqueID
				local name = li.name
				entry.string_name = name
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][ruid]) do
			net.Start( "get_role_licenses" )
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

function RemLicenseFromRole(ruid, muid)
	local role = GetRole(ruid)
	local lis = string.Explode( ",", role.string_licenses)
	local oldlis = {}
	for i, v in pairs(lis) do
		if !strEmpty( v) then
			table.insert(oldlis, v)
		end
	end

	local newlis = oldlis
	table.RemoveByValue(newlis, tostring(muid) )
	newlis = string.Implode( ",", newlis)

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_licenses"] = newlis}, "uniqueID = '" .. ruid .. "'" )
	SendLicenses(ruid)
end

function CleanUpLicenses(ruid)
	local role = GetRole(ruid)
	if wk(role) then
		local lis = string.Explode( ",", role.string_licenses)

		for i, li in pairs(lis) do
			if li != "" then
				local found = YRP_SQL_SELECT( "yrp_licenses", "*", "uniqueID = '" .. li .. "'" )
				if !wk(found) then
					RemLicenseFromRole(ruid, li)
				end
			end
		end
	end
end

util.AddNetworkString( "get_role_licenses" )
net.Receive( "get_role_licenses", function(len, ply)
	local uid = net.ReadInt(32)
	CleanUpLicenses(uid)
	SendLicenses(uid)
end)

util.AddNetworkString( "get_all_licenses" )
net.Receive( "get_all_licenses", function(len, ply)
	local alllis = YRP_SQL_SELECT( "yrp_licenses", "*", nil)
	if !wk( alllis) then
		alllis = {}
	end
	net.Start( "get_all_licenses" )
		net.WriteTable( alllis)
	net.Send(ply)
end)

function AddLicenseToRole(ruid, muid)
	local role = GetRole(ruid)
	local lis = string.Explode( ",", role.string_licenses)
	if !table.HasValue(lis, tostring(muid) ) then
		local oldlis = {}
		for i, v in pairs(lis) do
			if !strEmpty( v) then
				table.insert(oldlis, v)
			end
		end

		local newlis = oldlis
		table.insert(newlis, tostring(muid) )
		newlis = string.Implode( ",", newlis)

		YRP_SQL_UPDATE(DATABASE_NAME, {["string_licenses"] = newlis}, "uniqueID = '" .. ruid .. "'" )
		SendLicenses(ruid)
	end
end

util.AddNetworkString( "add_role_license" )
net.Receive( "add_role_license", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = tonumber(net.ReadString() )

	AddLicenseToRole(ruid, muid)
end)

util.AddNetworkString( "add_license" )
net.Receive( "add_license", function(len, ply)
	local ruid = net.ReadInt(32)
	local WorldModel = net.ReadString()
	local name = net.ReadString()
	YRP_SQL_INSERT_INTO( "yrp_licenses", "string_model, string_name", "'" .. WorldModel .. "', '" .. name .. "'" )

	local lastentry = YRP_SQL_SELECT( "yrp_licenses", "*", nil)
	lastentry = lastentry[table.Count(lastentry)]
	AddLicenseToRole(ruid, lastentry.uniqueID)
end)

util.AddNetworkString( "rem_role_license" )
net.Receive( "rem_role_license", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = tonumber(net.ReadString() )

	RemLicenseFromRole(ruid, muid)
end)



--specializations
function SendSpecializations(ruid)
	local role = GetRole(ruid)
	if wk(role) then
		local nettab = {}
		local specializations = string.Explode( ",", role.string_specializations)
		for i, val in pairs(specializations) do
			local li = YRP_SQL_SELECT( "yrp_specializations", "*", "uniqueID = '" .. val .. "'" )
			if wk(li) then
				li = li[1]
				local entry = {}
				entry.uniqueID = li.uniqueID
				local name = li.name
				entry.string_name = name
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][ruid]) do
			net.Start( "get_role_specializations" )
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

function RemSpecializationFromRole(ruid, muid)
	local role = GetRole(ruid)
	local lis = string.Explode( ",", role.string_specializations)
	local oldlis = {}
	for i, v in pairs(lis) do
		if !strEmpty( v) then
			table.insert(oldlis, v)
		end
	end

	local newlis = oldlis
	table.RemoveByValue(newlis, tostring(muid) )
	newlis = string.Implode( ",", newlis)

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_specializations"] = newlis}, "uniqueID = '" .. ruid .. "'" )
	SendSpecializations(ruid)
end

function CleanUpSpecializations(ruid)
	local role = GetRole(ruid)
	if wk(role) then
		local lis = string.Explode( ",", role.string_specializations)

		for i, li in pairs(lis) do
			if li != "" then
				local found = YRP_SQL_SELECT( "yrp_specializations", "*", "uniqueID = '" .. li .. "'" )
				if !wk(found) then
					RemSpecializationFromRole(ruid, li)
				end
			end
		end
	end
end

util.AddNetworkString( "get_role_specializations" )
net.Receive( "get_role_specializations", function(len, ply)
	local uid = net.ReadInt(32)
	CleanUpSpecializations(uid)
	SendSpecializations(uid)
end)

util.AddNetworkString( "get_all_specializations" )
net.Receive( "get_all_specializations", function(len, ply)
	local alllis = YRP_SQL_SELECT( "yrp_specializations", "*", nil)
	if !wk( alllis) then
		alllis = {}
	end
	net.Start( "get_all_specializations" )
		net.WriteTable( alllis)
	net.Send(ply)
end)

function AddSpecializationToRole(ruid, muid)
	local role = GetRole(ruid)
	local lis = string.Explode( ",", role.string_specializations)
	if !table.HasValue(lis, tostring(muid) ) then
		local oldlis = {}
		for i, v in pairs(lis) do
			if !strEmpty( v) then
				table.insert(oldlis, v)
			end
		end

		local newlis = oldlis
		table.insert(newlis, tostring(muid) )
		newlis = string.Implode( ",", newlis)

		YRP_SQL_UPDATE(DATABASE_NAME, {["string_specializations"] = newlis}, "uniqueID = '" .. ruid .. "'" )
		SendSpecializations(ruid)
	end
end

util.AddNetworkString( "add_role_specialization" )
net.Receive( "add_role_specialization", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = tonumber(net.ReadString() )

	AddSpecializationToRole(ruid, muid)
end)

util.AddNetworkString( "add_specialization" )
net.Receive( "add_specialization", function(len, ply)
	local ruid = net.ReadInt(32)
	local WorldModel = net.ReadString()
	local name = net.ReadString()
	YRP_SQL_INSERT_INTO( "yrp_specializations", "string_model, string_name", "'" .. WorldModel .. "', '" .. name .. "'" )

	local lastentry = YRP_SQL_SELECT( "yrp_specializations", "*", nil)
	lastentry = lastentry[table.Count(lastentry)]
	AddSpecializationToRole(ruid, lastentry.uniqueID)
end)

util.AddNetworkString( "rem_role_specialization" )
net.Receive( "rem_role_specialization", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = tonumber(net.ReadString() )

	RemSpecializationFromRole(ruid, muid)
end)



util.AddNetworkString( "openInteractMenu" )
net.Receive( "openInteractMenu", function(len, ply)
	local charid = net.ReadString()
	charid = tonumber( charid )
	local target = YRPGetPlayerByCharID( charid )

	if ea(target) and target:IsPlayer() then
		local idcard = YRP_SQL_SELECT( "yrp_general", "*", nil)
		idcard = tobool(idcard[1].bool_identity_card)

		local chatab = target:YRPGetCharacterTable()
		if wk(chatab) then
			local targetRole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. chatab.roleID)

			local tmpT = ply:YRPGetCharacterTable()
			local tmpTable = ply:YRPGetRoleTable()
			if wk(tmpT) and wk(tmpTable) then
				local isInstructor = false

				local tmpPromote = false
				local tmpPromoteName = ""

				local tmpDemote = false
				local tmpDemoteName = ""

				if tonumber(tmpTable.bool_instructor) == 1 then
					isInstructor = true

					local tmpSearch = true	--targetSteamID
					local tmpTableSearch = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tmpTable.int_prerole)
					if wk(tmpTableSearch) then
						local tmpSearchUniqueID = tmpTableSearch[1].int_prerole

						local tmpCounter = 0
						while (tmpSearch) do
							if wk(tmpTableSearch) then
								tmpSearchUniqueID = tonumber(tmpTableSearch[1].int_prerole)

								if tonumber(targetRole[1].int_prerole) != 0 and tmpTableSearch[1].uniqueID == targetRole[1].uniqueID then
									tmpDemote = true
									local tmp = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. targetRole[1].int_prerole)
									tmpDemoteName = tmp[1].string_name
								end

								if tonumber(tmpSearchUniqueID) == tonumber(targetRole[1].uniqueID) then
									tmpPromote = true
									tmpPromoteName = tmpTableSearch[1].string_name
								end

								if tmpPromote and tmpDemote then
									tmpSearch = false
								end
							end
							tmpTableSearch = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tmpSearchUniqueID)

							--Only look for 30 preroles
							tmpCounter = tmpCounter + 1
							if tmpCounter >= 30 then
								--YRP.msg( "note", "You have a loop in your preroles!" )
								tmpSearch = false
							end
						end
					end
				end

				local tmpHasSpecs = false
				if !strEmpty(tmpTable.string_specializations) then
					tmpHasSpecs = true
				end

				net.Start( "openInteractMenu" )
					net.WriteEntity(target)

					net.WriteBool(idcard)

					net.WriteBool(isInstructor)

					net.WriteBool(tmpPromote)
					net.WriteString(tmpPromoteName)

					net.WriteBool(tmpDemote)
					net.WriteString(tmpDemoteName)

					net.WriteBool(tmpHasSpecs)
				net.Send(ply)
			end
		end
	end
end)

util.AddNetworkString( "isidcardenabled" )
net.Receive( "isidcardenabled", function(len, ply)
	local idcard = YRP_SQL_SELECT( "yrp_general", "*", nil)
	idcard = tobool(idcard[1].bool_identity_card)

	net.Start( "isidcardenabled" )
		net.WriteBool(idcard)
	net.Send(ply)
end)

function removeFromWhitelist( SteamID, roleID )
	local _result = YRP_SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID )
	if _result != nil then
		YRP_SQL_DELETE_FROM( "yrp_role_whitelist", "uniqueID = " .. _result[1].uniqueID )
	end
end

function addToWhitelistByPly( SteamID, roleID, groupID, nick, ply, targetSteamID )
	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID() .. "', '" .. targetSteamID .. "', '" .. roleID .. " " .. groupID .. "'" )

	if YRP_SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID ) == nil then
		local dat = util.DateStamp()
		local status = "Promoted by " .. ply:SteamName()
		YRP_SQL_INSERT_INTO( "yrp_role_whitelist", "SteamID, nick, groupID, roleID, date, status, name", "'" .. SteamID .. "', " .. YRP_SQL_STR_IN( nick ) .. ", " .. groupID .. ", " .. roleID .. ", '" .. dat .. "', '" .. status .. "', '" .. nick .. "'" )
	else
		YRP.msg( "note", "is already in whitelist" )
	end
end

function addToWhitelist( roleID, ply )
	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID() .. "', '" .. ply:SteamID() .. "', '" .. roleID .. "'" )

	if YRP_SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. ply:YRPSteamID() .. "' AND roleID = " .. roleID ) == nil then
		local dat = util.DateStamp()
		local status = "Invited " .. ply:SteamName()
		local name = ply:SteamName()
		YRP_SQL_INSERT_INTO( "yrp_role_whitelist", "SteamID, nick, roleID, date, status, name", "'" .. ply:YRPSteamID() .. "', " .. YRP_SQL_STR_IN( ply:RPName() ) .. ", " .. roleID .. ", '" .. dat .. "', '" .. status .. "', '" .. name .. "'" )
	else
		YRP.msg( "note", "is already in whitelist" )
	end
end

function addToWhitelistGroup( groupID, ply )
	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID() .. "', '" .. ply:SteamID() .. "', '" .. groupID .. "'" )

	if YRP_SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. ply:YRPSteamID() .. "' AND groupID = " .. groupID ) == nil then
		local dat = util.DateStamp()
		local status = "Invited " .. ply:SteamName()
		local name = ply:SteamName()
		YRP_SQL_INSERT_INTO( "yrp_role_whitelist", "SteamID, nick, groupID, date, status, name", "'" .. ply:YRPSteamID() .. "', " .. YRP_SQL_STR_IN( ply:RPName() ) .. ", " .. groupID .. ", '" .. dat .. "', '" .. status .. "', '" .. name .. "'" )
	else
		YRP.msg( "note", "is already in whitelist" )
	end
end

function YRPGetCharTabByID( uid )
	local char = YRP_SQL_SELECT( "yrp_characters", "*", "uniqueID = '" .. uid .. "'" )
	if char and char[1] then
		return char[1]
	end
	return {}
end

function YRPGetPlayerByCharID( uid )
	for i, v in pairs( player.GetAll() ) do
		if v:CharID() == uid then
			return v
		end
	end
	return NULL
end

util.AddNetworkString( "promotePlayer" )
net.Receive( "promotePlayer", function(len, ply)
	local targetcharid = net.ReadString()
	targetcharid = tonumber( targetcharid )

	local target = YRPGetPlayerByCharID( targetcharid )
	local chatab = YRPGetCharTabByID( targetcharid )

	local tmpTableInstructorRole = ply:YRPGetRoleTable()
	if tonumber( tmpTableInstructorRole.bool_instructor ) == 1 then
		local tmpTableTargetRole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. chatab.roleID )
		local tmpTableTargetPromoteRole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "int_prerole = '" .. tmpTableTargetRole[1].uniqueID .. "' AND int_groupID = '" .. tmpTableInstructorRole.int_groupID .. "'" )
		local tmpTableTargetGroup = nil
		if tmpTableTargetPromoteRole != nil then
			tmpTableTargetGroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetPromoteRole[1].int_groupID )
		else
			tmpTableTargetPromoteRole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "int_prerole = '" .. 0 .. "' AND int_groupID = '" .. tmpTableInstructorRole.int_groupID .. "'" )
			tmpTableTargetGroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetPromoteRole[1].int_groupID )
		end

		tmpTableTargetPromoteRole = tmpTableTargetPromoteRole[1]
		tmpTableTargetGroup = tmpTableTargetGroup[1]

		if tmpTableTargetPromoteRole.uniqueID != tmpTableInstructorRole.uniqueID then
			addToWhitelistByPly( chatab.SteamID, tmpTableTargetPromoteRole.uniqueID, tmpTableTargetGroup.uniqueID, chatab.rpname, ply, chatab.SteamID )

			YRP_SQL_UPDATE( "yrp_characters", {
				["roleID"] = tmpTableTargetPromoteRole.uniqueID
			}, "uniqueID = '" .. chatab.uniqueID .. "'" )

			if IsValid( target ) then
				SetRole( target, tmpTableTargetPromoteRole.uniqueID, true )
			end
			YRP.msg( "note", ply:Nick() .. " promoted " .. chatab.rpname .. " to " .. tmpTableTargetPromoteRole.string_name )
			YRPSendGroupMember( ply, chatab.uniqueID )
		else
			YRP.msg( "note", ply:Nick() .. " tried to promote to same role" )
		end
	elseif tonumber( tmpTableInstructorRole.bool_instructor ) == 0 then
		YRP.msg( "error", "Player: " .. ply:Nick() .. " ( " .. ply:YRPSteamID() .. " ) tried to use promote function! He is not an instructor!" )
	else
		YRP.msg( "error", "ELSE promote: " .. tostring( tmpTableInstructorRole.bool_instructor ) )
	end
end)

util.AddNetworkString( "demotePlayer" )
net.Receive( "demotePlayer", function( len, ply )
	local targetcharid = net.ReadString()
	targetcharid = tonumber( targetcharid )

	local target = YRPGetPlayerByCharID( targetcharid )
	local chatab = YRPGetCharTabByID( targetcharid )

	local tmpTableInstructorRole = ply:YRPGetRoleTable()

	if tonumber( tmpTableInstructorRole.bool_instructor ) == 1 then
		local tmpTableTargetRole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. chatab.roleID )
		local tmpTableTargetDemoteRole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tmpTableTargetRole[1].int_prerole )
		local tmpTableTargetGroup = nil
		if tmpTableTargetDemoteRole != nil then
			tmpTableTargetGroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetDemoteRole[1].int_groupID )
		else
			tmpTableTargetDemoteRole = YRP_SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = '1'" )
			tmpTableTargetGroup = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '1'" )
		end
		tmpTableTargetDemoteRole = tmpTableTargetDemoteRole[1]
		tmpTableTargetGroup = tmpTableTargetGroup[1]

		removeFromWhitelist( chatab.SteamID, tmpTableTargetRole[1].uniqueID )

		YRP_SQL_UPDATE( "yrp_characters", {
			["roleID"] = tmpTableTargetDemoteRole.uniqueID
		}, "uniqueID = '" .. chatab.uniqueID .. "'" )

		if IsValid( target ) then
			SetRole( target, tmpTableTargetDemoteRole.uniqueID )
		end
		YRP.msg( "note", ply:Nick() .. " demoted " .. chatab.rpname .. " to " .. tmpTableTargetDemoteRole.string_name )
		YRPSendGroupMember( ply, chatab.uniqueID )
	elseif tonumber( tmpTableInstructorRole.bool_instructor ) == 0 then
		YRP.msg( "note", "Player: " .. ply:Nick() .. " ( " .. ply:YRPSteamID() .. " ) tried to use demote function! He is not an instructor!" )
	else
		YRP.msg( "error", "ELSE demote: " .. tostring( tmpTableInstructorRole.bool_instructor ) )
	end
end)

function YRPGetFirstRankUID(ruid)
	local tries = 30

	local lastuid = ruid
	local resultuid = 1

	local Search = true
	while (Search) do
		local int_prerole = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, int_prerole", "uniqueID = '" .. lastuid .. "'" )
		if wk(int_prerole) then
			int_prerole = int_prerole[1].int_prerole

			local prerole = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, int_prerole", "uniqueID = '" .. int_prerole .. "'" )
			if wk(prerole) then
				lastuid = prerole[1].uniqueID

				resultuid = lastuid
			end
		end

		tries = tries - 1
		if tries <= 0 then
			Search = false
		end
	end
	return resultuid
end

util.AddNetworkString( "invitetogroup" )
util.AddNetworkString( "yrp_invite_ply" )
util.AddNetworkString( "yrp_invite_accept" )
net.Receive( "invitetogroup", function( len, ply )
	local charid = net.ReadString()
	charid = tonumber( charid )

	local target = YRPGetPlayerByCharID( charid )

	local tmpTableInstructorRole = ply:YRPGetRoleTable()

	if IsValid( target ) then
		if tonumber( tmpTableInstructorRole.bool_instructor ) == 1 then
			local firstrankuid = YRPGetFirstRankUID(ply:GetRoleUID() )
			
			local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. firstrankuid .. "'" )
			local group = YRP_SQL_SELECT(DATABASE_NAME, "*", role.groupID)
			if wk(role) then
				role = role[1]

				local group = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. role.int_groupID .. "'" )

				if wk(group) then
					group = group[1]

					net.Start( "yrp_invite_ply" )
						net.WriteTable(role)
						net.WriteTable(group)
					net.Send(target)

					YRP.msg( "note", "[InviteToGroup] " .. ply:Nick() .. " invited " .. target:Nick() .. " to " .. ply:GetGroupName() )
				else
					YRP.msg( "note", "[InviteToGroup] GROUP DOESN'T EXISTS ANYMORE" )
				end
			else
				YRP.msg( "note", "[InviteToGroup] ROLE DOESN'T EXISTS ANYMORE" )
			end
		elseif tonumber( tmpTableInstructorRole.bool_instructor ) == 0 then
			YRP.msg( "note", "[InviteToGroup] Player: " .. ply:Nick() .. " ( " .. ply:YRPSteamID() .. " ) tried to use invite function! He is not an instructor!" )
		else
			YRP.msg( "error", "[InviteToGroup] ELSE invite: " .. tostring( tmpTableInstructorRole.bool_instructor ) )
		end
	else
		YRP.msg( "note", "[InviteToGroup] TARGET NOT FOUND" )
	end
end)
net.Receive( "yrp_invite_accept", function( len, ply )
	local r = net.ReadTable()

	local role = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. r.uniqueID .. "'" )
	if wk(role) then
		role = role[1]
	
		addToWhitelist( tonumber(role.uniqueID), ply )
		addToWhitelistGroup( tonumber(role.int_groupID), ply )
		SetRole( ply, tonumber(role.uniqueID) )
		YRP.msg( "note", "[yrp_invite_accept] Added to whitelist and setrole for " .. ply:YRPName() )
		YRPUpdateGroupMemberLists()
	else
		YRP.msg( "note", "[yrp_invite_accept] ROLE DOESN'T EXISTS ANYMORE" )
	end
end)



-- Role Reset
function CheckIfRoleExists(ply, ruid)
	local result = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. ruid .. "'" )

	if result == nil then
		YRP.msg( "note", "character role not exists anymore! Change back to default role!" )
		
		YRP_SQL_UPDATE( "yrp_characters", {
			["roleID"] = 1,
			["groupID"] = 1
		}, "uniqueID = '" .. ply:CharID() .. "'" )

		ply:OldKillSilent()
	end
end

function GetRoleTable(rid)
	local result = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. rid .. "'" )
	if wk(result) then
		result = result[1]
	end
	return result
end

util.AddNetworkString( "getallroles" )
net.Receive( "getallroles", function(len, ply)
	local dbtab = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, string_name", nil)
	if wk( dbtab) then
		for i, v in pairs( dbtab) do
			local pms = string.Explode( ",", GetPlayermodelsOfRole( v.uniqueID) )
			if pms[1] != nil then
				dbtab[i].WorldModel = pms[1] or ""
			else
				dbtab[i].WorldModel = ""
			end
		end

		net.Start( "getallroles" )
			net.WriteTable( dbtab)
		net.Send(ply)
	end
end)

util.AddNetworkString( "get_next_ranks" )
net.Receive( "get_next_ranks", function(len, ply)
	local ruid = net.ReadString()
	local rols = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '" .. ruid .. "'" )

	if wk(rols) then
		for i, rol in pairs(rols) do
			rols[i].pms = string.Explode( ",", GetPlayermodelsOfRole(rol.uniqueID) )
		end

		net.Start( "get_next_ranks" )
			net.WriteTable(rols)
		net.Send(ply)
	end
end)

util.AddNetworkString( "yrp_hasnext_ranks" )
net.Receive( "yrp_hasnext_ranks", function(len, ply)
	local ruid = net.ReadString()
	local rols = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '" .. ruid .. "'" )

	local has = false
	if wk(rols) then
		has = true
	end

	net.Start( "yrp_hasnext_ranks" )
		net.WriteString(ruid)
		net.WriteBool(has)
	net.Send(ply)
end)

util.AddNetworkString( "yrp_want_role" )
net.Receive( "yrp_want_role", function(len, ply)
	local ruid = net.ReadString()
	ruid = tonumber(ruid)
	local rol = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. ruid .. "'" )
	local result = "Role dont exists anymore"
	if wk(rol) then
		if canGetRole(ply, ruid, true) then
			result = "worked"
		else
			result = "LID_youarenotwhitelisted"
		end
	end

	net.Start( "yrp_want_role" )
		net.WriteString(result)
	net.Send(ply)
end)

function YRPSendRoleSpecs(ply, ruid)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "string_specializations", "uniqueID = '" .. ruid .. "'" )
	if wk(tab) then
		tab = tab[1]

		local nettab = {}

		for i, v in pairs( string.Explode( ",", tab.string_specializations ) ) do
			local dbtab = YRP_SQL_SELECT( "yrp_specializations", "*", "uniqueID = '" .. v .. "'" )
			if wk( dbtab) then
				local entry = {}
				entry.uid = v
				entry.name = dbtab[1].name

				table.insert( nettab, entry )
			end
		end

		net.Start( "get_role_specs" )
			net.WriteTable(nettab)
		net.Send(ply)
	end
end

util.AddNetworkString( "get_role_specs" )
net.Receive( "get_role_specs", function(len, ply)
	local ruid = net.ReadString()
	YRPSendRoleSpecs(ply, ruid)
end)



-- For Custom Charsystems
util.AddNetworkString( "yrp_getallroles" )
net.Receive( "yrp_getallroles", function( len, ply )
	local roles = YRP_SQL_SELECT( DATABASE_NAME, "*", nil )

	if wk( roles ) then
		for i, role in pairs( roles ) do
			role.pms = GetPlayermodelsOfRole( role.uniqueID )
			net.Start( "yrp_getallroles" )
				net.WriteTable( role )
			net.Send( ply )
		end
	end
end )

util.AddNetworkString( "yrp_getallroles_whitelisted" )
net.Receive( "yrp_getallroles_whitelisted", function( len, ply )
	local roles = YRP_SQL_SELECT( DATABASE_NAME, "*", nil )

	if wk( roles ) then
		for i, role in pairs( roles ) do
			role.pms = GetPlayermodelsOfRole( role.uniqueID )
			if YRPIsWhitelisted( ply, role.uniqueID ) then
				net.Start( "yrp_getallroles_whitelisted" )
					net.WriteTable( role )
				net.Send( ply )
			end
		end
	end
end )

util.AddNetworkString( "yrp_getcharacters" )
net.Receive( "yrp_getcharacters", function( len, ply )
	local chars = YRP_SQL_SELECT( "yrp_characters", "*", "steamid = '" .. ply:YRPSteamID() .. "'" )

	if wk( chars ) then
		for i, char in pairs( chars ) do
			local role = YRP_SQL_SELECT( "yrp_ply_roles", "uniqueID, string_name, string_color", "uniqueID = '" .. char.roleID .. "'" )
			if role and role[1] then
				char.rolename = role[1].string_name
				char.rolecolor = StringToColor( role[1].string_color )
			end
			local group = YRP_SQL_SELECT( "yrp_ply_groups", "uniqueID, string_name, string_color", "uniqueID = '" .. char.groupID .. "'" )
			if group and group[1] then
				char.groupname = group[1].string_name
				char.groupcolor = StringToColor( group[1].string_color )
			end
			char.playermodels = GetPlayermodelsOfRole( char.roleID )

			net.Start( "yrp_getcharacters" )
				net.WriteTable( char )
			net.Send( ply )
		end
	end
end )
