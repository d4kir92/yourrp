--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

playerready = playerready or false
local searchIcon = Material("icon16/magnifier.png")

function OpenHelpTranslatingWindow()
	local window = createD("DFrame", nil, ctr(1200), ctr(500), 0, 0)
	window:SetTitle("")
	window:Center()
	window:MakePopup()

	function window:Paint(pw, ph)
		surfaceWindow(self, pw, ph, "Help translating")
		draw.SimpleTextOutlined("If you want to add a new language or help translating an existing language,", "mat1text", ctr(10), ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("please do this:", "mat1text", ctr(10), ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("First go to the translation-website and register there:", "mat1text", ctr(10), ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("Then write D4KiR on the discord server to get rights for translating:", "mat1text", ctr(10), ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
	end

	window.translationsite = createD("DButton", window, ctr(400), ctr(50), ctr(10), ctr(200))
	window.translationsite:SetText("")

	function window.translationsite:Paint(pw, ph)
		surfaceButton(self, pw, ph, "Translation website")
	end

	function window.translationsite:DoClick()
		gui.OpenURL("https://yourrp.noserver4u.de/engage/yourrp/")
	end

	window.discordserver = createD("DButton", window, ctr(400), ctr(50), ctr(10), ctr(300))
	window.discordserver:SetText("")

	function window.discordserver:Paint(pw, ph)
		surfaceButton(self, pw, ph, "YourRP Discord server")
	end

	function window.discordserver:DoClick()
		gui.OpenURL("https://discord.gg/CXXDCMJ")
	end
end

function YRP.AddLanguageChangerLine(parent, tab, mainparent)
	local lang = createD("DButton", parent, parent:GetWide(), ctr(40), 0, 0)
	lang:SetText("")
	lang.lang = tab

	function lang:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		surfaceBox(0, 0, pw, ph, color)
		YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. tostring(self.lang.short)), ctr(46), ctr(31), ctr(4), ctr((40 - 31) / 2), Color(255, 255, 255, 255))
		self.textcol = Color(255, 255, 255)

		if self.lang.percentage != nil and self.lang.percentage == 100 then
			self.textcol = Color(0, 255, 0)
		end

		draw.SimpleTextOutlined(constructLanguageText(self.lang.language, self.lang.inenglish, self.lang.percentage), GetFont(), ctr(4 + 46 + 8), ph / 2, self.textcol, 0, 1, 1, Color(0, 0, 0, 255))
	end

	function lang:DoClick()
		YRP.LoadLanguage(self.lang.short)
		mainparent:Remove()
	end

	parent:AddItem(lang)
end

function constructLanguageText(lang, inenglish, percentage)
	if percentage != nil then
		return tostring(lang) .. "/" .. tostring(inenglish) .. " (" .. percentage .. "%)"
	else
		return tostring(lang) .. "/" .. tostring(inenglish)
	end
end

function YRP.AddLanguageAddLine(parent, mainparent)
	local lang = createD("DButton", parent, parent:GetWide(), ctr(40), 0, 0)
	lang:SetText("")

	function lang:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		surfaceBox(0, 0, pw, ph, color)
		local text = "Help translating"
		draw.SimpleTextOutlined(text, "DermaDefault", ctr(4 + 46 + 8), ph / 2, Color(255, 255, 0, 255), 0, 1, ctr(1), Color(0, 0, 0, 255))
	end

	function lang:DoClick()
		OpenHelpTranslatingWindow()
		mainparent:Remove()
	end

	parent:AddItem(lang)
end

function YRP.DChangeLanguage(parent, x, y, size)
	local LanguageChanger = createD("DButton", parent, size, size * 0.671, x, y)
	LanguageChanger:SetText("")
	LanguageChanger.selecting = false
	function LanguageChanger:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(ph / 4, 0, 0, pw, ph, color)
		YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. YRP.GetCurrentLanguage()), ph, ph * 0.671, (pw - ph) / 2, (ph - ph * 0.671) / 2, Color(255, 255, 255, 255))
	end

	function LanguageChanger:Selecting()
		return self.selecting
	end

	function LanguageChanger:DoClick()
		self.selecting = true
		local languages = YRP.GetAllLanguages()
		surface.SetFont(GetFont())
		local _longestLanguageString = 0

		for k, lang in SortedPairs(languages) do
			local testString = surface.GetTextSize(constructLanguageText(lang["language"], lang["inenglish"], lang.percentage))

			if testString > _longestLanguageString then
				_longestLanguageString = testString
			end
		end

		local window = createD("DFrame", nil, _longestLanguageString + ctr(78), ctr(400), 0, 0)
		window:SetTitle("")
		window:ShowCloseButton(false)
		window:SetDraggable(false)

		function window:Paint(pw, ph)
			local px, py = self:GetPos()

			if px > ScrW() - pw then
				self:SetPos(ScrW() - pw, py)
			elseif py > ScrH() - ph then
				self:SetPos(px, ScrH() - ph)
			end

			if self:IsHovered() then
				self.startup = true
			end

			for i, child in pairs(window.dpanellist:GetItems()) do
				if self.startup == nil and child:IsHovered() then
					self.startup = true
				end
				if self.startup and !self:IsHovered() and child:IsHovered() then

					return true
				end
			end
			if self.startup and !self:IsHovered() then
				self:Remove()
			end
			self:MoveToFront()
		end

		function window:OnRemove()
			LanguageChanger.selecting = false
		end

		window:MakePopup()
		local mx, my = gui.MousePos()
		mx = mx - window:GetWide() / 2
		my = my - ctr(25)
		window:SetPos(mx, my)
		window.dpanellist = createD("DPanelList", window, window:GetWide(), ctr(400), 0, 0)
		YRP.AddLanguageChangerLine(window.dpanellist, YRP.GetLanguageAutoInfo(), window)

		for k, lang in SortedPairs(languages) do
			YRP.AddLanguageChangerLine(window.dpanellist, lang, window)
		end

		YRP.AddLanguageAddLine(window.dpanellist, window)
		window.dpanellist:SetTall(ctr(40 * (table.Count(languages) + 2)))
		window:SetTall(ctr(40 * (table.Count(languages) + 2)))
	end

	return LanguageChanger
end

function isInTable(mytable, item)
	for k, v in pairs(mytable) do
		if string.lower(tostring(v)) == string.lower(tostring(item.ClassName)) then return true end
	end

	return false
end

function GetSWEPsList()
	local SWEPS = weapons.GetList()
	local list_weapon = list.Get("Weapon")

	for k, v in pairs(list_weapon) do
		if v.Category == "Half-Life 2" or string.find(v.ClassName, "weapon_physgun") then
			table.insert(SWEPS, v)
		end
	end

	return SWEPS
end

function GetSwepWorldModel(swepcn)
	local result = "notfound.mdl"
	local allsweps = GetSWEPsList()
	for i, swep in pairs(allsweps) do
		if swep.ClassName == swepcn then
			result = swep.WorldModel or result
			break
		end
	end
	return result
end

