--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local tmpTargetCharID = ""
function YRPToggleInteractMenu()
	local lply = LocalPlayer()
	local eyeTrace = lply:GetEyeTrace()
	--openInteractMenu(LocalPlayer():CharID())
	if eyeTrace.Entity:IsPlayer() and YRPIsNoMenuOpen() then
		if eyeTrace.Entity:GetColor().a > 0 then
			openInteractMenu(eyeTrace.Entity:CharID())
		end
	else
		closeInteractMenu()
	end
end

function closeInteractMenu()
	if yrp_Interact ~= nil then
		YRPCloseMenu()
		yrp_Interact:Remove()
		yrp_Interact = nil
	end
end

function openInteractMenu(CharID)
	if CharID ~= nil then
		YRPOpenMenu()
		tmpTargetCharID = CharID
		net.Start("nws_yrp_openInteractMenu")
		net.WriteString(tmpTargetCharID)
		net.SendToServer()
	end
end

net.Receive(
	"nws_yrp_openInteractMenu",
	function(len)
		local ply = net.ReadEntity()
		local idcard = net.ReadBool()
		local isInstructor = net.ReadBool()
		local promoteable = net.ReadBool()
		local promoteName = net.ReadString()
		local demoteable = net.ReadBool()
		local demoteName = net.ReadString()
		local hasspecs = net.ReadBool()
		yrp_Interact = YRPCreateD("YFrame", nil, YRP:ctr(1090), YRP:ctr(1360), 0, 0)
		yrp_Interact:SetHeaderHeight(YRP:ctr(100))
		function yrp_Interact:OnClose()
			YRPCloseMenu()
		end

		function yrp_Interact:OnRemove()
			YRPCloseMenu()
		end

		local tmpCharID = 0
		for k, v in pairs(player.GetAll()) do
			if tostring(v:CharID()) == tostring(tmpTargetCharID) then
				tmpPly = v
				tmpTargetName = v:Nick()
				tmpRPName = v:RPName()
				tmpID = v:GetYRPString("idcardid")
				tmpCharID = v:CharID()
				tmpRPDescription = ""
				for i = 1, 10 do
					if i > 1 then
						tmpRPDescription = tmpRPDescription .. "\n"
					end

					tmpRPDescription = tmpRPDescription .. v:GetYRPString("rpdescription" .. i, "")
				end

				break
			end
		end

		yrp_Interact:SetTitle(YRP:trans("LID_interactmenu"))
		function yrp_Interact:Paint(pw, ph)
			hook.Run("YFramePaint", self, pw, ph)
		end

		local content = yrp_Interact:GetContent()
		local licenses = ply:GetAllLicenses()
		function content:Paint(pw, ph)
			local scaleW = pw / (GetGlobalYRPInt("int_" .. "background" .. "_w", 100) + 20)
			local scaleH = YRP:ctr(470) / (GetGlobalYRPInt("int_" .. "background" .. "_h", 100) + 20)
			local scale = scaleW
			if scaleH < scaleW then
				scale = scaleH
			end

			YRPDrawIDCard(ply, scale, YRP:ctr(10), YRP:ctr(10))
			--[[ Licenses ]]
			draw.RoundedBox(0, YRP:ctr(10), YRP:ctr(500), content:GetWide() - YRP:ctr(20), YRP:ctr(50), Color(255, 255, 255, 255))
			draw.SimpleTextOutlined(YRP:trans("LID_licenses") .. ": " .. licenses, "Y_20_500", YRP:ctr(10 + 10), YRP:ctr(520), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(255, 255, 255, 0))
			--[[ Description ]]
			draw.RoundedBox(0, YRP:ctr(10), YRP:ctr(590), content:GetWide() - YRP:ctr(20), YRP:ctr(400 - 50), Color(255, 255, 255, 255))
			draw.SimpleTextOutlined(YRP:trans("LID_description") .. ":", "Y_20_500", YRP:ctr(10 + 10), YRP:ctr(610), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(255, 255, 255, 0))
		end

		if idcard then
			local _tmpDescription = YRPCreateD("DTextEntry", content, content:GetWide() - YRP:ctr(20), YRP:ctr(400 - 50), YRP:ctr(10), YRP:ctr(640))
			_tmpDescription:SetMultiline(true)
			_tmpDescription:SetEditable(false)
			_tmpDescription:SetText(tmpRPDescription or "")
		end

		if LocalPlayer():isCP() or LocalPlayer():GetYRPBool("bool_canusewarnsystem", false) then
			local btnVerwarnungUp = createVGUI("YButton", content, 50, 50, 10, 1000)
			btnVerwarnungUp:SetText("⮝")
			function btnVerwarnungUp:DoClick()
				net.Start("nws_yrp_warning_up")
				net.WriteEntity(ply)
				net.SendToServer()
			end

			local btnVerwarnungDn = createVGUI("YButton", content, 50, 50, 10, 1050)
			btnVerwarnungDn:SetText("⮟")
			function btnVerwarnungDn:DoClick()
				net.Start("nws_yrp_warning_dn")
				net.WriteEntity(ply)
				net.SendToServer()
			end

			local btnVerwarnung = createVGUI("YLabel", content, 450, 100, 60, 1000)
			function btnVerwarnung:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
				btnVerwarnung:SetText(YRP:trans("LID_warnings") .. ": " .. ply:GetYRPInt("int_warnings", -1))
			end

			local btnVerstoesseUp = createVGUI("YButton", content, 50, 50, 10, 1110)
			btnVerstoesseUp:SetText("⮝")
			function btnVerstoesseUp:DoClick()
				net.Start("nws_yrp_violation_up")
				net.WriteEntity(ply)
				net.SendToServer()
			end

			local btnVerstoesseDn = createVGUI("YButton", content, 50, 50, 10, 1160)
			btnVerstoesseDn:SetText("⮟")
			function btnVerstoesseDn:DoClick()
				net.Start("nws_yrp_violation_dn")
				net.WriteEntity(ply)
				net.SendToServer()
			end

			local btnVerstoesse = createVGUI("YLabel", content, 450, 100, 60, 1110)
			function btnVerstoesse:Paint(pw, ph)
				hook.Run("YLabelPaint", self, pw, ph)
				btnVerstoesse:SetText(YRP:trans("LID_violations") .. ": " .. ply:GetYRPInt("int_violations", -1))
			end
		end

		if isInstructor then
			if promoteable then
				local btnPromote = createVGUI("YButton", content, 500, 50, 520, 1000)
				btnPromote:SetText(YRP:trans("LID_promote") .. ": " .. promoteName)
				function btnPromote:DoClick()
					net.Start("nws_yrp_promotePlayer")
					net.WriteString(tmpTargetCharID)
					net.SendToServer()
					if YRPPanelAlive(yrp_Interact, "yrp_Interact 1") then
						yrp_Interact:Close()
					end
				end

				function btnPromote:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end
			end

			if demoteable then
				local btnDemote = createVGUI("YButton", content, 500, 50, 520, 1000 + 10 + 50)
				btnDemote:SetText(YRP:trans("LID_demote") .. ": " .. demoteName)
				function btnDemote:DoClick()
					net.Start("nws_yrp_demotePlayer")
					net.WriteString(tmpTargetCharID)
					net.SendToServer()
					if YRPPanelAlive(yrp_Interact, "yrp_Interact 2") then
						yrp_Interact:Close()
					end
				end

				function btnDemote:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end
			end

			if not promoteable and not demoteable then
				local btnbtnInviteToGroup = createVGUI("YButton", content, 500, 50, 520, 1000)
				btnbtnInviteToGroup:SetText(YRP:trans("LID_invitetogroup"))
				function btnbtnInviteToGroup:DoClick()
					net.Start("nws_yrp_invitetogroup")
					net.WriteString(tmpTargetCharID)
					net.SendToServer()
					if YRPPanelAlive(yrp_Interact, "yrp_Interact 3") then
						yrp_Interact:Close()
					end
				end

				function btnbtnInviteToGroup:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph)
				end
			end
		end

		if hasspecs then
			local btnbtnSpecialization = createVGUI("YButton", content, 500, 50, 520, 1120)
			btnbtnSpecialization:SetText(YRP:trans("LID_specializations"))
			function btnbtnSpecialization:DoClick()
				if YRPPanelAlive(yrp_Interact, "yrp_Interact 4") then
					yrp_Interact:Close()
				end

				YRPOpenGiveSpec(tmpCharID, LocalPlayer():GetRoleUID())
			end

			function btnbtnSpecialization:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end

		yrp_Interact:Center()
		yrp_Interact:MakePopup()
	end
)

