--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local searchIcon = Material("icon16/magnifier.png")

function OpenHelpTranslatingWindow()
	local window = createD("DFrame", nil, YRP.ctr(1200), YRP.ctr(500), 0, 0)
	window:SetTitle("")
	window:Center()
	window:MakePopup()

	function window:Paint(pw, ph)
		surfaceWindow(self, pw, ph, "Help translating")
		draw.SimpleTextOutlined("If you want to add a new language or help translating an existing language,", "mat1text", YRP.ctr(10), YRP.ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("please do this:", "mat1text", YRP.ctr(10), YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("First go to the translation-website and register there:", "mat1text", YRP.ctr(10), YRP.ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("Then write D4KiR on the discord server to get rights for translating:", "mat1text", YRP.ctr(10), YRP.ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
	end

	window.translationsite = createD("DButton", window, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(200))
	window.translationsite:SetText("")

	function window.translationsite:Paint(pw, ph)
		surfaceButton(self, pw, ph, "Translation website")
	end

	function window.translationsite:DoClick()
		gui.OpenURL("https://yourrp.noserver4u.de/engage/yourrp/")
	end

	window.discordserver = createD("DButton", window, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(300))
	window.discordserver:SetText("")

	function window.discordserver:Paint(pw, ph)
		surfaceButton(self, pw, ph, "YourRP Discord server")
	end

	function window.discordserver:DoClick()
		gui.OpenURL("https://discord.gg/CXXDCMJ")
	end
end

function YRP.AddLanguageChangerLine(parent, tab, mainparent)
	local lang = createD("DButton", parent, parent:GetWide(), YRP.ctr(40), 0, 0)
	lang:SetText("")
	lang.lang = tab

	function lang:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		surfaceBox(0, 0, pw, ph, color)
		YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. tostring(self.lang.short)), YRP.ctr(46), YRP.ctr(31), YRP.ctr(4), YRP.ctr((40 - 31) / 2), Color(255, 255, 255, 255))
		self.textcol = Color(255, 255, 255)

		if self.lang.percentage != nil then
			if self.lang.percentage == 100 then
				self.textcol = Color(0, 255, 0)
			elseif self.lang.percentage < 100 then
				local perc = 255 - 255 * self.lang.percentage / 100
				self.textcol = Color(perc, 255, perc)
			end
		end

		draw.SimpleTextOutlined(constructLanguageText(self.lang.language, self.lang.inenglish, self.lang.percentage), GetFont(), YRP.ctr(4 + 46 + 8), ph / 2, self.textcol, 0, 1, 1, Color(0, 0, 0, 255))
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
	local lang = createD("DButton", parent, parent:GetWide(), YRP.ctr(40), 0, 0)
	lang:SetText("")

	function lang:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		surfaceBox(0, 0, pw, ph, color)
		local text = "Help translating"
		draw.SimpleTextOutlined(text, "DermaDefault", YRP.ctr(4 + 46 + 8), ph / 2, Color(255, 255, 0, 255), 0, 1, YRP.ctr(1), Color(0, 0, 0, 255))
	end

	function lang:DoClick()
		OpenHelpTranslatingWindow()
		mainparent:Remove()
	end

	parent:AddItem(lang)
end

function YRP.DChangeLanguage(parent, x, y, size, vert)
	local sw = size
	local sh = size * 0.671
	if vert then
		sw = size * 1.4903
		sh = size
	end

	local LanguageChanger = createD("DButton", parent, sw, sh, x, y)
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

		local window = createD("DFrame", nil, _longestLanguageString + YRP.ctr(78), YRP.ctr(400), 0, 0)
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
			if pa(LanguageChanger) then
				LanguageChanger.selecting = false
			end
		end

		window:MakePopup()
		local mx, my = gui.MousePos()
		mx = mx - window:GetWide() / 2
		my = my - YRP.ctr(25)
		window:SetPos(mx, my)
		window.dpanellist = createD("DPanelList", window, window:GetWide(), YRP.ctr(400), 0, 0)
		YRP.AddLanguageChangerLine(window.dpanellist, YRP.GetLanguageAutoInfo(), window)

		for k, lang in SortedPairs(languages) do
			YRP.AddLanguageChangerLine(window.dpanellist, lang, window)
		end

		YRP.AddLanguageAddLine(window.dpanellist, window)
		window.dpanellist:SetTall(YRP.ctr(40 * (table.Count(languages) + 2)))
		window:SetTall(YRP.ctr(40 * (table.Count(languages) + 2)))
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
	ply.global_working = table.concat(tbl_sele, ",")
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #tbl_list
	local frame = createD("DFrame", nil, ScW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:Center()
	frame:SetTitle("")

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 254))
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - YRP.ctr(10 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local item = {}
	item.w = 740
	item.h = 370
	local _w = ScW() - YRP.ctr(20)
	local _h = ScrH() - YRP.ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = YRP.ctr(10)
	local _y = YRP.ctr(50 + 10 + 50 + 10)
	local _cw = _w / YRP.ctr(item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / YRP.ctr(item.h + 10)
	_ch = _ch - _ch % 1
	local _cs = _cw * _ch
	local searchButton = createD("DButton", frame, YRP.ctr(50), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(YRP.ctr(5), YRP.ctr(5), YRP.ctr(40), YRP.ctr(40))
		draw.SimpleText(YRP.lang_string("LID_search") .. ":", "DermaDefault", YRP.ctr(_but_len), YRP.ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	local search = createD("DTextEntry", frame, _w - YRP.ctr(50), YRP.ctr(50), YRP.ctr(10 + 50), YRP.ctr(50 + 10))

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

			local searchtext = search:GetText()
			if string.find(string.lower(v.WorldModel), searchtext) or string.find(string.lower(v.PrintName), searchtext) or string.find(string.lower(v.ClassName), searchtext) then
				site.count = site.count + 1

				if (site.count - 1) >= (site.cur - 1) * _cs and (site.count - 1) < site.cur * _cs then
					count = count + 1
					tmpCache[k] = createD("DPanel", scrollpanel, YRP.ctr(item.w), YRP.ctr(item.h), tmpX, tmpY)
					local tmpPointer = tmpCache[k]

					function tmpPointer:Paint(pw, ph)
						self.text = ""
						self.color = Color(0, 0, 0)

						if tmpSelected[k].selected then
							self.color = Color(0, 255, 0)
							self.tcolor = Color(255, 255, 255, 255)

							if string.find(v.ClassName, "npc_") then
								self.text = "NPC SWEP"
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = "Base Entity"
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
								self.text = "NPC SWEP"
								self.color = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = "Base Entity"
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
						local icon = createD("SpawnIcon", tmpPointer, YRP.ctr(item.h), YRP.ctr(item.h), 0, 0)
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

					local tmpButton = createD("DButton", tmpPointer, YRP.ctr(item.w), YRP.ctr(item.h), 0, 0)
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
						local _x_ = YRP.ctr(4)
						local _y_ = YRP.ctr(4)
						surfaceBox(_x_, _y_, _tw + YRP.ctr(8), _th + YRP.ctr(8), Color(0, 0, 0))
						surfaceText(_test, "DermaDefaultBold", _x_ + YRP.ctr(4), _y_ + YRP.ctr(15), Color(255, 255, 255, 255), 0, 1)
						--draw.SimpleTextOutlined(_test, "DermaDefaultBold", pw - YRP.ctr(10), YRP.ctr(10), Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, YRP.ctr(1), Color(255, 255, 255, 255))
						draw.SimpleTextOutlined(text, "HudBars", pw / 2, ph / 2, tmpPointer.tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
					end

					function tmpButton:DoClick()
						if tmpSelected[k].selected then
							tmpSelected[k].selected = false
						else
							tmpSelected[k].selected = true
						end

						local tmpString = ""

						for l, w in pairs(tmpSelected) do
							if w.selected and w.ClassName != nil then
								if tmpString == "" then
									tmpString = w.ClassName
								else
									tmpString = tmpString .. "," .. w.ClassName
								end
							end
						end

						ply.global_working = tmpString
					end

					tmpX = tmpX + YRP.ctr(item.w) + tmpBr

					if tmpX > _w - YRP.ctr(item.w) then
						tmpX = 0
						tmpY = tmpY + YRP.ctr(item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), ScW() - YRP.ctr(200 + 10), ScrH() - YRP.ctr(50 + 10))
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

	local prevB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), YRP.ctr(10 + 10), ScrH() - YRP.ctr(50 + 10))
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

function OpenSingleSelector(tab, closeF)
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #tab
	local _item = {}
	_item.w = 740
	_item.h = 370
	local _w = ScW() - YRP.ctr(20)
	local _h = ScrH() - YRP.ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = YRP.ctr(10)
	local _y = YRP.ctr(50 + 10 + 50 + 10)
	local _cw = _w / YRP.ctr(_item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / YRP.ctr(_item.h + 10)
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
	local frame = createD("DFrame", nil, ScW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:SetTitle(YRP.lang_string("Item Menu"))

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local PanelSelect = createD("DPanel", frame, _w, _h, _x, _y)
	PanelSelect:SetText("")

	function PanelSelect:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
	end

	local searchButton = createD("DButton", frame, YRP.ctr(50), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(YRP.ctr(5), YRP.ctr(5), YRP.ctr(40), YRP.ctr(40))
	end

	local search = createD("DTextEntry", frame, _w - YRP.ctr(50 + 10), YRP.ctr(50), YRP.ctr(10 + 50 + 10), YRP.ctr(50 + 10))

	function search:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local _string = search:GetText()

		if _string == "" then
			_string = YRP.lang_string("LID_search")
		end

		draw.SimpleTextOutlined(_string, "DermaDefault", YRP.ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
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

		for k, item in SortedPairsByMemberValue(tab, _cat, false) do
			item.PrintName = item.PrintName or item.Name or ""
			item.ClassName = item.ClassName or item.Class or ""
			item.WorldModel = item.WorldModel or item.Model or ""

			local searchtext = search:GetText()
			if string.find(string.lower(item.WorldModel or ""), searchtext) or string.find(string.lower(item.PrintName or ""), searchtext) or string.find(string.lower(item.ClassName or ""), searchtext) then
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

					local icon = createD("DPanel", PanelSelect, YRP.ctr(_item.w), YRP.ctr(_item.h), tmpX, tmpY)

					function icon:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
					end

					local spawnicon = createD("SpawnIcon", icon, YRP.ctr(_item.h), YRP.ctr(_item.h), 0, 0)
					spawnicon.item = item
					spawnicon:SetText("")

					timer.Create("shop" .. count, 0.002 * count, 1, function()
						if spawnicon != nil and spawnicon != NULL and spawnicon.item != nil then
							spawnicon:SetModel(spawnicon.item.WorldModel)
						end
					end)

					spawnicon:SetTooltip(item.PrintName)
					local _tmpName = createD("DButton", icon, YRP.ctr(_item.w), YRP.ctr(_item.h), 0, 0)
					_tmpName:SetText("")

					function _tmpName:Paint(pw, ph)
						draw.SimpleTextOutlined(item.PrintName, "pmT", pw - YRP.ctr(10), ph - YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
					end

					function _tmpName:DoClick()
						LocalPlayer():SetDString("WorldModel", item.WorldModel)
						LocalPlayer():SetDString("ClassName", item.ClassName)
						LocalPlayer():SetDString("PrintName", item.PrintName)
						LocalPlayer():SetDString("Skin", item.Skin)
						frame:Close()
					end

					tmpX = tmpX + YRP.ctr(_item.w) + tmpBr

					if tmpX > _w - YRP.ctr(_item.w) then
						tmpX = 0
						tmpY = tmpY + YRP.ctr(_item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), ScW() - YRP.ctr(200 + 10), ScrH() - YRP.ctr(50 + 10))
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

	local prevB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), YRP.ctr(10), ScrH() - YRP.ctr(50 + 10))
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

function openSelector(tab, dbTable, dbSets, dbWhile, closeF)
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #tab
	local table2 = string.Explode(",", _globalWorking)
	local frame = createD("DFrame", nil, ScW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:Center()
	frame:SetTitle("")

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 254))
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - YRP.ctr(10 + 25), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local item = {}
	item.w = 740
	item.h = 370
	local _w = ScW() - YRP.ctr(20)
	local _h = ScrH() - YRP.ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = YRP.ctr(10)
	local _y = YRP.ctr(50 + 10 + 50 + 10)
	local _cw = _w / YRP.ctr(item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / YRP.ctr(item.h + 10)
	_ch = _ch - _ch % 1
	local _cs = _cw * _ch
	local searchButton = createD("DButton", frame, YRP.ctr(50), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(YRP.ctr(5), YRP.ctr(5), YRP.ctr(40), YRP.ctr(40))
		draw.SimpleText(YRP.lang_string("LID_search") .. ":", "DermaDefault", YRP.ctr(_but_len), YRP.ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	local search = createD("DTextEntry", frame, _w - YRP.ctr(50), YRP.ctr(50), YRP.ctr(10 + 50), YRP.ctr(50 + 10))

	--[[function search:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local _string = search:GetText()
		if _string == "" then
			_string = YRP.lang_string("LID_search")
		end
		draw.SimpleTextOutlined(_string, "DermaDefault", YRP.ctr(10), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
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

		for k, v in pairs(tab) do
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

			local searchtext = search:GetText()
			if string.find(string.lower(v.WorldModel), searchtext) or string.find(string.lower(v.PrintName), searchtext) or string.find(string.lower(v.ClassName), searchtext) then
				site.count = site.count + 1

				if (site.count - 1) >= (site.cur - 1) * _cs and (site.count - 1) < site.cur * _cs then
					count = count + 1
					tmpCache[k] = createD("DPanel", scrollpanel, YRP.ctr(item.w), YRP.ctr(item.h), tmpX, tmpY)
					local tmpPointer = tmpCache[k]

					function tmpPointer:Paint(pw, ph)
						self.text = ""
						self.color = Color(0, 0, 0)

						if tmpSelected[k].selected then
							self.color = Color(0, 255, 0)
							self.tcolor = Color(255, 255, 255, 255)

							if string.find(v.ClassName, "npc_") then
								self.text = "NPC SWEP"
								self.color = Color(255, 255, 0, 255)
								self.tcolor = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = "Base SWEP"
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
								self.text = "NPC SWEP"
								self.color = Color(255, 0, 0, 255)
							elseif string.find(v.ClassName, "base") then
								self.text = "Base SWEP"
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
						local icon = createD("SpawnIcon", tmpPointer, YRP.ctr(item.h), YRP.ctr(item.h), 0, 0)
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

					local tmpButton = createD("DButton", tmpPointer, YRP.ctr(item.w), YRP.ctr(item.h), 0, 0)
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
						local _x_ = YRP.ctr(4)
						local _y_ = YRP.ctr(4)
						surfaceBox(_x_, _y_, _tw + YRP.ctr(8), _th + YRP.ctr(8), Color(0, 0, 0))
						surfaceText(_test, "DermaDefaultBold", _x_ + YRP.ctr(4), _y_ + YRP.ctr(15), Color(255, 255, 255, 255), 0, 1)
						--draw.SimpleTextOutlined(_test, "DermaDefaultBold", pw - YRP.ctr(10), YRP.ctr(10), Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, YRP.ctr(1), Color(255, 255, 255, 255))
						draw.SimpleTextOutlined(text, "HudBars", pw / 2, ph / 2, tmpPointer.tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
					end

					function tmpButton:DoClick()
						if tmpSelected[k].selected then
							tmpSelected[k].selected = false
						else
							tmpSelected[k].selected = true
						end

						local tmpString = ""

						for l, w in pairs(tmpSelected) do
							if w.selected and w.ClassName != nil then
								if tmpString == "" then
									tmpString = w.ClassName
								else
									tmpString = tmpString .. "," .. w.ClassName
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

					tmpX = tmpX + YRP.ctr(item.w) + tmpBr

					if tmpX > _w - YRP.ctr(item.w) then
						tmpX = 0
						tmpY = tmpY + YRP.ctr(item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), ScW() - YRP.ctr(200 + 10), ScrH() - YRP.ctr(50 + 10))
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

	local prevB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), YRP.ctr(10 + 10), ScrH() - YRP.ctr(50 + 10))
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

function openSingleSelector(tab, closeF)
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #tab
	local _item = {}
	_item.w = 740
	_item.h = 370
	local _w = ScW() - YRP.ctr(20)
	local _h = ScrH() - YRP.ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = YRP.ctr(10)
	local _y = YRP.ctr(50 + 10 + 50 + 10)
	local _cw = _w / YRP.ctr(_item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / YRP.ctr(_item.h + 10)
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
	local frame = createD("DFrame", nil, ScW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:SetTitle(YRP.lang_string("Item Menu"))

	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "sef", pw / 2, ph - YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local PanelSelect = createD("DPanel", frame, _w, _h, _x, _y)
	PanelSelect:SetText("")

	function PanelSelect:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
	end

	local searchButton = createD("DButton", frame, YRP.ctr(50), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50 + 10))
	searchButton:SetText("")

	function searchButton:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
		local _br = 4
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(YRP.ctr(5), YRP.ctr(5), YRP.ctr(40), YRP.ctr(40))
	end

	local search = createD("DTextEntry", frame, _w - YRP.ctr(50 + 10), YRP.ctr(50), YRP.ctr(10 + 50 + 10), YRP.ctr(50 + 10))

	function search:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local _string = search:GetText()

		if _string == "" then
			_string = YRP.lang_string("LID_search")
		end

		draw.SimpleTextOutlined(_string, "DermaDefault", YRP.ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
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

		for k, item in SortedPairsByMemberValue(tab, _cat, false) do
			item.PrintName = item.PrintName or item.Name or ""
			item.ClassName = item.ClassName or item.Class or ""
			item.WorldModel = item.WorldModel or item.Model or ""

			local searchtext = search:GetText()

			if string.find(string.lower(item.WorldModel or ""), searchtext) or string.find(string.lower(item.PrintName or ""), searchtext) or string.find(string.lower(item.ClassName or ""), searchtext) then
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

					local icon = createD("DPanel", PanelSelect, YRP.ctr(_item.w), YRP.ctr(_item.h), tmpX, tmpY)

					function icon:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
					end

					local spawnicon = createD("SpawnIcon", icon, YRP.ctr(_item.h), YRP.ctr(_item.h), 0, 0)
					spawnicon.item = item
					spawnicon:SetText("")

					timer.Create("shop" .. count, 0.002 * count, 1, function()
						if spawnicon != nil and spawnicon != NULL and spawnicon.item != nil then
							spawnicon:SetModel(spawnicon.item.WorldModel)
						end
					end)

					spawnicon:SetTooltip(item.PrintName)
					local _tmpName = createD("DButton", icon, YRP.ctr(_item.w), YRP.ctr(_item.h), 0, 0)
					_tmpName:SetText("")

					function _tmpName:Paint(pw, ph)
						draw.SimpleTextOutlined(item.PrintName, "pmT", pw - YRP.ctr(10), ph - YRP.ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
					end

					function _tmpName:DoClick()
						LocalPlayer():SetDString("WorldModel", item.WorldModel)
						LocalPlayer():SetDString("ClassName", item.ClassName)
						LocalPlayer():SetDString("PrintName", item.PrintName)
						LocalPlayer():SetDString("Skin", item.Skin)
						frame:Close()
					end

					tmpX = tmpX + YRP.ctr(_item.w) + tmpBr

					if tmpX > _w - YRP.ctr(_item.w) then
						tmpX = 0
						tmpY = tmpY + YRP.ctr(_item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), ScW() - YRP.ctr(200 + 10), ScrH() - YRP.ctr(50 + 10))
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

	local prevB = createD("DButton", frame, YRP.ctr(200), YRP.ctr(50), YRP.ctr(10), ScrH() - YRP.ctr(50 + 10))
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

yrp_hud = yrp_hud or {}
function YRPHUD(name, failed)
	local value = yrp_hud[name]
	if value != nil then
		return value
	else
		YRP.msg("error", "YRPHUD FAILED: " .. name)
		return failed
	end
end

net.Receive("yrp_hud_info", function(len)
	local hud = net.ReadTable()

	for i, v in pairs(hud) do
		if string.StartWith(v.name, "float_") or string.StartWith(v.name, "int_") then
			yrp_hud[v.name] = tonumber(v.value)
		elseif string.StartWith(v.name, "bool_") then
			yrp_hud[v.name] = tobool(v.value)
		else
			yrp_hud[v.name] = v.value
		end
	end

	changeFontSize()
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
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
	surface.SetDrawColor(color)
	surface.SetMaterial(YRP.GetDesignIcon(str))
	surface.DrawTexturedRect(-_size / 2, 0, _size, _size)
	cam.End3D2D()
end

function drawStringBox(ent, instr, z, color)
	local pos = ent:GetPos() + Vector(0, 0, ent:OBBMaxs().z)

	if ent:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local str = instr
	cam.Start3D2D(pos + Vector(0, 0, z), ang, 0.2)
		surface.SetFont("YRP_18_500")
		local tw, th = surface.GetTextSize(str)
		--surfaceText(str, "3d2d_string", 0, _th / 2 + 1, color, 1, 1)

		local br = 4
		local box = {}
		box.w = tw + 5 * br + th
		box.h = th + 2 * br
		draw.RoundedBox(box.h / 2, - box.w / 2, 0, box.w, box.h, Color(0, 0, 0, 160))

		local ico = {}
		ico.w = th * 0.8
		ico.h = ico.w
		ico.br = (th - ico.h) / 2
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(YRP.GetDesignIcon("shopping_cart"))
		surface.DrawTexturedRect(-box.w / 2 + br + ico.br, br + ico.br, ico.w, ico.h)

		draw.SimpleText(instr, "YRP_18_500", -box.w / 2 + th + 2 * br, box.h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) --, 1, Color(0, 0, 0))
	cam.End3D2D()
end

function drawString(ply, instr, z, color)
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	local str = instr
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
		surface.SetFont("3d2d_string")
		local _tw, _th = surface.GetTextSize(str)
		_tw = math.Round(_tw * 1.08, 0)
		_th = _th
		surfaceText(str, "3d2d_string", 0, _th / 2 + 1, color, 1, 1)
	cam.End3D2D()
end

function drawBar(ply, stri, z, color, cur, max, barcolor)
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	local str = stri
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
		surface.SetFont("3d2d_string")
		local _tw, _th = surface.GetTextSize(str)
		_tw = math.Round(_tw * 1.00, 0)
		_th = _th
		local w = 200
		local r = 4
		draw.RoundedBox(r, -w / 2 - 2, 2 - 2, w + 4, 20 + 4, Color(0, 0, 0, barcolor.a))
		draw.RoundedBox(r / 2, -w / 2, 2, w * cur / max, 20, barcolor)
		surfaceText(str, "3d2d_string", 0, _th / 2 - 0.2, color, 1, 1)
	cam.End3D2D()
end

function drawPlate(ply, stri, z, color)
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)

	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	local str = stri
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
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

		if cur != nil and max != nil and max > 0 then
			surfaceBox(0, 0, cur / max * w, h, color2)
		end
	end

	if icon != nil then
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(2, 2, h - 4, h - 4)
	end

	color.a = alpha
	surfaceText(str, "plyinfo", 5 + h, h / 2, Color(color.r, color.g, color.b, color.a + 1), 0, 1)
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
_icons["le"] = Material("icon16/layers.png")

function Debug3DText(ply, str, pos, color)
	local _tw, _th = surface.GetTextSize(str)
	local yaw = LocalPlayer():GetAngles().y
	cam.Start3D2D(pos + Vector(0, 0, _th), Angle(0, yaw - 90, 90), 1)
		surface.SetFont("3d2d_string")
		_tw = math.Round(_tw * 1.08, 0)
		_th = _th
		surfaceText(str, "3d2d_string", 0, _th / 2 + 1, color, 1, 1)
	cam.End3D2D()
end

function drawPlates()
	for i, ply in pairs(player.GetAll()) do
		local renderdist = 550
		local _distance = 200

		if GetGlobalDBool("bool_server_debug_voice", false) and LocalPlayer():GetPos():Distance(ply:GetPos()) < 1000 then
			if ply:GetDInt("speak_channel", -1) == 0 and GetGlobalDBool("bool_voice_channels", false) then
				local col = Color(255, 100, 100, 120)
				if LocalPlayer():GetPos():Distance(ply:GetPos()) < GetGlobalDInt("int_voice_local_range", 1) then
					col = Color(100, 255, 100, 120)
				end
				render.SetColorMaterial()
				render.DrawSphere(ply:GetPos(), GetGlobalDInt("int_voice_local_range", 1), 16, 16, col)
				render.DrawWireframeSphere(ply:GetPos(), GetGlobalDInt("int_voice_local_range", 1), 16, 16, col, true)
				Debug3DText(ply, "Local Voice Range", ply:GetPos() + Vector(0, 0, GetGlobalDInt("int_voice_local_range", 1)), Color(100, 100, 255, 200))
			end
			if !GetGlobalDBool("bool_voice_channels", false) then
				local col = Color(255, 100, 100, 120)
				if LocalPlayer():GetPos():Distance(ply:GetPos()) < GetGlobalDInt("int_voice_max_range", 1) then
					col = Color(100, 255, 100, 120)
				end
				render.SetColorMaterial()
				render.DrawSphere(ply:GetPos(), GetGlobalDInt("int_voice_max_range", 1), 16, 16, col)
				render.DrawWireframeSphere(ply:GetPos(), GetGlobalDInt("int_voice_max_range", 1), 16, 16, col, true)
				Debug3DText(ply, "Max Voice Range", ply:GetPos() + Vector(0, 0, GetGlobalDInt("int_voice_max_range", 1)), Color(255, 100, 100, 200))
			end
		end

		if LocalPlayer():GetPos():Distance(ply:GetPos()) < renderdist and ply:Alive() and !ply:InVehicle() then
			if LocalPlayer().view_range <= 0 and ply == LocalPlayer() then
				continue
			end
			local renderalpha = 255 - 255 * (LocalPlayer():GetPos():Distance(ply:GetPos()) / renderdist)
			local _height = 24 -- 31
			local color = ply:GetColor()
			if renderalpha < color.a then
				color.a = renderalpha
			end
			color.a = math.Clamp(color.a, 0, 200)

			if LocalPlayer():GetDBool("bool_canuseesp", false) then
				render.SetColorMaterial()
				local cent = ply:OBBCenter()
				render.DrawSphere(ply:GetPos() + cent, cent.z, 16, 16, Color(0, 255, 0, 1))
			end

			if GetGlobalDBool("bool_tag_on_head", false) then
				if GetGlobalDBool("bool_tag_on_head_voice", false) and ply:GetDBool("yrp_speaking", false) then
					local plyvol = ply:VoiceVolume() * 200
					local voicecolor = Color(color.r, color.g, color.b, 55 + plyvol)
					YRP.DrawSymbol(ply, "voice", 18, voicecolor)
				end

				if GetGlobalDBool("bool_tag_on_head_chat", false) and ply:GetDBool("istyping", false) then
					YRP.DrawSymbol(ply, "chat", 18, color)
				end

				if GetGlobalDBool("bool_tag_on_head_armor", false) then
					_height = _height + 1
					local str = ply:Armor() .. "/" .. ply:GetDInt("MaxArmor", 100)
					local col = ply:HudValue("AR", "BA")
					drawBar(ply, str, _height, color, ply:Armor(), ply:GetDInt("MaxArmor", 100), Color(col.r, col.g, col.b, color.a))
					_height = _height + 6
				end

				if GetGlobalDBool("bool_tag_on_head_health", false) then
					_height = _height + 1
					local str = ply:Health() .. "/" .. ply:GetMaxHealth()
					local col = ply:HudValue("HP", "BA")
					drawBar(ply, str, _height, color, ply:Health(), ply:GetMaxHealth(), Color(col.r, col.g, col.b, color.a))
					_height = _height + 6
				end

				if GetGlobalDBool("bool_tag_on_head_clan", false) then
					drawString(ply, "<" .. "CLAN WILL BE AVAILABLE IN FUTURE" .. ">", _height, color)
					_height = _height + 5
				end

				if GetGlobalDBool("bool_tag_on_head_name", false) then
					drawString(ply, ply:RPName(), _height, color)
					_height = _height + 5
				end

				if IsLevelSystemEnabled() and GetGlobalDBool("bool_tag_on_head_level", false) then
					local lvl = ply:Level()
					local t = {}
					t["LEVEL"] = lvl
					drawString(ply, YRP.lang_string("LID_levelx", t), _height, color)
					_height = _height + 5
				end

				if ply:AFK() or ply:DND() then
					local onlinestatus = ""
					local onlinecolor = Color(255, 255, 255, 255)
					if GetGlobalDBool("isdnd", false) then
						onlinestatus = YRP.lang_string("LID_dnd")
						onlinecolor = Color(255, 0, 0, 255)
					elseif ply:AFK() then
						onlinestatus = YRP.lang_string("LID_afk")
						onlinecolor = Color(255, 255, 0, 255)
					end
					onlinecolor.a = color.a
					drawString(ply, "<" .. string.upper(onlinestatus) .. ">", _height, onlinecolor)
					_height = _height + 5
				end

				if GetGlobalDBool("bool_tag_on_head_rolename", false) then
					local rc = ply:GetRoleColor()
					rc.a = color.a
					drawString(ply, ply:GetRoleName(), _height, rc)
					_height = _height + 5
				end

				if GetGlobalDBool("bool_tag_on_head_groupname", false) then
					local gc = ply:GetGroupColor()
					gc.a = color.a
					drawString(ply, ply:GetGroupName(), _height, gc)
					_height = _height + 5
				end

				if GetGlobalDBool("bool_tag_on_head_factionname", false) then
					local fc = ply:GetFactionColor()
					fc.a = color.a
					drawString(ply, "[" .. ply:GetFactionName() .. "]", _height, fc)
					_height = _height + 5
				end

				if GetGlobalDBool("bool_tag_on_head_usergroup", false) then
					local ugcolor = ply:GetUserGroupColor()
					ugcolor.a = color.a
					drawString(ply, string.upper(ply:GetUserGroup()), _height, ugcolor)
					_height = _height + 5
				end
			end

			_height = _height + 2

			if ply:GetDBool("tag_ug", false) or (GetGlobalDBool("show_tags", false) and ply:GetMoveType() == MOVETYPE_NOCLIP and !ply:InVehicle()) and color.a > 10 then

				drawPlate(ply, string.upper(ply:GetUserGroup()), _height, Color(0, 0, 140, color.a))
				_height = _height + 9
			end

			if ply:GetDBool("tag_dev", false) and tostring(ply:SteamID()) == "STEAM_0:1:20900349" then
				drawPlate(ply, "DEVELOPER", _height, Color(0, 0, 0, color.a))
				_height = _height + 9
			end

			if GetGlobalDBool("bool_tag_on_side", false) then
				local _alpha = color.a --255 - 255 * (LocalPlayer():GetPos():Distance(ply:GetPos()) / _distance)

				local _z = 50
				local _x = -10
				local _y = 18
				local _w = 160
				local _h = 20
				local _d = 2

				if GetGlobalDBool("bool_tag_on_side_name", false) then
					drawPlayerInfo(ply, ply:RPName(), _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["na"])
					_z = _z + _d
				end

				if GetGlobalDBool("bool_tag_on_side_rolename", false) then
					local rc = ply:GetRoleColor()
					drawPlayerInfo(ply, ply:GetRoleName(), _x, _y, _z, _w, _h, Color(rc.r, rc.g, rc.b, color.a), _alpha, _icons["rn"])
					_z = _z + _d
				end

				if GetGlobalDBool("bool_tag_on_side_groupname", false) then
					local _color = ply:GetDString("groupColor", "255,0,0")
					_color = string.Explode(",", _color)
					_color = Color(_color[1], _color[2], _color[3])
					local gc = ply:GetGroupColor()
					drawPlayerInfo(ply, ply:GetGroupName(), _x, _y, _z, _w, _h, Color(gc.r, gc.g, gc.b, color.a), _alpha, _icons["gn"])
					_z = _z + _d
				end

				if GetGlobalDBool("bool_tag_on_side_factionname", false) then
					local _color = ply:GetDString("factionColor", "255,0,0")
					_color = string.Explode(",", _color)
					_color = Color(_color[1], _color[2], _color[3])
					local fc = ply:GetFactionColor()
					drawPlayerInfo(ply, "[" .. ply:GetFactionName() .. "]", _x, _y, _z, _w, _h, Color(fc.r, fc.g, fc.b, color.a), _alpha, _icons["gn"])
					_z = _z + _d
				end

				if GetGlobalDBool("bool_tag_on_side_level", false) then
					local lvl = ply:Level()
					local t = {}
					t["LEVEL"] = lvl
					drawPlayerInfo(ply, YRP.lang_string("LID_levelx", t), _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["le"])
					_z = _z + _d
				end

				if GetGlobalDBool("bool_tag_on_side_health", false) then
					local col = ply:HudValue("HP", "BA")
					drawPlayerInfo(ply, ply:Health() .. "/" .. ply:GetMaxHealth(), _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["hp"], ply:Health(), ply:GetMaxHealth(), Color(col.r, col.g, col.b, 200))
					_z = _z + _d
				end

				if GetGlobalDBool("bool_tag_on_side_armor", false) then
					local col = ply:HudValue("AR", "BA")
					drawPlayerInfo(ply, ply:Armor() .. "/" .. ply:GetDInt("MaxArmor", 100), _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["ar"], ply:Armor(), ply:GetDString("MaxArmor", ""), Color(col.r, col.g, col.b, 200))
					_z = _z + _d
				end

				if LocalPlayer():HasAccess() then
					local col = ply:HudValue("ST", "BA")
					drawPlayerInfo(ply, ply:GetDString("GetCurStamina", "") .. "/" .. ply:GetDString("GetMaxStamina", ""), _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["ms"], ply:GetDString("GetCurStamina", ""), ply:GetDString("GetMaxStamina", ""), Color(col.r, col.g, col.b, _alpha))
					_z = _z + _d
					drawPlayerInfo(ply, ply:SteamName(), _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["sn"])
					_z = _z + _d
					local ugcolor = ply:GetUserGroupColor()
					drawPlayerInfo(ply, string.upper(ply:GetUserGroup()), _x, _y, _z, _w, _h, Color(ugcolor.r, ugcolor.g, ugcolor.b, color.a), _alpha, _icons["ug"])
					_z = _z + _d
					drawPlayerInfo(ply, "+" .. GetGlobalDString("text_money_pre", "") .. ply:GetDString("salary", "") .. GetGlobalDString("text_money_pos", ""), _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["sa"])
					_z = _z + _d
					local _motext = GetGlobalDString("text_money_pre", "") .. ply:GetDString("money", "") .. GetGlobalDString("text_money_pos", "")
					local _mMin = CurTime() + ply:GetDInt("salarytime", 0) - ply:GetDInt("nextsalarytime", 0)
					local _mMax = ply:GetDInt("salarytime", 0) + 1
					drawPlayerInfo(ply, _motext, _x, _y, _z, _w, _h, Color(0, 0, 0, color.a), _alpha, _icons["mo"], _mMin, _mMax, Color(33, 108, 42, _alpha))
					_z = _z + _d
				end
			end
		end

		ply:drawPlayerInfo()
		ply:drawWantedInfo()
	end
end
hook.Add("PostDrawTranslucentRenderables", "yrp_draw_plates", drawPlates)

function draw3DText(text, x, y, color)
	color = color or Color(255, 255, 255, 255)
	surface.SetTextColor(color)
	surface.SetFont("YRP_O_" .. 24 .. "_700")
	local tw, _ = surface.GetTextSize(text)
	surface.SetTextPos(x - tw / 2, y)
	surface.DrawText(text)
end

hook.Add("HUDPaint", "yrp_esp_draw", function()
	if LocalPlayer():GetDBool("bool_canuseesp", false) then
		for i, p in pairs(player.GetAll()) do
			--if p != LocalPlayer() then
				local OBBCen = p:LocalToWorld(p:OBBCenter())
				local ScrCen = OBBCen:ToScreen()

				local dist = math.Round(LocalPlayer():GetPos():Distance(p:GetPos()) * 0.019, 0)
				draw3DText(YRP.lang_string("LID_distance") .. ": " .. dist .. "m", ScrCen.x, ScrCen.y - 50)
				draw3DText(YRP.lang_string("LID_health") .. ": " .. p:Health() .. "/" .. p:GetMaxHealth() .. " [" .. p:Armor() .. "/" .. p:GetMaxArmor() .. "]", ScrCen.x, ScrCen.y - 30)
				draw3DText(YRP.lang_string("LID_name") .. ": " .. p:SteamName() .. " [" .. p:RPName() .. "]", ScrCen.x, ScrCen.y - 10)
				draw3DText(YRP.lang_string("LID_role") .. ": " .. p:GetRoleName() .. " [" .. p:GetGroupName() .. "]", ScrCen.x, ScrCen.y + 10)
				draw3DText(YRP.lang_string("LID_usergroup") .. ": " .. p:GetUserGroup(), ScrCen.x, ScrCen.y + 30)
			--end
		end
	end
	if GetGlobalDBool("bool_server_debug_voice", false) then
		for i, p in pairs(player.GetAll()) do
			local OBBCen = p:LocalToWorld(p:OBBCenter())
			local ScrCen = OBBCen:ToScreen()

			local dist = math.Round(LocalPlayer():GetPos():Distance(p:GetPos()) * 0.019, 0)
			if dist > 0 then
				draw3DText(YRP.lang_string("LID_distance") .. ": " .. dist .. "m", ScrCen.x, ScrCen.y - 40)
			end

			draw3DText(YRP.lang_string("LID_name") .. ": " .. p:SteamName() .. " [" .. p:RPName() .. "]" .. " GROUP: " .. " [" .. p:GetGroupName() .. "]", ScrCen.x, ScrCen.y - 20)

			if GetGlobalDBool("bool_voice_channels", false) then
				draw3DText(get_speak_channel_name(p) .. " (ID: " .. p:GetDInt("speak_channel", -1) .. ")", ScrCen.x, ScrCen.y, Color(255, 255, 0, 255))
			end
			if p:GetDBool("yrp_speaking", false) then
				local text = "IS SPEAKING!"
				if p != LocalPlayer() then
					text = text .. " [Volume: " .. math.Round(p:VoiceVolume(), 2) .. "]"
				end
				draw3DText(text, ScrCen.x, ScrCen.y + 20, Color(0, 255, 0, 255))
			end
		end
	end
end)

hook.Add("PostDrawOpaqueRenderables", "yrp_npc_tags", function()
	for i, ent in pairs(ents.GetAll()) do
		if ent:IsNPC() and !ent:IsPlayer() and GetGlobalDBool("bool_tag_on_head_name", false) and ent:GetDString("dealerID", "") != "" then
			local dist = LocalPlayer():GetPos():Distance(ent:GetPos())
			if dist < 300 then
				drawStringBox(ent, ent:GetDString("name", "Unnamed"), 20, Color(255, 255, 255))
			end
		end
	end
end)

net.Receive("yrp_noti", function(len)
	local ply = LocalPlayer()
	if ply:IsValid() and ply:HasAccess() then
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
end)

net.Receive("yrp_info", function(len)
	local ply = LocalPlayer()
	if ply:IsValid() then
		local _str = net.ReadString()
		_str = YRP.lang_string("LID_notallowed") .. " (" .. YRP.lang_string(_str) .. ")"
		notification.AddLegacy(_str, NOTIFY_GENERIC, 3)
	end
end)

net.Receive("yrp_info2", function(len)
	local ply = LocalPlayer()
	if ply:IsValid() then
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
end)

net.Receive("yrp_message", function(len)
	local ply = LocalPlayer()
	if ply:IsValid() then
		local _str = YRP.lang_string(net.ReadString())
		notification.AddLegacy(_str, NOTIFY_GENERIC, 3)
	end
end)

function DrawDoorText(door)
	local header = SQL_STR_OUT(door:GetDString("text_header", ""))
	surface.SetFont("Roboto24B")
	local head_size = surface.GetTextSize(header)
	surface.SetTextColor(255, 255, 255)
	surface.SetTextPos(- head_size / 2, -80)
	surface.DrawText(header)

	local description = SQL_STR_OUT(door:GetDString("text_description", ""))
	surface.SetFont("Roboto14")
	local desc_size = surface.GetTextSize(description)
	surface.SetTextColor(255, 255, 255)
	surface.SetTextPos(- desc_size / 2, -50)
	surface.DrawText(description)

	local sl = door:GetDInt("int_securitylevel", 0)
	if sl > 0 then
		local int_securitylevel = YRP.lang_string("LID_securitylevel") .. ": " .. sl
		surface.SetFont("Roboto24B")
		local secu_size = surface.GetTextSize(int_securitylevel)
		surface.SetTextColor(255, 255, 255)
		surface.SetTextPos(- secu_size / 2, -20)
		surface.DrawText(int_securitylevel)
	end
end

local loadattempts = 0
function loadDoorTexts()
	loadattempts = loadattempts + 1
	if GetGlobalBool("loaded_doors", false) and (table.Count(ents.FindByClass("prop_door_rotating")) > 0 or table.Count(ents.FindByClass("func_door")) > 0 or table.Count(ents.FindByClass("func_door_rotating")) > 0) then
		hook.Remove("PostDrawOpaqueRenderables", "yrp_door_info")
		hook.Add("PostDrawOpaqueRenderables", "yrp_door_info", function()
			local DOORS = GetAllDoors()
			for i, door in pairs(DOORS) do
				if door != nil and door != NULL and LocalPlayer():GetPos():Distance(door:GetPos()) < 500 then
					local ang = Angle(0, 0, 0)
					local mins = door:OBBMins()
					local maxs = door:OBBMaxs()
					local x = maxs.x - mins.x
					local y = maxs.y - mins.y

					local pos = door:LocalToWorld(door:OBBCenter())

					if x > y then
						ang = Angle(0, door:GetAngles().y, 90)
						pos = pos + door:GetRight() * y * 0.7
					else
						ang = Angle(0, door:GetAngles().y + 90, 90)
						pos = pos + door:GetForward() * x * 0.7
					end

					--render.DrawSphere(pos, 10, 8, 8, Color(0, 255, 0))

					cam.Start3D2D(pos, ang, 0.2)
						DrawDoorText(door)
					cam.End3D2D()

					ang = Angle(0, 180, 0)

					mins = door:OBBMins()
					maxs = door:OBBMaxs()
					x = maxs.x - mins.x
					y = maxs.y - mins.y

					pos = door:LocalToWorld(door:OBBCenter())

					if x > y then
						ang = Angle(0, door:GetAngles().y, 90)
						pos = pos - door:GetRight() * y * 0.7
					else
						ang = Angle(0, door:GetAngles().y + 90, 90)
						pos = pos - door:GetForward() * x * 0.7
					end

					ang = ang + Angle(0, 180, 0)

					cam.Start3D2D(pos, ang, 0.2)
						DrawDoorText(door)
					cam.End3D2D()
				end
			end
		end)
		printGM("gm", "loaded door texts")
	elseif loadattempts < 10 then
		timer.Simple(2, function()
			loadDoorTexts()
		end)
	end
end
timer.Simple(5, function()
	loadDoorTexts()
end)
net.Receive("loaded_doors", function()
	timer.Simple(5, function()
		loadDoorTexts()
	end)
end)

local logos = {}
local mats = {}
function drawIDCard(ply, scale, px, py)
	px = px or 0
	py = py or 0
	scale = scale or 1
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
		if GetGlobalDBool("bool_" .. ele .. "_visible", false) then
			local w = GetGlobalDInt("int_" .. ele .. "_w", 100)
			local h = GetGlobalDInt("int_" .. ele .. "_h", 100)

			local x = GetGlobalDInt("int_" .. ele .. "_x", 0)
			local y = GetGlobalDInt("int_" .. ele .. "_y", 0)

			local color = {}
			color.r = GetGlobalDInt("int_" .. ele .. "_r", 0)
			color.g = GetGlobalDInt("int_" .. ele .. "_g", 0)
			color.b = GetGlobalDInt("int_" .. ele .. "_b", 0)
			color.a = GetGlobalDInt("int_" .. ele .. "_a", 0)

			local colortype = GetGlobalDInt("int_" .. ele .. "_colortype", 0)
			if colortype == 2 then
				color = ply:GetFactionColor()
			elseif colortype == 3 then
				color = ply:GetGroupColor()
			elseif colortype == 4 then
				color = ply:GetRoleColor()
			elseif colortype == 5 then
				color = ply:GetUserGroupColor()
			end

			local ax = GetGlobalDInt("int_" .. ele .. "_ax", 0)
			local ay = GetGlobalDInt("int_" .. ele .. "_ay", 0)

			x = x * scale
			y = y * scale
			w = w * scale
			h = h * scale

			x = x + px
			y = y + py

			if !string.find(ele, "logo") then
				if string.find(ele, "background") or string.find(ele, "box") then
					draw.RoundedBox(0, x, y, w, h, color)
				else
					local text = "LOAD"
					if ele == "hostname" then
						text = GetGlobalDString("text_server_name", "")
					elseif ele == "role" then
						text = ply:GetRoleName()
					elseif ele == "rpname" then
						text = ply:RPName()
					elseif ele == "securitylevel" then
						text = YRP.lang_string("LID_" .. ele) .. " " .. ply:GetDInt("int_securitylevel", 0)
					elseif ele == "faction" then
						text = ply:GetFactionName()
					elseif ele == "group" then
						text = ply:GetGroupName()
					elseif ele == "idcardid" then
						text = ply:GetDString("idcardid", "")
					end

					local tx = 0
					local ty = 0
					if ax == 0 then
						tx = x
					elseif ax == 1 then
						tx = x + w / 2
					elseif ax == 2 then
						tx = x + w
					end
					if ay == 0 then
						ay = 3
						ty = y
					elseif ay == 1 then
						ty = y + h / 2
					elseif ay == 2 then
						ay = 4
						ty = y + h
					end
					color.a = 255

					local fs = math.Round(36 * scale, 0)
					fs = math.Clamp(fs, 4, 72)
					fs = math.Round(fs, 0)
					draw.SimpleText(text, "Y_" .. fs .. "_500", tx, ty, color, ax, ay)
				end
			else
				if logos[ele] == nil then
					logos[ele] = true
					local size = 256
					ply.html = createD("DHTML", nil, size, size, 0, 0)
					ply.html:SetHTML(GetHTMLImage(GetGlobalDString("text_server_logo", ""), size, size))
					function ply.html:Paint(pw, ph)
						if pa(ply.html) then
							ply.htmlmat = ply.html:GetHTMLMaterial()
							if ply.htmlmat != nil and !ply.html.found then
								ply.html.found = true
								timer.Simple(0.5, function()
									ply.matname = ply.htmlmat:GetName()
									local matdata =	{
										["$basetexture"] = ply.matname,
										["$model"] = 1,
										["$translucent"] = 1,
										["$vertexalpha"] = 1,
										["$vertexcolor"] = 1
									}
									local uid = string.Replace(ply.matname, "__vgui_texture_", "")
									mats[ele] = CreateMaterial("WebMaterial_" .. uid, "UnlitGeneric", matdata)
									ply.html:Remove()
								end)
							end
						end
					end
				end
				if mats[ele] != nil then
					surface.SetDrawColor(color)
					surface.SetMaterial(mats[ele])
					surface.DrawTexturedRect(x, y, w, h)
				end
			end
		end
	end
end