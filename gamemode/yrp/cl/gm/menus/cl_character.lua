--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function createMDBox(derma, parent, w, h, x, y, height, color)
	local tmpMD = vgui.Create(derma, parent)
	tmpMD:SetSize(w+height, h+height)
	tmpMD:SetPos(x, y)
	function tmpMD:Paint(pw, ph)
		--shadow
		draw.RoundedBox(0, height, height, pw-height, ph-height, Color(0, 0, 0, 100))

		--Box
		draw.RoundedBox(0, 0, 0, pw-height, ph-height, color)
	end
	return tmpMD
end

local _char_colors = {}
_char_colors.selected = Color(225, 225, 0, 255)
_char_colors.hovered = Color(0, 255, 0, 255)

function createMDPlus(parent, size, x, y, height)
	local w = size
	local h = w
	local tmpMD = vgui.Create("DButton", parent)
	tmpMD:SetSize(w+height, h+height)
	tmpMD:SetPos(x, y)
	function tmpMD:Paint(pw, ph)
		--shadow
		draw.RoundedBox(pw-height/2, height, height, pw-height, ph-height, Color(0, 0, 0, 100))

		--Button
		if tmpMD:IsHovered() then
			draw.RoundedBox(pw-height, 0, 0, pw-height, ph-height, get_dsbg_col()	)
		else
			draw.RoundedBox(pw-height, 0, 0, pw-height, ph-height, get_ds_col())
		end

		draw.SimpleTextOutlined("+", "HudBars", (pw-height)/2, (ph-height)/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	return tmpMD
end

function createMDButton(parent, w, h, x, y, height, text)
	local tmpMD = vgui.Create("DButton", parent)
	tmpMD:SetText("")
	tmpMD:SetSize(w, h)
	tmpMD:SetPos(x, y)
	function tmpMD:Paint(pw, ph)
		surfaceButton(self, pw, ph, text)
	end
	return tmpMD
end

function createMD(derma, parent, w, h, x, y, height)
	local tmpShadow = vgui.Create("DPanel", parent)
	tmpShadow:SetSize(w, h)
	tmpShadow:SetPos(x+height, y+height)
	function tmpShadow:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))
	end

	local tmpD = vgui.Create(derma, parent)
	tmpD:SetSize(w, h)
	tmpD:SetPos(x, y)
	tmpD.shadow = tmpShadow
	return tmpD
end

