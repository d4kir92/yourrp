--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _sh = {}
net.Receive(
	"nws_yrp_get_shops",
	function()
		local _shops = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			_sh._sho = YRPCreateD("DYRPDBList", PARENT, YRP:ctr(480), YRP:ctr(500), YRP:ctr(40), YRP:ctr(40))
			_sh._sho.tbl = _shops
			_sh._sho:SetListHeader(YRP:trans("LID_settings_shops"))
			_sh._sho:SetEditArYRPEntityAlive(_sh.ea)
			function _sh._sho:AddFunction()
				net.Start("nws_yrp_shop_add")
				net.SendToServer()
			end

			function _sh._sho:RemoveFunction()
				net.Start("nws_yrp_shop_rem")
				net.WriteString(self.uid)
				net.SendToServer()
				if _sh._cat ~= nil then
					_sh._cat:Remove()
				end

				if _sh._sit ~= nil then
					_sh._sit:Remove()
				end
			end

			function _sh.eaf(tbl)
				if not IsValid(_sh.ea) then return end
				for i, child in pairs(_sh.ea:GetChildren()) do
					child:Remove()
				end

				--[[ NAME ]]
				--
				_sh._sho._name = YRPCreateD("DYRPTextEntry", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, 0)
				_sh._sho._name.textentry.tbl = tbl
				_sh._sho._name:SetHeader(YRP:trans("LID_name"))
				_sh._sho._name:SetText(tbl.name)
				function _sh._sho._name.textentry:OnChange()
					self.tbl.name = self:GetValue()
					net.Start("nws_yrp_shop_edit_name")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.name)
					net.SendToServer()
				end

				net.Start("nws_yrp_get_shop_categories")
				net.WriteString(tbl.uniqueID)
				net.SendToServer()
			end

			_sh._sho:SetEditFunc(_sh.eaf)
			for i, shop in pairs(_shops) do
				_sh._sho:AddEntry(shop)
			end
		end
	end
)

net.Receive(
	"nws_yrp_get_shop_categories",
	function()
		local _scats = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			_sh._cat = YRPCreateD("DYRPDBList", PARENT, YRP:ctr(480), YRP:ctr(500), YRP:ctr(40), YRP:ctr(40 + 500 + 40))
			_sh._cat.tbl = _scats
			_sh._cat:SetListHeader(YRP:trans("LID_categories"))
			_sh._cat:SetEditArYRPEntityAlive(_sh.ea)
			function _sh._cat:AddFunction()
				if _sh._sho.uid ~= nil then
					net.Start("nws_yrp_category_add")
					net.WriteString(_sh._sho.uid)
					net.SendToServer()
				end
			end

			function _sh._cat:RemoveFunction()
				if _sh._sho.uid ~= nil then
					net.Start("nws_yrp_category_rem")
					net.WriteString(self.uid)
					net.WriteString(_sh._sho.uid)
					net.SendToServer()
					if _sh._sit ~= nil then
						_sh._sit:Remove()
					end
				end
			end

			function _sh.eaf2(tbl)
				if not IsValid(_sh.ea) then return end
				for i, child in pairs(_sh.ea:GetChildren()) do
					child:Remove()
				end

				--[[ NAME ]]
				--
				if YRPPanelAlive(_sh.ea) and YRPPanelAlive(_sh._cat) then
					_sh._cat._name = YRPCreateD("DYRPTextEntry", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, 0)
					_sh._cat._name.textentry.tbl = tbl
					_sh._cat._name:SetHeader(YRP:trans("LID_name"))
					_sh._cat._name:SetText(tbl.name)
					function _sh._cat._name.textentry:OnChange()
						self.tbl.name = self:GetValue()
						if _sh._sho.uid and self.tbl.uniqueID then
							net.Start("nws_yrp_category_edit_name")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.name)
							net.WriteString(_sh._sho.uid)
							net.SendToServer()
						end
					end

					net.Start("nws_yrp_get_shop_items")
					net.WriteString(tbl.uniqueID)
					net.SendToServer()
				end
			end

			_sh._cat:SetEditFunc(_sh.eaf2)
			for i, cat in pairs(_scats) do
				_sh._cat:AddEntry(cat)
			end
		end
	end
)

