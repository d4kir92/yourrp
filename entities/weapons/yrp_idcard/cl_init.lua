
include("shared.lua")

local logos = {}
local mats = {}

function YDrawIDCards(ply)
	if ply:GetPos():Distance(LocalPlayer():GetPos()) < 400 and ply:GetActiveWeapon().ClassName == "yrp_idcard" then
		local ang = Angle(0, ply:EyeAngles().y - 270, ply:EyeAngles().p + 90)
		local sca = 0.01

		local correction = 3
		if ply:LookupBone("ValveBiped.Bip01_R_Hand") then
			pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Hand"))
			correction = 6
		end

		cam.Start3D2D(pos + ply:EyeAngles():Forward() * correction, ang, sca)

			local elements = {
				"background",
				"hostname",
				"role",
				"group",
				"idcardid",
				"faction",
				"rpname",
				"box1",
				"box2",
				"box3",
				"box4",
				--"grouplogo",
				"serverlogo"
			}

			for i, ele in pairs(elements) do
				if GetGlobalDBool("bool_" .. ele .. "_visible", false) then
					local w = GetGlobalDInt("int_" .. ele .. "_w", 100)
					local h = GetGlobalDInt("int_" .. ele .. "_h", 100)

					local x = GetGlobalDInt("int_" .. ele .. "_x", 0)
					local y = GetGlobalDInt("int_" .. ele .. "_y", 0)

					local color = {}
					color.r = GetGlobalDInt("int_" .. ele .. "_r", 0)
					color.g = GetGlobalDInt("int_" .. ele .. "_g", 0)
					color.b = GetGlobalDInt("int_" .. ele .. "_b", 0)
					color.a = GetGlobalDInt("int_" .. ele .. "_a", 0)

					local ax = GetGlobalDInt("int_" .. ele .. "_ax", 0)
					local ay = GetGlobalDInt("int_" .. ele .. "_ay", 0)

					if !string.find(ele, "logo") then
						if string.find(ele, "background") or string.find(ele, "box") then
							draw.RoundedBox(0, x, y, w, h, color)
						else
							local text = "LOAD"
							if ele == "hostname" then
								text = GetGlobalDString("text_server_name", "")
							elseif ele == "role" then
								text = ply:GetRoleName()
							elseif ele == "rpname" then
								text = ply:RPName()
							elseif ele == "faction" then
								text = ply:GetFactionName()
							elseif ele == "group" then
								text = ply:GetGroupName()
							elseif ele == "idcardid" then
								text = ply:GetDString("idcardid", "")
							end

							local tx = 0
							local ty = 0
							if ax == 0 then
								tx = x
							elseif ax == 1 then
								tx = x + w / 2
							elseif ax == 2 then
								tx = x + w
							end
							if ay == 0 then
								ay = 3
								ty = y
							elseif ay == 1 then
								ty = y + h / 2
							elseif ay == 2 then
								ay = 4
								ty = y + h
							end
							color.a = 255
							draw.SimpleText(text, "YRP_48_500", tx, ty, color, ax, ay)
						end
					else
						if logos[ele] == nil then
							logos[ele] = true
							local size = 64
							ply.html = createD("DHTML", nil, size, size, 0, 0)
							ply.html:SetHTML(GetHTMLImage(GetGlobalDString("text_server_logo", ""), size, size))
							function ply.html:Paint(pw, ph)
								if pa(ply.html) then
									ply.htmlmat = ply.html:GetHTMLMaterial()
									if ply.htmlmat != nil and !ply.html.found then
										ply.html.found = true
										timer.Simple(0.1, function()
											ply.matname = ply.htmlmat:GetName()
											local matdata =	{
												["$basetexture"] = ply.matname,
												["$translucent"] = 1,
												["$model"] = 1
											}
											local uid = string.Replace(ply.matname, "__vgui_texture_", "")
											mats[ele] = CreateMaterial("WebMaterial_" .. uid, "VertexLitGeneric", matdata)
											ply.html:Remove()
										end)
									end
								end
							end
						end
						if mats[ele] != nil then
							surface.SetDrawColor(color)
							surface.SetMaterial(mats[ele])
							surface.DrawTexturedRect(x, y, w, h)
						end
					end
				end
			end

		cam.End3D2D()
	end
end

hook.Add("PostPlayerDraw", "yrp_draw_idcards", YDrawIDCards)