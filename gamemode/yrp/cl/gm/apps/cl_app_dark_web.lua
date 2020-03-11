--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local APP = APP or {}
APP.PrintName = "Dark Web"
APP.LangName = "darkweb"
APP.ClassName = "yrp_dark_web"

APP.Icon = Material("yrp/yrp_anonymous.png")

function APP:AppIcon(pw, ph)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.Icon	)
	surface.DrawTexturedRect(0, 0, pw, ph)

	--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255))
end

APP.Fullscreen = true

function testApp(display, x, y, w, h)
	local _dw = createD("DPanel", display, w, h, x, y)
	function _dw:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))
	end
	if LocalPlayer():IsAgent() then
		--[[ if Agent ]]--
		local _we = createD("DPanel", _dw, ctrb(800), ctrb(100), 0, 0)
		function _we:Paint(pw, ph)
			surfaceText("Welcome Agent", "HudBars", ctrb(10), ph/2, Color(255, 255, 255), 0, 2)
		end

		local _target_model = createD("DModelPanel", _dw, ctrb(800), ctrb(800), ctrb(400), ctrb(100))

		local _target_rpname = createD("DPanel", _dw, ctrb(400), ctrb(100), ctrb(1200), ctrb(100))
		_target_rpname.rpname = YRP.lang_string("LID_none")
		function _target_rpname:Paint(pw, ph)
			surfaceText("Target" .. ":", "HudBars", ctrb(10), ph/2, Color(255, 255, 255), 0, 2)
			surfaceText(self.rpname, "HudBars", ctrb(10), ph/2, Color(255, 255, 255), 0, 0)
		end

		local _target_reward = createD("DPanel", _dw, ctrb(400), ctrb(100), ctrb(1200), ctrb(250))
		_target_reward.reward = YRP.lang_string("LID_none")
		function _target_reward:Paint(pw, ph)
			surfaceText("Reward" .. ":", "HudBars", ctrb(10), ph/2, Color(255, 255, 255), 0, 2)
			surfaceText(self.reward, "HudBars", ctrb(10), ph/2, Color(255, 255, 255), 0, 0)
		end

		local _target_description = createD("DPanel", _dw, ctrb(400), ctrb(100), ctrb(1200), ctrb(400))
		_target_description.description = YRP.lang_string("LID_none")
		function _target_description:Paint(pw, ph)
			surfaceText(YRP.lang_string("LID_description") .. ":", "HudBars", ctrb(10), ph/2, Color(255, 255, 255), 0, 2)
			surfaceText(self.description, "HudBars", ctrb(10), ph/2, Color(255, 255, 255), 0, 0)
		end

		local _target_accept = createD("DButton", _dw, ctrb(400), ctrb(50), ctrb(1200), ctrb(550))
		_target_accept.hit = nil
		_target_accept:SetText("")
		function _target_accept:Paint(pw, ph)
			if self.hit != nil then
				surfaceButton(self, pw, ph, "Accept hit")
			end
		end
		function _target_accept:DoClick()
			net.Start("yrp_accepthit")
				net.WriteString(self.hit.uniqueID)
			net.SendToServer()
			closeSP()
		end

		local _target_list = createD("DListView", _dw, ctrb(1000), ctrb(1200), 0, ctrb(100))
		_target_list:AddColumn(YRP.lang_string("LID_name"))
		_target_list:AddColumn("Target")
		_target_list:AddColumn("Reward")
		_target_list:AddColumn(YRP.lang_string("LID_description"))
		net.Receive("yrp_gethits", function(len)
			local _hits = net.ReadTable()
			for i, hit in pairs(_hits) do
				for j, ply in pairs(player.GetAll()) do
					if ply:SteamID() == hit.target then
						_target_list:AddLine(ply:RPName(), hit.target, hit.reward, hit.description, hit.uniqueID)
						break
					end
				end
			end
		end)
		net.Start("yrp_gethits")
		net.SendToServer()
		function _target_list.OnRowSelected(lst, index, pnl)
			local hit = {}
			hit.uniqueID = pnl:GetColumnText(5)
			hit.rpname = pnl:GetColumnText(1)
			hit.steamid = pnl:GetColumnText(2)
			hit.reward = pnl:GetColumnText(3)
			hit.description = pnl:GetColumnText(4)
			for i, ply in pairs(player.GetAll()) do
				if ply:SteamID() == hit.steamid then

					_target_model:SetModel(ply:GetModel())

					_target_rpname.rpname = ply:RPName()

					local _pre = GetGlobalDString("text_money_pre", "")
					local _pos = GetGlobalDString("text_money_pos", "")
					_target_reward.reward = _pre .. hit.reward .. _pos

					_target_description.description = hit.description

					_target_accept.hit = hit

					break
				end
			end
		end
	else
		--[[ if NOT Agent ]]--
		local _ch = createD("DButton", _dw, ctrb(400), ctrb(60), 0, 0)
		_ch:SetText("")
		function _ch:Paint(pw, ph)
			surfaceButton(self, pw, ph, "Create Hit")
		end
		function _ch:DoClick()
			local _newhit = createD("DFrame", nil, ctrb(1400), ctrb(1400), 0, 0)
			_newhit:SetTitle("")
			_newhit:Center()
			function _newhit:Paint(pw, ph)
				surfaceWindow(self, pw, ph, "Create Hit")

				surfaceText("Target" .. ":", "apph1", ctrb(10), ctrb(100), Color(255, 255, 255), 0, 2)
			end

			local _pb = createD("DComboBox", _newhit, ctrb(400), ctrb(50), ctrb(10), ctrb(100))
			for i, ply in pairs(player.GetAll()) do
				_pb:AddChoice(ply:RPName(), ply:SteamID())
			end
			function _pb:OnSelect(index, value, data)
				if self._hi != nil then
					self._hi:Remove()
				end

				self._hi = createD("DPanel", _newhit, ctrb(600), ctrb(1000), ctrb(600), ctrb(100))
				self._hi.target = value
				function self._hi:Paint(pw, ph)
					surfaceText(YRP.lang_string("Target") .. ":", "apph1", ctrb(10), ctrb(50), Color(255, 255, 255), 0, 2)
					surfaceText(self.target, "apph1", ctrb(10), ctrb(50), Color(255, 255, 255), 0, 0)

					surfaceText(YRP.lang_string("Reward") .. ":", "apph1", ctrb(10), ctrb(150), Color(255, 255, 255), 0, 2)

					surfaceText(YRP.lang_string("LID_description") .. ":", "apph1", ctrb(10), ctrb(250), Color(255, 255, 255), 0, 2)
				end

				local _hr = createD("DNumberWang", self._hi, ctrb(400), ctrb(50), ctrb(10), ctrb(150))

				local _hd = createD("DTextEntry", self._hi, ctrb(800), ctrb(50), ctrb(10), ctrb(250))

				local _hp = createD("DButton", self._hi, ctrb(400), ctrb(50), ctrb(10), ctrb(350))
				_hp:SetText("")
				function _hp:Paint(pw, ph)
					surfaceButton(self, pw, ph, YRP.lang_string("Place hit"))
				end
				function _hp:DoClick()
					local _steamid = data
					local _reward = _hr:GetValue()
					local _desc = _hd:GetText()
					net.Start("yrp_placehit")
						net.WriteString(_steamid)
						net.WriteString(_reward)
						net.WriteString(_desc)
					net.SendToServer()
					_newhit:Close()
				end
			end
			_newhit:MakePopup()
		end

		local _target_list = createD("DListView", _dw, ctrb(1000), ctrb(1200), 0, ctrb(100))
		_target_list:AddColumn(YRP.lang_string("LID_name"))
		_target_list:AddColumn("Target")
		_target_list:AddColumn("Reward")
		_target_list:AddColumn(YRP.lang_string("LID_description"))
		net.Receive("yrp_get_contracts", function(len)
			local _hits = net.ReadTable()
			for i, hit in pairs(_hits) do
				for j, ply in pairs(player.GetAll()) do
					if ply:SteamID() == hit.target then
						_target_list:AddLine(ply:RPName(), hit.target, hit.reward, hit.description)
						break
					end
				end
			end
		end)
		net.Start("yrp_get_contracts")
		net.SendToServer()
	end
end

function APP:OpenApp(display, x, y, w, h)
	testApp(display, x, y, w, h)
end

list.Add("yrp_apps", APP)
