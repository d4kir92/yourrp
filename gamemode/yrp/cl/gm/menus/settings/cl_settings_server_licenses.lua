--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local _li = {}
net.Receive("get_licenses", function()
	local _licenses = net.ReadTable()

	if settingsWindow.window != nil then

		local spw = settingsWindow.window.sitepanel:GetWide()
		local sph = settingsWindow.window.sitepanel:GetTall()

		_li.ea = createD("DPanel", settingsWindow.window.site, ScW() - YRP.ctr(40 + 480 + 40 + 40), sph - YRP.ctr(80), YRP.ctr(40 + 480 + 40), YRP.ctr(40)	)
		function _li.ea:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
		end

		_li._lic = createD("DYRPDBList", settingsWindow.window.site, YRP.ctr(480), YRP.ctr(500), YRP.ctr(40), YRP.ctr(40))
		_li._lic:SetListHeader("licenses")
		--_li._lic:SetDStrForAdd("license_add")
		_li._lic:SetEditArea(_li.ea)
		function _li.eaf(tbl)
			for i, child in pairs(_li.ea:GetChildren()) do
				child:Remove()
			end

			--[[ NAME ]]--
			_li.name = createD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, 0)
			_li.name.textentry.tbl = tbl
			_li.name:SetHeader(YRP.lang_string("LID_name"))
			_li.name:SetText(SQL_STR_OUT(tbl.name))
			function _li.name.textentry:OnChange()
				self.tbl.name = self:GetValue()
				net.Start("edit_license_name")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.name)
				net.SendToServer()
			end

			--[[ Description ]]--
			_li.desc = createD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(400), 0, YRP.ctr(150))
			_li.desc.textentry.tbl = tbl
			_li.desc:SetHeader(YRP.lang_string("LID_description"))
			_li.desc:SetText(SQL_STR_OUT(tbl.description))
			function _li.desc.textentry:OnChange()
				self.tbl.description = self:GetValue()
				net.Start("edit_license_description")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.description)
				net.SendToServer()
			end

			--[[ Price ]]--
			_li.price = createD("DYRPNumberWang", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, YRP.ctr(600))
			_li.price.numberwang.tbl = tbl
			_li.price:SetHeader(YRP.lang_string("LID_price"))
			_li.price:SetValue(SQL_STR_OUT(tbl.price))
			function _li.price.numberwang:OnChange()
				self.tbl.price = self:GetValue()
				net.Start("edit_license_price")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.price)
				net.SendToServer()
			end
		end
		_li._lic:SetEditFunc(_li.eaf)
		function _li._lic:AddFunction()
			net.Start("license_add")
			net.SendToServer()
		end
		function _li._lic:RemoveFunction()
			net.Start("license_rem")
				net.WriteString(self.uid)
			net.SendToServer()
		end
		for i, license in pairs(_licenses) do
			_li._lic:AddEntry(license)
		end
	end
end)

hook.Add("open_server_licenses", "open_server_licenses", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

	function settingsWindow.window.site:Paint(w, h)
		--
	end

	net.Start("get_licenses")
	net.SendToServer()
end)
