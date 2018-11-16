--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _sh = {}

net.Receive("get_shops", function()
	local _shops = net.ReadTable()

	if settingsWindow.window != nil then
		_sh._sho = createD("DYRPDBList", settingsWindow.window.site, ctr(480), ctr(500), ctr(40), ctr(40))
		_sh._sho.tbl = _shops
		_sh._sho:SetListHeader("shops")
		_sh._sho:SetEditArea(_sh.ea)
		function _sh._sho:AddFunction()
			net.Start("shop_add")
			net.SendToServer()
		end
		function _sh._sho:RemoveFunction()
			net.Start("shop_rem")
				net.WriteString(self.uid)
			net.SendToServer()

			if _sh._cat != nil then
				_sh._cat:Remove()
			end
			if _sh._sit != nil then
				_sh._sit:Remove()
			end
		end

		function _sh.eaf(tbl)
			for i, child in pairs(_sh.ea:GetChildren()) do
				child:Remove()
			end

			--[[ NAME ]]--
			_sh._sho._name = createD("DYRPTextEntry", _sh.ea, ctr(800), ctr(100), 0, 0)
			_sh._sho._name.textentry.tbl = tbl
			_sh._sho._name:SetHeader(YRP.lang_string("name"))
			_sh._sho._name:SetText(SQL_STR_OUT(tbl.name))
			function _sh._sho._name.textentry:OnChange()
				self.tbl.name = self:GetValue()
				net.Start("shop_edit_name")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.name)
				net.SendToServer()
			end

			net.Start("get_shop_categories")
				net.WriteString(tbl.uniqueID)
			net.SendToServer()
		end
		_sh._sho:SetEditFunc(_sh.eaf)
		for i, shop in pairs(_shops) do
			_sh._sho:AddEntry(shop)
		end
	end
end)

net.Receive("get_shop_categories", function()
	local _scats = net.ReadTable()

	if settingsWindow.window != nil then
		_sh._cat = createD("DYRPDBList", settingsWindow.window.site, ctr(480), ctr(500), ctr(40), ctr(40+500+40))
		_sh._cat.tbl = _scats
		_sh._cat:SetListHeader("categories")
		_sh._cat:SetEditArea(_sh.ea)
		function _sh._cat:AddFunction()
			if _sh._sho.uid != nil then
				net.Start("category_add")
					net.WriteString(_sh._sho.uid)
				net.SendToServer()
			end
		end
		function _sh._cat:RemoveFunction()
			if _sh._sho.uid != nil then
				net.Start("category_rem")
					net.WriteString(self.uid)
					net.WriteString(_sh._sho.uid)
				net.SendToServer()
				if _sh._sit != nil then
					_sh._sit:Remove()
				end
			end
		end
		function _sh.eaf2(tbl)
			for i, child in pairs(_sh.ea:GetChildren()) do
				child:Remove()
			end

			--[[ NAME ]]--
			if pa(_sh.ea) then
				if pa(_sh._cat) then
					_sh._cat._name = createD("DYRPTextEntry", _sh.ea, ctr(800), ctr(100), 0, 0)
					_sh._cat._name.textentry.tbl = tbl
					_sh._cat._name:SetHeader(YRP.lang_string("name"))
					_sh._cat._name:SetText(SQL_STR_OUT(tbl.name))
					function _sh._cat._name.textentry:OnChange()
						self.tbl.name = self:GetValue()
						net.Start("category_edit_name")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.name)
							net.WriteString(_sh._sho.uid)
						net.SendToServer()
					end

					net.Start("get_shop_items")
						net.WriteString(tbl.uniqueID)
					net.SendToServer()
				end
			end
		end
		_sh._cat:SetEditFunc(_sh.eaf2)
		for i, cat in pairs(_scats) do
			_sh._cat:AddEntry(cat)
		end
	end
end)

