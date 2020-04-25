--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local tmpTargetSteamID = ""
function toggleInteractMenu()
	local lply = LocalPlayer()
	local eyeTrace = lply:GetEyeTrace()
	--openInteractMenu(LocalPlayer():SteamID())
	if eyeTrace.Entity:IsPlayer() and YRPIsNoMenuOpen() then
		if eyeTrace.Entity:GetColor().a > 0 then
			openInteractMenu(eyeTrace.Entity:SteamID())
		end
	else
		closeInteractMenu()
	end
end

function closeInteractMenu()
	if wInteract != nil then
		closeMenu()
		wInteract:Remove()
		wInteract = nil
	end
end

function openInteractMenu(SteamID)
	if SteamID != nil then
		openMenu()
		tmpTargetSteamID = SteamID
		net.Start("openInteractMenu")
			net.WriteString(tmpTargetSteamID)
		net.SendToServer()
	end
end

net.Receive("openInteractMenu", function(len)
	local ply = net.ReadEntity()

	local idcard = net.ReadBool()

	local isInstructor = net.ReadBool()

	local promoteable = net.ReadBool()
	local promoteName = net.ReadString()

	local demoteable = net.ReadBool()
	local demoteName = net.ReadString()

	local licenses = ply:GetLicenseNames()

	wInteract = createD("YFrame", nil, YRP.ctr(1090), YRP.ctr(1360), 0, 0)
	wInteract:SetHeaderHeight(YRP.ctr(100))
	function wInteract:OnClose()
		closeMenu()
	end
	function wInteract:OnRemove()
		closeMenu()
	end

	local tmpRPName = ""
	local tmpPly = NULL
	local tmpGender = ""
	local tmpID = ""
	for k, v in pairs (player.GetAll()) do
		if tostring(v:SteamID()) == tostring(tmpTargetSteamID) then
			tmpPly = v
			tmpTargetName = v:Nick()
			tmpRPName = v:RPName()
			tmpGender = v:GetDString("Gender")
			tmpID = v:GetDString("idcardid")
			tmpRPDescription = ""
			for i = 1, 10 do
				if i > 1 then
					tmpRPDescription = tmpRPDescription .. "\n"
				end
				tmpRPDescription = tmpRPDescription .. SQL_STR_OUT(v:GetDString("rpdescription" .. i, ""))
			end
			break
		end
	end
	wInteract:SetTitle(YRP.lang_string("LID_interactmenu"))

	function wInteract:Paint(pw, ph)
		hook.Run("YFramePaint", self, pw, ph)
	end

	local content = wInteract:GetContent()
	function content:Paint(pw, ph)
		local scaleW = pw / (GetGlobalDInt("int_" .. "background" .. "_w", 100) + 20)
		local scaleH = YRP.ctr(470) / (GetGlobalDInt("int_" .. "background" .. "_h", 100) + 20)
		local scale = scaleW
		if scaleH < scaleW then
			scale = scaleH
		end
		drawIDCard(ply, scale, YRP.ctr(10), YRP.ctr(10))
		
		--[[ Licenses ]]--
		if LocalPlayer():isCP() then
			draw.RoundedBox(0, YRP.ctr(10), YRP.ctr(470), content:GetWide() - YRP.ctr(20), YRP.ctr(100), Color(255, 255, 255, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_licenses") .. ":", "Y_20_500", YRP.ctr(10 + 10), YRP.ctr(470 + 5 + 25), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 0))
			draw.SimpleTextOutlined(SQL_STR_OUT(licenses), "Y_20_500", YRP.ctr(10 + 10), YRP.ctr(510 + 5 + 25), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 0))
		end
	
		--[[ Description ]]--
		draw.RoundedBox(0, YRP.ctr(10), YRP.ctr(590), content:GetWide() - YRP.ctr(20), YRP.ctr(400 - 50), Color(255, 255, 255, 255))
		draw.SimpleTextOutlined(YRP.lang_string("LID_description") .. ":", "Y_20_500", YRP.ctr(10 + 10), YRP.ctr(610), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 0))
	end

	if idcard then
		local _tmpDescription = createD("DTextEntry", content, content:GetWide() - YRP.ctr(20), YRP.ctr(400 - 50), YRP.ctr(10), YRP.ctr(640))
		_tmpDescription:SetMultiline(true)
		_tmpDescription:SetEditable(false)
		_tmpDescription:SetText(tmpRPDescription)
	end

	--[[local btnTrade = createVGUI("YButton", content, 500, 50, 10, 1000)
	btnTrade:SetText(YRP.lang_string("LID_trade") .. " (in future update)")
	function btnTrade:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
	end]]

	if LocalPlayer():isCP() then
		local btnVerwarnungUp = createVGUI("YButton", content, 50, 50, 10, 1000)
		btnVerwarnungUp:SetText("⮝")
		function btnVerwarnungUp:DoClick()
			net.Start("warning_up")
				net.WriteEntity(ply)
			net.SendToServer()
		end
		local btnVerwarnungDn = createVGUI("YButton", content, 50, 50, 10, 1050)
		btnVerwarnungDn:SetText("⮟")
		function btnVerwarnungDn:DoClick()
			net.Start("warning_dn")
				net.WriteEntity(ply)
			net.SendToServer()
		end
		local btnVerwarnung = createVGUI("YLabel", content, 450, 100, 60, 1000)
		function btnVerwarnung:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
			btnVerwarnung:SetText(YRP.lang_string("LID_warnings") .. ": " .. ply:GetDInt("int_warnings", -1))
		end

		local btnVerstoesseUp = createVGUI("YButton", content, 50, 50, 10, 1110)
		btnVerstoesseUp:SetText("⮝")
		function btnVerstoesseUp:DoClick()
			net.Start("violation_up")
				net.WriteEntity(ply)
			net.SendToServer()
		end
		local btnVerstoesseDn = createVGUI("YButton", content, 50, 50, 10, 1160)
		btnVerstoesseDn:SetText("⮟")
		function btnVerstoesseDn:DoClick()
			net.Start("violation_dn")
				net.WriteEntity(ply)
			net.SendToServer()
		end
		local btnVerstoesse = createVGUI("YLabel", content, 450, 100, 60, 1110)
		function btnVerstoesse:Paint(pw, ph)
			hook.Run("YLabelPaint", self, pw, ph)
			btnVerstoesse:SetText(YRP.lang_string("LID_violations") .. ": " .. ply:GetDInt("int_violations", -1))
		end
	end

	if isInstructor then
		if promoteable then
			local btnPromote = createVGUI("YButton", content, 500, 50, 520, 1000)
			btnPromote:SetText(YRP.lang_string("LID_promote") .. ": " .. promoteName)
			function btnPromote:DoClick()
				net.Start("promotePlayer")
					net.WriteString(tmpTargetSteamID)
				net.SendToServer()
				wInteract:Close()
			end
			function btnPromote:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end

		if demoteable then
			local btnDemote = createVGUI("YButton", content, 500, 50, 520, 1000 + 10 + 50)
			btnDemote:SetText(YRP.lang_string("LID_demote") .. ": " .. demoteName)
			function btnDemote:DoClick()
				net.Start("demotePlayer")
					net.WriteString(tmpTargetSteamID)
				net.SendToServer()
				wInteract:Close()
			end
			function btnDemote:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end
	end

	wInteract:Center()
	wInteract:MakePopup()
end)
