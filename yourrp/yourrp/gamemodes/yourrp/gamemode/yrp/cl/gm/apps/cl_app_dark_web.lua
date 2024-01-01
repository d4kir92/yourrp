--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local APP = APP or {}
APP.PrintName = "Dark Web"
APP.LangName = "darkweb"
APP.ClassName = "yrp_dark_web"
APP.Icon = Material("yrp/yrp_anonymous.png")
function APP:AppIcon(pw, ph)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(self.Icon)
	surface.DrawTexturedRect(0, 0, pw, ph)
	--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 255, 255 ) )
end

APP.Fullscreen = true
function testApp(display, x, y, w, h)
	local _dw = YRPCreateD("DPanel", display, w, h, x, y)
	function _dw:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))
	end

	if LocalPlayer():IsAgent() then
		--[[ if Agent ]]
		--
		local _we = YRPCreateD("DPanel", _dw, ctrb(800), ctrb(100), 0, 0)
		function _we:Paint(pw, ph)
			local tab = {}
			tab["NAME"] = LocalPlayer():RPName()
			draw.SimpleText(YRP.trans("LID_welcomeagentx", tab), "Y_24_500", ctrb(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, 0)
		end

		local _target_model = YRPCreateD("DModelPanel", _dw, ctrb(800), ctrb(800), ctrb(400), ctrb(100))
		local _target_rpname = YRPCreateD("DPanel", _dw, ctrb(800), ctrb(100), ctrb(1200), ctrb(100))
		_target_rpname.rpname = YRP.trans("LID_none")
		function _target_rpname:Paint(pw, ph)
			draw.SimpleText(YRP.trans("LID_target") .. ":", "Y_24_500", ctrb(300), ph / 2, Color(255, 255, 255, 255), 2, 0)
			draw.SimpleText(self.rpname, "Y_24_500", ctrb(320), ph / 2, Color(255, 255, 255, 255), 0, 0)
		end

		local _target_reward = YRPCreateD("DPanel", _dw, ctrb(800), ctrb(100), ctrb(1200), ctrb(250))
		_target_reward.reward = YRP.trans("LID_none")
		function _target_reward:Paint(pw, ph)
			draw.SimpleText("Reward" .. ":", "Y_24_500", ctrb(300), ph / 2, Color(255, 255, 255, 255), 2, 0)
			draw.SimpleText(self.reward, "Y_24_500", ctrb(320), ph / 2, Color(255, 255, 255, 255), 0, 0)
		end

		local _target_description = YRPCreateD("DPanel", _dw, ctrb(800), ctrb(100), ctrb(1200), ctrb(400))
		_target_description.description = YRP.trans("LID_none")
		function _target_description:Paint(pw, ph)
			draw.SimpleText(YRP.trans("LID_description") .. ":", "Y_24_500", ctrb(300), ph / 2, Color(255, 255, 255, 255), 2, 0)
			draw.SimpleText(self.description, "Y_24_500", ctrb(320), ph / 2, Color(255, 255, 255, 255), 0, 0)
		end

		local _target_accept = YRPCreateD("YButton", _dw, ctrb(800), ctrb(50), ctrb(1200), ctrb(550))
		_target_accept.hit = nil
		_target_accept:SetText("LID_accepthit")
		function _target_accept:Paint(pw, ph)
			if self.hit ~= nil then
				hook.Run("YButtonPaint", self, pw, ph)
			end
		end

		function _target_accept:DoClick()
			net.Start("nws_yrp_accepthit")
			net.WriteString(self.hit.uniqueID)
			net.SendToServer()
			closeSP()
		end

		local _target_list = YRPCreateD("DListView", _dw, ctrb(1000), ctrb(1200), 0, ctrb(100))
		_target_list:AddColumn(YRP.trans("LID_name"))
		_target_list:AddColumn(YRP.trans("LID_target"))
		_target_list:AddColumn(YRP.trans("LID_reward"))
		_target_list:AddColumn(YRP.trans("LID_description"))
		net.Receive(
			"nws_yrp_gethits",
			function(len)
				local _hits = net.ReadTable()
				for i, hit in pairs(_hits) do
					for j, ply in pairs(player.GetAll()) do
						if ply:YRPSteamID() == hit.target then
							_target_list:AddLine(ply:RPName(), hit.target, hit.reward, hit.description, hit.uniqueID)
							break
						end
					end
				end
			end
		)

		net.Start("nws_yrp_gethits")
		net.SendToServer()
		function _target_list.OnRowSelected(lst, index, pnl)
			local hit = {}
			hit.uniqueID = pnl:GetColumnText(5)
			hit.rpname = pnl:GetColumnText(1)
			hit.steamid = pnl:GetColumnText(2)
			hit.reward = pnl:GetColumnText(3)
			hit.description = pnl:GetColumnText(4)
			for i, ply in pairs(player.GetAll()) do
				if ply:YRPSteamID() == hit.steamid then
					_target_model:SetModel(ply:GetModel())
					_target_rpname.rpname = ply:RPName()
					local _pre = GetGlobalYRPString("text_money_pre", "")
					local _pos = GetGlobalYRPString("text_money_pos", "")
					_target_reward.reward = _pre .. hit.reward .. _pos
					_target_description.description = hit.description
					_target_accept.hit = hit
					break
				end
			end
		end
	else
		--[[ if NOT Agent ]]
		--
		local _ch = YRPCreateD("YButton", _dw, ctrb(400), ctrb(60), ctrb(20), ctrb(20))
		_ch:SetText("LID_createhit")
		function _ch:DoClick()
			local _newhit = YRPCreateD("YFrame", nil, ctrb(1400), ctrb(1400), 0, 0)
			_newhit:SetTitle("")
			_newhit:Center()
			local _pb = YRPCreateD("DComboBox", _newhit:GetContent(), ctrb(400), ctrb(50), ctrb(20), ctrb(20))
			for i, ply in pairs(player.GetAll()) do
				_pb:AddChoice(ply:RPName(), ply:YRPSteamID())
			end

			function _pb:OnSelect(index, value, data)
				if self._hi ~= nil then
					self._hi:Remove()
				end

				self._hi = YRPCreateD("DPanel", _newhit:GetContent(), ctrb(600), ctrb(1000), ctrb(500), ctrb(20))
				self._hi.target = value
				function self._hi:Paint(pw, ph)
					draw.SimpleText(YRP.trans("LID_target") .. ": " .. self.target, "Y_36_500", ctrb(20), ctrb(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(YRP.trans("LID_reward") .. ":", "Y_36_500", ctrb(20), ctrb(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(YRP.trans("LID_description") .. ":", "Y_36_500", ctrb(20), ctrb(350), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				end

				local _hr = YRPCreateD("DNumberWang", self._hi, ctrb(400), ctrb(50), ctrb(20), ctrb(200))
				local _hd = YRPCreateD("DTextEntry", self._hi, ctrb(800), ctrb(50), ctrb(20), ctrb(350))
				local _hp = YRPCreateD("YButton", self._hi, ctrb(400), ctrb(50), ctrb(20), ctrb(450))
				_hp:SetText("LID_placehit")
				function _hp:DoClick()
					local _steamid = data
					local _reward = _hr:GetValue()
					local _desc = _hd:GetText()
					net.Start("nws_yrp_placehit")
					net.WriteString(_steamid)
					net.WriteString(_reward)
					net.WriteString(_desc)
					net.SendToServer()
					_newhit:Close()
				end
			end

			_newhit:MakePopup()
		end

		local _target_list = YRPCreateD("DListView", _dw, ctrb(1000), ctrb(1200), ctrb(20), ctrb(100))
		_target_list:AddColumn(YRP.trans("LID_name"))
		_target_list:AddColumn(YRP.trans("LID_target"))
		_target_list:AddColumn(YRP.trans("LID_reward"))
		_target_list:AddColumn(YRP.trans("LID_description"))
		net.Receive(
			"nws_yrp_get_contracts",
			function(len)
				local _hits = net.ReadTable()
				for i, hit in pairs(_hits) do
					for j, ply in pairs(player.GetAll()) do
						if ply:YRPSteamID() == hit.target then
							_target_list:AddLine(ply:RPName(), hit.target, hit.reward, hit.description)
							break
						end
					end
				end
			end
		)

		net.Start("nws_yrp_get_contracts")
		net.SendToServer()
	end
end

function APP:OpenApp(display, x, y, w, h)
	testApp(display, x, y, w, h)
end

list.Add("yrp_apps", APP)