net.Receive("get_shop_items", function()
	local _sitems = net.ReadTable()

	if pa(settingsWindow.window) then
		_sh._sit = createD("DYRPDBList", settingsWindow.window.site, ctr(480), ctr(500), ctr(40), ctr(40+500+40+500+40))
		_sh._sit.tbl = _sitems
		_sh._sit:SetListHeader("items")
		_sh._sit:SetEditArea(_sh.ea)
		function _sh._sit:AddFunction()
			if _sh._cat.uid != nil then
				net.Start("shop_item_add")
					net.WriteString(_sh._cat.uid)
				net.SendToServer()
			end
		end
		function _sh._sit:RemoveFunction()
			if _sh._cat.uid != nil then
				net.Start("shop_item_rem")
					net.WriteString(self.uid)
					net.WriteString(_sh._cat.uid)
				net.SendToServer()
			end
		end
		function _sh.eaf3(tbl)
			for i, child in pairs(_sh.ea:GetChildren()) do
				child:Remove()
			end

			--[[ NAME ]]--
			if pa(_sh.ea) and pa(_sh._sit) then
				_sh._sit.itemname = createD("DYRPTextEntry", _sh.ea, ctr(800), ctr(100), 0, ctr(150))
				_sh._sit.itemname.textentry.tbl = tbl
				_sh._sit.itemname:SetHeader(YRP.lang_string("name"))
				_sh._sit.itemname:SetText(SQL_STR_OUT(tbl.name))
				function _sh._sit.itemname.textentry:SendNewName()
					if _sh._cat.uid != nil then
						net.Start("shop_item_edit_name")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.name)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end
				function _sh._sit.itemname.textentry:OnChange()
					self.tbl.name = self:GetValue()
					self:SendNewName()
				end
				function _sh._sit.itemname.textentry:OnValueChange()
					self.tbl.name = self:GetValue()
					self:SendNewName()
				end

				--[[ Description ]]--
				_sh._sit.itemdesc = createD("DYRPTextEntry", _sh.ea, ctr(800), ctr(400), 0, ctr(300))
				_sh._sit.itemdesc.textentry.tbl = tbl
				_sh._sit.itemdesc:SetHeader(YRP.lang_string("description"))
				_sh._sit.itemdesc:SetText(SQL_STR_OUT(tbl.description))
				_sh._sit.itemdesc.textentry:SetMultiline(true)
				function _sh._sit.itemdesc.textentry:SendNewDesc()
					if _sh._cat.uid != nil then
						net.Start("shop_item_edit_desc")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.description)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end
				function _sh._sit.itemdesc.textentry:OnChange()
					self.tbl.description = self:GetValue()
					self:SendNewDesc()
				end
				function _sh._sit.itemdesc.textentry:OnValueChange()
					self.tbl.description = self:GetValue()
					self:SendNewDesc()
				end

				--[[ Price ]]--
				_sh._sit.itemprice = createD("DYRPPanelPlus", _sh.ea, ctr(800), ctr(100), 0, ctr(750))
				_sh._sit.itemprice:SetHeader(YRP.lang_string("price"))
				_sh._sit.itemprice:INITPanel("DNumberWang")
				_sh._sit.itemprice.plus.tbl = tbl
				_sh._sit.itemprice.plus:SetMin(0)
				_sh._sit.itemprice.plus:SetMax(999999999)
				_sh._sit.itemprice.plus:SetValue(tbl.price)
				function _sh._sit.itemprice.plus:OnValueChanged(value)
					self.tbl.price = value
					if _sh._cat.uid != nil then
						net.Start("shop_item_edit_price")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.price)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end

				--[[ Quantity ]]--
				_sh._sit.itemquan = createD("DYRPPanelPlus", _sh.ea, ctr(800), ctr(100), 0, ctr(900))
				_sh._sit.itemquan:SetHeader(YRP.lang_string("quantity") .. " (" .. YRP.lang_string("wip") .. ")")
				_sh._sit.itemquan:INITPanel("DComboBox")
				_sh._sit.itemquan.plus.tbl = tbl
				_sh._sit.itemquan.plus:AddChoice(YRP.lang_string("disabled"), -1)
				for i=1, 32 do
					_sh._sit.itemquan.plus:AddChoice(i, i)
				end
				if tonumber(tbl.quantity) == -1 then
					_sh._sit.itemquan.plus:ChooseOption(YRP.lang_string("disabled"), tonumber(tbl.quantity))
				else
					_sh._sit.itemquan.plus:ChooseOption(tbl.quantity, tonumber(tbl.quantity))
				end
				function _sh._sit.itemquan.plus:OnSelect(index, value, data)
					self.tbl.quantity = data
					if _sh._cat.uid != nil then
						net.Start("shop_item_edit_quan")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.quantity)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end

				--[[ Cooldown ]]--
				_sh._sit.itemcool = createD("DYRPPanelPlus", _sh.ea, ctr(800), ctr(100), 0, ctr(1050))
				_sh._sit.itemcool:SetHeader(YRP.lang_string("cooldown") .. " (" .. YRP.lang_string("wip") .. ")")
				_sh._sit.itemcool:INITPanel("DNumberWang")
				_sh._sit.itemcool.plus.tbl = tbl
				_sh._sit.itemcool.plus:SetMin(0)
				_sh._sit.itemcool.plus:SetMax(9999)
				_sh._sit.itemcool.plus:SetValue(tbl.cooldown)
				function _sh._sit.itemcool.plus:OnValueChanged(value)
					self.tbl.cooldown = value
					if _sh._cat.uid != nil then
						net.Start("shop_item_edit_cool")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.cooldown)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end

				--[[ License ]]--
				_sh._sit.itemlice = createD("DYRPPanelPlus", _sh.ea, ctr(800), ctr(100), 0, ctr(1200))
				_sh._sit.itemlice:SetHeader(YRP.lang_string("licenses"))
				_sh._sit.itemlice:INITPanel("DComboBox")
				_sh._sit.itemlice.plus.tbl = tbl
				net.Start("get_all_licenses_simple")
				net.SendToServer()
				net.Receive("get_all_licenses_simple", function(len)
					local _licenses = net.ReadTable()
					if pa(_sh._sit) then
						_sh._sit.itemlice.plus:AddChoice(YRP.lang_string("none"), -1)
						for i, lic in pairs(_licenses) do
							local _b = false
							if tonumber(lic.uniqueID) == tonumber(tbl.licenseID) then
								_b = true
							end
							_sh._sit.itemlice.plus:AddChoice(SQL_STR_OUT(lic.name), lic.uniqueID, _b)
						end
					end
				end)
				function _sh._sit.itemlice.plus:OnSelect(index, value, data)
					self.tbl.licenseID = data
					if _sh._cat.uid != nil then
						net.Start("shop_item_edit_lice")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.licenseID)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end

				--[[ Permanent ]]--
				_sh._sit.itemperm = createD("DYRPPanelPlus", _sh.ea, ctr(800), ctr(100), 0, ctr(1350))
				_sh._sit.itemperm:SetHeader(YRP.lang_string("permanent") .. " (" .. YRP.lang_string("wip") .. ")")
				_sh._sit.itemperm:INITPanel("DCheckBox")
				_sh._sit.itemperm.plus.tbl = tbl
				_sh._sit.itemperm.plus:SetChecked(tobool(tbl.permanent))
				function _sh._sit.itemperm.plus:OnChange(bVal)
					local _checked = 0
					if bVal then
						_checked = 1
					end
					self.tbl.permanent = _checked
					if _sh._cat.uid != nil then
						net.Start("shop_item_edit_perm")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.permanent)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end

				--[[ TYPE ]]--
				_sh._sit.type = createD("DYRPPanelPlus", _sh.ea, ctr(800), ctr(100), 0, 0)
				_sh._sit.type:SetHeader(YRP.lang_string("type"))
				_sh._sit.type:INITPanel("DComboBox")
				_sh._sit.type.plus:AddChoice(YRP.lang_string("weapons"), "weapons")
				_sh._sit.type.plus:AddChoice(YRP.lang_string("entities"), "entities")
				_sh._sit.type.plus:AddChoice(YRP.lang_string("vehicles"), "vehicles")
				_sh._sit.type.plus:AddChoice(YRP.lang_string("licenses"), "licenses")
				_sh._sit.type.plus.tbl = tbl
				function _sh._sit.type.plus:OnSelect(panel, index, value)
					local _itemlist = {}
					if value == "weapons" then
						local swepsL = weapons.GetList()
						local _weaplist = list.Get("Weapon")

						for k, v in pairs(_weaplist) do
							if v.Category == "Half-Life 2" or string.find(v.ClassName, "weapon_physgun") then
								table.insert(swepsL, v)
							end
						end
						_itemlist = swepsL
						openSingleSelector(_itemlist, "selected_shop_item")
					elseif value == "entities" then
						local _sentlist = list.Get("SpawnableEntities")

						local tmpTable = {}
						local count = 0
						for k, v in pairs(_sentlist) do
							if !string.find(v.ClassName or v.Class or "", "base") then
								count = count + 1
								tmpTable[count] = {}
								tmpTable[count].WorldModel = v.WorldModel or v.Model or ""
								tmpTable[count].ClassName = v.ClassName or v.Class or ""
								tmpTable[count].PrintName = v.PrintName or v.Name or ""
							end
						end
						_itemlist = tmpTable
						openSingleSelector(_itemlist, "selected_shop_item")
					elseif value == "vehicles" then
						local tmpTable = get_all_vehicles()
						_itemlist = tmpTable
						openSingleSelector(_itemlist, "selected_shop_item")
					elseif value == "licenses" then
						net.Start("getlicenses")
						net.SendToServer()
						net.Receive("getlicenses", function()
							local _net_tab = net.ReadTable()
							_itemlist = _net_tab
							for i, lic in pairs(_itemlist) do
								lic.PrintName = SQL_STR_OUT(lic.name)
								lic.ClassName = lic.uniqueID
							end

							openSingleSelector(_itemlist, "selected_shop_item")
						end)
					end
				end
				hook.Add("selected_shop_item", "yrp_selected_shop_item", function()
					if pa(_sh._sit) then
						if pa(_sh._sit.type) then
							local _wm = LocalPlayer():GetNWString("WorldModel")
							local _cn = LocalPlayer():GetNWString("ClassName")
							local _pn = LocalPlayer():GetNWString("PrintName")
							local _type = _sh._sit.type.plus:GetOptionData(_sh._sit.type.plus:GetSelectedID())
							net.Start("shop_item_edit_base")
								net.WriteString(_sh._sit.type.plus.tbl.uniqueID)
								net.WriteString(_wm)
								net.WriteString(_cn)
								net.WriteString(_pn)
								net.WriteString(_type)
							net.SendToServer()
							_sh._sit.itemname.textentry:SetValue(_pn)
						end
					end
				end)
			end
		end
		_sh._sit:SetEditFunc(_sh.eaf3)
		for i, cat in pairs(_sitems) do
			_sh._sit:AddEntry(cat)
		end
	end
end)

hook.Add("open_server_shops", "open_server_shops", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	function settingsWindow.window.site:Paint(w, h)
		--
	end
	_sh.ea = createD("DPanel", settingsWindow.window.site, BScrW() - ctr(40 + 480 + 40 + 40), h - ctr(80), ctr(40 + 480 + 40), ctr(40)	)
	function _sh.ea:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
	end
	
	net.Start("get_shops")
	net.SendToServer()
end)
