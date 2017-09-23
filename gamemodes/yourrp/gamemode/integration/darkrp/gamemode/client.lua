--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DarkRP.addChatReceiver( prefix, text, hearFunc )
  --Description: Add a chat command with specific receivers
  printDRP( "addChatReceiver( " .. prefix .. ", " .. text .. ", " .. hearFunc .. " )" )
  printDRP( yrp._not )
end

function DarkRP.addF4MenuTab( name, panel )
  --Description: Add a tab to the F4 menu.
  printDRP( "addF4MenuTab( " .. name .. ", panel )" )
  printDRP( yrp._not )
end

function DarkRP.closeF1Menu()
  --Description: Close the F1 help menu.
  printDRP( "closeF1Menu()" )
  printDRP( yrp._not )
end

function DarkRP.closeF4Menu()
  --Description: Close the F4 menu if it's open.
  printDRP( "closeF4Menu()" )
  printDRP( yrp._not )
end

function DarkRP.deLocalise( text )
  --Description: Makes sure the string will not be localised when drawn or printed.
  printDRP( "deLocalise( " .. text .. " )" )
  printDRP( yrp._not )
  return text
end

function DarkRP.getF4MenuPanel()
  --Description: Get the F4 menu panel.
  printDRP( "getF4MenuPanel( " .. text .. " )" )
  printDRP( yrp._not )
  return NULL
end

function DarkRP.openF1Menu()
  --Description: Open the F1 help menu.
  printDRP( "openF1Menu()" )
  printDRP( yrp._not )
end

function DarkRP.openF4Menu()
  --Description: Open the F4 menu.
  printDRP( "openF4Menu()" )
  printDRP( yrp._not )
end

function DarkRP.openHitMenu( hitman )
  --Description: Open the menu that requests a hit.
  printDRP( "openHitMenu( hitman )" )
  printDRP( yrp._not )
end

function DarkRP.openKeysMenu()
  --Description: Open the keys/F2 menu.
  printDRP( "openKeysMenu()" )
  printDRP( yrp._not )
end

function DarkRP.openPocketMenu()
  --Description: Open the DarkRP pocket menu.
  printDRP( "openPocketMenu()" )
  printDRP( yrp._not )
end

function DarkRP.readNetDoorVar()
  --Description: Internal function. You probably shouldn't need this. DarkRP
  --             calls this function when reading DoorVar net messages.
  --             This function reads the net data for a specific DoorVar.
  printDRP( "readNetDoorVar()" )
  printDRP( yrp._not )
  return "Old readNetDoorVar", nil
end

function DarkRP.refreshF1Menu()
  --Description: Close the F1 help menu.
  printDRP( "refreshF1Menu()" )
  printDRP( yrp._not )
end

function DarkRP.removeChatReceiver( prefix )
  --Description: Remove a chat command receiver
  printDRP( "removeChatReceiver( prefix )" )
  printDRP( yrp._not )
end

function DarkRP.removeF4MenuTab( name )
  --Description: Remove a tab from the F4 menu by name.
  printDRP( "removeF4MenuTab( name )" )
  printDRP( yrp._not )
end

function DarkRP.setPreferredJobModel( teamNr, model )
  --Description: Set the model preferred by the player (if the job allows multiple models).
  printDRP( "setPreferredJobModel( teamNr, model )" )
  printDRP( yrp._not )
end

function DarkRP.switchTabOrder( firstTab, secondTab )
  --Description: Switch the order of two tabs.
  printDRP( "switchTabOrder( firstTab, secondTab )" )
  printDRP( yrp._not )
end

function DarkRP.textWrap( text, font, width )
  --Description: Wrap a text around when reaching a certain width.
  printDRP( "textWrap( text, font, width )" )
  printDRP( yrp._not )
  return text
end

function DarkRP.toggleF4Menu()
  --Description: Toggle the state of the F4 menu (open or closed).
  printDRP( "toggleF4Menu()" )
  printDRP( yrp._not )
  return text
end
