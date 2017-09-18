--[[
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
]]--

include( "shared_pres.lua" )

include( "shared.lua" )

--##############################################################################
--Resolutions
function ggT( _num1, _num2 )
  local _ggt = _num1 % _num2
  while ( _ggt != 0 ) do
    _num1 = _num2
    _num2 = _ggt

    _ggt = _num1 % _num2
  end
  return _num2
end

function getResolutionRatio()
  local _ggt = ggT( ScrW(), ScrH() )
  return ScrW()/_ggt, ScrH()/_ggt
end

function getPictureRatio( w, h )
  local _ggt = ggT( w, h )
  return w/_ggt, h/_ggt
end

function lowerToScreen( w, h )
  local tmpW = w
  local tmpH = h
  if w > ScrW() then
    local per = tmpW / ScrW()
    tmpW = tmpW / per
    tmpH = tmpH / per
  end
  if tmpH > ScrH() then
    local per = tmpH / ScrH()
    tmpW = tmpW / per
    tmpH = tmpH / per
  end
  return tmpW, tmpH
end

function ctrF( tmpNumber )
  tmpNumber = 2160/tmpNumber
  return math.Round( tmpNumber, 8 )
end

function ctrW( tmpNumber )
  if isnumber( tonumber( tmpNumber ) ) and tmpNumber != nil then
    tmpNumber = 2160/tmpNumber
    return math.Round( ScrH()/tmpNumber )
  else
    return -1
  end
end

function ctrH( tmpNumber )
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
	draw.RoundedBox( ctrW(r), ctrW(x), ctrW(y), ctrW(w), ctrW(h), col )
end

function drawRBoxBr( r, x, y, w, h, col, br )
	draw.RoundedBox( ctrW(r), ctrW(x-br), ctrW(y-br), ctrW(w+2*br-1), ctrW(2*br), col )
  draw.RoundedBox( ctrW(r), ctrW(x-br), ctrW(y+h-br), ctrW(w+2*br-1), ctrW(2*br), col )
  draw.RoundedBox( ctrW(r), ctrW(x-br), ctrW(y), ctrW(2*br), ctrW(h), col )
  draw.RoundedBox( ctrW(r), ctrW(x+w-br), ctrW(y), ctrW(2*br), ctrW(h), col )
end

function drawRBoxCr( x, y, size, col )
	draw.RoundedBox( ctrW(size/2), ctrW(x), ctrW(y), ctrW(size), ctrW(size), col )
end

function drawText( text, font, x, y, col, ax, ay )
	draw.SimpleText( text, font, ctrW(x), ctrW(y), col, ax, ay)
end

function createVGUI( art, parent, w, h, x, y )
  local tmp = vgui.Create( art, parent, nil )
  if w != nil and h != nil then
    tmp:SetSize( ctrW(w), ctrW(h) )
  end
  if x != nil and y != nil then
    tmp:SetPos( ctrW(x), ctrW(y) )
  end
  return tmp
end
--##############################################################################

--##############################################################################
--Includes
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
--##############################################################################

net.Receive( "yrpInfoBox", function( len )
  local _tmp = createVGUI( "DFrame", nil, 800, 400, 0, 0 )
  _tmp:SetTitle( "Notification" )
  local _text = net.ReadString()
  function _tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
    draw.SimpleText( _text, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
  printGM( "note", "All entities are loaded." )
  playerready = 1

  loadCompleteHud()

  http.Fetch( "https://docs.google.com/document/d/1mvyVK5OzHajMuq6Od74-RFaaRV7flbR2pYBiyuWVGxA/edit?usp=sharing",
    function( body, len, headers, code )
      local StartPos = string.find( body, "#", 1, false )
      local EndPos = string.find( body, "*", 1, false )
      local versionOnline = string.sub( body, StartPos+1, EndPos-1 )

      local cur2num = string.Replace( GAMEMODE.Version, ".", "" )
      local new2num = string.Replace( versionOnline, ".", "" )
      local verart = "Up-To-Date"
      if cur2num < new2num then
        verart = "NEW"
      elseif cur2num > new2num then
        verart = "OLDER"
      end
      if versionOnline != GAMEMODE.Version then
        yrp.outdated = true
        local frame = createVGUI( "DFrame", nil, 700, 320, 0, 0 )
        frame:Center()
        frame:SetTitle( "" )

        function frame:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
          draw.SimpleText( verart .. " YOURRP VERSION AVAILABLE!", "HudBars", pw/2, ph/2 - ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( "Current YOURRP Version: " .. GAMEMODE.Version, "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( "Workshop Version: " .. versionOnline, "HudBars", pw/2, ph/2 + ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        local showChanges = createVGUI( "DButton", frame, 400, 50, 350-200, 260 )
        showChanges:SetText( "" )
        function showChanges:DoClick()
          gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152" )
        end
        function showChanges:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
          draw.SimpleText( "Show Changes", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        frame:MakePopup()
      else
        yrp.outdated = false
        printGM( "note", "YourRP is on the newest version (unstable)")
      end
    end,
    function( error )
      -- We failed. =(
    end
   )

	--net.Start( "clientFinished" )
  --net.SendToServer()
end

--Remove Ragdolls after 60 sec
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
  return false
end

function drawPlate( ply, string )
  if ply:Alive() and ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
    cam.Start3D2D( ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) + Vector( 0, 0, ply:GetModelScale() * 20 ), Angle( 0, ply:GetAngles().y-90, 90 ), ply:GetModelScale()/4 )
      draw.RoundedBox( 0, -55, 0, 110, 20, Color( 0, 0, 0, 200 ) )
      draw.SimpleText( string, "HudBars", 0, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    cam.End3D2D()
  end
end

function drawPlates()
  for k, v in pairs( player.GetAll() ) do
    if v:GetNWBool( "tag", false ) then
      if tostring( v:SteamID() ) == "STEAM_0:1:20900349" then
        drawPlate( v, "DEVELOPER" )
      end
    end
  end
end
hook.Add( "PostPlayerDraw", "DrawName", drawPlates )
