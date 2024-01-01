--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #buymenu #buy
BUYMENU = BUYMENU or {}
BUYMENU.open = false
function YRPToggleBuyMenu()
	if not BUYMENU.open and YRPIsNoMenuOpen() then
		YRPOpenBuyMenu()
	else
		YRPCloseBuyMenu()
	end
end

function YRPCloseBuyMenu()
	BUYMENU.open = false
	if BUYMENU.window ~= nil then
		YRPCloseMenu()
		BUYMENU.window:Remove()
		BUYMENU.window = nil
	end
end

local lnames = {}
net.Receive(
	"nws_yrp_getLicenseName",
	function(len)
		local id = net.ReadString()
		local tmp = net.ReadString()
		lnames[id] = tmp
	end
)

function createShopItem(item, duid, id)
	local lply = LocalPlayer()
	item.permanent = tobool(item.permanent)
	item.int_level = tonumber(item.int_level)
	item.count = 1
	local W = 1800
	local H = 300 + 2 * 20
	local BR = 20
	local HE = 50
	if item.type == "vehicle" then
		H = 500 + 2 * 20
	end

	local _i = YRPCreateD("DPanel", nil, YRP.ctr(W), YRP.ctr(H), YRP.ctr(BR), 0)
	function _i:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "HI"))
		draw.RoundedBox(0, YRP.ctr(20), YRP.ctr(20), YRP.ctr(H - 2 * BR), YRP.ctr(H - 2 * BR), YRPInterfaceValue("YFrame", "PC"))
	end

	_i.item = item
	if item.WorldModel ~= nil and not strEmpty(item.WorldModel) then
		_i.model = YRPCreateD("DModelPanel", _i, YRP.ctr(H - 2 * BR), YRP.ctr(H - 2 * BR), YRP.ctr(BR), YRP.ctr(BR))
		_i.model:SetModel(item.WorldModel)
		if YRPEntityAlive(_i.model.Entity) then
			local _mins, _maxs = _i.model.Entity:GetRenderBounds()
			local _x = _maxs.x - _mins.x
			local _y = _maxs.y - _mins.y
			local _z = _maxs.z - _mins.z
			local _range = math.max(_x, _y, _z)
			_z = _mins.z + (_maxs.z - _mins.z) * 0.46
			_i.model:SetLookAt(Vector(0, 0, _z))
			_i.model:SetCamPos(Vector(0, 0, _z) - Vector(-_range, 0, 0))
		end

		_i.modelc = YRPCreateD("DButton", _i.model, YRP.ctr(40), YRP.ctr(40), YRP.ctr(20), _i.model:GetTall() - YRP.ctr(40 + 20))
		_i.modelc:SetText("")
		_i.modelc.color = Color(255, 255, 255, 255)
		function _i.modelc:Paint(pw, ph)
			draw.RoundedBox(ph / 2, 0, 0, pw, ph, self.color)
		end

		function _i.modelc:DoClick()
			local mx, my = gui.MousePos()
			local w = YRPCreateD("DFrame", nil, YRP.ctr(360 + 2 * 20), YRP.ctr(200 + 2 * 20), mx - 50, my - 50)
			w:MakePopup()
			w:SetTitle("")
			w:ShowCloseButton(false)
			function w:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
				if self.cc ~= nil then
					mx, my = gui.MousePos()
					local px, py = self:GetPos()
					if mx < px or my < py or mx > px + pw or my > py + ph then
						self:Remove()
					end
				end
			end

			w.cc = YRPCreateD("DColorMixer", w, YRP.ctr(360), YRP.ctr(200), YRP.ctr(20), YRP.ctr(20))
			w.cc:SetPalette(false)
			w.cc:SetAlphaBar(false)
			w.cc:SetWangs(true)
			w.cc:SetColor(Color(255, 255, 255, 255))
			function w.cc:ValueChanged(col)
				_i.modelc.color = col
				_i.model:SetColor(_i.modelc.color)
				lply.item_color = YRPColorToString(col)
			end
		end
	end

	if item.name ~= nil then
		_i.name = YRPCreateD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(20))
		_i.name.name = item.name
		if item.type == "licenses" then
			_i.name.name = YRP.trans("LID_license") .. ": " .. _i.name.name
		end

		function _i.name:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 255, 0) )
			draw.SimpleText(self.name, "Y_30_500", 0, ph / 2, Color(255, 255, 255, 255), 0, 1)
		end
	end

	if item.description ~= nil then
		_i.description = YRPCreateD("RichText", _i, YRP.ctr(W - H - 20), YRP.ctr(350), YRP.ctr(H), YRP.ctr(20 + HE + 20))
		_i.description.description = item.description
		_i.description:SetText(_i.description.description)
		function _i.description:PerformLayout()
			if self.SetUnderlineFont ~= nil then
				self:SetUnderlineFont("Y_18_500")
			end

			self:SetFontInternal("Y_18_500")
			--self:SetBGColor(Color(50, 50, 50) )
			self:SetFGColor(Color(255, 255, 255, 255))
		end
	end

	if item.price ~= nil then
		_i.price = YRPCreateD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE - 20 - HE))
		function _i.price:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 255, 0) )
			local c = ""
			if item.count > 1 then
				c = item.count .. "x "
			end

			draw.SimpleText(c .. formatMoney(item.price, LocalPlayer()), "Y_30_500", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
		end
	end

	if item.permanent then
		_i.permanent = YRPCreateD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE - 20 - HE - 20 - HE))
		function _i.permanent:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 255, 0) )
			draw.SimpleText("[" .. YRP.trans("LID_permanent") .. "]", "Y_30_500", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
		end
	end

	if LocalPlayer():HasLicense(item.licenseID) then
		if LocalPlayer():HasStorageItem(item.uniqueID) then
			_i.owned = YRPCreateD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
			function _i.owned:Paint(pw, ph)
				local _color = Color(100, 255, 100)
				draw.RoundedBox(0, 0, 0, pw, ph, _color)
				draw.SimpleText(YRP.trans("LID_owned"), "Y_24_500", pw / 2, ph / 2, Color(0, 0, 0, 255), 1, 1)
			end
		elseif IsLevelSystemEnabled() and LocalPlayer():Level() < item.int_level then
			_i.require = YRPCreateD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
			_i.require.level = item.int_level
			function _i.require:Paint(pw, ph)
				local _color = Color(255, 100, 100)
				draw.RoundedBox(0, 0, 0, pw, ph, _color)
				local tab = {}
				tab["LEVEL"] = self.level
				draw.SimpleText(YRP.trans("LID_requires") .. ": " .. YRP.trans("LID_levelx", tab), "Y_24_500", pw / 2, ph / 2, Color(0, 0, 0, 255), 1, 1)
			end
		else
			_i.buy = YRPCreateD("YButton", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
			_i.buy:SetText("")
			_i.buy.item = item
			function _i.buy:Paint(pw, ph)
				local _color = Color(34, 139, 34)
				local _text = YRP.trans("LID_buy")
				if not LocalPlayer():canAfford(item.price) then
					_color = Color(255, 100, 100)
				end

				if self:IsHovered() then
					_color = Color(255, 255, 100)
				end

				local c = ""
				if item.count > 1 then
					c = " (" .. formatMoney(item.price * item.count) .. ")"
					_text = _text .. c
				end

				if LocalPlayer():GetYRPFloat("buy_ts" .. item.uniqueID, 0.0) > CurTime() then
					_color = Color(0, 255, 0)
					_text = YRP.trans("LID_oncooldown")
				end

				self:SetText(_text)
				hook.Run("YButtonAPaint", self, pw, ph)
			end

			function _i.buy:DoClick()
				if LocalPlayer():GetYRPFloat("buy_ts" .. item.uniqueID, 0.0) <= CurTime() then
					net.Start("nws_yrp_item_buy")
					self.item.color = lply.item_color or "255, 255, 255"
					net.WriteString(duid)
					net.WriteString(self.item.uniqueID)
					net.WriteString(self.item.count)
					net.WriteString(self.item.color)
					net.SendToServer()
					YRPCloseBuyMenu()
				end
			end

			if not item.permanent and item.type == "weapons" then
				_i.count = YRPCreateD("DNumberWang", _i, YRP.ctr(HE * 2), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
				_i.count:SetValue(1)
				_i.count:SetMin(1)
				_i.count:SetMax(10)
				function _i.count:OnValueChanged()
					local val = self:GetValue()
					if self.setval then return end
					self.setval = true
					if val > self:GetMax() then
						val = self:GetMax()
						self:SetValue(val)
						self:SetText(val)
					elseif val < self:GetMin() then
						val = self:GetMin()
						self:SetValue(val)
						self:SetText(val)
					end

					item.count = self:GetValue()
					self.setval = false
				end

				_i.buy:SetPos(YRP.ctr(H + 2 * HE + 20), YRP.ctr(H - 20 - HE))
				_i.buy:SetWide(YRP.ctr(W - H - 20 - 2 * HE - 20))
			end
		end
	else
		_i.require = YRPCreateD("DPanel", _i, YRP.ctr(W - H - 20), YRP.ctr(HE), YRP.ctr(H), YRP.ctr(H - 20 - HE))
		lnames[item.licenseID] = lnames[item.licenseID] or item.licenseID
		net.Start("nws_yrp_getLicenseName")
		net.WriteInt(item.licenseID, 32)
		net.SendToServer()
		function _i.require:Paint(pw, ph)
			local _color = Color(255, 100, 100)
			draw.RoundedBox(0, 0, 0, pw, ph, _color)
			draw.SimpleText(YRP.trans("LID_requires") .. ": " .. lnames[item.licenseID], "Y_24_500", pw / 2, ph / 2, Color(0, 0, 0, 255), 1, 1)
		end
	end

	return _i
end

function createStorageItem(item, duid)
	local W = 800
	local H = 400
	local _i = YRPCreateD("DPanel", nil, YRP.ctr(W), YRP.ctr(H), 0, 0)
	function _i:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "HB"))
		drawRBBR(0, 0, 0, pw, ph, Color(160, 160, 160, 255), 1)
	end

	_i.item = item
	if item.WorldModel ~= nil and item.WorldModel ~= "" then
		_i.model = YRPCreateD("DModelPanel", _i, YRP.ctr(W - 50), YRP.ctr(H), YRP.ctr(0), YRP.ctr(0))
		_i.model:SetModel(item.WorldModel)
		if _i.model.Entity ~= NULL and _i.model.Entity ~= nil then
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

	if item.name ~= nil then
		_i.name = YRPCreateD("DPanel", _i, YRP.ctr(W), YRP.ctr(50), 0, 0)
		_i.name.name = item.name
		function _i.name:Paint(pw, ph)
			draw.SimpleText(self.name, "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
		end
	end

	if item.type ~= "licenses" then
		_i.spawn = YRPCreateD("DButton", _i, YRP.ctr(W), YRP.ctr(50), YRP.ctr(0), YRP.ctr(H - 50))
		_i.spawn:SetText("")
		_i.spawn.item = item
		_i.spawn.action = 0
		_i.spawn.name = "LID_tospawn"
		if IsYRPEntityAlive(LocalPlayer(), item.uniqueID) then
			_i.spawn.action = 1
			_i.spawn.name = "LID_tostore"
		end

		function _i.spawn:Paint(pw, ph)
			local _color = Color(100, 255, 100)
			if not LocalPlayer():canAfford(item.price) then
				_color = Color(255, 100, 100)
			end

			if self:IsHovered() then
				_color = Color(255, 255, 100)
			end

			draw.RoundedBox(0, 0, 0, pw, ph, _color)
			draw.SimpleText(YRP.trans(self.name), "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
		end

		function _i.spawn:DoClick()
			if self.action == 0 then
				net.Start("nws_yrp_item_spawn")
				net.WriteTable(self.item)
				net.WriteString(duid)
				net.SendToServer()
			elseif self.action == 1 then
				net.Start("nws_yrp_item_despawn")
				net.WriteTable(self.item)
				net.SendToServer()
			end

			_i.spawn.action = 0
			_i.spawn.name = "LID_tospawn"
			if IsYRPEntityAlive(LocalPlayer(), item.uniqueID) then
				_i.spawn.action = 1
				_i.spawn.name = "LID_tostore"
			else
				_i.spawn.action = 0
				_i.spawn.name = "LID_tospawn"
			end

			YRPCloseBuyMenu()
		end
	end

	return _i
end

local _mat_set = Material("vgui/yrp/light_settings.png")
net.Receive(
	"nws_yrp_shop_get_tabs",
	function(len)
		local _dealer = net.ReadTable()
		local _dealer_uid = _dealer.uniqueID
		local _tabs = net.ReadTable()
		if not IsNotNilAndNotFalse(BUYMENU) then return end
		if not YRPPanelAlive(BUYMENU.tabs, "BUYMENU.tabs 1") then return end
		BUYMENU.dUID = _dealer_uid
		if BUYMENU.content:GetParent().standalone then
			BUYMENU.content:GetParent():SetTitle(_dealer.name)
		end

		for i, tab in pairs(_tabs) do
			if not IsNotNilAndNotFalse(BUYMENU) then return end
			if not YRPPanelAlive(BUYMENU.tabs, "BUYMENU.tabs 2") then return end
			local _tab = BUYMENU.tabs:AddTab(tab.name, tab.uniqueID)
			function _tab:GetCategories()
				net.Receive(
					"nws_yrp_shop_get_categories",
					function(le)
						if BUYMENU.shop:IsValid() then
							local _uid = net.ReadString()
							local _cats = net.ReadTable()
							BUYMENU.shop:Clear()
							for j, cat in pairs(_cats) do
								local BR = 20
								local _cat = YRPCreateD("DYRPCollapsibleCategory", BUYMENU.shop, BUYMENU.shop:GetWide(), YRP.ctr(100), 0, 0)
								_cat.uid = cat.uniqueID
								_cat:SetHeaderHeight(YRP.ctr(100))
								_cat:SetHeader(cat.name)
								_cat:SetSpacing(YRP.ctr(BR * 2))
								_cat.color = YRPInterfaceValue("YFrame", "HI")
								_cat.color2 = YRPInterfaceValue("YFrame", "HB")
								function _cat:DoClick()
									if self:IsOpen() then
										net.Receive(
											"nws_yrp_shop_get_items",
											function(l)
												local uid = net.ReadString()
												local _items = net.ReadTable()
												local cat2 = BUYMENU.cats[uid]
												if IsValid(cat2) then
													cat2.hs = cat2.hs or {}
													local id = 0
													local w = YRP.ctr(600 + BR)
													local idmax = math.Round(_cat:GetWide() / w - 0.6, 0)
													for k, item in pairs(_items) do
														--[[if id == 0 then
												hid = hid + 1
												cat.hs[hid] = YRPCreateD( "DPanel", nil, w * idmax, YRP.ctr(650 + 2 * 20), 0, 0)
												local line = cat.hs[hid]
												function line:Paint(pw, ph)
													--
												end

												cat:Add(line)
											end]]
														local _item = createShopItem(item, _dealer_uid, nil, id)
														cat2:Add(_item)
														id = id + 1
														if id >= idmax then
															id = 0
														end
													end
												end
											end
										)

										net.Start("nws_yrp_shop_get_items")
										net.WriteString(self.uid)
										net.SendToServer()
									else
										self:ClearContent()
									end
								end

								BUYMENU.cats = BUYMENU.cats or {}
								BUYMENU.cats[cat.uniqueID] = _cat
								BUYMENU.shop:AddItem(_cat)
								BUYMENU.shop:Rebuild()
								--_cat.header:DoClick() -- opens the items
							end

							if LocalPlayer():HasAccess("show_get_tabs1") then
								local _remove = YRPCreateD("DButton", _cat, YRP.ctr(400), YRP.ctr(100), 0, 0)
								_remove:SetText("")
								_remove.uid = _uid
								function _remove:Paint(pw, ph)
									draw.RoundedBox(0, 0, 0, pw, ph, Color(200, 50, 50))
									draw.SimpleText(YRP.trans("LID_remove") .. " [" .. YRP.trans("LID_tab") .. "] => " .. tab.name, "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
								end

								function _remove:DoClick()
									net.Start("nws_yrp_dealer_rem_tab")
									net.WriteString(_dealer_uid)
									net.WriteString(self.uid)
									net.SendToServer()
									YRPCloseBuyMenu()
								end

								BUYMENU.shop:AddItem(_remove)
								BUYMENU.shop:Rebuild()
							end
						end
					end
				)

				net.Start("nws_yrp_shop_get_categories")
				net.WriteString(_tab.tbl)
				net.SendToServer()
			end

			function _tab:Click()
				_tab.GetCategories()
			end

			if tab.haspermanent then
				local _tab2 = BUYMENU.tabs:AddTab(YRP.trans("LID_mystorage") .. ": " .. tab.name, tab.uniqueID)
				function _tab2:GetCategories()
					net.Receive(
						"nws_yrp_shop_get_categories",
						function(le)
							local _uid = net.ReadString()
							local _cats = net.ReadTable()
							if IsNotNilAndNotFalse(BUYMENU.content) and YRPPanelAlive(BUYMENU.shop) and BUYMENU.shop.Clear then
								BUYMENU.shop:Clear()
								for j, cat in pairs(_cats) do
									local _c = YRPCreateD("DYRPCollapsibleCategory", BUYMENU.shop, BUYMENU.shop:GetWide(), YRP.ctr(100), 0, 0)
									_c.uid = cat.uniqueID
									_c:SetHeaderHeight(YRP.ctr(100))
									_c:SetHeader(cat.name)
									_c:SetSpacing(30)
									_c.color = YRPInterfaceValue("YFrame", "HI")
									_c.color2 = YRPInterfaceValue("YFrame", "HB")
									function _c:DoClick()
										if self:IsOpen() then
											net.Receive(
												"nws_yrp_shop_get_items_storage",
												function(l)
													local _items = net.ReadTable()
													for k, item in pairs(_items) do
														local _item = createStorageItem(item, _dealer_uid)
														self:Add(_item)
													end
												end
											)

											net.Start("nws_yrp_shop_get_items_storage")
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
						end
					)

					net.Start("nws_yrp_shop_get_categories")
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

		if LocalPlayer():HasAccess("show_get_tabs2") then
			if not IsNotNilAndNotFalse(BUYMENU) then return end
			if not YRPPanelAlive(BUYMENU.tabs, "BUYMENU.tabs 3") then return end
			BUYMENU.addtab = YRPCreateD("DButton", BUYMENU.content, YRP.ctr(80), YRP.ctr(90), BUYMENU.content:GetWide() - YRP.ctr(100 + 100), YRP.ctr(10))
			BUYMENU.addtab:SetText("")
			function BUYMENU.addtab:Paint(pw, ph)
				local _color = Color(50, 200, 50, 255)
				if self:IsHovered() then
					_color = Color(200, 200, 50, 255)
				end

				draw.RoundedBoxEx(ph / 2, 0, 0, pw, ph, _color, true, true)
				draw.SimpleText(" + ", "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
			end

			function BUYMENU.addtab:DoClick()
				local _tmp = YRPCreateD("DFrame", nil, YRP.ctr(420), YRP.ctr(50 + 10 + 100 + 10 + 50 + 10), 0, 0)
				function _tmp:Paint(pw, ph)
					if not YRPPanelAlive(BUYMENU.tabs, "BUYMENU.tabs 5") then
						self:Remove()
					end

					draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
				end

				_tmp:SetTitle("")
				_tmp:Center()
				_tmp:MakePopup()
				_tmp.tabs = YRPCreateD("DYRPPanelPlus", _tmp, YRP.ctr(400), YRP.ctr(100), YRP.ctr(10), YRP.ctr(50 + 10))
				_tmp.tabs:INITPanel("DComboBox")
				_tmp.tabs:SetHeader(YRP.trans("LID_tabs"))
				net.Receive(
					"nws_yrp_shop_get_all_tabs",
					function(l)
						local _ts = net.ReadTable()
						if YRPPanelAlive(_tmp.tabs, "_tmp.tabs") then
							for i, tab in pairs(_ts) do
								_tmp.tabs.plus:AddChoice(tab.name, tab.uniqueID)
							end
						end
					end
				)

				net.Start("nws_yrp_shop_get_all_tabs")
				net.SendToServer()
				_tmp.addtab = YRPCreateD("YButton", _tmp, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50 + 10 + 100 + 10))
				_tmp.addtab:SetText("LID_add")
				function _tmp.addtab:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end

				function _tmp.addtab:DoClick()
					local _name, _uid = _tmp.tabs.plus:GetSelected()
					if _uid ~= nil then
						net.Start("nws_yrp_dealer_add_tab")
						net.WriteString(BUYMENU.dUID)
						net.WriteString(_uid)
						net.SendToServer()
					end

					if self:GetParent().Close ~= nil then
						self:GetParent():Close()
					end

					YRPCloseBuyMenu()
				end
			end
		end

		--[[ Settings ]]
		--
		if LocalPlayer():HasAccess("show_get_tabs3") then
			if not IsNotNilAndNotFalse(BUYMENU) then return end
			if not YRPPanelAlive(BUYMENU.tabs, "BUYMENU.tabs 4") then return end
			BUYMENU.settings = YRPCreateD("YButton", BUYMENU.content, YRP.ctr(80), YRP.ctr(80), BUYMENU.content:GetWide() - YRP.ctr(100), YRP.ctr(10))
			BUYMENU.settings:SetText("")
			function BUYMENU.settings:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
				local _br = 4
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(_mat_set)
				surface.DrawTexturedRect(YRP.ctr(_br), YRP.ctr(_br), pw - YRP.ctr(2 * _br), ph - YRP.ctr(2 * _br))
			end

			function BUYMENU.settings:DoClick()
				net.Receive(
					"nws_yrp_dealer_settings",
					function(le)
						local _set = YRPCreateD("DFrame", nil, YRP.ctr(700), YRP.ctr(60 + 110 + 110 + 110 + 10), 0, 0)
						_set:SetTitle("")
						_set:Center()
						_set:MakePopup()
						function _set:Paint(pw, ph)
							YRPCloseBuyMenu()
							draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
						end

						_set.name = YRPCreateD("DYRPPanelPlus", _set, YRP.ctr(660), YRP.ctr(100), YRP.ctr(20), YRP.ctr(60))
						_set.name:INITPanel("DTextEntry")
						_set.name:SetHeader(YRP.trans("LID_name"))
						_set.name:SetText(_dealer.name)
						function _set.name.plus:OnChange()
							_dealer.name = self:GetText()
							net.Start("nws_yrp_dealer_edit_name")
							net.WriteString(_dealer.uniqueID)
							net.WriteString(_dealer.name)
							net.SendToServer()
						end

						_set.pmodel = YRPCreateD("DYRPPanelPlus", _set, YRP.ctr(660), YRP.ctr(100), YRP.ctr(20), YRP.ctr(170))
						_set.pmodel:INITPanel("YButton")
						_set.pmodel:SetHeader(YRP.trans("LID_appearance"))
						_set.pmodel.plus:SetText("LID_change")
						function _set.pmodel.plus:Paint(pw, ph)
							hook.Run("YButtonPaint", self, pw, ph)
						end

						function _set.pmodel.plus:DoClick()
							local playermodels = player_manager.AllValidModels()
							local noneplayermodels = {}
							AddToTabRecursive(noneplayermodels, "models/", "GAME", "*.mdl")
							for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
								if not addon.downloaded or not addon.mounted then continue end
								AddToTabRecursive(noneplayermodels, "models/", addon.title, "*.mdl")
							end

							local tmpTable = {}
							local count = 0
							for k, v in pairs(playermodels) do
								count = count + 1
								tmpTable[count] = {}
								tmpTable[count].WorldModel = v
								tmpTable[count].ClassName = v
								tmpTable[count].PrintName = player_manager.TranslateToPlayerModelName(v)
							end

							for k, v in pairs(noneplayermodels) do
								count = count + 1
								tmpTable[count] = {}
								tmpTable[count].WorldModel = v
								tmpTable[count].ClassName = v
								tmpTable[count].PrintName = player_manager.TranslateToPlayerModelName(v)
							end

							_globalWorking = _dealer.WorldModel
							hook.Add(
								"close_dealerWorldmodel",
								"close_dealerWorldmodelHook",
								function()
									_dealer.WorldModel = LocalPlayer().WorldModel
									if IsNotNilAndNotFalse(_dealer.WorldModel) then
										net.Start("nws_yrp_dealer_edit_worldmodel")
										net.WriteString(_dealer.uniqueID)
										net.WriteString(_dealer.WorldModel)
										net.SendToServer()
									end
								end
							)

							openSingleSelector(tmpTable, "close_dealerWorldmodel")
						end

						local _storages = net.ReadTable()
						_set.storagepoint = YRPCreateD("DYRPPanelPlus", _set, YRP.ctr(660), YRP.ctr(100), YRP.ctr(20), YRP.ctr(280))
						_set.storagepoint:INITPanel("DComboBox")
						_set.storagepoint:SetHeader(YRP.trans("LID_storagepoint") .. " (Where the items should spawn)")
						for i, storage in pairs(_storages) do
							local _sp = false
							if tonumber(storage.uniqueID) == tonumber(_dealer.storagepoints) then
								_sp = true
							end

							_set.storagepoint.plus:AddChoice(storage.name, storage.uniqueID, _sp)
						end

						function _set.storagepoint.plus:OnSelect(index, value, data)
							net.Start("nws_yrp_dealer_edit_storagepoints")
							net.WriteString(_dealer.uniqueID)
							net.WriteString(data)
							net.SendToServer()
						end
					end
				)

				net.Start("nws_yrp_dealer_settings")
				net.SendToServer()
			end
		end
	end
)

function CreateBuyMenuContent(parent, uid)
	uid = uid or 1
	if YRPPanelAlive(parent, "parent buymenu") then
		BUYMENU.content = parent
		--[[ Shop ]]
		--
		BUYMENU.shop = YRPCreateD("DPanelList", BUYMENU.content, BUYMENU.content:GetWide(), BUYMENU.content:GetTall() - YRP.ctr(100), YRP.ctr(0), YRP.ctr(100))
		BUYMENU.shop:EnableVerticalScrollbar(true)
		BUYMENU.shop:SetSpacing(20)
		BUYMENU.shop:SetNoSizing(false)
		function BUYMENU.shop:Paint(pw, ph)
			if YRPPanelAlive(BUYMENU.content, "BUYMENU.content") then
				self:SetWide(BUYMENU.content:GetWide())
				self:SetTall(BUYMENU.content:GetTall() - YRP.ctr(100))
				--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 100, 240) )
			end
		end

		BUYMENU.tabs = YRPCreateD("DYRPTabs", BUYMENU.content, BUYMENU.content:GetWide(), YRP.ctr(100), 0, 0)
		BUYMENU.tabs:SetSelectedColor(YRPInterfaceValue("YButton", "SC"))
		BUYMENU.tabs:SetUnselectedColor(YRPInterfaceValue("YButton", "NC"))
		BUYMENU.tabs:SetSize(BUYMENU.shop:GetWide(), YRP.ctr(100))
		if LocalPlayer():HasAccess("show_get_tabs4") then
			BUYMENU.tabs:SetSize(BUYMENU.shop:GetWide() - YRP.ctr(220), YRP.ctr(100))
		end

		net.Start("nws_yrp_shop_get_tabs")
		net.WriteString(uid)
		net.SendToServer()
	end
end

function YRPOpenBuyMenu(uid)
	uid = uid or 1
	YRPOpenMenu()
	BUYMENU.open = true
	BUYMENU.window = YRPCreateD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	BUYMENU.window.standalone = true
	BUYMENU.window:Center()
	BUYMENU.window:SetDraggable(true)
	BUYMENU.window:SetBorder(0)
	--BUYMENU.window:SetSizable(true)
	BUYMENU.window:SetHeaderHeight(YRP.ctr(100))
	function BUYMENU.window:OnClose()
		YRPCloseMenu()
	end

	function BUYMENU.window:OnRemove()
		YRPCloseMenu()
	end

	BUYMENU.window.systime = SysTime()
	function BUYMENU.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph)
	end

	BUYMENU.window:MakePopup()
	CreateBuyMenuContent(BUYMENU.window.con, uid)
end