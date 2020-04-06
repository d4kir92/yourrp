--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local pp = {}

net.Receive("get_perma_props", function(len, ply)
	pp.tab = net.ReadTable()

	if pa(pp.list) then
		local h = YRP.ctr(240)
		for i, v in SortedPairsByMemberValue(pp.tab, "model") do
			local line = createD("DPanel", nil, pp.list:GetWide(), h, 0, 0)
			function line:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(45, 45, 45, 100))

				draw.SimpleText(v.class, "DermaDefault", ph, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local mdl = createD("DModelPanel", line, h, h, 0, 0)
			mdl:SetModel(v.model)

			local rem = createD("YButton", line, YRP.ctr(240), h, line:GetWide() - YRP.ctr(240 + 36), 0)
			rem:SetText("LID_remove")
			rem.line = line
			rem.id = v.id
			function rem:Paint(pw, ph)
				hook.Run("YButtonRPaint", self, pw, ph)
			end
			function rem:DoClick()
				net.Start("yrp_pp_remove")
					net.WriteString(self.id)
				net.SendToServer()
				self.line:Remove()
			end

			pp.list:AddItem(line)
		end
	end
end)


function CreatePermaPropsSetting()
	if pa(settingsWindow.window) then
		local PARENT = settingsWindow.window.site

		pp.list = createD("DPanelList", PARENT, PARENT:GetWide() - YRP.ctr(40), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
		pp.list:EnableVerticalScrollbar()
		pp.list:SetSpacing(YRP.ctr(20))
		function pp.list:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 100))
		end

		net.Start("get_perma_props")
		net.SendToServer()
	end
end

hook.Add("open_server_permaprops", "open_server_permaprops", function()
	CreatePermaPropsSetting()
end)
