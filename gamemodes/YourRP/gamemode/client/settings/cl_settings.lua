--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings.lua

include( "cl_settings_client.lua" )
include( "cl_settings_server.lua" )
include( "cl_settings_yourrp.lua")
include( "cl_settings_settings.lua" )

yrp.colors.black = Color( 0, 0, 0, 255 )
yrp.colors.background = Color( 0, 0, 0, 160 )
yrp.colors.background2 = Color( 0, 0, 0, 254 )
yrp.colors.panel = Color( 0, 143, 255, 120 )
yrp.colors.buttonInActive = Color( 100, 100, 100, 160 )

function drawBackground( x, y, w, h, br )
  draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.background )

  draw.RoundedBox( 0,   x,      y,      w,  br, yrp.colors.black )
  draw.RoundedBox( 0,   x,      y+h-br, w,  br, yrp.colors.black )
  draw.RoundedBox( 0,   x,      y,      br, h,  yrp.colors.black )
  draw.RoundedBox( 0,   x+w-br, y,      br, h,  yrp.colors.black )
end

function openSettings()
  settingsOpen = 1

  settingsWindow = vgui.Create( "DFrame" )
  settingsWindow:SetSize( ctrW( 2160 ), ctrW( 2160 ) )
  settingsWindow:SetPos( ScrW2() - ctrW( 2160/2 ), 0 )
  settingsWindow:SetTitle( "" )
  settingsWindow:ShowCloseButton( true )
  function settingsWindow:OnClose()
    gui.EnableScreenClicker( false )
    if modelSelector != nil then
      modelSelector:Remove()
    end
    _menuIsOpen = 0
  end
  function settingsWindow:Paint( pw, ph )
    draw.RoundedBox( 0, ctrW( 0 ), ctrW( 0 ), pw, ph, yrp.colors.background )
  end

  local settingsSheet = vgui.Create( "DPropertySheet", settingsWindow )
  settingsSheet:Dock( FILL )
  function settingsSheet:Paint()
    --drawBackground( 0, 0, settingsSheet:GetWide(), settingsSheet:GetTall(), ctrW( 0 ) )
  end

  local Langu = createVGUI( "DComboBox", settingsWindow, 400, 50, 1500, 0 )
  Langu:SetValue( lang.lang )
  Langu:AddChoice("[AUTOMATIC]", "auto")
  for k, v in pairs( lang.all ) do
    Langu:AddChoice( v.ineng .. "/" .. v.lang, v.short )
  end
  Langu.OnSelect = function( panel, index, value, data )
    changeLang(data)
  end

  tabClient( settingsSheet )

  tabServer( settingsSheet )

  tabYourRP( settingsSheet )

  tabSettings( settingsSheet )

  local bs = 600
  local button = vgui.Create( "DButton", settingsWindow )
  button:SetSize( ctrW( bs ), ctrW( 50 ) )
  button:SetPos( ctrW( 15 ), ctrW( 5 ) )
  button:SetText( "" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
  function button:Paint( pw, ph )
    if button:IsHovered() then
      draw.RoundedBox( 0, ctrW( 0 ), ctrW( 0 ), pw, ph, Color( 255, 255, 0, 200 ) )
    else
      draw.RoundedBox( 0, ctrW( 0 ), ctrW( 0 ), pw, ph, yrp.colors.panel )
    end
    draw.SimpleText( "Live Support Click me! (Discord)", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local versionInfo = createVGUI( "DPanel", settingsWindow, 300, 50, 15 + bs + 10, 5 )
  function versionInfo:Paint( pw, ph )
    draw.RoundedBox( 0, ctrW( 0 ), ctrW( 0 ), pw, ph, yrp.colors.panel )
    draw.SimpleText( "Current: " .. GAMEMODE.Version, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local versionInfoOnlinePanel = createVGUI( "DPanel", settingsWindow, 300, 50, 15 + bs + 10 + 300 + 10, 5 )
  function versionInfoOnlinePanel:Paint( pw, ph )
    draw.RoundedBox( 0, ctrW( 0 ), ctrW( 0 ), pw, ph, yrp.colors.panel )
  end

  local versionInfoOnline = createVGUI( "HTML", versionInfoOnlinePanel, bs, bs, 20, -85 )
  versionInfoOnline:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vQ9arSoujn5cs5g1YrJuhw6jpWmn0tdtBInHBp9uSLQdYvl-eft4LPEfXujyF-HHex9hwU1GNA3d_eI/pub" )

  for k, v in pairs(settingsSheet.Items) do
  	if (!v.Tab) then continue end

    v.Tab.Paint = function(self,w,h)
      if v.Tab == settingsSheet:GetActiveTab() then
		    draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.background )
      else
        draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.buttonInActive )
      end
    end
  end

  settingsWindow:MakePopup()
end