function paintMD(w, h, string, color)
	if string == nil then
		string = ""
	end
	draw.RoundedBox(0, 0, 0, w, h, color)
	draw.SimpleTextOutlined(string, "HudBars", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
end

local character = {}
character.amount = 0

function openCharacterCreation()
	openMenu()
	local ply = LocalPlayer()
	character.cause = YRP.lang_string("LID_enteraname")
	character.rpname = ""
	character.gender = "gendermale"
	character.groupID = 1
	character.roleID = 1
	character.hp = 0
	character.hpmax = 0
	character.ar = 0
	character.armax = 0
	character.salary = 0
	character.playermodels = {}
	character.playermodelID = 1
	character.skin = 1

	character.description = {}
	for i = 1, 6 do
		character.description[i] = ""
	end

	local frame = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:Center()
	function frame:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 250))
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 250))

		draw.SimpleTextOutlined(YRP.lang_string("LID_charactercreation") .. " [PROTOTYPE]", "HudHeader", pw/2, ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	function frame:OnClose()
		closeMenu()
	end
	function frame:OnRemove()
		closeMenu()
	end


	local identification = createD("DPanel", frame, ctr(800), ctr(360), ScrW() - ctr(800) - ctr(100), ScrH() - ctr(400) - ctr(100))
	function identification:Paint(pw, ph)
		draw.RoundedBox(ctr(15), 0, 0, pw, ph, Color(255, 255, 255, 255))

		draw.SimpleTextOutlined(YRP.lang_string("LID_identifycard"), "charText", ctr(10), ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(GetHostName(), "charText", ctr(10), ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined(ply:SteamID(), "charText", pw - ctr(10), ctr(10), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined(YRP.lang_string("LID_name"), "charText", ctr(256 + 20), ctr(130), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(character.rpname, "charText", ctr(256 + 20), ctr(130), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined(YRP.lang_string("LID_gender"), "charText", ctr(256 + 20), ctr(220), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string(character.gender), "charText", ctr(256 + 20), ctr(220), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

	end
	local avatar = createD("AvatarImage", identification, ctr(256), ctr(256), ctr(10), ctr(360 - 10 - 256))
	avatar:SetPlayer(ply)

	local border = ctr(50)
	local charactersBackground = createMD("DPanel", frame, ctr(800), ScrH() - (2*border), border, border, ctr(5))
	function charactersBackground:Paint(pw, ph)
		paintMD(pw, ph, nil, get_dp_col())
	end

	border = ctr(20)
	local data = {}
	data.w = ctr(800) - 2*border
	data.h = ctr(200)
	data.x = border
	data.y = border
	local charactersGender = createMD("DPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr(5))
	function charactersGender:Paint(pw, ph)
		paintMD(pw, ph, nil, get_ds_col())
		draw.SimpleTextOutlined(YRP.lang_string("LID_gender"), "HudBars", pw/2, ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	local charactersGenderMale = createMD("DButton", charactersGender, ctr(100), ctr(100), ctr((760/2)-50-100-20), ctr(70), ctr(5))
	charactersGenderMale:SetText("")
	function charactersGenderMale:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, _char_colors.hovered)
		else
			if character.gender == "gendermale" then
				draw.RoundedBox(0, 0, 0, pw, ph, _char_colors.selected)
			else
				draw.RoundedBox(0, 0, 0, pw, ph, get_dsbg_col())
			end
		end
		draw.SimpleTextOutlined("♂", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	function charactersGenderMale:DoClick()
		character.gender = "gendermale"
	end

	local charactersGenderFemale = createMD("DButton", charactersGender, ctr(100), ctr(100), ctr((760/2)-50), ctr(70), ctr(5))
	charactersGenderFemale:SetText("")
	function charactersGenderFemale:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, _char_colors.hovered)
		else
			if character.gender == "genderfemale" then
				draw.RoundedBox(0, 0, 0, pw, ph, _char_colors.selected)
			else
				draw.RoundedBox(0, 0, 0, pw, ph, get_dsbg_col())
			end
		end
		draw.SimpleTextOutlined("♀", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	function charactersGenderFemale:DoClick()
		character.gender = "genderfemale"
	end

	local charactersGenderOther = createMD("DButton", charactersGender, ctr(100), ctr(100), ctr((760/2)+50+20), ctr(70), ctr(5))
	charactersGenderOther:SetText("")
	function charactersGenderOther:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, _char_colors.hovered)
		else
			if character.gender == "genderother" then
				draw.RoundedBox(0, 0, 0, pw, ph, _char_colors.selected)
			else
				draw.RoundedBox(0, 0, 0, pw, ph, get_dsbg_col())
			end
		end
		draw.SimpleTextOutlined("⚲", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	function charactersGenderOther:DoClick()
		character.gender = "genderother"
	end

	data.x = border
	data.y = data.y + data.h + border
	data.w = ctr(800) - 2 * border
	data.h = ctr(140)
	local charactersGroup = createMD("DPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr(5))
	function charactersGroup:Paint(pw, ph)
		paintMD(pw, ph, nil, get_ds_col())
		draw.SimpleTextOutlined(YRP.lang_string("LID_group"), "HudBars", pw/2, ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	local charactersGroupCB = createMD("DComboBox", charactersGroup, ctr(600), ctr(50), ctr((760-600)/2), ctr(70), ctr(5))
	net.Start("charGetGroups")
	net.SendToServer()
	net.Receive("charGetGroups", function(len)
		local tmpTable = net.ReadTable()
		for k, v in pairs(tmpTable) do
			local selectChoice = false
			if tonumber(v.uniqueID) == tonumber(character.groupID) then
				selectChoice = true
			end
			if pa(charactersGroupCB) then
				charactersGroupCB:AddChoice(v.string_name, v.uniqueID, selectChoice)
			else
				break
			end
		end
	end)
	function charactersGroupCB:OnSelect(index, value, dat)
		character.groupID = tonumber(dat)
		net.Start("charGetRoles")
			net.WriteString(character.groupID)
		net.SendToServer()
	end

	data.x = border
	data.y = data.y + data.h + border
	data.w = ctr(800) - 2 * border
	data.h = ctr(740)
	local charactersRole = createMD("DPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr(5))
	function charactersRole:Paint(pw, ph)
		paintMD(pw, ph, nil, get_ds_col())
		draw.SimpleTextOutlined(YRP.lang_string("LID_role"), "HudBars", pw/2, ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_health") .. ": " .. character.hp .. "/" .. character.hpmax, "HudBars", ctr(10), ctr(160), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_armor") .. ": " .. character.ar .. "/" .. character.armax, "HudBars", ctr(10), ctr(220), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_salary") .. ": " .. character.salary, "HudBars", ctr(10), ctr(280), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(YRP.lang_string("LID_description") .. ":", "HudBars", ctr(10), ctr(340), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(character.description[1], "HudBars", ctr(10), ctr(400), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(character.description[2] , "HudBars", ctr(10), ctr(460), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(character.description[3], "HudBars", ctr(10), ctr(520), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(character.description[4], "HudBars", ctr(10), ctr(580), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(character.description[5], "HudBars", ctr(10), ctr(640), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		draw.SimpleTextOutlined(character.description[6], "HudBars", ctr(10), ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	local characterPlayermodel = createMD("DModelPanel", frame, ctr(1600), ctr(2160), ScrW2() - ctr(1600/2), ScrH2() - ctr(2160/2), ctr(5))
	characterPlayermodel.bodygroups = {}
	characterPlayermodel.cache = {}

	characterPlayermodel:SetAnimated(true)
	characterPlayermodel.Angles = Angle(0, 0, 0)

	function characterPlayermodel:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end
	function characterPlayermodel:DragMouseRelease() self.Pressed = false end

	function characterPlayermodel:LayoutEntity(ent)

		if (self.bAnimated) then self:RunAnimation() end

		if (self.Pressed) then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)

			self.PressX, self.PressY = gui.MousePos()
			if ent != nil then
				ent:SetAngles(self.Angles)
			end
		end
	end

	data.x = border
	data.y = data.y + data.h + border
	data.w = ctr(800) - 2*border
	data.h = ctr(740)
	local charactersBodygroups = createMD("DScrollPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr(5))
	function charactersBodygroups:Paint(pw, ph)
		paintMD(pw, ph, nil, get_ds_col())
		draw.SimpleTextOutlined(YRP.lang_string("LID_appearance"), "HudBars", pw/2, ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	local _skins = createD("DPanel", charactersBodygroups, ctr(600), ctr(100), ctr(10), ctr(60))
	function _skins:Paint(pw, ph)
		if characterPlayermodel.skin != nil and characterPlayermodel.skinmax != nil then
			draw.SimpleTextOutlined(YRP.lang_string("LID_skin") .. ": " .. characterPlayermodel.skin+1 .. "/" .. characterPlayermodel.skinmax+1, "HudBars", ctr(80), ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
	end

	character.bg = {}
	for i = 0, 20 do
		character.bg[i] = 0
	end

	function characterPlayermodel:UpdateBodyGroups()
		if characterPlayermodel.Entity != nil then
			self.skin = 0
			self.skinmax = characterPlayermodel.Entity:SkinCount() - 1
			self.bodygroups = characterPlayermodel.Entity:GetBodyGroups()

			for k, v in pairs(self.cache) do
				v:Remove()
			end
			for k, v in pairs(self.bodygroups) do

					self.cache[k] = createD("DPanel", charactersBodygroups, ctr(600), ctr(100), ctr(10), ctr(200 + (k-1)*110))
					local tmp = self.cache[k]
					tmp.count = 0
					tmp.countmax = v.num
					function tmp:Paint(pw, ph)
						draw.SimpleTextOutlined(v.name .. ": " .. self.count+1 .. "/" .. self.countmax, "HudBars", ctr(80), ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
					end
					local tmpUp = createD("DButton", tmp, ctr(50), ctr(50), ctr(0), ctr(0))
					tmpUp:SetText("")
					function tmpUp:Paint(pw, ph)
						local color = Color(100, 100, 100, 100)
						if tmp.count < tmp.countmax-1 then
							color = Color(255, 255, 255, 255)
						end
						draw.RoundedBox(0, 0, 0, pw, ph, color)
						draw.SimpleTextOutlined("↑", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
					end
					function tmpUp:DoClick()
						if tmp.count < tmp.countmax-1 then
							tmp.count = tmp.count + 1
						end
						v.value = tmp.count
						characterPlayermodel.bodygroups[v.id] = v.value
						character.bg[k-1] = v.value
						if characterPlayermodel.Entity != nil then
							characterPlayermodel.Entity:SetBodygroup(v.id, v.value)
						end
					end
					local tmpDown = createD("DButton", tmp, ctr(50), ctr(50), ctr(0), ctr(50))
					tmpDown:SetText("")
					function tmpDown:Paint(pw, ph)
						local color = Color(100, 100, 100, 100)
						if tmp.count > 0 then
							color = Color(255, 255, 255, 255)
						end
						draw.RoundedBox(0, 0, 0, pw, ph, color)
						draw.SimpleTextOutlined("↓", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
					end
					function tmpDown:DoClick()
						if tmp.count > 0 then
							tmp.count = tmp.count - 1
						end
						v.value = tmp.count
						characterPlayermodel.bodygroups[v.id] = v.value
						character.bg[k-1] = v.value
						if characterPlayermodel.Entity != nil then
							characterPlayermodel.Entity:SetBodygroup(v.id, v.value)
						end
					end

			end
		end
	end
	if character.playermodels[tonumber(character.playermodelID)] != nil then
		characterPlayermodel:SetModel(character.playermodels[tonumber(character.playermodelID)])
		characterPlayermodel.Entity:SetModelScale(character.playermodelsize)
		characterPlayermodel:UpdateBodyGroups()
	end

	local prevPM = createD("DButton", frame, ctr(100), ctr(1200), ScrW()/2 - ctr(50 + 800), ScrH() - ctr(1800))
	prevPM:SetText("")
	function prevPM:Paint(pw, ph)
		if tonumber(character.playermodelID) > 1 then
			if self:IsHovered() then
				paintMD(pw, ph, "<", get_dsbg_col())
			else
				paintMD(pw, ph, "<", get_ds_col())
			end
		end
	end
	function prevPM:DoClick()
		character.playermodelID = character.playermodelID - 1
		if tonumber(character.playermodelID) < 1 then
			character.playermodelID = 1
		end
		characterPlayermodel:SetModel(character.playermodels[tonumber(character.playermodelID)])
		if characterPlayermodel.Entity != nil then
			characterPlayermodel.Entity:SetModelScale(character.playermodelsize)
		end
		characterPlayermodel:UpdateBodyGroups()
	end

	local nextPM = createD("DButton", frame, ctr(100), ctr(1200), ScrW()/2 + ctr(-50 + 800), ScrH() - ctr(1800))
	nextPM:SetText("")
	function nextPM:Paint(pw, ph)
		if tonumber(character.playermodelID) < #character.playermodels then
			if self:IsHovered() then
				paintMD(pw, ph, ">", get_dsbg_col())
			else
				paintMD(pw, ph, ">", get_ds_col())
			end
		end
	end
	function nextPM:DoClick()
		if characterPlayermodel != nil then
			character.playermodelID = character.playermodelID + 1
			if tonumber(character.playermodelID) > #character.playermodels then
				character.playermodelID = #character.playermodels
			end
			characterPlayermodel:SetModel(character.playermodels[tonumber(character.playermodelID)])
			if characterPlayermodel.Entity != nil then
				characterPlayermodel.Entity:SetModelScale(character.playermodelsize)
			end
			characterPlayermodel:UpdateBodyGroups()
		end
	end

	local charactersRoleCB = createMD("DComboBox", charactersRole, ctr(600), ctr(50), ctr((760-600)/2), ctr(70), ctr(5))
	net.Receive("charGetRoles", function(len)
		charactersRoleCB:Clear()
		local tmpTable = net.ReadTable()
		for k, v in pairs(tmpTable) do
			local selectChoice = false
			if tonumber(v.uniqueID) == tonumber(character.roleID) then
				selectChoice = true
			end
			charactersRoleCB:AddChoice(v.string_name, v.uniqueID, selectChoice)
		end
	end)
	function charactersRoleCB:OnSelect(index, value, data)
		character.roleID = tonumber(data)
		net.Start("charGetRoleInfo")
			net.WriteString(character.roleID)
		net.SendToServer()

		net.Receive("charGetRoleInfo", function(len)
			local tmpTable = net.ReadTable()

			character.hp = tmpTable[1].int_hp
			character.hpmax = tmpTable[1].int_hpmax
			character.ar = tmpTable[1].int_ar
			character.armax = tmpTable[1].int_armax
			character.salary = tmpTable[1].int_salary
			character.description = tmpTable[1].string_description
			character.playermodels = string.Explode(",", tmpTable[1].string_playermodels)
			character.playermodelID = 1
			character.playermodelsize = tmpTable[1].int_playermodelsize or 1
			if character.playermodels[tonumber(character.playermodelID)] != nil then
				if characterPlayermodel != nil and characterPlayermodel != NULL then
					characterPlayermodel:SetModel(character.playermodels[tonumber(character.playermodelID)])
					if characterPlayermodel.Entity != nil then
						characterPlayermodel.Entity:SetModelScale(character.playermodelsize or 1)
					end
					characterPlayermodel:UpdateBodyGroups()
				end
			end
		end)
	end

	local skinUp = createD("DButton", charactersBodygroups, ctr(50), ctr(50), ctr(10), ctr(60))
	skinUp:SetText("↑")
	function skinUp:Paint(pw, ph)
		local color = Color(100, 100, 100, 100)
		if characterPlayermodel.Entity != nil then
			if characterPlayermodel.Entity:SkinCount()-1 > characterPlayermodel.Entity:GetSkin() then
				color = Color(255, 255, 255, 255)
			end
		end
		draw.RoundedBox(0, 0, 0, pw, ph, color)
		draw.SimpleTextOutlined("↑", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	function skinUp:DoClick()
		if characterPlayermodel.Entity != nil then
			if characterPlayermodel.Entity:SkinCount()-1 > characterPlayermodel.Entity:GetSkin() and characterPlayermodel.skin != nil then
				characterPlayermodel.skin = characterPlayermodel.skin + 1
				character.skin = characterPlayermodel.skin
				characterPlayermodel.Entity:SetSkin(characterPlayermodel.skin)
			end
		end
	end

	local skinDo = createD("DButton", charactersBodygroups, ctr(50), ctr(50), ctr(10), ctr(110))
	skinDo:SetText("↓")
	function skinDo:Paint(pw, ph)
		local color = Color(100, 100, 100, 100)
		if characterPlayermodel.Entity != nil then
			if characterPlayermodel.Entity:GetSkin() > 0 then
				color = Color(255, 255, 255, 255)
			end
		end
		draw.RoundedBox(0, 0, 0, pw, ph, color)
		draw.SimpleTextOutlined("↓", "HudBars", pw/2, ph/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
	function skinDo:DoClick()
		if characterPlayermodel.Entity != nil then
			if characterPlayermodel.Entity:GetSkin() > 0 then
				characterPlayermodel.skin = characterPlayermodel.skin - 1
				character.skin = characterPlayermodel.skin
				characterPlayermodel.Entity:SetSkin(characterPlayermodel.skin)
			end
		end
	end

	local charactersNameText = createMD("DTextEntry", frame, ctr(600), ctr(100), ScrW2() - ctr(600/2), ScrH() - ctr(100+50), ctr(5))
	charactersNameText:SetText(character.rpname)
	function charactersNameText:OnTextChanged()
		character.rpname = charactersNameText:GetValue()
	end

	YRP.DChangeLanguage(frame, BScrW() - ctr(100 + 10), ctr(10), ctr(100))

	if character.amount > 0 then
		local button = {}
		button.w = ctr(400)
		button.h = ctr(100)
		button.x = ScrW2() - ctr(400 + 300 + 50)
		button.y = ScrH() - ctr(100+50)
		local charactersBack = createMD("DButton", frame, button.w, button.h, button.x, button.y, ctr(10))
		charactersBack:SetText("")
		function charactersBack:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_back"))
		end
		function charactersBack:DoClick()
			frame:Close()

			openCharacterSelection()
		end
	end

	local button = {}
	button.w = ctr(600)
	button.h = ctr(100)
	button.x = ScrW2() + ctr(300+50)
	button.y = ScrH() - ctr(100+50)
	local charactersConfirm = createMD("DButton", frame, button.w, button.h, button.x, button.y, ctr(10))
	charactersConfirm:SetText("")
	function testName()
		if string.len(character.rpname) >= 3 then
			if string.len(character.rpname) < 33 then
				character.cause = "OK"
				return true
			else
				character.cause = YRP.lang_string("LID_nameistolong")
				return false
			end
		else
			character.cause = YRP.lang_string("LID_nameistoshort")
			return false
		end
	end
	function charactersConfirm:Paint(pw, ph)
		local text = "Fill out more"
		local color = Color(255, 255, 0, 255)
		if testName() then
			text = YRP.lang_string("LID_confirm")
			color = get_dp_col()
		else
			text = character.cause
		end
		surfaceButton(self, pw, ph, YRP.lang_string(text))
	end
	function charactersConfirm:DoClick()
		if testName() then
			frame:Close()

			openCharacterSelection()

			net.Start("CreateCharacter")
				net.WriteTable(character)
			net.SendToServer()
		end
	end

	frame:MakePopup()
end

local _cs = {}

function toggleCharacterSelection()
	if isNoMenuOpen() then
		openCharacterSelection()
	else
		closeCharacterSelection()
	end
end

function closeCharacterSelection()
	if _cs.frame != nil then
		closeMenu()
		_cs.frame:Remove()
		_cs.frame = nil
	end
end

local curChar = "-1"
local _cur = ""
function openCharacterSelection()
	if true then
		openMenu()
		local ply = LocalPlayer()

		local cache = {}

		_cs.frame = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
		_cs.frame:SetTitle("")
		_cs.frame:ShowCloseButton(false)
		_cs.frame:SetDraggable(false)
		_cs.frame:Center()
		function _cs.frame:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 254))

			draw.SimpleTextOutlined(YRP.lang_string("LID_characterselection") .. " [PROTOTYPE]", "HudHeader", pw/2, ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(_cur, "HudHeader", pw/2, ctr(110), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
		function _cs.frame:OnClose()
			closeMenu()
		end
		function _cs.frame:OnRemove()
			closeMenu()
		end

		local _close = createD("DButton", _cs.frame, ctr(50), ctr(50), BScrW() - ctr(60), ctr(10))
		_close:SetText("")
		function _close:Paint(pw, ph)
			surfaceButton(self, pw, ph, "X")
		end
		function _close:DoClick()
			closeCharacterSelection()
		end

		local feedback = createD("DButton", _cs.frame, ctr(500), ctr(50), BScrW() - ctr(510), ScrH() - ctr(60))
		feedback:SetText("")
		function feedback:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_givefeedback"))
		end
		function feedback:DoClick()
			closeCharacterSelection()
			openFeedbackMenu()
		end

		YRP.DChangeLanguage(_cs.frame, BScrW() - ctr(100 + 10 + 50 + 10), ctr(10), ctr(100))

		local border = ctr(50)
		local charactersBackground = createD("DPanel", _cs.frame, ctr(800), ScrH() - (2*border), (ScrW() - BScrW())/2 + border, border)
		charactersBackground.text = YRP.lang_string("LID_siteisloading")
		function charactersBackground:Paint(pw, ph)
			paintMD(pw, ph, nil, get_dp_col())
			draw.SimpleTextOutlined(self.text, "HudHeader", pw/2, ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr(1), Color(0, 0, 0, 255))
		end

		local charplayermodel = createD("DModelPanel", _cs.frame, ScrH() - ctr(200), ScrH() - ctr(200), ScrW2() - (ScrH() - ctr(200))/2, 0)
		charplayermodel:SetModel("models/player/skeleton.mdl")
		charplayermodel:SetAnimated(true)
		charplayermodel.Angles = Angle(0, 0, 0)
		charplayermodel:RunAnimation()

		function charplayermodel:DragMousePress()
			self.PressX, self.PressY = gui.MousePos()
			self.Pressed = true
		end
		function charplayermodel:DragMouseRelease() self.Pressed = false end

		function charplayermodel:LayoutEntity(ent)

			if (self.bAnimated) then self:RunAnimation() end

			if (self.Pressed) then
				local mx, my = gui.MousePos()
				self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)

				self.PressX, self.PressY = gui.MousePos()
				if ent != nil then
					ent:SetAngles(self.Angles)
				end
			end
		end

		local characterList = createD("DScrollPanel", charactersBackground, ctr(800), ScrH() - (2*border), 0, 0)

		net.Receive("yrp_get_characters", function(len)
			printGM("gm", "received characterlist")
			local _characters = net.ReadTable()

			if pa(charactersBackground) then
				charactersBackground.text = ""
				if _characters != nil and pa(_characters) then
					character.amount = #_characters or 0

					if #_characters < 1 then
						if pa(_cs.frame) then
							_cs.frame:Close()
						end
						openCharacterCreation()
						return false
					end
					local y = 0
					for k, v in pairs(cache) do
						if v.tmpChar.shadow != nil then
							v.tmpChar.shadow:Remove()
						end
						v.tmpChar:Remove()
					end
					for i = 1, #_characters do
						if _characters[i].char != nil then
							cache[i] = {}
							cache[i].tmpChar = createMD("DButton", characterList, ctr(800-20), ctr(200), ctr(10), ctr(10) + y * ctr(200) + y * ctr(10), ctr(5))
							local tmpChar = cache[i].tmpChar
							tmpChar:SetText("")

							_characters[i].char = _characters[i].char or {}
							_characters[i].role = _characters[i].role or {}
							_characters[i].group = _characters[i].group or {}
							_characters[i].faction = _characters[i].faction or {}

							tmpChar.charid = _characters[i].char.uniqueID or "UID INVALID"
							tmpChar.rpname = _characters[i].char.rpname or "RPNAME INVALID"
							tmpChar.rolename = _characters[i].role.string_name or "ROLE INVALID"
							tmpChar.factionID = _characters[i].faction.string_name or "FACTION INVALID"
							tmpChar.groupID = _characters[i].group.string_name or "GROUP INVALID"
							tmpChar.map = _characters[i].char.map
							tmpChar.playermodelID = _characters[i].char.playermodelID

							tmpChar.playermodels = string.Explode(",", _characters[i].role.string_playermodels) or {}
							if tmpChar.playermodels == "" or tmpChar.playermodels == " " then
								tmpChar.playermodels = {}
							end

							tmpChar.playermodelsize = _characters[i].role.playermodelsize
							tmpChar.skin = _characters[i].char.skin
							tmpChar.bg0 = _characters[i].char.bg0 or 0
							tmpChar.bg1 = _characters[i].char.bg1 or 0
							tmpChar.bg2 = _characters[i].char.bg2 or 0
							tmpChar.bg3 = _characters[i].char.bg3 or 0
							tmpChar.bg4 = _characters[i].char.bg4 or 0
							tmpChar.bg5 = _characters[i].char.bg5 or 0
							tmpChar.bg6 = _characters[i].char.bg6 or 0
							tmpChar.bg7 = _characters[i].char.bg7 or 0
							tmpChar.bg8 = _characters[i].char.bg8 or 0
							tmpChar.bg9 = _characters[i].char.bg9 or 0
							tmpChar.bg10 = _characters[i].char.bg10 or 0
							tmpChar.bg11 = _characters[i].char.bg11 or 0
							tmpChar.bg12 = _characters[i].char.bg12 or 0
							tmpChar.bg13 = _characters[i].char.bg13 or 0
							tmpChar.bg14 = _characters[i].char.bg14 or 0
							tmpChar.bg15 = _characters[i].char.bg15 or 0
							tmpChar.bg16 = _characters[i].char.bg16 or 0
							tmpChar.bg17 = _characters[i].char.bg17 or 0
							tmpChar.bg18 = _characters[i].char.bg18 or 0
							tmpChar.bg19 = _characters[i].char.bg19 or 0

							tmpChar.grp = YRP.lang_string("LID_level") .. " 1 " .. tmpChar.rolename
							if tmpChar.groupID == tmpChar.factionID then
								tmpChar.grp = tmpChar.grp .. " [" .. tmpChar.factionID .. "]"
							else
								tmpChar.grp = tmpChar.grp .. " " .. tmpChar.groupID .. " [" .. tmpChar.factionID .. "]"
							end

							function tmpChar:Paint(pw, ph)
								if tmpChar:IsHovered() then
									paintMD(pw, ph, nil, Color(255, 255, 0, 255))
								else
									paintMD(pw, ph, nil, get_ds_col())
								end
								if curChar == self.charid then
									paintMD(pw, ph, nil, Color(255, 255, 100, 255))
									local _br = 4
									local _w = 50
									local _h = 10
									draw.RoundedBox(0, ctr(_br), ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
									draw.RoundedBox(0, ctr(_br), ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))

									draw.RoundedBox(0, ctr(_br), ph - ctr(_h) - ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
									draw.RoundedBox(0, ctr(_br), ph - ctr(_w) - ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))

									draw.RoundedBox(0, pw - ctr(_w) - ctr(_br), ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
									draw.RoundedBox(0, pw - ctr(_h) - ctr(_br), ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))

									draw.RoundedBox(0, pw - ctr(_w) - ctr(_br), ph - ctr(_h) - ctr(_br), ctr(_w), ctr(_h), Color(0, 0, 0, 255))
									draw.RoundedBox(0, pw - ctr(_h) - ctr(_br), ph - ctr(_w) - ctr(_br), ctr(_h), ctr(_w), Color(0, 0, 0, 255))
								end
								draw.SimpleTextOutlined(self.rpname, "HudBars", ctr(30), ctr(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
								draw.SimpleTextOutlined(self.grp, "HudBars", ctr(30), ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
								draw.SimpleTextOutlined(self.map, "HudBars", ctr(30), ctr(155), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
							end
							function tmpChar:DoClick()
								curChar = self.charid
								_cur = self.rpname
								if self.playermodels != nil and self.playermodelID != nil then
									local _playermodel = self.playermodels[tonumber(self.playermodelID)] or nil
									if _playermodel != nil and charplayermodel != NULL and pa(charplayermodel) then
										if _playermodel != "" and _playermodel != " " then
											charplayermodel:SetModel(_playermodel)
										else
											charplayermodel:SetModel("models/player/skeleton.mdl")
										end
										if charplayermodel.Entity != nil then
											charplayermodel.Entity:SetModelScale(self.playermodelsize or 1)
											charplayermodel.Entity:SetSkin(self.skin)
											for bgx = 0, 19 do
												charplayermodel.Entity:SetBodygroup(bgx, self["bg" .. bgx])
											end
										end
									end
								else
									printGM("note", "Character role has no playermodel!")
								end
							end

							if _characters[i].char.uniqueID == _characters.plytab.CurrentCharacter then
								curChar = tmpChar.charid
								tmpChar:DoClick()
							end
							y = y + 1
						end
					end
				end
			end
		end)

		printGM("gm", "ask for characterlist")
		timer.Simple(0.1, function()
			net.Start("yrp_get_characters")
			net.SendToServer()
		end)

		local deleteChar = createMD("DButton", _cs.frame, ctr(400), ctr(100), ScrW2() - ctr(400 + 800/2 + 10), ScrH() - ctr(150), ctr(5))
		deleteChar:SetText("")
		function deleteChar:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_deletecharacter"), Color(255, 0, 0))
		end
		function deleteChar:DoClick()
			local _window = createVGUI("DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0)
			_window:Center()
			_window:SetTitle(YRP.lang_string("LID_areyousure"))

			local _yesButton = createVGUI("DButton", _window, 200, 50, 10, 60)
			_yesButton:SetText(YRP.lang_string("LID_yes"))
			function _yesButton:DoClick()

				net.Start("DeleteCharacter")
					net.WriteString(curChar)
				net.SendToServer()

				_window:Close()
			end

			local _noButton = createVGUI("DButton", _window, 200, 50, 10 + 200 + 10, 60)
			_noButton:SetText(YRP.lang_string("LID_no"))
			function _noButton:DoClick()
				_window:Close()
			end

			_window:MakePopup()
		end

	--[[
		local backB = createMD("DButton", _cs.frame, ctr(400), ctr(100), ScrW2() + ctr(800/2 + 10), ScrH() - ctr(150), ctr(5))
		backB:SetText("")
		function backB:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("LID_back"))
		end
		function backB:DoClick()
			if curChar != "-1" then
				if _cs.frame != nil then
					_cs.frame:Close()
				end
			end
		end
	]]--

		local button = {}
		button.size = ctr(100)
		button.x = ctr(720)
		button.y = ScrH() - button.size - border - ctr(30)
		local charactersCreate = createMDPlus(_cs.frame, button.size, button.x, button.y, ctr(5))
		charactersCreate:SetText("")
		function charactersCreate:DoClick()
			_cs.frame:Close()

			openCharacterCreation()
		end

		button.w = ctr(800)
		button.h = ctr(100)
		button.x = ScrW2() - button.w/2
		button.y = ScrH() - button.h - border
		local confirmColor = Color(255, 0, 0, 255)
		local charactersEnter = createMDButton(_cs.frame, button.w, button.h, button.x, button.y, ctr(0), YRP.lang_string("LID_enterworld"))
		function charactersEnter:Paint(pw, ph)
			local text = YRP.lang_string("LID_enterworld") .. " (" .. _cur .. ")"
			if LocalPlayer() != nil then
				if LocalPlayer():Alive() then
					text = YRP.lang_string("LID_suicide") .. " (" .. LocalPlayer():RPName() .. ")"
				end
			end
			surfaceButton(self, pw, ph, YRP.lang_string(text))
		end

		charactersEnter:SetText("")
		function charactersEnter:DoClick()
			if LocalPlayer() != nil then
				if curChar != "-1" then
					if LocalPlayer():Alive() then
						net.Start("LogOut")
						net.SendToServer()
					else
						net.Start("EnterWorld")
							net.WriteString(curChar)
						net.SendToServer()
						_cs.frame:Close()
					end
				end
			end
		end

		_cs.frame:MakePopup()
	end
end

net.Receive("openCharacterMenu", function(len, ply)
	local tmpTable = net.ReadTable()

	--timer.Create("yrp_open_character_selection", 1, 0, function()
		--if playerfullready == true and isNoMenuOpen() then
			openCharacterSelection()
			--timer.Remove("yrp_open_character_selection")
		--end
	--end)

end)
