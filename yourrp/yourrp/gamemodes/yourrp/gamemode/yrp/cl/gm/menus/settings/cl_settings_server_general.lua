--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function CreateCheckBoxLine(dpanellist, val, lstr, netstr, fixx, textcolor)
	textcolor = textcolor or Color(255, 255, 255, 255)
	fixx = fixx or 0
	local background = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(50), 0, 0)
	background.text_posx = YRP:ctr(50 + 10)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, "", nil, self.text_posx + YRP:ctr(fixx), nil, 0, 1)
		draw.SimpleText(YRP:trans(lstr), "Y_16_500", self.text_posx + YRP:ctr(fixx), ph / 2, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	background.checkbox = YRPCreateD("DCheckBox", background, YRP:ctr(50), YRP:ctr(50), 0 + YRP:ctr(fixx), 0)
	background.checkbox:SetValue(val)
	function background.checkbox:Paint(pw, ph)
		surfaceCheckBox(self, pw, ph, "done")
	end

	background.checkbox.serverside = false
	function background.checkbox:OnChange(bVal)
		if not self.serverside then
			net.Start(netstr)
			net.WriteBool(bVal)
			net.SendToServer()
		end
	end

	net.Receive(
		netstr,
		function(len)
			local b = net.ReadString()
			if YRPPanelAlive(background.checkbox) then
				background.checkbox.serverside = true
				background.checkbox:SetValue(b)
				background.checkbox.serverside = false
			end
		end
	)

	dpanellist:AddItem(background)

	return background
end

function CreateCheckBoxLineTab(dpanellist, val, lstr, netstr, x)
	local cb = CreateCheckBoxLine(dpanellist, val, lstr, netstr)
	cb.checkbox:SetPos(x or YRP:ctr(50), YRP:ctr(0))
	cb.text_posx = x or YRP:ctr(50)
	cb.text_posx = cb.text_posx + YRP:ctr(50 + 10)
end

function CreateButtonLine(dpanellist, lstr, netstr, lstr2)
	local background = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP:trans(lstr) .. ":", nil, YRP:ctr(10), ph * 1 / 4, 0, 1)
	end

	background.button = YRPCreateD("YButton", background, dpanellist:GetWide() - YRP:ctr(10 * 2), YRP:ctr(50), YRP:ctr(10), YRP:ctr(50))
	background.button:SetText("")
	background.button.text = lstr2 or lstr
	background.button.tab = {
		["text"] = ""
	}

	function background.button:Paint(pw, ph)
		hook.Run(
			"YButtonPaint",
			self,
			pw,
			ph,
			{
				["text"] = YRP:trans(self.text),
				["color"] = Color(200, 200, 200, 255)
			}
		)
	end

	function background.button:DoClick()
		net.Start(netstr)
		net.SendToServer()
	end

	dpanellist:AddItem(background)

	return background
end

function CreateTextBoxLine(dpanellist, text, lstr, netstr)
	local background = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP:trans(lstr) .. ":", nil, YRP:ctr(10), ph * 1 / 4, 0, 1)
	end

	local textbox = YRPCreateD("DTextEntry", background, dpanellist:GetWide() - YRP:ctr(10 * 2), YRP:ctr(50), YRP:ctr(10), YRP:ctr(50))
	if text then
		textbox:SetText(text)
	end

	textbox.serverside = false
	function textbox:OnChange()
		if not self.serverside then
			net.Start(netstr)
			net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(
		netstr,
		function(len)
			local tex = net.ReadString()
			if YRPPanelAlive(textbox) then
				textbox.serverside = true
				textbox:SetText(tex)
				textbox.serverside = false
			end
		end
	)

	dpanellist:AddItem(background)

	return background
end

function CreateComboBoxLine(dpanellist, text, lstr, netstr, default, choices)
	local background = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP:trans(lstr) .. ":", nil, YRP:ctr(10), ph * 1 / 4, 0, 1)
	end

	local combobox = YRPCreateD("DComboBox", background, dpanellist:GetWide() - YRP:ctr(10 * 2), YRP:ctr(50), YRP:ctr(10), YRP:ctr(50))
	combobox.serverside = false
	for id, v in pairs(choices) do
		local selected = false
		if v == default then
			selected = true
		end

		combobox:AddChoice(v, id, selected)
	end

	function combobox:OnSelect(index, value)
		if not self.serverside then
			net.Start(netstr)
			net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(
		netstr,
		function(len)
			local tex = net.ReadString()
			if YRPPanelAlive(combobox) then
				combobox.serverside = true
				combobox:SetText(tex)
				combobox.serverside = false
			end
		end
	)

	dpanellist:AddItem(background)

	return background
end

function CreateTextBoxBox(dpanellist, text, lstr, netstr)
	text = YRP_SQL_STR_OUT(text)
	local background = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(50 + 400 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP:trans(lstr) .. ":", nil, YRP:ctr(10), YRP:ctr(25), 0, 1)
	end

	local textbox = YRPCreateD("DTextEntry", background, dpanellist:GetWide() - YRP:ctr(10 * 2), YRP:ctr(400), YRP:ctr(10), YRP:ctr(50))
	textbox:SetText(text)
	textbox:SetMultiline(true)
	textbox.serverside = false
	function textbox:OnChange()
		if not self.serverside then
			net.Start(netstr)
			net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(
		netstr,
		function(len)
			local tex = net.ReadString()
			if YRPPanelAlive(textbox) then
				textbox.serverside = true
				textbox:SetText(tex)
				textbox.serverside = false
			end
		end
	)

	dpanellist:AddItem(background)

	return background
end

function CreateTextBoxLineSpecial(dpanellist, text, text2, lstr, netstr, netstr2)
	local background = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP:trans(lstr) .. ": ( " .. GetGlobalYRPString("text_money_pre", "") .. "100" .. GetGlobalYRPString("text_money_pos", "") .. " )", nil, YRP:ctr(10), ph * 1 / 4, 0, 1)
	end

	background.textbox = YRPCreateD("DTextEntry", background, YRP:ctr(400) - YRP:ctr(10 * 2), YRP:ctr(50), YRP:ctr(10), YRP:ctr(50))
	background.textbox:SetText(text or "MISSING")
	background.textbox.serverside = false
	function background.textbox:OnChange()
		if not self.serverside then
			net.Start(netstr)
			net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(
		netstr,
		function(len)
			local tex = net.ReadString()
			if YRPPanelAlive(background.textbox) then
				background.textbox.serverside = true
				background.textbox:SetText(tex)
				background.textbox.serverside = false
			end
		end
	)

	background.textbox2 = YRPCreateD("DTextEntry", background, YRP:ctr(400) - YRP:ctr(10 * 2), YRP:ctr(50), YRP:ctr(10 + 400), YRP:ctr(50))
	background.textbox2:SetText(text2 or "MISSING")
	background.textbox2.serverside = false
	function background.textbox2:OnChange()
		if not self.serverside then
			net.Start(netstr2)
			net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(
		netstr2,
		function(len)
			local tex = net.ReadString()
			if YRPPanelAlive(background.textbox2) then
				background.textbox2.serverside = true
				background.textbox2:SetText(tex)
				background.textbox2.serverside = false
			end
		end
	)

	dpanellist:AddItem(background)

	return background
