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
		local cl_rpNamelabel = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_rpNamelabel:SetText("")
		function cl_rpNamelabel:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_name"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_rpName = createD("DTextEntry", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(70))
		cl_rpName:SetText(LocalPlayer():RPName())
		function cl_rpName:OnChange()
			if #self:GetText() > 32 then
				self:SetText(string.sub(self:GetText(), 0, 32))
			end
		end
		Y = Y + 70
	end



	local cl_rpDescriptionlabel = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
	cl_rpDescriptionlabel:SetText("")
	function cl_rpDescriptionlabel:Paint(pw, ph)
		draw.SimpleText(YRP.lang_string("LID_description"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	Y = Y + 50
	local cl_rpDescription = createD("DTextEntry", parent, YRP.ctr(800), YRP.ctr(200), YRP.ctr(20), YRP.ctr(Y))
	cl_rpDescription:SetMultiline(true)
	cl_rpDescription:SetText(LocalPlayer():GetDString("rpdescription", "FAIL"))
	function cl_rpDescription:OnChange()

	end
	Y = Y + 220

	local cl_birthday = nil
	if GetGlobalDBool("bool_characters_birthday", false) then
		local cl_birthdayheader = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_birthdayheader:SetText("")
		function cl_birthdayheader:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_birthday"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_birthday = createD("DTextEntry", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_birthday:SetText(LocalPlayer():GetDString("string_birthday", ""))
		function cl_birthday:OnChange()

		end
		Y = Y + 50 + 20
	end

	local cl_bodyheight = nil
	if GetGlobalDBool("bool_characters_bodyheight", false) then
		local cl_bodyheightheader = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_bodyheightheader:SetText("")
		function cl_bodyheightheader:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_bodyheight"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_bodyheight = createD("DNumberWang", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_bodyheight:SetValue(tostring(LocalPlayer():GetDInt("int_bodyheight", 0)))
		function cl_bodyheight:OnChange()

		end
		Y = Y + 50 + 20
	end

	local cl_weight = nil
	if GetGlobalDBool("bool_characters_weight", false) then
		local cl_weightheader = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_weightheader:SetText("")
		function cl_weightheader:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_weight"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_weight = createD("DNumberWang", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_weight:SetText(LocalPlayer():GetDInt("int_weight", 0))
		function cl_weight:OnChange()

		end
		Y = Y + 50 + 20
	end	

	local cl_nationality = nil
	if GetGlobalDBool("bool_characters_nationality", false) then
		local cl_nationalityheader = createD("DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_nationalityheader:SetText("")
		function cl_nationalityheader:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_nationality"), "Y_24_500", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_nationality = createD("DComboBox", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
		cl_nationality:SetText(LocalPlayer():GetDString("string_nationality", ""))
		function cl_nationality:OnChange()

		end

		local text_nationalities = string.Explode(",", GetGlobalDString("text_nationalities", ""))
		for i, v in pairs(text_nationalities) do
			cl_nationality:AddChoice(v, v, false)
		end

		Y = Y + 50 + 20
	end


	local cl_save = createD("YButton", parent, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y))
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

			if GetGlobalDBool("bool_characters_birthday", false) then
				net.Start("change_birthday")
					net.WriteString(cl_birthday:GetText())
				net.SendToServer()
			end
			if GetGlobalDBool("bool_characters_bodyheight", false) then
				net.Start("change_bodyheight")
					net.WriteString(cl_bodyheight:GetText())
				net.SendToServer()
			end
			if GetGlobalDBool("bool_characters_weight", false) then
				net.Start("change_weight")
					net.WriteString(cl_weight:GetText())
				net.SendToServer()
			end
			if GetGlobalDBool("bool_characters_nationality", false) then
				net.Start("change_nationality")
					net.WriteString(cl_nationality:GetText())
				net.SendToServer()
			end
		end
	end
end
