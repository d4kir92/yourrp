--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_design"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_hud_design", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_interface_design", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_fontname", "TEXT DEFAULT 'Impact'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_hud_profile", "TEXT DEFAULT 'YourRP Default'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_headerheight", "INT DEFAULT '100'")
local fir = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1")
if fir == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_hud_design, string_interface_design, string_fontname", "'Simple', 'Material', 'Roboto'")
elseif IsNotNilAndNotFalse(fir) then
	fir = fir[1]
	if fir.string_interface_design == "Simple" or fir.string_hud_design == "Material" then
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_hud_design"] = "Simple"
			}, "uniqueID = '" .. "1" .. "'"
		)

		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_interface_design"] = "Material"
			}, "uniqueID = '" .. "1" .. "'"
		)
	end
end

--YRP_SQL_DROPTABLE(DATABASE_NAME)
local HUDS = {}
function YRPGetHUDs()
	hook.Run("RegisterHUDDesign")

	return HUDS
end

function RegisterHUDDesign(tab)
	if tab.name == nil then
		YRP.msg("note", "RegisterDesign Failed! Missing Design Name")

		return false
	elseif tab.author == nil then
		YRP.msg("note", "RegisterDesign Failed! Missing Design Author")

		return false
	end

	if HUDS[tab.name] == nil then
		YRP.msg("note", "[RegisterDesign] Registered HUD: " .. tostring(tab.name))
		HUDS[tab.name] = tab
	end

	return true
end

hook.Add(
	"RegisterHUDDesign",
	"RegisterHUDDesign_none",
	function()
		local HUD_None = {}
		HUD_None.name = "Disabled"
		HUD_None.author = "YourRP"
		HUD_None.progress = 100
		RegisterHUDDesign(HUD_None)
	end
)

hook.Add(
	"RegisterHUDDesign",
	"RegisterHUDDesign_simple",
	function()
		local HUD_Simple = {}
		HUD_Simple.name = "Simple"
		HUD_Simple.author = "D4KiR"
		HUD_Simple.progress = 100
		RegisterHUDDesign(HUD_Simple)
	end
)

hook.Add(
	"RegisterHUDDesign",
	"RegisterHUDDesign_space",
	function()
		local HUD_Space = {}
		HUD_Space.name = "Space"
		HUD_Space.author = "D4KiR"
		HUD_Space.progress = 90
		RegisterHUDDesign(HUD_Space)
	end
)

hook.Add(
	"RegisterHUDDesign",
	"RegisterHUDDesign_fallout_76",
	function()
		local HUD_FO76 = {}
		HUD_FO76.name = "Fallout 76"
		HUD_FO76.author = "D4KiR"
		HUD_FO76.progress = 100
		RegisterHUDDesign(HUD_FO76)
	end
)

hook.Add(
	"RegisterHUDDesign",
	"RegisterHUDDesign_icons",
	function()
		local HUD_Icons = {}
		HUD_Icons.name = "Icons"
		HUD_Icons.author = "D4KiR"
		HUD_Icons.progress = 100
		RegisterHUDDesign(HUD_Icons)
	end
)

hook.Add(
	"RegisterHUDDesign",
	"RegisterHUDDesign_circles",
	function()
		local HUD_Circles = {}
		HUD_Circles.name = "Circles"
		HUD_Circles.author = "D4KiR"
		HUD_Circles.progress = 90
		RegisterHUDDesign(HUD_Circles)
	end
)

hook.Add(
	"RegisterHUDDesign",
	"RegisterHUDDesign_Thin",
	function()
		local HUD_Thin = {}
		HUD_Thin.name = "Thin"
		HUD_Thin.author = "D4KiR"
		HUD_Thin.progress = 100
		RegisterHUDDesign(HUD_Thin)
	end
)

local HUDMASKS = {}
function YRPGetHUDMasks()
	hook.Run("RegisterHUDMASKDesign")

	return HUDMASKS
end

function RegisterHUDMASKDesign(tab)
	if tab.name == nil then
		YRP.msg("note", "RegisterHUDMASKDesign Failed! Missing Design Name")

		return false
	elseif tab.author == nil then
		YRP.msg("note", "RegisterHUDMASKDesign Failed! Missing Design Author")

		return false
	end

	if HUDMASKS[tab.name] == nil then
		YRP.msg("note", "[RegisterHUDMASKDesign] Registered HUD: " .. tostring(tab.name))
		HUDMASKS[tab.name] = tab
	end

	return true
end

--[[ LOADOUT ]]
--
function YRPDesignLoadout(from)
	--self:HudLoadout()
	--self:InterfaceLoadout()
	local setting = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if IsNotNilAndNotFalse(setting) then
		setting = setting[1]
		SetGlobalYRPString("string_hud_design", setting.string_hud_design)
		SetGlobalYRPString("string_interface_design", setting.string_interface_design)
		SetGlobalYRPString("string_hud_profile", setting.string_hud_profile)
		SetGlobalYRPInt("int_headerheight", setting.int_headerheight)
	else
		YRP.msg("note", "Fatal Error: Design Settings not found")
	end
