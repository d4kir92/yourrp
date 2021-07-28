--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function DarkRP.addChatReceiver(prefix, text, hearFunc)
	--Description: Add a chat command with specific receivers
	YRP.msg("darkrp", "addChatReceiver(" .. prefix .. ", " .. text .. ", " .. tostring(hearFunc) .. ")")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.addF4MenuTab(name, panel)
	--Description: Add a tab to the F4 menu.
	YRP.msg("darkrp", "addF4MenuTab(" .. name .. ", panel)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.closeF1Menu()
	--Description: Close the F1 help menu.
	YRP.msg("darkrp", "closeF1Menu()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.closeF4Menu()
	--Description: Close the F4 menu if it's open.
	YRP.msg("darkrp", "closeF4Menu()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.deLocalise(text)
	--Description: Makes sure the string will not be localised when drawn or printed.
	YRP.msg("darkrp", "deLocalise(" .. text .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return text
end

function DarkRP.getF4MenuPanel()
	--Description: Get the F4 menu panel.
	YRP.msg("darkrp", "getF4MenuPanel(" .. text .. ")")
	YRP.msg("darkrp", DarkRP._not)
	return NULL
end

function DarkRP.openF1Menu()
	--Description: Open the F1 help menu.
	YRP.msg("darkrp", "openF1Menu()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.openF4Menu()
	--Description: Open the F4 menu.
	YRP.msg("darkrp", "openF4Menu()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.openHitMenu(hitman)
	--Description: Open the menu that requests a hit.
	YRP.msg("darkrp", "openHitMenu(hitman)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.openKeysMenu()
	--Description: Open the keys/F2 menu.
	YRP.msg("darkrp", "openKeysMenu()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.openPocketMenu()
	--Description: Open the DarkRP pocket menu.
	YRP.msg("darkrp", "openPocketMenu()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.readNetDoorVar()
	--Description: Internal function. You probably shouldn't need this. DarkRP
	--						 calls this function when reading DoorVar net messages.
	--						 This function reads the net data for a specific DoorVar.
	YRP.msg("darkrp", "readNetDoorVar()")
	YRP.msg("darkrp", DarkRP._not)
	return "Old readNetDoorVar", nil
end

function DarkRP.refreshF1Menu()
	--Description: Close the F1 help menu.
	YRP.msg("darkrp", "refreshF1Menu()")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeChatReceiver(prefix)
	--Description: Remove a chat command receiver
	YRP.msg("darkrp", "removeChatReceiver(prefix)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.removeF4MenuTab(name)
	--Description: Remove a tab from the F4 menu by name.
	YRP.msg("darkrp", "removeF4MenuTab(name)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.setPreferredJobModel(teamNr, model)
	--Description: Set the model preferred by the player (if the job allows multiple models).
	--YRP.msg("darkrp", "setPreferredJobModel(" .. tostring(teamNr) .. ", " .. tostring(model) .. ")")
end

function DarkRP.switchTabOrder(firstTab, secondTab)
	--Description: Switch the order of two tabs.
	YRP.msg("darkrp", "switchTabOrder(firstTab, secondTab)")
	YRP.msg("darkrp", DarkRP._not)
end

function DarkRP.textWrap(text, font, maxWidth)
	--Description: Wrap a text around when reaching a certain width.
	local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
		local char = string.sub(word, 1, 1)
		if char == "\n" or char == "\t" then
			totalWidth = 0
		end

		local wordlen = surface.GetTextSize(word)
		totalWidth = totalWidth + wordlen

		-- Wrap around when the max width is reached
		if wordlen >= maxWidth then -- Split the word if the word is too big
			local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
			totalWidth = splitPoint
			return splitWord
		elseif totalWidth < maxWidth then
			return word
		end

		-- Split before the word
		if char == ' ' then
			totalWidth = wordlen - spaceWidth
			return '\n' .. string.sub(word, 2)
		end

		totalWidth = wordlen
		return '\n' .. word
	end)
	return text
end

function DarkRP.toggleF4Menu()
	--Description: Toggle the state of the F4 menu (open or closed).
	YRP.msg("darkrp", "toggleF4Menu()")
	YRP.msg("darkrp", DarkRP._not)
	return text
end

net.Receive("sendNotify", function()
	local message = net.ReadString()
	notification.AddLegacy(message, NOTIFY_GENERIC, 3)
end)
