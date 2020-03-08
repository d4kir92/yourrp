--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function CreateCheckBoxLine(dpanellist, val, lstr, netstr, fixx)
	fixx = fixx or 0
	local background = createD("DPanel", nil, dpanellist:GetWide(), YRP.ctr(50), 0, 0)
	background.text_posx = YRP.ctr(50 + 10)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP.lang_string(lstr), nil, self.text_posx + YRP.ctr(fixx), nil, 0, 1)
	end

	background.checkbox = createD("DCheckBox", background, YRP.ctr(50), YRP.ctr(50), 0 + YRP.ctr(fixx), 0)
	background.checkbox:SetValue(val)
	function background.checkbox:Paint(pw, ph)
		surfaceCheckBox(self, pw, ph, "done")
	end
	background.checkbox.serverside = false

	function background.checkbox:OnChange(bVal)
		if !self.serverside then
			net.Start(netstr)
				net.WriteBool(bVal)
			net.SendToServer()
		end
	end

	net.Receive(netstr, function(len)
		local b = net.ReadString()
		if pa(background.checkbox) then
			background.checkbox.serverside = true
			background.checkbox:SetValue(b)
			background.checkbox.serverside = false
		end
	end)

	dpanellist:AddItem(background)
	return background
end

function CreateCheckBoxLineTab(dpanellist, val, lstr, netstr)
	local cb = CreateCheckBoxLine(dpanellist, val, lstr, netstr)
	cb.checkbox:SetPos(YRP.ctr(50), YRP.ctr(0))
	cb.text_posx = YRP.ctr(50 + 50 + 10)
end

function CreateButtonLine(dpanellist, lstr, netstr, lstr2)
	local background = createD("DPanel", nil, dpanellist:GetWide(), YRP.ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP.lang_string(lstr) .. ":", nil, YRP.ctr(10), ph * 1 / 4, 0, 1)
	end

	background.button = createD("DButton", background, dpanellist:GetWide() - YRP.ctr(10 * 2), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50))
	background.button:SetText("")
	background.button.text = lstr2 or lstr
	function background.button:Paint(pw, ph)
		surfaceButton(self, pw, ph, YRP.lang_string(self.text), Color(200, 200, 200, 255))
	end

	function background.button:DoClick()
		net.Start(netstr)
		net.SendToServer()
	end

	dpanellist:AddItem(background)

	return background
end

function CreateTextBoxLine(dpanellist, text, lstr, netstr)
	local background = createD("DPanel", nil, dpanellist:GetWide(), YRP.ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP.lang_string(lstr) .. ":", nil, YRP.ctr(10), ph * 1 / 4, 0, 1)
	end

	local textbox = createD("DTextEntry", background, dpanellist:GetWide() - YRP.ctr(10 * 2), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50))
	textbox:SetText(SQL_STR_OUT(text))
	textbox.serverside = false

	function textbox:OnChange()
		if !self.serverside then
			net.Start(netstr)
				net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(netstr, function(len)
		local tex = net.ReadString()
		if pa(textbox) then
			textbox.serverside = true
			textbox:SetText(tex)
			textbox.serverside = false
		end
	end)

	dpanellist:AddItem(background)

	return background
end

function CreateTextBoxBox(dpanellist, text, lstr, netstr)
	text = SQL_STR_OUT(text)
	local background = createD("DPanel", nil, dpanellist:GetWide(), YRP.ctr(50 + 400 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP.lang_string(lstr) .. ":", nil, YRP.ctr(10), YRP.ctr(25), 0, 1)
	end

	local textbox = createD("DTextEntry", background, dpanellist:GetWide() - YRP.ctr(10 * 2), YRP.ctr(400), YRP.ctr(10), YRP.ctr(50))
	textbox:SetText(text)
	textbox:SetMultiline(true)
	textbox.serverside = false

	function textbox:OnChange()
		if !self.serverside then
			net.Start(netstr)
				net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(netstr, function(len)
		local tex = net.ReadString()
		if pa(textbox) then
			textbox.serverside = true
			textbox:SetText(tex)
			textbox.serverside = false
		end
	end)

	dpanellist:AddItem(background)

	return background
end

function CreateTextBoxLineSpecial(dpanellist, text, text2, lstr, netstr, netstr2)
	local background = createD("DPanel", nil, dpanellist:GetWide(), YRP.ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP.lang_string(lstr) .. ": (" .. GetGlobalDString("text_money_pre", "") .. "100" .. GetGlobalDString("text_money_pos", "") .. ")", nil, YRP.ctr(10), ph * 1 / 4, 0, 1)
	end

	background.textbox = createD("DTextEntry", background, YRP.ctr(400) - YRP.ctr(10 * 2), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50))
	background.textbox:SetText(text)
	background.textbox.serverside = false

	function background.textbox:OnChange()
		if !self.serverside then
			net.Start(netstr)
				net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(netstr, function(len)
		local tex = net.ReadString()
		if pa(background.textbox) then
			background.textbox.serverside = true
			background.textbox:SetText(tex)
			background.textbox.serverside = false
		end
	end)

	background.textbox2 = createD("DTextEntry", background, YRP.ctr(400) - YRP.ctr(10 * 2), YRP.ctr(50), YRP.ctr(10 + 400), YRP.ctr(50))
	background.textbox2:SetText(text2)
	background.textbox2.serverside = false

	function background.textbox2:OnChange()
		if !self.serverside then
			net.Start(netstr2)
				net.WriteString(self:GetText())
			net.SendToServer()
		end
	end

	net.Receive(netstr2, function(len)
		local tex = net.ReadString()
		if pa(background.textbox2) then
			background.textbox2.serverside = true
			background.textbox2:SetText(tex)
			background.textbox2.serverside = false
		end
	end)

	dpanellist:AddItem(background)

	return background
