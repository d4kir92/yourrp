--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local tmpTargetSteamID = ""
function toggleInteractMenu()
	local ply = LocalPlayer()
	local eyeTrace = ply:GetEyeTrace()
	if eyeTrace.Entity:IsPlayer() and isNoMenuOpen() then
		openInteractMenu(eyeTrace.Entity:SteamID())
	else
		closeInteractMenu()
	end
end

function closeInteractMenu()
	if _windowInteract != nil then
		closeMenu()
		_windowInteract:Remove()
		_windowInteract = nil
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

	_windowInteract = createVGUI("DFrame", nil, 1090, 1090, ScrW() - 160, ScrH() - 100)
	function _windowInteract:OnClose()
		closeMenu()
	end
	function _windowInteract:OnRemove()
		closeMenu()
	end

	local tmpTargetName = ""
	local tmpRPName = ""
	local tmpPly = NULL
	for k, v in pairs (player.GetAll()) do
		if tostring(v:SteamID()) == tostring(tmpTargetSteamID) then
			tmpPly = v
			tmpTargetName = v:Nick()
			tmpRPName = v:RPName()
			tmpGender = v:GetNWString("Gender")
			tmpRPDescription = ""
			for i = 1, 10 do
				if i > 1 then
					tmpRPDescription = tmpRPDescription .. "\n"
				end
				tmpRPDescription = tmpRPDescription .. v:GetNWString("rpdescription" .. i, "")
			end
			break
		end
	end
	_windowInteract:SetTitle(YRP.lang_string("LID_interactmenu"))

	function _windowInteract:Paint(pw, ph)
		surfaceWindow(self, pw, ph, "")

		if idcard then
			draw.RoundedBox(ctr(30), ctr(10), ctr(50), ctr(750), ctr(350), Color(255, 255, 255, 255))

			draw.SimpleTextOutlined(YRP.lang_string("LID_identifycard"), "charTitle", ctr(10 + 10), ctr(55), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 0))
			draw.SimpleTextOutlined(GetHostName(), "charTitle", ctr(10 + 10), ctr(60+30), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 0))
			draw.SimpleTextOutlined(LocalPlayer():SteamID(), "charTitle", ctr(745), ctr(55), Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 0))

			draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ":", "charHeader", ctr(280), ctr(60 + 70), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 0))

			draw.SimpleTextOutlined(tmpRPName, "charText", ctr(280), ctr(60 + 100), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 0))

			draw.SimpleTextOutlined(YRP.lang_string("LID_gender") .. ":", "charHeader", ctr(280), ctr(60 + 210), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 0))
			local gender = YRP.lang_string("LID_genderother")
			if tmpGender == "gendermale" then
				gender = YRP.lang_string("LID_gendermale")
			elseif tmpGender == "genderfemale" then
				gender = YRP.lang_string("LID_genderfemale")
			elseif tmpGender == "genderother" then
				gender = YRP.lang_string("LID_genderother")
			end
			draw.SimpleTextOutlined(gender, "charText", ctr(280), ctr(60 + 240), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 0))

			--[[ Licenses ]]--
			draw.RoundedBox(0, ctr(10), ctr(420), ctr(1070), ctr(100), Color(255, 255, 255, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_licenses") .. ":", "charTitle", ctr(10 + 10), ctr(420 + 5 + 25), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 0))
			draw.SimpleTextOutlined(licenses, "charTitle", ctr(10 + 10), ctr(460 + 5 + 25), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 0))

			--[[ Description ]]--
			draw.RoundedBox(0, ctr(10), ctr(530), ctr(1070), ctr(100), Color(255, 255, 255, 255))
			draw.SimpleTextOutlined(YRP.lang_string("LID_description") .. ":", "charTitle", ctr(10 + 10), ctr(560), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 0))
		end
	end

	if idcard then
		local _tmpDescription = createD("DTextEntry", _windowInteract, ctr(1070), ctr(400 - 50), ctr(10), ctr(590))
		_tmpDescription:SetMultiline(true)
		_tmpDescription:SetEditable(false)
		_tmpDescription:SetText(tmpRPDescription)

		local tmpAvatarI = createVGUI("AvatarImage", _windowInteract, 256, 256, 10 + 10, 60 + 70)
		tmpAvatarI:SetPlayer(tmpPly, ctr(256))
	end

	local buttonTrade = createVGUI("DButton", _windowInteract, 530, 50, 10, 950)
	buttonTrade:SetText("")
	function buttonTrade:Paint(pw, ph)
		surfaceButton(self, pw, ph, YRP.lang_string("LID_trade") .. " (in future update)")
	end

	if isInstructor then
		if promoteable then
			local buttonPromote = createVGUI("DButton", _windowInteract, 530, 50, 545, 950)
			buttonPromote:SetText("")
			function buttonPromote:DoClick()
				net.Start("promotePlayer")
					net.WriteString(tmpTargetSteamID)
				net.SendToServer()
				_windowInteract:Close()
			end
			function buttonPromote:Paint(pw, ph)
				surfaceButton(self, pw, ph, YRP.lang_string("LID_promote") .. ": " .. promoteName)
			end
		end

		if demoteable then
			local buttonDemote = createVGUI("DButton", _windowInteract, 530, 50, 545, 950 + 10 + 50)
			buttonDemote:SetText("")
			function buttonDemote:DoClick()
				net.Start("demotePlayer")
					net.WriteString(tmpTargetSteamID)
				net.SendToServer()
				_windowInteract:Close()
			end
			function buttonDemote:Paint(pw, ph)
				surfaceButton(self, pw, ph, YRP.lang_string("LID_demote") .. ": " .. demoteName)
			end
		end
	end

	_windowInteract:Center()
	_windowInteract:MakePopup()
end)
