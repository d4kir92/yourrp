--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function DarkRP.addChatReceiver(prefix, text, hearFunc)
end

--Description: Add a chat command with specific receivers
--YRPDarkrpNotFound( "addChatReceiver( " .. prefix .. ", " .. text .. ", " .. tostring(hearFunc) .. " )" )
function DarkRP.addF4MenuTab(name, panel)
	--Description: Add a tab to the F4 menu.
	YRPDarkrpNotFound("addF4MenuTab( " .. tostring(name) .. ", " .. tostring(panel) .. " )")
end

function DarkRP.closeF1Menu()
	--Description: Close the F1 help menu.
	--YRPDarkrpNotFound( "closeF1Menu()" )
	YRPCloseCombinedMenu()
end

function DarkRP.closeF4Menu()
	--Description: Close the F4 menu if it's open.
	--YRPDarkrpNotFound( "closeF4Menu()" )
	YRPCloseCombinedMenu()
end

function DarkRP.deLocalise(text)
	--Description: Makes sure the string will not be localised when drawn or printed.
	YRPDarkrpNotFound("deLocalise( " .. text .. " )")

	return text
end

function DarkRP.getF4MenuPanel()
	--Description: Get the F4 menu panel.
	YRPDarkrpNotFound("getF4MenuPanel()")

	return NULL
end

function DarkRP.openF1Menu()
	--Description: Open the F1 help menu.
	--YRPDarkrpNotFound( "openF1Menu()" )
	YRPToggleCombinedMenu(1)
end

function DarkRP.openF4Menu()
end

--Description: Open the F4 menu.
--YRPDarkrpNotFound( "openF4Menu()" )
--YRPToggleCombinedMenu(2)
--F4Menu:OpenMenu()
function DarkRP.openHitMenu(hitman)
	--Description: Open the menu that requests a hit.
	YRPDarkrpNotFound("openHitMenu( " .. tostring(hitman) .. " )")
end

function DarkRP.openKeysMenu()
end

--Description: Open the keys/F2 menu.
--YRPDarkrpNotFound( "openKeysMenu()" )
function DarkRP.openPocketMenu()
	--Description: Open the DarkRP pocket menu.
	YRPDarkrpNotFound("openPocketMenu()")
end

function DarkRP.readNetDoorVar()
	--Description: Internal function. You probably shouldn't need this. DarkRP
	--						 calls this function when reading DoorVar net messages.
	--						 This function reads the net data for a specific DoorVar.
	YRPDarkrpNotFound("readNetDoorVar()")

	return "Old readNetDoorVar", nil
end

function DarkRP.refreshF1Menu()
	--Description: Close the F1 help menu.
	YRPDarkrpNotFound("refreshF1Menu()")
end

function DarkRP.removeChatReceiver(prefix)
	--Description: Remove a chat command receiver
	YRPDarkrpNotFound("removeChatReceiver( " .. prefix .. " )")
end

function DarkRP.removeF4MenuTab(name)
	--Description: Remove a tab from the F4 menu by name.
	YRPDarkrpNotFound("removeF4MenuTab( " .. name .. " )")
end

function DarkRP.setPreferredJobModel(teamNr, model)
end

--Description: Set the model preferred by the player (if the job allows multiple models).
--YRPDarkrpNotFound( "setPreferredJobModel( " .. tostring(teamNr) .. ", " .. tostring(model) .. " )" )
function DarkRP.switchTabOrder(firstTab, secondTab)
	--Description: Switch the order of two tabs.
	YRPDarkrpNotFound("switchTabOrder( " .. firstTab .. ", " .. secondTab .. " )")
end

local function charWrap(tex, remainingWidth, maxWidth)
	local totalWidth = 0
	tex = tex:gsub(
		".",
		function(char)
			totalWidth = totalWidth + surface.GetTextSize(char)
			if totalWidth >= remainingWidth then
				totalWidth = surface.GetTextSize(char)
				remainingWidth = maxWidth

				return "\n" .. char
			end

			return char
		end
	)

	return tex, totalWidth
end

function DarkRP.textWrap(tex, font, maxWidth)
	--Description: Wrap a text around when reaching a certain width.
	local totalWidth = 0
	surface.SetFont(font)
	local spaceWidth = surface.GetTextSize(' ')
	tex = tex:gsub(
		"(%s?[%S]+)",
		function(word)
			local char = string.sub(word, 1, 1)
			if char == "\n" or char == "\t" then
				totalWidth = 0
			end

			local wordlen = surface.GetTextSize(word)
			totalWidth = totalWidth + wordlen
			-- Wrap around when the max width is reached
			-- Split the word if the word is too big
			if wordlen >= maxWidth then
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
		end
	)

	return tex
end

function DarkRP.toggleF4Menu()
end

--Description: Toggle the state of the F4 menu (open or closed).
--YRPDarkrpNotFound( "toggleF4Menu()" )
net.Receive(
	"nws_yrp_sendNotify",
	function()
		local message = net.ReadString()
		notification.AddLegacy(message, NOTIFY_GENERIC, 3)
	end
)