end

function CreateNumberWangLine(dpanellist, value, lstr, netstr, fixx, max, min)
	local background = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP:trans(lstr) .. ":", nil, YRP:ctr(10) + YRP:ctr(fixx), ph * 1 / 4, 0, 1)
	end

	background.numberwang = YRPCreateD("DNumberWang", background, dpanellist:GetWide() - YRP:ctr(20 * 2) - YRP:ctr(fixx), YRP:ctr(50), YRP:ctr(10) + YRP:ctr(fixx), YRP:ctr(50))
	background.numberwang:SetMax(max or 999999999999)
	background.numberwang:SetMin(min or -999999999999)
	background.numberwang:SetValue(value)
	background.numberwang.serverside = false
	function background.numberwang:OnChange()
		if not self.serverside then
			local num = tonumber(self:GetValue())
			local vmax = self:GetMax()
			local vmin = self:GetMin()
			if num >= vmin and num <= vmax then
				net.Start(netstr)
				net.WriteString(num)
				net.SendToServer()
			else
				if num > vmax then
					self:SetText(vmax)
					num = vmax
				elseif num < vmin then
					self:SetText(vmin)
					num = vmin
				end

				net.Start(netstr)
				net.WriteString(num)
				net.SendToServer()
			end
		end
	end

	net.Receive(
		netstr,
		function(len)
			local val = net.ReadString()
			if YRPPanelAlive(background.numberwang) then
				background.numberwang.serverside = true
				background.numberwang:SetValue(val)
				background.numberwang.serverside = false
			end
		end
	)

	dpanellist:AddItem(background)

	return background
end

function CreateHRLine(dpanellist)
	local hr = YRPCreateD("DPanel", nil, dpanellist:GetWide(), YRP:ctr(20), 0, 0)
	function hr:Paint(pw, ph)
		surfacePanel(self, pw, ph, "")
		draw.RoundedBox(0, YRP:ctr(10), hr:GetTall() / 4, hr:GetWide() - YRP:ctr(2 * 10), hr:GetTall() / 2, Color(0, 0, 0, 255))
	end

	dpanellist:AddItem(hr)

	return hr
end

function AddToTabRecursive(tab, folder, path, wildcard)
	local files, folders = file.Find(folder .. "*", path)
	if files then
		for k, v in pairs(files) do
			if not string.EndsWith(v, ".mdl") then continue end
			if not table.HasValue(tab, folder .. v) then
				table.insert(tab, folder .. v)
			end
		end
	end

	if folders then
		for k, v in pairs(folders) do
			AddToTabRecursive(tab, folder .. v .. "/", path, wildcard)
		end
	end
end

