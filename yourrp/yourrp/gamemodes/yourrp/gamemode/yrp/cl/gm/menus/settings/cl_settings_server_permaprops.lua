--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local pp = {}
pp.c = 0
net.Receive(
	"nws_yrp_get_perma_props",
	function(len, ply)
		pp.tab = pp.tab or {}
		pp.c = pp.c + 1
		local i = net.ReadString()
		i = tonumber(i)
		pp.tab[i] = net.ReadTable()
		if YRPPanelAlive(pp.list) then
			local h = YRP.ctr(240)
			local line = YRPCreateD("DPanel", nil, pp.list:GetWide(), h, 0, 0)
			line.c = pp.c
			line.id = pp.tab[i].id
			line.max = pp.tab[i].max
			line.class = pp.tab[i].class
			line.model = pp.tab[i].model or ""
			function line:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(45, 45, 45, 100))
				draw.SimpleText("ID: " .. tostring(self.id) .. "    " .. tostring(self.c) .. "/" .. tostring(self.max), "Y_30_500", ph + YRP.ctr(20), ph / 4, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("ClassName: " .. tostring(self.class), "Y_30_500", ph + YRP.ctr(20), ph / 4 * 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("WorldModel: " .. tostring(self.model), "Y_30_500", ph + YRP.ctr(20), ph / 4 * 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local mdl = YRPCreateD("DModelPanel", line, h, h, 0, 0)
			local sho = YRPCreateD("YButton", line, h, h, 0, 0)
			sho:SetText("LID_show")
			sho.model = pp.tab[i].model or ""
			sho.mdl = mdl
			function sho:Paint(pw, ph)
				self.o = self.o or false
				if self:IsVisible() and self.mdl:GetModel() == nil and not self.o then
					self.o = true
					if not strEmpty(self.model) then
						self.mdl:SetModel(self.model)
					end
				end
			end

			function sho:DoClick()
			end

			--mdl:SetModel(self.model)
			local tel = YRPCreateD("YButton", line, YRP.ctr(480), h, line:GetWide() - YRP.ctr(480 + 20 + 240 + 36), 0)
			tel:SetText("LID_tpto")
			tel.line = line
			tel.id = pp.tab[i].id
			function tel:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			function tel:DoClick()
				net.Start("nws_yrp_permaprops_teleport")
				net.WriteString(self.id)
				net.SendToServer()
			end

			local rem = YRPCreateD("YButton", line, YRP.ctr(240), h, line:GetWide() - YRP.ctr(240 + 36), 0)
			rem:SetText("LID_remove")
			rem.line = line
			rem.id = pp.tab[i].id
			function rem:Paint(pw, ph)
				hook.Run("YButtonRPaint", self, pw, ph)
			end

			function rem:DoClick()
				net.Start("nws_yrp_permaprops_remove")
				net.WriteString(self.id)
				net.SendToServer()
				self.line:Remove()
			end

			pp.list:AddItem(line)
		end
	end
)

function CreatePermaPropsSetting()
	local PARENT = GetSettingsSite()
	if YRPPanelAlive(PARENT) then
		pp.list = YRPCreateD("DPanelList", PARENT, PARENT:GetWide() - YRP.ctr(40), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
		pp.list:EnableVerticalScrollbar()
		pp.list:SetSpacing(YRP.ctr(20))
		function pp.list:Paint(pw, ph)
		end

		--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 100, 100, 100) )
		function pp.list:OnRemove()
			net.Start("nws_yrp_permaprops_close")
			net.SendToServer()
		end

		pp.tab = {}
		pp.c = 0
		timer.Simple(
			0.5,
			function()
				net.Start("nws_yrp_get_perma_props")
				net.SendToServer()
			end
		)
	end
end

function OpenSettingsPermaProps()
	CreatePermaPropsSetting()
end

-- new
local pp2 = {}
pp2.c = 0
net.Receive(
	"nws_yrp_get_perma_props2",
	function(len, ply)
		pp2.tab = pp2.tab or {}
		pp2.c = pp2.c + 1
		local i = net.ReadString()
		i = tonumber(i)
		pp2.tab[i] = net.ReadTable()
		if YRPPanelAlive(pp2.list) then
			local h = YRP.ctr(240)
			local line = YRPCreateD("DPanel", nil, pp2.list:GetWide(), h, 0, 0)
			line.c = pp2.c
			line.id = pp2.tab[i].id
			line.max = pp2.tab[i].max
			line.class = pp2.tab[i].class
			line.model = pp2.tab[i].model
			function line:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(45, 45, 45, 100))
				draw.SimpleText("ID: " .. self.id .. "    " .. self.c .. "/" .. self.max, "Y_30_500", ph + YRP.ctr(20), ph / 4, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("ClassName: " .. self.class, "Y_30_500", ph + YRP.ctr(20), ph / 4 * 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("WorldModel: " .. self.model, "Y_30_500", ph + YRP.ctr(20), ph / 4 * 3, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			local mdl = YRPCreateD("DModelPanel", line, h, h, 0, 0)
			local sho = YRPCreateD("YButton", line, h, h, 0, 0)
			sho:SetText("LID_show")
			sho.model = pp2.tab[i].model
			sho.mdl = mdl
			function sho:Paint(pw, ph)
				self.o = self.o or false
				if self:IsVisible() and self.mdl:GetModel() == nil and not self.o then
					self.o = true
					self.mdl:SetModel(self.model)
				end
			end

			function sho:DoClick()
			end

			--mdl:SetModel(self.model)
			local tel = YRPCreateD("YButton", line, YRP.ctr(480), h, line:GetWide() - YRP.ctr(480 + 20 + 240 + 36), 0)
			tel:SetText("LID_tpto")
			tel.line = line
			tel.id = pp2.tab[i].id
			function tel:Paint(pw, ph)
				hook.Run("YButtonPaint", self, pw, ph)
			end

			function tel:DoClick()
				net.Start("nws_yrp_permaprops_teleport2")
				net.WriteString(self.id)
				net.SendToServer()
			end

			local rem = YRPCreateD("YButton", line, YRP.ctr(240), h, line:GetWide() - YRP.ctr(240 + 36), 0)
			rem:SetText("LID_remove")
			rem.line = line
			rem.id = pp2.tab[i].id
			function rem:Paint(pw, ph)
				hook.Run("YButtonRPaint", self, pw, ph)
			end

			function rem:DoClick()
				net.Start("nws_yrp_permaprops_remove2")
				net.WriteString(self.id)
				net.SendToServer()
				self.line:Remove()
			end

			pp2.list:AddItem(line)
		end
	end
)

function CreatePermaPropsSetting2()
	local PARENT = GetSettingsSite()
	if YRPPanelAlive(PARENT) then
		pp2.list = YRPCreateD("DPanelList", PARENT, PARENT:GetWide() - YRP.ctr(40), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
		pp2.list:EnableVerticalScrollbar()
		pp2.list:SetSpacing(YRP.ctr(20))
		function pp2.list:Paint(pw, ph)
		end

		--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 100, 100, 100) )
		function pp2.list:OnRemove()
			net.Start("nws_yrp_permaprops_close2")
			net.SendToServer()
		end

		pp2.tab = {}
		pp2.c = 0
		timer.Simple(
			0.5,
			function()
				net.Start("nws_yrp_get_perma_props2")
				net.SendToServer()
			end
		)
	end
end

function OpenSettingsPermaProps2()
	CreatePermaPropsSetting2()
end