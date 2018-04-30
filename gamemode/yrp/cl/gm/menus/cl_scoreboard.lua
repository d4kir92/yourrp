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
          local _mx, _my = gui.MousePos()
          local _menu = createD( "DYRPMenu", nil, ctr( 500 ), ctr( 50 ), _mx - ctr( 25 ), _my - ctr( 25 ) )
          _menu:MakePopup()

          local osp = _menu:AddOption( lang_string( "openprofile" ), "icon16/page.png" )
          function osp:DoClick()
            ply:ShowProfile()
          end

          _menu:AddSpacer()

          local csid = _menu:AddOption( lang_string( "copysteamid" ), "icon16/page_copy.png" )
          function csid:DoClick()
            SetClipboardText( ply:SteamID() )
            _menu:Remove()
          end
          local csid64 = _menu:AddOption( lang_string( "copysteamid64" ), "icon16/page_copy.png" )
          function csid64:DoClick()
            SetClipboardText( ply:SteamID64() )
            _menu:Remove()
          end
          local crpname = _menu:AddOption( lang_string( "copyrpname" ), "icon16/page_copy.png" )
          function crpname:DoClick()
            SetClipboardText( ply:RPName() )
            _menu:Remove()
          end
          local csname = _menu:AddOption( lang_string( "copysteamname" ), "icon16/page_copy.png" )
          function csname:DoClick()
            SetClipboardText( ply:SteamName() )
            _menu:Remove()
          end

          if LocalPlayer():HasAccess() then
            _menu:AddSpacer()

            local ban = _menu:AddOption( lang_string( "ban" ), "icon16/world_link.png" )
            function ban:DoClick()
              net.Start( "ply_ban" )
                net.WriteEntity( ply )
              net.SendToServer()
            end
            local kick = _menu:AddOption( lang_string( "kick" ), "icon16/world_go.png" )
            function kick:DoClick()
              net.Start( "ply_kick" )
                net.WriteEntity( ply )
              net.SendToServer()
            end

            _menu:AddSpacer()

            local tpto = _menu:AddOption( lang_string( "tpto" ), "icon16/arrow_right.png" )
            function tpto:DoClick()
              net.Start( "tp_tpto" )
                net.WriteEntity( ply )
              net.SendToServer()
            end
            local bring = _menu:AddOption( lang_string( "bring" ), "icon16/arrow_redo.png" )
            function bring:DoClick()
              net.Start( "tp_bring" )
                net.WriteEntity( ply )
              net.SendToServer()
            end
            if !ply:GetNWBool( "injail", false ) then
              local jail = _menu:AddOption( lang_string( "jail" ), "icon16/lock_go.png" )
              function jail:DoClick()
                net.Start( "tp_jail" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            else
              local unjail = _menu:AddOption( lang_string( "unjail" ), "icon16/lock_open.png" )
              function unjail:DoClick()
                net.Start( "tp_unjail" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            end

            _menu:AddSpacer()

            if !ply:GetNWBool( "ragdolled", false ) then
              local ragdoll = _menu:AddOption( lang_string( "ragdoll" ), "icon16/user_red.png" )
              function ragdoll:DoClick()
                net.Start( "ragdoll" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            else
              local unragdoll = _menu:AddOption( lang_string( "unragdoll" ), "icon16/user_green.png" )
              function unragdoll:DoClick()
                net.Start( "unragdoll" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            end
            if !ply:IsFlagSet( FL_FROZEN ) then
              local freeze = _menu:AddOption( lang_string( "freeze" ), "icon16/user_suit.png" )
              function freeze:DoClick()
                net.Start( "freeze" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            else
              local unfreeze = _menu:AddOption( lang_string( "unfreeze" ), "icon16/user_gray.png" )
              function unfreeze:DoClick()
                net.Start( "unfreeze" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            end
            if !ply:GetNWBool( "godmode", false ) then
              local god = _menu:AddOption( lang_string( "god" ), "icon16/star.png" )
              function god:DoClick()
                net.Start( "god" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            else
              local ungod = _menu:AddOption( lang_string( "ungod" ), "icon16/stop.png" )
              function ungod:DoClick()
                net.Start( "ungod" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            end
            if !ply:GetNWBool( "cloaked", false ) then
              local cloak = _menu:AddOption( lang_string( "cloak" ), "icon16/status_offline.png" )
              function cloak:DoClick()
                net.Start( "cloak" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            else
              local uncloak = _menu:AddOption( lang_string( "uncloak" ), "icon16/status_online.png" )
              function uncloak:DoClick()
                net.Start( "uncloak" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            end
            if !ply:GetNWBool( "blinded", false ) then
              local blind = _menu:AddOption( lang_string( "blind" ), "icon16/weather_sun.png" )
              function blind:DoClick()
                net.Start( "blind" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            else
              local unblind = _menu:AddOption( lang_string( "unblind" ), "icon16/weather_clouds.png" )
              function unblind:DoClick()
                net.Start( "unblind" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            end
            if !ply:IsOnFire() then
              local ignite = _menu:AddOption( lang_string( "ignite" ), "icon16/fire.png" )
              function ignite:DoClick()
                net.Start( "ignite" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            else
              local extinguish = _menu:AddOption( lang_string( "extinguish" ), "icon16/water.png" )
              function extinguish:DoClick()
                net.Start( "extinguish" )
                  net.WriteEntity( ply )
                net.SendToServer()
                _menu:Remove()
              end
            end

            local slay = _menu:AddOption( lang_string( "slay" ), "icon16/delete.png" )
            function slay:DoClick()
              net.Start( "slay" )
                net.WriteEntity( ply )
              net.SendToServer()
              _menu:Remove()
            end
            local slap = _menu:AddOption( lang_string( "slap" ), "icon16/heart_delete.png" )
            function slap:DoClick()
              net.Start( "slap" )
                net.WriteEntity( ply )
              net.SendToServer()
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
