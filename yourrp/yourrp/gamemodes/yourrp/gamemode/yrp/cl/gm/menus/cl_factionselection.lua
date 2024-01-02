--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local config = {}
-- CONFIG --
-- List Width
config.w = 2500
-- List Height
config.h = 1400
-- BR
config.br = 20
-- CONFIG --
function CreateFactionSelectionContent()
	local lply = LocalPlayer()
	local parent = CharacterMenu or RoleMenu
	local nw = YRP.ctr(config.w)
	local nh = YRP.ctr(config.h)
	if not LocalPlayer().cc then
		nw = parent:GetWide()
		nh = parent:GetTall()
	end

	local site = YRPCreateD("DPanel", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	function site:Paint(pw, ph)
	end

	-- List of Factions
	local lis = YRPCreateD("DScrollPanel", site, nw, nh, 0, 0)
	lis:Center()
	function lis:Paint(pw, ph)
	end

	--draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue( "YFrame", "NC" ) )
	local sbar = lis:GetVBar()
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

	-- for Character Creation
	if LocalPlayer().cc then
		local header = YRPCreateD("DPanel", site, YRP.ctr(1000), YRP.ctr(100), site:GetWide() / 2 - YRP.ctr(500), YRP.ctr(200))
		function header:Paint(pw, ph)
			draw.SimpleText(YRP.trans("LID_chooseyourfaction"), "Y_36_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = {}
		btn.w = 500
		btn.h = 75
		local back = YRPCreateD("YButton", site, YRP.ctr(btn.w), YRP.ctr(btn.h), site:GetWide() / 2 - YRP.ctr(btn.w) / 2, ScH() - YRP.ctr(200))
		back:SetText("LID_back")
		function back:Paint(pw, ph)
			if LocalPlayer():GetYRPInt("char_count", 0) > 0 then
				hook.Run("YButtonRPaint", self, pw, ph)
			end
		end

		function back:DoClick()
			if LocalPlayer():GetYRPInt("char_count", 0) > 0 then
				parent:Remove()
				YRPOpenCharacterSelection()
			end
		end
	end

	-- Factions
	net.Receive(
		"nws_yrp_factionselection_getfactions",
		function(len)
			local ftab = net.ReadTable()
			if YRPPanelAlive(lis, "lis") then
				local x = 0
				local y = 0
				-- If more then 1 Faction
				if table.Count(ftab) > 1 then
					lply.onefaction = false
					local w = (nw - YRP.ctr(3 * config.br)) / 2
					local h = YRP.ctr(500)
					if table.Count(ftab) > 4 then
						lis:SetWide(nw + sbar:GetWide())
					end

					-- Recalculate Height
					local sh = math.Clamp(YRP.ctr(config.br) + table.Count(ftab) / 2 * (h + YRP.ctr(config.br)), 100, nh)
					lis:SetTall(sh)
					lis:Center()
					for i, fac in SortedPairsByMemberValue(ftab, "int_position") do
						fac.uniqueID = tonumber(fac.uniqueID)
						fac.bool_visible_cc = tobool(fac.bool_visible_cc)
						fac.bool_visible_rm = tobool(fac.bool_visible_rm)
						if LocalPlayer().cc == true and not fac.bool_visible_cc then
							continue
						elseif LocalPlayer().cc == false and not fac.bool_visible_rm then
							continue
						end

						if fac.uniqueID ~= -1 then
							local faction = YRPCreateD("YPanel", nil, w, h, YRP.ctr(config.br) + x * (w + YRP.ctr(config.br)), YRP.ctr(config.br) + y * (h + YRP.ctr(config.br)))
							function faction:Paint(pw, ph)
								if LocalPlayer().cc then
									draw.RoundedBox(YRP.ctr(10), 0, 0, w, h, YRPInterfaceValue("YFrame", "BG"))
								else
									draw.RoundedBox(YRP.ctr(10), 0, 0, w, h, YRPInterfaceValue("YFrame", "HB"))
								end
							end

							local px = YRP.ctr(20)
							local sw = w - 2 * YRP.ctr(20)
							local url = fac.string_icon
							if not strEmpty(url) then
								px = h + YRP.ctr(20)
								sw = w - h - 2 * YRP.ctr(20)
								local logo = YRPCreateD("DHTML", faction, h - 2 * YRP.ctr(config.br), h - 2 * YRP.ctr(config.br), YRP.ctr(config.br), YRP.ctr(config.br))
								logo:SetHTML(YRPGetHTMLImage(url, logo:GetWide(), logo:GetTall()))
							end

							local name = YRPCreateD("DPanel", faction, sw, YRP.ctr(100), px, 0)
							function name:Paint(pw, ph)
								draw.SimpleText(fac.string_name, "Y_26_500", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							end

							local description = YRPCreateD("RichText", faction, sw, h - YRP.ctr(100), px, YRP.ctr(100))
							description:SetText(fac.string_description)
							function description:PerformLayout()
								if self.SetUnderlineFont ~= nil then
									self:SetUnderlineFont("Y_18_500")
								end

								self:SetFontInternal("Y_18_500")
								self:SetFGColor(Color(255, 255, 255, 255))
							end

							local join = YRPCreateD("DButton", faction, faction:GetWide() - YRP.ctr(60), faction:GetTall(), 0, 0)
							join:SetText("")
							function join:Paint(pw, ph)
								if self:IsHovered() then
									draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, Color(255, 255, 255, 1))
								end
							end

							function join:DoClick()
								lply.charcreate_fuid = fac.uniqueID
								parent:Clear()
								CreateRoleSelectionContent()
							end

							lis:AddItem(faction)
							x = x + 1
							if x > 1 then
								x = 0
								y = y + 1
							end
						end
					end
				else -- If not Enough Factions
					lply.charcreate_fuid = 1
					lply.onefaction = true
					parent:Clear()
					CreateRoleSelectionContent()
				end
			end
		end
	)

	net.Start("nws_yrp_factionselection_getfactions")
	net.SendToServer()
end