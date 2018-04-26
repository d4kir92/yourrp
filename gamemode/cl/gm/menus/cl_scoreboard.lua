--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_scoreboard.lua

local sb_groups = {}
net.Receive( "getScoreboardGroups", function()
  sb_groups = net.ReadTable()
end)
timer.Simple( 1, function()
  net.Start( "getScoreboardGroups" )
  net.SendToServer()
end)
timer.Simple( 6, function()
  net.Start( "getScoreboardGroups" )
  net.SendToServer()
end)

local scoreboard = {}

local elePos = {}
elePos.x = 0
elePos.y = 0

local _yrpIcon = Material( "yrp/yrp_icon" )
local _br = 40

function hasGroupPlayers( id )
  for k, ply in pairs( player.GetAll() ) do
    if tonumber( ply:GetNWString( "groupUniqueID" ) ) == tonumber( id ) then
      return true
    end
  end
  return false
end

function hasLowerGroupPlayers( id )
  for k, group in pairs( sb_groups ) do
    if tonumber( group.uppergroup ) == tonumber( id ) then
      if hasGroupPlayers( group.uniqueID ) then
        return true
      elseif hasLowerGroupPlayers( group.uniqueID ) then
        return true
      end
    end
  end
  return false
end

function hasGroupRowPlayers( id )
  for g, groups in pairs( sb_groups ) do
    if tonumber( groups.uniqueID ) == tonumber( id ) then
      if hasGroupPlayers( groups.uniqueID ) then
        return true
      else
        if hasLowerGroupPlayers( groups.uniqueID ) then
          return true
        end
      end
    end
  end
  return false
end

