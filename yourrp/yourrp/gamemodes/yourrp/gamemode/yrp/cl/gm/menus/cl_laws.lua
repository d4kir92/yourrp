--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _la = {}
function YRPToggleLawsMenu()
	if YRPIsNoMenuOpen() then
		OpenLawsMenu()
	end
end

function CloseLawsMenu()
	if _la.window ~= nil then
		YRPCloseMenu()
		_la.window:Remove()
		_la.window = nil
	end
end

function CreateLawsContent(PARENT)
	if not YRPPanelAlive(PARENT, "PARENT 123") then return end
	local lply = LocalPlayer()
	net.Receive(
		"nws_yrp_get_laws",
		function(len)
			local lawtab = net.ReadTable()
			local laws = lawtab.string_laws
			local lockdowntext = lawtab.string_lockdowntext
			local lockdown = tobool(lawtab.bool_lockdown)
			if not YRPPanelAlive(PARENT, "PARENT 312") then return end
			if not lply:GetYRPBool("bool_" .. "ismayor", false) then
				if PARENT:IsValid() then
					_la.laws = YRPCreateD("RichText", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
					for i, v in pairs(string.Explode("\n", laws)) do
						_la.laws:AppendText(v .. "\n")
					end
				end
			else
				-- LAWS
				_la.lawsheader = YRPCreateD("YLabel", PARENT, YRP:ctr(760), YRP:ctr(50), YRP:ctr(0), YRP:ctr(0))
				_la.lawsheader:SetText(YRP:trans("LID_laws"))
				function _la.lawsheader:Paint(pw, ph)
					hook.Run("YLabelPaint", self, pw, ph)
				end

				_la.laws = YRPCreateD("DTextEntry", PARENT, YRP:ctr(760), PARENT:GetTall() - YRP:ctr(50), YRP:ctr(0), YRP:ctr(50))
				_la.laws:SetMultiline(true)
				_la.laws:SetText("#" .. laws)
				function _la.laws:OnChange()
					net.Start("nws_yrp_set_laws")
					net.WriteString(self:GetText())
					net.SendToServer()
				end

				-- LOCKDOWN
				_la.lockdownheader = YRPCreateD("YLabel", PARENT, YRP:ctr(760), YRP:ctr(50), YRP:ctr(800), YRP:ctr(0))
				_la.lockdownheader:SetText(YRP:trans("LID_lockdowntext"))
				function _la.lockdownheader:Paint(pw, ph)
					hook.Run("YLabelPaint", self, pw, ph)
				end

				_la.lockdowntext = YRPCreateD("DTextEntry", PARENT, YRP:ctr(760), YRP:ctr(50), YRP:ctr(800), YRP:ctr(50))
				_la.lockdowntext:SetText("#" .. lockdowntext)
				function _la.lockdowntext:OnChange()
					net.Start("nws_yrp_set_lockdowntext")
					net.WriteString(self:GetText())
					net.SendToServer()
				end

				_la.lockdowntoggle = YRPCreateD("YButton", PARENT, YRP:ctr(760), YRP:ctr(50), YRP:ctr(800), YRP:ctr(120))
				_la.lockdowntoggle:SetPressed(lockdown)
				local ld_enabled = YRP:trans("LID_lockdown") .. " ( " .. YRP:trans("LID_enabled") .. " )"
				local ld_disabled = YRP:trans("LID_lockdown") .. " ( " .. YRP:trans("LID_disabled") .. " )"
				if lockdown then
					_la.lockdowntoggle:SetText(ld_enabled)
				else
					_la.lockdowntoggle:SetText(ld_disabled)
				end

				function _la.lockdowntoggle:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end

				function _la.lockdowntoggle:DoClick()
					lockdown = not self:IsPressed()
					self:SetPressed(lockdown)
					if lockdown then
						_la.lockdowntoggle:SetText(ld_enabled)
					else
						_la.lockdowntoggle:SetText(ld_disabled)
					end

					net.Start("nws_yrp_set_lockdown")
					net.WriteBool(lockdown)
					net.SendToServer()
				end

				-- Lockdown Alarms
				local alarms = GetGlobalYRPTable("lockdown_alarms")
				local l_alarms = YRPCreateD("DPanelList", PARENT, YRP:ctr(760), YRP:ctr(400), YRP:ctr(800), YRP:ctr(120 + 50 + 20))
				l_alarms:EnableVerticalScrollbar()
				l_alarms:SetSpacing(4)
				function l_alarms:Paint(pw, ph)
				end

				--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
				for i, e in pairs(alarms) do
					local line = YRPCreateD("DPanel", nil, YRP:ctr(400), YRP:ctr(50), 0, 0)
					function line:Paint(pw, ph)
					end

					--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 0, 255 ) )
					local a = YRPCreateD("DCheckBox", line, YRP:ctr(50), YRP:ctr(50), 0, 0)
					a:SetChecked(e.enabled)
					function a:OnChange(bVal)
						net.Start("nws_yrp_update_lockdown_alarms")
						net.WriteString(e.name)
						net.WriteBool(bVal)
						net.SendToServer()
					end

					local label = YRPCreateD("YLabel", line, YRP:ctr(700), YRP:ctr(50), YRP:ctr(60), 0)
					label:SetText(e.name)
					l_alarms:AddItem(line)
				end

				-- Buildings
				local buildings = net.ReadTable()
				if table.Count(buildings) > 0 then
					local l_buildings = YRPCreateD("DPanelList", PARENT, YRP:ctr(760), YRP:ctr(400), YRP:ctr(800), YRP:ctr(120 + 50 + 20 + 400 + 20))
					l_buildings:EnableVerticalScrollbar()
					l_buildings:SetSpacing(4)
					function l_buildings:Paint(pw, ph)
					end

					--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
					for i, e in pairs(buildings) do
						local line = YRPCreateD("DPanel", nil, YRP:ctr(400), YRP:ctr(50), 0, 0)
						function line:Paint(pw, ph)
						end

						--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 0, 255 ) )
						local a = YRPCreateD("DCheckBox", line, YRP:ctr(50), YRP:ctr(50), 0, 0)
						a:SetChecked(tobool(e.bool_lockdown))
						function a:OnChange(bVal)
							net.Start("nws_yrp_update_lockdown_buildings")
							net.WriteString(e.uniqueID)
							net.WriteBool(bVal)
							net.SendToServer()
						end

						local label = YRPCreateD("YLabel", line, YRP:ctr(700), YRP:ctr(50), YRP:ctr(60), 0)
						label:SetText(e.name)
						l_buildings:AddItem(line)
					end
				end
			end
		end
	)

	net.Start("nws_yrp_get_laws")
	net.SendToServer()
end

function OpenLawsMenu()
	YRPOpenMenu()
	_la.window = YRPCreateD("YFrame", nil, YRP:ctr(1600), YRP:ctr(1200), 0, 0)
	_la.window:Center()
	_la.window:MakePopup()
	_la.window:SetTitle(YRP:trans("LID_laws"))
	_la.window:SetHeaderHeight(YRP:ctr(100))
	function _la.window:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end

	_la.window:SetTitle(YRP:trans("LID_laws") .. " | " .. YRP:trans("LID_lockdown"))
	local content = _la.window:GetContent()
	CreateLawsContent(content)
end
