--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function BuildTable(tab, parent, name, tabx)
	local header = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
	function header:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0,0,255,100))
		draw.SimpleText(name .. ":", "Y_14_500", tabx + YRP.ctr(10), ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	parent:AddItem(header)

	for i, v in pairs(tab) do
		if type(v) == "function" then 
			--print(i, v)
			--continue
		elseif type(v) == "table" then
			BuildTable(v, parent, i, tabx + YRP.ctr(40))
		elseif type(v) == "boolean" then
			local pnl = createD("DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function pnl:Paint(pw, ph)
				draw.SimpleText(i, "Y_18_500", tabx + YRP.ctr(40) + YRP.ctr(40 + 20), ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local check = createD("DCheckBox", pnl, YRP.ctr(40), YRP.ctr(40), tabx + YRP.ctr(40), 0)
			check:SetChecked(v)
			function check:OnChange()
				net.Start("yrp_darkrp_bool")
					net.WriteString(i)
					net.WriteBool(check:GetChecked())
				net.SendToServer()
			end

			parent:AddItem(pnl)
		else
			print(i, v, type(v))
		end
	end
end

function CreateDarkRPSetting()
	if pa(settingsWindow.window) then
		local PARENT = settingsWindow.window.site

		local list = createD("DPanelList", PARENT, PARENT:GetWide() - YRP.ctr(40), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
		list:EnableVerticalScrollbar()
		function list:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 100))
		end

		BuildTable(DarkRP, list, "DarkRP", 0)
	end
end

hook.Add("open_server_darkrp", "open_server_darkrp", function()
	CreateDarkRPSetting()
end)