end

function CreateNumberWangLine(dpanellist, value, lstr, netstr, fixx, max, min)
	local background = createD("DPanel", nil, dpanellist:GetWide(), YRP.ctr(100 + 10), 0, 0)
	function background:Paint(pw, ph)
		surfacePanel(self, pw, ph, YRP.lang_string(lstr) .. ":", nil, YRP.ctr(10) + YRP.ctr(fixx), ph * 1 / 4, 0, 1)
	end

	background.numberwang = createD("DNumberWang", background, dpanellist:GetWide() - YRP.ctr(20 * 2) - YRP.ctr(fixx), YRP.ctr(50), YRP.ctr(10) + YRP.ctr(fixx), YRP.ctr(50))
	background.numberwang:SetMax(max or 999999999999)
	background.numberwang:SetMin(min or -999999999999)
	background.numberwang:SetValue(value)
	background.numberwang.serverside = false

	function background.numberwang:OnChange()
		if !self.serverside then
			local num = tonumber(self:GetValue())
			local max = self:GetMax()
			local min = self:GetMin()

			if num >= min and num <= max then
				net.Start(netstr)
					net.WriteString(num)
				net.SendToServer()
			else
				if num > max then
					self:SetText(max)
					num = max
				elseif num < min then
					self:SetText(min)
					num = min
				end
				net.Start(netstr)
					net.WriteString(num)
				net.SendToServer()
			end
		end
	end

	net.Receive(netstr, function(len)
		local val = net.ReadString()
		if pa(background.numberwang) then
			background.numberwang.serverside = true
			background.numberwang:SetValue(val)
			background.numberwang.serverside = false
		end
	end)

	dpanellist:AddItem(background)

	return background
end

function CreateHRLine(dpanellist)
	local hr = createD("DPanel", nil, dpanellist:GetWide(), YRP.ctr(20), 0, 0)
	function hr:Paint(pw, ph)
		surfacePanel(self, pw, ph, "")
		surfaceBox(YRP.ctr(10), hr:GetTall() / 4, hr:GetWide() - YRP.ctr(2 * 10), hr:GetTall() / 2, Color(0, 0, 0, 255))
	end
	dpanellist:AddItem(hr)
	return hr
end

function AddToTabRecursive(tab, folder, path, wildcard)
	local files, folders = file.Find( folder .. "*", path )
	for k, v in pairs( files ) do
		if ( !string.EndsWith( v, ".mdl" ) ) then continue end
		table.insert( tab, folder .. v )
	end

	for k, v in pairs( folders ) do
		AddToTabRecursive(tab, folder .. v .. "/", path, wildcard)
	end
end

