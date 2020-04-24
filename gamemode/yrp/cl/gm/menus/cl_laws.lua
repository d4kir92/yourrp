--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
local _la = {}

function ToggleLawsMenu()
	if YRPIsNoMenuOpen() then
		OpenLawsMenu()
	end
end

function CloseLawsMenu()
	if _la.window != nil then
		closeMenu()
		_la.window:Remove()
		_la.window = nil
	end
end

function CreateLawsContent(PARENT)
	local lply = LocalPlayer()
	net.Receive("yrp_get_laws", function(len)
		local lawtab = net.ReadTable()
		local lawsymbol = tostring(lawtab.string_lawsymbol)
		local laws = lawtab.string_laws
		local lockdowntext = lawtab.string_lockdowntext
		local lockdown = tobool(lawtab.bool_lockdown)

		if !lply:GetDBool("bool_" .. "ismayor", false) then
			if PARENT:IsValid() then
				_la.laws = createD("RichText", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
				for i, v in pairs(string.Explode("\n", laws)) do
					_la.laws:AppendText(v .. "\n")
				end
			end
		else
			-- LAWS
			_la.lawsheader = createD("YLabel", PARENT, YRP.ctr(760), YRP.ctr(50), YRP.ctr(0), YRP.ctr(0))
			_la.lawsheader:SetText(YRP.lang_string("LID_laws"))
			function _la.lawsheader:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			_la.laws = createD("DTextEntry", PARENT, YRP.ctr(760), PARENT:GetTall() - YRP.ctr(50), YRP.ctr(0), YRP.ctr(50))
			_la.laws:SetMultiline(true)
			_la.laws:SetText("#" .. laws)
			function _la.laws:OnChange()
				net.Start("set_laws")
					net.WriteString(self:GetText())
				net.SendToServer()
			end



			-- LOCKDOWN
			_la.lockdownheader = createD("YLabel", PARENT, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(0))
			_la.lockdownheader:SetText(YRP.lang_string("LID_lockdowntext"))
			function _la.lockdownheader:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
			end

			_la.lockdowntext = createD("DTextEntry", PARENT, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(50))
			_la.lockdowntext:SetText("#" .. lockdowntext)
			function _la.lockdowntext:OnChange()
				net.Start("set_lockdowntext")
					net.WriteString(self:GetText())
				net.SendToServer()
			end

			_la.lockdowntoggle = createD("YButton", PARENT, YRP.ctr(760), YRP.ctr(50), YRP.ctr(800), YRP.ctr(120))
			_la.lockdowntoggle:SetPressed(lockdown)
			local ld_enabled = YRP.lang_string("LID_lockdown") .. " (" .. YRP.lang_string("LID_enabled") .. ")"
			local ld_disabled = YRP.lang_string("LID_lockdown") .. " (" .. YRP.lang_string("LID_disabled") .. ")"
			if lockdown then
				_la.lockdowntoggle:SetText(ld_enabled)
			else
				_la.lockdowntoggle:SetText(ld_disabled)
			end
			function _la.lockdowntoggle:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end
			function _la.lockdowntoggle:DoClick()
				lockdown = !self:IsPressed()
				self:SetPressed(lockdown)
				if lockdown then
					_la.lockdowntoggle:SetText(ld_enabled)
				else
					_la.lockdowntoggle:SetText(ld_disabled)
				end
				net.Start("set_lockdown")
					net.WriteBool(lockdown)
				net.SendToServer()
			end

			-- Lockdown Alarms
			local alarms = GetGlobalDTable("lockdown_alarms")
			local l_alarms = createD("DPanelList", PARENT, YRP.ctr(760), YRP.ctr(400), YRP.ctr(800), YRP.ctr(120 + 50 + 20))
			l_alarms:EnableVerticalScrollbar()
			l_alarms:SetSpacing(4)
			function l_alarms:Paint(pw, ph)
				--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
			end
			for i, e in pairs(alarms) do
				local line = createD("DPanel", nil, YRP.ctr(400), YRP.ctr(50), 0, 0)
				function line:Paint(pw, ph)
					--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0))
				end

				local a = createD("DCheckBox", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
				a:SetChecked(e.enabled)
				function a:OnChange( bVal )
					net.Start("update_lockdown_alarms")
						net.WriteString(e.name)
						net.WriteBool(bVal)
					net.SendToServer()
				end

				local label = createD("YLabel", line, YRP.ctr(700), YRP.ctr(50), YRP.ctr(60), 0)
				label:SetText(e.name)

				l_alarms:AddItem(line)
			end

			-- Buildings
			local buildings = net.ReadTable()
			if table.Count(buildings) > 0 then
				local l_buildings = createD("DPanelList", PARENT, YRP.ctr(760), YRP.ctr(400), YRP.ctr(800), YRP.ctr(120 + 50 + 20 + 400 + 20))
				l_buildings:EnableVerticalScrollbar()
				l_buildings:SetSpacing(4)
				function l_buildings:Paint(pw, ph)
					--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
				end

				for i, e in pairs(buildings) do
					local line = createD("DPanel", nil, YRP.ctr(400), YRP.ctr(50), 0, 0)
					function line:Paint(pw, ph)
						--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0))
					end

					local a = createD("DCheckBox", line, YRP.ctr(50), YRP.ctr(50), 0, 0)
					a:SetChecked(tobool(e.bool_lockdown))
					function a:OnChange( bVal )
						net.Start("update_lockdown_buildings")
							net.WriteString(e.uniqueID)
							net.WriteBool(bVal)
						net.SendToServer()
					end

					local label = createD("YLabel", line, YRP.ctr(700), YRP.ctr(50), YRP.ctr(60), 0)
					label:SetText(SQL_STR_OUT(e.name))

					l_buildings:AddItem(line)
				end
			end
		end
	end)

	net.Start("yrp_get_laws")
	net.SendToServer()
end

function OpenLawsMenu()
	openMenu()
	_la.window = createD("YFrame", nil, YRP.ctr(1600), YRP.ctr(1200), 0, 0)
	_la.window:Center()
	_la.window:MakePopup()
	_la.window:SetTitle(YRP.lang_string("LID_laws"))
	_la.window:SetHeaderHeight(YRP.ctr(100))
	function _la.window:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end
	_la.window:SetTitle(YRP.lang_string("LID_laws") .. " | " .. YRP.lang_string("LID_lockdown"))

	local content = _la.window:GetContent()

	CreateLawsContent(content)
end
