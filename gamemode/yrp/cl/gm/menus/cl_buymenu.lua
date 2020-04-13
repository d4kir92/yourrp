--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #buymenu #buy

BUYMENU = BUYMENU or {}
BUYMENU.open = false

function ToggleBuyMenu()
	if !BUYMENU.open and YRPIsNoMenuOpen() then
		OpenBuyMenu()
	else
		CloseBuyMenu()
	end
end

function CloseBuyMenu()
	BUYMENU.open = false
	if BUYMENU.window != nil then
		closeMenu()
		BUYMENU.window:Remove()
		BUYMENU.window = nil
	end
end

local lnames = {}
net.Receive("GetLicenseName", function(len)
	local id = net.ReadString()
	local tmp = net.ReadString()
	lnames[id] = SQL_STR_OUT(tmp)
end)

function createShopItem(item, duid, id)
	local lply = LocalPlayer()
	YRP.msg("note", "[BUYMENU] createShopItem")
	item.int_level = tonumber(item.int_level)
	local W = 1800
	local H = 500 + 2 * 20
	local BR = 20
	local HE = 60
	local _i = createD("DPanel", nil, YRP.ctr(W), YRP.ctr(H), YRP.ctr(BR), 0)
	function _i:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "HI"))

		draw.RoundedBox(0, YRP.ctr(20), YRP.ctr(20), YRP.ctr(H - 2 * BR), YRP.ctr(H - 2 * BR), lply:InterfaceValue("YFrame", "PC"))
	end
	_i.item = item
	if item.WorldModel != nil and !strEmpty(item.WorldModel) then
		_i.model = createD("DModelPanel", _i, YRP.ctr(H - 2 * BR), YRP.ctr(H - 2 * BR), YRP.ctr(BR), YRP.ctr(BR))
		_i.model:SetModel(item.WorldModel)

		if ea(_i.model.Entity) then
			local _mins, _maxs = _i.model.Entity:GetRenderBounds()
			local _x = _maxs.x - _mins.x
			local _y = _maxs.y - _mins.y
			local _z = _maxs.z - _mins.z
			local _range = math.max(_x, _y, _z)

			_z = _mins.z + (_maxs.z - _mins.z) * 0.46

			_i.model:SetLookAt(Vector(0, 0, _z))
			_i.model:SetCamPos(Vector(0, 0, _z) - Vector(-_range, 0, 0))
		end

		_i.modelc = createD("DButton", _i.model, YRP.ctr(40), YRP.ctr(40), YRP.ctr(20), _i.model:GetTall() - YRP.ctr(40 + 20))
		_i.modelc:SetText("")
		_i.modelc.color = Color(255, 255, 255)
		function _i.modelc:Paint(pw, ph)
			draw.RoundedBox(ph / 2, 0, 0, pw, ph, self.color)
		end
		function _i.modelc:DoClick()
			local mx, my = gui.MousePos()
			local w = createD("DFrame", nil, YRP.ctr(360 + 2 * 20), YRP.ctr(200 + 2 * 20), mx - 50, my - 50)
			w:MakePopup()
			w:SetTitle("")
			w:ShowCloseButton(false)
			function w:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0))
				if self.cc != nil then
					mx, my = gui.MousePos()
					local px, py = self:GetPos()
					if mx < px or my < py or mx > px + pw or my > py + ph then
						self:Remove()
					end
				end
			end

			w.cc = createD("DColorMixer", w, YRP.ctr(360), YRP.ctr(200), YRP.ctr(20), YRP.ctr(20))
			w.cc:SetPalette(false)
			w.cc:SetAlphaBar(false)
			w.cc:SetWangs(true)
			w.cc:SetColor(Color(255, 255, 255))
			function w.cc:ValueChanged(col)
				_i.modelc.color = col
				_i.model:SetColor(_i.modelc.color)
				lply:SetDString("item_color", ColorToString(col))
			end
		end
	end

	if item.name != nil then
		_i.name = createD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(20))
		_i.name.name = SQL_STR_OUT(item.name)
		if item.type == "licenses" then
			_i.name.name = YRP.lang_string("LID_license") .. ": " .. _i.name.name
		end
		function _i.name:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 0))
			draw.SimpleText(self.name, "Y_40_500", 0, ph / 2, Color(255, 255, 255), 0, 1)
		end
	end
	if item.description != nil then
		_i.description = createD("RichText", _i, YRP.ctr(W - H - 20), YRP.ctr(350), YRP.ctr(H), YRP.ctr(20 + HE + 20))
		_i.description.description = SQL_STR_OUT(item.description)
		_i.description:SetText(_i.description.description)
		function _i.description:PerformLayout()
			if self.SetUnderlineFont != nil then
				self:SetUnderlineFont("Y_18_500")
			end
			self:SetFontInternal("Y_18_500")

			--self:SetBGColor(Color(50, 50, 50))
			self:SetFGColor(Color(255, 255, 255))
		end
	end
	if item.price != nil then
		_i.price = createD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE - 20 - HE))
		function _i.price:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 0))
			draw.SimpleText(formatMoney(item.price, LocalPlayer()), "Y_40_500", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end
	if tonumber(item.permanent) == 1 then
		_i.permanent = createD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE - 20 - HE - 20 - HE))
		function _i.permanent:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 0))
			draw.SimpleText("[" .. YRP.lang_string("LID_permanent") .. "]", "Y_40_500", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end

	if LocalPlayer():HasLicense(item.licenseID) then
		YRP.msg("note", "[BUYMENU] HAS LICENSE")
		if IsLevelSystemEnabled() and LocalPlayer():Level() < item.int_level then
			_i.require = createD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
			_i.require.level = item.int_level
			function _i.require:Paint(pw, ph)
				local _color = Color(255, 100, 100)
				draw.RoundedBox(0, 0, 0, pw, ph, _color)
				local tab = {}
				tab["LEVEL"] = self.level
				draw.SimpleText(YRP.lang_string("LID_requires") .. ": " .. YRP.lang_string("LID_levelx", tab), "Y_24_500", pw / 2, ph / 2, Color(0, 0, 0), 1, 1)
			end
		else
			_i.buy = createD("YButton", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
			_i.buy:SetText("")
			_i.buy.item = item
			function _i.buy:Paint(pw, ph)
				local _color = Color(34, 139, 34)
				if !LocalPlayer():canAfford(item.price) then
					_color = Color(255, 100, 100)
				end
				if self:IsHovered() then
					_color = Color(255, 255, 100)
				end
				draw.RoundedBox(0, 0, 0, pw, ph, _color)
				draw.SimpleText(YRP.lang_string("LID_buy"), "Y_24_500", pw / 2, ph / 2, Color(0, 0, 0), 1, 1)
			end
			function _i.buy:DoClick()
				net.Start("item_buy")
					self.item.color = lply:GetDString("item_color", "255, 255, 255")
					net.WriteTable(self.item)
					net.WriteString(duid)
				net.SendToServer()
				CloseBuyMenu()
			end
		end
	else
		_i.require = createD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
		lnames[item.licenseID] = lnames[item.licenseID] or item.licenseID
		net.Start("GetLicenseName")
			net.WriteInt(item.licenseID, 32)
		net.SendToServer()
		function _i.require:Paint(pw, ph)
			local _color = Color(255, 100, 100)
			draw.RoundedBox(0, 0, 0, pw, ph, _color)
			draw.SimpleText(YRP.lang_string("LID_requires") .. ": " .. lnames[item.licenseID], "Y_24_500", pw / 2, ph / 2, Color(0, 0, 0), 1, 1)
		end
	end
	return _i
end

function createStorageItem(item, duid)
	local lply = LocalPlayer()
	local W = 800
	local H = 400
	local _i = createD("DPanel", nil, YRP.ctr(W), YRP.ctr(H), 0, 0)
	function _i:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "HB"))
		drawRBBR(0, 0, 0, pw, ph, Color(160, 160, 160, 255), 1)
	end
	_i.item = item
	if item.WorldModel != nil and item.WorldModel != "" then
		_i.model = createD("DModelPanel", _i, YRP.ctr(W - 50), YRP.ctr(H), YRP.ctr(0), YRP.ctr(0))
		_i.model:SetModel(item.WorldModel)
		if _i.model.Entity != NULL and _i.model.Entity != nil then
			local _mins, _maxs = _i.model.Entity:GetRenderBounds()
			local _x = _maxs.x - _mins.x
			local _y = _maxs.y - _mins.y
			local _z = _maxs.z - _mins.z
			local _range = math.max(_x, _y, _z)

			_z = _mins.z + (_maxs.z - _mins.z) * 0.46

			_i.model:SetLookAt(Vector(0, 0, _z))
			_i.model:SetCamPos(Vector(0, 0, _z) - Vector(-_range, 0, 0))
		end
	end

	if item.name != nil then
		_i.name = createD("DPanel", _i, YRP.ctr(W), YRP.ctr(50), 0, 0)
		_i.name.name = SQL_STR_OUT(item.name)
		function _i.name:Paint(pw, ph)
			draw.SimpleText(self.name, "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end

	if item.type != "licenses" then
		_i.spawn = createD("DButton", _i, YRP.ctr(W), YRP.ctr(50), YRP.ctr(0), YRP.ctr(H - 50))
		_i.spawn:SetText("")
		_i.spawn.item = item
		_i.spawn.action = 0
		_i.spawn.name = "LID_tospawn"
		if IsEntityAlive(LocalPlayer(), item.uniqueID) then
			_i.spawn.action = 1
			_i.spawn.name = "LID_tostore"
		end
		function _i.spawn:Paint(pw, ph)
			local _color = Color(100, 255, 100)
			if !LocalPlayer():canAfford(item.price) then
				_color = Color(255, 100, 100)
			end
			if self:IsHovered() then
				_color = Color(255, 255, 100)
			end
			draw.RoundedBox(0, 0, 0, pw, ph, _color)
			draw.SimpleText(YRP.lang_string(self.name), "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
		function _i.spawn:DoClick()
			if self.action == 0 then
				net.Start("item_spawn")
					net.WriteTable(self.item)
					net.WriteString(duid)
				net.SendToServer()
			elseif self.action == 1 then
				net.Start("item_despawn")
					net.WriteTable(self.item)
				net.SendToServer()
			end

			_i.spawn.action = 0
			_i.spawn.name = "LID_tospawn"
			if IsEntityAlive(LocalPlayer(), item.uniqueID) then
				_i.spawn.action = 1
				_i.spawn.name = "LID_tostore"
			else
				_i.spawn.action = 0
				_i.spawn.name = "LID_tospawn"
			end

			CloseBuyMenu()
		end
	end

	return _i
end

local _mat_set = Material("vgui/yrp/light_settings.png")

net.Receive("shop_get_tabs", function(len)
	local _dealer = net.ReadTable()
	local _dealer_uid = _dealer.uniqueID
	local _tabs = net.ReadTable()

	if !pa(BUYMENU) then return end
	if !pa(BUYMENU.tabs) then return end

	BUYMENU.dUID = _dealer_uid
	if BUYMENU.content:GetParent().standalone then
		BUYMENU.content:GetParent():SetTitle(_dealer.name)
	end

	for i, tab in pairs(_tabs) do
		if !pa(BUYMENU) then return end
		if !pa(BUYMENU.tabs) then return end

		local _tab = BUYMENU.tabs:AddTab(SQL_STR_OUT(tab.name), tab.uniqueID)

		function _tab:GetCategories()
			net.Receive("yrp_shop_get_categories", function(le)
				local lply = LocalPlayer()
				if BUYMENU.shop:IsValid() then
					local _uid = net.ReadString()
					local _cats = net.ReadTable()

					BUYMENU.shop:Clear()

					for j, cat in pairs(_cats) do
						local BR = 20
						local _cat = createD("DYRPCollapsibleCategory", BUYMENU.shop, BUYMENU.shop:GetWide(), YRP.ctr(100), 0, 0)
						_cat.uid = cat.uniqueID
						_cat:SetHeaderHeight(YRP.ctr(100))
						_cat:SetHeader(SQL_STR_OUT(cat.name))
						_cat:SetSpacing(YRP.ctr(BR * 2))
						_cat.color = lply:InterfaceValue("YFrame", "HI")
						_cat.color2 = lply:InterfaceValue("YFrame", "HB")
						function _cat:DoClick()
							if self:IsOpen() then
								YRP.msg("note", "[BUYMENU] CATEGORY OPEN")
								net.Receive("yrp_shop_get_items", function(l)
									local _items = net.ReadTable()
									if IsValid(self) then
										self.hs = self.hs or {}
										local hid = 0
										local id = 0
										local w = YRP.ctr(600 + BR)
										local idmax = math.Round(_cat:GetWide() / w - 0.6, 0)
										for k, item in pairs(_items) do
											--[[if id == 0 then
												YRP.msg("note", "[BUYMENU] CREATE LINE")
												hid = hid + 1
												self.hs[hid] = createD("DPanel", nil, w * idmax, YRP.ctr(650 + 2 * 20), 0, 0)
												local line = self.hs[hid]
												function line:Paint(pw, ph)
													--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 100))
												end

												self:Add(line)
											end]]

											local _item = createShopItem(item, _dealer_uid, nil, id)
											self:Add(_item)
											id = id + 1
											if id >= idmax then
												id = 0
											end
										end
									end
								end)
								net.Start("yrp_shop_get_items")
									net.WriteString(self.uid)
								net.SendToServer()
							else
								self:ClearContent()
							end
						end

						BUYMENU.shop:AddItem(_cat)
						BUYMENU.shop:Rebuild()
					end
					if LocalPlayer():HasAccess() then
						local _remove = createD("DButton", _cat, YRP.ctr(400), YRP.ctr(100), 0, 0)
						_remove:SetText("")
						_remove.uid = _uid
						function _remove:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(200, 50, 50))
							draw.SimpleText(YRP.lang_string("LID_remove") .. " [" .. YRP.lang_string("LID_tab") .. "] => " .. SQL_STR_OUT(tab.name), "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
						end
						function _remove:DoClick()
							net.Start("dealer_rem_tab")
								net.WriteString(_dealer_uid)
								net.WriteString(self.uid)
							net.SendToServer()
							CloseBuyMenu()
						end
						BUYMENU.shop:AddItem(_remove)
						BUYMENU.shop:Rebuild()
					end
				end
			end)
			net.Start("yrp_shop_get_categories")
				net.WriteString(_tab.tbl)
			net.SendToServer()
		end
		function _tab:Click()
			_tab.GetCategories()
		end
	
		if i == 1 then
			_tab:DoClick()
		end

		if tab.haspermanent then
			local _tab2 = BUYMENU.tabs:AddTab(YRP.lang_string("LID_mystorage") .. ": " .. SQL_STR_OUT(tab.name), tab.uniqueID)
			function _tab2:GetCategories()
				net.Receive("yrp_shop_get_categories", function(le)
					local _uid = net.ReadString()
					local _cats = net.ReadTable()

					if wk(BUYMENU.content) then
						BUYMENU.shop:Clear()

						for j, cat in pairs(_cats) do
							local _c = createD("DYRPCollapsibleCategory", BUYMENU.shop, BUYMENU.shop:GetWide(), YRP.ctr(100), 0, 0)
							_c.uid = cat.uniqueID
							_c:SetHeaderHeight(YRP.ctr(100))
							_c:SetHeader(SQL_STR_OUT(cat.name))
							_c:SetSpacing(30)
							_c.color = lply:InterfaceValue("YFrame", "HI")
							_c.color2 = lply:InterfaceValue("YFrame", "HB")
							function _c:DoClick()
								if self:IsOpen() then
									net.Receive("shop_get_items_storage", function(l)
										local _items = net.ReadTable()
										for k, item in pairs(_items) do
											local _item = createStorageItem(item, _dealer_uid)
											self:Add(_item)
										end
									end)
									net.Start("shop_get_items_storage")
										net.WriteString(self.uid)
									net.SendToServer()
								else
									self:ClearContent()
								end
							end

							BUYMENU.shop:AddItem(_c)
							BUYMENU.shop:Rebuild()
						end
					end
				end)
				net.Start("yrp_shop_get_categories")
					net.WriteString(_tab.tbl)
				net.SendToServer()
			end
			function _tab2:Click()
				_tab2.GetCategories()
			end
		end

		if i == 1 then
			_tab.GetCategories()
		end
	end

	if LocalPlayer():HasAccess() then
		if !pa(BUYMENU) then return end
		if !pa(BUYMENU.tabs) then return end

		BUYMENU.addtab = createD("DButton", BUYMENU.content, YRP.ctr(80), YRP.ctr(90), BUYMENU.content:GetWide() - YRP.ctr(100 + 100), YRP.ctr(10))
		BUYMENU.addtab:SetText("")
		function BUYMENU.addtab:Paint(pw, ph)
			local _color = Color(50, 200, 50, 255)
			if self:IsHovered() then
				_color = Color(200, 200, 50, 255)
			end
			draw.RoundedBoxEx(ph / 2, 0, 0, pw, ph, _color, true, true)
			draw.SimpleText(" + ", "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
		function BUYMENU.addtab:DoClick()
			local _tmp = createD("DFrame", nil, YRP.ctr(420), YRP.ctr(50 + 10 + 100 + 10 + 50 + 10), 0, 0)
			function _tmp:Paint(pw, ph)
				if !pa(BUYMENU.tabs) then
					self:Remove()
				end
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
			end
			_tmp:SetTitle("")
			_tmp:Center()
			_tmp:MakePopup()

			_tmp.tabs = createD("DYRPPanelPlus", _tmp, YRP.ctr(400), YRP.ctr(100), YRP.ctr(10), YRP.ctr(50 + 10))
			_tmp.tabs:INITPanel("DComboBox")
			_tmp.tabs:SetHeader(YRP.lang_string("LID_tabs"))

			net.Receive("shop_get_all_tabs", function(l)
				local _ts = net.ReadTable()
				for i, tab in pairs(_ts) do
					_tmp.tabs.plus:AddChoice(SQL_STR_OUT(tab.name), tab.uniqueID)
				end
			end)

			net.Start("shop_get_all_tabs")
			net.SendToServer()

			_tmp.addtab = createD("YButton", _tmp, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50 + 10 + 100 + 10))
			_tmp.addtab:SetText("LID_add")
			function _tmp.addtab:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end
			function _tmp.addtab:DoClick()
				local _name, _uid = _tmp.tabs.plus:GetSelected()
				if _uid != nil then
					net.Start("dealer_add_tab")
						net.WriteString(BUYMENU.dUID)
						net.WriteString(_uid)
					net.SendToServer()
				end
				if self:GetParent().Close != nil then
					self:GetParent():Close()
				end
				CloseBuyMenu()
			end
		end
	end

	--[[ Settings ]]--
	if LocalPlayer():HasAccess() then
		if !pa(BUYMENU) then return end
		if !pa(BUYMENU.tabs) then return end

		BUYMENU.settings = createD("YButton", BUYMENU.content, YRP.ctr(80), YRP.ctr(80), BUYMENU.content:GetWide() - YRP.ctr(100), YRP.ctr(10))
		BUYMENU.settings:SetText("")
		function BUYMENU.settings:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
			local _br = 4
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(_mat_set)
			surface.DrawTexturedRect(YRP.ctr(_br), YRP.ctr(_br), pw-YRP.ctr(2 * _br), ph-YRP.ctr(2 * _br))
		end
		function BUYMENU.settings:DoClick()
			net.Receive("dealer_settings", function(le)
				local _set = createD("DFrame", nil, YRP.ctr(600), YRP.ctr(60 + 110 + 110 + 110), 0, 0)
				_set:SetTitle("")
				_set:Center()
				_set:MakePopup()
				function _set:Paint(pw, ph)
					CloseBuyMenu()
					draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
				end

				_set.name = createD("DYRPPanelPlus", _set, YRP.ctr(560), YRP.ctr(100), YRP.ctr(20), YRP.ctr(60))
				_set.name:INITPanel("DTextEntry")
				_set.name:SetHeader(YRP.lang_string("LID_name"))
				_set.name:SetText(_dealer.name)
				function _set.name.plus:OnChange()
					_dealer.name = self:GetText()
					net.Start("dealer_edit_name")
						net.WriteString(_dealer.uniqueID)
						net.WriteString(_dealer.name)
					net.SendToServer()
				end

				_set.name = createD("DYRPPanelPlus", _set, YRP.ctr(560), YRP.ctr(100), YRP.ctr(20), YRP.ctr(170))
				_set.name:INITPanel("YButton")
				_set.name:SetHeader(YRP.lang_string("LID_appearance"))
				_set.name.plus:SetText("LID_change")
				function _set.name.plus:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end
				function _set.name.plus:DoClick()
					local playermodels = player_manager.AllValidModels()
					local tmpTable = {}
					local count = 0
					for k, v in pairs(playermodels) do
						count = count + 1
						tmpTable[count] = {}
						tmpTable[count].WorldModel = v
						tmpTable[count].ClassName = v
						tmpTable[count].PrintName = player_manager.TranslateToPlayerModelName(v)
					end
					_globalWorking = _dealer.WorldModel
					hook.Add("close_dealerWorldmodel", "close_dealerWorldmodelHook", function()
						_dealer.WorldModel = LocalPlayer():GetDString("WorldModel")

						net.Start("dealer_edit_worldmodel")
							net.WriteString(_dealer.uniqueID)
							net.WriteString(_dealer.WorldModel)
						net.SendToServer()
					end)
					openSingleSelector(tmpTable, "close_dealerWorldmodel")
				end

				local _storages = net.ReadTable()
				_set.storagepoint = createD("DYRPPanelPlus", _set, YRP.ctr(560), YRP.ctr(100), YRP.ctr(20), YRP.ctr(280))
				_set.storagepoint:INITPanel("DComboBox")
				_set.storagepoint:SetHeader(YRP.lang_string("LID_storagepoint"))
				for i, storage in pairs(_storages) do
					local _sp = false
					if tonumber(storage.uniqueID) == tonumber(_dealer.storagepoints) then
						_sp = true
					end
					_set.storagepoint.plus:AddChoice(storage.name, storage.uniqueID, _sp)
				end
				function _set.storagepoint.plus:OnSelect(index, value, data)
					net.Start("dealer_edit_storagepoints")
						net.WriteString(_dealer.uniqueID)
						net.WriteString(data)
					net.SendToServer()
				end
			end)

			net.Start("dealer_settings")
			net.SendToServer()
		end
	end
end)