function GetSWEPWorldModel(ClassName)
	local sweps = weapons.GetList()
	local _weaplist = list.Get("Weapon")

	for k, v in pairs(_weaplist) do
		table.insert(sweps, v)
	end

	for k, v in pairs(sweps) do
		if v.WorldModel == nil then
			v.WorldModel = v.Model or ""
		end

		if v.PrintName == nil then
			v.PrintName = v.Name or ""
		end

		if v.ClassName == nil then
			v.ClassName = v.Class or ""
		end

		if tostring(v.ClassName) == tostring(ClassName) and v.WorldModel != nil then
			return v.WorldModel
		end
	end

	return ""
end

function GetSENTsList()
	local list_entities = list.Get("SpawnableEntities")

	return list_entities
end

function OpenSelector(tbl_list, tbl_sele, closeF)
	local ply = LocalPlayer()
	ply:SetNWString("global_working", table.concat(tbl_sele, ","))
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #tbl_list
	local frame = createD("DFrame", nil, BScrW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:Center()
	frame:SetTitle("")

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 254))
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - ctr(10 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local item = {}
	item.w = 740
	item.h = 370
	local _w = BScrW() - ctr(20)
	local _h = ScrH() - ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = ctr(10)
	local _y = ctr(50 + 10 + 50 + 10)
	local _cw = _w / ctr(item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / ctr(item.h + 10)
	_ch = _ch - _ch % 1
	local _cs = _cw * _ch
	local searchButton = createD("DButton", frame, ctr(50), ctr(50), ctr(10), ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(ctr(5), ctr(5), ctr(40), ctr(40))
		draw.SimpleText(YRP.lang_string("LID_search") .. ":", "DermaDefault", ctr(_but_len), ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	local search = createD("DTextEntry", frame, _w - ctr(50), ctr(50), ctr(10 + 50), ctr(50 + 10))

	function getMaxSite()
		site.max = site.count / _cs
		local _mod = site.max % 1
		site.max = site.max - _mod

		if site.max + _mod > site.max then
			site.max = site.max + 1
		end
	end

	getMaxSite()
	local scrollpanel = createD("DPanel", frame, _w, _h, _x, _y)

	function scrollpanel:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
	end

	local tmpCache = {}
	local tmpSelected = {}

	function showList()
		for k, v in pairs(tmpCache) do
			v:Remove()
		end

		local tmpBr = 10
		local tmpX = 0
		local tmpY = 0
		site.count = 0
		local count = 0

		for k, v in pairs(tbl_list) do
			if v.WorldModel == nil then
				v.WorldModel = v.Model or ""
			end

			if v.PrintName == nil then
				v.PrintName = v.Name or ""
			end

			if v.ClassName == nil then
				v.ClassName = v.Class or ""
			end

			if tmpSelected[k] == nil then
				tmpSelected[k] = {}
				tmpSelected[k].ClassName = v.ClassName

				if isInTable(tbl_sele, v) then
					tmpSelected[k].selected = true
				else
					tmpSelected[k].selected = false
				end
			end

			if string.find(string.lower(v.WorldModel), search:GetText()) or string.find(string.lower(v.PrintName), search:GetText()) or string.find(string.lower(v.ClassName), search:GetText()) then
				site.count = site.count + 1

				if (site.count - 1) >= (site.cur - 1) * _cs and (site.count - 1) < site.cur * _cs then
					count = count + 1
					tmpCache[k] = createD("DPanel", scrollpanel, ctr(item.w), ctr(item.h), tmpX, tmpY)
					local tmpPointer = tmpCache[k]

					function tmpPointer:Paint(pw, ph)
						self.text = ""
						self.color = Color(0, 0, 0)

						if tmpSelected[k].selected then
							self.color = Color(0, 255, 0)
							self.tcolor = Color(255, 255, 255, 255)

							if string.find(v.ClassName, "npc_") then
								self.text = YRP.lang_string("LID_npcswep")
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = YRP.lang_string("LID_baseentity")
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 0, 0, 255)
							elseif v.WorldModel == "" then
								self.text = "NO MODEL"
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 255, 0, 255)
							end

							draw.RoundedBox(0, 0, 0, pw, ph, self.color)
						else
							if string.find(v.ClassName, "npc_") then
								self.text = YRP.lang_string("LID_npcswep")
								self.color = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = YRP.lang_string("LID_baseentity")
								self.color = Color(255, 0, 0, 255)
							elseif v.WorldModel == "" then
								self.text = "NO MODEL"
								self.color = Color(255, 255, 0, 255)
							end

							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 200))

							if self.text != "" then
								surfaceText(string.upper(self.text) .. "!", "plates", pw / 2, ph / 2, self.color, 1, 1)
							end
						end
					end

					if v.WorldModel != nil and v.WorldModel != "" then
						local icon = createD("SpawnIcon", tmpPointer, ctr(item.h), ctr(item.h), 0, 0)
						icon.item = v
						icon:SetText("")

						timer.Create("shop" .. count, 0.002 * count, 1, function()
							if icon != nil and icon != NULL and icon.item != nil then
								icon:SetModel(icon.item.WorldModel)

								if icon.Entity != nil then
									icon.Entity:SetModelScale(1, 0)
									icon:SetLookAt(Vector(0, 0, 0))
									icon:SetCamPos(Vector(0, -30, 15))
								end
							end
						end)
					end

					local tmpButton = createD("DButton", tmpPointer, ctr(item.w), ctr(item.h), 0, 0)
					tmpButton:SetText("")

					function tmpButton:Paint(pw, ph)
						--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 0))
						local text = "" --YRP.lang_string("LID_notadded")

						if tmpSelected[k].selected then
							text = "Added"

							if tmpPointer.text != "" then
								text = text .. " (" .. tmpPointer.text .. ")"
							end
						end

						local _test = "HAS NO NAME"

						if v.PrintName != nil and v.PrintName != "" then
							_test = v.PrintName
						elseif v.ClassName != nil and v.ClassName != "" then
							_test = v.ClassName
						elseif v.WorldModel != nil and v.WorldModel != "" then
							_test = v.WorldModel
						elseif v.ViewModel != nil and v.ViewModel != "" then
							_test = v.ViewModel
						end

						surface.SetFont("DermaDefaultBold")
						local _tw, _th = surface.GetTextSize(_test)
						local _x = ctr(4)
						local _y = ctr(4)
						surfaceBox(_x, _y, _tw + ctr(8), _th + ctr(8), Color(0, 0, 0))
						surfaceText(_test, "DermaDefaultBold", _x + ctr(4), _y + ctr(15), Color(255, 255, 255, 255), 0, 1)
						--draw.SimpleTextOutlined(_test, "DermaDefaultBold", pw - ctr(10), ctr(10), Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, ctr(1), Color(255, 255, 255, 255))
						draw.SimpleTextOutlined(text, "HudBars", pw / 2, ph / 2, tmpPointer.tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
					end

					function tmpButton:DoClick()
						if tmpSelected[k].selected then
							tmpSelected[k].selected = false
						else
							tmpSelected[k].selected = true
						end

						local tmpString = ""

						for k, v in pairs(tmpSelected) do
							if v.selected and v.ClassName != nil then
								if tmpString == "" then
									tmpString = v.ClassName
								else
									tmpString = tmpString .. "," .. v.ClassName
								end
							end
						end

						ply:SetNWString("global_working", tmpString)
					end

					tmpX = tmpX + ctr(item.w) + tmpBr

					if tmpX > _w - ctr(item.w) then
						tmpX = 0
						tmpY = tmpY + ctr(item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, ctr(200), ctr(50), BScrW() - ctr(200 + 10), ScrH() - ctr(50 + 10))
	nextB:SetText("")

	function nextB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_next"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function nextB:DoClick()
		if site.max > site.cur then
			site.cur = site.cur + 1
			showList()
		end
	end

	local prevB = createD("DButton", frame, ctr(200), ctr(50), ctr(10 + 10), ScrH() - ctr(50 + 10))
	prevB:SetText("")

	function prevB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_prev"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function prevB:DoClick()
		site.cur = site.cur - 1

		if site.cur < 1 then
			site.cur = 1
		end

		showList()
	end

	function search:OnChange()
		site.cur = 1
		showList()
		getMaxSite()
	end

	showList()
	frame:MakePopup()
end

function OpenSingleSelector(table, closeF)
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #table
	local _item = {}
	_item.w = 740
	_item.h = 370
	local _w = BScrW() - ctr(20)
	local _h = ScrH() - ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = ctr(10)
	local _y = ctr(50 + 10 + 50 + 10)
	local _cw = _w / ctr(_item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / ctr(_item.h + 10)
	_ch = _ch - _ch % 1
	local _cs = _cw * _ch

	function getMaxSite()
		local tmpMax = math.Round(site.count / 20, 0)
		site.max = math.Round(site.count / 20, 0)

		if tmpMax > site.max then
			site.max = site.max + 1
		end
	end

	getMaxSite()
	local frame = createD("DFrame", nil, BScrW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:SetTitle(YRP.lang_string("Item Menu"))

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local PanelSelect = createD("DPanel", frame, _w, _h, _x, _y)
	PanelSelect:SetText("")

	function PanelSelect:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
	end

	local searchButton = createD("DButton", frame, ctr(50), ctr(50), ctr(10), ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(ctr(5), ctr(5), ctr(40), ctr(40))
	end

	local search = createD("DTextEntry", frame, _w - ctr(50 + 10), ctr(50), ctr(10 + 50 + 10), ctr(50 + 10))

	function search:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local _string = search:GetText()

		if _string == "" then
			_string = YRP.lang_string("LID_search")
		end

		draw.SimpleTextOutlined(_string, "DermaDefault", ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
	end

	function showList()
		local tmpBr = 10
		local tmpX = 0
		local tmpY = 0
		PanelSelect:Clear()
		local _cat = nil

		if tab == "vehicles" then
			_cat = "Category"
		end

		site.count = 0
		local count = 0

		for k, item in SortedPairsByMemberValue(table, _cat, false) do
			item.PrintName = item.PrintName or item.Name or ""
			item.ClassName = item.ClassName or item.Class or ""
			item.WorldModel = item.WorldModel or item.Model or ""

			if string.find(string.lower(item.WorldModel or ""), search:GetText()) or string.find(string.lower(item.PrintName or ""), search:GetText()) or string.find(string.lower(item.ClassName or ""), search:GetText()) then
				site.count = site.count + 1

				if (site.count - 1) >= (site.cur - 1) * _cs and (site.count - 1) < site.cur * _cs then
					count = count + 1

					if item.WorldModel == nil then
						item.WorldModel = item.Model or ""
					end

					if item.ClassName == nil then
						item.ClassName = item.Class or ""
					end

					if item.PrintName == nil then
						item.PrintName = item.Name or ""
					end

					local icon = createD("DPanel", PanelSelect, ctr(_item.w), ctr(_item.h), tmpX, tmpY)

					function icon:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
					end

					local spawnicon = createD("SpawnIcon", icon, ctr(_item.h), ctr(_item.h), 0, 0)
					spawnicon.item = item
					spawnicon:SetText("")

					timer.Create("shop" .. count, 0.002 * count, 1, function()
						if spawnicon != nil and spawnicon != NULL and spawnicon.item != nil then
							spawnicon:SetModel(spawnicon.item.WorldModel)
						end
					end)

					spawnicon:SetTooltip(item.PrintName)
					local _tmpName = createD("DButton", icon, ctr(_item.w), ctr(_item.h), 0, 0)
					_tmpName:SetText("")

					function _tmpName:Paint(pw, ph)
						draw.SimpleTextOutlined(item.PrintName, "pmT", pw - ctr(10), ph - ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
					end

					function _tmpName:DoClick()
						LocalPlayer():SetNWString("WorldModel", item.WorldModel)
						LocalPlayer():SetNWString("ClassName", item.ClassName)
						LocalPlayer():SetNWString("PrintName", item.PrintName)
						LocalPlayer():SetNWString("Skin", item.Skin)
						frame:Close()
					end

					tmpX = tmpX + ctr(_item.w) + tmpBr

					if tmpX > _w - ctr(_item.w) then
						tmpX = 0
						tmpY = tmpY + ctr(_item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, ctr(200), ctr(50), BScrW() - ctr(200 + 10), ScrH() - ctr(50 + 10))
	nextB:SetText("")

	function nextB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_next"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function nextB:DoClick()
		if site.max > site.cur then
			site.cur = site.cur + 1
			showList()
		end
	end

	local prevB = createD("DButton", frame, ctr(200), ctr(50), ctr(10), ScrH() - ctr(50 + 10))
	prevB:SetText("")

	function prevB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_prev"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function prevB:DoClick()
		site.cur = site.cur - 1

		if site.cur < 1 then
			site.cur = 1
		end

		showList()
	end

	function search:OnChange()
		site.cur = 1
		showList()
		getMaxSite()
	end

	showList()
	frame:MakePopup()
end

function openSelector(table, dbTable, dbSets, dbWhile, closeF)
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #table
	local table2 = string.Explode(",", _globalWorking)
	local frame = createD("DFrame", nil, BScrW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:Center()
	frame:SetTitle("")

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 254))
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - ctr(10 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local item = {}
	item.w = 740
	item.h = 370
	local _w = BScrW() - ctr(20)
	local _h = ScrH() - ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = ctr(10)
	local _y = ctr(50 + 10 + 50 + 10)
	local _cw = _w / ctr(item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / ctr(item.h + 10)
	_ch = _ch - _ch % 1
	local _cs = _cw * _ch
	local searchButton = createD("DButton", frame, ctr(50), ctr(50), ctr(10), ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(ctr(5), ctr(5), ctr(40), ctr(40))
		draw.SimpleText(YRP.lang_string("LID_search") .. ":", "DermaDefault", ctr(_but_len), ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	local search = createD("DTextEntry", frame, _w - ctr(50), ctr(50), ctr(10 + 50), ctr(50 + 10))

	--[[function search:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local _string = search:GetText()
		if _string == "" then
			_string = YRP.lang_string("LID_search")
		end
		draw.SimpleTextOutlined(_string, "DermaDefault", ctr(10), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
	end]]
	--
	function getMaxSite()
		site.max = site.count / _cs
		local _mod = site.max % 1
		site.max = site.max - _mod

		if site.max + _mod > site.max then
			site.max = site.max + 1
		end
	end

	getMaxSite()
	local scrollpanel = createD("DPanel", frame, _w, _h, _x, _y)

	function scrollpanel:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
	end

	local tmpCache = {}
	local tmpSelected = {}

	function showList()
		for k, v in pairs(tmpCache) do
			v:Remove()
		end

		local tmpBr = 10
		local tmpX = 0
		local tmpY = 0
		site.count = 0
		local count = 0

		for k, v in pairs(table) do
			if v.WorldModel == nil then
				v.WorldModel = v.Model or ""
			end

			if v.PrintName == nil then
				v.PrintName = v.Name or ""
			end

			if v.ClassName == nil then
				v.ClassName = v.Class or ""
			end

			if tmpSelected[k] == nil then
				tmpSelected[k] = {}
				tmpSelected[k].ClassName = v.ClassName

				if isInTable(table2, v) then
					tmpSelected[k].selected = true
				else
					tmpSelected[k].selected = false
				end
			end

			if string.find(string.lower(v.WorldModel), search:GetText()) or string.find(string.lower(v.PrintName), search:GetText()) or string.find(string.lower(v.ClassName), search:GetText()) then
				site.count = site.count + 1

				if (site.count - 1) >= (site.cur - 1) * _cs and (site.count - 1) < site.cur * _cs then
					count = count + 1
					tmpCache[k] = createD("DPanel", scrollpanel, ctr(item.w), ctr(item.h), tmpX, tmpY)
					local tmpPointer = tmpCache[k]

					function tmpPointer:Paint(pw, ph)
						self.text = ""
						self.color = Color(0, 0, 0)

						if tmpSelected[k].selected then
							self.color = Color(0, 255, 0)
							self.tcolor = Color(255, 255, 255, 255)

							if string.find(v.ClassName, "npc_") then
								self.text = YRP.lang_string("LID_npcswep")
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = YRP.lang_string("LID_baseentity")
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 0, 0, 255)
							elseif v.WorldModel == "" then
								self.text = "NO MODEL"
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 255, 0, 255)
							end

							draw.RoundedBox(0, 0, 0, pw, ph, self.color)
						else
							if string.find(v.ClassName, "npc_") then
								self.text = YRP.lang_string("LID_npcswep")
								self.color = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = YRP.lang_string("LID_baseentity")
								self.color = Color(255, 0, 0, 255)
							elseif v.WorldModel == "" then
								self.text = "NO MODEL"
								self.color = Color(255, 255, 0, 255)
							end

							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 200))

							if self.text != "" then
								surfaceText(string.upper(self.text) .. "!", "plates", pw / 2, ph / 2, self.color, 1, 1)
							end
						end
					end

					if v.WorldModel != nil and v.WorldModel != "" then
						local icon = createD("SpawnIcon", tmpPointer, ctr(item.h), ctr(item.h), 0, 0)
						icon.item = v
						icon:SetText("")

						timer.Create("shop" .. count, 0.002 * count, 1, function()
							if icon != nil and icon != NULL and icon.item != nil then
								icon:SetModel(icon.item.WorldModel)

								if icon.Entity != nil then
									icon.Entity:SetModelScale(1, 0)
									icon:SetLookAt(Vector(0, 0, 0))
									icon:SetCamPos(Vector(0, -30, 15))
								end
							end
						end)
					end

					local tmpButton = createD("DButton", tmpPointer, ctr(item.w), ctr(item.h), 0, 0)
					tmpButton:SetText("")

					function tmpButton:Paint(pw, ph)
						--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 0))
						local text = "" --YRP.lang_string("LID_notadded")

						if tmpSelected[k].selected then
							text = "Added"

							if tmpPointer.text != "" then
								text = text .. " (" .. tmpPointer.text .. ")"
							end
						end

						local _test = "HAS NO NAME"

						if v.PrintName != nil and v.PrintName != "" then
							_test = v.PrintName
						elseif v.ClassName != nil and v.ClassName != "" then
							_test = v.ClassName
						elseif v.WorldModel != nil and v.WorldModel != "" then
							_test = v.WorldModel
						elseif v.ViewModel != nil and v.ViewModel != "" then
							_test = v.ViewModel
						end

						surface.SetFont("DermaDefaultBold")
						local _tw, _th = surface.GetTextSize(_test)
						local _x = ctr(4)
						local _y = ctr(4)
						surfaceBox(_x, _y, _tw + ctr(8), _th + ctr(8), Color(0, 0, 0))
						surfaceText(_test, "DermaDefaultBold", _x + ctr(4), _y + ctr(15), Color(255, 255, 255, 255), 0, 1)
						--draw.SimpleTextOutlined(_test, "DermaDefaultBold", pw - ctr(10), ctr(10), Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, ctr(1), Color(255, 255, 255, 255))
						draw.SimpleTextOutlined(text, "HudBars", pw / 2, ph / 2, tmpPointer.tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
					end

					function tmpButton:DoClick()
						if tmpSelected[k].selected then
							tmpSelected[k].selected = false
						else
							tmpSelected[k].selected = true
						end

						local tmpString = ""

						for k, v in pairs(tmpSelected) do
							if v.selected and v.ClassName != nil then
								if tmpString == "" then
									tmpString = v.ClassName
								else
									tmpString = tmpString .. "," .. v.ClassName
								end
							end
						end

						net.Start("dbUpdate")
						net.WriteString(dbTable)
						net.WriteString(dbSets .. " = '" .. tmpString .. "'")
						net.WriteString(dbWhile)
						net.SendToServer()
						_globalWorking = tmpString
					end

					tmpX = tmpX + ctr(item.w) + tmpBr

					if tmpX > _w - ctr(item.w) then
						tmpX = 0
						tmpY = tmpY + ctr(item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, ctr(200), ctr(50), BScrW() - ctr(200 + 10), ScrH() - ctr(50 + 10))
	nextB:SetText("")

	function nextB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_next"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function nextB:DoClick()
		if site.max > site.cur then
			site.cur = site.cur + 1
			showList()
		end
	end

	local prevB = createD("DButton", frame, ctr(200), ctr(50), ctr(10 + 10), ScrH() - ctr(50 + 10))
	prevB:SetText("")

	function prevB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_prev"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function prevB:DoClick()
		site.cur = site.cur - 1

		if site.cur < 1 then
			site.cur = 1
		end

		showList()
	end

	function search:OnChange()
		site.cur = 1
		showList()
		getMaxSite()
	end

	showList()
	frame:MakePopup()
end

function openSingleSelector(table, closeF)
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #table
	local _item = {}
	_item.w = 740
	_item.h = 370
	local _w = BScrW() - ctr(20)
	local _h = ScrH() - ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = ctr(10)
	local _y = ctr(50 + 10 + 50 + 10)
	local _cw = _w / ctr(_item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / ctr(_item.h + 10)
	_ch = _ch - _ch % 1
	local _cs = _cw * _ch

	function getMaxSite()
		local tmpMax = math.Round(site.count / 20, 0)
		site.max = math.Round(site.count / 20, 0)

		if tmpMax > site.max then
			site.max = site.max + 1
		end
	end

	getMaxSite()
	local frame = createD("DFrame", nil, BScrW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:SetTitle(YRP.lang_string("Item Menu"))

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local PanelSelect = createD("DPanel", frame, _w, _h, _x, _y)
	PanelSelect:SetText("")

	function PanelSelect:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
	end

	local searchButton = createD("DButton", frame, ctr(50), ctr(50), ctr(10), ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(ctr(5), ctr(5), ctr(40), ctr(40))
	end

	local search = createD("DTextEntry", frame, _w - ctr(50 + 10), ctr(50), ctr(10 + 50 + 10), ctr(50 + 10))

	function search:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local _string = search:GetText()

		if _string == "" then
			_string = YRP.lang_string("LID_search")
		end

		draw.SimpleTextOutlined(_string, "DermaDefault", ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
	end

	function showList()
		local tmpBr = 10
		local tmpX = 0
		local tmpY = 0
		PanelSelect:Clear()
		local _cat = nil

		if tab == "vehicles" then
			_cat = "Category"
		end

		site.count = 0
		local count = 0

		for k, item in SortedPairsByMemberValue(table, _cat, false) do
			item.PrintName = item.PrintName or item.Name or ""
			item.ClassName = item.ClassName or item.Class or ""
			item.WorldModel = item.WorldModel or item.Model or ""

			if string.find(string.lower(item.WorldModel or ""), search:GetText()) or string.find(string.lower(item.PrintName or ""), search:GetText()) or string.find(string.lower(item.ClassName or ""), search:GetText()) then
				site.count = site.count + 1

				if (site.count - 1) >= (site.cur - 1) * _cs and (site.count - 1) < site.cur * _cs then
					count = count + 1

					if item.WorldModel == nil then
						item.WorldModel = item.Model or ""
					end

					if item.ClassName == nil then
						item.ClassName = item.Class or ""
					end

					if item.PrintName == nil then
						item.PrintName = item.Name or ""
					end

					local icon = createD("DPanel", PanelSelect, ctr(_item.w), ctr(_item.h), tmpX, tmpY)

					function icon:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
					end

					local spawnicon = createD("SpawnIcon", icon, ctr(_item.h), ctr(_item.h), 0, 0)
					spawnicon.item = item
					spawnicon:SetText("")

					timer.Create("shop" .. count, 0.002 * count, 1, function()
						if spawnicon != nil and spawnicon != NULL and spawnicon.item != nil then
							spawnicon:SetModel(spawnicon.item.WorldModel)
						end
					end)

					spawnicon:SetTooltip(item.PrintName)
					local _tmpName = createD("DButton", icon, ctr(_item.w), ctr(_item.h), 0, 0)
					_tmpName:SetText("")

					function _tmpName:Paint(pw, ph)
						draw.SimpleTextOutlined(item.PrintName, "pmT", pw - ctr(10), ph - ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
					end

					function _tmpName:DoClick()
						LocalPlayer():SetNWString("WorldModel", item.WorldModel)
						LocalPlayer():SetNWString("ClassName", item.ClassName)
						LocalPlayer():SetNWString("PrintName", item.PrintName)
						LocalPlayer():SetNWString("Skin", item.Skin)
						frame:Close()
					end

					tmpX = tmpX + ctr(_item.w) + tmpBr

					if tmpX > _w - ctr(_item.w) then
						tmpX = 0
						tmpY = tmpY + ctr(_item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, ctr(200), ctr(50), BScrW() - ctr(200 + 10), ScrH() - ctr(50 + 10))
	nextB:SetText("")

	function nextB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_next"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function nextB:DoClick()
		if site.max > site.cur then
			site.cur = site.cur + 1
			showList()
		end
	end

	local prevB = createD("DButton", frame, ctr(200), ctr(50), ctr(10), ScrH() - ctr(50 + 10))
	prevB:SetText("")

	function prevB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("lid_prev"), "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function prevB:DoClick()
		site.cur = site.cur - 1

		if site.cur < 1 then
			site.cur = 1
		end

		showList()
	end

	function search:OnChange()
		site.cur = 1
		showList()
		getMaxSite()
	end

	showList()
	frame:MakePopup()
end

net.Receive("yrpInfoBox", function(len)
	local _tmp = createVGUI("DFrame", nil, 800, 400, 0, 0)
	_tmp:SetTitle("Notification")
	local _text = net.ReadString()

	function _tmp:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 80))
		draw.SimpleTextOutlined(_text, "sef", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	local closeButton = createVGUI("DButton", _tmp, 200, 50, 400 - 100, 400 - 50)
	closeButton:SetText("Close")

	function closeButton:DoClick()
		_tmp:Close()
	end

	_tmp:Center()
	_tmp:MakePopup()
end)

function YRP.Color()
	return Color(26, 113, 242)
end

local yrp_icon = Material("yrp/yrp_icon")
local loadinggamemode = nil
local loadingend = false
if !playerready then
	loadinggamemode = createD("YFrame", nil, ScrW(), ScrH(), 0, 0)
	loadinggamemode:SetTitle("")
	loadinggamemode:SetDraggable(false)
	loadinggamemode:ShowCloseButton(false)
	loadinggamemode.languagechanger = YRP.DChangeLanguage(loadinggamemode, PosX() + ScrW() - ctr(200) - ctr(100), ScrH() - ctr(200) - ctr(250), ctr(100))
	function loadinggamemode:Paint(pw, ph)
		if !self.languagechanger:Selecting() then
			self:MoveToFront()
		end
		local lply = LocalPlayer()
		local hud = tonumber(lply:GetNWInt("yrp_loading_hud", 0))
		local interface = tonumber(lply:GetNWInt("yrp_loading_interface", 0))
		local loading = hud + interface
		loading = loading / 2
		draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40))

		local iconsize = ctr(512)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(yrp_icon)
		surface.DrawTexturedRect(pw / 2 - iconsize / 2, ph / 2 - iconsize - ctr(100), iconsize, iconsize)

		local text = math.Round(loading, 0) .. "%"
		local posx = PosX()
		local w = ScW() - ctr(400)
		local h = ctr(120)
		local x = posx + ctr(200)
		local y = ph - h - ctr(200)
		draw.RoundedBox(h / 2, x, y, w, h, Color(0, 0, 0))
		draw.RoundedBox(h / 2, x, y, w * loading / 100, h, YRP.Color())
		draw.SimpleTextOutlined(text, "Roboto60B", pw / 2, y + h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		local text_hud_name = YRP.lang_string("LID_hud") .. ":"
		draw.SimpleTextOutlined(text_hud_name, "Roboto18B", posx + ctr(200), y - ctr(70), YRP.Color(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		local text_hud_value = hud .. "%"
		draw.SimpleTextOutlined(text_hud_value, "Roboto18B", posx + ctr(200) + ctr(300), y - ctr(70), YRP.Color(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		local text_interface_name = YRP.lang_string("LID_interface") .. ":"
		draw.SimpleTextOutlined(text_interface_name, "Roboto18B", posx + ctr(200), y - ctr(30), YRP.Color(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		local text_interface_value = interface .. "%"
		draw.SimpleTextOutlined(text_interface_value, "Roboto18B", posx + ctr(200) + ctr(300), y - ctr(30), YRP.Color(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		local text_version = "(" .. string.upper(GAMEMODE.dedicated) .. " Server) YourRP V.: " .. GAMEMODE.Version .. " by D4KiR"
		draw.SimpleTextOutlined(text_version, "Roboto18B", posx + ctr(200) + w, y - ctr(30), GetVersionColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		draw.SimpleTextOutlined("YourRP", "Roboto48B", pw / 2, ph / 2, YRP.Color(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		draw.SimpleTextOutlined(GetHostName(), "Roboto48B", posx + ctr(200), ctr(200), YRP.Color(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(GAMEMODE:GetGameDescription(), "Roboto24B", posx + ctr(200), ctr(300), YRP.Color(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined(YRP.lang_string("LID_map") .. ": " .. game.GetMap(), "Roboto24B", posx + ctr(200), ctr(350), YRP.Color(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

		if loading >= 100 and !loadingend then
			loadingend = true
			timer.Simple(1, function()
				if loadinggamemode != nil then
					loadinggamemode:Remove()
				end
			end)
		end
	end

	loadinggamemode:MakePopup()
end

function SendIsReady()
	net.Start("yrp_player_is_ready")
		net.WriteBool(system.IsWindows())
		net.WriteBool(system.IsLinux())
		net.WriteBool(system.IsOSX())
		net.WriteString(system.GetCountry())
	net.SendToServer()

	YRP.initLang()

	if tobool(get_tutorial("tut_welcome")) then
		openHelpMenu()
	end

	timer.Simple(4, function()
		local _wsitems = engine.GetAddons()
		printGM("note", "[" .. #_wsitems .. " Workshop items]")
		printGM("note", " Nr.\tID\t\tName Mounted")

		for k, ws in pairs(_wsitems) do
			if !ws.mounted then
				printGM("note", "+[" .. k .. "]\t[" .. tostring(ws.wsid) .. "]\t[" .. tostring(ws.title) .. "] Mounting")
				game.MountGMA(tostring(ws.path))
			end
		end

		printGM("note", "Workshop Addons Done")
		playerfullready = true

		--[[ IF STARTED SINGLEPLAYER ]]
		--
		if game.SinglePlayer() then
			local _warning = createD("DFrame", nil, 600, 300, 0, 0)
			_warning:SetTitle("")
			_warning:Center()

			function _warning:Paint(pw, ph)
				surfaceWindow(self, pw, ph, "WARNING!")
				draw.SimpleTextOutlined("PLEASE DO !USE SINGLEPLAYER!", "HudBars", pw / 2, ph / 2 - ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
				draw.SimpleTextOutlined("Use a dedicated server or start multiplayer, thanks!", "HudBars", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
				draw.SimpleTextOutlined("PLEASE USE A DEDICATED SERVER, FOR THE BEST EXPERIENCE!", "HudBars", pw / 2, ph / 2 + ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
			end

			_warning:MakePopup()
		elseif !ServerIsDedicated and ServerIsDedicated != nil and LocalPlayer():HasAccess() then
			LocalPlayer():SetNWBool("warning_dedicated", true)

			timer.Create("yrp_warning_dedicated_server", 10, 0, function()
				LocalPlayer():SetNWBool("warning_dedicated", false)
			end)
		end
	end)
end

function YRPInitPostEntity()
	printGM("note", "YRPInitPostEntity()")
	if playerready == false then
		printGM("note", "Player is ready.")
		playerready = true

		timer.Create("yrp_ready_timer", 0.1, 0, function()
			local lply = LocalPlayer()
			if lply:GetNWInt("yrp_loading_hud", 0) >= 100 and lply:GetNWInt("yrp_loading_interface", 0) >= 100 then
				timer.Remove("yrp_ready_timer")
				SendIsReady()
			end
		end)
	end
end

function GM:Initialize()
	timer.Simple(4, function()
		YRPInitPostEntity()
	end)
end

hook.Add("Initialize", "yrp_Initialize", function()
	timer.Simple(4, function()
		YRPInitPostEntity()
	end)
end)

function GM:InitPostEntity()
	printGM("note", "All entities are loaded.")
	YRPInitPostEntity()
end

hook.Add("InitPostEntity", "yrp_InitPostEntity", function()
	YRPInitPostEntity()
end)

--Remove Ragdolls after 60 sec
function RemoveDeadRag(ent)
	if (ent == NULL) or (ent == nil) then return end

	if (ent:GetClass() == "class C_ClientRagdoll") and ent:IsValid() and ent != NULL then
			SafeRemoveEntityDelayed(ent, 60)
	end
end

hook.Add("OnEntityCreated", "RemoveDeadRag", RemoveDeadRag)

function GM:HUDDrawTargetID()
	return false
end

function surfaceBox(x, y, w, h, color)
	surface.SetDrawColor(color)
	surface.DrawRect(x, y, w, h)
end

function YRP.DrawSymbol(ply, str, z, color)
	local _size = 32
	local pos = ply:GetPos() + Vector(0, 0, 86)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	cam.Start3D2D(pos + Vector(0, 0, z), ang, sca)
	surface.SetDrawColor(color)
	surface.SetMaterial(YRP.GetDesignIcon(str))
	surface.DrawTexturedRect(-_size / 2, 0, _size, _size)
	cam.End3D2D()
end

function drawString(ply, instr, z, color)
	local pos = ply:GetPos() + Vector(0, 0, 86)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	local str = instr
	cam.Start3D2D(pos + Vector(0, 0, z), ang, sca)
	surface.SetFont("3d2d_string")
	local _tw, _th = surface.GetTextSize(str)
	_tw = math.Round(_tw * 1.08, 0)
	_th = _th
	surfaceText(str, "3d2d_string", 0, _th / 2 + 1, color, 1, 1)
	cam.End3D2D()
end

function drawBar(ply, string, z, color, cur, max, barcolor)
	local pos = ply:GetPos() + Vector(0, 0, 86)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	local str = string
	cam.Start3D2D(pos + Vector(0, 0, z), ang, sca)
	surface.SetFont("3d2d_string")
	local _tw, _th = surface.GetTextSize(str)
	_tw = math.Round(_tw * 1.00, 0)
	_th = _th
	local w = 200
	surfaceBox(-w / 2 - 2, 2 - 2, w + 4, 20 + 4, Color(0, 0, 0, 100))
	surfaceBox(-w / 2, 2, w * cur / max, 20, barcolor)
	surfaceText(str, "3d2d_string", 0, _th / 2 + 1, color, 1, 1)
	cam.End3D2D()
end

function drawPlate(ply, string, z, color)
	local pos = ply:GetPos() + Vector(0, 0, 86)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	local str = string
	cam.Start3D2D(pos + Vector(0, 0, z), ang, sca)
	surface.SetFont("plates")
	local _tw, _th = surface.GetTextSize(str)
	_tw = math.Round(_tw * 1.08, 0)
	_th = _th
	color.a = math.Round(color.a * 0.5, 0)
	surfaceBox(-_tw / 2, 0, _tw, _th, color)
	surfaceText(str, "plates", 0, _th / 2 + 1, Color(255, 255, 255, color.a + 1), 1, 1)
	cam.End3D2D()
end

function drawPlayerInfo(ply, _str, _x, _y, _z, _w, _h, color, _alpha, icon, _cur, _max, color2)
	local x = tonumber(_x)
	local y = tonumber(_y)
	local z = tonumber(_z)
	local w = tonumber(_w)
	local h = tonumber(_h)
	local h = tonumber(_h)
	local alpha = tonumber(_alpha)
	local pos = ply:GetPos()
	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = 0.1
	x = x * (0.75 + ply:GetModelScale() * 0.25)
	y = y * (0.75 + ply:GetModelScale() * 0.25)
	local str = _str
	--cam.Start3D2D(pos + Vector(0, 0, z) + ply:GetRight() * y + ply:GetForward() * x, ang, sca)
	cam.Start3D2D(pos + Vector(0, 0, z) + LocalPlayer():GetRight() * y + LocalPlayer():GetForward() * x, ang, sca)
	surface.SetFont("plyinfo")
	local _tw, _th = surface.GetTextSize(str)
	_tw = _tw + 8
	_th = _th
	color.a = math.Round(color.a * 0.5, 0)
	surfaceBox(0, 0, w, h, color)

	if _cur != nil and _max != nil then
		color2.a = alpha
		local cur = tonumber(_cur)
		local max = tonumber(_max)

		if cur != nil and max != nil then
			if max > 0 then
				surfaceBox(0, 0, cur / max * w, h, color2)
			end
		end
	end

	if icon != nil then
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(2, 2, h - 4, h - 4)
	end

	color.a = alpha
	surfaceText(str, "plyinfo", 5 + h, h / 2, Color(255, 255, 255, color.a + 1), 0, 1)
	cam.End3D2D()
end

hook.Add("PlayerNoClip", "yrp_noclip_restriction", function(ply, bool) return true end)
local _icons = {}
_icons["hp"] = Material("icon16/heart.png")
_icons["ar"] = Material("icon16/shield.png")
_icons["gn"] = Material("icon16/group.png")
_icons["rn"] = Material("icon16/user_gray.png")
_icons["na"] = Material("icon16/vcard.png")
_icons["sa"] = Material("icon16/money_add.png")
_icons["mo"] = Material("icon16/money.png")
_icons["sn"] = Material("icon16/status_online.png")
_icons["ug"] = Material("icon16/group_key.png")
_icons["ms"] = Material("icon16/lightning.png")

function drawPlates(ply)
	if ply:Alive() and ply:GetNWInt("yrp_loading_hud", 0) >= 100 then
		local _height = 31
		local color = ply:GetColor()
		color.a = color.a - 160

		if color.a <= 0 then
			color.a = 10
		end

		if ply:GetNWBool("bool_tag_on_head", false) then
			if ply:GetNWBool("bool_tag_on_head_voice", false) and ply:GetNWBool("yrp_speaking", false) then
				local plyvol = ply:VoiceVolume() * 200
				local voicecolor = Color(color.r, color.g, color.b, 55 + plyvol)
				YRP.DrawSymbol(ply, "voice", 26, voicecolor)
			end

			if ply:GetNWBool("bool_tag_on_head_chat", false) and ply:GetNWBool("istyping", false) then
				YRP.DrawSymbol(ply, "chat", 26, color)
			end

			if ply:GetNWBool("bool_tag_on_head_clan", false) then
				drawString(ply, "<" .. "CLAN WILL BE AVAILABLE IN FUTURE" .. ">", _height, color)
				_height = _height + 5
			end

			if ply:GetNWBool("bool_tag_on_head_name", false) then
				drawString(ply, ply:RPName(), _height, color)
				_height = _height + 5
			end

			if ply:GetNWBool("isafk", false) or ply:GetNWBool("isdnd", false) then
				local onlinestatus = ""
				local onlinecolor = Color(255, 255, 255, 255)
				if ply:GetNWBool("isdnd", false) then
					onlinestatus = YRP.lang_string("LID_dnd")
					onlinecolor = Color(255, 0, 0, 255)
				elseif ply:GetNWBool("isafk", false) then
					onlinestatus = YRP.lang_string("LID_afk")
					onlinecolor = Color(255, 255, 0, 255)
				end
				onlinecolor.a = color.a
				drawString(ply, "<" .. string.upper(onlinestatus) .. ">", _height, onlinecolor)
				_height = _height + 5
			end

			if ply:GetNWBool("bool_tag_on_head_rolename", false) then
				drawString(ply, ply:GetRoleName(), _height, color)
				_height = _height + 5
			end

			if ply:GetNWBool("bool_tag_on_head_groupname", false) then
				drawString(ply, ply:GetGroupName(), _height, color)
				_height = _height + 5
			end

			if ply:GetNWBool("bool_tag_on_head_factionname", false) then
				drawString(ply, "[" .. ply:GetFactionName() .. "]", _height, color)
				_height = _height + 5
			end

			if ply:GetNWBool("bool_tag_on_head_armor", false) then
				_height = _height + 1
				local str = ply:Armor() .. "/" .. ply:GetNWInt("MaxArmor", 100)
				local col = ply:HudValue("AR", "BA")
				drawBar(ply, str, _height, color, ply:Armor(), ply:GetNWInt("MaxArmor", 100), Color(col.r, col.g, col.b, color.a))
				_height = _height + 6
			end

			if ply:GetNWBool("bool_tag_on_head_health", false) then
				_height = _height + 1
				local str = ply:Health() .. "/" .. ply:GetMaxHealth()
				local col = ply:HudValue("HP", "BA")
				drawBar(ply, str, _height, color, ply:Health(), ply:GetMaxHealth(), Color(col.r, col.g, col.b, color.a))
				_height = _height + 6
			end

			if ply:GetNWBool("bool_tag_on_head_usergroup", false) then
				local ugcolor = ply:GetUserGroupColor()
				ugcolor.a = color.a
				drawString(ply, string.upper(ply:GetUserGroup()), _height, ugcolor)
				_height = _height + 5
			end
		end

		_height = _height + 2

		if ply:GetNWBool("tag_ug", false) or (ply:GetNWBool("show_tags", false) and ply:GetMoveType() == MOVETYPE_NOCLIP and !ply:InVehicle()) and ply:GetColor().a > 10 then
				drawPlate(ply, string.upper(ply:GetUserGroup()), _height, Color(0, 0, 140, ply:GetColor().a))
				_height = _height + 9
		end

		if ply:GetNWBool("tag_dev", false) and tostring(ply:SteamID()) == "STEAM_0:1:20900349" then
				drawPlate(ply, "DEVELOPER", _height, Color(0, 0, 0, ply:GetColor().a))
				_height = _height + 9
		end

		if ply:GetNWBool("bool_tag_on_side", false) then
			local _distance = 200

			if LocalPlayer():GetPos():Distance(ply:GetPos()) < _distance then
				local _alpha = 255 - 255 * (LocalPlayer():GetPos():Distance(ply:GetPos()) / _distance)

				if ply:GetColor().a < _alpha then
					_alpha = ply:GetColor().a
				end

				local _z = 50
				local _x = -10
				local _y = 18
				local _w = 160
				local _h = 20
				local _d = 2

				if ply:GetNWBool("bool_tag_on_side_name", false) then
					drawPlayerInfo(ply, ply:RPName(), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["na"])
					_z = _z + _d
				end

				if ply:GetNWBool("bool_tag_on_side_rolename", false) then
					drawPlayerInfo(ply, ply:GetRoleName(), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["rn"])
					_z = _z + _d
				end

				if ply:GetNWBool("bool_tag_on_side_groupname", false) then
					local _color = ply:GetNWString("groupColor", "255,0,0")
					_color = string.Explode(",", _color)
					_color = Color(_color[1], _color[2], _color[3])
					drawPlayerInfo(ply, ply:GetGroupName(), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["gn"], 1, 1, _color)
					_z = _z + _d
				end

				if ply:GetNWBool("bool_tag_on_side_factionname", false) then
					local _color = ply:GetNWString("factionColor", "255,0,0")
					_color = string.Explode(",", _color)
					_color = Color(_color[1], _color[2], _color[3])
					drawPlayerInfo(ply, "[" .. ply:GetFactionName() .. "]", _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["gn"], 1, 1, _color)
					_z = _z + _d
				end

				if ply:GetNWBool("bool_tag_on_side_health", false) then
					local col = ply:HudValue("HP", "BA")
					drawPlayerInfo(ply, ply:Health() .. "/" .. ply:GetMaxHealth(), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["hp"], ply:Health(), ply:GetMaxHealth(), Color(col.r, col.g, col.b, 200))
					_z = _z + _d
				end

				if ply:GetNWBool("bool_tag_on_side_armor", false) then
					local col = ply:HudValue("AR", "BA")
					drawPlayerInfo(ply, ply:Armor() .. "/" .. ply:GetNWInt("MaxArmor", 100), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["ar"], ply:Armor(), ply:GetNWString("MaxArmor", ""), Color(col.r, col.g, col.b, 200))
					_z = _z + _d
				end

				if LocalPlayer():HasAccess() then
					local col = ply:HudValue("ST", "BA")
					drawPlayerInfo(ply, ply:GetNWString("GetCurStamina", "") .. "/" .. ply:GetNWString("GetMaxStamina", ""), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["ms"], ply:GetNWString("GetCurStamina", ""), ply:GetNWString("GetMaxStamina", ""), Color(col.r, col.g, col.b, _alpha))
					_z = _z + _d
					drawPlayerInfo(ply, ply:SteamName(), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["sn"])
					_z = _z + _d
					drawPlayerInfo(ply, string.upper(ply:GetUserGroup()), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["ug"])
					_z = _z + _d
					drawPlayerInfo(ply, "+" .. ply:GetNWString("text_money_pre", "") .. ply:GetNWString("salary", "") .. ply:GetNWString("text_money_pos", ""), _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["sa"])
					_z = _z + _d
					local _motext = ply:GetNWString("text_money_pre", "") .. ply:GetNWString("money", "") .. ply:GetNWString("text_money_pos", "")
					local _mMin = CurTime() + ply:GetNWInt("salarytime") - ply:GetNWInt("nextsalarytime")
					local _mMax = ply:GetNWInt("salarytime") + 1
					drawPlayerInfo(ply, _motext, _x, _y, _z, _w, _h, Color(0, 0, 0, ply:GetColor().a), _alpha, _icons["mo"], _mMin, _mMax, Color(33, 108, 42, _alpha))
					_z = _z + _d
				end
			end
		end
	end

	ply:drawPlayerInfo()
	ply:drawWantedInfo()
end

hook.Add("PostPlayerDraw", "yrp_draw_plates", drawPlates)

hook.Add("PostDrawOpaqueRenderables", "yrp_npc_tags", function()
	local ply = LocalPlayer()

	if ply:GetNWBool("tag_immortal", false) then
		for i, ent in pairs(ents.GetAll()) do
			if (ent:IsNPC() or ent:IsPlayer()) and (ent:GetNWBool("immortal", false) or ent:GetNWBool("godmode", false)) then
				drawPlate(ent, string.upper("[" .. YRP.lang_string("LID_immortal") .. "]"), 0, Color(0, 0, 100, ent:GetColor().a))
			end
		end
	end
end)

net.Receive("yrp_noti", function(len)
	if playerready then
		local ply = LocalPlayer()

		if ply != nil and ply:HasAccess() then
			local _str_lang = net.ReadString()
			local _time = 4
			local _channel = NOTIFY_GENERIC
			local _str = "[" .. YRP.lang_string("LID_adminnotification") .. "] "

			if _str_lang == "noreleasepoint" then
				_str = _str .. YRP.lang_string("LID_" .. _str_lang)
			elseif _str_lang == "nojailpoint" then
				_str = _str .. YRP.lang_string("LID_" .. _str_lang)
			elseif _str_lang == "nogroupspawn" then
				_str = _str .. "[" .. string.upper(net.ReadString()) .. "]" .. " " .. YRP.lang_string("LID_" .. _str_lang) .. "!"
			elseif _str_lang == "inventoryclearing" then
				_str = _str .. YRP.lang_string("LID_" .. _str_lang) .. " (" .. YRP.lang_string(net.ReadString()) .. ")"
			elseif _str_lang == "playerisready" then
				local name = {}
				name["NAME"] = net.ReadString()
				_str = _str .. YRP.lang_string("LID_hasfinishedloading", name)
			elseif _str_lang == "newfeedback" then
				_str = _str .. "New Feedback!"
			elseif _str_lang == "database_full_server" then
				_str = _str .. "SERVER: Database or disk is full, please make more space!"
				_time = 40
				_channel = NOTIFY_ERROR
			end

			notification.AddLegacy(_str, _channel, _time)
		end
	end
end)

net.Receive("yrp_info", function(len)
	if playerready then
		local ply = LocalPlayer()

		if ply != nil then
			local _str = net.ReadString()
			_str = YRP.lang_string("LID_notallowed") .. " (" .. YRP.lang_string(_str) .. ")"
			notification.AddLegacy(_str, NOTIFY_GENERIC, 3)
		end
	end
end)

net.Receive("yrp_info2", function(len)
	if playerready then
		local ply = LocalPlayer()

		if ply != nil then
			local _str = net.ReadString()
			_str = YRP.lang_string(_str)
			local _str2 = net.ReadString()

			if _str2 != nil then
				_str2 = " " .. YRP.lang_string(_str2)
			else
				_str2 = ""
			end

			notification.AddLegacy(_str .. _str2, NOTIFY_GENERIC, 3)
		end
	end
end)

net.Receive("yrp_message", function(len)
	if playerready then
		local ply = LocalPlayer()

		if ply != nil then
			local _str = YRP.lang_string(net.ReadString())
			notification.AddLegacy(_str, NOTIFY_GENERIC, 3)
		end
	end
end)
