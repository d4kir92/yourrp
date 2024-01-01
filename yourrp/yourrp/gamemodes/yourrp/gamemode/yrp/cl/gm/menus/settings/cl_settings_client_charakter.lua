--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local save_delay = 0
net.Receive(
	"nws_yrp_getCharakterList",
	function()
		local _charTab = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			local cl_rpName = createVGUI("DTextEntry", PARENT, 800, 50, 10, 50)
			if _charTab.rpname ~= nil then
				cl_rpName:SetText(_charTab.rpname)
			end

			function cl_rpName:OnChange()
				if #self:GetText() > 32 then
					self:SetText(string.sub(self:GetText(), 0, 32))
				end
			end

			local cl_rpDescription = createVGUI("DTextEntry", PARENT, 1200, 400, 10, 200)
			cl_rpDescription:SetMultiline(true)
			if _charTab.rpdescription ~= nil then
				cl_rpDescription:SetText(_charTab.rpdescription)
			end

			function cl_rpDescription:OnChange()
			end

			local cl_save = createVGUI("YButton", PARENT, 400, 50, 10, 620)
			cl_save:SetText("LID_change")
			function cl_save:Paint(pw, ph)
				if CurTime() > save_delay then
					hook.Run("YButtonPaint", self, pw, ph)
				else
					draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
					draw.SimpleTextOutlined(YRP.trans("LID_cooldown"), "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				end
			end

			function cl_save:DoClick()
				if CurTime() > save_delay then
					save_delay = CurTime() + 4
					net.Start("nws_yrp_change_rpname")
					net.WriteString(cl_rpName:GetText())
					net.SendToServer()
					net.Start("nws_yrp_change_rpdescription")
					net.WriteString(cl_rpDescription:GetText())
					net.SendToServer()
				end
			end
		end
	end
)

hook.Add(
	"open_client_character",
	"open_client_character",
	function()
		if YRPPanelAlive(settingsWindow) then
			SaveLastSite()
		end
	end
)