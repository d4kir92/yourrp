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

include( "api/color.lua" )
include( "api/derma.lua" )
include( "api/math.lua" )

--##############################################################################

function ChangeLanguage( parent, w, h, x, y )
  local tmp = createD( "DComboBox", parent, w, h, x, y )
  tmp:SetValue( lang.lang )
  tmp:AddChoice( "[AUTOMATIC]", "auto" )
  for k, v in pairs( lang.all ) do
    tmp:AddChoice( v.ineng .. "/" .. v.lang, v.short )
  end
  tmp.OnSelect = function( panel, index, value, data )
    changeLang( data )
  end
  return tmp
end
--##############################################################################

function isInTable( table, item )
  for k, v in pairs( table ) do
    if string.lower( tostring( v ) ) == string.lower( tostring( item.ClassName ) ) then
      return true
    end
  end
  return false
end

function openSelector( table, dbTable, dbSets, dbWhile, closeF )
  local table2 = string.Explode( ",", _globalWorking )
  local frame = createVGUI( "DFrame", nil, 2000, 2000, 0, 0 )
  frame:Center()
  frame:SetTitle( "" )
  function frame:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )
  end
  function frame:OnClose()
    hook.Call( closeF )
  end

  local search = createVGUI( "DTextEntry", frame, 2000 - 20, 40, 10, 50 )

  local site = {}
  site.cur = 1
  site.max = 1
  site.count = #table
  function getMaxSite()
    local tmpMax = math.Round( site.count/42, 2 )
    site.max = math.Round( site.count/42, 0 )
    if tmpMax > site.max then
      site.max = site.max + 1
    end
  end
  getMaxSite()

  local scrollpanel = createVGUI( "DPanel", frame, 2000 - 20, 2000 - 50 - 40 - 10 - 10, 10, 50+40+10 )
  function scrollpanel:Paint( pw, ph )
    //draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
    draw.SimpleText( site.cur .. "/" .. site.max, "sef", pw/2, ph - 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local tmpCache = {}
  local tmpSelected = {}

  function showList()
    for k, v in pairs( tmpCache ) do
      v:Remove()
    end

    local itemSize = 320

    local tmpBr = 25
    local tmpX = 0
    local tmpY = 0

    site.count = 0
    local count = 0
    for k, v in pairs( table ) do
      if v.WorldModel == nil then
        v.WorldModel = v.Model or ""
      end
      if v.PrintName == nil then
        v.PrintName = v.Name or ""
      end
      if v.ClassName == nil then
        v.ClassName = v.Class or ""
      end

      tmpSelected[k] = {}
      tmpSelected[k].ClassName = v.ClassName
      if isInTable( table2, v ) then
        tmpSelected[k].selected = true
      else
        tmpSelected[k].selected = false
      end

      if string.find( string.lower( v.WorldModel ), search:GetText() ) or string.find( string.lower( v.PrintName ), search:GetText() ) or string.find( string.lower( v.ClassName ), search:GetText() ) then
        site.count = site.count + 1
        if ( site.count - 1 ) >= ( site.cur - 1 ) * 25 and ( site.count - 1 ) < ( site.cur ) * 25 then
          count = count + 1
          tmpCache[k] = createVGUI( "DPanel", scrollpanel, itemSize, itemSize, tmpX, tmpY )

          local tmpPointer = tmpCache[k]
          function tmpPointer:Paint( pw, ph )
            if tmpSelected[k].selected then
              draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 200 ) )
            else
              draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
            end
          end

          if v.WorldModel != nil and v.WorldModel != "" then
            local icon = createVGUI( "SpawnIcon", tmpPointer, itemSize, itemSize, 0, 0 )
            icon.item = v
            icon:SetText( "" )
            timer.Create( "shop" .. count, 0.5*count, 1, function()
              if icon != nil and icon != NULL and icon.item != nil then
                icon:SetModel( icon.item.WorldModel )
                if icon.Entity != nil then
                  icon.Entity:SetModelScale( 1, 0 )
                  icon:SetLookAt( Vector( 0, 0, 0 ) )
                  icon:SetCamPos( Vector( 0, -30, 15 ) )
                end
              end
            end)
          end

          local tmpButton = createVGUI( "DButton", tmpPointer, 256, 256, 0, 0 )
          tmpButton:SetText( "" )
          function tmpButton:Paint( pw, ph )
            draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 0 ) )
            local text = lang.notadded
            if tmpSelected[k].selected then
              text = lang.added
            end
            draw.SimpleText( text, "sef", pw/2, ctrW( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( v.PrintName, "sef", pw/2, ph - ctrW( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end
          function tmpButton:DoClick()
            if tmpSelected[k].selected then
              tmpSelected[k].selected = false
            else
              tmpSelected[k].selected = true
            end
            local tmpString = ""
            for k, v in pairs( tmpSelected ) do
              if v.selected and v.ClassName != nil then
                if tmpString == "" then
                  tmpString = v.ClassName
                else
                  tmpString = tmpString .. "," .. v.ClassName
                end
              end
            end
            net.Start( "dbUpdate" )
              net.WriteString( dbTable )
              net.WriteString( dbSets .. " = '" .. tmpString .. "'" )
              net.WriteString( dbWhile )
            net.SendToServer()
            _globalWorking = tmpString
          end

          tmpX = tmpX + itemSize + tmpBr
          if tmpX > 2000 - itemSize - tmpBr then
            tmpX = 0
            tmpY = tmpY + itemSize + tmpBr
          end
        end
      end
    end
  end

  local nextB = createVGUI( "DButton", frame, 200, 50, 2000 - 10 - 200, 1800 )
  nextB:SetText( "" )
  function nextB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleText( lang.nextsite, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function nextB:DoClick()
    if site.max > site.cur then
      site.cur = site.cur + 1
      showList()
    end
  end

  local prevB = createVGUI( "DButton", frame, 200, 50, 10, 1800 )
  prevB:SetText( "" )
  function prevB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleText( lang.prevsite, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function prevB:DoClick()
    site.cur = site.cur - 1
    if site.cur < 1 then
      site.cur = 1
    end
    showList()
  end

  function search:OnChange()
    site.cur = 1
    showList()
    getMaxSite()
  end
  showList()

  frame:MakePopup()
end

function openSingleSelector( table )
  local site = {}
  site.cur = 1
  site.max = 1
  site.count = #table
  function getMaxSite()
    local tmpMax = math.Round( site.count/42, 2 )
    site.max = math.Round( site.count/42, 0 )
    if tmpMax > site.max then
      site.max = site.max + 1
    end
  end
  getMaxSite()

  local shopsize = ScrH()
  local frame = vgui.Create( "DFrame" )
  frame:SetSize( shopsize, shopsize )
  frame:SetPos( ScrW2() - shopsize/2, ScrH2() - shopsize/2 )
  frame:SetTitle( lang.itemMenu )
  function frame:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.dbackground )
  end

  local PanelSelect = createD( "DPanel", frame, shopsize - ctr( 20 ), shopsize - ctr( 100 ), ctr( 10 ), ctr( 100 ) )
  PanelSelect:SetText( "" )
  function PanelSelect:Paint( pw, ph )
    //draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
    draw.SimpleText( site.cur .. "/" .. site.max, "sef", pw/2, ph - ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local search = createD( "DTextEntry", frame, shopsize - ctr( 20 ), ctr( 40 ), ctr( 10 ), ctr( 50 ) )
  function showList()
    local tmpBr = 25
    local tmpX = 0
    local tmpY = 0

    PanelSelect:Clear()
    local _cat = nil
    if tab == "vehicles" then
      _cat = "Category"
    end

    site.count = 0
    local count = 0
    local iconsize = 384
    local amount = 20
    for k, item in SortedPairsByMemberValue( table, _cat, false ) do
      item.PrintName = item.PrintName or item.Name or ""
      item.ClassName = item.ClassName or item.Class or ""
      item.WorldModel = item.WorldModel or item.Model or ""
      if string.find( string.lower( item.WorldModel or "XXXXXXXXX" ), search:GetText() ) or string.find( string.lower( item.PrintName or "XXXXXXXXX" ), search:GetText() ) or string.find( string.lower( item.ClassName or "XXXXXXXXX" ), search:GetText() ) then
        site.count = site.count + 1
        if ( site.count - 1 ) >= ( site.cur - 1 ) * amount and ( site.count - 1 ) < ( site.cur ) * amount then
          count = count + 1

          if item.WorldModel == nil then
            item.WorldModel = item.Model or ""
          end
          if item.ClassName == nil then
            item.ClassName = item.Class or ""
          end
          if item.PrintName == nil then
            item.PrintName = item.Name or ""
          end

          local icon = createD( "SpawnIcon", PanelSelect, ctr( iconsize ), ctr( iconsize ), ctr( tmpX ), ctr( tmpY ) )
          icon.item = item
          icon:SetText( "" )
          timer.Create( "shop" .. count, 0.6*count, 1, function()
            if icon != nil and icon != NULL and icon.item != nil then
              icon:SetModel( icon.item.WorldModel )
            end
          end)
          icon:SetTooltip( item.PrintName )
          local _tmpName = createVGUI( "DButton", icon, iconsize, iconsize, 10, 10 )
          _tmpName:SetText( "" )
          function _tmpName:Paint( pw, ph )
            draw.SimpleText( item.PrintName, "pmT", pw/2, ph-ctrW( 35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end
          function _tmpName:DoClick()
            LocalPlayer():SetNWString( "WorldModel", item.WorldModel )
            LocalPlayer():SetNWString( "ClassName", item.ClassName )
            LocalPlayer():SetNWString( "PrintName", item.PrintName )
            LocalPlayer():SetNWString( "Skin", item.Skin )
            frame:Close()
          end
          tmpX = tmpX + iconsize + tmpBr
          if ctr( tmpX ) > shopsize - ctr( iconsize ) - tmpBr then
            tmpX = 0
            tmpY = tmpY + iconsize + tmpBr
          end
        end
      end
    end
  end

  local nextB = createD( "DButton", frame, ctr( 200 ), ctr( 50 ), shopsize - ctr( 10 ) - ctr( 200 ), ctr( 1800 ) )
  nextB:SetText( "" )
  function nextB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleText( lang.nextsite, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function nextB:DoClick()
    if site.max > site.cur then
      site.cur = site.cur + 1
      showList()
    end
  end

  local prevB = createD( "DButton", frame, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 1800 ) )
  prevB:SetText( "" )
  function prevB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleText( lang.prevsite, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function prevB:DoClick()
    site.cur = site.cur - 1
    if site.cur < 1 then
      site.cur = 1
    end
    showList()
  end

  function search:OnChange()
    site.cur = 1
    showList()
    getMaxSite()
  end
  showList()

  frame:MakePopup()
end

--##############################################################################
--Includes
include( "shared/sh_player.lua" )

include( "integration/darkrp.lua" )

include( "client/database/db_database.lua" )

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
include( "client/vehicle/cl_vehicle_options.lua" )
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

local testingversion = false
local serverVersion = "-1.-1.-1"
function testVersion()
  if !testingversion then
    testingversion = true
    net.Start( "getServerVersion" )
    net.SendToServer()
  end
end

function showVersion()
  local ply = LocalPlayer()

  http.Fetch( "https://docs.google.com/document/d/1mvyVK5OzHajMuq6Od74-RFaaRV7flbR2pYBiyuWVGxA/edit?usp=sharing",
    function( body, len, headers, code )
      local StartPos = string.find( body, "#", 1, false )
      local EndPos = string.find( body, "*", 1, false )
      local versionOnline = string.sub( body, StartPos+1, EndPos-1 )

      --Client
      local cur2num = string.Replace( GAMEMODE.Version, ".", "" )
      local new2num = string.Replace( versionOnline, ".", "" )
      local verart = "Up-To-Date"
      yrp.versionCol = Color( 0, 255, 0, 255 )
      if cur2num < new2num then
        verart = lang.versionnewpre .. " " .. GAMEMODE.Name .. " " .. lang.versionnewpos
        yrp.versionCol = Color( 255, 0, 0, 255 )
      elseif cur2num > new2num then
        verart = lang.versionoldpre .. " " .. GAMEMODE.Name .. " " .. lang.versionoldpos
        yrp.versionCol = Color( 100, 100, 255, 255 )
      end

      --Server
      local cur2num2 = string.Replace( GAMEMODE.Version, ".", "" )
      local new2num2 = string.Replace( versionOnline, ".", "" )
      local verart2 = "Up-To-Date"
      local outcol2 = Color( 0, 255, 0, 255 )
      if cur2num2 < new2num2 then
        verart2 = lang.versionnewpre .. " " .. GAMEMODE.Name .. " " .. lang.versionnewpos
        outcol2 = Color( 255, 0, 0, 255 )
      elseif cur2num2 > new2num2 then
        verart2 = lang.versionoldpre .. " " .. GAMEMODE.Name .. " " .. lang.versionoldpos
        outcol2 = Color( 100, 100, 255, 255 )
      end

      local _serverSort = ""
      if serverIsDedicated then
        GAMEMODE.dedicated = "Dedicated"
        _serverSort = lang.serverdedicated
      else
        GAMEMODE.dedicated = "Local"
        _serverSort = lang.serverlocal
      end

      local _versionsort = ""
      if GAMEMODE.VersionSort == "unstable" then
        _versionsort = lang.unstable
      elseif GAMEMODE.VersionSort == "stable" then
        _versionsort = lang.stable
      end

      if versionOnline != GAMEMODE.Version then
        yrp.outdated = true
        local frame = createVGUI( "DFrame", nil, 1000, 500, 0, 0 )
        frame:Center()
        frame:SetTitle( "" )
        function frame:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
          draw.SimpleText( "Language:", "HudBars", ctrW( 300 ), ctrW( 25 + 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
          draw.SimpleText( verart .. "! (" .. _versionsort .. ")", "HudBars", pw/2, ctrW( 100 ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( lang.currentversion .. ":", "HudBars", pw/2, ctrW( 175 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          draw.SimpleText( lang.client .. ": ", "HudBars", pw/2, ctrW( 225 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
          draw.SimpleText( GAMEMODE.Version, "HudBars", pw/2, ctrW( 225 ), yrp.versionCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

          draw.SimpleText( "(" .. _serverSort .. ") " .. lang.server .. ": ", "HudBars", pw/2, ctrW( 275 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
          draw.SimpleText( serverVersion, "HudBars", pw/2, ctrW( 275 ), outcol2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

          draw.SimpleText( lang.workshopversion .. ": ", "HudBars", pw/2, ctrW( 375 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
          draw.SimpleText( versionOnline .. " (" .. _versionsort .. ")", "HudBars", pw/2, ctrW( 375 ), Color( 0, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        local Langu = createVGUI( "DComboBox", frame, 400, 50, 10 + 300, 10 )
        Langu:SetValue( lang.lang )
        Langu:AddChoice( "[AUTOMATIC]", "auto" )
        for k, v in pairs( lang.all ) do
          Langu:AddChoice( v.ineng .. "/" .. v.lang, v.short )
        end
        Langu.OnSelect = function( panel, index, value, data )
          changeLang(data)
        end

        local showChanges = createVGUI( "DButton", frame, 460, 50, 0, 0 )
        showChanges:SetText( "" )
        function showChanges:DoClick()
          gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152" )
        end
        function showChanges:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
          draw.SimpleText( lang.showchanges, "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        if ply:IsAdmin() or ply:IsSuperAdmin() then
          local restartServer = createVGUI( "DButton", frame, 460, 50, 0, 0 )
          restartServer:SetText( "" )
          function restartServer:DoClick()
            net.Start( "restartServer" )
            net.SendToServer()
          end
          function restartServer:Paint( pw, ph )
            draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
            draw.SimpleText( lang.updateserver, "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          end

          showChanges:SetPos( ctrW( 500-460-10 ), ctrW( 425 ) )
          restartServer:SetPos( ctrW( 500+10 ), ctrW( 425 ) )
        else
          showChanges:SetPos( ctrW( 500-230 ), ctrW( 425 ) )
        end

        frame:MakePopup()
      else
        yrp.outdated = false
        printGM( "note", "YourRP is on the newest version (unstable)")
      end
      testingversion = false
    end,
    function( error )
      -- We failed. =(
    end
   )
end

net.Receive( "getServerVersion", function( len )
  serverVersion = net.ReadString()
  serverIsDedicated = net.ReadBool()
  showVersion()
end)

function GM:InitPostEntity()
  printGM( "note", "All entities are loaded." )
  playerready = true
  timer.Simple( 4, function()
    playerfullready = true
  end)

  loadCompleteHud()
  testVersion()
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
    local pos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) + Vector( 0, 0, ply:GetModelScale() * 20 )
    local ang = Angle( 0, ply:GetAngles().y-90, 90 )
    local sca = ply:GetModelScale()/4
    local str = string
    local strSize = string.len( str ) + 3
    cam.Start3D2D( pos , ang, sca )
      draw.RoundedBox( 0, -( ( strSize * 10 )/2 ), 0, strSize*10, 24, Color( 0, 0, 0, 200 ) )
      draw.SimpleText( str, "HudBars", 0, 12, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
