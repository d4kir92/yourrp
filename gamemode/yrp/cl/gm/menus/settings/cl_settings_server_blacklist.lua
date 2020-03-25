--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #BLACKLISTSETTINGS

hook.Add("open_server_blacklist", "open_server_blacklist", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local PARENT = settingsWindow.window.site

	local wip = createD("DPanel", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function wip:Paint(pw, ph)
		draw.SimpleText("[" .. YRP.lang_string("LID_wip") .. "]", "Y_72_500", pw / 2, ph / 2, Color(255, 100, 100, 255), 1, 1)
	end
end)
