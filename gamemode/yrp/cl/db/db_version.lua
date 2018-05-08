--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local testingversion = false
local serverVersion = "-1.-1.-1"
local v_color = Color( 255, 255, 255, 255 )
local v_tested = false
local s_sort = ""

function version_tested()
  return v_tested
end

function testVersion()
  if !testingversion then
    testingversion = true
    net.Start( "getServerVersion" )
    net.SendToServer()
  end
end

timer.Create( "check_yrp_version", 3600, 0, function()
  testVersion()
end)

function is_version_outdated()
  return LocalPlayer():GetNWBool( "version_outdated", false )
end
function version_color()
  return v_color
end
function version_sort()
  return s_sort
end

function showVersion()
  local ply = LocalPlayer()

  LocalPlayer():SetNWBool( "version_outdated", false )
  http.Fetch( "https://docs.google.com/document/d/1mvyVK5OzHajMuq6Od74-RFaaRV7flbR2pYBiyuWVGxA/edit?usp=sharing",
    function( body, len, headers, code )
      local StartPos = string.find( body, "#", 1, false )
      local EndPos = string.find( body, "*", 1, false )
      local versionOnline = string.sub( body, StartPos+1, EndPos-1 )

      --Client
      local _v_off = string.Replace( GAMEMODE.Version, "V.: ", "" )
      local _v_on = string.Replace( versionOnline, "V.: ", "" )
      local cur2num = string.Explode( ".", _v_off )
      local new2num = string.Explode( ".", _v_on )
      local verart = "Up-To-Date"
      v_color = Color( 0, 255, 0, 255 )
      for k, v in pairs( cur2num ) do
        if tonumber( cur2num[k] ) < tonumber( new2num[k] ) then
          verart = lang_string( "versionnewpre" ) .. " " .. GAMEMODE.BaseName .. " " .. lang_string( "versionnewpos" )
          v_color = Color( 255, 0, 0, 255 )
        elseif tonumber( cur2num[k] ) > tonumber( new2num[k] ) then
          verart = lang_string( "versionoldpre" ) .. " " .. GAMEMODE.BaseName .. " " .. lang_string( "versionoldpos" )
          v_color = Color( 100, 100, 255, 255 )
        end
      end

      --Server
      local _v_off2 = string.Replace( GAMEMODE.Version, "V.: ", "" )
      local _v_on2 = string.Replace( versionOnline, "V.: ", "" )
      local cur2num2 = string.Explode( ".", _v_off2 )
      local new2num2 = string.Explode( ".", _v_on2 )
      local verart2 = "Up-To-Date"
      local outcol2 = Color( 0, 255, 0, 255 )
      for k, v in pairs( cur2num2 ) do
        if tonumber( cur2num2[k] ) < tonumber( new2num2[k] ) then
          verart2 = lang_string( "versionnewpre" ) .. " " .. GAMEMODE.BaseName .. " " .. lang_string( "versionnewpos" )
          outcol2 = Color( 255, 0, 0, 255 )

          LocalPlayer():SetNWBool( "version_outdated", true )
        elseif tonumber( cur2num2[k] ) > tonumber( new2num2[k] ) then
          verart2 = lang_string( "versionoldpre" ) .. " " .. GAMEMODE.BaseName .. " " .. lang_string( "versionoldpos" )
          outcol2 = Color( 100, 100, 255, 255 )

          printGM( "note", "YourRP is on a newer version (" .. tostring( GAMEMODE.VersionSort ) .. ")")
        elseif tonumber( cur2num2[k] ) == tonumber( new2num2[k] ) then
            verart2 = lang_string( "versionoldpre" ) .. " " .. GAMEMODE.BaseName .. " " .. lang_string( "versionoldpos" )
            outcol2 = Color( 100, 100, 255, 255 )

            printGM( "note", "YourRP is on the newest version (" .. tostring( GAMEMODE.VersionSort ) .. ")")
          end
      end

      local _serverSort = ""
      if serverIsDedicated then
        GAMEMODE.dedicated = "Dedicated"
        _serverSort = lang_string( "serverdedicated" )
      else
        GAMEMODE.dedicated = "Local"
        _serverSort = lang_string( "serverlocal" )
      end

      local s_sort = ""
      if string.lower( GAMEMODE.VersionSort ) == "canary" then
        s_sort = lang_string( "canarychannel" )
      elseif string.lower( GAMEMODE.VersionSort ) == "beta" then
        s_sort = lang_string( "betachannel" )
      elseif string.lower( GAMEMODE.VersionSort ) == "stable" then
        s_sort = lang_string( "stable" )
      end

      if LocalPlayer():GetNWBool( "version_outdated", false ) then
        local frame = createVGUI( "DFrame", nil, 1200, 570, 0, 0 )
        frame:Center()
        frame:SetTitle( "" )
        function frame:Paint( pw, ph )
          --draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )

					surfaceWindow( self, pw, ph, lang_string( "about" ) )

          draw.SimpleTextOutlined( "Language:", "HudBars", ctr( 400 ), ctr( 50+30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( tostring( verart ) .. "! (" .. tostring( s_sort ) .. ")", "HudBars", pw/2, ctr( 140 ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( lang_string( "currentversion" ) .. ":", "HudBars", pw/2, ctr( 215 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( lang_string( "client" ) .. ": ", "HudBars", pw/2, ctr( 265 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( GAMEMODE.Version, "HudBars", pw/2, ctr( 265 ), v_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( "(" .. tostring( _serverSort ) .. ") " .. lang_string( "server" ) .. ": ", "HudBars", pw/2, ctr( 315 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( tostring( serverVersion ), "HudBars", pw/2, ctr( 315 ), outcol2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( lang_string( "workshopversion" ) .. ": ", "HudBars", pw/2, ctr( 415 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( tostring( versionOnline ) .. " (" .. tostring( s_sort ) .. ")", "HudBars", pw/2, ctr( 415 ), Color( 0, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end

        local _langu = derma_change_language( frame, ctr( 400 ), ctr( 50 ), ctr( 400 ), ctr( 60 ) )

        local showChanges = createVGUI( "DButton", frame, 520, 80, 0, 0 )
        showChanges:SetText( "" )
        function showChanges:DoClick()
          gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152" )
        end
        function showChanges:Paint( pw, ph )
          surfaceButton( self, pw, ph, lang_string( "showchanges" ) )
        end

        if ply:HasAccess() then
          if VERSIONART == "workshop" then
            local restartServer = createVGUI( "DButton", frame, 520, 80, 0, 0 )
            restartServer:SetText( "" )
            function restartServer:DoClick()
              net.Start( "restartServer" )
              net.SendToServer()
            end
            function restartServer:Paint( pw, ph )
  						surfaceButton( self, pw, ph, lang_string( "updateserver" ) )
            end
            restartServer:SetPos( ctr( 600+10 ), ctr( 460 ) )
          else
            local download_latest_git = createVGUI( "DButton", frame, 520, 80, 0, 0 )
            download_latest_git:SetText( "" )
            function download_latest_git:DoClick()
              gui.OpenURL( "https://github.com/d4kir92/GMOD-YourRP-unstable" )
            end
            function download_latest_git:Paint( pw, ph )
  						surfaceButton( self, pw, ph, "Download Latest Version" )
            end
            download_latest_git:SetPos( ctr( 600+10 ), ctr( 460 ) )
          end
          showChanges:SetPos( ctr( 600-520-10 ), ctr( 460 ) )
        else
          showChanges:SetPos( ctr( 600-230 ), ctr( 460 ) )
        end

        frame:MakePopup()
      end
      testingversion = false
      v_tested = true
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
