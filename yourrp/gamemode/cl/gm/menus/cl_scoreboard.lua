--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_scoreboard.lua

sb_groups = {}
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

scoreboard = {}

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
  for k, ply in pairs( player.GetAll() ) do
    if ply != NULL then
      if tonumber( id ) == tonumber( ply:GetNWString( "groupUniqueID" ) ) then
        elePos.y = elePos.y + 50
        local _tmpPly = createVGUI( "DPanel", _SBSP, 1880 - elePos.x, 50, elePos.x, elePos.y )
        _tmpPly.level = 1
        _tmpPly.rpname = ply:RPName() or ""
        _tmpPly.rolename = ply:GetNWString( "roleName" ) or ""
        _tmpPly.ping = ply:Ping() or ""
        function _tmpPly:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, get_color( "epicOrange" ) )
          --draw.SimpleTextOutlined( self.level, "sef", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( self.rpname, "sef", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( self.rolename, "sef", pw - ctr( 260 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( self.ping, "sef", pw - ctr( 100 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end
      end
    end
  end
end

function drawGroup( id, name )
  elePos.y = elePos.y + 50
  local _tmpPanel = createVGUI( "DPanel", _SBSP, 1880 - elePos.x, 9999, elePos.x, elePos.y )
  function _tmpPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_color( "epicBlue" ) )
    draw.SimpleTextOutlined( name, "sef", ctr( 10 ), ctr( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  if hasGroupPlayers( id ) then
    elePos.y = elePos.y + 50
    local _tmpHeader = createVGUI( "DPanel", _SBSP, 1880 - elePos.x, 50, elePos.x, elePos.y )
    function _tmpHeader:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, get_color( "epicBlue" ) )
      --draw.SimpleTextOutlined( lang_string( "level" ), "sef", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "name" ), "sef", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "role" ), "sef", pw - ctr( 260 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "ping" ), "sef", pw - ctr( 100 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
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
      local _tmpGroup = drawGroup( group.uniqueID, group.groupID )
      return _tmpGroup
    end
  end
end

function tryLowerGroup( id )
  if hasLowerGroup( id ) then
    elePos.x = elePos.x + ctr( 20 )
    for k, group in pairs( sb_groups ) do
      if tonumber( group.uppergroup ) == tonumber( id ) then
        local tmp = drawLowerGroup( group.uniqueID )
        tryLowerGroup( group.uniqueID )

        elePos.y = elePos.y + ctr( 20 )

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
        local tmp = drawGroup( group.uniqueID, group.groupID )
        tryLowerGroup( group.uniqueID )

        elePos.y = elePos.y + ctr( 20 )

        local tmpX, tmpY = tmp:GetPos()
        tmp:SetSize( tmp:GetWide(), ctr( elePos.y+50 ) - tmpY )
      end
    end
  end
end

function drawGroups()
  for k, group in pairs( sb_groups ) do
    if tonumber( group.uppergroup ) == tonumber( -1 ) then
      elePos.x = ctr( 20 )
      drawGroupRow( group.uniqueID )
    end
  end
end

function drawScoreboard()
  elePos.x = ctr( 20 )
  elePos.y = ctr( -50 )
  drawGroups()
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
  _SBFrame = createVGUI( "DFrame", nil, 2000, 2000, 10, 10 )
  _SBFrame:SetTitle( "" )
  _SBFrame:ShowCloseButton( false )
  _SBFrame:Center()

  _SBFrame:MakePopup()

  local _mapPNG = getMapPNG()

  function _SBFrame:Paint( pw, ph )
    draw.RoundedBox( 0, ctr( _br ), ctr( _br ), pw - ctr( 50 ), ctr( 125 ), get_color( "epicBlue" ) )

    draw.RoundedBox( 0, ctr( _br ), ctr( 256 - _br ), pw - ctr( _br*2 ), ph, get_color( "darkBG" ) )

    draw.SimpleTextOutlined( GAMEMODE:GetGameDescription(), "ScoreBoardNormal", ctr( 256 + 20 ), ctr( 75 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( GetHostName(), "ScoreBoardTitle", ctr( 256 + 20 ), ctr( 120 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "map" ) .. ": " .. string.upper( game.GetMap() ), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 75 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "players" ) .. ": " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "ScoreBoardNormal", pw - ctr( 256 + 20 ), ctr( 125 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrpIcon	)
  	surface.DrawTexturedRect( 0, ctr( 4 ), ctr( 256 ), ctr( 256 ) )

    draw.RoundedBox( 0, pw-ctr( 256+8 ), 0, ctr( 256+8 ), ctr( 256+8 ), Color( 0, 0, 0, 255 ) )
    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _mapPNG	)
  	surface.DrawTexturedRect( pw-ctr( 256+4 ), ctr( 4 ), ctr( 256 ), ctr( 256 ) )
  end

  _SBSP = createVGUI( "DScrollPanel", _SBFrame, 2000-80, 2000-(256+48-50)-10, 40, 256+48-50+10 )

  local _DPanelHeader = createVGUI( "DPanel", _SBSP, 2000, 2000, 0, 0 )
  function _DPanelHeader:Paint( pw, ph )
    --draw.RoundedBox( 0, ctr( 25 ), ctr( 256 - 25 ), pw, ph, get_color( "darkBG" ) )
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
