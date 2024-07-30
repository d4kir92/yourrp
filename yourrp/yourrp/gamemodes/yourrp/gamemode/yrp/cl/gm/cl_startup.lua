--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
local searchIcon = Material("icon16/magnifier.png")
function OpenHelpTranslatingWindow()
	local window = YRPCreateD("DFrame", nil, YRP:ctr(1200), YRP:ctr(500), 0, 0)
	window:SetTitle("")
	window:Center()
	window:MakePopup()
	function window:Paint(pw, ph)
		surfaceWindow(self, pw, ph, "Help translating")
		draw.SimpleTextOutlined("If you want to add a new language or help translating an existing language,", "Y_18_500", YRP:ctr(10), YRP:ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("please do this:", "Y_18_500", YRP:ctr(10), YRP:ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("First go to the translation-website and register there:", "Y_18_500", YRP:ctr(10), YRP:ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("Then write D4KiR on the discord server to get rights for translating:", "Y_18_500", YRP:ctr(10), YRP:ctr(300), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
	end

	window.translationsite = YRPCreateD("YButton", window, YRP:ctr(400), YRP:ctr(50), YRP:ctr(10), YRP:ctr(200))
	window.translationsite:SetText("")
	window.translationsite.tab = {
		["text"] = "Translation website"
	}

	function window.translationsite:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph, self.tab)
	end

	function window.translationsite:DoClick()
		gui.OpenURL("https://yourrp.noserver4u.de/engage/yourrp/")
	end

	window.discordserver = YRPCreateD("YButton", window, YRP:ctr(400), YRP:ctr(50), YRP:ctr(10), YRP:ctr(300))
	window.discordserver:SetText("")
	window.discordserver.tab = {
		["text"] = "YourRP Discord server"
	}

	function window.discordserver:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph, self.tab)
	end

	function window.discordserver:DoClick()
		gui.OpenURL("https://discord.gg/CXXDCMJ")
	end
end

function YRP:AddLanguageChangerLine(parent, tab, mainparent)
	local lang = YRPCreateD("YButton", parent, parent:GetWide(), YRP:ctr(40), 0, 0)
	lang:SetText("")
	lang.lang = tab
	function lang:Paint(pw, ph)
		local color = YRPGetColor("2")
		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(0, 0, 0, pw, ph, color)
		YRP:DrawIcon(YRP:GetDesignIcon("lang_" .. tostring(self.lang.short)), YRP:ctr(46), YRP:ctr(31), YRP:ctr(4), YRP:ctr((40 - 31) / 2), Color(255, 255, 255, 255))
		self.textcol = Color(255, 255, 255, 255)
		if self.lang.percentage ~= nil then
			if self.lang.percentage == 100 then
				self.textcol = Color(0, 255, 0)
			elseif self.lang.percentage < 100 then
				local perc = 255 - 255 * self.lang.percentage / 100
				self.textcol = Color(perc, 255, perc)
			end
		end

		draw.SimpleTextOutlined(constructLanguageText(self.lang.language, self.lang.inenglish, self.lang.percentage), YRPGetFont(), YRP:ctr(4 + 46 + 8), ph / 2, self.textcol, 0, 1, 1, Color(0, 0, 0, 255))
	end

	function lang:DoClick()
		YRP:LoadLanguage(self.lang.short)
		mainparent:Remove()
	end

	parent:AddItem(lang)
end

function constructLanguageText(lang, inenglish, percentage)
	if percentage ~= nil then
		return tostring(lang) .. "/" .. tostring(inenglish) .. " ( " .. percentage .. "%)"
	else
		return tostring(lang) .. "/" .. tostring(inenglish)
	end
end

function YRP:AddLanguageAddLine(parent, mainparent)
	local lang = YRPCreateD("YButton", parent, parent:GetWide(), YRP:ctr(40), 0, 0)
	lang:SetText("")
	function lang:Paint(pw, ph)
		local color = YRPGetColor("2")
		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(0, 0, 0, pw, ph, color)
		local text = "Help translating"
		draw.SimpleTextOutlined(text, "DermaDefault", YRP:ctr(4 + 46 + 8), ph / 2, Color(255, 255, 0, 255), 0, 1, YRP:ctr(1), Color(0, 0, 0, 255))
	end

	function lang:DoClick()
		OpenHelpTranslatingWindow()
		mainparent:Remove()
	end

	parent:AddItem(lang)
end

function YRP:DChangeLanguage(parent, x, y, size, vert)
	local sw = size
	local sh = size / 5.6
	if vert then
		sw = size * 5.6
		sh = size
	end

	local LanguageChanger = YRPCreateD("DPanel", parent, sw, sh, x, y)
	function LanguageChanger:Paint(pw, ph)
	end

	--
	LanguageChanger.selecting = false
	LanguageChanger.btn = YRPCreateD("YButton", LanguageChanger, sw, sh, 0, 0)
	LanguageChanger.btn:SetText("")
	local br = YRP:ctr(10)
	function LanguageChanger.btn:Paint(pw, ph)
		local color = Color(255, 255, 255, 0) --YRPGetColor( "2" )
		local text = YRP:GetCurrentLanguageInEnglish()
		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(ph / 4, 0, 0, pw, ph, color)
		local ts = math.Round(math.Clamp(ph, 6, 100), 0)
		local font = "Y_" .. ts .. "_500"
		if self.oldtext ~= text then
			self.oldtext = text
			surface.SetFont(font)
			local tsw, _ = surface.GetTextSize(text)
			self:SetWide(br + size + br + tsw + br)
			self:SetPos(LanguageChanger:GetWide() - self:GetWide(), 0)
		end

		YRP:DrawIcon(YRP:GetDesignIcon("lang_" .. YRP:GetCurrentLanguage()), ph, ph * 0.671, br, (ph - ph * 0.671) / 2, Color(255, 255, 255, 255))
		draw.SimpleText(text, font, br + size + br, ph / 2 * 0.85, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	function LanguageChanger.btn:DoClick()
		LanguageChanger.selecting = true
		local languages = YRP:GetAllLanguages()
		surface.SetFont(YRPGetFont())
		local _longestLanguageString = 0
		for k, lang in SortedPairs(languages) do
			local testString = surface.GetTextSize(constructLanguageText(lang["language"], lang["inenglish"], lang.percentage))
			if testString > _longestLanguageString then
				_longestLanguageString = testString
			end
		end

		local window = YRPCreateD("DFrame", nil, _longestLanguageString + YRP:ctr(78), YRP:ctr(400), 0, 0)
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

				if self.startup and not self:IsHovered() and child:IsHovered() then return true end
			end

			if self.startup and not self:IsHovered() then
				self:Remove()
			end

			self:MoveToFront()
		end

		function window:OnRemove()
			if YRPPanelAlive(LanguageChanger, "LanguageChanger") then
				LanguageChanger.selecting = false
			end
		end

		window:MakePopup()
		local mx, my = gui.MousePos()
		mx = mx - window:GetWide() / 2
		my = my - YRP:ctr(25)
		window:SetPos(mx, my)
		window.dpanellist = YRPCreateD("DPanelList", window, window:GetWide(), YRP:ctr(400), 0, 0)
		YRP:AddLanguageChangerLine(window.dpanellist, YRP:GetLanguageAutoInfo(), window)
		for k, lang in SortedPairs(languages) do
			YRP:AddLanguageChangerLine(window.dpanellist, lang, window)
		end

		YRP:AddLanguageAddLine(window.dpanellist, window)
		window.dpanellist:SetTall(YRP:ctr(40 * (table.Count(languages) + 2)))
		window:SetTall(YRP:ctr(40 * (table.Count(languages) + 2)))
	end

	return LanguageChanger
end

function isInTable(mytable, item)
	for k, v in pairs(mytable) do
		if string.lower(tostring(v)) == string.lower(tostring(item.ClassName)) then return true end
	end

	return false
end

function YRPGetSWEPsList()
	local sweps = {}
	local cnames = {}
	for k, v in pairs(weapons.GetList()) do
		if not table.HasValue(cnames, v.ClassName) and not string.StartWith(string.lower(v.ClassName), "npc_") then
			table.insert(cnames, v.ClassName)
			table.insert(sweps, v)
		end
	end

	for k, v in pairs(list.Get("Weapon")) do
		if v.Category == "Half-Life 2" or string.find(v.ClassName, "weapon_physgun", 1, true) and not table.HasValue(cnames, v.ClassName) and not string.StartWith(string.lower(v.ClassName), "npc_") then
			table.insert(cnames, v.ClassName)
			table.insert(sweps, v)
		end
	end

	return sweps
end

function GetSwepWorldModel(swepcn)
	local result = ""
	local allsweps = YRPGetSWEPsList()
	for i, swep in pairs(allsweps) do
		if swep.ClassName == swepcn then
			result = swep.WorldModel or result
			break
		end
	end

	return result
end

function GetSWEPWorldModel(ClassName)
	local sweps = YRPGetSWEPsList()
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

		if tostring(v.ClassName) == tostring(ClassName) and v.WorldModel ~= nil then return v.WorldModel end
	end

	return ""
end

function GetSWEPPrintName(ClassName)
	local sweps = YRPGetSWEPsList()
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

		if tostring(v.ClassName) == tostring(ClassName) and v.PrintName ~= nil then return v.PrintName end
	end

	return ""
end

local color1 = Color(0, 0, 0, 120)
function YRPOpenSelector(tab, multiple, ret, fu)
	local lply = LocalPlayer()
	if multiple then
		lply.yrpseltab = lply.yrpseltab or {}
	else
		lply.yrpseltab = {}
	end

	local br = 10
	local pmsel = YRPCreateD("YFrame", nil, ScrW(), ScrH(), 0, 0)
	pmsel:SetTitle(YRP:trans("LID_add") .. ": " .. tostring(ret))
	pmsel:Center()
	pmsel:MakePopup()
	pmsel.nr = 0
	function pmsel:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
		if self.nr and self.perpage and pmsel.maxpage then
			draw.SimpleText(YRP:trans("LID_page") .. ": " .. ((pmsel.nr / self.perpage) + 1) .. "/" .. pmsel.maxpage, "DermaDefault", ScrW() / 2, ph - YRP:ctr(50 + 10), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	local parent = pmsel:GetContent()
	pmsel.height = parent:GetTall() - YRP:ctr(10 + 50 + 10 + 10 + 50 + 10)
	pmsel.fx = parent:GetWide() - YRP:ctr(br + br)
	pmsel.size = (pmsel.height - 3 * br) / 4
	pmsel.space = pmsel.size + br
	pmsel.x_max = pmsel.fx / pmsel.space - pmsel.fx / pmsel.space % 1
	pmsel.perpage = pmsel.x_max * 4
	pmsel.maxpage = math.ceil(#tab / pmsel.perpage)
	function parent:Paint(pw, ph)
		draw.SimpleText(YRP:trans("LID_search") .. ": ", "DermaDefault", YRP:ctr(br + 100), YRP:ctr(br + 25), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	pmsel.dpl = YRPCreateD("DPanel", parent, parent:GetWide() - YRP:ctr(br + br), parent:GetTall() - YRP:ctr(br + 50 + br + br + 50 + br), YRP:ctr(br), YRP:ctr(br + 50 + br))
	function pmsel.dpl:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, color1)
	end

	--pmsel.dpl:EnableVerticalScrollbar(true)
	--pmsel.dpl:SetSpacing(10)
	function pmsel:RefreshPage()
		pmsel.dpl:Clear()
		self.count = 0
		self.fcount = 0
		self.nothingfound = true
		self.px = 0
		self.py = 0
		if pmsel.strsearch ~= nil then
			pmsel.strsearch = string.Replace(pmsel.strsearch or "", "[", "")
			pmsel.strsearch = string.Replace(pmsel.strsearch or "", "]", "")
			pmsel.strsearch = string.Replace(pmsel.strsearch or "", "%", "")
		end

		for i, v in pairs(tab) do
			if YRPPanelAlive(pmsel, "pmsel 1") and pmsel.strsearch ~= nil and v.PrintName ~= nil and (string.find(string.lower(v.PrintName or ""), pmsel.strsearch or "", 1, true) or string.find(string.lower(v.ClassName or ""), pmsel.strsearch or "", 1, true) or string.find(string.lower(v.WorldModel or ""), pmsel.strsearch or "", 1, true)) then
				self.nothingfound = false
				self.count = self.count + 1
				if self.count > pmsel.nr and self.count <= pmsel.nr + pmsel.perpage then
					self.fcount = self.fcount + 1
					local d_pm = YRPCreateD("DPanel", pmsel.dpl, pmsel.size, pmsel.size, self.px * pmsel.space, self.py * pmsel.space)
					d_pm:SetText("")
					d_pm.WorldModel = v.WorldModel
					d_pm.ClassName = v.ClassName
					d_pm.PrintName = v.PrintName
					function d_pm:Paint(pw, ph)
						local text = YRP:trans("LID_notadded")
						local col = Color(255, 255, 255, 255)
						if ret == "worldmodel" then
							if lply.yrpseltab ~= nil and table.HasValue(lply.yrpseltab, self.WorldModel) then
								col = Color(0, 255, 0)
								text = YRP:trans("LID_added")
							end
						elseif ret == "classname" then
							if lply.yrpseltab ~= nil and table.HasValue(lply.yrpseltab, self.ClassName) then
								col = Color(0, 255, 0)
								text = YRP:trans("LID_added")
							end
						end

						draw.RoundedBox(YRP:ctr(10), 0, 0, pw, ph, col)
						if multiple then
							draw.SimpleText(text, "DermaDefault", pw / 2, ph * 0.05, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end

						draw.SimpleText(self.PrintName, "DermaDefault", pw / 2, ph * 0.90, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(self.WorldModel, "DermaDefault", pw / 2, ph * 0.95, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end

					local msize = d_pm:GetTall() * 0.75
					local mbr = (d_pm:GetTall() - msize) / 2
					local my = d_pm:GetTall() * 0.10
					if v.WorldModel ~= "" then
						d_pm.model = YRPCreateD("DModelPanel", d_pm, msize, msize, mbr, my)
						timer.Simple(
							0.1 * self.fcount,
							function()
								if YRPPanelAlive(d_pm, "d_pm 1") and YRPPanelAlive(d_pm.model, "d_pm.model") then
									d_pm.model:SetModel(v.WorldModel)
								end
							end
						)
					else
						d_pm.model = YRPCreateD("DPanel", d_pm, msize, msize, mbr, my)
						function d_pm.model:Paint(pw, ph)
							draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
							draw.SimpleText("NO MODEL", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end
					end

					d_pm.btn = YRPCreateD("YButton", d_pm, d_pm:GetWide(), d_pm:GetTall(), 0, 0)
					d_pm.btn:SetText("")
					function d_pm.btn:DoClick()
						if ret == "worldmodel" then
							if not table.HasValue(lply.yrpseltab, v.WorldModel) then
								table.insert(lply.yrpseltab, v.WorldModel)
							elseif table.HasValue(lply.yrpseltab, v.WorldModel) then
								table.RemoveByValue(lply.yrpseltab, v.WorldModel)
							end
						elseif ret == "classname" then
							if not table.HasValue(lply.yrpseltab, v.ClassName) then
								table.insert(lply.yrpseltab, v.ClassName)
							elseif table.HasValue(lply.yrpseltab, v.ClassName) then
								table.RemoveByValue(lply.yrpseltab, v.ClassName)
							end
						end

						if not multiple and YRPPanelAlive(pmsel, "pmsel 2") then
							if fu then
								fu()
							end

							pmsel:Close()
						end
					end

					function d_pm.btn:Paint(pw, ph)
					end

					self.px = self.px + 1
					if self.px > pmsel.x_max - 1 then
						self.px = 0
						self.py = self.py + 1
					end
				end
			end
		end

		pmsel.maxpage = math.ceil(self.count / pmsel.perpage)
		if self.fcount <= 0 then
			pmsel.nr = pmsel.nr - pmsel.perpage
			if not self.nothingfound then
				self:RefreshPage()
			end
		end
	end

	function pmsel:Search(strsearch)
		strsearch = string.lower(strsearch)
		pmsel.strsearch = strsearch
		pmsel.nr = 0
		pmsel:RefreshPage()
	end

	pmsel.prev = YRPCreateD("YButton", parent, YRP:ctr(100), YRP:ctr(50), parent:GetWide() / 2 - YRP:ctr(100 + br) - YRP:ctr(100), parent:GetTall() - YRP:ctr(50 + br))
	pmsel.prev:SetText("<")
	function pmsel.prev:DoClick()
		if pmsel.nr >= pmsel.perpage then
			pmsel.nr = pmsel.nr - pmsel.perpage
			pmsel:RefreshPage()
		end
	end

	pmsel.next = YRPCreateD("YButton", parent, YRP:ctr(100), YRP:ctr(50), parent:GetWide() / 2 + YRP:ctr(100 + br), parent:GetTall() - YRP:ctr(50 + br))
	pmsel.next:SetText(">")
	function pmsel.next:DoClick()
		pmsel.nr = pmsel.nr + pmsel.perpage
		pmsel:RefreshPage()
	end

	if multiple then
		pmsel.done = YRPCreateD("YButton", parent, YRP:ctr(200), YRP:ctr(50), parent:GetWide() - YRP:ctr(200 + br), parent:GetTall() - YRP:ctr(50 + br))
		pmsel.done:SetText("LID_done")
		function pmsel.done:DoClick()
			if fu then
				fu()
			end

			if YRPPanelAlive(pmsel, "pmsel 3") then
				pmsel:Close()
			end
		end
	end

	pmsel.search = YRPCreateD("DTextEntry", parent, parent:GetWide() - YRP:ctr(10 + 100 + 10), YRP:ctr(50), YRP:ctr(10 + 100), YRP:ctr(10))
	function pmsel.search:OnChange()
		pmsel:Search(self:GetText())
	end

	timer.Simple(
		1,
		function()
			if YRPPanelAlive(pmsel, "pmsel 4") then
				pmsel:Search("")
			end
		end
	)
end

function openSingleSelector(tab, closeF, web)
	local site = {}
	site.cur = 1
	site.max = 1
	site.count = #tab
	local _item = {}
	_item.w = 740
	_item.h = 370
	local _w = ScrW() - YRP:ctr(20)
	local _h = ScrH() - YRP:ctr(50 + 10 + 50 + 10 + 10 + 50 + 10)
	local _x = YRP:ctr(10)
	local _y = YRP:ctr(50 + 10 + 50 + 10)
	local _cw = _w / YRP:ctr(_item.w + 10)
	_cw = _cw - _cw % 1
	local _ch = _h / YRP:ctr(_item.h + 10)
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
	local frame = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
	frame:SetDraggable(false)
	frame:SetTitle(YRP:trans("Item Menu"))
	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, get_dbg_col())
		draw.SimpleTextOutlined(site.cur .. "/" .. site.max, "Y_24_500", pw / 2, ph - YRP:ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
	end

	function frame:OnClose()
		hook.Call(closeF)
	end

	local PanelSelect = YRPCreateD("DPanel", frame, _w, _h, _x, _y)
	PanelSelect:SetText("")
	function PanelSelect:Paint(pw, ph)
	end

	--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
	local searchButton = YRPCreateD("YButton", frame, YRP:ctr(50), YRP:ctr(50), YRP:ctr(10), YRP:ctr(50 + 10))
	searchButton:SetText("")
	function searchButton:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
		local _br = 4
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(searchIcon)
		surface.DrawTexturedRect(YRP:ctr(5), YRP:ctr(5), YRP:ctr(40), YRP:ctr(40))
	end

	local search = YRPCreateD("DTextEntry", frame, _w - YRP:ctr(50 + 10), YRP:ctr(50), YRP:ctr(10 + 50 + 10), YRP:ctr(50 + 10))
	function search:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		local _string = search:GetText()
		if _string == "" then
			_string = YRP:trans("LID_search")
		end

		draw.SimpleTextOutlined(_string, "DermaDefault", YRP:ctr(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, YRP:ctr(1), Color(0, 0, 0, 255))
	end

	function showList()
		if not YRPPanelAlive(PanelSelect) then return end
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
			searchtext = string.Replace(searchtext or "", "[", "")
			searchtext = string.Replace(searchtext or "", "]", "")
			searchtext = string.Replace(searchtext or "", "%", "")
			if string.find(string.lower(item.WorldModel or ""), searchtext, 1, true) or string.find(string.lower(item.PrintName or ""), searchtext, 1, true) or string.find(string.lower(item.ClassName or ""), searchtext, 1, true) then
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

					local icon = YRPCreateD("DPanel", PanelSelect, YRP:ctr(_item.w), YRP:ctr(_item.h), tmpX, tmpY)
					function icon:Paint(pw, ph)
						if item.ishidden then
							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100))
							draw.SimpleText("HIDDEN ENTITY!", "Y_30_500", pw / 2, YRP:ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						else
							draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
						end
					end

					local spawnicon = YRPCreateD("SpawnIcon", icon, YRP:ctr(_item.h), YRP:ctr(_item.h), 0, 0)
					spawnicon.item = item
					spawnicon:SetText("")
					spawnicon:SetModel(item.WorldModel)
					spawnicon:SetTooltip(item.PrintName)
					local _tmpName = YRPCreateD("YButton", icon, YRP:ctr(_item.w), YRP:ctr(_item.h), 0, 0)
					_tmpName:SetText("")
					function _tmpName:Paint(pw, ph)
						draw.SimpleTextOutlined(item.PrintName, "Y_20_500", pw - YRP:ctr(10), ph - YRP:ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
						draw.SimpleTextOutlined(item.ClassName, "Y_20_500", pw - YRP:ctr(10), ph - YRP:ctr(60), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
					end

					function _tmpName:DoClick()
						LocalPlayer().WorldModel = item.WorldModel
						LocalPlayer().ClassName = item.ClassName
						LocalPlayer().PrintName = item.PrintName
						LocalPlayer().Skin = item.Skin
						frame:Close()
					end

					tmpX = tmpX + YRP:ctr(_item.w) + tmpBr
					if tmpX > _w - YRP:ctr(_item.w) then
						tmpX = 0
						tmpY = tmpY + YRP:ctr(_item.h) + tmpBr
					end
				end
			end
		end
	end

	local nextB = YRPCreateD("YButton", frame, YRP:ctr(200), YRP:ctr(50), ScrW() - YRP:ctr(200 + 10), ScrH() - YRP:ctr(50 + 10))
	nextB:SetText("")
	function nextB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP:trans("LID_next"), "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end

	function nextB:DoClick()
		if site.max > site.cur then
			site.cur = site.cur + 1
			showList()
		end
	end

	local prevB = YRPCreateD("YButton", frame, YRP:ctr(200), YRP:ctr(50), YRP:ctr(10), ScrH() - YRP:ctr(50 + 10))
	prevB:SetText("")
	function prevB:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP:trans("LID_prev"), "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
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

net.Receive(
	"yrpInfoBox",
	function(len)
		local _tmp = createVGUI("DFrame", nil, 800, 400, 0, 0)
		_tmp:SetTitle("Notification")
		local _text = net.ReadString()
		function _tmp:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 80))
			draw.SimpleTextOutlined(_text, "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end

		local closeButton = createVGUI("YButton", _tmp, 200, 50, 400 - 100, 400 - 50)
		closeButton:SetText("Close")
		function closeButton:DoClick()
			_tmp:Close()
		end

		_tmp:Center()
		_tmp:MakePopup()
	end
)

function YRP:Color()
	return Color(26, 113, 242)
end

local vTab = {}
function YRPHUD(name, failed)
	if string.StartWith(name, "float_HUD_") then
		return GetGlobalYRPFloat(name, 0.0)
	elseif string.StartWith(name, "int_HUD_") then
		return GetGlobalYRPInt(name, 0)
	elseif string.StartWith(name, "bool_HUD_") then
		return GetGlobalYRPBool(name, false)
	elseif string.StartWith(name, "text_HUD_") then
		return GetGlobalYRPString(name, "")
	elseif string.StartWith(name, "color_HUD_") then
		local vecname = GetGlobalYRPString(name, "255,0,0,255")
		if _type(vecname) == "string" then
			if vTab[vecname] == nil then
				vTab[vecname] = StringToColor(vecname)
			end

			return vTab[vecname]
		end
	elseif name == "Version" then
		return GetGlobalYRPInt("Version", -1)
	else
		MsgC(Color(0, 255, 0), "Failed To HUD", name, "\n")
	end

	return failed
end

--Remove Ragdolls after 60 sec
function RemoveDeadRag(ent)
	if (ent == NULL) or (ent == nil) then return end
	if (ent:GetClass() == "class C_ClientRagdoll") and ent:IsValid() and ent ~= NULL then
		SafeRemoveEntityDelayed(ent, 60)
	end
end

hook.Add("OnEntityCreated", "RemoveDeadRag", RemoveDeadRag)
function GM:HUDDrawTargetID()
	return false
end

function YRP:DrawSymbol(ply, str, z, color, x)
	local px = x or 0
	local _size = 40
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)
	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
	if YRP:GetDesignIcon(str) then
		surface.SetDrawColor(color)
		surface.SetMaterial(YRP:GetDesignIcon(str))
		surface.DrawTexturedRect(-_size / 2 - px, 0, _size, _size)
	end

	cam.End3D2D()
end

function YRPDrawNamePlateStringBox(ent, instr, z, color)
	local pos = ent:GetPos() + Vector(0, 0, ent:OBBMaxs().z)
	if ent:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local str = instr
	cam.Start3D2D(pos + Vector(0, 0, z), ang, 0.2)
	surface.SetFont("Y_18_500")
	local tw, th = surface.GetTextSize(str)
	--surfaceText(str, "Y_22_500", 0, _th / 2 + 1, color, 1, 1)
	local br = 4
	local box = {}
	box.w = tw + 5 * br + th
	box.h = th + 2 * br
	draw.RoundedBox(math.Round(box.h / 2 - (box.h / 2) % 1, 0), -box.w / 2, 0, box.w, box.h, Color(0, 0, 0, 160))
	if YRP:GetDesignIcon("shopping_cart") ~= nil then
		local ico = {}
		ico.w = th * 0.8
		ico.h = ico.w
		ico.br = (th - ico.h) / 2
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(YRP:GetDesignIcon("shopping_cart"))
		surface.DrawTexturedRect(-box.w / 2 + br + ico.br, br + ico.br, ico.w, ico.h)
	end

	draw.SimpleText(instr, "Y_18_500", -box.w / 2 + th + 2 * br, box.h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) --, 1, Color( 0, 0, 0, 255 ) )
	cam.End3D2D()
end

function YRPDrawNamePlateString(ply, instr, z, color)
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)
	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4 / 5
	local str = instr
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
	surface.SetFont("Y_100_500")
	local _tw, _th = surface.GetTextSize(str)
	_tw = math.Round(_tw * 1.08, 0)
	_th = _th
	draw.SimpleText(str, "Y_100_500", 0, _th / 2 + 1, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

local lerptab = {}
function YRPDrawNamePlateBar(ply, stri, z, color, cur, max, barcolor, name)
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)
	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4 / 5
	local str = stri
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
	surface.SetFont("Y_100_500")
	local _tw, _th = surface.GetTextSize(str)
	_th = _th
	local w = 1000
	local r = 18
	local br = 10
	lerptab[name] = lerptab[name] or 0
	lerptab[name] = Lerp(FrameTime() * 2, lerptab[name], cur)
	draw.RoundedBox(r, -w / 2 - br, 2 - br, w + br * 2, 100 + br * 2, Color(0, 0, 0, barcolor.a))
	draw.RoundedBox(r / 2, -w / 2, 2, w * lerptab[name] / max, 100, barcolor)
	surfaceText(str, "Y_100_500", 0, _th / 2 - 0.2, color, 1, 1)
	cam.End3D2D()
end

function YRPDrawNamePlate(ply, stri, z, color)
	local br = 2
	local font = "Y_100_700"
	local textcolor = YRPTextColor(color)
	local pos = ply:GetPos() + Vector(0, 0, ply:OBBMaxs().z)
	if ply:LookupBone("ValveBiped.Bip01_Head1") then
		pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))
	end

	local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	local sca = ply:GetModelScale() / 4 / 4
	local str = stri
	cam.Start3D2D(pos + Vector(0, 0, z * ply:GetModelScale()), ang, sca)
	surface.SetFont(font)
	local _tw, _th = surface.GetTextSize(str)
	_tw = _tw + _th + 2 * br
	_th = _th + 2 * br
	textcolor.a = color.a
	color.a = color.a / 2
	draw.RoundedBox(_th, -_tw / 2, 0, _tw, _th, color)
	draw.SimpleText(str, font, 0, _th / 2, textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function YRPDrawNamePlayerInfo(ply, _str, _x, _y, _z, _w, _h, color, _alpha, icon, _cur, _max, color2)
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
	surface.SetFont("Y_18_500")
	local _tw, _th = surface.GetTextSize(str)
	_tw = _tw + 8
	_th = _th
	color.a = math.Round(color.a * 0.5, 0)
	draw.RoundedBox(0, 0, 0, w, h, color)
	if _cur ~= nil and _max ~= nil then
		color2.a = alpha
		local cur = tonumber(_cur)
		local max = tonumber(_max)
		if cur ~= nil and max ~= nil and max > 0 then
			draw.RoundedBox(0, 0, 0, cur / max * w, h, color2)
		end
	end

	if icon ~= nil then
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(2, 2, h - 4, h - 4)
	end

	color.a = alpha
	surfaceText(str, "Y_18_500", 5 + h, h / 2, Color(color.r, color.g, color.b, color.a + 1), 0, 1)
	cam.End3D2D()
end

local _icons = {}
_icons["hp"] = Material("icon16/heart.png")
_icons["ar"] = Material("icon16/shield.png")
_icons["gn"] = Material("icon16/group.png")
_icons["rn"] = Material("icon16/user_gray.png")
_icons["na"] = Material("icon16/vcard.png")
_icons["id"] = Material("icon16/vcard.png")
_icons["sa"] = Material("icon16/money_add.png")
_icons["mo"] = Material("icon16/money.png")
_icons["sn"] = Material("icon16/status_online.png")
_icons["ug"] = Material("icon16/group_key.png")
_icons["ms"] = Material("icon16/lightning.png")
_icons["le"] = Material("icon16/layers.png")
function YRPDebug3DText(ply, str, pos, color)
	local _tw, _th = surface.GetTextSize(str)
	if _tw and _th then
		local yaw = LocalPlayer():GetAngles().y
		cam.Start3D2D(pos + Vector(0, 0, _th), Angle(0, yaw - 90, 90), 1)
		surface.SetFont("Y_22_500")
		_tw = math.Round(_tw * 1.08, 0)
		_th = _th
		surfaceText(str, "Y_22_500", 0, _th / 2 + 1, color, 1, 1)
		cam.End3D2D()
	end
end

local translatorsteamids = {
	-- DE -- D4KiR
	["76561198002066427"] = true,
	-- RU
	["76561198219530143"] = true, -- Aimatt
	["76561198349004756"] = true, -- Uzlovskii
	-- TR -- KAEL
	["76561198064891084"] = true,
}

local symc = 0
local delay = 0
function YRPDrawNamePlates()
	local renderdist = 550
	local _distance = 200
	if IsValid(LocalPlayer()) and player.GetAll() then
		-- NAMEPLATES
		for i, ply in pairs(player.GetAll()) do
			ply.ply_distance = LocalPlayer():GetPos():Distance(ply:GetPos())
		end

		for i, ply in SortedPairsByMemberValue(player.GetAll(), "ply_distance", true) do
			if GetGlobalYRPBool("bool_server_debug_voice", false) and LocalPlayer():GetPos():Distance(ply:GetPos()) < 1000 then
				local col = Color(255, 100, 100, 120)
				if ply == LocalPlayer() then
					local esphere = ents.FindInSphere(LocalPlayer():GetPos(), GetGlobalYRPInt("int_voice_max_range", 1))
					for j, ent in pairs(esphere) do
						if ent:IsPlayer() and ent ~= LocalPlayer() then
							col = Color(100, 255, 100, 120)
						end
					end
				else
					if LocalPlayer() and ply and LocalPlayer():GetPos():Distance(ply:GetPos()) < GetGlobalYRPInt("int_voice_max_range", 1) then
						col = Color(100, 255, 100, 120)
					end
				end

				render.SetColorMaterial()
				local range = YRPGetVoiceRange(ply)
				render.DrawSphere(ply:GetPos(), range, 16, 16, col)
				render.DrawWireframeSphere(ply:GetPos(), range, 16, 16, col, true)
				render.DrawSphere(ply:GetPos(), GetGlobalYRPInt("int_voice_max_range", 1), 16, 16, col)
				render.DrawWireframeSphere(ply:GetPos(), GetGlobalYRPInt("int_voice_max_range", 1), 16, 16, col, true)
				YRPDebug3DText(ply, "Max Voice Range", ply:GetPos() + Vector(0, 0, GetGlobalYRPInt("int_voice_max_range", 1)), Color(255, 100, 100, 200))
			end

			if LocalPlayer():GetPos():Distance(ply:GetPos()) < renderdist and ply:Alive() and not ply:InVehicle() then
				if LocalPlayer().yrp_view_range ~= nil and LocalPlayer().yrp_view_range <= 0 and ply == LocalPlayer() then continue end
				local renderalpha = 255 - 255 * (LocalPlayer():GetPos():Distance(ply:GetPos()) / renderdist)
				local _height = 24 -- 31
				local color = ply:GetColor()
				local color2 = ply:GetColor()
				ply.headalpha = ply.headalpha or 0
				ply.sidealpha = ply.sidealpha or 0
				if GetGlobalYRPBool("bool_tag_on_head_target", false) then
					local pt = LocalPlayer():GetEyeTrace()
					if pt and IsValid(pt.Entity) and ply == pt.Entity then
						ply.headalpha = ply.headalpha + 5
					else
						ply.headalpha = ply.headalpha - 5
					end

					local maxalpha = math.Clamp(color.a, 0, 240)
					ply.headalpha = math.Clamp(ply.headalpha, 0, maxalpha)
					color.a = ply.headalpha
				elseif renderalpha < color.a then
					color.a = renderalpha
				end

				color.a = math.Clamp(color.a, 0, 240)
				if GetGlobalYRPBool("bool_tag_on_side_target", false) then
					local pt = LocalPlayer():GetEyeTrace()
					if pt and pt.Entity and ply == pt.Entity then
						ply.sidealpha = ply.sidealpha + 5
					else
						ply.sidealpha = ply.sidealpha - 5
					end

					ply.sidealpha = math.Clamp(ply.sidealpha, 0, 240)
					color2.a = ply.sidealpha
				elseif renderalpha < color2.a then
					color2.a = renderalpha
				end

				color2.a = math.Clamp(color2.a, 0, 240)
				if GetGlobalYRPBool("bool_tag_on_head", false) then
					if GetGlobalYRPBool("bool_tag_on_head_voice", false) and ply:GetYRPBool("yrp_speaking", false) then
						local plyvol = ply:VoiceVolume() * 200
						plyvol = 125 + plyvol
						if GetGlobalYRPBool("bool_tag_on_head_target_forced", false) then
							plyvol = math.Clamp(plyvol, 0, color.a)
						else
							plyvol = math.Clamp(plyvol, 0, ply:GetColor().a)
						end

						-- flüstern
						local sym = "volume_mute"
						local x = 0
						local voicecolor = Color(255, 255, 255, plyvol)
						-- Schreien
						if ply:VoiceVolume() > 0.50 then
							voicecolor = Color(255, 100, 100, plyvol)
						elseif ply:VoiceVolume() > 0.20 then
							-- Laut
							voicecolor = Color(220, 220, 80, plyvol)
						elseif ply:VoiceVolume() > 0.08 then
							-- Normal
							voicecolor = Color(80, 255, 80, plyvol)
						elseif ply:VoiceVolume() > 0.04 then
							-- Flüstern
							voicecolor = Color(160, 255, 160, plyvol)
						end

						if symc == 1 then
							x = 0
							sym = "volume_down"
						elseif symc == 2 then
							x = 0
							sym = "volume_up"
						end

						YRP:DrawSymbol(ply, sym, 21, voicecolor, x)
					elseif GetGlobalYRPBool("bool_tag_on_head_chat", false) and ply:GetYRPBool("istyping", false) then
						local chatalpha = 150
						if GetGlobalYRPBool("bool_tag_on_head_target_forced", false) then
							chatalpha = math.Clamp(chatalpha, 0, color.a)
						else
							chatalpha = math.Clamp(chatalpha, 0, ply:GetColor().a)
						end

						YRP:DrawSymbol(ply, "chat", 21, Color(255, 255, 255, chatalpha))
					end

					if GetGlobalYRPBool("bool_tag_on_head_armor", false) then
						_height = _height + 4
						local str = ply:Armor() .. "/" .. ply:GetYRPInt("MaxArmor", 100)
						local col = ply:HudValue("AR", "BA")
						YRPDrawNamePlateBar(ply, str, _height, color, ply:Armor(), ply:GetYRPInt("MaxArmor", 100), Color(col.r, col.g, col.b, color.a), "AR")
						_height = _height + 6
					end

					if GetGlobalYRPBool("bool_tag_on_head_health", false) or LocalPlayer():GetYRPBool("bool_ismedic", false) then
						_height = _height + 1
						local str = ply:Health() .. "/" .. ply:GetMaxHealth()
						local col = ply:HudValue("HP", "BA")
						YRPDrawNamePlateBar(ply, str, _height, color, ply:Health(), ply:GetMaxHealth(), Color(col.r, col.g, col.b, color.a), "HP")
						_height = _height + 6
					end

					--[[if GetGlobalYRPBool( "bool_tag_on_head_clan", false) then
						if !strEmpty(ply:GetYRPString( "yrp_clan", "" ) ) then
							YRPDrawNamePlateString(ply, "<" .. ply:GetYRPString( "yrp_clan", "" ) .. ">", _height, color)
							_height = _height + 5
						end
					end]]
					if GetGlobalYRPBool("bool_tag_on_head_name", false) then
						local drawname = false
						if GetGlobalYRPBool("bool_tag_on_head_name_onlyrole", false) then
							if LocalPlayer():GetRoleUID() == ply:GetRoleUID() then
								drawname = true
							end
						elseif GetGlobalYRPBool("bool_tag_on_head_name_onlygroup", false) then
							if LocalPlayer():GetGroupUID() == ply:GetGroupUID() then
								drawname = true
							end
						elseif GetGlobalYRPBool("bool_tag_on_head_name_onlyfaction", false) then
							if LocalPlayer():GetFactionUID() == ply:GetFactionUID() then
								drawname = true
							end
						else
							drawname = true
						end

						if drawname then
							YRPDrawNamePlateString(ply, ply:RPName(), _height, color)
							_height = _height + 5
						end
					end

					if GetGlobalYRPBool("bool_tag_on_head_idcardid", false) then
						YRPDrawNamePlateString(ply, ply:IDCardID(), _height, color)
						_height = _height + 5
					end

					if IsLevelSystemEnabled() and GetGlobalYRPBool("bool_tag_on_head_level", false) then
						local lvl = ply:Level()
						local t = {}
						t["LEVEL"] = lvl
						YRPDrawNamePlateString(ply, YRP:trans("LID_levelx", t), _height, color)
						_height = _height + 5
					end

					if ply:AFK() or ply:DND() then
						local onlinestatus = ""
						local onlinecolor = Color(255, 255, 255, 255)
						if ply:DND() then
							onlinestatus = YRP:trans("LID_dnd")
							onlinecolor = Color(255, 0, 0, 255)
						elseif ply:AFK() then
							onlinestatus = YRP:trans("LID_afk")
							onlinecolor = Color(255, 255, 0, 255)
						else
							onlinestatus = "FAILED REPORT DEV"
							onlinecolor = Color(255, 0, 0, 255)
						end

						onlinecolor.a = color.a
						YRPDrawNamePlateString(ply, "<" .. string.upper(onlinestatus) .. ">", _height, onlinecolor)
						_height = _height + 5
					end

					if GetGlobalYRPBool("bool_tag_on_head_rolename", false) then
						local rc = ply:GetRoleColor()
						rc.a = color.a
						YRPDrawNamePlateString(ply, ply:GetRoleName(), _height, rc)
						_height = _height + 5
					end

					if GetGlobalYRPBool("bool_tag_on_head_groupname", false) then
						local gc = ply:GetGroupColor()
						gc.a = color.a
						YRPDrawNamePlateString(ply, ply:GetGroupName(), _height, gc)
						_height = _height + 5
					end

					if GetGlobalYRPBool("bool_tag_on_head_factionname", false) then
						local fc = ply:GetFactionColor()
						fc.a = color.a
						YRPDrawNamePlateString(ply, "[" .. ply:GetFactionName() .. "]", _height, fc)
						_height = _height + 5
					end

					if GetGlobalYRPBool("bool_tag_on_head_usergroup", false) then
						local ugcolor = ply:GetUserGroupColor()
						ugcolor.a = color.a
						YRPDrawNamePlateString(ply, ply:GetUserGroupNice(), _height, ugcolor)
						_height = _height + 5
					end
				end

				_height = _height + 2
				if ply:GetYRPBool("tag_ug", false) or (GetGlobalYRPBool("show_tags", false) and ply:GetMoveType() == MOVETYPE_NOCLIP and not ply:InVehicle()) and color.a > 10 then
					local ugcolor = ply:GetUserGroupColor()
					ugcolor.a = color.a
					YRPDrawNamePlate(ply, ply:GetUserGroupNice(), _height, ugcolor)
					_height = _height + 7
				end

				-- Translators of YourRP
				if ply:GetYRPBool("tag_tra", false) and translatorsteamids[tostring(ply:SteamID64())] then
					YRPDrawNamePlate(ply, YRP:trans("LID_gamemodetranslator"), _height, Color(100, 100, 255, color.a))
					_height = _height + 7
				end

				-- D4KIR, Developer of YourRP
				if ply:GetYRPBool("tag_dev", false) and tostring(ply:SteamID64()) == "76561198002066427" then
					YRPDrawNamePlate(ply, YRP:trans("LID_gamemodedeveloper"), _height, Color(255, 165, 0, color.a))
					_height = _height + 7
				end

				if GetGlobalYRPBool("bool_tag_on_side", false) then
					local _alpha = color2.a --255 - 255 * (LocalPlayer():GetPos():Distance(ply:GetPos() ) / _distance)
					local _z = 50
					local _x = -10
					local _y = 18
					local _w = 160
					local _h = 20
					local _d = 2
					if GetGlobalYRPBool("bool_tag_on_side_name", false) then
						YRPDrawNamePlayerInfo(ply, ply:RPName(), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["na"])
						_z = _z + _d
					end

					if GetGlobalYRPBool("bool_tag_on_side_idcardid", false) then
						YRPDrawNamePlayerInfo(ply, ply:IDCardID(), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["id"])
						_z = _z + _d
					end

					if GetGlobalYRPBool("bool_tag_on_side_rolename", false) then
						local rc = ply:GetRoleColor()
						YRPDrawNamePlayerInfo(ply, ply:GetRoleName(), _x, _y, _z, _w, _h, Color(rc.r, rc.g, rc.b, _alpha), _alpha, _icons["rn"])
						_z = _z + _d
					end

					if GetGlobalYRPBool("bool_tag_on_side_groupname", false) then
						local _color = ply:GetYRPString("groupColor", "255,0,0")
						_color = string.Explode(",", _color)
						_color = Color(_color[1], _color[2], _color[3])
						local gc = ply:GetGroupColor()
						YRPDrawNamePlayerInfo(ply, ply:GetGroupName(), _x, _y, _z, _w, _h, Color(gc.r, gc.g, gc.b, _alpha), _alpha, _icons["gn"])
						_z = _z + _d
					end

					if GetGlobalYRPBool("bool_tag_on_side_factionname", false) then
						local _color = ply:GetYRPString("factionColor", "255,0,0")
						_color = string.Explode(",", _color)
						_color = Color(_color[1], _color[2], _color[3])
						local fc = ply:GetFactionColor()
						YRPDrawNamePlayerInfo(ply, "[" .. ply:GetFactionName() .. "]", _x, _y, _z, _w, _h, Color(fc.r, fc.g, fc.b, _alpha), _alpha, _icons["gn"])
						_z = _z + _d
					end

					if GetGlobalYRPBool("bool_tag_on_side_level", false) then
						local lvl = ply:Level()
						local t = {}
						t["LEVEL"] = lvl
						YRPDrawNamePlayerInfo(ply, YRP:trans("LID_levelx", t), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["le"])
						_z = _z + _d
					end

					if GetGlobalYRPBool("bool_tag_on_side_health", false) then
						local col = ply:HudValue("HP", "BA")
						YRPDrawNamePlayerInfo(ply, ply:Health() .. "/" .. ply:GetMaxHealth(), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["hp"], ply:Health(), ply:GetMaxHealth(), Color(col.r, col.g, col.b, 200))
						_z = _z + _d
					end

					if GetGlobalYRPBool("bool_tag_on_side_armor", false) then
						local col = ply:HudValue("AR", "BA")
						YRPDrawNamePlayerInfo(ply, ply:Armor() .. "/" .. ply:GetYRPInt("MaxArmor", 100), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["ar"], ply:Armor(), ply:GetYRPInt("MaxArmor", ""), Color(col.r, col.g, col.b, 200))
						_z = _z + _d
					end

					if LocalPlayer():HasAccess("YRPDrawNamePlates") then
						local col = ply:HudValue("ST", "BA")
						YRPDrawNamePlayerInfo(ply, ply:GetYRPFloat("GetCurStamina", 0.0) .. "/" .. ply:GetYRPFloat("GetMaxStamina", 1.0), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["ms"], ply:GetYRPFloat("GetCurStamina", 0.0), ply:GetYRPFloat("GetMaxStamina", ""), Color(col.r, col.g, col.b, _alpha))
						_z = _z + _d
						YRPDrawNamePlayerInfo(ply, ply:SteamName(), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["sn"])
						_z = _z + _d
						local ugcolor = ply:GetUserGroupColor()
						YRPDrawNamePlayerInfo(ply, string.upper(ply:GetUserGroupNice()), _x, _y, _z, _w, _h, Color(ugcolor.r, ugcolor.g, ugcolor.b, _alpha), _alpha, _icons["ug"])
						_z = _z + _d
						YRPDrawNamePlayerInfo(ply, "+" .. GetGlobalYRPString("text_money_pre", "") .. ply:GetYRPString("salary", "") .. GetGlobalYRPString("text_money_pos", ""), _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["sa"])
						_z = _z + _d
						local _motext = GetGlobalYRPString("text_money_pre", "") .. ply:GetYRPString("money", "") .. GetGlobalYRPString("text_money_pos", "")
						local _mMin = ply:CurrentSalaryTime()
						local _mMax = ply:GetYRPInt("salarytime", 0) + 1
						YRPDrawNamePlayerInfo(ply, _motext, _x, _y, _z, _w, _h, Color(0, 0, 0, _alpha), _alpha, _icons["mo"], _mMin, _mMax, Color(33, 108, 42, _alpha))
						_z = _z + _d
					end
				end
			end

			ply:drawPlayerInfo()
			ply:drawWantedInfo()
		end

		if delay < CurTime() then
			delay = CurTime() + 0.3
			symc = math.Clamp(symc + 1, 0, 3)
			if symc == 3 then
				symc = 0
			end
		end
	end
end

hook.Add("PostDrawTranslucentRenderables", "yrp_draw_plates", YRPDrawNamePlates)
function draw3DText(text, x, y, color)
	color = color or Color(255, 255, 255, 255)
	surface.SetTextColor(color)
	surface.SetFont("Y_" .. 24 .. "_500")
	local tw, _ = surface.GetTextSize(text)
	surface.SetTextPos(x - tw / 2, y)
	surface.DrawText(text)
end

hook.Add(
	"PostDrawOpaqueRenderables",
	"yrp_npc_tags",
	function()
		for i, ent in pairs(ents.GetAll()) do
			if LocalPlayer() and ent and ent:IsNPC() and not ent:IsPlayer() and ent:IsDealer() then
				local dist = LocalPlayer():GetPos():Distance(ent:GetPos())
				if dist < 300 then
					YRPDrawNamePlateStringBox(ent, ent:GetYRPString("name", "Unnamed"), 20, Color(255, 255, 255, 255))
				end
			end
		end
	end
)

net.Receive(
	"nws_yrp_whitelist_infoplayer",
	function(len)
		local msg = net.ReadString()
		notification.AddLegacy(YRP:trans(msg), NOTIFY_GENERIC, 6)
	end
)

net.Receive(
	"nws_yrp_noti",
	function(len)
		local lply = LocalPlayer()
		if lply:IsValid() and lply:HasAccess("nws_yrp_noti") then
			local _str_lang = net.ReadString()
			local _time = 4
			local _channel = NOTIFY_GENERIC
			local _str = "[" .. YRP:trans("LID_adminnotification") .. "] "
			if _str_lang == "noreleasepoint" then
				_str = _str .. YRP:trans("LID_" .. _str_lang)
			elseif _str_lang == "nojailpoint" then
				_str = _str .. YRP:trans("LID_" .. _str_lang)
			elseif _str_lang == "nogroupspawn" then
				_str = _str .. "[" .. string.upper(net.ReadString()) .. "]" .. " " .. YRP:trans("LID_" .. _str_lang) .. "!"
			elseif _str_lang == "inventoryclearing" then
				_str = _str .. YRP:trans("LID_" .. _str_lang) .. " ( " .. YRP:trans(net.ReadString()) .. " )"
			elseif _str_lang == "playerisready" then
				local name = {}
				name["NAME"] = net.ReadString()
				_str = _str .. YRP:trans("LID_hasfinishedloading", name)
			elseif _str_lang == "newfeedback" then
				_str = _str .. "New TICKET!"
				_time = 10
			elseif _str_lang == "database_full_server" then
				_str = _str .. "SERVER: Database or disk is full, please make more space!"
				_time = 40
				_channel = NOTIFY_ERROR
			end

			notification.AddLegacy(_str, _channel, _time)
		end
	end
)

function YRPReplaceLIDs(str)
	local tmpstr = string.Explode(" ", str)
	for i, v in pairs(tmpstr) do
		if string.StartWith(string.lower(v), "lid_") then
			tmpstr[i] = YRP:trans(v)
		end
	end

	return table.concat(tmpstr, " ")
end

function YRPReplaceKEYs(str)
	local tmpstr = string.Explode(" ", str)
	for i, v in pairs(tmpstr) do
		if string.StartWith(string.lower(v), "menu_") then
			tmpstr[i] = YRPGetKeybindName(YRPGetKeybind(v))
		end
	end

	return table.concat(tmpstr, " ")
end

local dela = 0
net.Receive(
	"nws_yrp_info",
	function(len)
		local lply = LocalPlayer()
		if lply:IsValid() and dela < CurTime() then
			delay = CurTime() + 1
			local _str = net.ReadString()
			_str = YRPReplaceLIDs(_str)
			_str = YRPReplaceKEYs(_str)
			_str = YRP:trans("LID_notallowed") .. " (" .. YRP:trans(_str) .. ")"
			notification.AddLegacy(_str, NOTIFY_GENERIC, 6)
		end
	end
)

local delay2 = 0
net.Receive(
	"nws_yrp_info2",
	function(len)
		local lply = LocalPlayer()
		if lply:IsValid() and delay2 < CurTime() then
			delay2 = CurTime() + 1
			local _str = net.ReadString()
			_str = YRP:trans(_str)
			local _str2 = net.ReadString()
			if _str2 ~= nil then
				_str2 = " " .. YRP:trans(_str2)
			else
				_str2 = ""
			end

			notification.AddLegacy(_str .. _str2, NOTIFY_GENERIC, 3)
		end
	end
)

local delay3 = 0
net.Receive(
	"nws_yrp_info3",
	function(len)
		local lply = LocalPlayer()
		if lply:IsValid() and delay3 < CurTime() then
			delay3 = CurTime() + 1
			local _str = net.ReadString()
			_str = YRP:trans(_str)
			notification.AddLegacy(_str, NOTIFY_GENERIC, 10)
		end
	end
)

net.Receive(
	"nws_yrp_message",
	function(len)
		local lply = LocalPlayer()
		if lply:IsValid() then
			local _str = YRP:trans(net.ReadString())
			notification.AddLegacy(_str, NOTIFY_GENERIC, 3)
		end
	end
)

net.Receive(
	"nws_yrp_notification",
	function(len)
		local lply = LocalPlayer()
		if IsValid(lply) then
			local msg = net.ReadString()
			notification.AddLegacy(msg, NOTIFY_GENERIC, 5)
		end
	end
)

net.Receive(
	"nws_yrp_autoreload",
	function(len, ply)
		local t = net.ReadString()
		local str = YRP:trans("LID_automaticmapchangeinx") .. " (to prevent Lags/Stutter after 6/12 Hours)."
		str = string.Replace(str, "X", t)
		notification.AddLegacy(str, NOTIFY_GENERIC, 1)
	end
)

function DrawDoorText(door)
	local sl = door:SecurityLevel()
	if sl > 0 and GetGlobalYRPBool("bool_securitylevel_system", false) and GetGlobalYRPBool("bool_show_securitylevel", true) then
		local int_securitylevel = YRP:trans("LID_securitylevel") .. ": " .. sl
		surface.SetFont("Y_24_500")
		local secu_size = surface.GetTextSize(int_securitylevel)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.SetTextPos(-secu_size / 2, -20)
		surface.DrawText(int_securitylevel)
	else
		if door:GetYRPBool("bool_hasowner", false) then
			local header = door:GetYRPString("text_header", "")
			surface.SetFont("Y_24_500")
			local head_size = surface.GetTextSize(header)
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetTextPos(-head_size / 2, -80)
			surface.DrawText(header)
			local description = door:GetYRPString("text_description", "")
			surface.SetFont("Y_14_500")
			local desc_size = surface.GetTextSize(description)
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetTextPos(-desc_size / 2, -50)
			surface.DrawText(description)
		else
			local buildingprice = formatMoney(door:GetYRPString("buildingprice", ""))
			surface.SetFont("Y_24_500")
			local head_size = surface.GetTextSize(buildingprice)
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetTextPos(-head_size / 2, -80)
			surface.DrawText(buildingprice)
			local name = door:GetYRPString("name", "")
			surface.SetFont("Y_14_500")
			local desc_size = surface.GetTextSize(name)
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetTextPos(-desc_size / 2, -50)
			surface.DrawText(name)
		end
	end
end

local loadattempts = 0
function loadDoorTexts()
	loadattempts = loadattempts + 1
	if GetGlobalYRPBool("loaded_doors", false) and (table.Count(ents.FindByClass("prop_door_rotating")) > 0 or table.Count(ents.FindByClass("func_door")) > 0 or table.Count(ents.FindByClass("func_door_rotating")) > 0) then
		hook.Add(
			"PostDrawOpaqueRenderables",
			"yrp_door_info",
			function()
				local DOORS = GetAllDoors()
				if GetGlobalYRPBool("bool_building_system", false) and GetGlobalYRPBool("bool_building_system_3d", false) then
					for i, door in pairs(DOORS) do
						if door ~= nil and door ~= NULL and LocalPlayer():GetPos():Distance(door:GetPos()) < 500 then
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

							--render.DrawSphere(pos, 10, 8, 8, Color( 0, 255, 0 ) )
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
				end
			end
		)

		YRP:msg("gm", "loaded door texts")
	elseif loadattempts < 10 then
		timer.Simple(
			2,
			function()
				loadDoorTexts()
			end
		)
	end
end

timer.Simple(
	5,
	function()
		loadDoorTexts()
	end
)

net.Receive(
	"nws_yrp_loaded_doors",
	function()
		timer.Simple(
			5,
			function()
				loadDoorTexts()
			end
		)
	end
)

local logos = {}
local mats = {}
function YRPDrawIDCard(ply, scale, px, py)
	px = px or 0
	py = py or 0
	if scale == nil then
		scale = 1
	end

	local elements = {"background", "box1", "box2", "box3", "box4", "box5", "serverlogo", "box6", "box7", "box8", "hostname", "role", "group", "idcardid", "faction", "rpname", "securitylevel", "birthday", "bodyheight", "weight"}
	--"grouplogo",
	for i, ele in pairs(elements) do
		if GetGlobalYRPBool("bool_" .. ele .. "_visible", false) then
			local w = GetGlobalYRPInt("int_" .. ele .. "_w", 100)
			local h = GetGlobalYRPInt("int_" .. ele .. "_h", 100)
			local x = GetGlobalYRPInt("int_" .. ele .. "_x", 0)
			local y = GetGlobalYRPInt("int_" .. ele .. "_y", 0)
			local color = {}
			color.r = GetGlobalYRPInt("int_" .. ele .. "_r", 0)
			color.g = GetGlobalYRPInt("int_" .. ele .. "_g", 0)
			color.b = GetGlobalYRPInt("int_" .. ele .. "_b", 0)
			color.a = GetGlobalYRPInt("int_" .. ele .. "_a", 0)
			local colortype = GetGlobalYRPInt("int_" .. ele .. "_colortype", 0)
			if colortype == 2 then
				color = ply:GetFactionColor()
			elseif colortype == 3 then
				color = ply:GetGroupColor()
			elseif colortype == 4 then
				color = ply:GetRoleColor()
			elseif colortype == 5 then
				color = ply:GetUserGroupColor()
			end

			local ax = GetGlobalYRPInt("int_" .. ele .. "_ax", 0)
			local ay = GetGlobalYRPInt("int_" .. ele .. "_ay", 0)
			x = x * scale
			y = y * scale
			w = w * scale
			h = h * scale
			x = x + px
			y = y + py
			if not string.find(ele, "logo", 1, true) and not string.find(ele, "background", 1, true) then
				if string.find(ele, "box", 1, true) then
					draw.RoundedBox(0, x, y, w, h, color)
				else
					local text = ""
					if ele == "hostname" then
						text = GetGlobalYRPString("text_server_name", "")
					elseif ele == "role" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_role") .. ": "
						end

						text = text .. ply:GetRoleName()
					elseif ele == "rpname" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_name") .. ": "
						end

						text = text .. ply:RPName()
					elseif ele == "securitylevel" then
						text = YRP:trans("LID_" .. ele) .. " " .. ply:SecurityLevel()
					elseif ele == "faction" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_faction") .. ": "
						end

						text = text .. ply:GetFactionName()
					elseif ele == "group" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_group") .. ": "
						end

						text = text .. ply:GetGroupName()
					elseif ele == "idcardid" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_id") .. ": "
						end

						text = text .. ply:GetYRPString("idcardid", "")
					elseif ele == "birthday" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_birthday") .. ": "
						end

						text = text .. ply:GetYRPString("string_birthday", "")
					elseif ele == "bodyheight" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_bodyheight") .. ": "
						end

						text = text .. tostring(ply:GetYRPInt("int_bodyheight", 0))
					elseif ele == "weight" then
						if GetGlobalYRPBool("bool_" .. ele .. "_title", false) then
							text = YRP:trans("LID_weight") .. ": "
						end

						text = text .. tostring(ply:GetYRPInt("int_weight", 0))
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
				if string.find(ele, "background", 1, true) and strEmpty(GetGlobalYRPString("text_idcard_background", "")) then
					draw.RoundedBox(0, x, y, w, h, color)
				end

				if logos[ele] == nil then
					logos[ele] = true
					local test = YRPCreateD("DHTML", nil, w, h, 0, 0)
					if string.find(ele, "logo", 1, true) then
						test:SetHTML(YRPGetHTMLImage(GetGlobalYRPString("text_server_logo", ""), w, h))
					else
						test:SetHTML(YRPGetHTMLImage(GetGlobalYRPString("text_idcard_background", ""), w, h))
					end

					function test:Paint(pw, ph)
						if YRPPanelAlive(test, "test") then
							test.mat = test:GetHTMLMaterial()
							if test.mat ~= nil and not test.found then
								test.found = true
								timer.Simple(
									1.0,
									function()
										test.matname = test.mat:GetName()
										local matdata = {
											["$basetexture"] = test.matname,
											["$model"] = 1,
											["$translucent"] = 1,
											["$vertexalpha"] = 1,
											["$vertexcolor"] = 1
										}

										local uid = string.Replace(test.matname, "__vgui_texture_", "")
										mats[ele] = CreateMaterial("WebMaterial_" .. uid, "UnlitGeneric", matdata)
										test:Remove()
									end
								)
							end
						end
					end
				end

				if mats[ele] ~= nil then
					surface.SetDrawColor(color)
					surface.SetMaterial(mats[ele])
					surface.DrawTexturedRect(x, y, w, h)
				end
			end
		end
	end
end

local customDeathscreen = false
function YRPCustomDeathscreen(b)
	customDeathscreen = b
end

-- #DEATHSCREEN, #RESPAWNING, #CHANGECHARACTER
local dsd = CurTime() + 2
local ds = ds or false
hook.Add(
	"Think",
	"openDeathScreen",
	function(len)
		if LocalPlayer() == NULL then return end
		if not YRP_LogOut and LocalPlayer():LoadedGamemode() and not LocalPlayer():Alive() and not vgui.CursorVisible() and dsd < CurTime() and LocalPlayer():CharID() > 0 and not ds and GetGlobalYRPBool("bool_deathscreen", false) and not customDeathscreen then
			ds = true
			local win = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
			win:SetTitle("")
			--win:MakePopup() -- chat not work in deathscreen if popup
			--gui.EnableScreenClicker(true)
			win:Center()
			win:SetDraggable(false)
			win:ShowCloseButton(false)
			win.systime = SysTime()
			function win:Paint(pw, ph)
				self.a = self.a or 0
				self.a = math.Clamp(self.a + 0.02, 0, 1)
				if LocalPlayer():Alive() or LocalPlayer():CharID() <= 0 then
					ds = false
					self:Remove()
					gui.EnableScreenClicker(false)
				end

				Derma_DrawBackgroundBlur(self, self.systime)
				draw.RoundedBox(0, 0, YRP:ctr(300), pw, YRP:ctr(500), Color(0, 0, 0, 180 * self.a))
				if not vgui.CursorVisible() then
					draw.SimpleText(YRP:trans("LID_rightclicktoshowmouse"), "Y_40_500", pw - 100, ph - 100, Color(255, 255, 100, 255 * self.a), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				end

				if LocalPlayer():GetYRPInt("int_deathtimestamp_max", 0) <= CurTime() then
					draw.SimpleText(string.upper(YRP:trans("LID_youdied")), "Y_100_500", pw / 2, YRP:ctr(300 + 500 / 2), Color(255, 100, 100, 255 * self.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(YRP:trans("LID_youreunconsious") .. ".", "Y_50_500", pw / 2, YRP:ctr(300 + 500 / 3), Color(255, 100, 100, 255 * self.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					local tab = {}
					tab["X"] = math.Round(LocalPlayer():GetYRPInt("int_deathtimestamp_max", 0) - CurTime(), 0)
					draw.SimpleText(YRP:trans("LID_youredeadinxseconds", tab) .. ".", "Y_30_500", pw / 2, YRP:ctr(300 + 500 * 2 / 3), Color(255, 100, 100, 255 * self.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				if input.IsMouseDown(MOUSE_FIRST) or input.IsMouseDown(MOUSE_RIGHT) then
					gui.EnableScreenClicker(true)
				end
			end

			win.respawn = YRPCreateD("YButton", win, YRP:ctr(600), YRP:ctr(100), ScrW2() - YRP:ctr(600 / 2), ScrH() - YRP:ctr(400))
			win.respawn:SetText("LID_respawnnow")
			function win.respawn:DoClick()
				if LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() and not LocalPlayer():GetYRPBool("yrp_chararchived", false) then
					net.Start("YRPResetCharLoadout")
					net.SendToServer()
					net.Start("nws_yrp_EnterWorld")
					net.WriteString(LocalPlayer():CharID())
					net.SendToServer()
					ds = false
					win:Close()
					gui.EnableScreenClicker(false)
					dsd = CurTime() + 1
				end
			end

			function win.respawn:Paint(pw, ph)
				if not LocalPlayer():GetYRPBool("yrp_chararchived", false) then
					local tab = {}
					tab.color = Color(56, 118, 29, 255)
					tab.tcolor = Color(255, 255, 255, 255)
					if LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) <= CurTime() then
						hook.Run("YButtonPaint", self, pw, ph, tab)
					else
						tab.text = math.Round(LocalPlayer():GetYRPInt("int_deathtimestamp_min", 0) - CurTime(), 0)
						hook.Run("YButtonPaint", self, pw, ph, tab)
					end
				end
			end

			win.changecharacter = YRPCreateD("YButton", win, YRP:ctr(600), YRP:ctr(100), ScrW2() - YRP:ctr(600 / 2), ScrH() - YRP:ctr(250))
			win.changecharacter:SetText("LID_changecharacter")
			function win.changecharacter:DoClick()
				ds = false
				win:Close()
				net.Start("YRPResetCharLoadout")
				net.SendToServer()
				gui.EnableScreenClicker(false)
				YRPOpenCharacterSelection()
				dsd = CurTime() + 1
			end

			function win.changecharacter:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end
		elseif LocalPlayer():Alive() then
			dsd = CurTime() + 2
		end
	end
)

function YRPCPP(a)
	return Color(43, 61, 79, a)
end

function YRPCPL(a)
	return Color(85, 103, 123, a)
end

function YRPCPD(a)
	return Color(2, 23, 39, a)
end

local windowOpen = false
net.Receive(
	"nws_yrp_openLawBoard",
	function(len)
		if not windowOpen and (LocalPlayer():isCP() or LocalPlayer():GetYRPBool("bool_canusewarnsystem", false)) then
			local tmpJailList = net.ReadTable()
			windowOpen = true
			local window = YRPCreateD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
			window:SetHeaderHeight(YRP:ctr(100))
			window:SetTitle("LID_jail")
			window:Center()
			function window:OnClose()
				window:Remove()
				YRPCloseMenu()
			end

			function window:OnRemove()
				windowOpen = false
				YRPCloseMenu()
			end

			function window:Paint(pw, ph)
				hook.Run("YFramePaint", self, pw, ph)
			end

			window.tabs = YRPCreateD("YTabs", window:GetContent(), window:GetContent():GetWide(), window:GetContent():GetTall(), 0, 0)
			window.tabs:AddOption(
				"LID_prisoners",
				function(parent)
					local scrollpanel = YRPCreateD("DScrollPanel", parent, parent:GetWide() - YRP:ctr(40), parent:GetTall() - YRP:ctr(90), YRP:ctr(20), YRP:ctr(90))
					function scrollpanel:Paint(pw, ph)
					end

					--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 255, 255, 100) )
					scrollpanel.selected = 0
					scrollpanel.p = nil
					-- ADD
					local adYButton = YRPCreateD("YButton", parent, YRP:ctr(50), YRP:ctr(50), YRP:ctr(20), YRP:ctr(20))
					adYButton:SetText("+")
					function adYButton:DoClick()
						local _SteamID = nil
						local _nick = ""
						local _Cell = nil
						local addWindow = createVGUI("YFrame", nil, 800, 820, 0, 0)
						addWindow:SetHeaderHeight(YRP:ctr(100))
						addWindow:SetTitle("LID_add")
						addWindow:Center()
						function addWindow:Paint(pw, ph)
							hook.Run("YFramePaint", self, pw, ph)
						end

						local content = addWindow:GetContent()
						function content:Paint(pw, ph)
							draw.SimpleTextOutlined(YRP:trans("LID_player"), "Y_24_500", YRP:ctr(10), YRP:ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
							draw.SimpleTextOutlined(YRP:trans("LID_cell"), "Y_24_500", YRP:ctr(10), YRP:ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
							draw.SimpleTextOutlined(YRP:trans("LID_note"), "Y_24_500", YRP:ctr(10), YRP:ctr(250), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
							draw.SimpleTextOutlined(YRP:trans("LID_timeinsec"), "Y_24_500", YRP:ctr(10), YRP:ctr(350), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 255))
						end

						local _player = createVGUI("DComboBox", addWindow:GetContent(), 380, 50, 10, 50)
						for k, v in pairs(player.GetAll()) do
							_player:AddChoice(v:RPName(), v:YRPSteamID())
						end

						function _player:OnSelect(index, value, data)
							_SteamID = data
							_nick = value
						end

						local _cell = createVGUI("DComboBox", addWindow:GetContent(), 380, 50, 10, 150)
						for k, v in pairs(GetGlobalYRPTable("yrp_jailpoints")) do
							_cell:AddChoice(v.name, v.uniqueID)
						end

						function _cell:OnSelect(index, value, data)
							_Cell = data
						end

						local _reason = createVGUI("DTextEntry", addWindow:GetContent(), 380, 50, 10, 250)
						local _time = createVGUI("DNumberWang", addWindow:GetContent(), 380, 50, 10, 350)
						local _add = createVGUI("YButton", addWindow:GetContent(), 380, 50, 10, 420)
						_add:SetText("LID_add")
						function _add:DoClick()
							if _SteamID ~= nil and _Cell ~= nil then
								local _insert = "'" .. _SteamID .. "', '" .. _reason:GetText() .. "', " .. db_int(_time:GetValue()) .. ", '" .. _nick .. "', '" .. _Cell .. "'"
								net.Start("nws_yrp_dbAddJail")
								net.WriteString("yrp_jail")
								net.WriteString("SteamID, reason, time, nick, cell")
								net.WriteString(_insert)
								net.WriteString(_SteamID)
								net.SendToServer()
								net.Start("nws_yrp_addJailNote")
								net.WriteString(_SteamID)
								net.WriteString(_reason:GetText())
								net.SendToServer()
							end
						end

						window:Close()
						addWindow:MakePopup()
					end

					function adYButton:Paint(pw, ph)
						local tab = {}
						tab.color = Color(100, 255, 100)
						hook.Run("YButtonPaint", self, pw, ph, tab)
					end

					-- REMOVE
					local remBtn = YRPCreateD("YButton", parent, YRP:ctr(50), YRP:ctr(50), YRP:ctr(90), YRP:ctr(20))
					remBtn:SetText("-")
					function remBtn:DoClick()
						if scrollpanel.selected > 0 then
							net.Start("nws_yrp_dbRemJail")
							net.WriteString(scrollpanel.selected)
							net.SendToServer()
							scrollpanel.items[scrollpanel.selected]:Remove()
							scrollpanel.selected = 0
						end
					end

					function remBtn:Paint(pw, ph)
						if scrollpanel.selected > 0 then
							local tab = {}
							tab.color = Color(255, 100, 100)
							hook.Run("YButtonPaint", self, pw, ph, tab)
						end
					end

					-- JAIL
					local jailBtn = YRPCreateD("YButton", parent, YRP:ctr(200), YRP:ctr(50), YRP:ctr(160), YRP:ctr(20))
					jailBtn:SetText("LID_jail")
					function jailBtn:DoClick()
						if scrollpanel.selected > 0 then
							local target = nil
							for i, p in pairs(player.GetAll()) do
								if p:YRPSteamID() == scrollpanel.p.SteamID then
									target = p
									break
								end
							end

							if target ~= nil then
								net.Start("nws_yrp_jail")
								net.WriteEntity(target)
								net.SendToServer()
							end
						end
					end

					function jailBtn:Paint(pw, ph)
						if scrollpanel.selected > 0 then
							local tab = {}
							tab.color = Color(255, 100, 100)
							hook.Run("YButtonPaint", self, pw, ph, tab)
						end
					end

					-- UNJAIL
					local unjailBtn = YRPCreateD("YButton", parent, YRP:ctr(200), YRP:ctr(50), YRP:ctr(380), YRP:ctr(20))
					unjailBtn:SetText("LID_unjail")
					function unjailBtn:DoClick()
						if scrollpanel.selected > 0 then
							local target = nil
							for i, p in pairs(player.GetAll()) do
								if p:YRPSteamID() == scrollpanel.p.SteamID then
									target = p
									break
								end
							end

							if target ~= nil then
								net.Start("nws_yrp_unjail")
								net.WriteEntity(target)
								net.SendToServer()
								window:Close()
							end
						end
					end

					function unjailBtn:Paint(pw, ph)
						if scrollpanel.selected > 0 then
							local tab = {}
							tab.color = Color(100, 255, 100)
							hook.Run("YButtonPaint", self, pw, ph, tab)
						end
					end

					local _x = 0
					local _y = 0
					local s = {}
					s.w = 800
					s.h = 400
					for k, v in pairs(tmpJailList) do
						v.uniqueID = tonumber(v.uniqueID)
						local dpanel = createVGUI("YButton", scrollpanel, s.w, s.h, 0, 0)
						dpanel.uniqueID = v.uniqueID
						dpanel:SetText("")
						dpanel.sp = scrollpanel
						dpanel:SetPos(_x * YRP:ctr(s.w + 20), _y * YRP:ctr(s.h + 20))
						function dpanel:DoClick()
							self.sp.p = v
							self.sp.selected = v.uniqueID
						end

						function dpanel:Paint(pw, ph)
							local color = Color(100, 100, 255, 100)
							if scrollpanel.selected == v.uniqueID then
								color = Color(255, 255, 100, 100)
							end

							draw.RoundedBox(0, 0, 0, pw, ph, color)
							draw.SimpleTextOutlined(YRP:trans("LID_name") .. ": " .. v.nick, "Y_26_500", YRP:ctr(20), YRP:ctr(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							draw.SimpleTextOutlined(YRP:trans("LID_cell") .. ": " .. v.cellname, "Y_24_500", YRP:ctr(20), YRP:ctr(95), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							draw.SimpleTextOutlined(YRP:trans("LID_note") .. ": " .. v.reason, "Y_24_500", YRP:ctr(20), YRP:ctr(145), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							draw.SimpleTextOutlined(YRP:trans("LID_time") .. ": " .. v.time, "Y_24_500", YRP:ctr(20), ph - YRP:ctr(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end

						local model = ""
						for j, p in pairs(player.GetAll()) do
							if p:YRPSteamID() == v.SteamID then
								model = p:GetModel()
							end
						end

						if not strEmpty(model) then
							local dmodelpanel = YRPCreateD("DModelPanel", dpanel, dpanel:GetTall() - YRP:ctr(20), dpanel:GetTall() - YRP:ctr(20), dpanel:GetWide() - (dpanel:GetTall() - YRP:ctr(20)), YRP:ctr(10))
							dmodelpanel:SetModel(model)
						end

						scrollpanel:AddItem(dpanel)
						scrollpanel.items = scrollpanel.items or {}
						scrollpanel.items[v.uniqueID] = dpanel
						_x = _x + 1
						if (_x - 1) * s.w >= window:GetContent():GetWide() then
							_y = _y + 1
							_x = 0
						end
					end
				end
			)

			window.tabs:AddOption(
				"LID_records",
				function(parent)
					-- PlayerListHeader
					local p = YRPCreateD("YLabel", parent, YRP:ctr(800), YRP:ctr(50), YRP:ctr(20), YRP:ctr(20))
					p:SetText(YRP:trans("LID_players"))
					-- PlayerList
					local plist = YRPCreateD("DScrollPanel", parent, p:GetWide(), YRP:ctr(800), YRP:ctr(20), YRP:ctr(20 + 50))
					function plist:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))
					end

					plist.btn = 0
					plist.ply = NULL
					-- RIGHT
					plist.notes = YRPCreateD("YPanel", parent, YRP:ctr(1000), YRP:ctr(1000), YRP:ctr(20 + 800 + 20), YRP:ctr(20))
					plist.notes.curnote = 0
					function plist.notes:Paint(pw, ph)
					end

					function plist.notes:UpdatePlayerNotes()
						self:Clear()
						self.addNote = YRPCreateD("YButton", self, YRP:ctr(50), YRP:ctr(50), YRP:ctr(0), YRP:ctr(0))
						self.addNote:SetText("+")
						function self.addNote:Paint(pw, ph)
							local tab = {}
							tab.color = Color(100, 255, 100)
							hook.Run("YButtonPaint", self, pw, ph, tab)
						end

						function self.addNote:DoClick()
							local win = YRPCreateD("YFrame", nil, YRP:ctr(400), YRP:ctr(400), 0, 0)
							win:SetTitle("")
							win:SetHeaderHeight(YRP:ctr(100))
							win:Center()
							win:MakePopup()
							local content = win:GetContent()
							win.text = YRPCreateD("DTextEntry", content, content:GetWide(), YRP:ctr(50), 0, 0)
							win.send = YRPCreateD("YButton", content, content:GetWide(), YRP:ctr(50), 0, YRP:ctr(50))
							win.send:SetText("LID_send")
							function win.send:DoClick()
								if IsValid(plist.ply) and win.text then
									net.Start("nws_yrp_addJailNote")
									net.WriteString(plist.ply:YRPSteamID())
									net.WriteString(win.text:GetText())
									net.SendToServer()
								end

								plist.notes:UpdatePlayerNotes()
								win:Close()
							end
						end

						self.remNote = YRPCreateD("YButton", self, YRP:ctr(50), YRP:ctr(50), self:GetWide() - YRP:ctr(50), YRP:ctr(0))
						self.remNote:SetText("-")
						function self.remNote:Paint(pw, ph)
							if plist.notes.curnote > 0 then
								local tab = {}
								tab.color = Color(255, 100, 100)
								hook.Run("YButtonPaint", self, pw, ph, tab)
							end
						end

						function self.remNote:DoClick()
							if plist.notes.curnote > 0 then
								net.Start("nws_yrp_removeJailNote")
								net.WriteString(plist.notes.curnote)
								net.SendToServer()
								plist.notes:UpdatePlayerNotes()
							end
						end

						self.nlist = YRPCreateD("DScrollPanel", self, self:GetWide(), self:GetTall() - YRP:ctr(50), 0, YRP:ctr(50))
						function self.nlist:Paint(pw, ph)
						end

						--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 40, 40, 255) )
						net.Start("nws_yrp_getPlayerNotes")
						net.WriteEntity(plist.ply)
						net.SendToServer()
					end

					net.Receive(
						"nws_yrp_getPlayerNotes",
						function()
							local par = plist.notes
							local notes = net.ReadTable()
							if par then
								for i, note in pairs(notes) do
									note.uniqueID = tonumber(note.uniqueID)
									local n = YRPCreateD("YButton", par.nlist, par:GetWide(), YRP:ctr(50), 0, YRP:ctr(50) * (i - 1))
									n:SetText(note.note)
									function n:Paint(pw, ph)
										local tab = {}
										tab.color = Color(100, 100, 255, 255)
										if note.uniqueID == par.curnote then
											tab.color = Color(255, 255, 100, 255)
										end

										hook.Run("YButtonPaint", self, pw, ph, tab)
									end

									function n:DoClick()
										par.curnote = note.uniqueID
									end
								end
							end
						end
					)

					-- PlayerLines
					for i, v in pairs(player.GetAll()) do
						local pline = YRPCreateD("YButton", plist, p:GetWide(), YRP:ctr(50), 0, YRP:ctr(50) * (i - 1))
						pline:SetText(v:RPName())
						function pline:Paint(pw, ph)
							local color = Color(120, 120, 120, 255)
							if plist.btn == self then
								color = Color(255, 255, 100, 255)
							elseif self:IsHovered() then
								color = Color(255, 255, 255, 255)
							end

							draw.RoundedBox(0, 0, 0, pw, ph, color)
							draw.SimpleText(self:GetText(), "Y_18_500", YRP:ctr(20), ph / 2, Color(0, 0, 0, 255), 0, 1)
						end

						function pline:DoClick()
							plist.btn = self
							plist.ply = v
							plist.notes:UpdatePlayerNotes()
						end

						plist:Add(pline)
					end

					-- Playerinfo
					local pinfo = YRPCreateD("YPanel", parent, YRP:ctr(800), YRP:ctr(800), YRP:ctr(20), YRP:ctr(890))
					function pinfo:Paint(pw, ph)
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							local scale = self:GetWide() / GetGlobalYRPInt("int_" .. "background" .. "_w", 100)
							YRPDrawIDCard(plist.ply, scale, 0, 0)
						end
					end

					local btnVerwarnungUp = createVGUI("YButton", parent, 50, 50, 20, 1310)
					btnVerwarnungUp:SetText("⮝")
					function btnVerwarnungUp:DoClick()
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							net.Start("nws_yrp_warning_up")
							net.WriteEntity(plist.ply)
							net.SendToServer()
						end
					end

					local btnVerwarnungDn = createVGUI("YButton", parent, 50, 50, 20, 1360)
					btnVerwarnungDn:SetText("⮟")
					function btnVerwarnungDn:DoClick()
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							net.Start("nws_yrp_warning_dn")
							net.WriteEntity(plist.ply)
							net.SendToServer()
						end
					end

					local btnVerwarnung = createVGUI("YLabel", parent, 450, 100, 70, 1310)
					btnVerwarnung:SetText("")
					function btnVerwarnung:Paint(pw, ph)
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							hook.Run("YLabelPaint", self, pw, ph)
							btnVerwarnung:SetText(YRP:trans("LID_warnings") .. ": " .. plist.ply:GetYRPInt("int_warnings", -1))
						end
					end

					local btnVerstoesseUp = createVGUI("YButton", parent, 50, 50, 20, 1430)
					btnVerstoesseUp:SetText("⮝")
					function btnVerstoesseUp:DoClick()
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							net.Start("nws_yrp_violation_up")
							net.WriteEntity(plist.ply)
							net.SendToServer()
						end
					end

					local btnVerstoesseDn = createVGUI("YButton", parent, 50, 50, 20, 1480)
					btnVerstoesseDn:SetText("⮟")
					function btnVerstoesseDn:DoClick()
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							net.Start("nws_yrp_violation_dn")
							net.WriteEntity(plist.ply)
							net.SendToServer()
						end
					end

					local btnVerstoesse = createVGUI("YLabel", parent, 450, 100, 70, 1430)
					btnVerstoesse:SetText("")
					function btnVerstoesse:Paint(pw, ph)
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							hook.Run("YLabelPaint", self, pw, ph)
							btnVerstoesse:SetText(YRP:trans("LID_violations") .. ": " .. plist.ply:GetYRPInt("int_violations", -1))
						end
					end

					local btnArrests = createVGUI("YLabel", parent, 450, 100, 70, 1550)
					btnArrests:SetText("")
					function btnArrests:Paint(pw, ph)
						if IsValid(plist) and plist.ply and IsValid(plist.ply) and plist.ply:IsPlayer() then
							hook.Run("YLabelPaint", self, pw, ph)
							btnArrests:SetText(YRP:trans("LID_arrests") .. ": " .. plist.ply:GetYRPInt("int_arrests", -1))
						end
					end
				end
			)

			window.tabs:GoToSite("LID_prisoners")
			window:MakePopup()
		end
	end
)