net.Receive(
	"nws_yrp_connect_Settings_General",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			function PARENT:OnRemove()
				net.Start("nws_yrp_disconnect_Settings_General")
				net.SendToServer()
			end

			local GEN = net.ReadTable()
			local General_Slider = YRPCreateD("DHorizontalScroller", PARENT, PARENT:GetWide() - YRP:ctr(2 * 20), PARENT:GetTall() - YRP:ctr(2 * 20), YRP:ctr(20), YRP:ctr(20))
			General_Slider:SetOverlap(-YRP:ctr(20))
			function General_Slider:Paint(pw, ph)
				if self.w ~= PARENT:GetWide() or self.h ~= PARENT:GetTall() then
					self.w = PARENT:GetWide()
					self.w = PARENT:GetTall()
					self:SetSize(PARENT:GetWide() - YRP:ctr(2 * 20), PARENT:GetTall() - YRP:ctr(2 * 20))
					self:SetPos(YRP:ctr(20), YRP:ctr(20))
				end
			end

			--[[ SERVER SETTINGS ]]
			--
			local SERVER_SETTINGS = YRPCreateD("YGroupBox", Server_Settings, YRP:ctr(800), General_Slider:GetTall(), 0, 0)
			SERVER_SETTINGS:SetText("LID_serversettings")
			function SERVER_SETTINGS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			General_Slider:AddPanel(SERVER_SETTINGS)
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_server_reload, "LID_automaticreloadingoftheserver", "nws_yrp_update_bool_server_reload")
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_server_reload_notification, YRP:trans("LID_automaticreloadingoftheserver") .. " (Notification)", "nws_yrp_update_bool_server_reload_notification")
			CreateHRLine(SERVER_SETTINGS:GetContent())
			CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_name, "LID_hostname", "nws_yrp_update_text_server_name")
			CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_logo, "LID_serverlogo", "nws_yrp_update_text_server_logo")
			--[LATER] CreateHRLine(SERVER_SETTINGS:GetContent() )
			--[LATER] local community_servers = CreateButtonLine(SERVER_SETTINGS:GetContent(), "LID_communityservers", "nws_yrp_update_community_servers" )
			CreateHRLine(SERVER_SETTINGS:GetContent())
			CreateTextBoxBox(SERVER_SETTINGS:GetContent(), GEN.text_server_rules, "LID_rules", "nws_yrp_update_text_server_rules")
			CreateHRLine(SERVER_SETTINGS:GetContent())
			CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_welcome_message, "LID_welcomemessage", "nws_yrp_update_text_server_welcome_message")
			CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_message_of_the_day, "LID_messageoftheday", "nws_yrp_update_text_server_message_of_the_day")
			CreateHRLine(SERVER_SETTINGS:GetContent())
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_gm, "Console Gamemode (GM)", "nws_yrp_update_bool_msg_channel_gm")
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_db, "Console Database (DB)", "nws_yrp_update_bool_msg_channel_db")
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_l, "Console Language (LANG)", "nws_yrp_update_bool_msg_channel_l")
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_n, "Console Notification (NOTI)", "nws_yrp_update_bool_msg_channel_n")
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_darkrp, "Console DarkRP (DarkRP)", "nws_yrp_update_bool_msg_channel_darkrp")
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_c, "Console Chat (CHAT)", "nws_yrp_update_bool_msg_channel_c")
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_debug, "Console DEBUG (DEBUG)", "nws_yrp_update_bool_msg_channel_debug")
			CreateHRLine(SERVER_SETTINGS:GetContent())
			CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_server_debug_voice, "Voice DEBUG", "nws_yrp_update_bool_server_debug_voice")
			--[[ GAMEMODE SETTINGS ]]
			--
			local GAMEMODE_SETTINGS = YRPCreateD("YGroupBox", Gamemode_Settings, YRP:ctr(1000), General_Slider:GetTall(), 0, 0)
			GAMEMODE_SETTINGS:SetText("LID_gamemodesettings")
			function GAMEMODE_SETTINGS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			General_Slider:AddPanel(GAMEMODE_SETTINGS)
			CreateTextBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.text_gamemode_name, "LID_gamemodename", "nws_yrp_update_text_gamemode_name")
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_graffiti_disabled, "LID_graffitidisabled", "nws_yrp_update_bool_graffiti_disabled")
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_suicide_disabled, "LID_suicidedisabled", "nws_yrp_update_bool_suicide_disabled")
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_team_set, "SetTeam for Roles(TEAM_) (required for some DarkRP addons)", "nws_yrp_update_bool_team_set")
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_team_color, "TEAM Color", "nws_yrp_update_bool_team_color")
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_antipropkill, "LID_antipropkill", "nws_yrp_update_bool_antipropkill")
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_drop_items_on_death, "LID_dropitemsondeath", "nws_yrp_update_bool_drop_items_on_death")
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_drop_items_role, "LID_droproleitems", "nws_yrp_update_bool_drop_items_role")
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_players_can_YRPDropWeapons, "LID_playerscandropweapons", "nws_yrp_update_bool_players_can_YRPDropWeapons")
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_players_start_with_default_role, "LID_playersstartwithdefaultrole", "nws_yrp_update_bool_players_start_with_default_role", nil, Color(255, 0, 0, 255))
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_dealers_can_take_damage, "LID_dealerscantakedamage", "nws_yrp_update_bool_dealers_can_take_damage")
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_thirdperson, "LID_tpp", "nws_yrp_update_bool_thirdperson")
			local text_view_distance = CreateNumberWangLine(GAMEMODE_SETTINGS:GetContent(), GEN.text_view_distance, "LID_thirdpersonmaxdistance", "nws_yrp_update_text_view_distance")
			text_view_distance.numberwang:SetMax(9999)
			text_view_distance.numberwang:SetMin(-200)
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_canbeowned, YRP:trans("LID_buildingsystem") .. ": " .. YRP:trans("LID_canbeowned"), "nws_yrp_update_bool_canbeowned")
			CreateCheckBoxLineTab(GAMEMODE_SETTINGS:GetContent(), GEN.bool_removebuildingowner, "LID_removethebuildingowneratdisconnect", "nws_yrp_update_bool_removebuildingowner")
			CreateCheckBoxLineTab(GAMEMODE_SETTINGS:GetContent(), GEN.bool_removebuildingownercharswitch, "LID_removethebuildingowneratcharswitch", "nws_yrp_update_bool_removebuildingownercharswitch")
			CreateNumberWangLine(GAMEMODE_SETTINGS:GetContent(), GEN.text_removebuildingownertime, "LID_timeremovethebuildingowneratdisconnect", "nws_yrp_update_text_removebuildingownertime", 50)
			CreateHRLine(GAMEMODE_SETTINGS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_autopickup, "LID_autopickup", "nws_yrp_update_bool_autopickup")
			CreateNumberWangLine(GAMEMODE_SETTINGS:GetContent(), GEN.int_ttlsweps, "LID_ttlsweps", "nws_yrp_update_int_ttlsweps")
			CreateNumberWangLine(GAMEMODE_SETTINGS:GetContent(), GEN.int_afkkicktime, "LID_afkkicktime", "nws_yrp_update_int_afkkicktime")
			--[[ GAMEMODE SYSTEMS ]]
			--
			local GAMEMODE_SYSTEMS = YRPCreateD("YGroupBox", General_Slider, YRP:ctr(800), General_Slider:GetTall(), 0, 0)
			GAMEMODE_SYSTEMS:SetText("LID_gamemodesystems")
			function GAMEMODE_SYSTEMS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			General_Slider:AddPanel(GAMEMODE_SYSTEMS)
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_onlywhencook, "LID_onlywhencook", "nws_yrp_update_bool_onlywhencook")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_hunger, "LID_hunger", "nws_yrp_update_bool_hunger")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_thirst, "LID_thirst", "nws_yrp_update_bool_thirst")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_permille, "LID_permille", "nws_yrp_update_bool_permille")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_stamina, "LID_stamina", "nws_yrp_update_bool_stamina")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_radiation, "LID_radiation", "nws_yrp_update_bool_radiation")
			CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_character_system, "LID_charactersystem", "nws_yrp_update_bool_character_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_building_system, "LID_buildingsystem", "nws_yrp_update_bool_building_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_building_system, "LID_buildingsystem_3d", "nws_yrp_update_bool_building_system_3d")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_allbuildingsunlocked, "LID_allbuildingsunlocked", "nws_yrp_update_bool_allbuildingsunlocked")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_securitylevel_system, "LID_securitylevelsystem", "nws_yrp_update_bool_securitylevel_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_inventory_system, "LID_inventorysystem", "nws_yrp_update_bool_inventory_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_realistic_system, "LID_realisticsystem", "nws_yrp_update_bool_realistic_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_level_system, "LID_levelsystem", "nws_yrp_update_bool_level_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_weapon_system, "LID_weaponsystem", "nws_yrp_update_bool_weapon_system")
			local wc_mdl = CreateButtonLine(GAMEMODE_SYSTEMS:GetContent(), YRP:trans("LID_weaponchest") .. " ( " .. YRP:trans("LID_model") .. " )", "nws_yrp_update_text_weaponchest_model", "LID_change")
			function YRPWeaponchestUpdateModel()
				local mdl = LocalPlayer().yrpseltab[1]
				if mdl then
					net.Start("nws_yrp_update_text_weapon_system_model")
					net.WriteString(mdl)
					net.SendToServer()
				end
			end

			function wc_mdl.button:DoClick()
				local noneplayermodels = {}
				AddToTabRecursive(noneplayermodels, "models/", "GAME", "*.mdl")
				for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
					if not addon.downloaded or not addon.mounted then continue end
					AddToTabRecursive(noneplayermodels, "models/", addon.title, "*.mdl")
				end

				local cl_pms = {}
				local c = 0
				for k, v in pairs(noneplayermodels) do
					c = c + 1
					cl_pms[c] = {}
					cl_pms[c].WorldModel = v
					cl_pms[c].ClassName = v
					cl_pms[c].PrintName = v
				end

				YRPOpenSelector(cl_pms, false, "worldmodel", YRPWeaponchestUpdateModel)
			end

			CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_identity_card, "LID_identitycard", "nws_yrp_update_bool_identity_card")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_map_system, "LID_map", "nws_yrp_update_bool_map_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_laws_system, "LID_laws", "nws_yrp_update_bool_laws_system")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_appearance_system, "LID_appearancesystem", "nws_yrp_update_bool_appearance_system")
			local wc_mdl_f = CreateButtonLine(GAMEMODE_SYSTEMS:GetContent(), YRP:trans("LID_appearance") .. " ( " .. YRP:trans("LID_model") .. " )", "nws_yrp_update_text_appearance_model", "LID_change")
			function YRPAppearanceUpdateModel()
				local mdl = LocalPlayer().yrpseltab[1]
				if mdl then
					net.Start("nws_yrp_update_text_appearance_model")
					net.WriteString(mdl)
					net.SendToServer()
				end
			end

			function wc_mdl_f.button:DoClick()
				local noneplayermodels = {}
				AddToTabRecursive(noneplayermodels, "models/", "GAME", "*.mdl")
				for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
					if not addon.downloaded or not addon.mounted then continue end
					AddToTabRecursive(noneplayermodels, "models/", addon.title, "*.mdl")
				end

				local cl_pms = {}
				local c = 0
				for k, v in pairs(noneplayermodels) do
					c = c + 1
					cl_pms[c] = {}
					cl_pms[c].WorldModel = v
					cl_pms[c].ClassName = v
					cl_pms[c].PrintName = v
				end

				YRPOpenSelector(cl_pms, false, "worldmodel", YRPAppearanceUpdateModel)
			end

			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_smartphone_system, "LID_smartphonesystem", "nws_yrp_update_bool_smartphone_system")
			CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_wanted_system, "LID_wantedsystem", "nws_yrp_update_bool_wanted_system")
			CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_players_can_switch_faction, "LID_playerscanswitchfaction", "nws_yrp_update_bool_players_can_switch_faction")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_players_can_switch_role, "LID_playerscanswitchrole", "nws_yrp_update_bool_players_can_switch_role")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_players_die_on_role_switch, "LID_playersdieonroleswitch", "nws_yrp_update_bool_players_die_on_role_switch")
			CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice, "LID_voicechat", "nws_yrp_update_bool_voice")
			CreateCheckBoxLineTab(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_module, YRP:trans("LID_voicemodule") .. " (YourRP)", "nws_yrp_update_bool_voice_module")
			CreateCheckBoxLineTab(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_module_locally, YRP:trans("LID_voicemodule") .. " (YourRP) [" .. YRP:trans("local") .. "]", "nws_yrp_update_bool_voice_module_locally")
			CreateNumberWangLine(GAMEMODE_SYSTEMS:GetContent(), GEN.int_voice_max_range, YRP:trans("LID_maxvoicerange"), "nws_yrp_update_int_voice_max_range", 50)
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_3d, YRP:trans("LID_voicechat") .. " (3D)", "nws_yrp_update_bool_voice_3d")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_idcardid, "IDCardID in Voicechat", "nws_yrp_update_bool_voice_idcardid")
			CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_gmod_voice_module, YRP:trans("LID_voicemodule") .. " (GMOD)", "nws_yrp_update_bool_gmod_voice_module")
			--[[ GAMEMODE VISUALS ]]
			--
			local GAMEMODE_VISUALS = YRPCreateD("YGroupBox", General_Slider, YRP:ctr(800), General_Slider:GetTall(), 0, 0)
			GAMEMODE_VISUALS:SetText("LID_gamemodevisuals")
			function GAMEMODE_VISUALS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			General_Slider:AddPanel(GAMEMODE_VISUALS)
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_combined_menu, "LID_combinedmenu", "nws_yrp_update_bool_yrp_combined_menu")
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_role_menu, "LID_rolemenu", "nws_yrp_update_bool_yrp_role_menu")
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_help_menu, "LID_helpmenu", "nws_yrp_update_bool_yrp_help_menu")
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_buy_menu, "LID_buymenu", "nws_yrp_update_bool_yrp_buy_menu")
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_char_menu, "LID_charactermenu", "nws_yrp_update_bool_yrp_char_menu")
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_keybinds_menu, "LID_keybindsmenu", "nws_yrp_update_bool_yrp_keybinds_menu")
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_tickets_menu, "LID_ticketsmenu", "nws_yrp_update_bool_yrp_tickets_menu")
			CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_appearance_system, "LID_macromenu", "nws_yrp_update_bool_yrp_macro_menu")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateTextBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.text_character_background, "LID_character_background", "nws_yrp_update_text_character_background")
			CreateComboBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.text_character_design, "LID_characterdesign", "nws_yrp_update_text_character_design", GetGlobalYRPString("text_character_design", "Default"), {"Default", "HorizontalNEW", "Horizontal", "Vertical"})
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat_commands, "YourRP Chat Commands", "nws_yrp_update_bool_yrp_chat_commands")
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat, "LID_yourrpchat", "nws_yrp_update_bool_yrp_chat")
			CreateNumberWangLine(GAMEMODE_VISUALS:GetContent(), GEN.int_yrp_chat_range_local, YRP:trans("LID_localchatrange"), "nws_yrp_update_int_yrp_chat_range_local", 50, 1000, 20)
			CreateTextBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.text_idstructure, YRP:trans("LID_idstructure") .. " (!D 1Dig., !L 1Let., !N 1Num.)", "nws_yrp_update_text_idstructure")
			CreateTextBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.text_idcard_background, YRP:trans("LID_background") .. " ( " .. YRP:trans("LID_idcard") .. " )", "nws_yrp_update_text_idcard_background")
			local gs = 8
			local idcard_change = YRPCreateD("YButton", GAMEMODE_VISUALS:GetContent(), YRP:ctr(400), YRP:ctr(50), 0, 0)
			idcard_change:SetText("LID_change")
			function idcard_change:DoClick()
				F8CloseSettings()
				local idbg = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
				idbg:Center()
				idbg:MakePopup()
				idbg:SetTitle("")
				idbg:SetDraggable(false)
				function idbg:Paint(pw, ph)
					--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 0, 255 ) )
					for y = 0, ScrH(), gs do
						draw.RoundedBox(0, 0, y, pw, 1, Color(255, 255, 255, 255))
					end

					for x = 0, ScrW(), gs do
						draw.RoundedBox(0, x, 0, 1, ph, Color(255, 255, 255, 255))
					end

					YRPDrawIDCard(LocalPlayer(), 1)
				end

				local elements = {"background", "box1", "box2", "box3", "box4", "box5", "serverlogo", "box6", "box7", "box8", "hostname", "role", "group", "idcardid", "faction", "rpname", "securitylevel", "birthday", "bodyheight", "weight"}
				--"grouplogo",
				local register = {}
				for i, ele in pairs(elements) do
					local name = string.upper(ele)
					if not string.find(ele, "box", 1, true) then
						name = YRP:trans("LID_" .. ele)
					end

					local sw = GetGlobalYRPInt("int_" .. ele .. "_w", 10)
					local sh = GetGlobalYRPInt("int_" .. ele .. "_h", 10)
					local posx = GetGlobalYRPInt("int_" .. ele .. "_x", 10)
					local posy = GetGlobalYRPInt("int_" .. ele .. "_y", 10)
					if posx > ScrW() - sw then
						SetGlobalYRPInt("int_" .. ele .. "_x", ScrW() - sw)
						posx = ScrW() - sw
						net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_x")
						net.WriteString("int_" .. ele .. "_x")
						net.WriteString(posx)
						net.SendToServer()
					end

					if posy > ScrH() - sh then
						SetGlobalYRPInt("int_" .. ele .. "_y", ScrH() - sh)
						posy = ScrH() - sh
						net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_y")
						net.WriteString("int_" .. ele .. "_y")
						net.WriteString(posy)
						net.SendToServer()
					end

					local e = YRPCreateD("YFrame", idbg, sw, sh, posx, posy)
					if string.find(ele, "background", 1, true) then
						e:SetDraggable(false)
						e.draggable = false
					else
						e:SetDraggable(true)
						e.draggable = true
					end

					e:SetHeaderHeight(YRP:ctr(100))
					e:SetMinWidth(YRP:ctr(40))
					e:SetMinHeight(YRP:ctr(40))
					e:SetTitle("")
					e:ShowCloseButton(false)
					e:SetCloseButton(false)
					e:SetLanguageChanger(false)
					e:SetSizable(true)
					e.ts = CurTime() + 1
					e.ts2 = CurTime() + 1
					e.ts3 = CurTime() + 1
					function e:Paint(pw, ph)
						--[[if ele == "background" or string.find(ele,  "box", 1, true) then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(GetGlobalYRPInt( "int_" .. ele .. "_r", 0), GetGlobalYRPInt( "int_" .. ele .. "_g", 0), GetGlobalYRPInt( "int_" .. ele .. "_b", 0), GetGlobalYRPInt( "int_" .. ele .. "_a", 0) ))
					end]]
						local visible = false
						local mx, my = gui.MousePos()
						local px, py = self:GetPos()
						self.inbg = false
						if GetGlobalYRPInt("int_" .. ele .. "_x", 0) < GetGlobalYRPInt("int_" .. "background" .. "_w", 0) and GetGlobalYRPInt("int_" .. ele .. "_y", 0) < GetGlobalYRPInt("int_" .. "background" .. "_h", 0) then
							self.inbg = true
						end

						if self:IsHovered() or self.setting:IsHovered() then
							visible = true
						elseif mx > px and mx < px + pw and my > py and my < py + ph then
							visible = true
						elseif GetGlobalYRPBool("bool_" .. ele .. "_visible", false) == false then
							visible = true
						elseif GetGlobalYRPInt("int_" .. ele .. "_x", 0) > GetGlobalYRPInt("int_" .. "background" .. "_w", 0) or GetGlobalYRPInt("int_" .. ele .. "_y", 0) > GetGlobalYRPInt("int_" .. "background" .. "_h", 0) then
							visible = true
						end

						if self.toggle ~= nil then
							self.toggle:SetVisible(visible)
						end

						if self.setting ~= nil then
							self.setting:SetVisible(visible)
						end

						local a1 = 1
						local a2 = 2
						local a3 = 100
						if visible then
							a1 = 200
							a2 = 100
							a3 = 200
						end

						if self.inbg and (mx > GetGlobalYRPInt("int_" .. "background" .. "_w", 0) or my > GetGlobalYRPInt("int_" .. "background" .. "_h", 0)) then
							a1 = 0
							a2 = 0
							a3 = 0
						end

						local br = 2
						draw.RoundedBox(0, 0, 0, pw, br, Color(0, 0, 0, a3))
						draw.RoundedBox(0, 0, ph - br, pw, br, Color(0, 0, 0, a3))
						draw.RoundedBox(0, 0, 0, br, ph, Color(0, 0, 0, a3))
						draw.RoundedBox(0, pw - br, 0, br, ph, Color(0, 0, 0, a3))
						local lon = pw
						if ph > pw then
							lon = ph
						end

						if pw == ph then
							surface.SetDrawColor(255, 255, 255, a3)
							surface.DrawLine(pw / 2, 0, pw / 2, ph)
							surface.DrawLine(0, ph / 2, pw, ph / 2)
							surface.DrawLine(0, 0, lon, lon)
						end

						--if ele ~= "background" and !string.find(ele,  "box" ) then
						if not string.find(ele, "logo", 1, true) or GetGlobalYRPBool("bool_" .. ele .. "_visible", false) == false then
							local bgcolor = Color(255, 0, 0, a1)
							if GetGlobalYRPBool("bool_" .. ele .. "_visible", false) == true then
								bgcolor = Color(0, 255, 0, 1)
							end

							draw.RoundedBox(0, 0, 0, pw, ph, bgcolor)
						end

						--end
						if self:IsDraggable() or e.draggable then
							draw.RoundedBox(0, 0, 0, pw, self:GetHeaderHeight(), Color(60, 255, 60, a2))
						end

						draw.SimpleTextOutlined(name, "Y_24_700", pw / 2, ph / 2, Color(255, 255, 255, a3), 1, 1, 1, Color(0, 0, 0, a3))
						-- SIZE
						local w, h = self:GetSize()
						local wrongsize = false
						if w > ScrW() then
							w = ScrW()
							wrongsize = true
						end

						if h > ScrH() then
							h = ScrH()
							wrongsize = true
						end

						if w % gs ~= 0 then
							w = w - w % gs
							wrongsize = true
						end

						if h % gs ~= 0 then
							h = h - h % gs
							wrongsize = true
						end

						if wrongsize then
							self:SetSize(w, h)
						end

						-- POSITION
						local x, y = self:GetPos()
						local wrongpos = false
						if x < 0 then
							x = 0
							wrongpos = true
						elseif x + w > ScrW() then
							x = ScrW() - w
							wrongpos = true
						end

						if y < 0 then
							y = 0
							wrongpos = true
						elseif y + h > ScrH() then
							y = ScrH() - h
							wrongpos = true
						end

						if x % gs ~= 0 then
							x = x - x % gs
							wrongpos = true
						end

						if y % gs ~= 0 then
							y = y - y % gs
							wrongpos = true
						end

						if ele == "background" and (x ~= 0 or y ~= 0) then
							x = 0
							y = 0
							wrongpos = true
						end

						if wrongpos then
							self:SetPos(x, y)
						end

						self.posx = self.posx or x
						self.posy = self.posy or y
						if self.posx ~= x or self.posy ~= y then
							self.posx = x
							self.posy = y
						elseif e.ts <= CurTime() then
							e.ts = CurTime() + 1
							register["int_" .. ele .. "_x"] = register["int_" .. ele .. "_x"] or x
							register["int_" .. ele .. "_y"] = register["int_" .. ele .. "_y"] or y
							if register["int_" .. ele .. "_x"] ~= x or register["int_" .. ele .. "_y"] ~= y then
								register["int_" .. ele .. "_x"] = x
								register["int_" .. ele .. "_y"] = y
								self.d = self.d or 0
								self.d = self.d + 0.1
								timer.Simple(
									self.d,
									function()
										if net.BytesLeft() == nil and net.BytesWritten() == nil then
											net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_x")
											net.WriteString("int_" .. ele .. "_x")
											net.WriteString(x)
											net.SendToServer()
											net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_y")
											net.WriteString("int_" .. ele .. "_y")
											net.WriteString(y)
											net.SendToServer()
										end
									end
								)
							end
						end

						self.sizw = self.sizw or w
						self.sizh = self.sizh or h
						if self.sizw ~= w or self.sizh ~= h then
							self.sizw = w
							self.sizh = h
						elseif e.ts2 <= CurTime() then
							e.ts2 = CurTime() + 1
							register["int_" .. ele .. "_w"] = register["int_" .. ele .. "_w"] or w
							register["int_" .. ele .. "_h"] = register["int_" .. ele .. "_h"] or h
							if register["int_" .. ele .. "_w"] ~= w or register["int_" .. ele .. "_h"] ~= h then
								register["int_" .. ele .. "_w"] = w
								register["int_" .. ele .. "_h"] = h
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_w")
								net.WriteString("int_" .. ele .. "_w")
								net.WriteString(w)
								net.SendToServer()
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_h")
								net.WriteString("int_" .. ele .. "_h")
								net.WriteString(h)
								net.SendToServer()
							end
						end

						if e.col ~= nil then
							local r = e.col.r
							local g = e.col.g
							local b = e.col.b
							local a = e.col.a
							register["int_" .. ele .. "_r"] = register["int_" .. ele .. "_r"] or r
							register["int_" .. ele .. "_g"] = register["int_" .. ele .. "_g"] or g
							register["int_" .. ele .. "_b"] = register["int_" .. ele .. "_b"] or b
							register["int_" .. ele .. "_a"] = register["int_" .. ele .. "_a"] or a
							if e.ts3 <= CurTime() and (register["int_" .. ele .. "_r"] ~= r or register["int_" .. ele .. "_g"] ~= g or register["int_" .. ele .. "_b"] ~= b or register["int_" .. ele .. "_a"] ~= a) then
								register["int_" .. ele .. "_r"] = r
								register["int_" .. ele .. "_g"] = g
								register["int_" .. ele .. "_b"] = b
								register["int_" .. ele .. "_a"] = a
								e.ts3 = CurTime() + 1
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_r")
								net.WriteString("int_" .. ele .. "_r")
								net.WriteString(r)
								net.SendToServer()
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_g")
								net.WriteString("int_" .. ele .. "_g")
								net.WriteString(g)
								net.SendToServer()
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_b")
								net.WriteString("int_" .. ele .. "_b")
								net.WriteString(b)
								net.SendToServer()
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_a")
								net.WriteString("int_" .. ele .. "_a")
								net.WriteString(a)
								net.SendToServer()
							end
						end
					end

					local X = 0
					if ele ~= "background" then
						e.toggle = YRPCreateD("DCheckBox", e, YRP:ctr(50), YRP:ctr(50), 0, 0)
						e.toggle:SetChecked(GetGlobalYRPBool("bool_" .. ele .. "_visible", false))
						function e.toggle:OnChange(bVal)
							net.Start("nws_yrp_update_idcard_" .. "bool_" .. ele .. "_visible")
							net.WriteString("bool_" .. ele .. "_visible")
							net.WriteString(tostring(bVal))
							net.SendToServer()
						end

						X = X + YRP:ctr(50 + 2)
					end

					e.setting = YRPCreateD("YButton", e, YRP:ctr(70), YRP:ctr(50), X, 0)
					e.setting:SetText(string.sub(YRP:trans("LID_settings"), 1, 3) .. ".")
					function e.setting:DoClick()
						local win = YRPCreateD("YFrame", nil, YRP:ctr(800), YRP:ctr(1000), 0, 0)
						win:SetTitle(name)
						win:SetHeaderHeight(YRP:ctr(100))
						win:MakePopup()
						win:Center()
						function win:Paint(pw, ph)
							hook.Run("YFramePaint", self, pw, ph)
						end

						local content = win:GetContent()
						function content:Paint(pw, ph)
							draw.SimpleText("TEXT ALIGN", "DermaDefault", YRP:ctr(10), YRP:ctr(560), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
							draw.SimpleText("TEXT HEIGHT", "DermaDefault", YRP:ctr(10), YRP:ctr(680), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
							draw.SimpleText(YRP:trans("LID_title"), "DermaDefault", YRP:ctr(60), YRP:ctr(800), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						end

						win.ele = ele
						win.colortype = YRPCreateD("DComboBox", win:GetContent(), YRP:ctr(400), YRP:ctr(50), 0, YRP:ctr(0))
						local cho = {}
						cho[1] = YRP:trans("LID_custom") .. "-" .. YRP:trans("LID_color")
						cho[2] = YRP:trans("LID_faction") .. "-" .. YRP:trans("LID_color")
						cho[3] = YRP:trans("LID_group") .. "-" .. YRP:trans("LID_color")
						cho[4] = YRP:trans("LID_role") .. "-" .. YRP:trans("LID_color")
						cho[5] = YRP:trans("LID_usergroup") .. "-" .. YRP:trans("LID_color")
						for id, v in pairs(cho) do
							local selected = false
							if id == GetGlobalYRPInt("int_" .. ele .. "_colortype", 0) then
								selected = true
							end

							win.colortype:AddChoice(YRP:trans(v), id, selected)
						end

						function win.colortype:OnSelect(index, value)
							net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_colortype")
							net.WriteString("int_" .. ele .. "_colortype")
							net.WriteString(index)
							net.SendToServer()
						end

						win.color = YRPCreateD("DColorMixer", win:GetContent(), YRP:ctr(400), YRP:ctr(400), 0, YRP:ctr(50))
						win.color:SetColor(Color(GetGlobalYRPInt("int_" .. ele .. "_r", 0), GetGlobalYRPInt("int_" .. ele .. "_g", 0), GetGlobalYRPInt("int_" .. ele .. "_b", 0), GetGlobalYRPInt("int_" .. ele .. "_a", 0)))
						function win.color:ValueChanged(colo)
							e.col = colo
						end

						local halign = {}
						halign[0] = "L"
						halign[1] = "C"
						halign[2] = "R"
						for x = 0, 2 do
							local ax = YRPCreateD("YButton", win:GetContent(), YRP:ctr(50), YRP:ctr(50), x * YRP:ctr(50 + 2), YRP:ctr(570))
							ax:SetText(halign[x])
							function ax:DoClick()
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_ax")
								net.WriteString("int_" .. ele .. "_ax")
								net.WriteString(x)
								net.SendToServer()
							end
						end

						local valign = {}
						valign[0] = "T"
						valign[1] = "C"
						valign[2] = "B"
						for x = 0, 2 do
							local ay = YRPCreateD("YButton", win:GetContent(), YRP:ctr(50), YRP:ctr(50), x * YRP:ctr(50 + 2), YRP:ctr(690))
							ay:SetText(valign[x])
							function ay:DoClick()
								net.Start("nws_yrp_update_idcard_" .. "int_" .. ele .. "_ay")
								net.WriteString("int_" .. ele .. "_ay")
								net.WriteString(x)
								net.SendToServer()
							end
						end

						X = X + YRP:ctr(50 + 2)
						e.title = YRPCreateD("DCheckBox", win:GetContent(), YRP:ctr(50), YRP:ctr(50), 0, YRP:ctr(780))
						e.title:SetChecked(GetGlobalYRPBool("bool_" .. ele .. "_title", false))
						function e.title:OnChange(bVal)
							net.Start("nws_yrp_update_idcard_" .. "bool_" .. ele .. "_title")
							net.WriteString("bool_" .. ele .. "_title")
							net.WriteString(tostring(bVal))
							net.SendToServer()
						end

						X = X + YRP:ctr(50 + 2)
					end
				end
			end

			GAMEMODE_VISUALS:GetContent():AddItem(idcard_change)
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_show_securitylevel, YRP:trans("LID_securitylevel") .. " (Show/Hide on Door)", "nws_yrp_update_bool_show_securitylevel")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_play_button, "LID_playbutton", "nws_yrp_update_bool_yrp_play_button")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_showowner, "LID_showowner", "nws_yrp_update_bool_yrp_showowner")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_crosshair, "LID_yourrpcrosshair", "nws_yrp_update_bool_yrp_crosshair")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_hud, "LID_yourrphud", "nws_yrp_update_bool_yrp_hud")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_hud_swaying, "LID_swaying", "nws_yrp_update_bool_yrp_hud_swaying")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard, "LID_yourrpscoreboard", "nws_yrp_update_bool_yrp_scoreboard")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_level, "LID_showlevel", "nws_yrp_update_bool_yrp_scoreboard_show_level")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_name, "LID_showname", "nws_yrp_update_bool_yrp_scoreboard_show_name")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_usergroup, "LID_showusergroup", "nws_yrp_update_bool_yrp_scoreboard_show_usergroup")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_rolename, "LID_showrolename", "nws_yrp_update_bool_yrp_scoreboard_show_rolename")
			--CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_factionname, "LID_showfactionname", "nws_yrp_update_bool_yrp_scoreboard_show_factionname" )
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_groupname, "LID_showgroupname", "nws_yrp_update_bool_yrp_scoreboard_show_groupname")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_language, "LID_showlanguage", "nws_yrp_update_bool_yrp_scoreboard_show_language")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_idcardid, "LID_showidcardid", "nws_yrp_update_bool_yrp_scoreboard_show_idcardid")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_operating_system, "LID_showoperatingsystem", "nws_yrp_update_bool_yrp_scoreboard_show_operating_system")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_playtime, "LID_showplaytime", "nws_yrp_update_bool_yrp_scoreboard_show_playtime")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head, "LID_overheadinfo", "nws_yrp_update_bool_tag_on_head")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_target, "LID_showonlytarget", "nws_yrp_update_bool_tag_on_head_target")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_name, "LID_showname", "nws_yrp_update_bool_tag_on_head_name")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_name_onlyfaction, "LID_onlyfaction", "nws_yrp_update_bool_tag_on_head_name_onlyfaction", YRP:ctr(100))
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_name_onlygroup, "LID_onlygroup", "nws_yrp_update_bool_tag_on_head_name_onlygroup", YRP:ctr(100))
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_name_onlyrole, "LID_onlyrole", "nws_yrp_update_bool_tag_on_head_name_onlyrole", YRP:ctr(100))
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_idcardid, "LID_showidcardid", "nws_yrp_update_bool_tag_on_head_idcardid")
			--CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_clan, "LID_showclan", "nws_yrp_update_bool_tag_on_head_clan" )
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_level, "LID_showlevel", "nws_yrp_update_bool_tag_on_head_level")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_rolename, "LID_showrolename", "nws_yrp_update_bool_tag_on_head_rolename")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_factionname, "LID_showfactionname", "nws_yrp_update_bool_tag_on_head_factionname")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_groupname, "LID_showgroupname", "nws_yrp_update_bool_tag_on_head_groupname")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_health, "LID_showhealth", "nws_yrp_update_bool_tag_on_head_health")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_armor, "LID_showarmor", "nws_yrp_update_bool_tag_on_head_armor")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_usergroup, "LID_showusergroup", "nws_yrp_update_bool_tag_on_head_usergroup")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_target_forced, "LID_showonlytargetforced", "nws_yrp_update_bool_tag_on_head_target_forced")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_voice, "LID_showvoiceicon", "nws_yrp_update_bool_tag_on_head_voice")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_chat, "LID_showchaticon", "nws_yrp_update_bool_tag_on_head_chat")
			CreateHRLine(GAMEMODE_VISUALS:GetContent())
			CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side, "LID_sideinfo", "nws_yrp_update_bool_tag_on_side")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_target, "LID_showonlytarget", "nws_yrp_update_bool_tag_on_side_target")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_name, "LID_showname", "nws_yrp_update_bool_tag_on_side_name")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_idcardid, "LID_showidcardid", "nws_yrp_update_bool_tag_on_side_idcardid")
			--CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_clan, "LID_showclan", "nws_yrp_update_bool_tag_on_side_clan" )
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_rolename, "LID_showrolename", "nws_yrp_update_bool_tag_on_side_rolename")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_factionname, "LID_showfactionname", "nws_yrp_update_bool_tag_on_side_factionname")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_groupname, "LID_showgroupname", "nws_yrp_update_bool_tag_on_side_groupname")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_health, "LID_showhealth", "nws_yrp_update_bool_tag_on_side_health")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_armor, "LID_showarmor", "nws_yrp_update_bool_tag_on_side_armor")
			CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_usergroup, "LID_showusergroup", "nws_yrp_update_bool_tag_on_side_usergroup")
			--[[ MONEY SETTINGS ]]
			--
			local MONEY_SETTINGS = YRPCreateD("YGroupBox", General_Slider, YRP:ctr(800), General_Slider:GetTall(), 0, 0)
			MONEY_SETTINGS:SetText("LID_moneysettings")
			function MONEY_SETTINGS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			General_Slider:AddPanel(MONEY_SETTINGS)
			CreateCheckBoxLine(MONEY_SETTINGS:GetContent(), GEN.bool_YRPDropMoneyChat_on_death, "LID_dropmoneyondeath", "nws_yrp_update_bool_YRPDropMoneyChat_on_death")
			CreateNumberWangLine(MONEY_SETTINGS:GetContent(), GEN.text_money_max_amount_of_dropped_money, "LID_maxamountofdroppedmoney", "nws_yrp_update_text_money_max_amount_of_dropped_money")
			CreateHRLine(MONEY_SETTINGS:GetContent())
			CreateTextBoxLineSpecial(MONEY_SETTINGS:GetContent(), GEN.text_money_pre, GEN.text_money_pos, "LID_visual", "nws_yrp_update_text_money_pre", "nws_yrp_update_text_money_pos")
			CreateHRLine(MONEY_SETTINGS:GetContent())
			CreateTextBoxLine(MONEY_SETTINGS:GetContent(), GEN.text_money_model, "LID_model", "nws_yrp_update_text_money_model")
			CreateHRLine(MONEY_SETTINGS:GetContent())
			local money_reset = CreateButtonLine(MONEY_SETTINGS:GetContent(), "LID_moneyreset", "nws_yrp_update_money_reset")
			function money_reset.button:DoClick()
				local win = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
				win:Center()
				win:SetTitle(YRP:trans("LID_areyousure"))
				local _yesButton = createVGUI("YButton", win, 200, 50, 10, 60)
				_yesButton:SetText(YRP:trans("LID_yes"))
				function _yesButton:DoClick()
					net.Start("nws_yrp_moneyreset")
					net.SendToServer()
					win:Close()
				end

				local _noButton = createVGUI("YButton", win, 200, 50, 10 + 200 + 10, 60)
				_noButton:SetText(YRP:trans("LID_no"))
				function _noButton:DoClick()
					win:Close()
				end

				win:MakePopup()
			end

			CreateHRLine(MONEY_SETTINGS:GetContent())
			CreateCheckBoxLine(MONEY_SETTINGS:GetContent(), GEN.bool_money_printer_spawn_money, "LID_moneyprinterspawnmoney", "nws_yrp_update_bool_money_printer_spawn_money")
			--[[ CHARACTERS SETTINGS ]]
			--
			local CHARACTERS_SETTINGS = YRPCreateD("YGroupBox", General_Slider, YRP:ctr(1000), General_Slider:GetTall(), 0, 0)
			CHARACTERS_SETTINGS:SetText("LID_characterssettings")
			function CHARACTERS_SETTINGS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			General_Slider:AddPanel(CHARACTERS_SETTINGS)
			CreateNumberWangLine(CHARACTERS_SETTINGS:GetContent(), GEN.text_characters_money_start, "LID_charactersmoneystart", "nws_yrp_update_text_characters_money_start")
			CreateHRLine(CHARACTERS_SETTINGS:GetContent())
			CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_changeable_name, "LID_namechangeable", "nws_yrp_update_bool_characters_changeable_name")
			CreateHRLine(CHARACTERS_SETTINGS:GetContent())
			CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_removeondeath, YRP:trans("LID_removeondeath") .. " (REMOVES CHAR ON DEATH)", "nws_yrp_update_bool_characters_removeondeath", nil, Color(0, 255, 0))
			CreateHRLine(CHARACTERS_SETTINGS:GetContent())
			CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_birthday, "LID_birthday", "nws_yrp_update_bool_characters_birthday")
			CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_bodyheight, "LID_bodyheight", "nws_yrp_update_bool_characters_bodyheight")
			CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_weight, "LID_weight", "nws_yrp_update_bool_characters_weight")
			CreateHRLine(CHARACTERS_SETTINGS:GetContent())
			CreateNumberWangLine(CHARACTERS_SETTINGS:GetContent(), GEN.int_logouttime, YRP:trans("LID_logouttime"), "nws_yrp_update_int_logouttime")
			CreateHRLine(CHARACTERS_SETTINGS:GetContent())
			CreateNumberWangLine(CHARACTERS_SETTINGS:GetContent(), GEN.int_deathtimestamp_min, YRP:trans("LID_respawntime") .. " [" .. YRP:trans("LID_min") .. "]", "nws_yrp_update_int_deathtimestamp_min")
			CreateNumberWangLine(CHARACTERS_SETTINGS:GetContent(), GEN.int_deathtimestamp_max, YRP:trans("LID_respawntime") .. " [" .. YRP:trans("LID_max") .. "]" .. "(afterwards no longer revivable)", "nws_yrp_update_int_deathtimestamp_max")
			CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_deathscreen, "LID_deathscreen", "nws_yrp_update_bool_deathscreen")
			--[[ SOCIAL SETTINGS ]]
			--
			local SOCIAL_SETTINGS = YRPCreateD("YGroupBox", General_Slider, YRP:ctr(800), General_Slider:GetTall(), 0, 0)
			SOCIAL_SETTINGS:SetText("LID_socialsettings")
			function SOCIAL_SETTINGS:Paint(pw, ph)
				hook.Run("YGroupBoxPaint", self, pw, ph)
			end

			General_Slider:AddPanel(SOCIAL_SETTINGS)
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_website, "LID_website", "nws_yrp_update_text_social_website")
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_forum, "LID_forum", "nws_yrp_update_text_social_forum")
			CreateHRLine(SOCIAL_SETTINGS:GetContent())
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_discord, "LID_discord", "nws_yrp_update_text_social_discord")
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_discord_widgetid, YRP:trans("LID_discord") .. " " .. YRP:trans("LID_serverid"), "nws_yrp_update_text_social_discord_widgetid")
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_teamspeak_ip, YRP:trans("LID_teamspeak") .. " [" .. YRP:trans("LID_ip") .. "/" .. YRP:trans("LID_hostname") .. "]", "nws_yrp_update_text_social_teamspeak_ip")
			CreateNumberWangLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_teamspeak_port, YRP:trans("LID_teamspeak") .. " [" .. YRP:trans("LID_port") .. "]", "nws_yrp_update_text_social_teamspeak_port")
			CreateNumberWangLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_teamspeak_query_port, YRP:trans("LID_teamspeak") .. " [" .. YRP:trans("LID_queryport") .. "]", "nws_yrp_update_text_social_teamspeak_query_port")
			CreateHRLine(SOCIAL_SETTINGS:GetContent())
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_youtube, "Youtube", "nws_yrp_update_text_social_youtube")
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_twitch, "Twitch", "nws_yrp_update_text_social_twitch")
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_twitter, "Twitter", "nws_yrp_update_text_social_twitter")
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_facebook, "Facebook", "nws_yrp_update_text_social_facebook")
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_instagram, "Instagram", "nws_yrp_update_text_social_instagram")
			CreateHRLine(SOCIAL_SETTINGS:GetContent())
			CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_steamgroup, "SteamGroup", "nws_yrp_update_text_social_steamgroup")
		end
	end
)

function OpenSettingsGeneral()
	net.Start("nws_yrp_connect_Settings_General")
	net.SendToServer()
end
