--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:drawHitInfo()
  --Description: Start drawing the hit information above a hitman.
  printDRP( "drawHitInfo()" )
  printDRP( yrp._not )
end

function Player:drawPlayerInfo()
  --Description: Draw player info above a player's head (name, health job). Override this function to disable or change drawing behaviour in DarkRP.
  printDRP( "drawPlayerInfo()" )
  printDRP( yrp._not )
end

function Player:drawWantedInfo()
  --Description: Draw the wanted info above a player's head. Override this to disable or change the drawing of wanted info above players' heads.
  printDRP( "drawWantedInfo()" )
  printDRP( yrp._not )
end

function Player:getPreferredJobModel( teamNr )
  --Description: Draw the wanted info above a player's head. Override this to disable or change the drawing of wanted info above players' heads.
  printDRP( "getPreferredJobModel( " .. tostring( teamNr ) .. " )" )
  printDRP( yrp._not )
  return ""
end

function Player:isInRoom()
  --Description: Whether the player is in the same room as the LocalPlayer.
  printDRP( "isInRoom()" )
  printDRP( yrp._not )
  return false
end

function Player:stopHitInfo()
  --Description: Stop drawing the hit information above a hitman.
  printDRP( "stopHitInfo()" )
  printDRP( yrp._not )
end
