--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

CHAR = CHAR or {}
CHAR.open = false

function YRPToggleCharMenu()
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
	CHAR.window = YRPCreateD( "YFrame", nil, BFW(), BFH(), BPX(), BPY() )
	CHAR.window:Center()
	CHAR.window:SetTitle( "LID_character" )
	CHAR.window:SetHeaderHeight(YRP.ctr(100) )
	function CHAR.window:OnClose()
		closeMenu()
	end
	function CHAR.window:OnRemove()
		closeMenu()
	end
	CHAR.window.systime = SysTime()
	function CHAR.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		hook.Run( "YFramePaint", self, pw, ph) --surfaceWindow(self, pw, ph, YRP.lang_string( "LID_givechar" ) .. " [PROTOTYPE]" )
	end
	CHAR.window:MakePopup()

	CreateCharContent(CHAR.window.con)
end

local save_delay = 0
function CreateCharContent(parent)
	local lply = LocalPlayer()
	CHAR.content = parent


	local Y = 20
	local cl_rpName = nil
	if GetGlobalYRPBool( "bool_characters_changeable_name", false) then
		local cl_rpNamelabel = YRPCreateD( "DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
		cl_rpNamelabel:SetText( "" )
		function cl_rpNamelabel:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string( "LID_name" ), "Y_24_500", 0, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_rpName = YRPCreateD( "DTextEntry", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(70) )
		cl_rpName:SetText(LocalPlayer():RPName() )
		function cl_rpName:OnChange()
			if #self:GetText() > 32 then
				self:SetText(string.sub(self:GetText(), 0, 32) )
			end
		end
		Y = Y + 70
	end



	local cl_rpDescriptionlabel = YRPCreateD( "DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
	cl_rpDescriptionlabel:SetText( "" )
	function cl_rpDescriptionlabel:Paint(pw, ph)
		draw.SimpleText(YRP.lang_string( "LID_description" ), "Y_24_500", 0, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	Y = Y + 50
	local cl_rpDescription = YRPCreateD( "DTextEntry", parent, YRP.ctr(800), YRP.ctr(200), YRP.ctr(20), YRP.ctr(Y) )
	cl_rpDescription:SetMultiline(true)
	cl_rpDescription:SetText(LocalPlayer():GetYRPString( "rpdescription", "FAIL" ) )
	function cl_rpDescription:OnChange()

	end
	Y = Y + 220



	local cl_birthday = nil
	if GetGlobalYRPBool( "bool_characters_birthday", false) then
		local cl_birthdayheader = YRPCreateD( "DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
		cl_birthdayheader:SetText( "" )
		function cl_birthdayheader:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string( "LID_birthday" ), "Y_24_500", 0, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_birthday = YRPCreateD( "DTextEntry", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
		cl_birthday:SetText(LocalPlayer():GetYRPString( "string_birthday", "" ) )
		function cl_birthday:OnChange()

		end
		Y = Y + 50 + 20
	end



	local cl_bodyheight = nil
	if GetGlobalYRPBool( "bool_characters_bodyheight", false) then
		local cl_bodyheightheader = YRPCreateD( "DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
		cl_bodyheightheader:SetText( "" )
		function cl_bodyheightheader:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string( "LID_bodyheight" ), "Y_24_500", 0, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_bodyheight = YRPCreateD( "DNumberWang", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
		cl_bodyheight:SetValue(tostring(LocalPlayer():GetYRPInt( "int_bodyheight", 0) ))
		function cl_bodyheight:OnChange()

		end
		Y = Y + 50 + 20
	end



	local cl_weight = nil
	if GetGlobalYRPBool( "bool_characters_weight", false) then
		local cl_weightheader = YRPCreateD( "DLabel", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
		cl_weightheader:SetText( "" )
		function cl_weightheader:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string( "LID_weight" ), "Y_24_500", 0, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		Y = Y + 50
		cl_weight = YRPCreateD( "DNumberWang", parent, YRP.ctr(800), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
		cl_weight:SetText(LocalPlayer():GetYRPInt( "int_weight", 0) )
		function cl_weight:OnChange()

		end
		Y = Y + 50 + 20
	end	



	--[[local attr = YRPCreateD( "YPanel", parent, YRP.ctr(300), YRP.ctr(260), YRP.ctr(20), YRP.ctr(Y) )
	function attr:Paint(pw, ph)
		hook.Run( "YPanelPaint", self, pw, ph)

		draw.SimpleText(YRP.lang_string( "LID_strength" ) .. ":", "Y_14_500", YRP.ctr(20), YRP.ctr(20), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(YRP.lang_string( "LID_agility" ) .. ":", "Y_14_500", YRP.ctr(20), YRP.ctr(60), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(YRP.lang_string( "LID_stamina" ) .. ":", "Y_14_500", YRP.ctr(20), YRP.ctr(100), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(YRP.lang_string( "LID_intellect" ) .. ":", "Y_14_500", YRP.ctr(20), YRP.ctr(140), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(YRP.lang_string( "LID_spirit" ) .. ":" , "Y_14_500", YRP.ctr(20), YRP.ctr(180), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(YRP.lang_string( "LID_armor" ) .. ":", "Y_14_500", YRP.ctr(20), YRP.ctr(220), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		
		draw.SimpleText(lply:GetYRPInt( "int_strength", 0), "Y_14_500", pw - YRP.ctr(20), YRP.ctr(20), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(lply:GetYRPInt( "int_agility", 0), "Y_14_500", pw - YRP.ctr(20), YRP.ctr(60), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(lply:GetYRPInt( "int_stamina", 0), "Y_14_500", pw - YRP.ctr(20), YRP.ctr(100), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(lply:GetYRPInt( "int_intellect", 0), "Y_14_500", pw - YRP.ctr(20), YRP.ctr(140), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(lply:GetYRPInt( "int_spirit", 0), "Y_14_500", pw - YRP.ctr(20), YRP.ctr(180), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(lply:GetYRPInt( "int_armor", 0), "Y_14_500", pw - YRP.ctr(20), YRP.ctr(220), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	end

	Y = Y + 400 + 20]]



	local cl_save = YRPCreateD( "YButton", parent, YRP.ctr(400), YRP.ctr(50), YRP.ctr(20), YRP.ctr(Y) )
	cl_save:SetText( "LID_change" )
	function cl_save:Paint(pw, ph)
		if CurTime() > save_delay then
			hook.Run( "YButtonPaint", self, pw, ph)
		else
			draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
			draw.SimpleTextOutlined(YRP.lang_string( "LID_cooldown" ), "Y_24_500", pw / 2, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
		end
	end
	function cl_save:DoClick()
		if CurTime() > save_delay then
			save_delay = CurTime() + 4
			if GetGlobalYRPBool( "bool_characters_changeable_name", false) then
				net.Start( "change_rpname" )
					net.WriteString( cl_rpName:GetText() )
				net.SendToServer()
			end

			net.Start( "change_rpdescription" )
				net.WriteString( cl_rpDescription:GetText() )
			net.SendToServer()

			if GetGlobalYRPBool( "bool_characters_birthday", false) then
				net.Start( "change_birthday" )
					net.WriteString( cl_birthday:GetText() )
				net.SendToServer()
			end
			if GetGlobalYRPBool( "bool_characters_bodyheight", false) then
				net.Start( "change_bodyheight" )
					net.WriteString( cl_bodyheight:GetText() )
				net.SendToServer()
			end
			if GetGlobalYRPBool( "bool_characters_weight", false) then
				net.Start( "change_weight" )
					net.WriteString( cl_weight:GetText() )
				net.SendToServer()
			end
		end
	end
end
