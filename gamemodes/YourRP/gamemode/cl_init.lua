/*
Copyright (C) 2017 Arno Zura

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see < http://www.gnu.org/licenses/ >.
*/

include( "shared_pres.lua" )

include( "shared.lua" )

//##############################################################################
//Resolutions
function calculateToResu( tmpNumber )
  tmpNumber = 2160/tmpNumber
  return math.Round( ScrH()/tmpNumber )
end

function ctr( tmpNumber )
  tmpNumber = 2160/tmpNumber
  return math.Round( ScrH()/tmpNumber )
end

function ScrW2()
  return ( ScrW() / 2 )
end

function ScrH2()
  return ( ScrH() / 2 )
end

function drawRBox( r, x, y, w, h, col )
	draw.RoundedBox( calculateToResu(r), calculateToResu(x), calculateToResu(y), calculateToResu(w), calculateToResu(h), col )
end

function drawRBoxBr( r, x, y, w, h, col, br )
	draw.RoundedBox( calculateToResu(r), calculateToResu(x-br), calculateToResu(y-br), calculateToResu(w+2*br), calculateToResu(2*br), col )
  draw.RoundedBox( calculateToResu(r), calculateToResu(x-br), calculateToResu(y+h-br), calculateToResu(w+2*br), calculateToResu(2*br), col )
  draw.RoundedBox( calculateToResu(r), calculateToResu(x-br), calculateToResu(y), calculateToResu(2*br), calculateToResu(h), col )
  draw.RoundedBox( calculateToResu(r), calculateToResu(x+w-br), calculateToResu(y), calculateToResu(2*br), calculateToResu(h), col )
end

function drawRBoxCr( x, y, size, col )
	draw.RoundedBox( calculateToResu(size/2), calculateToResu(x), calculateToResu(y), calculateToResu(size), calculateToResu(size), col )
end

function drawText( text, font, x, y, col, ax, ay )
	draw.SimpleText( text, font, calculateToResu(x), calculateToResu(y), col, ax, ay)
end

function createVGUI( art, parent, w, h, x, y )
  local tmp = vgui.Create( art, parent, nil )
  if w != nil and h != nil then
    tmp:SetSize( calculateToResu(w), calculateToResu(h) )
  end
  if x != nil and y != nil then
    tmp:SetPos( calculateToResu(x), calculateToResu(y) )
  end
  return tmp
end
//##############################################################################

//##############################################################################
//Includes
include( "darkrp.lua" )

include( "client/database/db_database.lua" )
include( "client/cl_player.lua" )

include( "client/cl_fonts.lua" )
include( "client/cl_scoreboard.lua" )
include( "client/cl_think.lua" )
include( "client/cl_hud.lua" )
include( "client/cl_chat.lua" )
include( "client/settings/cl_settings.lua" )
include( "client/roles/cl_rolesmenu.lua" )
include( "client/charakter/cl_charakter.lua" )
include( "client/buy/cl_buy.lua" )
include( "client/interact/cl_interact.lua" )
include( "client/door/cl_door_options.lua" )
//##############################################################################

net.Receive( "yrpInfoBox", function( len )
  local _tmp = createVGUI( "DFrame", nil, 800, 400, 0, 0 )
  _tmp:SetTitle( "Notification" )
  local _text = net.ReadString()
  function _tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
    draw.SimpleText( _text, "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local closeButton = createVGUI( "DButton", _tmp, 200, 50, 400 - 100, 400 - 50 )
  closeButton:SetText( "Close" )
  function closeButton:DoClick()
    _tmp:Close()
  end
  _tmp:Center()
  _tmp:MakePopup()
end)

function GM:InitPostEntity()
  printGM( "note", "All entities are loaded.")
  playerready = 1

  loadCompleteHud()

	//net.Start( "clientFinished" )
  //net.SendToServer()
end

//Remove Ragdolls after 60 sec
function RemoveDeadRag( ent )
	if (ent == NULL) or (ent == nil) then return end
	if (ent:GetClass() == "class C_ClientRagdoll") then
		if ent:IsValid() and !(ent == NULL) then
			SafeRemoveEntityDelayed( ent, 60 )
		end
	end
end
hook.Add("OnEntityCreated", "RemoveDeadRag", RemoveDeadRag)

function GM:HUDDrawTargetID()
  //Nothing
end
