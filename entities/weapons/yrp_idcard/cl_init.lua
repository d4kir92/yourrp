
include("shared.lua")


function YDrawIDCards(ply)

	if ply:GetPos():Distance(LocalPlayer():GetPos()) < 400 and ply:GetActiveWeapon().ClassName == "yrp_idcard" then
		local ang = Angle(0, LocalPlayer():GetAngles().y - 270, 90)
		local sca = 0.01

		if ply:LookupBone("ValveBiped.Bip01_R_Finger1") then
			pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Finger1"))
		end

		cam.Start3D2D(pos + Vector(0, 0, 0) + ply:GetForward() * 2.6, ang, sca)

			draw.RoundedBox(0, 4, 0, 400, 200, Color(120, 120, 120)) -- Background

			draw.SimpleText(ply:GetFactionName(), "YRP_" .. 36 .. "_700", 4 + 10, 20, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			draw.RoundedBox(0, 4, 40, 400, 20, Color(255, 255, 255)) -- Line

			draw.SimpleText(ply:GetGroupName(), "YRP_" .. 36 .. "_700", 4 + 10, 75, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(ply:RPName(), "YRP_" .. 36 .. "_700", 4 + 10, 125, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(ply:GetDString("idcardid", ""), "YRP_" .. 36 .. "_700", 4 + 10, 175, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(YRP.GetDesignIcon("security"))
			surface.DrawTexturedRect(4 + 275, 75, 100, 100)

		cam.End3D2D()
	end
end

hook.Add("PostPlayerDraw", "yrp_draw_idcards", YDrawIDCards)