function YRPOpenGiveSpec(charid, ruid)
	charid = tonumber(charid)
	ruid = tonumber(ruid)
	local win = YRPCreateD("YFrame", nil, 600, 600, 0, 0)
	win:SetTitle("LID_specializations")
	win:Center()
	win:MakePopup()
	local content = win:GetContent()
	win.header = YRPCreateD("YLabel", content, 280, 50, 0, 0)
	win.header:SetText("LID_add")
	win.headerrem = YRPCreateD("YLabel", content, 280, 50, 300, 0)
	win.headerrem:SetText("LID_remove")
	win.dpl = YRPCreateD("DPanelList", content, 280, content:GetTall() - 50, 0, 50)
	win.dpl:EnableVerticalScrollbar()
	win.dpl:SetSpacing(2)
	function win.dpl:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 80))
	end

	win.dplrem = YRPCreateD("DPanelList", content, 280, content:GetTall() - 50, 300, 50)
	win.dplrem:EnableVerticalScrollbar()
	win.dplrem:SetSpacing(2)
	function win.dplrem:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 80))
	end

	net.Receive(
		"nws_yrp_get_role_specs",
		function(len)
			local nettab = net.ReadTable()
			if YRPPanelAlive(win, "win xx") and YRPPanelAlive(win.dpl, "win.dpl") then
				local ply = NULL
				for i, v in pairs(player.GetAll()) do
					if v:CharID() == charid then
						ply = v
						break
					end
				end

				local specids = {}
				if IsValid(ply) then
					specids = string.Explode(",", ply:GetYRPString("specializationIDs", ""))
					for i, v in pairs(specids) do
						specids[i] = tonumber(v)
					end
				end

				for i, v in pairs(nettab) do
					v.uid = tonumber(v.uid)
					if not table.HasValue(specids, v.uid) then
						local btn = YRPCreateD("YButton", nil, 250, 50, 0, 0)
						btn:SetText(v.name)
						function btn:Paint(pw, ph)
							hook.Run("YButtonAPaint", self, pw, ph)
						end

						function btn:DoClick()
							net.Start("nws_yrp_char_add_spec")
							net.WriteString(charid)
							net.WriteString(v.uid)
							net.WriteString(ruid)
							net.SendToServer()
							win:Close()
						end

						win.dpl:AddItem(btn)
					else
						local btn = YRPCreateD("YButton", nil, 250, 50, 0, 0)
						btn:SetText(v.name)
						function btn:Paint(pw, ph)
							hook.Run("YButtonRPaint", self, pw, ph)
						end

						function btn:DoClick()
							net.Start("nws_yrp_char_rem_spec")
							net.WriteString(charid)
							net.WriteString(v.uid)
							net.WriteString(ruid)
							net.SendToServer()
							win:Close()
						end

						win.dplrem:AddItem(btn)
					end
				end
			end
		end
	)

	if ruid then
		net.Start("nws_yrp_get_role_specs")
		net.WriteString(ruid)
		net.SendToServer()
	end