function drawGroupPlayers( id )
  elePos.y = elePos.y + 50
  for k, ply in pairs( player.GetAll() ) do
    if ply != NULL then
      if tonumber( id ) == tonumber( ply:GetNWString( "groupUniqueID" ) ) then
        local _tmpPly = createD( "DButton", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), ctr( 128 ), ctr( elePos.x ), ctr( elePos.y ) )
        _tmpPly:SetText( "" )
        _tmpPly.gerade = k%2
        _tmpPly.level = 1
        _tmpPly.rpname = ply:RPName() or ""
        _tmpPly.rolename = ply:GetNWString( "roleName" ) or ""
        _tmpPly.groupname = ply:GetNWString( "groupName" ) or ""
        _tmpPly.rank = ply:GetUserGroup() or ""
        _tmpPly.ping = ply:Ping() or ""
        _tmpPly.usergroup = ply:GetUserGroup() or ""
        _tmpPly.steamname = ply:SteamName() or ""
        _tmpPly.lang = get_language_name( ply:GetNWString( "client_lang", lang_string( "none" ) ) )
        _tmpPly.money = ply:GetNWString( "money" )
        _tmpPly.moneybank = ply:GetNWString( "moneybank" )
        local _pt = string.FormattedTime( ply:GetNWFloat( "uptime_current", 0 ) )
        if _pt.m < 10 then
          _pt.m = "0" .. _pt.m
        end
        if _pt.h < 10 then
          _pt.h = "0" .. _pt.h
        end
        _tmpPly.playtime = _pt.h .. ":" .. _pt.m

        local _tmp_p_ava = createD( "DPanel", _tmpPly, ctr( 128-8 ), ctr( 128-8 ), ctr( 4 ), ctr( 4 ) )
        _tmp_p_ava.Avatar = createD( "AvatarImage", _tmp_p_ava, ctr( 128-8 ), ctr( 128-8 ), 0, 0 )
        _tmp_p_ava.Avatar:SetPlayer( ply, ctr( 128-8 ) )
        _tmp_p_ava.Avatar:SetPaintedManually( true )
        function _tmp_p_ava:Paint( pw, ph )
          render.ClearStencil()
          render.SetStencilEnable( true )

            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )

            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )

            render.SetStencilFailOperation( STENCILOPERATION_INCR )
            render.SetStencilPassOperation( STENCILOPERATION_KEEP )
            render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

            render.SetStencilReferenceValue( 1 )

            drawRoundedBox( ph/2, 0, 0, pw, ph, Color( 0, 0, 0, 255 ) )

            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

            self.Avatar:SetPaintedManually(false)
            self.Avatar:PaintManual()
            self.Avatar:SetPaintedManually(true)

          render.SetStencilEnable( false )
        end

        function _tmpPly:Paint( pw, ph )
          local _extra = 0
          if self.gerade == 0 then
            _extra = 50
          end
          if self:IsHovered() then
            if self.gerade == 1 then
            end
            draw.RoundedBoxEx( ph/2, 0, 0, pw, ph, Color( 255, 255, 0, 200 ), true, false, true, false )
          else
            draw.RoundedBoxEx( ph/2, 0, 0, pw, ph, Color( _extra, _extra, _extra, 200 ), true, false, true, false )
          end

          draw.SimpleTextOutlined( self.rpname, "sef", ctr( 128+16 ), ph/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( string.upper( self.rank ), "sef", ctr( 128+16 ), ph*3/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( self.rolename, "sef", ctr( 700 ), ph/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( self.groupname, "sef", ctr( 700 ), ph*3/4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( string.upper( self.lang ), "sef", pw - ctr( 1000 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( self.playtime, "sef", pw - ctr( 180 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( self.ping, "sef", pw - ctr( 20 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end

        function _tmpPly:DoClick()
          local _info = createD( "DFrame", nil, ctr( 800 ), ctr( 800 ), ctr( 0 ), ctr( 0 ) )
          _info:SetTitle( "" )

          local _mx, _my = gui.MousePos()
          _info:SetPos( _mx - _info:GetWide()/2, _my - ctr( 25 ) )
          _info:MakePopup()
          _info.startup = true
          function _info:Paint( pw, ph )
            if !pa( _tmpPly ) then
              self:Remove()
            else
              if !self:HasFocus() and self.startup then
                self.startup = false
              else
                if pa( _info ) then
                  if !self:HasFocus() then
                    self:Remove()
                  end
                end
              end
              surfaceWindow( self, pw, ph, lang_string( "info" ) )

              draw.SimpleTextOutlined( lang_string( "nick" ) .. ":", "sef", ctr( 10 ), ctr( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
              draw.SimpleTextOutlined( string.upper( _tmpPly.steamname ), "sef", ctr( 10 ), ctr( 440 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

              if LocalPlayer():HasAccess() then
                draw.SimpleTextOutlined( lang_string( "moneychar" ) .. ":", "sef", ctr( 10 ), ctr( 500 ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
                draw.SimpleTextOutlined( formatMoney( ply, _tmpPly.money ), "sef", ctr( 10 ), ctr( 540 ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

                draw.SimpleTextOutlined( lang_string( "moneybank" ) .. ":", "sef", ctr( 10 ), ctr( 600 ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
                draw.SimpleTextOutlined( formatMoney( ply, _tmpPly.moneybank ), "sef", ctr( 10 ), ctr( 640 ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
              end
            end
          end

          _info.profile = createD( "DButton", _info, ctr( 780 ), ctr( 50 ), ctr( 10 ), ctr( 60 ) )
          _info.profile:SetText( "" )
          function _info.profile:Paint( pw, ph )
            surfaceButton( self, pw, ph, lang_string( "openprofile" ) )
          end
          function _info.profile:DoClick()
            if pa( ply ) then
              ply:ShowProfile()
            end
          end
        end

        elePos.y = elePos.y + 128
      end
    end
  end
end

function drawGroup( id, name, color )
  elePos.y = elePos.y + 50

  local _color = string.Explode( ",", color )
  local _tmpPanel = createD( "DPanel", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), 9999, ctr( elePos.x ), ctr( elePos.y ) )
  _tmpPanel.color = Color( _color[1], _color[2], _color[3], 200 )
  function _tmpPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
    draw.SimpleTextOutlined( name, "sef", ctr( 10 ), ctr( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  if hasGroupPlayers( id ) then
    elePos.y = elePos.y + 50
    local _tmpHeader = createD( "DPanel", _SBSP, BScrW() - ctr(400) - ctr( 110 ) - ctr( elePos.x ), ctr( 50 ), ctr( elePos.x ), ctr( elePos.y ) )
    _tmpHeader.color = Color( _color[1], _color[2], _color[3], 200 )
    function _tmpHeader:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, self.color )
      --draw.SimpleTextOutlined( lang_string( "level" ), "sef", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "name" ) .. "/" .. lang_string( "usergroup" ), "sef", ctr( 128 + 16 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "role" ) .. "/" .. lang_string( "group" ), "sef", ctr( 700 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( "Language", "sef", pw - ctr( 1000 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "playtime" ), "sef", pw - ctr( 180 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "ping" ), "sef", pw - ctr( 20 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      --draw.SimpleTextOutlined( lang_string( "mute" ), "sef", pw - ctr( 100 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end

    drawGroupPlayers( id )
  end
  return _tmpPanel
end

function hasLowerGroup( id )
  for k, group in pairs( sb_groups ) do
    if tonumber( group.uppergroup ) == tonumber( id ) then
      return true
    end
  end
  return false
end

function drawLowerGroup( id )
  for k, group in pairs( sb_groups ) do
    if tonumber( id ) == tonumber( group.uniqueID ) then
      local _tmpGroup = drawGroup( group.uniqueID, group.groupID, group.color )
      return _tmpGroup
    end
  end
end

function tryLowerGroup( id )
  if hasLowerGroup( id ) then
    elePos.x = elePos.x + ctr( 6 )
    for k, group in pairs( sb_groups ) do
      if tonumber( group.uppergroup ) == tonumber( id ) then
        local tmp = drawLowerGroup( group.uniqueID )
        tryLowerGroup( group.uniqueID )

        elePos.y = elePos.y + ctr( 6 )

        local tmpX, tmpY = tmp:GetPos()
        tmp:SetSize( tmp:GetWide(), ctr( elePos.y + 50 ) - tmpY )
      end
    end
  end
end

function drawGroupRow( id )
  if hasGroupRowPlayers( id ) then
    for k, group in pairs( sb_groups ) do
      if tonumber( id ) == tonumber( group.uniqueID ) then
        local tmp = drawGroup( group.uniqueID, group.groupID, group.color )
        tryLowerGroup( group.uniqueID )

        elePos.y = elePos.y + ctr( 6 )

        local tmpX, tmpY = tmp:GetPos()
        tmp:SetSize( tmp:GetWide(), ctr( elePos.y+50 ) - tmpY )
      end
    end
  end
end

function drawGroups()
  local _not_first = false
  for k, group in pairs( sb_groups ) do
    if tonumber( group.uppergroup ) == tonumber( -1 ) then
      if hasGroupRowPlayers( group.uniqueID ) then
        if _not_first then
          elePos.y = elePos.y + 40
        end
        _not_first = true
      end

      elePos.x = ctr( 10 )
      drawGroupRow( group.uniqueID )
    end
  end
end

function drawScoreboard()
  elePos.x = ctr( 10 )
  elePos.y = ctr( -50 )
  drawGroups()
end

function BScrW()
  --[[ give ScrW() only when under 21:9 ]]--
  if ScrW() > ScrH()*2.5 then
    return ctr( 3840 )
  else
    return ScrW()
  end
end

isScoreboardOpen = false
function scoreboard:show_sb()
  net.Start( "getScoreboardGroups" )
  net.SendToServer()

  isScoreboardOpen = true
  if _SBFrame != nil then
    _SBFrame:Remove()
    _SBFrame = nil
  end
  local _w = BScrW() - ctr( 400 )
  _SBFrame = createD( "DFrame", nil, _w, ScrH(), 10, 10 )
  _SBFrame:SetTitle( "" )
  _SBFrame:ShowCloseButton( false )
  _SBFrame:SetDraggable( false )
  _SBFrame:Center()

  _SBFrame:MakePopup()

  local _mapPNG = getMapPNG()

  function _SBFrame:Paint( pw, ph )
    draw.RoundedBox( 0, ctr( 256 ), ctr( _br ), pw - ctr( 256*2 ), ctr( 125 ), get_color( "epicBlue" ) )

    draw.RoundedBox( 0, ctr( _br ), ctr( 256 - _br ), pw - ctr( _br*2 ), ph, get_color( "darkBG" ) )

    draw.SimpleTextOutlined( GAMEMODE:GetGameDescription(), "ScoreBoardNormal", ctr( 256 + 20 ), ctr( 75 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( GetHostName(), "ScoreBoardTitle", ctr( 256 + 20 ), ctr( 120 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "map" ) .. ": " .. GetNiceMapName(), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 75 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "players" ) .. ": " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 125 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrpIcon	)
  	surface.DrawTexturedRect( 0, ctr( 4 ), ctr( 256 ), ctr( 256 ) )

    if _mapPNG != false then
      draw.RoundedBox( 0, pw-ctr( 256+8 ), 0, ctr( 256+8 ), ctr( 256+8 ), Color( 0, 0, 0, 255 ) )

      surface.SetDrawColor( 255, 255, 255, 255 )
    	surface.SetMaterial( _mapPNG	)
    	surface.DrawTexturedRect( pw-ctr( 256+4 ), ctr( 4 ), ctr( 256 ), ctr( 256 ) )
    else
      surface.SetDrawColor( 255, 255, 255, 255 )
      surface.SetMaterial( _yrpIcon	)
      surface.DrawTexturedRect( pw-ctr( 256+4 ), ctr( 4 ), ctr( 256 ), ctr( 256 ) )
    end
  end

  _SBSP = createD( "DScrollPanel", _SBFrame, _w-ctr( 80 ), ScrH() - ctr( 256+48-50 ) - ctr( 10 ), ctr( 40 ), ctr( 256+48-50+10 ) )

  local _DPanelHeader = createD( "DPanel", _SBSP, ScrH(), ScrH(), 0, 0 )
  function _DPanelHeader:Paint( pw, ph )
    --draw.RoundedBox( 0, 0, 0, pw, ph, get_color( "darkBG" ) )
  end

  drawScoreboard()
end

function scoreboard:hide_sb()
  isScoreboardOpen = false
  if _SBFrame != nil then
    _SBFrame:Remove()
    _SBFrame = nil
    gui.EnableScreenClicker( false )
  end
end

function GM:ScoreboardShow()
	scoreboard:show_sb()
end

function GM:ScoreboardHide()
  if scoreboard != nil then
	   scoreboard:hide_sb()
   end
end
