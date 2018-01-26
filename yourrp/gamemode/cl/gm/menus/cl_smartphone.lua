--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_sp = {}
yrp_sp.s_w = 500
yrp_sp.s_h = 900

yrp_sp.visible = false

function toggleHelpMenu()
  if isNoMenuOpen() then
    openHelpMenu()
  else
    closeHelpMenu()
  end
end

function getSpTable()
  local _tab = {}
  _tab.w, _tab.h = yrp_sp.window:GetSize()
  _tab.x, _tab.y = yrp_sp.window:GetPos()
  _tab.x = tonumber( _tab.x )
  _tab.y = tonumber( _tab.y )
  _tab.w = tonumber( _tab.w )
  _tab.h = tonumber( _tab.h )

  return _tab
end

function isSpVisible()
  return yrp_sp.visible
end

function openSP()
  print("openSP")

  if isNoMenuOpen() then
    openMenu()

    yrp_sp.visible = true

    yrp_sp.window = createD( "DFrame", nil, ctr( yrp_sp.s_w ), ctr( yrp_sp.s_h ), ScrW() - ctr( yrp_sp.s_w + 25 ), ScrH() - ctr( yrp_sp.s_h ) )
    yrp_sp.window:ShowCloseButton( false )
    yrp_sp.window:SetTitle( "" )
    yrp_sp.window:SetDraggable( false )

    function yrp_sp.window:Paint( pw, ph )
      --[[ Background ]]--
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 255, 255 ) )

      draw.SimpleTextOutlined( "YRP " .. lang_string( "smartphone" ) .. " (" .. lang_string( "wip" ) .. ")", "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
    end

    yrp_sp.topbar = createD( "DPanel", yrp_sp.window, ctr( yrp_sp.s_w ), ctr( 40 ), 0, 0 )
    function yrp_sp.topbar:Paint( pw, ph )
      --[[ Top Bar ]]--
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 255 ) )
      local _clock = {}
      _clock.sec = os.date( "%S" )
      _clock.min = os.date( "%M" )
      _clock.hours = os.date( "%I" )
      if os.date( "%p" ) == "PM" then
        _clock.hours = tonumber( _clock.hours ) + 12
      end
      draw.SimpleTextOutlined( "100% " .._clock.hours .. ":" .. _clock.min, "DermaDefault", pw - ctr( 10 ), ctr( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
    end

    --[[ Smartphone Loaded ]]--
    local _c = {}
    _c.x, _c.y = yrp_sp.window:GetPos()
    _c.w, _c.h = yrp_sp.window:GetSize()
    input.SetCursorPos( _c.x + _c.w/2, _c.y + _c.h/2 )
    yrp_sp.window:MakePopup()
  end
end

function closeSP()
  print("closeSP")

  closeMenu()

  yrp_sp.visible = false

  if yrp_sp.window != nil then
    yrp_sp.window:Close()
    yrp_sp.window = nil
  end
end
