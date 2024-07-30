-- Group Menu
function YRPGetCharStatusByName(name)
	for i, v in pairs(player.GetAll()) do
		if v:RPName() == name then return "Online" end
	end

	return "Offline"
end

function YRPGetCharIsInstructorByName(name)
	for i, v in pairs(player.GetAll()) do
		if v:RPName() == name then return v:GetYRPBool("isInstructor") end
	end

	return false
end

function YRPGetCharIsInstructorTextByName(name)
	local isInstructor = YRPGetCharIsInstructorByName(name)
	if isInstructor then return YRP:trans("LID_yes") end

	return YRP:trans("LID_no")
end

local GMENU = nil
function YRPToggleGroupMenu()
	if IsValid(GMENU) then
		YRPCloseMenu()
		GMENU:Remove()
	elseif YRPIsNoMenuOpen() then
		YRPOpenMenu()
		GMENU = YRPCreateD("YFrame", nil, 600, 600, 0, 0)
		GMENU:SetTitle(string.format("%s: %s", YRP:trans("LID_group"), LocalPlayer():GetGroupName()))
		GMENU:Center()
		GMENU:MakePopup()
		GMENU:SetSizable(true)
		-- LEFT
		GMENU.left = YRPCreateD("DPanel", GMENU, 200, 300, 0, 0)
		GMENU.left:Dock(FILL)
		function GMENU.left:Paint(pw, ph)
		end

		if LocalPlayer():GetYRPBool("isInstructor") then
			GMENU.invite = YRPCreateD("YButton", GMENU.left, 36, 30, 0, 0)
			GMENU.invite:Dock(TOP)
			GMENU.invite:SetText("LID_invitetogroup")
			function GMENU.invite:DoClick()
				local win = YRPCreateD("YFrame", nil, 400, 500, 0, 0)
				win:SetTitle("LID_invitetogroup")
				win:Center()
				win:MakePopup()
				win:SetSizable(true)
				win.listheader = YRPCreateD("YLabel", win, 36, 30, 0, 0)
				win.listheader:Dock(TOP)
				win.listheader:DockMargin(0, 5, 0, 0)
				win.listheader:SetText("LID_players")
				win.listheader.rad = 0
				win.list = YRPCreateD("DScrollPanel", win, 36, 30, 0, 0)
				win.list:Dock(FILL)
				function win.list:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
				end

				local sbar = win.list.VBar
				function sbar:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
				end

				function sbar.btnUp:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
				end

				function sbar.btnDown:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
				end

				function sbar.btnGrip:Paint(w, h)
					draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
				end

				for i, v in pairs(player.GetAll()) do
					if LocalPlayer():GetGroupUID() ~= v:GetGroupUID() then
						local inv = YRPCreateD("YButton", win.list, 30, 30, 0, 0)
						inv:Dock(TOP)
						inv:SetText(v:RPName())
						function inv:DoClick()
							net.Start("nws_yrp_invitetogroup")
							net.WriteString(v:CharID())
							net.SendToServer()
							win:Remove()
						end
					end
				end
			end
		end

		GMENU.listheader = YRPCreateD("YLabel", GMENU.left, 36, 30, 0, 0)
		GMENU.listheader:Dock(TOP)
		if LocalPlayer():GetYRPBool("isInstructor") then
			GMENU.listheader:DockMargin(0, 5, 0, 0)
		end

		GMENU.listheader:SetText("LID_members")
		GMENU.listheader.rad = 0
		GMENU.list = YRPCreateD("DScrollPanel", GMENU.left, 36, 30, 0, 0)
		GMENU.list:Dock(FILL)
		function GMENU.list:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20))
		end

		local sbar = GMENU.list.VBar
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
		end

		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end

		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end

		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
		end

		-- RIGHT
		GMENU.right = YRPCreateD("DPanel", GMENU, 300, 300, 0, 0)
		GMENU.right:Dock(RIGHT)
		GMENU.right:DockMargin(5, 0, 0, 0)
		function GMENU.right:Paint(pw, ph)
		end

		--
		GMENU.membername = YRPCreateD("YLabel", GMENU.right, 36, 30, 0, 0)
		GMENU.membername:Dock(TOP)
		GMENU.membername:SetText("LID_member")
		GMENU.membername:Hide()
		GMENU.memberstatus = YRPCreateD("YLabel", GMENU.right, 36, 30, 0, 0)
		GMENU.memberstatus:Dock(TOP)
		GMENU.memberstatus:DockMargin(0, 5, 0, 0)
		GMENU.memberstatus:SetText("LID_status")
		GMENU.memberstatus:Hide()
		GMENU.memberrole = YRPCreateD("YLabel", GMENU.right, 36, 30, 0, 0)
		GMENU.memberrole:Dock(TOP)
		GMENU.memberrole:DockMargin(0, 5, 0, 0)
		GMENU.memberrole:SetText("LID_role")
		GMENU.memberrole:Hide()
		GMENU.instructor = YRPCreateD("YLabel", GMENU.right, 36, 30, 0, 0)
		GMENU.instructor:Dock(TOP)
		GMENU.instructor:DockMargin(0, 5, 0, 0)
		GMENU.instructor:SetText("LID_instructor")
		GMENU.instructor:Hide()
		GMENU.specsinfo = YRPCreateD("DScrollPanel", GMENU.right, 36, 120, 0, 0)
		GMENU.specsinfo:Dock(TOP)
		GMENU.specsinfo:DockMargin(0, 15, 0, 0)
		GMENU.specsinfo:SetPadding(-10)
		GMENU.specs = YRPCreateD("YButton", GMENU.right, 36, 30, 0, 0)
		GMENU.specs:Dock(BOTTOM)
		GMENU.specs:DockMargin(0, 5, 0, 0)
		GMENU.specs:SetText("LID_specializations")
		GMENU.specs:Hide()
		function GMENU.specs:DoClick()
			if GMENU.charid then
				YRPOpenGiveSpec(GMENU.charid, LocalPlayer():GetRoleUID())
			end
		end

		GMENU.demote = YRPCreateD("YButton", GMENU.right, 36, 30, 0, 0)
		GMENU.demote:Dock(BOTTOM)
		GMENU.demote:DockMargin(0, 5, 0, 0)
		GMENU.demote:SetText("LID_demote")
		GMENU.demote:Hide()
		function GMENU.demote:DoClick()
			if GMENU.charid then
				net.Start("nws_yrp_demotePlayer")
				net.WriteString(GMENU.charid)
				net.SendToServer()
			end
		end

		GMENU.promote = YRPCreateD("YButton", GMENU.right, 36, 30, 0, 0)
		GMENU.promote:Dock(BOTTOM)
		GMENU.promote:DockMargin(0, 5, 0, 0)
		GMENU.promote:SetText("LID_promote")
		GMENU.promote:Hide()
		function GMENU.promote:DoClick()
			if GMENU.charid then
				net.Start("nws_yrp_promotePlayer")
				net.WriteString(GMENU.charid)
				net.SendToServer()
			end
		end

		net.Receive(
			"nws_yrp_group_getmember",
			function(len)
				local char = net.ReadTable()
				char.uniqueID = tonumber(char.uniqueID)
				if IsValid(GMENU) then
					GMENU.charid = char.uniqueID
					GMENU.membername:SetText(string.format("%s: %s", YRP:trans("LID_name"), char.name))
					GMENU.membername:Show()
					GMENU.memberstatus:SetText(string.format("%s: %s", YRP:trans("LID_status"), YRPGetCharStatusByName(char.name)))
					GMENU.memberstatus:Show()
					GMENU.memberrole:SetText(string.format("%s: %s", YRP:trans("LID_role"), char.roleName))
					GMENU.memberrole:Show()
					GMENU.instructor:SetText(string.format("%s: %s", YRP:trans("LID_isinstructor"), YRPGetCharIsInstructorTextByName(char.name)))
					GMENU.instructor:Show()
					GMENU.specsinfo:Clear()
					local headline = YRPCreateD("YLabel", GMENU.specsinfo, 36, 30, 0, 0)
					headline:SetText(YRP:trans("LID_specializations") .. ":")
					headline:Dock(TOP)
					headline:DockMargin(0, 5, 0, 0)
					GMENU.specsinfo:AddItem(headline)
					for i, v in pairs(char.specs) do
						local line = YRPCreateD("YLabel", GMENU.specsinfo, 36, 30, 0, 0)
						line:SetText(v)
						line:Dock(TOP)
						line:DockMargin(0, 5, 0, 0)
						GMENU.specsinfo:AddItem(line)
					end

					if char.canspecs then
						GMENU.specs:Show()
					else
						GMENU.specs:Hide()
					end

					if char.candemote then
						GMENU.demote:Show()
					else
						GMENU.demote:Hide()
					end

					if char.uniqueID ~= LocalPlayer():CharID() then
						if char.canpromote then
							GMENU.promote:Show()
						else
							GMENU.promote:Hide()
						end
					else
						GMENU.promote:Hide()
					end
				end
			end
		)

		net.Receive(
			"nws_yrp_group_getmembers",
			function(len)
				local members = net.ReadTable()
				if IsValid(GMENU) then
					GMENU.list:Clear()
					for i, v in pairs(members) do
						if IsValid(GMENU) and v.rpname ~= "ID_RPNAME" and v.rpname ~= "BOTNAME" then
							v.uniqueID = tonumber(v.uniqueID)
							local plline = YRPCreateD("YPanel", GMENU.list, 30, 30, 0, 0)
							plline:Dock(TOP)
							plline:DockMargin(0, 0, 0, 2)
							plline.pl = YRPCreateD("YButton", plline, 30, 30, 0, 0)
							plline.pl:Dock(FILL)
							plline.pl:SetText(v.rpname)
							plline.pl.rad = 0
							function plline.pl:DoClick()
								net.Start("nws_yrp_group_getmember")
								net.WriteUInt(v.uniqueID, 24)
								net.SendToServer()
							end

							if LocalPlayer():GetYRPBool("isInstructor") and LocalPlayer():CharID() ~= v.uniqueID then
								plline.del = YRPCreateD("YButton", plline, 30, 30, 0, 0)
								plline.del:Dock(RIGHT)
								plline.del:SetText("X")
								function plline.del:Paint(pw, ph)
									local color = Color(200, 160, 160, 255)
									if self:IsHovered() then
										color = Color(200, 0, 0, 255)
									end

									draw.RoundedBox(0, 0, 0, pw, ph, color)
									if YRP:GetDesignIcon("64_trash") then
										surface.SetMaterial(YRP:GetDesignIcon("64_trash"))
										surface.SetDrawColor(Color(255, 255, 255, 255))
										surface.DrawTexturedRect(pw * 0.25, ph * 0.25, pw * 0.5, ph * 0.5)
									end
								end

								function plline.del:DoClick()
									net.Start("nws_yrp_group_delmember")
									net.WriteUInt(v.uniqueID, 24)
									net.SendToServer()
								end
							end
						end
					end
				end
			end
		)

		net.Start("nws_yrp_group_getmembers")
		net.SendToServer()
	end
end
