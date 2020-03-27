--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

CHAR = CHAR or {}
CHAR.open = false

function toggleCharMenu()
	if !CHAR.open and YRPIsNoMenuOpen() then
		openCharMenu()
	end
end

function closeCharMenu()
	CHAR.open = false
	if CHAR.window != nil then
		closeMenu()
		CHAR.window:Remove()
		CHAR.window = nil
	end
end

function openCharMenu()
	openMenu()

	CHAR.open = true
	CHAR.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	CHAR.window:Center()
	CHAR.window:SetTitle("LID_character")
	CHAR.window:SetHeaderHeight(YRP.ctr(100))
	function CHAR.window:OnClose()
		closeMenu()
	end
	function CHAR.window:OnRemove()
		closeMenu()
	end
	CHAR.window.systime = SysTime()
	function CHAR.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run("YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string("LID_givechar") .. " [PROTOTYPE]")
	end
	CHAR.window:MakePopup()

	CreateCharContent(CHAR.window.con)
end

local save_delay = 0
function CreateCharContent(parent)
	CHAR.content = parent


	local Y = 20
	local cl_rpName = nil
	if GetGlobalDBool("bool_characters_changeable_name", false) then
		local cl_rpNamelabel = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(10), YRP.ctr(Y))
		cl_rpNamelabel:SetText("")
		function cl_rpNamelabel:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_name"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_rpName = createD("DTextEntry", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(10), YRP.ctr(70))
		cl_rpName:SetText(LocalPlayer():RPName())
		function cl_rpName:OnChange()
			if #self:GetText() > 32 then
				self:SetText(string.sub(self:GetText(), 0, 32))
			end
		end
		Y = Y + 70
	end



	local cl_rpDescriptionlabel = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(10), YRP.ctr(Y))
	cl_rpDescriptionlabel:SetText("")
	function cl_rpDescriptionlabel:Paint(pw, ph)
		draw.SimpleText(YRP.lang_string("LID_description"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	Y = Y + 50
	local cl_rpDescription = createD("DTextEntry", parent, YRP.ctr(800), YRP.ctr(200), YRP.ctr(10), YRP.ctr(Y))
	cl_rpDescription:SetMultiline(true)
	cl_rpDescription:SetText(LocalPlayer():GetDString("rpdescription", "FAIL"))
	function cl_rpDescription:OnChange()

	end
	Y = Y + 250


	local cl_save = createD("YButton", parent, YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(Y))
	cl_save:SetText("LID_change")
	function cl_save:Paint(pw, ph)
		if CurTime() > save_delay then
			hook.Run("YButtonPaint", self, pw, ph)
		else
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_cooldown"), "Y_24_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end
	end
	function cl_save:DoClick()
		if CurTime() > save_delay then
			save_delay = CurTime() + 4
			if GetGlobalDBool("bool_characters_changeable_name", false) then
				net.Start("change_rpname")
					net.WriteString(cl_rpName:GetText())
				net.SendToServer()
			end

			net.Start("change_rpdescription")
				net.WriteString(cl_rpDescription:GetText())
			net.SendToServer()
		end
	end
end
