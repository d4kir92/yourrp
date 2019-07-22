--Copyright (C) 2017-2019 Arno Zura (https: /  / www.gnu.org / licenses / gpl.txt)

local _bm = {}

function toggleBuyMenu()
	if isNoMenuOpen() then
		openBuyMenu()
	else
		closeBuyMenu()
	end
end

function closeBuyMenu()
	if _bm.window != nil then
		closeMenu()
		_bm.window:Remove()
		_bm.window = nil
	end
end

function createShopItem(item, duid)
	item.int_level = tonumber(item.int_level)
	local _w = 2000
	local _h = 400
	local _i = createD("DPanel", nil, ctrb(_w), ctrb(_h), 0, 0)
	function _i:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
	end
	_i.item = item
	if item.WorldModel != nil then
		if item.WorldModel != "" then
			_i.model = createD("DModelPanel", _i, ctrb(_w / 2), ctrb(_h), ctrb(0), ctrb(0))
			_i.model:SetModel(item.WorldModel)

			if ea(_i.model.Entity) then
				local _mins, _maxs = _i.model.Entity:GetRenderBounds()
				local _x = _maxs.x - _mins.x
				local _y = _maxs.y - _mins.y
				local _range = 0
				if _x > _y then
					_range = _x
				elseif _y > _x then
					_range = _y
				end

				local _z = _mins.z + (_maxs.z - _mins.z) * 2 / 3

				_i.model:SetLookAt(Vector(0, 0, _z))
				_i.model:SetCamPos(Vector(0, 0, _z) - Vector(-_range * 1.6, 0, 0))
			end
		else
			printGM("note", "[BuyMenu] WorldModel empty.")
		end
	end

	if item.name != nil then
		_i.name = createD("DPanel", _i, ctrb(_w / 2), ctrb(50), 0, 0)
		_i.name.name = SQL_STR_OUT(item.name)
		if item.type == "licenses" then
			_i.name.name = YRP.lang_string("LID_license") .. ": " .. _i.name.name
		end
		function _i.name:Paint(pw, ph)
			surfaceText(self.name, "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end
	if item.price != nil then
		_i.price = createD("DPanel", _i, ctrb(_w / 2), ctrb(50), ctrb(_w / 2), ctrb(300))
		function _i.price:Paint(pw, ph)
			surfaceText(formatMoney(item.price, LocalPlayer()), "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end
	if tonumber(item.permanent) == 1 then
		_i.price = createD("DPanel", _i, ctrb(_w / 2), ctrb(50), 0, ctrb(50))
		function _i.price:Paint(pw, ph)
			surfaceText("[" .. YRP.lang_string("LID_permanent") .. "]", "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end

	item.description = SQL_STR_OUT(item.description)
	if item.description != "" then
		_i.description = createD("DTextEntry", _i, ctrb(_w / 2), ctrb(_h - 100), ctrb(_w / 2), ctrb(0))
		_i.description:SetMultiline(true)
		_i.description:SetEditable(false)
		_i.description:SetText(SQL_STR_OUT(item.description))
	end

	if LocalPlayer():HasLicense(item.licenseID) then
		if LocalPlayer():Level() < item.int_level then
			_i.require = createD("DPanel", _i, ctrb(_w), ctrb(50), ctrb(0), ctrb(350))
			_i.require.level = item.int_level
			function _i.require:Paint(pw, ph)
				local _color = Color(255, 0, 0)
				draw.RoundedBox(0, 0, 0, pw, ph, _color)
				local tab = {}
				tab["LEVEL"] = self.level
				surfaceText(YRP.lang_string("LID_requires") .. ": " .. YRP.lang_string("LID_levelx", tab), "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
			end
		else
			_i.buy = createD("DButton", _i, ctrb(_w / 2), ctrb(50), ctrb(_w / 2), ctrb(350))
			_i.buy:SetText("")
			_i.buy.item = item
			function _i.buy:Paint(pw, ph)
				local _color = Color(0, 255, 0)
				if !LocalPlayer():canAfford(item.price) then
					_color = Color(255, 0, 0)
				end
				if self:IsHovered() then
					_color = Color(255, 255, 0)
				end
				draw.RoundedBox(0, 0, 0, pw, ph, _color)
				surfaceText(YRP.lang_string("LID_buy"), "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
			end
			function _i.buy:DoClick()
				net.Start("item_buy")
					net.WriteTable(self.item)
					net.WriteString(duid)
				net.SendToServer()
				closeBuyMenu()
			end
		end
	else
		_i.require = createD("DPanel", _i, ctrb(_w), ctrb(50), ctrb(0), ctrb(350))
		_i.require.text = "[NOT FOUND]"
		net.Receive("GetLicenseName", function(len)
			local tmp = net.ReadString()
			if wk(tmp) and _i.require != nil then
				_i.require.text = SQL_STR_OUT(tmp)
			end
		end)
		net.Start("GetLicenseName")
			net.WriteInt(item.licenseID, 32)
		net.SendToServer()
		function _i.require:Paint(pw, ph)
			local _color = Color(255, 0, 0)
			draw.RoundedBox(0, 0, 0, pw, ph, _color)
			surfaceText(YRP.lang_string("LID_requires") .. ": " .. self.text, "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end
	return _i
end

function createStorageItem(item, duid)
	local _w = 800
	local _h = 400
	local _i = createD("DPanel", nil, ctrb(_w), ctrb(_h), 0, 0)
	function _i:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
	end
	_i.item = item
	if item.WorldModel != nil then
		if item.WorldModel != "" then
			_i.model = createD("DModelPanel", _i, ctrb(_w - 50), ctrb(_h), ctrb(0), ctrb(0))
			_i.model:SetModel(item.WorldModel)
			if _i.model.Entity != NULL and _i.model.Entity != nil then
				local _mins, _maxs = _i.model.Entity:GetRenderBounds()
				local _x = _maxs.x - _mins.x
				local _y = _maxs.y - _mins.y
				local _range = 0
				if _x > _y then
					_range = _x
				elseif _y > _x then
					_range = _y
				end

				local _z = _mins.z + (_maxs.z - _mins.z) * 2 / 3

				_i.model:SetLookAt(Vector(0, 0, _z))
				_i.model:SetCamPos(Vector(0, 0, _z) - Vector(-_range * 1.6, 0, 0))
			end
		else
			printGM("note", "[BuyMenu] WorldModel empty 2.")
		end
	end

	if item.name != nil then
		_i.name = createD("DPanel", _i, ctrb(_w), ctrb(50), 0, 0)
		_i.name.name = SQL_STR_OUT(item.name)
		function _i.name:Paint(pw, ph)
			surfaceText(self.name, "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
	end

	if item.type != "licenses" then
		_i.spawn = createD("DButton", _i, ctrb(_w), ctrb(50), ctrb(0), ctrb(350))
		_i.spawn:SetText("")
		_i.spawn.item = item
		_i.spawn.action = 0
		_i.spawn.name = "LID_tospawn"
		if IsEntityAlive(LocalPlayer(), item.uniqueID) then
			_i.spawn.action = 1
			_i.spawn.name = "LID_tostore"
		end
		function _i.spawn:Paint(pw, ph)
			local _color = Color(0, 255, 0)
			if !LocalPlayer():canAfford(item.price) then
				_color = Color(255, 0, 0)
			end
			if self:IsHovered() then
				_color = Color(255, 255, 0)
			end
			draw.RoundedBox(0, 0, 0, pw, ph, _color)
			surfaceText(YRP.lang_string(self.name), "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
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
			closeBuyMenu()
		end
	end

	return _i
end

local _mat_set = Material("vgui/yrp/light_settings.png")

net.Receive("shop_get_tabs", function(len)
	openMenu()

	local _dealer = net.ReadTable()
	local _dealer_uid = _dealer.uniqueID
	local _tabs = net.ReadTable()

	_bm.window = createD("YFrame", nil, FW(), FH(), PX(), PY())
	_bm.window.dUID = _dealer_uid
	_bm.window:SetTitle(_dealer.name)
	_bm.window:Center()
	_bm.window:ShowCloseButton(true)
	_bm.window:SetDraggable(true)
	_bm.window:SetHeaderHeight(50)
	function _bm.window:OnClose()
		closeMenu()
	end
	function _bm.window:OnRemove()
		closeMenu()
	end

	_bm.window.systime = SysTime()
	function _bm.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph) -- surfaceWindow(self, pw, ph, YRP.lang_string(_dealer.name) .. " [PROTOTYPE]")
	end

	--[[ Settings ]]--
	if LocalPlayer():HasAccess() then
		_bm.settings = createD("YButton", _bm.window, ctrb(40), ctrb(40), _bm.window:GetWide() - ctrb(240), ctrb(5))
		_bm.settings:SetText("")
		function _bm.settings:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
			local _br = 4
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(_mat_set)
			surface.DrawTexturedRect(YRP.ctr(_br), YRP.ctr(_br), pw-YRP.ctr(2 * _br), ph-YRP.ctr(2 * _br))
		end
		function _bm.settings:DoClick()
			net.Receive("dealer_settings", function(le)
				local _set = createD("DFrame", nil, ctrb(600), ctrb(60 + 110 + 110 + 110), 0, 0)
				_set:SetTitle("")
				_set:Center()
				_set:MakePopup()
				function _set:Paint(pw, ph)
					if !pa(_bm.window) then
						self:Remove()
					end
					draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
				end

				_set.name = createD("DYRPPanelPlus", _set, ctrb(560), ctrb(100), ctrb(20), ctrb(60))
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

				_set.name = createD("DYRPPanelPlus", _set, ctrb(560), ctrb(100), ctrb(20), ctrb(170))
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
					hook.Add("close_dealer_worldmodel", "close_dealer_worldmodel_hook", function()
						_dealer.WorldModel = LocalPlayer():GetDString("WorldModel")

						net.Start("dealer_edit_worldmodel")
							net.WriteString(_dealer.uniqueID)
							net.WriteString(_dealer.WorldModel)
						net.SendToServer()
					end)
					openSingleSelector(tmpTable, "close_dealer_worldmodel")
				end

				local _storages = net.ReadTable()
				_set.storagepoint = createD("DYRPPanelPlus", _set, ctrb(560), ctrb(100), ctrb(20), ctrb(280))
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

	--[[ Shop ]]--
	_bm.shop = createD("DPanelList", _bm.window, FW() - ctrb(20 + 20), FH() - ctrb(100 + 20 + 60 + 20), ctrb(20), ctrb(100 + 20 + 60))
	_bm.shop:EnableVerticalScrollbar(true)
	_bm.shop:SetSpacing(20)
	_bm.shop:SetNoSizing(false)
	function _bm.shop:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 100, 240))
	end

	_bm.tabs = createD("DYRPTabs", _bm.window, FW() - ctrb(20 + 20) - YRP.ctr(80 + 20), ctrb(60), ctrb(20), ctrb(100 + 20))
	_bm.tabs:SetSelectedColor(Color(100, 100, 100, 240))
	_bm.tabs:SetUnselectedColor(Color(0, 0, 0, 240))

	for i, tab in pairs(_tabs) do
		local _tab = _bm.tabs:AddTab(SQL_STR_OUT(tab.name), tab.uniqueID)

		function _tab:GetCategories()
			net.Receive("shop_get_categories", function(le)
				if _bm.shop:IsValid() then
					local _uid = net.ReadString()
					local _cats = net.ReadTable()

					_bm.shop:Clear()

					for j, cat in pairs(_cats) do
						local _cat = createD("DYRPCollapsibleCategory", _bm.shop, _bm.shop:GetWide(), ctrb(100), 0, 0)
						_cat.uid = cat.uniqueID
						_cat:SetHeaderHeight(ctrb(100))
						_cat:SetHeader(SQL_STR_OUT(cat.name))
						_cat:SetSpacing(30)
						_cat.color = Color(100, 100, 255)
						_cat.color2 = Color(50, 50, 255)
						function _cat:DoClick()
							if self:IsOpen() then
								net.Receive("shop_get_items", function(l)
									local _items = net.ReadTable()
									for k, item in pairs(_items) do
										timer.Simple(0.1 * k, function()
											local _item = createShopItem(item, _dealer_uid)
											self:Add(_item)
										end)
									end
								end)
								net.Start("shop_get_items")
									net.WriteString(self.uid)
								net.SendToServer()
							else
								self:ClearContent()
							end
						end

						_bm.shop:AddItem(_cat)
						_bm.shop:Rebuild()
					end
					if LocalPlayer():HasAccess() then
						local _remove = createD("DButton", _cat, YRP.ctr(400), YRP.ctr(100), 0, 0)
						_remove:SetText("")
						_remove.uid = _uid
						function _remove:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
							surfaceText(YRP.lang_string("LID_remove") .. " [" .. YRP.lang_string("LID_tab") .. "] => " .. SQL_STR_OUT(tab.name), "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
						end
						function _remove:DoClick()
							net.Start("dealer_rem_tab")
								net.WriteString(_dealer_uid)
								net.WriteString(self.uid)
							net.SendToServer()
							_bm.window:Close()
						end
						_bm.shop:AddItem(_remove)
						_bm.shop:Rebuild()
					end
				end
			end)
			net.Start("shop_get_categories")
				net.WriteString(_tab.tbl)
			net.SendToServer()
		end
		function _tab:Click()
			_tab.GetCategories()
		end

		local _tab2 = _bm.tabs:AddTab(YRP.lang_string("LID_mystorage") .. ": " .. SQL_STR_OUT(tab.name), tab.uniqueID)
		function _tab2:GetCategories()
			net.Receive("shop_get_categories", function(le)
				local _uid = net.ReadString()
				local _cats = net.ReadTable()

				if wk(_bm) then
					_bm.shop:Clear()

					for j, cat in pairs(_cats) do
						local _c = createD("DYRPCollapsibleCategory", _bm.shop, _bm.shop:GetWide(), ctrb(100), 0, 0)
						_c.uid = cat.uniqueID
						_c:SetHeaderHeight(ctrb(100))
						_c:SetHeader(SQL_STR_OUT(cat.name))
						_c:SetSpacing(30)
						_c.color = Color(100, 100, 255)
						_c.color2 = Color(50, 50, 255)
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

						_bm.shop:AddItem(_c)
						_bm.shop:Rebuild()
					end
				end
			end)
			net.Start("shop_get_categories")
				net.WriteString(_tab.tbl)
			net.SendToServer()
		end
		function _tab2:Click()
			_tab2.GetCategories()
		end

		if i == 1 then
			_tab.GetCategories()
		end
	end

	if LocalPlayer():HasAccess() then
		_bm.addtab = createD("DButton", _bm.window, YRP.ctr(80), YRP.ctr(60), FW() - YRP.ctr(80 + 20), YRP.ctr(100 + 20))
		_bm.addtab:SetText("")
		function _bm.addtab:Paint(pw, ph)
			local _color = Color(0, 255, 0, 255)
			if self:IsHovered() then
				_color = Color(255, 255, 0, 255)
			end
			draw.RoundedBoxEx(ph / 2, 0, 0, pw, ph, _color, true, true)
			surfaceText(" + ", "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end
		function _bm.addtab:DoClick()
			local _tmp = createD("DFrame", nil, YRP.ctr(420), YRP.ctr(50 + 10 + 100 + 10 + 50 + 10), 0, 0)
			function _tmp:Paint(pw, ph)
				if !pa(_bm.tabs) then
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
						net.WriteString(_bm.window.dUID)
						net.WriteString(_uid)
					net.SendToServer()
				end
				self:GetParent():Close()
				_bm.window:Close()
			end
		end
	end

	_bm.window:MakePopup()
end)

function openBuyMenu()
	net.Start("shop_get_tabs")
		net.WriteString("1")
	net.SendToServer()
end
