--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
local _la = {}

function ToggleLawsMenu()
	if isNoMenuOpen() then
		OpenLawsMenu()
	end
end

function CloseLawsMenu()
	if _la.window ~= nil then
		closeMenu()
		_la.window:Remove()
		_la.window = nil
	end
end

function OpenLawsMenu()
	openMenu()
	_la.window = createD("YFrame", nil, ctr(800), ctr(1200), 0, 0)
	_la.window:Center()
	_la.window:ShowCloseButton(true)
	_la.window:MakePopup()
	_la.window:SetTitle(YRP.lang_string("LID_laws"))
	_la.window:SetHeaderHeight(ctr(100))
	function _la.window:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end

	local lply = LocalPlayer()
	net.Receive("get_laws", function(len)
		local lawtab = net.ReadTable()
		local lawsymbol = lawtab.string_lawsymbol
		local laws = lawtab.string_laws

		if !lply:GetNWBool("bool_" .. "ismayor", false) then
			local laws = string.Explode(lawsymbol, laws)
			if _la.window:IsValid() then
				_la.dpl = createD("DPanelList", _la.window, ctr(760), ctr(1200 - 100 - 20 - 20), ctr(20), ctr(100 + 20))
				_la.dpl:SetSpacing(ctr(20))
				for i, law in pairs(laws) do
					if law != "" then
						if string.EndsWith(law, "\n") then
							law = string.sub(law, 1, string.len(law) - 1)
						end
						local lines = string.Explode("\n", law)
						lines = table.Count(lines)
						local l = createD("YLabel", nil, ctr(100), ctr(50) * lines, 0, 0)
						l:SetText(lawsymbol .. law)
						l:SetWrap(true)
						function l:Paint(pw, ph)
							local tab = {}
							tab.ax = 0
							hook.Run("YLabelPaint", self, pw, ph, tab)
						end

						_la.dpl:AddItem(l)
					end
				end
			end
		else
			_la.lawsymbolheader = createD("YLabel", _la.window, ctr(760), ctr(50), ctr(20), ctr(100 + 20))
			_la.lawsymbolheader:SetText(YRP.lang_string("LID_lawsymbol"))
			function _la.lawsymbolheader:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			_la.lawsymbol = createD("DTextEntry", _la.window, ctr(760), ctr(50), ctr(20), ctr(100 + 20 + 50))
			_la.lawsymbol:SetText(lawsymbol)
			function _la.lawsymbol:OnChange()
				net.Start("set_lawsymbol")
					net.WriteString(self:GetText())
				net.SendToServer()
			end



			_la.lawsheader = createD("YLabel", _la.window, ctr(760), ctr(50), ctr(20), ctr(100 + 20 + 50 + 50 + 20))
			_la.lawsheader:SetText(YRP.lang_string("LID_laws"))
			function _la.lawsheader:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			_la.laws = createD("DTextEntry", _la.window, ctr(760), ctr(1200 - 100 - 20 - 20 - 100 - 20 - 50), ctr(20), ctr(100 + 20 + 50 + 50 + 20 + 50))
			_la.laws:SetMultiline(true)
			_la.laws:SetText(laws)
			function _la.laws:OnChange()
				net.Start("set_laws")
					net.WriteString(self:GetText())
				net.SendToServer()
			end
		end
	end)

	net.Start("get_laws")
	net.SendToServer()
end