function CreateBuyMenuContent(parent, uid)
	uid = uid or 1
	
	if IsValid(parent) then
		BUYMENU.content = parent
		--[[ Shop ]]--
		BUYMENU.shop = createD("DPanelList", BUYMENU.content, BUYMENU.content:GetWide(), BUYMENU.content:GetTall() - YRP.ctr(100), YRP.ctr(0), YRP.ctr(100))
		BUYMENU.shop:EnableVerticalScrollbar(true)
		BUYMENU.shop:SetSpacing(20)
		BUYMENU.shop:SetNoSizing(false)
		function BUYMENU.shop:Paint(pw, ph)
			self:SetWide(BUYMENU.content:GetWide())
			self:SetTall(BUYMENU.content:GetTall())
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 100, 240))
		end

		BUYMENU.tabs = createD("DYRPTabs", BUYMENU.content, BUYMENU.content:GetWide(), YRP.ctr(100), 0, 0)
		BUYMENU.tabs:SetSelectedColor(lply:InterfaceValue("YButton", "SC"))
		BUYMENU.tabs:SetUnselectedColor(lply:InterfaceValue("YButton", "NC"))
		BUYMENU.tabs:SetSize(BUYMENU.shop:GetWide(), YRP.ctr(100))
		if LocalPlayer():HasAccess() then
			BUYMENU.tabs:SetSize(BUYMENU.shop:GetWide() - YRP.ctr(220), YRP.ctr(100))
		end

		net.Start("shop_get_tabs")
			net.WriteString(uid)
		net.SendToServer()
	end
end

function OpenBuyMenu(uid)
	uid = uid or 1
	openMenu()

	BUYMENU.open = true
	BUYMENU.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	BUYMENU.window.standalone = true
	BUYMENU.window:Center()
	BUYMENU.window:SetDraggable(true)
	--BUYMENU.window:SetSizable(true)
	BUYMENU.window:SetHeaderHeight(YRP.ctr(100))
	function BUYMENU.window:OnClose()
		closeMenu()
	end
	function BUYMENU.window:OnRemove()
		closeMenu()
	end

	BUYMENU.window.systime = SysTime()
	function BUYMENU.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph)
	end
	BUYMENU.window:MakePopup()

	CreateBuyMenuContent(BUYMENU.window.con, uid)
end