end

net.Receive(
	"nws_yrp_reopen_givespec",
	function()
		local charid = net.ReadString()
		local ruid = net.ReadString()
		YRPOpenGiveSpec(charid, ruid)
	end
)

net.Receive(
	"nws_yrp_invite_ply",
	function(len)
		local role = net.ReadTable()
		local group = net.ReadTable()
		local win = YRPCreateD("YFrame", nil, YRP:ctr(600), YRP:ctr(400), 0, 0)
		win:SetTitle("LID_invitation")
		win:Center()
		win:MakePopup()
		local content = win:GetContent()
		function content:Paint(pw, ph)
			local text = YRP:trans("LID_youwereinvited")
			draw.SimpleText(text .. ":", "Y_16_500", pw / 2, YRP:ctr(20), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(group.string_name, "Y_16_500", pw / 2, YRP:ctr(60), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(role.string_name, "Y_16_500", pw / 2, YRP:ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		win.accept = YRPCreateD("YButton", content, YRP:ctr(200), YRP:ctr(50), content:GetWide() / 2 - YRP:ctr(200 + 5), content:GetTall() - YRP:ctr(50 + 10))
		win.accept:SetText("LID_accept")
		function win.accept:DoClick()
			net.Start("nws_yrp_invite_accept")
			net.WriteTable(role)
			net.SendToServer()
			win:Close()
		end

		win.decline = YRPCreateD("YButton", content, YRP:ctr(200), YRP:ctr(50), content:GetWide() / 2 + YRP:ctr(5), content:GetTall() - YRP:ctr(50 + 10))
		win.decline:SetText("LID_decline")
		function win.decline:DoClick()
			win:Close()
		end
	end
)