end

YRPDesignLoadout("Init")
local once = false
util.AddNetworkString("nws_yrp_ply_changed_resolution")
net.Receive(
	"nws_yrp_ply_changed_resolution",
	function(len, ply)
		--YRP.msg( "note", ply:YRPName() .. " changed the Resolution." )
		if not once then
			once = true

			return
		end

		timer.Simple(
			1,
			function()
				if IsValid(ply) then
					SetGlobalYRPInt("YRPHUDVersion", -2)
				end
			end
		)

		timer.Simple(
			2,
			function()
				if IsValid(ply) then
					SetGlobalYRPInt("YRPHUDVersion", -1)
				end
			end
		)
	end
)

util.AddNetworkString("nws_yrp_change_hud_design")
net.Receive(
	"nws_yrp_change_hud_design",
	function(len, ply)
		local string_hud_design = net.ReadString()
		YRP.msg("db", "[DESIGN] string_hud_design changed to " .. string_hud_design)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_hud_design"] = string_hud_design
			}, "uniqueID = '1'"
		)

		SetGlobalYRPString("string_hud_design", string_hud_design)
	end
)

-- Interface
INTERFACES = INTERFACES or {}
function RegisterInterfaceDesign(tab)
	if tab.name == nil then
		YRP.msg("note", "RegisterDesign Failed! Missing Design Name")

		return false
	elseif tab.author == nil then
		YRP.msg("note", "RegisterDesign Failed! Missing Design Author")

		return false
	end

	INTERFACES[tab.name] = tab
	--YRP.msg( "db", "Added Interface Design ( " .. tostring(tab.name) .. " )" )

	return true
end

local IF_Material = {}
IF_Material.name = "Material"
IF_Material.author = "D4KiR"
IF_Material.progress = 100
RegisterInterfaceDesign(IF_Material)
local IF_Blur = {}
IF_Blur.name = "Blur"
IF_Blur.author = "D4KiR"
IF_Blur.progress = 50
RegisterInterfaceDesign(IF_Blur)
util.AddNetworkString("nws_yrp_change_interface_design")
net.Receive(
	"nws_yrp_change_interface_design",
	function(len, ply)
		local string_interface_design = net.ReadString()
		YRP.msg("db", "[DESIGN] string_interface_design changed to " .. string_interface_design)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_interface_design"] = string_interface_design
			}, "uniqueID = '1'"
		)

		SetGlobalYRPString("string_interface_design", string_interface_design)
		ResetDesign()
	end
)

-- F8 Design Page
util.AddNetworkString("nws_yrp_get_design_settings")
net.Receive(
	"nws_yrp_get_design_settings",
	function(len, ply)
		if ply:CanAccess("bool_design") then
			hook.Call("RegisterHUDDesign")
			local setting = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
			local hud_profiles = GetHudProfiles()
			if IsNotNilAndNotFalse(setting) then
				setting = setting[1]
				net.Start("nws_yrp_get_design_settings")
				net.WriteTable(setting)
				net.WriteTable(HUDS)
				net.WriteTable(INTERFACES)
				net.WriteTable(hud_profiles)
				net.Send(ply)
			end
		end
	end
)

util.AddNetworkString("nws_yrp_set_font")
function YRPSendFontName(ply)
	local dbtab = YRP_SQL_SELECT(DATABASE_NAME, "string_fontname", "uniqueID = '1'")
	if IsNotNilAndNotFalse(dbtab) then
		dbtab = dbtab[1]
		net.Start("nws_yrp_set_font")
		net.WriteString(dbtab.string_fontname)
		net.Send(ply)
	end
end

net.Receive(
	"nws_yrp_set_font",
	function(len, ply)
		YRPSendFontName(ply)
	end
)

util.AddNetworkString("nws_yrp_update_font")
net.Receive(
	"nws_yrp_update_font",
	function(len, ply)
		local string_fontname = net.ReadString()
		YRP.msg("db", "[DESIGN] string_fontname changed to " .. string_fontname)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_fontname"] = string_fontname
			}, "uniqueID = '1'"
		)

		for i, p in pairs(player.GetAll()) do
			YRPSendFontName(p)
		end
	end
)

util.AddNetworkString("nws_yrp_change_headerheight")
net.Receive(
	"nws_yrp_change_headerheight",
	function(len, ply)
		local newheaderheight = net.ReadString()
		newheaderheight = tonumber(newheaderheight)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_headerheight"] = newheaderheight
			}, "uniqueID = '1'"
		)

		SetGlobalYRPInt("int_headerheight", newheaderheight)
	end
)