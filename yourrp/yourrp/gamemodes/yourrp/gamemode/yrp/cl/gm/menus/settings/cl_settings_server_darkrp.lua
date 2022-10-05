--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

function BuildTable(tab, parent, name, tabx)
	local header = YRPCreateD( "DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
	function header:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color( 0,0,255,100) )
		draw.SimpleText(name .. ":", "Y_14_500", tabx + YRP.ctr(10), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	parent:AddItem(header)

	for i, v in pairs(tab) do
		if type( v) == "function" then 
			continue
		elseif type( v) == "table" then
			BuildTable( v, parent, i, tabx + YRP.ctr(40) )
		elseif type( v) == "boolean" then
			local pnl = YRPCreateD( "DPanel", nil, YRP.ctr(40), YRP.ctr(40), 0, 0)
			function pnl:Paint(pw, ph)
				draw.SimpleText(i, "Y_18_500", tabx + YRP.ctr(40) + YRP.ctr(40 + 20), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local check = YRPCreateD( "DCheckBox", pnl, YRP.ctr(40), YRP.ctr(40), tabx + YRP.ctr(40), 0)
			check:SetChecked( v)
			function check:OnChange()
				net.Start( "yrp_darkrp_bool" )
					net.WriteString(i)
					net.WriteBool( check:GetChecked() )
				net.SendToServer()
			end

			parent:AddItem(pnl)
		end
	end
end

function CreateDarkRPSetting()
	local PARENT = GetSettingsSite()
	if PanelAlive(PARENT) then
		local list = YRPCreateD( "DPanelList", PARENT, PARENT:GetWide() - YRP.ctr(40), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20) )
		list:EnableVerticalScrollbar()
		function list:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 100, 100, 100) )
		end

		BuildTable(DarkRP, list, "DarkRP", 0)
	end
end

function OpenSettingsDarkRP()
	CreateDarkRPSetting()
end
