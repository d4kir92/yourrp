--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function AddYRPAddon(parent, tab)
	local _add_on = YRPCreateD("DPanel", parent, YRP.ctr(1600), YRP.ctr(6 * 100 + 5 * 20), 0, 0)
	function _add_on:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40))
	end

	_add_on.icon = YRPCreateD("DHTML", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(20))
	if strEmpty(tab.icon) then
		tab.icon = "http://www.famfamfam.com/lab/icons/silk/icons/plugin.png"
	end

	_add_on.icon:SetHTML(YRPGetHTMLImage(tab.icon, YRP.ctr(100), YRP.ctr(100)))
	if not strEmpty(tab.workshopid) then
		_add_on.workshop = YRPCreateD("DHTML", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(140))
		_add_on.workshop:SetHTML(YRPGetHTMLImage("https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Steam_icon_logo.svg/120px-Steam_icon_logo.svg.png", YRP.ctr(100), YRP.ctr(100)))
		_add_on.workshopbutton = YRPCreateD("DButton", _add_on.workshop, YRP.ctr(100), YRP.ctr(100), 0, 0)
		_add_on.workshopbutton:SetText("")
		function _add_on.workshopbutton:Paint(pw, ph)
		end

		function _add_on.workshopbutton:DoClick()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. tab.workshopid)
		end
	end

	if not strEmpty(tab.discord) then
		_add_on.discord = YRPCreateD("DHTML", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(260))
		_add_on.discord:SetHTML(YRPGetHTMLImage("https://i.imgur.com/rUUpbXO.png", YRP.ctr(100), YRP.ctr(100)))
		_add_on.discordbutton = YRPCreateD("DButton", _add_on.discord, YRP.ctr(100), YRP.ctr(100), 0, 0)
		_add_on.discordbutton:SetText("")
		function _add_on.discordbutton:Paint(pw, ph)
		end

		function _add_on.discordbutton:DoClick()
			gui.OpenURL(tab.discord)
		end
	end

	if not strEmpty(tab.settings) then
		_add_on.settings = YRPCreateD("DButton", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(380))
		_add_on.settings:SetText("")
		function _add_on.settings:Paint(pw, ph)
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.SetMaterial(YRP.GetDesignIcon("settings"))
			surface.DrawTexturedRect(0, 0, pw, ph)
		end

		function _add_on.settings:DoClick()
			hook.Call(tab.settings)
			F8CloseSettings()
		end
	end

	if not strEmpty(tab.name) then
		_add_on.name = YRPCreateD("DTextEntry", _add_on, _add_on:GetWide() - YRP.ctr(160), YRP.ctr(100), YRP.ctr(140), YRP.ctr(20))
		_add_on.name:SetEditable(false)
		_add_on.name:SetText(YRP.trans("LID_name") .. ": " .. tab.name)
		function _add_on.name:PerformLayout()
			local ts = 24
			if ts > 0 then
				if self.SetUnderlineFont ~= nil then
					self:SetUnderlineFont("Y_" .. ts .. "_500")
				end

				self:SetFontInternal("Y_" .. ts .. "_500")
			end
		end
	end

	if not strEmpty(tab.author) then
		_add_on.author = YRPCreateD("DTextEntry", _add_on, _add_on:GetWide() - YRP.ctr(160), YRP.ctr(100), YRP.ctr(140), YRP.ctr(140))
		_add_on.author:SetEditable(false)
		_add_on.author:SetText(YRP.trans("LID_s_author") .. ": " .. tab.author)
		function _add_on.author:PerformLayout()
			local ts = 18
			if ts > 0 then
				if self.SetUnderlineFont ~= nil then
					self:SetUnderlineFont("Y_" .. ts .. "_500")
				end

				self:SetFontInternal("Y_" .. ts .. "_500")
			end
		end
	end

	if not strEmpty(tab.description) then
		_add_on.description = YRPCreateD("DTextEntry", _add_on, _add_on:GetWide() - YRP.ctr(160), YRP.ctr(420), YRP.ctr(140), YRP.ctr(260))
		_add_on.description:SetEditable(false)
		_add_on.description:SetMultiline(true)
		_add_on.description:SetText(YRP.trans("LID_description") .. ":\n" .. tab.description)
		function _add_on.description:PerformLayout()
			local ts = 18
			if ts > 0 then
				if self.SetUnderlineFont ~= nil then
					self:SetUnderlineFont("Y_" .. ts .. "_500")
				end

				self:SetFontInternal("Y_" .. ts .. "_500")
			end
		end
	end

	parent:AddItem(_add_on)

	return _add_on
end

net.Receive(
	"nws_yrp_connect_Settings_YourRP_Addons",
	function(len)
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			function PARENT:OnRemove()
				net.Start("nws_yrp_disconnect_Settings_YourRP_Addons")
				net.SendToServer()
			end

			local YRPA = net.ReadTable()
			local addons = YRPCreateD("DPanelList", PARENT, YRP.ctr(1600), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))
			addons:EnableVerticalScrollbar(true)
			addons:SetSpacing(10)
			function addons:Paint(pw, ph)
				local box = {}
				box.w = pw
				box.h = ph
				box.color = Color(80, 80, 80)
				YRPDrawBox(box)
			end

			if table.Count(YRPA) > 0 then
				for i, addon in pairs(YRPA) do
					AddYRPAddon(addons, addon)
				end
			else
				local _empty = YRPCreateD("DPanel", addons, YRP.ctr(1600), YRP.ctr(4 * 100 + 5 * 20), 0, 0)
				function _empty:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
					local tab = {}
					tab.x = pw / 2
					tab.y = ph / 2
					tab.ax = 1
					tab.ay = 1
					tab.font = "Y_18_500"
					tab.text = "empty"
					YRPDrawText(tab)
				end

				addons:AddItem(_empty)
			end
		end
	end
)

function OpenSettingsYourRPAddons()
	net.Start("nws_yrp_connect_Settings_YourRP_Addons")
	net.SendToServer()
end