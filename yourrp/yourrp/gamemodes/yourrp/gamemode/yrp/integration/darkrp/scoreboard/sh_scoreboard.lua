--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
FAdmin = FAdmin or {}
FAdmin.PlayerActions = FAdmin.PlayerActions or {}
FAdmin.StartHooks = FAdmin.StartHooks or {}
FAdmin.GlobalSetting = FAdmin.GlobalSetting or {}
FAdmin.ScoreBoard = FAdmin.ScoreBoard or {}
FAdmin.Commands = {}
FAdmin.Commands.List = {}
function FAdmin.Commands.AddCommand(name, callback, ...)
	FAdmin.Commands.List[string.lower(name)] = {
		callback = callback,
		ExtraArgs = {...}
	}
end

FAdmin.ScoreBoard.Controls = FAdmin.ScoreBoard.Controls or {}
FAdmin.ScoreBoard.CurrentView = "Main"
FAdmin.ScoreBoard.Main = FAdmin.ScoreBoard.Main or {}
FAdmin.ScoreBoard.Main.Controls = FAdmin.ScoreBoard.Main.Controls or {}
FAdmin.ScoreBoard.Main.Logo = "gui/gmod_logo"
FAdmin.ScoreBoard.Player = FAdmin.ScoreBoard.Player or {}
FAdmin.ScoreBoard.Player.Controls = FAdmin.ScoreBoard.Player.Controls or {}
FAdmin.ScoreBoard.Player.Player = NULL
FAdmin.ScoreBoard.Player.Logo = "fadmin/back"
FAdmin.ScoreBoard.Server = FAdmin.ScoreBoard.Server or {}
FAdmin.ScoreBoard.Server.Controls = FAdmin.ScoreBoard.Server.Controls or {}
FAdmin.ScoreBoard.Server.Logo = "fadmin/back"
FAdmin.ScoreBoard.Player.Information = {}
FAdmin.ScoreBoard.Player.ActionButtons = {}
function FAdmin.ScoreBoard.Player.Show(ply)
	ply = ply or FAdmin.ScoreBoard.Player.Player
	FAdmin.ScoreBoard.Player.Player = ply
	if not IsValid(ply) or not IsValid(FAdmin.ScoreBoard.Player.Player) then
		FAdmin.ScoreBoard.ChangeView("Main")

		return
	end

	local ScreenHeight = ScrH()
	FAdmin.ScoreBoard.Player.Controls.AvatarBackground = vgui.Create("AvatarImage")
	FAdmin.ScoreBoard.Player.Controls.AvatarBackground:SetPos(FAdmin.ScoreBoard.X + 20, FAdmin.ScoreBoard.Y + 100)
	FAdmin.ScoreBoard.Player.Controls.AvatarBackground:SetSize(184, 184)
	FAdmin.ScoreBoard.Player.Controls.AvatarBackground:SetPlayer(ply, 184)
	FAdmin.ScoreBoard.Player.Controls.AvatarBackground:SetVisible(true)
	FAdmin.ScoreBoard.Player.InfoPanels = FAdmin.ScoreBoard.Player.InfoPanels or {}
	for k, v in pairs(FAdmin.ScoreBoard.Player.InfoPanels) do
		if IsValid(v) then
			v:Remove()
			FAdmin.ScoreBoard.Player.InfoPanels[k] = nil
		end
	end

	if IsValid(FAdmin.ScoreBoard.Player.Controls.InfoPanel1) then
		FAdmin.ScoreBoard.Player.Controls.InfoPanel1:Remove()
	end

	FAdmin.ScoreBoard.Player.Controls.InfoPanel1 = vgui.Create("DListLayout")
	FAdmin.ScoreBoard.Player.Controls.InfoPanel1:SetPos(FAdmin.ScoreBoard.X + 20, FAdmin.ScoreBoard.Y + 100 + 184 + 5) --[[ + Avatar size]]
	FAdmin.ScoreBoard.Player.Controls.InfoPanel1:SetSize(184, ScreenHeight * 0.1 + 2)
	FAdmin.ScoreBoard.Player.Controls.InfoPanel1:SetVisible(true)
	FAdmin.ScoreBoard.Player.Controls.InfoPanel1:Clear(true)
	FAdmin.ScoreBoard.Player.Controls.InfoPanel2 = FAdmin.ScoreBoard.Player.Controls.InfoPanel2 or vgui.Create("FAdminPanelList")
	FAdmin.ScoreBoard.Player.Controls.InfoPanel2:SetPos(FAdmin.ScoreBoard.X + 25 + 184, FAdmin.ScoreBoard.Y + 100) --[[+ Avatar]]
	FAdmin.ScoreBoard.Player.Controls.InfoPanel2:SetSize(FAdmin.ScoreBoard.Width - 184 - 30 - 10, 184 + 5 + ScreenHeight * 0.1 + 2)
	FAdmin.ScoreBoard.Player.Controls.InfoPanel2:SetVisible(true)
	FAdmin.ScoreBoard.Player.Controls.InfoPanel2:Clear(true)
	local function AddInfoPanel()
		local pan = FAdmin.ScoreBoard.Player.Controls.InfoPanel2:Add("DListLayout")
		pan:SetSize(1, FAdmin.ScoreBoard.Player.Controls.InfoPanel2:GetTall())
		table.insert(FAdmin.ScoreBoard.Player.InfoPanels, pan)

		return pan
	end

	local SelectedPanel = AddInfoPanel() -- Make first panel to put the first things in
	for k, v in pairs(FAdmin.ScoreBoard.Player.Information) do
		SelectedPanel:Dock(LEFT)
		local Value = v.func(FAdmin.ScoreBoard.Player.Player)
		--if not Value or Value == "" then return --[[ Value = "N/A" ]] end
		if Value and Value ~= "" then
			local Text = vgui.Create("DLabel")
			Text:Dock(LEFT)
			Text:SetFont("TabLarge")
			Text:SetText(v.name .. ": " .. Value)
			Text:SizeToContents()
			Text:SetColor(Color(200, 200, 200, 200))
			Text:SetTooltip("Click to copy " .. v.name .. " to clipboard")
			Text:SetMouseInputEnabled(true)
			function Text:OnMousePressed(mcode)
				self:SetTooltip(v.name .. " copied to clipboard!")
				ChangeTooltip(self)
				SetClipboardText(Value)
				self:SetTooltip("Click to copy " .. v.name .. " to clipboard")
			end

			timer.Create(
				"FAdmin_Scoreboard_text_update_" .. v.name,
				1,
				0,
				function()
					if not IsValid(ply) or not IsValid(FAdmin.ScoreBoard.Player.Player) or not IsValid(Text) then
						timer.Remove("FAdmin_Scoreboard_text_update_" .. v.name)
						if FAdmin.ScoreBoard.Visible and (not IsValid(ply) or not IsValid(FAdmin.ScoreBoard.Player.Player)) then
							FAdmin.ScoreBoard.ChangeView("Main")
						end

						return
					end

					Value = v.func(FAdmin.ScoreBoard.Player.Player)
					if not Value or Value == "" then
						Value = "N/A"
					end

					Text:SetText(v.name .. ": " .. Value)
				end
			)

			if (#FAdmin.ScoreBoard.Player.Controls.InfoPanel1:GetChildren() * 17 + 17) <= FAdmin.ScoreBoard.Player.Controls.InfoPanel1:GetTall() and not v.NewPanel then
				FAdmin.ScoreBoard.Player.Controls.InfoPanel1:Add(Text)
			else
				if #SelectedPanel:GetChildren() * 17 + 17 >= SelectedPanel:GetTall() or v.NewPanel then
					SelectedPanel = AddInfoPanel() -- Add new panel if the last one is full
				end

				SelectedPanel:Add(Text)
				if Text:GetWide() > SelectedPanel:GetWide() then
					SelectedPanel:SetWide(Text:GetWide() + 40)
				end
			end
		end
	end

	local CatColor = team.GetColor(ply:Team())
	if GAMEMODE.Name == "Sandbox" then
		CatColor = Color(100, 150, 245, 255)
		if ply:Team() == TEAM_CONNECTING then
			CatColor = Color(200, 120, 50, 255)
		elseif ply:IsAdmin() then
			CatColor = Color(30, 200, 50, 255)
		end

		if ply:GetFriendStatus() == "friend" then
			CatColor = Color(236, 181, 113, 255)
		end
	end

	FAdmin.ScoreBoard.Player.Controls.ButtonCat = FAdmin.ScoreBoard.Player.Controls.ButtonCat or vgui.Create("FAdminPlayerCatagory")
	FAdmin.ScoreBoard.Player.Controls.ButtonCat:SetLabel("	Player options!")
	FAdmin.ScoreBoard.Player.Controls.ButtonCat.CatagoryColor = CatColor
	FAdmin.ScoreBoard.Player.Controls.ButtonCat:SetSize(FAdmin.ScoreBoard.Width - 40, 100)
	FAdmin.ScoreBoard.Player.Controls.ButtonCat:SetPos(FAdmin.ScoreBoard.X + 20, FAdmin.ScoreBoard.Y + 100 + FAdmin.ScoreBoard.Player.Controls.InfoPanel2:GetTall() + 5)
	FAdmin.ScoreBoard.Player.Controls.ButtonCat:SetVisible(true)
	function FAdmin.ScoreBoard.Player.Controls.ButtonCat:Toggle()
	end

	FAdmin.ScoreBoard.Player.Controls.ButtonPanel = FAdmin.ScoreBoard.Player.Controls.ButtonPanel or vgui.Create("FAdminPanelList", FAdmin.ScoreBoard.Player.Controls.ButtonCat)
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:SetSpacing(5)
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:EnableHorizontal(true)
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:EnableVerticalScrollbar(true)
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:SizeToContents()
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:SetVisible(true)
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:SetSize(0, (ScreenHeight - FAdmin.ScoreBoard.Y - 40) - (FAdmin.ScoreBoard.Y + 100 + FAdmin.ScoreBoard.Player.Controls.InfoPanel2:GetTall() + 5))
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:Clear()
	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:DockMargin(5, 5, 5, 5)
	for _, v in ipairs(FAdmin.ScoreBoard.Player.ActionButtons) do
		if v.Visible == true or (type(v.Visible) == "function" and v.Visible(FAdmin.ScoreBoard.Player.Player) == true) then
			local ActionButton = vgui.Create("FAdminActionButton")
			if type(v.Image) == "string" then
				ActionButton:SetImage(v.Image or "icon16/exclamation")
			elseif type(v.Image) == "table" then
				ActionButton:SetImage(v.Image[1])
				if v.Image[2] then
					ActionButton:SetImage2(v.Image[2])
				end
			elseif type(v.Image) == "function" then
				local img1, img2 = v.Image(ply)
				ActionButton:SetImage(img1)
				if img2 then
					ActionButton:SetImage2(img2)
				end
			else
				ActionButton:SetImage("icon16/exclamation")
			end

			local name = v.Name
			if type(name) == "function" then
				name = name(FAdmin.ScoreBoard.Player.Player)
			end

			ActionButton:SetText(DarkRP.deLocalise(name))
			ActionButton:SetBorderColor(v.color)
			function ActionButton:DoClick()
				if not IsValid(FAdmin.ScoreBoard.Player.Player) then return end

				return v.Action(FAdmin.ScoreBoard.Player.Player, self)
			end

			FAdmin.ScoreBoard.Player.Controls.ButtonPanel:AddItem(ActionButton)
			if v.OnButtonCreated then
				v.OnButtonCreated(FAdmin.ScoreBoard.Player.Player, ActionButton)
			end
		end
	end

	FAdmin.ScoreBoard.Player.Controls.ButtonPanel:Dock(TOP)
end

-- ForeNewPanel is to start a new column
function FAdmin.ScoreBoard.Player:AddInformation(name, func, ForceNewPanel)
	table.insert(
		FAdmin.ScoreBoard.Player.Information,
		{
			name = name,
			func = func,
			NewPanel = ForceNewPanel
		}
	)
end

function FAdmin.ScoreBoard.Player:AddActionButton(Name, Image, color, Visible, Action, OnButtonCreated)
	table.insert(
		FAdmin.ScoreBoard.Player.ActionButtons,
		{
			Name = Name,
			Image = Image,
			color = color,
			Visible = Visible,
			Action = Action,
			OnButtonCreated = OnButtonCreated
		}
	)
end

FAdmin.ScoreBoard.Player:AddInformation("Name", function(ply) return ply:Nick() end)
FAdmin.ScoreBoard.Player:AddInformation("Kills", function(ply) return ply:Frags() end)
FAdmin.ScoreBoard.Player:AddInformation("Deaths", function(ply) return ply:Deaths() end)
FAdmin.ScoreBoard.Player:AddInformation("Health", function(ply) return ply:Health() end)
FAdmin.ScoreBoard.Player:AddInformation("Ping", function(ply) return ply:Ping() end)
FAdmin.ScoreBoard.Player:AddInformation("SteamID", function(ply) return ply:YRPSteamID() end, true)
FAdmin.ScoreBoard.Server.Information = {} -- Compatibility for autoreload
FAdmin.ScoreBoard.Server.ActionButtons = {} -- Refresh server buttons when reloading gamemode
local function MakeServerOptions()
	local _, YPos, Width = 20, FAdmin.ScoreBoard.Y + 120 + FAdmin.ScoreBoard.Height / 5 + 20, (FAdmin.ScoreBoard.Width - 40) / 3
	FAdmin.ScoreBoard.Server.Controls.ServerActionsCat = FAdmin.ScoreBoard.Server.Controls.ServerActionsCat or vgui.Create("FAdminPlayerCatagory")
	FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetLabel("	Server Actions")
	FAdmin.ScoreBoard.Server.Controls.ServerActionsCat.CatagoryColor = Color(155, 0, 0, 255)
	FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetSize(Width - 5, FAdmin.ScoreBoard.Height - 20 - YPos)
	FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetPos(FAdmin.ScoreBoard.X + 20, YPos)
	FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetVisible(true)
	function FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:Toggle()
	end

	FAdmin.ScoreBoard.Server.Controls.ServerActions = FAdmin.ScoreBoard.Server.Controls.ServerActions or vgui.Create("FAdminPanelList")
	FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetContents(FAdmin.ScoreBoard.Server.Controls.ServerActions)
	FAdmin.ScoreBoard.Server.Controls.ServerActions:SetTall(FAdmin.ScoreBoard.Height - 20 - YPos)
	for k, v in pairs(FAdmin.ScoreBoard.Server.Controls.ServerActions:GetChildren()) do
		if k == 1 then continue end
		v:Remove()
	end

	FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat = FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat or vgui.Create("FAdminPlayerCatagory")
	FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetLabel("	Player Actions")
	FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat.CatagoryColor = Color(0, 155, 0, 255)
	FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetSize(Width - 5, FAdmin.ScoreBoard.Height - 20 - YPos)
	FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetPos(FAdmin.ScoreBoard.X + 20 + Width, YPos)
	FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetVisible(true)
	function FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:Toggle()
	end

	FAdmin.ScoreBoard.Server.Controls.PlayerActions = FAdmin.ScoreBoard.Server.Controls.PlayerActions or vgui.Create("FAdminPanelList")
	FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetContents(FAdmin.ScoreBoard.Server.Controls.PlayerActions)
	FAdmin.ScoreBoard.Server.Controls.PlayerActions:SetTall(FAdmin.ScoreBoard.Height - 20 - YPos)
	for k, v in pairs(FAdmin.ScoreBoard.Server.Controls.PlayerActions:GetChildren()) do
		if k == 1 then continue end
		v:Remove()
	end

	FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat = FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat or vgui.Create("FAdminPlayerCatagory")
	FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetLabel("	Server Settings")
	FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat.CatagoryColor = Color(0, 0, 155, 255)
	FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetSize(Width - 5, FAdmin.ScoreBoard.Height - 20 - YPos)
	FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetPos(FAdmin.ScoreBoard.X + 20 + Width * 2, YPos)
	FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetVisible(true)
	function FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:Toggle()
	end

	FAdmin.ScoreBoard.Server.Controls.ServerSettings = FAdmin.ScoreBoard.Server.Controls.ServerSettings or vgui.Create("FAdminPanelList")
	FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetContents(FAdmin.ScoreBoard.Server.Controls.ServerSettings)
	FAdmin.ScoreBoard.Server.Controls.ServerSettings:SetTall(FAdmin.ScoreBoard.Height - 20 - YPos)
	for k, v in pairs(FAdmin.ScoreBoard.Server.Controls.ServerSettings:GetChildren()) do
		if k == 1 then continue end
		v:Remove()
	end

	for k, v in ipairs(FAdmin.ScoreBoard.Server.ActionButtons) do
		local visible = v.Visible == true or (type(v.Visible) == "function" and v.Visible(LocalPlayer()) == true)
		local ActionButton = vgui.Create("FAdminActionButton")
		if type(v.Image) == "string" then
			ActionButton:SetImage(v.Image or "icon16/exclamation")
		elseif type(v.Image) == "table" then
			ActionButton:SetImage(v.Image[1])
			if v.Image[2] then
				ActionButton:SetImage2(v.Image[2])
			end
		elseif type(v.Image) == "function" then
			local img1, img2 = v.Image()
			ActionButton:SetImage(img1)
			if img2 then
				ActionButton:SetImage2(img2)
			end
		else
			ActionButton:SetImage("icon16/exclamation")
		end

		local name = v.Name
		if type(name) == "function" then
			name = name()
		end

		ActionButton:SetText(DarkRP.deLocalise(name))
		ActionButton:SetBorderColor(visible and v.color or Color(120, 120, 120))
		ActionButton:SetDisabled(not visible)
		ActionButton:Dock(TOP)
		function ActionButton:DoClick()
			return v.Action(self)
		end

		FAdmin.ScoreBoard.Server.Controls[v.TYPE]:Add(ActionButton)
		if v.OnButtonCreated then
			v.OnButtonCreated(ActionButton)
		end
	end
end

function FAdmin.ScoreBoard.Server:AddServerAction(Name, Image, color, Visible, Action, OnButtonCreated)
	table.insert(
		FAdmin.ScoreBoard.Server.ActionButtons,
		{
			TYPE = "ServerActions",
			Name = Name,
			Image = Image,
			color = color,
			Visible = Visible,
			Action = Action,
			OnButtonCreated = OnButtonCreated
		}
	)
end

function FAdmin.ScoreBoard.Server:AddPlayerAction(Name, Image, color, Visible, Action, OnButtonCreated)
	table.insert(
		FAdmin.ScoreBoard.Server.ActionButtons,
		{
			TYPE = "PlayerActions",
			Name = Name,
			Image = Image,
			color = color,
			Visible = Visible,
			Action = Action,
			OnButtonCreated = OnButtonCreated
		}
	)
end

function FAdmin.ScoreBoard.Server:AddServerSetting(Name, Image, color, Visible, Action, OnButtonCreated)
	table.insert(
		FAdmin.ScoreBoard.Server.ActionButtons,
		{
			TYPE = "ServerSettings",
			Name = Name,
			Image = Image,
			color = color,
			Visible = Visible,
			Action = Action,
			OnButtonCreated = OnButtonCreated
		}
	)
end

function FAdmin.ScoreBoard.Server.Show(ply)
	FAdmin.ScoreBoard.Server.InfoPanels = FAdmin.ScoreBoard.Server.InfoPanels or {}
	for k, v in pairs(FAdmin.ScoreBoard.Server.InfoPanels) do
		if IsValid(v) then
			v:Remove()
			FAdmin.ScoreBoard.Server.InfoPanels[k] = nil
		end
	end

	if IsValid(FAdmin.ScoreBoard.Server.Controls.InfoPanel) then
		FAdmin.ScoreBoard.Server.Controls.InfoPanel:Remove()
	end

	FAdmin.ScoreBoard.Server.Controls.InfoPanel = vgui.Create("FAdminPanelList")
	FAdmin.ScoreBoard.Server.Controls.InfoPanel:SetPos(FAdmin.ScoreBoard.X + 20, FAdmin.ScoreBoard.Y + 120)
	FAdmin.ScoreBoard.Server.Controls.InfoPanel:SetSize(FAdmin.ScoreBoard.Width - 40, FAdmin.ScoreBoard.Height / 5)
	FAdmin.ScoreBoard.Server.Controls.InfoPanel:SetVisible(true)
	FAdmin.ScoreBoard.Server.Controls.InfoPanel:Clear(true)
	local function AddInfoPanel()
		local pan = vgui.Create("FAdminPanelList")
		pan:SetSize(1, FAdmin.ScoreBoard.Server.Controls.InfoPanel:GetTall())
		pan:Dock(LEFT)
		FAdmin.ScoreBoard.Server.Controls.InfoPanel:Add(pan)
		table.insert(FAdmin.ScoreBoard.Server.InfoPanels, pan)

		return pan
	end

	local SelectedPanel = AddInfoPanel() -- Make first panel to put the first things in
	for _, v in pairs(FAdmin.ScoreBoard.Server.Information) do
		local Text = vgui.Create("DLabel")
		Text:SetFont("TabLarge")
		Text:SetColor(Color(255, 255, 255, 200))
		Text:Dock(TOP)
		Text.Func = v.Func
		local EndText
		local function RefreshText()
			local Value = v.func()
			if not Value or Value == "" then
				Value = "N/A"
			end

			EndText = v.name .. ":	" .. Value
			local strLen = string.len(EndText)
			if strLen > 40 then
				local NewValue = string.sub(EndText, 1, 40)
				for i = 40, strLen, 34 do
					NewValue = NewValue .. "\n				" .. string.sub(EndText, i + 1, i + 34)
				end

				EndText = NewValue
			else
				local MaxWidth = 240
				surface.SetFont("TabLarge")
				local TextWidth = surface.GetTextSize(v.name .. ": " .. Value)
				if TextWidth <= MaxWidth then
					local SpacesAmount = (MaxWidth - TextWidth) / 3
					local Spaces = ""
					for i = 1, SpacesAmount do
						Spaces = Spaces .. " "
					end

					EndText = v.name .. ":" .. Spaces .. Value
				end
			end

			Text:SetText(DarkRP.deLocalise(EndText))
			Text:SizeToContents()
			Text:SetTooltip("Click to copy " .. v.name .. " to clipboard")
			Text:SetMouseInputEnabled(true)
		end

		RefreshText()
		function Text:OnMousePressed(mcode)
			self:SetTooltip(v.name .. " copied to clipboard!")
			ChangeTooltip(self)
			SetClipboardText(v.func() or "")
			self:SetTooltip("Click to copy " .. v.name .. " to clipboard")
		end

		timer.Create(
			"FAdmin_Scoreboard_text_update_" .. v.name,
			1,
			0,
			function()
				if not IsValid(Text) then
					timer.Remove("FAdmin_Scoreboard_text_update_" .. v.name)
					FAdmin.ScoreBoard.ChangeView("Main")

					return
				end

				RefreshText()
			end
		)

		if #SelectedPanel:GetChildren() * 17 + 17 >= SelectedPanel:GetTall() or v.NewPanel then
			SelectedPanel = AddInfoPanel()
		end

		-- Add new panel if the last one is full
		SelectedPanel:Add(Text)
		if Text:GetWide() > SelectedPanel:GetWide() then
			SelectedPanel:SetWide(Text:GetWide() + 40)
		end
	end

	MakeServerOptions()
end

-- ForeNewPanel is to start a new column
function FAdmin.ScoreBoard.Server:AddInformation(name, func, ForceNewPanel)
	table.insert(
		FAdmin.ScoreBoard.Server.Information,
		{
			name = name,
			func = func,
			NewPanel = ForceNewPanel
		}
	)
end

FAdmin.ScoreBoard.Server:AddInformation("Hostname", GetHostName)
FAdmin.ScoreBoard.Server:AddInformation("Gamemode", function() return GAMEMODE.Name end)
FAdmin.ScoreBoard.Server:AddInformation("Author", function() return GAMEMODE.Author end)
FAdmin.ScoreBoard.Server:AddInformation("Map", GetMapNameDB())
FAdmin.ScoreBoard.Server:AddInformation("Players", function() return player.GetCount() .. "/" .. game.MaxPlayers() end)
FAdmin.ScoreBoard.Server:AddInformation("Ping", function() return LocalPlayer():Ping() end)