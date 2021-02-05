--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
local ta = {}

function ToggleTalentsMenu()
	if YRPIsNoMenuOpen() then
		OpenTalentsMenu()
	else
		CloseTalentsMenu()
	end
end

function CloseTalentsMenu()
	if ta.win != nil then
		closeMenu()
		ta.win:Remove()
		ta.win = nil
	end
end

function CreateTalentsContent(PARENT)
	local lply = LocalPlayer()
	
	local wip = createD("DPanel", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function wip:Paint(pw, ph)
		draw.SimpleText(YRP.lang_string("LID_wip"), "Y_24_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function OpenTalentsMenu()
	openMenu()
	ta.win = createD("YFrame", nil, YRP.ctr(1600), YRP.ctr(1200), 0, 0)
	ta.win:Center()
	ta.win:MakePopup()
	ta.win:SetTitle(YRP.lang_string("LID_talents"))
	ta.win:SetHeaderHeight(YRP.ctr(100))
	function ta.win:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end

	local content = ta.win:GetContent()

	CreateTalentsContent(content)
end
