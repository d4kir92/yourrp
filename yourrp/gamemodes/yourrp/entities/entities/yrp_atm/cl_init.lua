--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

include( "shared.lua" )

ent = ENT

ENT.name = {}
ENT.SteamID = {}

function ENT:Draw()
	local lply = LocalPlayer()

	if self.display == nil then
		self.display = vgui.Create( "DFrame" )
		self.display:SetTitle( "" )
		self.display:SetSize(1000, 1000)
		self.display:ShowCloseButton(false)
		self.display:SetDraggable(false)
		self.display:SetPaintedManually(true)
		self.display.ent = self

		function self.display:Paint(pw, ph)
			local bankName = "YRP Bank [" .. GetGlobalString( "text_money_pre", "" ) .. lply:GetNW2String( "moneybank", "-1" ) .. GetGlobalString( "text_money_pos", "" ) .. "]"
			if self.ent:GetNW2String( "status" ) == "startup" then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0) )
				draw.SimpleTextOutlined( "..." .. YRP.lang_string( "LID_loading" ) .. "...", "Y_80_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self.ent:GetNW2String( "status" ) == "logo" then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_welcome" ) .. "!", "Y_80_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self.ent:GetNW2String( "status" ) == "home" then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255) )
				draw.SimpleTextOutlined( bankName, "Y_80_500", 15, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 150, pw, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_home" ), "Y_80_500", pw / 2, 150 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 300, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_withdraw" ), "Y_60_500", 200, 300 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 450, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_deposit" ), "Y_60_500", 200, 450 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 600, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_transfer" ), "Y_60_500", 200, 600 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self.ent:GetNW2String( "status" ) == "withdraw" then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255) )
				draw.SimpleTextOutlined( bankName, "Y_80_500", 15, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 150, pw, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_withdraw" ), "Y_80_500", pw / 2, 150 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 300, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "5" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", 200, 300 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 450, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "10" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", 200, 450 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 600, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "20" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", 200, 600 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 850, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_back" ), "Y_60_500", 200, 850 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, pw-400, 300, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "50" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", pw-200, 300 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, pw-400, 450, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "100" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", pw-200, 450 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, pw-400, 600, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_other" ), "Y_60_500", pw-200, 600 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self.ent:GetNW2String( "status" ) == "deposit" then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255) )
				draw.SimpleTextOutlined( bankName, "Y_80_500", 15, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 150, pw, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_deposit" ), "Y_80_500", pw / 2, 150 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 300, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "5" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", 200, 300 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 450, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "10" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", 200, 450 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 600, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "20" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", 200, 600 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 850, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_back" ), "Y_60_500", 200, 850 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, pw-400, 300, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "50" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", pw-200, 300 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, pw-400, 450, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. "100" .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", pw-200, 450 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, pw-400, 600, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_other" ), "Y_60_500", pw-200, 600 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self.ent:GetNW2String( "status" ) == "transfer" then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255) )
				draw.SimpleTextOutlined( bankName, "Y_80_500", 15, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 150, pw, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_transfer" ), "Y_80_500", pw / 2, 150 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				if self.ent:GetNW2String( "name1" ) != "nil" then
					draw.RoundedBox(0, 0, 300, 400, 100, Color(255, 255, 255) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "name1", "EMPTY" ), "Y_40_500", 200, 300 + 50-20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "SteamID1", "EMPTY" ), "Y_40_500", 200, 300 + 50 + 20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				end
				if self.ent:GetNW2String( "name2" ) != "nil" then
					draw.RoundedBox(0, 0, 450, 400, 100, Color(255, 255, 255) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "name2", "EMPTY" ), "Y_40_500", 200, 450 + 50-20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "SteamID2", "EMPTY" ), "Y_40_500", 200, 450 + 50 + 20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				end

				draw.RoundedBox(0, 0, 600, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_prev" ), "Y_60_500", 200, 600 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 850, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_back" ), "Y_60_500", 200, 850 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				if self.ent:GetNW2String( "name3" ) != "nil" then
					draw.RoundedBox(0, pw-400, 300, 400, 100, Color(255, 255, 255) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "name3", "EMPTY" ), "Y_40_500", pw-200, 300 + 50-20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "SteamID3", "EMPTY" ), "Y_40_500", pw-200, 300 + 50 + 20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				end
				if self.ent:GetNW2String( "name4" ) != "nil" then
					draw.RoundedBox(0, pw-400, 450, 400, 100, Color(255, 255, 255) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "name4", "EMPTY" ), "Y_40_500", pw-200, 450 + 50-20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
					draw.SimpleTextOutlined(self.ent:GetNW2String( "SteamID4", "EMPTY" ), "Y_40_500", pw-200, 450 + 50 + 20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				end

				draw.RoundedBox(0, pw-400, 600, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_next" ), "Y_60_500", pw-200, 600 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self.ent:GetNW2String( "status" ) == "other" then
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255) )
				draw.SimpleTextOutlined( bankName, "Y_80_500", 15, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 150, pw, 100, Color(255, 255, 255) )
				local otherText = ""
				local otherTextPos = YRP.lang_string( "LID_other" )
				if self.ent:GetNW2String( "prevstatus" ) == "withdraw" then
					otherText = YRP.lang_string( "LID_withdraw" )
				elseif self.ent:GetNW2String( "prevstatus" ) == "deposit" then
					otherText = YRP.lang_string( "LID_deposit" )
				elseif self.ent:GetNW2String( "prevstatus" ) == "transfer" then
					otherText = YRP.lang_string( "LID_transfer" )
					otherTextPos = self.ent:GetNW2String( "name", "ERROR" )
				end
				draw.SimpleTextOutlined(otherText .. " > " .. otherTextPos, "Y_80_500", pw / 2, 150 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 300, 250, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(GetGlobalString( "text_money_pre", "" ) .. self.ent:GetNW2String( "othermoney", "..." ) .. GetGlobalString( "text_money_pos", "" ), "Y_60_500", 500, 250 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 750, 250, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "<", "Y_60_500", 800, 250 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 300, 400, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "1", "Y_60_500", 350, 400 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 450, 400, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "2", "Y_60_500", 500, 400 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 600, 400, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "3", "Y_60_500", 650, 400 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 300, 550, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "4", "Y_60_500", 350, 550 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 450, 550, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "5", "Y_60_500", 500, 550 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 600, 550, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "6", "Y_60_500", 650, 550 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 300, 700, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "7", "Y_60_500", 350, 700 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 450, 700, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "8", "Y_60_500", 500, 700 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 600, 700, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "9", "Y_60_500", 650, 700 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 750, 700, 100, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "0", "Y_60_500", 800, 700 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 600, 850, 400, 100, Color(255, 255, 255) )
				local _confirm = ""
				if self.ent:GetNW2String( "prevstatus" ) == "withdraw" then
					_confirm = YRP.lang_string( "LID_withdraw" )
				elseif self.ent:GetNW2String( "prevstatus" ) == "deposit" then
					_confirm = YRP.lang_string( "LID_deposit" )
				elseif self.ent:GetNW2String( "prevstatus" ) == "transfer" then
					_confirm = YRP.lang_string( "LID_transfer" )
				end
				draw.SimpleTextOutlined(_confirm, "Y_60_500", 600 + 200, 850 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 850, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_back" ), "Y_60_500", 200, 850 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			else
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0) )
				draw.SimpleTextOutlined( bankName, "Y_80_500", 15, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 150, pw, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined( "ERROR", "Y_80_500", pw / 2, 150 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.SimpleTextOutlined( "404", "Y_80_500", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				draw.SimpleTextOutlined( "Please tell the DEVs", "Y_80_500", pw / 2, ph / 2 + 72 + 10, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )

				draw.RoundedBox(0, 0, 850, 400, 100, Color(255, 255, 255) )
				draw.SimpleTextOutlined(YRP.lang_string( "LID_back" ), "Y_60_500", 200, 850 + 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			end
		end
	end

	if lply:GetPos():Distance(self:GetPos() ) < 2200 then
		self:DrawModel()

		local ang = self:GetAngles()
		local pos = self:GetPos() + ang:Up() * 53.7 + ang:Right() * 8 + ang:Forward() * 3.2
		local camAng = Angle( ang.p, ang.y, ang.r)

		camAng:RotateAroundAxis( camAng:Up(), 90)
		camAng:RotateAroundAxis( camAng:Forward(), 45)

		cam.Start3D2D(pos, camAng, 0.016)
			self.display:PaintManual()
		cam.End3D2D()
	end
end
