--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

net.Receive("setting_characters", function(len)
	local PARENT = GetSettingsSite()
	local tab = net.ReadTable()

	if pa(PARENT) then

		local charlist = createD("DListView", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
		charlist:AddColumn("SteamID")
		charlist:AddColumn(YRP.lang_string("LID_name"))
		charlist:AddColumn(YRP.lang_string("LID_idcardid"))
		charlist:AddColumn(YRP.lang_string("LID_description"))
		charlist:AddColumn(YRP.lang_string("LID_group"))
		charlist:AddColumn(YRP.lang_string("LID_role"))
		charlist:AddColumn(YRP.lang_string("LID_money")):SetFixedWidth(80)
		charlist:AddColumn(YRP.lang_string("LID_money") .. " (BANK)"):SetFixedWidth(80)
		charlist:AddColumn(YRP.lang_string("LID_level")):SetFixedWidth(50)
		charlist:AddColumn(YRP.lang_string("LID_event")):SetFixedWidth(50)
		charlist:AddColumn("Archived"):SetFixedWidth(50)

		for n, y in pairs(tab) do
			if y.SteamID != "BOT" then
				local event = tobool(y.bool_eventchar)
				local archi = tobool(y.bool_archived)
				local descr = ""
				if y.rpdescription and y.rpdescription != "nil" then
					descr = tostring(y.rpdescription)
				end
				descr = descr

				charlist:AddLine(y.SteamID, y.rpname, y.text_idcardid, descr, y.groupID, y.roleID, y.money, y.moneybank, y.int_level, event, archi)
			end
		end
	end
end)

function OpenSettingsCharacters()
	net.Start("setting_characters")
	net.SendToServer()
end