net.Receive("Connect_Settings_General", function(len)
	if pa(settingsWindow) and settingsWindow.window != nil then

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_General")
			net.SendToServer()
		end

		local GEN = net.ReadTable()



		local General_Slider = createD("DHorizontalScroller", PARENT, PARENT:GetWide() - YRP.ctr(2 * 20), PARENT:GetTall() - YRP.ctr(2 * 20), YRP.ctr(20), YRP.ctr(20))
		General_Slider:SetOverlap(- YRP.ctr(20))
		function General_Slider:Paint(pw, ph)
			if self.w != PARENT:GetWide() or self.h != PARENT:GetTall() then
				self.w = PARENT:GetWide()
				self.w = PARENT:GetTall()

				self:SetSize(PARENT:GetWide() - YRP.ctr(2 * 20), PARENT:GetTall() - YRP.ctr(2 * 20))
				self:SetPos(YRP.ctr(20), YRP.ctr(20))
			end
		end


		--[[ SERVER SETTINGS ]]--
		local SERVER_SETTINGS = createD("YGroupBox", Server_Settings, YRP.ctr(800), General_Slider:GetTall(), 0, 0)
		SERVER_SETTINGS:SetText("LID_serversettings")
		function SERVER_SETTINGS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		General_Slider:AddPanel(SERVER_SETTINGS)

		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_server_reload, "LID_automaticreloadingoftheserver", "update_bool_server_reload")
		CreateHRLine(SERVER_SETTINGS:GetContent())
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_noclip_effect, "LID_noclipeffect", "update_bool_noclip_effect")
		CreateCheckBoxLineTab(SERVER_SETTINGS:GetContent(), GEN.bool_noclip_stealth, "LID_noclipcloak", "update_bool_noclip_stealth")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_noclip_tags, "LID_noclipusergroup", "update_bool_noclip_tags")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_noclip_model, "LID_noclipmodel", "update_bool_noclip_model")
		local noclip_mdl = CreateButtonLine(SERVER_SETTINGS:GetContent(), "LID_noclipmodel", "update_text_noclip_mdl", "LID_change")
		hook.Add("update_text_noclip_mdl", "yrp_update_text_noclip_mdl", function()
			local mdl = LocalPlayer():GetDString("WorldModel", "")
			net.Start("update_text_noclip_mdl")
				net.WriteString(mdl)
			net.SendToServer()
		end)
		function noclip_mdl.button:DoClick()
			local tmpTable = {}
			local count = 0
			local noneplayermodels = {}
			for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
				if (!addon.downloaded or !addon.mounted) then continue end
				AddToTabRecursive(noneplayermodels, "models/", addon.title, "*.mdl")
			end
			for k, v in pairs(noneplayermodels) do
				count = count + 1
				tmpTable[count] = {}
				tmpTable[count].WorldModel = v
				tmpTable[count].ClassName = v
				tmpTable[count].PrintName = v
			end

			local allvalidmodels = player_manager.AllValidModels()
			for k, v in pairs(allvalidmodels) do
				count = count + 1
				tmpTable[count] = {}
				tmpTable[count].WorldModel = v
				tmpTable[count].ClassName = v
				tmpTable[count].PrintName = player_manager.TranslateToPlayerModelName(v)
			end

			count = count + 1
			tmpTable[count] = {}
			tmpTable[count].WorldModel = "models/crow.mdl"
			tmpTable[count].ClassName = "npc_crow"
			tmpTable[count].PrintName = "CROW"

			LocalPlayer():SetDString("WorldModel", GEN.bool_noclip_mdl)
			OpenSingleSelector(tmpTable, "update_text_noclip_mdl")
		end
		CreateHRLine(SERVER_SETTINGS:GetContent())
		CreateNumberWangLine(SERVER_SETTINGS:GetContent(), GEN.text_server_collectionid, "LID_collectionid", "update_text_server_collectionid")
		CreateHRLine(SERVER_SETTINGS:GetContent())
		CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_name, "LID_hostname", "update_text_server_name")
		CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_logo, "LID_serverlogo", "update_text_server_logo")
		--[LATER] CreateHRLine(SERVER_SETTINGS:GetContent())
		--[LATER] local community_servers = CreateButtonLine(SERVER_SETTINGS:GetContent(), "LID_communityservers", "update_community_servers")
		CreateHRLine(SERVER_SETTINGS:GetContent())
		CreateTextBoxBox(SERVER_SETTINGS:GetContent(), GEN.text_server_rules, "LID_rules", "update_text_server_rules")
		CreateHRLine(SERVER_SETTINGS:GetContent())
		CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_welcome_message, "LID_welcomemessage", "update_text_server_welcome_message")
		CreateTextBoxLine(SERVER_SETTINGS:GetContent(), GEN.text_server_message_of_the_day, "LID_messageoftheday", "update_text_server_message_of_the_day")
		CreateHRLine(SERVER_SETTINGS:GetContent())
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_gm, "Console Gamemode (GM)", "update_bool_msg_channel_gm")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_db, "Console Database (DB)", "update_bool_msg_channel_db")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_lang, "Console Language (LANG)", "update_bool_msg_channel_lang")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_noti, "Console Notification (NOTI)", "update_bool_msg_channel_noti")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_darkrp, "Console DarkRP (DarkRP)", "update_bool_msg_channel_darkrp")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_chat, "Console Chat (CHAT)", "update_bool_msg_channel_chat")
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_msg_channel_debug, "Console DEBUG (DEBUG)", "update_bool_msg_channel_debug")
		CreateHRLine(SERVER_SETTINGS:GetContent())
		CreateCheckBoxLine(SERVER_SETTINGS:GetContent(), GEN.bool_server_debug_voice, "Voice DEBUG", "update_bool_server_debug_voice")



		--[[ GAMEMODE SETTINGS ]]--
		local GAMEMODE_SETTINGS = createD("YGroupBox", Gamemode_Settings, YRP.ctr(1000), General_Slider:GetTall(), 0, 0)
		GAMEMODE_SETTINGS:SetText("LID_gamemodesettings")
		function GAMEMODE_SETTINGS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		General_Slider:AddPanel(GAMEMODE_SETTINGS)

		CreateTextBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.text_gamemode_name, "LID_gamemodename", "update_text_gamemode_name")
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_graffiti_disabled, "LID_graffitidisabled", "update_bool_graffiti_disabled")
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_anti_bhop, "LID_antibunnyhop", "update_bool_anti_bhop")
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_suicide_disabled, "LID_suicidedisabled", "update_bool_suicide_disabled")
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_drop_items_on_death, "LID_dropitemsondeath", "update_bool_drop_items_on_death")
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		--CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_players_need_to_introduce, "LID_playerintroduction", "update_bool_players_need_to_introduce")
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_players_can_drop_weapons, "LID_playerscandropweapons", "update_bool_players_can_drop_weapons")
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_dealers_can_take_damage, "LID_dealerscantakedamage", "update_bool_dealers_can_take_damage")
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_thirdperson, "LID_tpp", "update_bool_thirdperson")
		local text_view_distance = CreateNumberWangLine(GAMEMODE_SETTINGS:GetContent(), GEN.text_view_distance, "LID_thirdpersonmaxdistance", "update_text_view_distance")
		text_view_distance.numberwang:SetMax(9999)
		text_view_distance.numberwang:SetMin(-200)
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		CreateTextBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.text_chat_advert, "LID_channelname", "update_text_chat_advert")
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SETTINGS:GetContent(), GEN.bool_removebuildingowner, "LID_removethebuildingowneratdisconnect", "update_bool_removebuildingowner")
		CreateNumberWangLine(GAMEMODE_SETTINGS:GetContent(), GEN.text_removebuildingownertime, "LID_timeremovethebuildingowneratdisconnect", "update_text_removebuildingownertime")
		CreateHRLine(GAMEMODE_SETTINGS:GetContent())
		CreateNumberWangLine(GAMEMODE_SETTINGS:GetContent(), GEN.int_ttlsweps, "LID_ttlsweps", "update_int_ttlsweps")



		--[[ GAMEMODE SYSTEMS ]]--
		local GAMEMODE_SYSTEMS = createD("YGroupBox", General_Slider, YRP.ctr(800), General_Slider:GetTall(), 0, 0)
		GAMEMODE_SYSTEMS:SetText("LID_gamemodesystems")
		function GAMEMODE_SYSTEMS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		General_Slider:AddPanel(GAMEMODE_SYSTEMS)

		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_hunger, "LID_hunger", "update_bool_hunger")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_hunger_health_regeneration, "LID_hungerhealthregeneration", "update_bool_hunger_health_regeneration")
		local text_hunger_health_regeneration_tickrate = CreateNumberWangLine(GAMEMODE_SYSTEMS:GetContent(), GEN.text_hunger_health_regeneration_tickrate, "LID_hungerhealthregenerationtickrate", "update_text_hunger_health_regeneration_tickrate")
		text_hunger_health_regeneration_tickrate.numberwang:SetMax(3600)
		text_hunger_health_regeneration_tickrate.numberwang:SetMin(1)
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_thirst, "LID_thirst", "update_bool_thirst")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_stamina, "LID_stamina", "update_bool_stamina")
		CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_building_system, "LID_buildingsystem", "update_bool_building_system")
		--CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_inventory_system, "LID_inventorysystem", "update_bool_inventory_system")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_realistic_system, "LID_realisticsystem", "update_bool_realistic_system")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_level_system, "LID_levelsystem", "update_bool_level_system")
		CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_identity_card, "LID_identitycard", "update_bool_identity_card")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_map_system, "LID_map", "update_bool_map_system")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_appearance_system, "LID_appearancesystem", "update_bool_appearance_system")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_smartphone_system, "LID_smartphonesystem", "update_bool_smartphone_system")
		CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_wanted_system, "LID_wantedsystem", "update_bool_wanted_system")
		CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_players_can_switch_role, "LID_playerscanswitchrole", "update_bool_players_can_switch_role")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_players_die_on_role_switch, "LID_playersdieonroleswitch", "update_bool_players_die_on_role_switch")
		CreateHRLine(GAMEMODE_SYSTEMS:GetContent())
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice, "LID_voicechat", "update_bool_voice")
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_3d, "LID_3dvoicechat", "update_bool_voice_3d", 50)
		CreateNumberWangLine(GAMEMODE_SYSTEMS:GetContent(), GEN.int_voice_max_range, YRP.lang_string("LID_maxvoicerange"), "update_int_voice_max_range", 100)
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_channels, YRP.lang_string("LID_voicechatchannels"), "update_bool_voice_channels", 50)
		CreateNumberWangLine(GAMEMODE_SYSTEMS:GetContent(), GEN.int_voice_local_range, YRP.lang_string("LID_localvoicechatdistance"), "update_int_voice_local_range", 100)
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_group_local, YRP.lang_string("LID_groupvoicechatisaudiblelocally"), "update_bool_voice_group_local", 100)
		CreateCheckBoxLine(GAMEMODE_SYSTEMS:GetContent(), GEN.bool_voice_radio, YRP.lang_string("LID_voicechatradio"), "update_bool_voice_radio", 50)



		--[[ GAMEMODE VISUALS ]]--
		local GAMEMODE_VISUALS = createD("YGroupBox", General_Slider, YRP.ctr(800), General_Slider:GetTall(), 0, 0)
		GAMEMODE_VISUALS:SetText("LID_gamemodevisuals")
		function GAMEMODE_VISUALS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		General_Slider:AddPanel(GAMEMODE_VISUALS)

		CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_combined_menu, "LID_combinedmenu", "update_bool_yrp_combined_menu")
		CreateHRLine(GAMEMODE_VISUALS:GetContent())
		CreateTextBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.text_character_background, "LID_character_background", "update_text_character_background")
		CreateHRLine(GAMEMODE_VISUALS:GetContent())
		CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat, "LID_yourrpchat", "update_bool_yrp_chat")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat_show_rolename, "LID_showrolename", "update_bool_yrp_chat_show_rolename")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat_show_factionname, "LID_showfactionname", "update_bool_yrp_chat_show_factionname")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat_show_groupname, "LID_showgroupname", "update_bool_yrp_chat_show_groupname")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat_show_usergroup, "LID_showusergroup", "update_bool_yrp_chat_show_usergroup")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_chat_show_idcardid, "LID_showidcardid", "update_bool_yrp_chat_show_idcardid")
		CreateNumberWangLine(GAMEMODE_VISUALS:GetContent(), GEN.int_yrp_chat_range_local, YRP.lang_string("LID_localchatrange"), "update_int_yrp_chat_range_local", 50, 1000, 10)
		
		--GetGlobalDInt("int_yrp_chat_range_local", 400)

		CreateTextBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.text_idstructure, YRP.lang_string("LID_idstructure") .. " (!D 1Dig., !L 1Let., !N 1Num.)", "update_text_idstructure")
		local gs = 8
		local idcard_change = createD("YButton", GAMEMODE_VISUALS:GetContent(), YRP.ctr(400), YRP.ctr(50), 0, 0)
		idcard_change:SetText("LID_change")
		function idcard_change:DoClick()
			CloseSettings()
			local idbg = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
			idbg:MakePopup()
			idbg:SetTitle("")
			idbg:SetDraggable(false)
			function idbg:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
				for y = 0, ScrH(), gs do
					draw.RoundedBox(0, 0, y, pw, 1, Color(255, 255, 255, 255))
				end
				for x = 0, ScrW(), gs do
					draw.RoundedBox(0, x, 0, 1, ph, Color(255, 255, 255, 255))
				end
				drawIDCard(LocalPlayer(), 1)
			end

			local elements = {
				"background",
				"hostname",
				"role",
				"group",
				"idcardid",
				"faction",
				"rpname",
				"securitylevel",
				"box1",
				"box2",
				"box3",
				"box4",
				--"grouplogo",
				"serverlogo"
			}
			for i, ele in pairs(elements) do
				local name = string.upper(ele)
				if !string.find(ele, "box") then
					name = YRP.lang_string("LID_" .. ele)
				end
				local e = createD("YFrame", idbg, GetGlobalDInt("int_" .. ele .. "_w", 10), GetGlobalDInt("int_" .. ele .. "_h", 10), GetGlobalDInt("int_" .. ele .. "_x", 10), GetGlobalDInt("int_" .. ele .. "_y", 10))
				if string.find(ele, "background") then
					e:SetDraggable(false)
					e.draggable = false
				else
					e:SetDraggable(true)
					e.draggable = true
				end
				e:SetHeaderHeight(YRP.ctr(100))
				e:SetMinWidth(YRP.ctr(40))
				e:SetMinHeight(YRP.ctr(40))
				e:SetTitle("")
				e:ShowCloseButton(false)
				e:SetCloseButton(false)
				e:SetLanguageChanger(false)
				e:SetSizable(true)
				e.ts = CurTime() + 1
				e.ts2 = CurTime() + 1
				e.ts3 = CurTime() + 1
				function e:Paint(pw, ph)
					--[[if ele == "background" or string.find(ele,  "box") then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(GetGlobalDInt("int_" .. ele .. "_r", 0), GetGlobalDInt("int_" .. ele .. "_g", 0), GetGlobalDInt("int_" .. ele .. "_b", 0), GetGlobalDInt("int_" .. ele .. "_a", 0)))
					end]]
					local visible = false
					local mx, my = gui.MousePos()
					local px, py = self:GetPos()
					self.inbg = false
					if GetGlobalDInt("int_" .. ele .. "_x", 0) < GetGlobalDInt("int_" .. "background" .. "_w", 0) and GetGlobalDInt("int_" .. ele .. "_y", 0) < GetGlobalDInt("int_" .. "background" .. "_h", 0) then
						self.inbg = true
					end
					if self:IsHovered() then
						visible = true
					elseif mx > px and mx < px + pw and my > py and my < py + ph then
						visible = true
					elseif GetGlobalDBool("bool_" .. ele .. "_visible", false) == false then
						visible = true
					elseif GetGlobalDInt("int_" .. ele .. "_x", 0) > GetGlobalDInt("int_" .. "background" .. "_w", 0) or GetGlobalDInt("int_" .. ele .. "_y", 0) > GetGlobalDInt("int_" .. "background" .. "_h", 0) then
						visible = true
					end

					if self.toggle != nil then
						self.toggle:SetVisible(visible)
					end
					if self.setting != nil then
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
					if self.inbg and (mx > GetGlobalDInt("int_" .. "background" .. "_w", 0) or my > GetGlobalDInt("int_" .. "background" .. "_h", 0)) then
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
					--if ele != "background" and !string.find(ele,  "box") then
						if !string.find(ele, "logo") or GetGlobalDBool("bool_" .. ele .. "_visible", false) == false then
							local bgcolor = Color(255, 0, 0, a1)
							if GetGlobalDBool("bool_" .. ele .. "_visible", false) == true then
								bgcolor = Color(0, 255, 0, 1)
							end
							draw.RoundedBox(0, 0, 0, pw, ph, bgcolor)
						end
					--end

					if self:IsDraggable() or e.draggable then
						draw.RoundedBox(0, 0, 0, pw, self:GetHeaderHeight(), Color(60, 255, 60, a2))
					end

					draw.SimpleText(name, "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, a3), 1, 1)

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
					if w % gs != 0 then
						w = w - w % gs
						wrongsize = true
					end
					if h % gs != 0 then
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
					if x % gs != 0 then
						x = x - x % gs
						wrongpos = true
					end
					if y % gs != 0 then
						y = y - y % gs
						wrongpos = true
					end
					if ele == "background" and (x != 0 or y != 0) then
						x = 0
						y = 0
						wrongpos = true
					end

					if wrongpos then
						self:SetPos(x, y)
					end

					self.posx = self.posx or x
					self.posy = self.posy or y
					if self.posx != x or self.posy != y then
						self.posx = x
						self.posy = y
					elseif e.ts <= CurTime() then
						e.ts = CurTime() + 1
						if GetGlobalDInt("int_" .. ele .. "_x", 10) != x or GetGlobalDInt("int_" .. ele .. "_y", 10) != y then
							net.Start("update_idcard_" .. "int_" .. ele .. "_x")
								net.WriteString("int_" .. ele .. "_x")
								net.WriteString(x)
							net.SendToServer()
							net.Start("update_idcard_" .. "int_" .. ele .. "_y")
								net.WriteString("int_" .. ele .. "_y")
								net.WriteString(y)
							net.SendToServer()
						end
					end

					self.sizw = self.sizw or w
					self.sizh = self.sizh or h
					if self.sizw != w or self.sizh != h then
						self.sizw = w
						self.sizh = h
					elseif e.ts2 <= CurTime() then
						e.ts2 = CurTime() + 1
						if GetGlobalDInt("int_" .. ele .. "_w", 10) != w or GetGlobalDInt("int_" .. ele .. "_h", 10) != h then
							net.Start("update_idcard_" .. "int_" .. ele .. "_w")
								net.WriteString("int_" .. ele .. "_w")
								net.WriteString(w)
							net.SendToServer()
							net.Start("update_idcard_" .. "int_" .. ele .. "_h")
								net.WriteString("int_" .. ele .. "_h")
								net.WriteString(h)
							net.SendToServer()
						end
					end

					if e.col != nil then
						local r = e.col.r
						local g = e.col.g
						local b = e.col.b
						local a = e.col.a
						if e.ts3 <= CurTime() then
							e.ts3 = CurTime() + 1
							net.Start("update_idcard_" .. "int_" .. ele .. "_r")
								net.WriteString("int_" .. ele .. "_r")
								net.WriteString(r)
							net.SendToServer()
							net.Start("update_idcard_" .. "int_" .. ele .. "_g")
								net.WriteString("int_" .. ele .. "_g")
								net.WriteString(g)
							net.SendToServer()
							net.Start("update_idcard_" .. "int_" .. ele .. "_b")
								net.WriteString("int_" .. ele .. "_b")
								net.WriteString(b)
							net.SendToServer()
							net.Start("update_idcard_" .. "int_" .. ele .. "_a")
								net.WriteString("int_" .. ele .. "_a")
								net.WriteString(a)
							net.SendToServer()
						end
					end
				end

				local X = 0
				if ele != "background" then
					e.toggle = createD("DCheckBox", e, YRP.ctr(50), YRP.ctr(50), 0, 0)
					e.toggle:SetChecked(GetGlobalDBool("bool_" .. ele .. "_visible", false))
					function e.toggle:OnChange(bVal)
						net.Start("update_idcard_" .. "bool_" .. ele .. "_visible")
							net.WriteString("bool_" .. ele .. "_visible")
							net.WriteString(tostring(bVal))
						net.SendToServer()
					end
					X = X + YRP.ctr(50 + 2)
				end

				e.setting = createD("YButton", e, YRP.ctr(250), YRP.ctr(50), X, 0)
				e.setting:SetText("LID_settings")
				function e.setting:DoClick()
					local win = createD("YFrame", nil, YRP.ctr(800), YRP.ctr(1000), 0, 0)
					win:SetTitle(name)
					win:SetHeaderHeight(YRP.ctr(100))
					win:MakePopup()
					win:Center()
					function win:Paint(pw, ph)
						hook.Run("YFramePaint", self, pw, ph)
					end
					local content = win:GetContent()
					function content:Paint(pw, ph)
						draw.SimpleText("TEXT ALIGN", "DermaDefault", YRP.ctr(10), YRP.ctr(560), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
						draw.SimpleText("TEXT HEIGHT", "DermaDefault", YRP.ctr(10), YRP.ctr(680), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					end
					win.ele = ele

					win.colortype = createD("DComboBox", win:GetContent(), YRP.ctr(400), YRP.ctr(50), 0, YRP.ctr(0))
					local cho = {}
					cho[1] = YRP.lang_string("LID_custom") .. "-" .. YRP.lang_string("LID_color")
					cho[2] = YRP.lang_string("LID_faction") .. "-" .. YRP.lang_string("LID_color")
					cho[3] = YRP.lang_string("LID_group") .. "-" .. YRP.lang_string("LID_color")
					cho[4] = YRP.lang_string("LID_role") .. "-" .. YRP.lang_string("LID_color")
					cho[5] = YRP.lang_string("LID_usergroup") .. "-" .. YRP.lang_string("LID_color")
					for id, v in pairs(cho) do
						local selected = false
						if id == GetGlobalDInt("int_" .. ele .. "_colortype", 0) then
							selected = true
						end
						win.colortype:AddChoice(YRP.lang_string(v), id, selected)
					end
					function win.colortype:OnSelect(index, value)
						net.Start("update_idcard_" .. "int_" .. ele .. "_colortype")
							net.WriteString("int_" .. ele .. "_colortype")
							net.WriteString(index)
						net.SendToServer()
					end

					win.color = createD("DColorMixer", win:GetContent(), YRP.ctr(400), YRP.ctr(400), 0, YRP.ctr(50))
					win.color:SetColor(Color(GetGlobalDInt("int_" .. ele .. "_r", 0), GetGlobalDInt("int_" .. ele .. "_g", 0), GetGlobalDInt("int_" .. ele .. "_b", 0), GetGlobalDInt("int_" .. ele .. "_a", 0)))
					function win.color:ValueChanged(colo)
						e.col = colo
					end

					local halign = {}
					halign[0] = "L"
					halign[1] = "C"
					halign[2] = "R"
					for x = 0, 2 do
						local ax = createD("YButton", win:GetContent(), YRP.ctr(50), YRP.ctr(50), x * YRP.ctr(50 + 2), YRP.ctr(570))
						ax:SetText(halign[x])
						function ax:DoClick()
							net.Start("update_idcard_" .. "int_" .. ele .. "_ax")
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
						local ay = createD("YButton", win:GetContent(), YRP.ctr(50), YRP.ctr(50), x * YRP.ctr(50 + 2), YRP.ctr(690))
						ay:SetText(valign[x])
						function ay:DoClick()
							net.Start("update_idcard_" .. "int_" .. ele .. "_ay")
								net.WriteString("int_" .. ele .. "_ay")
								net.WriteString(x)
							net.SendToServer()
						end
					end
					X = X + YRP.ctr(50 + 2)
				end
			end
		end

		GAMEMODE_VISUALS:GetContent():AddItem(idcard_change)
		CreateHRLine(GAMEMODE_VISUALS:GetContent())
		CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_crosshair, "LID_yourrpcrosshair", "update_bool_yrp_crosshair")
		CreateHRLine(GAMEMODE_VISUALS:GetContent())
		CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_hud, "LID_yourrphud", "update_bool_yrp_hud")
		CreateHRLine(GAMEMODE_VISUALS:GetContent())
		CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard, "LID_yourrpscoreboard", "update_bool_yrp_scoreboard")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_level, "LID_showlevel", "update_bool_yrp_scoreboard_show_level")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_usergroup, "LID_showusergroup", "update_bool_yrp_scoreboard_show_usergroup")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_rolename, "LID_showrolename", "update_bool_yrp_scoreboard_show_rolename")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_groupname, "LID_showgroupname", "update_bool_yrp_scoreboard_show_groupname")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_language, "LID_showlanguage", "update_bool_yrp_scoreboard_show_language")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_country, "LID_showcountry", "update_bool_yrp_scoreboard_show_country")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_playtime, "LID_showplaytime", "update_bool_yrp_scoreboard_show_playtime")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_frags, "LID_showfrags", "update_bool_yrp_scoreboard_show_frags")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_deaths, "LID_showdeaths", "update_bool_yrp_scoreboard_show_deaths")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_operating_system, "LID_showoperatingsystem", "update_bool_yrp_scoreboard_show_operating_system")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_yrp_scoreboard_show_idcardid, "LID_showidcardid", "update_bool_yrp_scoreboard_show_idcardid")
		CreateHRLine(GAMEMODE_VISUALS:GetContent())
		CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head, "LID_overheadinfo", "update_bool_tag_on_head")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_target, "LID_showonlytarget", "update_bool_tag_on_head_target")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_name, "LID_showname", "update_bool_tag_on_head_name")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_clan, "LID_showclan", "update_bool_tag_on_head_clan")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_level, "LID_showlevel", "update_bool_tag_on_head_level")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_rolename, "LID_showrolename", "update_bool_tag_on_head_rolename")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_factionname, "LID_showfactionname", "update_bool_tag_on_head_factionname")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_groupname, "LID_showgroupname", "update_bool_tag_on_head_groupname")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_health, "LID_showhealth", "update_bool_tag_on_head_health")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_armor, "LID_showarmor", "update_bool_tag_on_head_armor")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_usergroup, "LID_showusergroup", "update_bool_tag_on_head_usergroup")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_frequency, "LID_showfrequency", "update_bool_tag_on_head_frequency")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_voice, "LID_showvoiceicon", "update_bool_tag_on_head_voice")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_head_chat, "LID_showchaticon", "update_bool_tag_on_head_chat")
		CreateHRLine(GAMEMODE_VISUALS:GetContent())
		CreateCheckBoxLine(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side, "LID_sideinfo", "update_bool_tag_on_side")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_target, "LID_showonlytarget", "update_bool_tag_on_side_target")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_name, "LID_showname", "update_bool_tag_on_side_name")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_clan, "LID_showclan", "update_bool_tag_on_side_clan")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_level, "LID_showlevel", "update_bool_tag_on_side_level")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_rolename, "LID_showrolename", "update_bool_tag_on_side_rolename")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_factionname, "LID_showfactionname", "update_bool_tag_on_side_factionname")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_groupname, "LID_showgroupname", "update_bool_tag_on_side_groupname")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_health, "LID_showhealth", "update_bool_tag_on_side_health")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_armor, "LID_showarmor", "update_bool_tag_on_side_armor")
		CreateCheckBoxLineTab(GAMEMODE_VISUALS:GetContent(), GEN.bool_tag_on_side_usergroup, "LID_showusergroup", "update_bool_tag_on_side_usergroup")



		--[[ MONEY SETTINGS ]]--
		local MONEY_SETTINGS = createD("YGroupBox", General_Slider, YRP.ctr(800), General_Slider:GetTall(), 0, 0)
		MONEY_SETTINGS:SetText("LID_moneysettings")
		function MONEY_SETTINGS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		General_Slider:AddPanel(MONEY_SETTINGS)

		CreateCheckBoxLine(MONEY_SETTINGS:GetContent(), GEN.bool_drop_money_on_death, "LID_dropmoneyondeath", "update_bool_drop_money_on_death")
		CreateNumberWangLine(MONEY_SETTINGS:GetContent(), GEN.text_money_max_amount_of_dropped_money, "LID_maxamountofdroppedmoney", "update_text_money_max_amount_of_dropped_money")
		CreateHRLine(MONEY_SETTINGS:GetContent())
		CreateTextBoxLineSpecial(MONEY_SETTINGS:GetContent(), GEN.text_money_pre, GEN.text_money_pos, "LID_visual", "update_text_money_pre", "update_text_money_pos")
		CreateHRLine(MONEY_SETTINGS:GetContent())
		CreateTextBoxLine(MONEY_SETTINGS:GetContent(), GEN.text_money_model, "LID_model", "update_text_money_model")
		CreateHRLine(MONEY_SETTINGS:GetContent())
		local money_reset = CreateButtonLine(MONEY_SETTINGS:GetContent(), "LID_moneyreset", "update_money_reset")
		function money_reset.button:DoClick()
			local win = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			win:Center()
			win:SetTitle(YRP.lang_string("LID_areyousure"))
			local _yesButton = createVGUI("DButton", win, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string("LID_yes"))
			function _yesButton:DoClick()

				net.Start("moneyreset")
				net.SendToServer()

				win:Close()
			end
			local _noButton = createVGUI("DButton", win, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string("LID_no"))
			function _noButton:DoClick()
				win:Close()
			end
			win:MakePopup()
		end
		CreateHRLine(MONEY_SETTINGS:GetContent())
		CreateCheckBoxLine(MONEY_SETTINGS:GetContent(), GEN.bool_money_printer_spawn_money, "LID_moneyprinterspawnmoney", "update_bool_money_printer_spawn_money")



		--[[ CHARACTERS SETTINGS ]]--
		local CHARACTERS_SETTINGS = createD("YGroupBox", General_Slider, YRP.ctr(800), General_Slider:GetTall(), 0, 0)
		CHARACTERS_SETTINGS:SetText("LID_characterssettings")
		function CHARACTERS_SETTINGS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		General_Slider:AddPanel(CHARACTERS_SETTINGS)

		CreateNumberWangLine(CHARACTERS_SETTINGS:GetContent(), GEN.text_characters_money_start, "LID_charactersmoneystart", "update_text_characters_money_start")

		CreateHRLine(CHARACTERS_SETTINGS:GetContent())
		CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_gender, "LID_gender", "update_bool_characters_gender")
		CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_othergender, "LID_genderother", "update_bool_characters_othergender", 50)

		CreateHRLine(CHARACTERS_SETTINGS:GetContent())
		CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_characters_changeable_name, "LID_namechangeable", "update_bool_characters_changeable_name")
		
		CreateNumberWangLine(CHARACTERS_SETTINGS:GetContent(), GEN.int_deathtimestamp_min, YRP.lang_string("LID_respawntime") .. " [" .. YRP.lang_string("LID_min") .. "]", "update_int_deathtimestamp_min")
		CreateNumberWangLine(CHARACTERS_SETTINGS:GetContent(), GEN.int_deathtimestamp_max, YRP.lang_string("LID_respawntime") .. " [" .. YRP.lang_string("LID_max") .. "]", "update_int_deathtimestamp_max")
		CreateCheckBoxLine(CHARACTERS_SETTINGS:GetContent(), GEN.bool_spawncorpseondeath, "LID_spawncorpseondeath", "update_bool_spawncorpseondeath")
		


		--[[ SOCIAL SETTINGS ]]--
		local SOCIAL_SETTINGS = createD("YGroupBox", General_Slider, YRP.ctr(800), General_Slider:GetTall(), 0, 0)
		SOCIAL_SETTINGS:SetText("LID_socialsettings")
		function SOCIAL_SETTINGS:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		General_Slider:AddPanel(SOCIAL_SETTINGS)

		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_website, "LID_website", "update_text_social_website")
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_forum, "LID_forum", "update_text_social_forum")
		CreateHRLine(SOCIAL_SETTINGS:GetContent())
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_discord, "LID_discord", "update_text_social_discord")
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_discord_widgetid, YRP.lang_string("LID_discord") .. " " .. YRP.lang_string("LID_serverid"), "update_text_social_discord_widgetid")
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_teamspeak_ip, YRP.lang_string("LID_teamspeak") .. " [" .. YRP.lang_string("LID_ip") .. "/" .. YRP.lang_string("LID_hostname") .. "]", "update_text_social_teamspeak_ip")
		CreateNumberWangLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_teamspeak_port, YRP.lang_string("LID_teamspeak") .. " [" .. YRP.lang_string("LID_port") .. "]", "update_text_social_teamspeak_port")
		CreateNumberWangLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_teamspeak_query_port, YRP.lang_string("LID_teamspeak") .. " [" .. YRP.lang_string("LID_queryport") .. "]", "update_text_social_teamspeak_query_port")
		CreateHRLine(SOCIAL_SETTINGS:GetContent())
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_youtube, "Youtube", "update_text_social_youtube")
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_twitter, "Twitter", "update_text_social_twitter")
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_facebook, "Facebook", "update_text_social_facebook")
		CreateHRLine(SOCIAL_SETTINGS:GetContent())
		CreateTextBoxLine(SOCIAL_SETTINGS:GetContent(), GEN.text_social_steamgroup, "SteamGroup", "update_text_social_steamgroup")
	end
end)

hook.Add("open_server_general", "open_server_general", function()
	SaveLastSite()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	net.Start("Connect_Settings_General")
	net.SendToServer()
end)
