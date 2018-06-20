--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DarkRP.addChatReceiver( prefix, text, hearFunc )
	--Description: Add a chat command with specific receivers
	printGM( "darkrp", "addChatReceiver( " .. prefix .. ", " .. text .. ", " .. hearFunc .. " )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.addF4MenuTab( name, panel )
	--Description: Add a tab to the F4 menu.
	printGM( "darkrp", "addF4MenuTab( " .. name .. ", panel )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.closeF1Menu()
	--Description: Close the F1 help menu.
	printGM( "darkrp", "closeF1Menu()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.closeF4Menu()
	--Description: Close the F4 menu if it's open.
	printGM( "darkrp", "closeF4Menu()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.deLocalise( text )
	--Description: Makes sure the string will not be localised when drawn or printed.
	printGM( "darkrp", "deLocalise( " .. text .. " )" )
	printGM( "darkrp", DarkRP._not )
	return text
end

function DarkRP.getF4MenuPanel()
	--Description: Get the F4 menu panel.
	printGM( "darkrp", "getF4MenuPanel( " .. text .. " )" )
	printGM( "darkrp", DarkRP._not )
	return NULL
end

function DarkRP.openF1Menu()
	--Description: Open the F1 help menu.
	printGM( "darkrp", "openF1Menu()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.openF4Menu()
	--Description: Open the F4 menu.
	printGM( "darkrp", "openF4Menu()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.openHitMenu( hitman )
	--Description: Open the menu that requests a hit.
	printGM( "darkrp", "openHitMenu( hitman )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.openKeysMenu()
	--Description: Open the keys/F2 menu.
	printGM( "darkrp", "openKeysMenu()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.openPocketMenu()
	--Description: Open the DarkRP pocket menu.
	printGM( "darkrp", "openPocketMenu()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.readNetDoorVar()
	--Description: Internal function. You probably shouldn't need this. DarkRP
	--						 calls this function when reading DoorVar net messages.
	--						 This function reads the net data for a specific DoorVar.
	printGM( "darkrp", "readNetDoorVar()" )
	printGM( "darkrp", DarkRP._not )
	return "Old readNetDoorVar", nil
end

function DarkRP.refreshF1Menu()
	--Description: Close the F1 help menu.
	printGM( "darkrp", "refreshF1Menu()" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.removeChatReceiver( prefix )
	--Description: Remove a chat command receiver
	printGM( "darkrp", "removeChatReceiver( prefix )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.removeF4MenuTab( name )
	--Description: Remove a tab from the F4 menu by name.
	printGM( "darkrp", "removeF4MenuTab( name )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.setPreferredJobModel( teamNr, model )
	--Description: Set the model preferred by the player (if the job allows multiple models).
	printGM( "darkrp", "setPreferredJobModel( teamNr, model )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.switchTabOrder( firstTab, secondTab )
	--Description: Switch the order of two tabs.
	printGM( "darkrp", "switchTabOrder( firstTab, secondTab )" )
	printGM( "darkrp", DarkRP._not )
end

function DarkRP.textWrap( text, font, width )
	--Description: Wrap a text around when reaching a certain width.
	printGM( "darkrp", "textWrap( text, font, width )" )
	printGM( "darkrp", DarkRP._not )
	return text
end

function DarkRP.toggleF4Menu()
	--Description: Toggle the state of the F4 menu (open or closed).
	printGM( "darkrp", "toggleF4Menu()" )
	printGM( "darkrp", DarkRP._not )
	return text
end

net.Receive( "sendNotify", function()
	local message = net.ReadString()
	notification.AddLegacy( message, NOTIFY_GENERIC, 3 )
end)
