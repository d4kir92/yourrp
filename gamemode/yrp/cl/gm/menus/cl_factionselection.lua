--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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



	local nw = config.w
	local nh = config.h
	if !LocalPlayer():GetDBool("cc", true) then
		nw = parent:GetWide() * 2
		nh = parent:GetTall() * 2
	end

	local site = createD("DPanel", parent, parent:GetWide(), parent:GetTall(), 0, 0)
	function site:Paint(pw, ph)
	end

	-- List of Factions
	local list = createD("DScrollPanel", site, YRP.ctr(nw), YRP.ctr(nh), 0, 0)
	list:Center()
	function list:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))
	end
	local sbar = list:GetVBar()
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "NC"))
	end
	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end
	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, lply:InterfaceValue("YFrame", "HI"))
	end



	if LocalPlayer():GetDBool("cc", true) then -- for Character Creation
		local header = createD("DPanel", site, YRP.ctr(1000), YRP.ctr(100), site:GetWide() / 2 - YRP.ctr(500), YRP.ctr(200))
		function header:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_chooseyourfaction"), "Y_36_700", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local btn = {}
		btn.w = 500
		btn.h = 75

		local back = createD("YButton", site, YRP.ctr(btn.w), YRP.ctr(btn.h), site:GetWide() / 2 - YRP.ctr(btn.w) / 2, ScH() - YRP.ctr(200))
		back:SetText("LID_back")
		function back:Paint(pw, ph)
			hook.Run("YButtonRPaint", self, pw, ph)
		end
		function back:DoClick()
			parent:Remove()
			openCharacterSelection()
		end
	end



	-- Factions
	net.Receive("yrp_factionselection_getfactions", function(len)
		local ftab = net.ReadTable()

		if pa(list) then
			local x = 0
			local y = 0

			if table.Count(ftab) > 1 then -- If more then 1 Faction
				lply:SetDBool("onefaction", false)
				local w = YRP.ctr(nw - 3 * config.br) / 2
				local h = YRP.ctr(500)
				if table.Count(ftab) > 4 then
					list:SetWide(YRP.ctr(nw) + sbar:GetWide())
				end

				-- Recalculate Height
				local sh = math.Clamp(YRP.ctr(config.br) + table.Count(ftab) / 2 * (h + YRP.ctr(config.br)), 100, YRP.ctr(nh))
				list:SetTall(sh)
				list:Center()

				for i, fac in pairs(ftab) do
					fac.uniqueID = tonumber(fac.uniqueID)
		
					if fac.uniqueID != -1 then
						local faction = createD("YPanel", nil, w, h, YRP.ctr(config.br) + x * (w + YRP.ctr(config.br)), YRP.ctr(config.br) + y * (h + YRP.ctr(config.br)))

						local px = YRP.ctr(20)
						local sw = w - 2 * YRP.ctr(20)
						local url = fac.string_icon
						if !strEmpty(url) then
							px = h + YRP.ctr(20)
							sw = w - h - 2 * YRP.ctr(20)
							local logo = createD("DHTML", faction, h - 2 * YRP.ctr(config.br), h - 2 * YRP.ctr(config.br), YRP.ctr(config.br), YRP.ctr(config.br))
							logo:SetHTML(GetHTMLImage(url, logo:GetWide(), logo:GetTall()))
						end

						local name = createD("DPanel", faction, sw, YRP.ctr(100), px, 0)
						function name:Paint(pw, ph)
							draw.SimpleText(fac.string_name, "Y_26_700", 0, ph / 2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						end

						local description = createD("RichText", faction, sw, h - YRP.ctr(100), px, YRP.ctr(100))
						description:SetText(fac.string_description)
						function description:PerformLayout()
							if self.SetUnderlineFont != nil then
								self:SetUnderlineFont("Y_18_500")
							end
							self:SetFontInternal("Y_18_500")

							self:SetFGColor(Color(255, 255, 255))
						end

						local join = createD("DButton", faction, faction:GetWide(), faction:GetTall(), 0, 0)
						join:SetText("")
						function join:Paint(pw, ph)
							if self:IsHovered() then
								draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
							end
						end
						function join:DoClick()
							lply:SetDString("charcreate_fuid", fac.uniqueID)
							parent:Clear()

							CreateRoleSelectionContent()
						end

						list:AddItem(faction)



						x = x + 1
						if x > 1 then
							x = 0
							y = y + 1
						end
					end
				end
			else -- If not Enough Factions
				lply:SetDString("charcreate_fuid", "1")
				lply:SetDBool("onefaction", true)
				parent:Clear()

				CreateRoleSelectionContent()
			end
		end
	end)
	net.Start("yrp_factionselection_getfactions")
	net.SendToServer()
end