net.Receive(
	"nws_yrp_get_shop_items",
	function()
		local _sitems = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			_sh._sit = YRPCreateD("DYRPDBList", PARENT, YRP:ctr(480), YRP:ctr(500), YRP:ctr(40), YRP:ctr(40 + 500 + 40 + 500 + 40))
			_sh._sit.tbl = _sitems
			_sh._sit:SetListHeader(YRP:trans("LID_items"))
			_sh._sit:SetEditArYRPEntityAlive(_sh.ea)
			function _sh._sit:AddFunction()
				if _sh._cat.uid ~= nil then
					net.Start("nws_yrp_shop_item_add")
					net.WriteString(_sh._cat.uid)
					net.SendToServer()
				end
			end

			function _sh._sit:RemoveFunction()
				if _sh._cat.uid ~= nil then
					net.Start("nws_yrp_shop_item_rem")
					net.WriteString(self.uid)
					net.WriteString(_sh._cat.uid)
					net.SendToServer()
				end
			end

			function _sh.eaf3(tbl)
				if not IsValid(_sh.ea) then return end
				for i, child in pairs(_sh.ea:GetChildren()) do
					child:Remove()
				end

				--[[ NAME ]]
				--
				if YRPPanelAlive(_sh.ea) and YRPPanelAlive(_sh._sit) then
					_sh._sit.itemname = YRPCreateD("DYRPTextEntry", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, YRP:ctr(150))
					_sh._sit.itemname.textentry.tbl = tbl
					_sh._sit.itemname:SetHeader(YRP:trans("LID_name"))
					_sh._sit.itemname:SetText(tbl.name)
					function _sh._sit.itemname.textentry:SendNewName()
						if _sh._cat.uid ~= nil then
							net.Start("nws_yrp_shop_item_edit_name")
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

					--[[ Description ]]
					--
					_sh._sit.itemdesc = YRPCreateD("DYRPTextEntry", _sh.ea, YRP:ctr(800), YRP:ctr(400), 0, YRP:ctr(300))
					_sh._sit.itemdesc.textentry.tbl = tbl
					_sh._sit.itemdesc:SetHeader(YRP:trans("LID_description"))
					_sh._sit.itemdesc:SetText(tbl.description)
					_sh._sit.itemdesc.textentry:SetMultiline(true)
					function _sh._sit.itemdesc.textentry:SendNewDesc()
						if _sh._cat.uid ~= nil then
							net.Start("nws_yrp_shop_item_edit_desc")
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

					--[[ Price ]]
					--
					_sh._sit.itemprice = YRPCreateD("DYRPPanelPlus", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, YRP:ctr(750))
					_sh._sit.itemprice:SetHeader(YRP:trans("LID_price"))
					_sh._sit.itemprice:INITPanel("DNumberWang")
					_sh._sit.itemprice.plus.tbl = tbl
					_sh._sit.itemprice.plus:SetMin(0)
					_sh._sit.itemprice.plus:SetMax(999999999)
					_sh._sit.itemprice.plus:SetValue(tbl.price)
					function _sh._sit.itemprice.plus:OnValueChanged(value)
						self.tbl.price = value
						if _sh._cat.uid ~= nil then
							net.Start("nws_yrp_shop_item_edit_price")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.price)
							net.WriteString(_sh._cat.uid)
							net.SendToServer()
						end
					end

					--[[ LEVEL ]]
					--
					_sh._sit.itemlevel = YRPCreateD("DYRPPanelPlus", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, YRP:ctr(900))
					_sh._sit.itemlevel:SetHeader(YRP:trans("LID_level"))
					_sh._sit.itemlevel:INITPanel("DNumberWang")
					_sh._sit.itemlevel.plus.tbl = tbl
					_sh._sit.itemlevel.plus:SetMin(0)
					_sh._sit.itemlevel.plus:SetMax(999999999)
					_sh._sit.itemlevel.plus:SetValue(tbl.int_level)
					function _sh._sit.itemlevel.plus:OnValueChanged(value)
						self.tbl.int_level = value
						if _sh._cat.uid ~= nil then
							net.Start("nws_yrp_shop_item_edit_level")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.int_level)
							net.WriteString(_sh._cat.uid)
							net.SendToServer()
						end
					end

					--[[ Quantity ]]
					--
					--[[
				_sh._sit.itemquan = YRPCreateD( "DYRPPanelPlus", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, YRP:ctr(1050) )
				_sh._sit.itemquan:SetHeader(YRP:trans( "LID_quantity" ) .. " ( " .. YRP:trans( "LID_wip" ) .. " )" )
				_sh._sit.itemquan:INITPanel( "DComboBox" )
				_sh._sit.itemquan.plus.tbl = tbl
				_sh._sit.itemquan.plus:AddChoice(YRP:trans( "LID_disabled" ), -1)
				for i=1, 32 do
					_sh._sit.itemquan.plus:AddChoice(i, i)
				end
				if tonumber(tbl.quantity) == -1 then
					_sh._sit.itemquan.plus:ChooseOption(YRP:trans( "LID_disabled" ), tonumber(tbl.quantity) )
				else
					_sh._sit.itemquan.plus:ChooseOption(tbl.quantity, tonumber(tbl.quantity) )
				end
				function _sh._sit.itemquan.plus:OnSelect(index, value, data)
					self.tbl.quantity = data
					if _sh._cat.uid ~= nil then
						net.Start( "nws_yrp_shop_item_edit_quan" )
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.quantity)
							net.WriteString(_sh._cat.uid)
						net.SendToServer()
					end
				end
				]]
					--
					--[[ Cooldown ]]
					--
					_sh._sit.itemcool = YRPCreateD("DYRPPanelPlus", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, YRP:ctr(1200))
					_sh._sit.itemcool:SetHeader(YRP:trans("LID_cooldown"))
					_sh._sit.itemcool:INITPanel("DNumberWang")
					_sh._sit.itemcool.plus.tbl = tbl
					_sh._sit.itemcool.plus:SetMin(0)
					_sh._sit.itemcool.plus:SetMax(9999)
					_sh._sit.itemcool.plus:SetValue(tbl.cooldown)
					function _sh._sit.itemcool.plus:OnValueChanged(value)
						self.tbl.cooldown = value
						if _sh._cat.uid ~= nil then
							net.Start("nws_yrp_shop_item_edit_cool")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.cooldown)
							net.WriteString(_sh._cat.uid)
							net.SendToServer()
						end
					end

					--[[ License ]]
					--
					_sh._sit.itemlice = YRPCreateD("DYRPPanelPlus", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, YRP:ctr(1350))
					_sh._sit.itemlice:SetHeader(YRP:trans("LID_licenses"))
					_sh._sit.itemlice:INITPanel("DComboBox")
					_sh._sit.itemlice.plus.tbl = tbl
					net.Start("nws_yrp_get_all_licenses_simple")
					net.SendToServer()
					net.Receive(
						"nws_yrp_get_all_licenses_simple",
						function(len)
							local _licenses = net.ReadTable()
							if YRPPanelAlive(_sh._sit) and YRPPanelAlive(_sh._sit.itemlice) and YRPPanelAlive(_sh._sit.itemlice.plus) then
								_sh._sit.itemlice.plus:AddChoice(YRP:trans("LID_none"), -1)
								for i, lic in pairs(_licenses) do
									local _b = false
									if tonumber(lic.uniqueID) == tonumber(tbl.licenseID) then
										_b = true
									end

									_sh._sit.itemlice.plus:AddChoice(lic.name, lic.uniqueID, _b)
								end
							end
						end
					)

					function _sh._sit.itemlice.plus:OnSelect(index, value, data)
						self.tbl.licenseID = data
						if _sh._cat.uid ~= nil then
							net.Start("nws_yrp_shop_item_edit_lice")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.licenseID)
							net.WriteString(_sh._cat.uid)
							net.SendToServer()
						end
					end

					--[[ Permanent ]]
					--
					_sh._sit.itemperm = YRPCreateD("DYRPPanelPlus", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, YRP:ctr(1500))
					_sh._sit.itemperm:SetHeader(YRP:trans("LID_permanent") .. " ( " .. YRP:trans("LID_wip") .. " )")
					_sh._sit.itemperm:INITPanel("DCheckBox")
					_sh._sit.itemperm.plus.tbl = tbl
					_sh._sit.itemperm.plus:SetChecked(tobool(tbl.permanent))
					function _sh._sit.itemperm.plus:OnChange(bVal)
						local _checked = 0
						if bVal then
							_checked = 1
						end

						self.tbl.permanent = _checked
						if _sh._cat.uid ~= nil then
							net.Start("nws_yrp_shop_item_edit_perm")
							net.WriteString(self.tbl.uniqueID)
							net.WriteString(self.tbl.permanent)
							net.WriteString(_sh._cat.uid)
							net.SendToServer()
						end
					end

					--[[ TYPE ]]
					--
					_sh._sit.type = YRPCreateD("DYRPPanelPlus", _sh.ea, YRP:ctr(800), YRP:ctr(100), 0, 0)
					_sh._sit.type:SetHeader(YRP:trans("LID_type"))
					_sh._sit.type:INITPanel("DComboBox")
					_sh._sit.type.plus:AddChoice(YRP:trans("LID_weapons"), "weapons")
					_sh._sit.type.plus:AddChoice(YRP:trans("LID_props"), "props")
					_sh._sit.type.plus:AddChoice(YRP:trans("LID_entities"), "entities")
					_sh._sit.type.plus:AddChoice(YRP:trans("LID_vehicles"), "vehicles")
					_sh._sit.type.plus:AddChoice(YRP:trans("LID_licenses"), "licenses")
					_sh._sit.type.plus:AddChoice(YRP:trans("LID_roles"), "roles")
					_sh._sit.type.plus.tbl = tbl
					function _sh._sit.type.plus:OnSelect(panel, index, value)
						local _itemlist = {}
						if value == "weapons" then
							local swepsL = YRPGetSWEPsList()
							_itemlist = swepsL
							openSingleSelector(_itemlist, "selected_shop_item")
						elseif value == "props" then
							local _proplist = YRPGetPROPsList()
							local tmpTable = {}
							local count = 0
							for k, v in pairs(_proplist) do
								count = count + 1
								tmpTable[count] = tmpTable[count] or {}
								tmpTable[count].ClassName = "prop_physics"
								tmpTable[count].WorldModel = v
								tmpTable[count].PrintName = v
								tmpTable[count].ishidden = false
							end

							_itemlist = tmpTable
							openSingleSelector(_itemlist, "selected_shop_item", true)
						elseif value == "entities" then
							local _sentlist = YRPGetSENTsList()
							local tmpTable = {}
							local count = 0
							for k, v in pairs(_sentlist) do
								count = count + 1
								tmpTable[count] = tmpTable[count] or {}
								tmpTable[count].ClassName = k or v.ClassName
								tmpTable[count].WorldModel = ""
								tmpTable[count].PrintName = v.PrintName
								tmpTable[count].ishidden = false
							end

							_itemlist = tmpTable
							openSingleSelector(_itemlist, "selected_shop_item", true)
						elseif value == "vehicles" then
							local tmpTable = get_all_vehicles()
							_itemlist = tmpTable
							openSingleSelector(_itemlist, "selected_shop_item")
						elseif value == "licenses" then
							net.Start("nws_yrp_getlicenses")
							net.SendToServer()
							net.Receive(
								"nws_yrp_getlicenses",
								function()
									local _net_tab = net.ReadTable()
									_itemlist = _net_tab
									for i, lic in pairs(_itemlist) do
										lic.PrintName = lic.name
										lic.ClassName = lic.uniqueID
									end

									openSingleSelector(_itemlist, "selected_shop_item")
								end
							)
						elseif value == "roles" then
							net.Receive(
								"nws_yrp_getallroles",
								function()
									local _net_tab = net.ReadTable()
									_itemlist = _net_tab
									for i, rol in pairs(_itemlist) do
										rol.PrintName = rol.string_name
										rol.WorldModel = rol.WorldModel
										rol.ClassName = rol.uniqueID
									end

									openSingleSelector(_itemlist, "selected_shop_item")
								end
							)

							net.Start("nws_yrp_getallroles")
							net.SendToServer()
						end
					end

					hook.Add(
						"selected_shop_item",
						"yrp_selected_shop_item",
						function()
							if YRPPanelAlive(_sh._sit) and YRPPanelAlive(_sh._sit.type) then
								local _wm = LocalPlayer().WorldModel or ""
								local _cn = LocalPlayer().ClassName or ""
								local _pn = LocalPlayer().PrintName or ""
								local _type = _sh._sit.type.plus:GetOptionData(_sh._sit.type.plus:GetSelectedID())
								net.Start("nws_yrp_shop_item_edit_base")
								net.WriteString(_sh._sit.type.plus.tbl.uniqueID)
								net.WriteString(_wm)
								net.WriteString(_cn)
								net.WriteString(_pn)
								net.WriteString(_type)
								net.SendToServer()
								_sh._sit.itemname.textentry:SetValue(_pn)
							end
						end
					)
				end
			end

			_sh._sit:SetEditFunc(_sh.eaf3)
			for i, cat in pairs(_sitems) do
				_sh._sit:AddEntry(cat)
			end
		end
	end
)

function OpenSettingsShops()
	local setSite = GetSettingsSite()
	if setSite then
		local h = setSite:GetTall()
		_sh.ea = YRPCreateD("DPanel", setSite, ScW() - YRP:ctr(40 + 480 + 40 + 40), h - YRP:ctr(80), YRP:ctr(40 + 480 + 40), YRP:ctr(40))
		function _sh.ea:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
		end

		net.Start("nws_yrp_get_shops")
		net.SendToServer()
	end
end
