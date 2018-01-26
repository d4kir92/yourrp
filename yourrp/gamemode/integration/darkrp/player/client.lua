--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:drawHitInfo()
  --Description: Start drawing the hit information above a hitman.
  printGM( "darkrp", "drawHitInfo()" )
  printGM( "darkrp", DarkRP._not )
end

function Player:drawPlayerInfo()
  --Description: Draw player info above a player's head (name, health job). Override this function to disable or change drawing behaviour in DarkRP.
  printGM( "darkrp", "drawPlayerInfo()" )
  printGM( "darkrp", DarkRP._not )
end

function Player:drawWantedInfo()
  --Description: Draw the wanted info above a player's head. Override this to disable or change the drawing of wanted info above players' heads.
  printGM( "darkrp", "drawWantedInfo()" )
  printGM( "darkrp", DarkRP._not )
end

function Player:getPreferredJobModel( teamNr )
  --Description: Draw the wanted info above a player's head. Override this to disable or change the drawing of wanted info above players' heads.
  printGM( "darkrp", "getPreferredJobModel( " .. tostring( teamNr ) .. " )" )
  printGM( "darkrp", DarkRP._not )
  return ""
end

function Player:isInRoom()
  --Description: Whether the player is in the same room as the LocalPlayer.
  printGM( "darkrp", "isInRoom()" )
  printGM( "darkrp", DarkRP._not )
  return false
end

function Player:stopHitInfo()
  --Description: Stop drawing the hit information above a hitman.
  printGM( "darkrp", "stopHitInfo()" )
  printGM( "darkrp", DarkRP._not )
end
