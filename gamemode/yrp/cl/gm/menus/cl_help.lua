--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function replaceKeyName( str )
  if str == "uparrow" or str == "pgup" then
    return "↑"
  elseif str == "downarrow" or str == "pgdn"  then
    return "↓"
  elseif str == "rightarrow" then
    return "→"
  elseif str == "leftarrow" then
    return "←"
  elseif str == "home" then
    return lang_string( "numpadhome" )
  elseif str == "plus" then
    return "+"
  elseif str == "minus" then
    return "-"
  elseif str == "ins" then
    return lang_string( "keyinsert" )
  end
  return str
end

function nicekey( key_str )
  local _str = string.lower( tostring( key_str ) )
  if _str != nil then
    if string.find( _str, "kp_" ) then
      local _end = string.sub( _str, 4 )

      _end = replaceKeyName( _end )
      return lang_string( "keynumpad" ) .. " " .. _end
    elseif string.find( _str, "pg" ) then
      return lang_string( "keypage" ) .. " " .. replaceKeyName( _str )
    end
    _str = replaceKeyName( _str )
  end
  return tostring( _str )
end

local HELPMENU = {}

function toggleHelpMenu()
  if isNoMenuOpen() then
    openHelpMenu()
  else
    closeHelpMenu()
  end
end

function closeHelpMenu()
  if HELPMENU.window != nil then
    closeMenu()
    HELPMENU.window:Remove()
    HELPMENU.window = nil
  end
end

function AddKeybind( plist, keybind, lstr, icon )
  local kb = createD( "DPanel", nil, ctr( 100 ), ctr( 50 ), 0, 0 )
  kb.key = keybind
  function kb:Paint( pw, ph )
    draw.SimpleTextOutlined( string.upper( "[" .. nicekey( self.key ) .. "]" ), "mat1text", ph + ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), 0, 1, ctr( 1 ), Color( 0, 0, 0, 255 ) )
    draw.SimpleTextOutlined( lang_string( lstr ), "mat1text", ph + ctr( 300 ), ph/2, Color( 255, 255, 255, 255 ), 0, 1, ctr( 1 ), Color( 0, 0, 0, 255 ) )
    DrawIcon( GetDesignIcon( icon ), ph - ctr( 4 ), ph - ctr( 4 ), ctr( 2 ), ctr( 2 ), Color( 255, 255, 255, 255 ) )
  end

  plist:AddItem( kb )
end

function AddKeybindBr( plist )
  local kb = createD( "DPanel", nil, ctr( 100 ), ctr( 20 ), 0, 0 )
  function kb:Paint( pw, ph )
    draw.RoundedBox( 0, 0, ph/4, pw, ph/2, Color( 0, 0, 0, 255 ) )
  end

  plist:AddItem( kb )
end

net.Receive( "getsitehelp", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local keybinds = createD( "DPanelList", HELPMENU.mainmenu.site, ctr( 1200 ), ScrH(), 0, 0 )
    AddKeybind( keybinds, "F1",                                           "help",               "help" )
    AddKeybind( keybinds, GetKeybindName( "menu_character_selection" ),   "characterselection", "character" )
    AddKeybind( keybinds, GetKeybindName( "toggle_mouse" ),               "togglemouse",           "mouse" )
    AddKeybind( keybinds, GetKeybindName( "menu_role" ),                  "rolemenu",           "role" )
    AddKeybind( keybinds, "F7",                                           "givefeedback",       "feedback" )
    AddKeybind( keybinds, GetKeybindName( "menu_settings" ),              "settings",           "settings" )
    AddKeybind( keybinds, GetKeybindName( "menu_role" ),                  "buymenu",            "shop" )
    AddKeybind( keybinds, GetKeybindName( "toggle_map" ),                 "map",                "map" )
    AddKeybind( keybinds, GetKeybindName( "menu_inventory" ),             "inventory",          "work" )
    AddKeybind( keybinds, GetKeybindName( "menu_appearance" ),            "appearance",         "face" )
    AddKeybind( keybinds, GetKeybindName( "menu_emotes" ),                "emotes",             "smile" )
    AddKeybindBr( keybinds )
    AddKeybind( keybinds, GetKeybindName( "drop_item" ),                  "drop",               "pin_drop" )
    AddKeybind( keybinds, GetKeybindName( "weaponlowering" ),             "weaponlowering",     "keyboard_arrow_down" )
    AddKeybindBr( keybinds )
    AddKeybind( keybinds, GetKeybindName( "view_switch" ),                "switchview",         "3d_rotation" )
    AddKeybind( keybinds, GetKeybindName( "view_up" ),                    "increaseviewingheight",      "keyboard_arrow_up" )
    AddKeybind( keybinds, GetKeybindName( "view_down" ),                  "decreaseviewingheight",      "keyboard_arrow_down" )
    AddKeybind( keybinds, GetKeybindName( "view_right" ),                 "viewingpositiontotheright",       "keyboard_arrow_right" )
    AddKeybind( keybinds, GetKeybindName( "view_left" ),                  "viewingpositiontotheleft",        "keyboard_arrow_left" )
    AddKeybind( keybinds, GetKeybindName( "view_spin_right" ),            "turnviewingangletotheright", "rotate_right" )
    AddKeybind( keybinds, GetKeybindName( "view_spin_left" ),             "turnviewingangletotheleft",  "rotate_left" )
    AddKeybind( keybinds, GetKeybindName( "view_zoom_out" ),              "holdtozoomoutview",     "unfold_more" )
    AddKeybind( keybinds, GetKeybindName( "view_zoom_in" ),               "holdtozoominview",        "unfold_less" )
    AddKeybindBr( keybinds )
    AddKeybind( keybinds, GetKeybindName( "sp_open" ),                    "presstoopensmartphone",       "smartphone" )
    AddKeybind( keybinds, GetKeybindName( "sp_close" ),                   "presstoclosesmartphone",    "system_update" )
    AddKeybindBr( keybinds )
    AddKeybind( keybinds, GetKeybindName( "speak_next" ),                 "nextvoicechannel",          "record_voice_over" )
    AddKeybind( keybinds, GetKeybindName( "speak_prev" ),                 "previousvoicechannel",          "record_voice_over" )

    HELPMENU.feedback = createD( "DButton", HELPMENU.mainmenu.site, ctr( 500 ), ctr( 50 ), ctr( 1210 ), ctr( 10 ) )
    HELPMENU.feedback:SetText( "" )
    function HELPMENU.feedback:Paint( pw, ph )
      surfaceButton( self, pw, ph, "givefeedback" )
    end
    function HELPMENU.feedback:DoClick()
      closeHelpMenu()
      openFeedbackMenu()
      --gui.OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/viewform?usp=sf_link" )
    end

    HELPMENU.discord = createD( "DButton", HELPMENU.mainmenu.site, ctr( 500 ), ctr( 50 ), ctr( 1210 ), ctr( 10 + 50 + 10 ) )
    HELPMENU.discord:SetText( "" )
    function HELPMENU.discord:Paint( pw, ph )
      surfaceButton( self, pw, ph, "getlivesupport" )
    end
    function HELPMENU.discord:DoClick()
      gui.OpenURL( "https://discord.gg/sEgNZxg" )
    end
  end
end)

net.Receive( "getsitestaff", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local staff = net.ReadTable()

    local stafflist = createD( "DPanelList", HELPMENU.mainmenu.site, ctr( 800 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
    stafflist:SetSpacing( ctr( 10 ) )

    for i, pl in pairs( staff ) do
      local tmp = createD( "DButton", stafflist, ctr( 800 ), ctr( 200 ), 0, 0 )
      tmp:SetText( "" )
      function tmp:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 255, 200 ) )
        draw.SimpleTextOutlined( lang_string( "name" ) .. ": " .. pl:RPName(), "mat1text", ph + ctr( 10 ), ctr( 25 ), Color( 255, 255, 255, 255 ), 0, 1, ctr( 1 ), Color( 0, 0, 0, 255 ) )
        draw.SimpleTextOutlined( lang_string( "usergroup" ) .. ": " .. pl:GetUserGroup(), "mat1text", ph + ctr( 10 ), ctr( 50 + 25 ), Color( 255, 255, 255, 255 ), 0, 1, ctr( 1 ), Color( 0, 0, 0, 255 ) )
      end

      tmp.avatar = createD( "AvatarImage", tmp, ctr( 200 - 8 ), ctr( 200 - 8 ), ctr( 4 ), ctr( 4 ) )
      tmp.avatar:SetPlayer( pl, ctr( 200 ) )

      local steamsize = 50
      tmp.steam = createD( "DButton", tmp, ctr( steamsize ), ctr( steamsize ), ctr( 200 + 10 ), ctr( 200 - steamsize - 10 ) )
      tmp.steam:SetText( "" )
      function tmp.steam:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "steam" ), pw - ctr( 4 ), ph - ctr( 4 ), ctr( 2 ), ctr( 2 ), YRPGetColor( "6" ) )
      end
      function tmp.steam:DoClick()
        pl:ShowProfile()
      end

      stafflist:AddItem( tmp )
    end
  end
end)

net.Receive( "getsitecollection", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local collectionid = tonumber( net.ReadString() )

    if collectionid > 0 then
      local link = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. collectionid
      local WorkshopPage = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function WorkshopPage:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      WorkshopPage:OpenURL( link )

      local openLink = createD( "DButton", WorkshopPage, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsitecommunitywebsite", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = net.ReadString()

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsitecommunityforum", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = net.ReadString()

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsitecommunitydiscord", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = net.ReadString()
    local widgetid = net.ReadString()

    if widgetid != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, ctr( 1000 + 2*20 ), ph, Color( 255, 255, 255, 255 ) )
      end
      local widgetlink = "<iframe src=\"https://canary.discordapp.com/widget?id=" .. widgetid .. "&theme=dark\" width=\"" .. ctr( 1000 ) .. "\" height=\"" .. page:GetTall() - ctr( 2*20 ) .. "\" allowtransparency=\"true\" frameborder=\"0\"></iframe>"
      page:SetHTML( widgetlink )

      local openLink = createD( "DButton", page, ctr( 240 ), ctr( 54 ), ctr( 390 ), page:GetTall() - ctr( 92 ) )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsitecommunityteamspeak", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local ip = net.ReadString()
    local port = net.ReadString()
    local query_port = net.ReadString()

    printGM( "gm", "TS: " .. ip .. ":" .. port .. " | QPort: " .. query_port )

    if ip != "" then
      if port != "" and query_port != "" then
        local page = createD( "DHTML", HELPMENU.mainmenu.site, ctr( 1000 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
        function page:Paint( pw, ph )
          surfaceBox( 0, 0, ctr( 1000 + 2*20 ), ph, Color( 40, 40, 40, 255 ) )
        end
        local widgetlink = "<span id=\"its402545\"><a href=\"https://www.teamspeak3.com/\">teamspeak</a> Hosting by TeamSpeak3.com</span><script type=\"text/javascript\" src=\"https://view.light-speed.com/teamspeak3.php?IP=" .. ip .. "&PORT=" .. port .. "&QUERY= " .. query_port .. "&UID=402545&display=block&font=11px&background=transparent&server_info_background=transparent&server_info_text=%23ffffff&server_name_background=transparent&server_name_text=%23ffffff&info_background=transparent&channel_background=transparent&channel_text=%23ffffff&username_background=transparent&username_text=%23ffffff\"></script>"
        page:SetHTML( widgetlink )

        local ipport = createD( "DTextEntry", HELPMENU.mainmenu.site, ctr( 400 ), ctr( 50 ), page:GetWide() + ctr( 20 ), 0 )
        ipport:SetText( ip .. ":" .. port )
        ipport:SetEditable( false )
      else
        printGM( "note", "missing Port and QueryPort" )
      end
    end
  end
end)

net.Receive( "getsitecommunitytwitter", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = net.ReadString()

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsitecommunityyoutube", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = net.ReadString()

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsitecommunityfacebook", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = net.ReadString()

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsitecommunitysteamgroup", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = net.ReadString()

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)


net.Receive( "getsiteyourrpnews", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = "https://docs.google.com/document/d/1s9lqfYeTbTW7YOgyvg3F2gNx4LBvNpt9fA8eGUYfpTI/edit?usp=sharing"

    if link != "" then
      local posy = ctr( 220 )
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ) + posy, 0, -posy )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsiteyourrpwebsite", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = "https://sites.google.com/view/yrp"

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
      end
      page:OpenURL( link )

      local openLink = createD( "DButton", page, ctr( 100 ), ctr( 100 ), ScrW() - ctr( 100 + 20 + 20 ), 0 )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

net.Receive( "getsiteyourrpdiscord", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local link = "https://discord.gg/CXXDCMJ"

    if link != "" then
      local page = createD( "DHTML", HELPMENU.mainmenu.site, ScrW() - ctr( 20 + 20 ), ScrH() - ctr( 100 + 20 + 20 ), 0, 0 )
      function page:Paint( pw, ph )
        surfaceBox( 0, 0, ctr( 1000 + 2*20 ), ph, Color( 255, 255, 255, 255 ) )
      end
      page:SetHTML( "<iframe src=\"https://canary.discordapp.com/widget?id=322771229213851648&theme=dark\" width=\"" .. ctr( 1000 ) .. "\" height=\"" .. page:GetTall() - ctr( 2*20 ) .. "\" allowtransparency=\"true\" frameborder=\"0\"></iframe>" )

      local openLink = createD( "DButton", page, ctr( 240 ), ctr( 54 ), ctr( 390 ), page:GetTall() - ctr( 92 ) )
      openLink:SetText( "" )
      function openLink:Paint( pw, ph )
        surfaceButton( self, pw, ph, "" )
        DrawIcon( GetDesignIcon( "launch" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
      end
      function openLink:DoClick()
        gui.OpenURL( link )
      end
    end
  end
end)

function openHelpMenu()
  openMenu()
  HELPMENU.window = createD( "DFrame", nil, ScrW(), ScrH(), 0, 0 )
  HELPMENU.window:MakePopup()
  HELPMENU.window:Center()
  HELPMENU.window:SetTitle( "" )
  HELPMENU.window:SetDraggable( false )
  HELPMENU.window:ShowCloseButton( false )
  function HELPMENU.window:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 90, 90, 90, 200 ) )
  end

  HELPMENU.mainmenu = createD( "DYRPHorizontalMenu", HELPMENU.window, BScrW(), ScrH(), 0, 0 )
  HELPMENU.mainmenu:GetMenuInfo( "gethelpmenu" )
  HELPMENU.mainmenu:SetStartTab( "help" )

  HELPMENU.changelanguage = DChangeLanguage( HELPMENU.window, BScrW() - ctr( 20 + 64 + 20 + 100 ), ctr( 20 ), ctr( 100 ) )

  HELPMENU.close = createD( "DButton", HELPMENU.window, ctr( 64 ), ctr( 64 ), BScrW() - ctr( 64 + 20 ), ctr( 20 ) )
  HELPMENU.close:SetText( "" )
  function HELPMENU.close:Paint( pw, ph )
    local color = YRPGetColor( "2" )
    if self:IsHovered() then
      color = YRPGetColor( "1" )
    end
    draw.RoundedBox( ph/2, 0, 0, pw, ph, color )
    DrawIcon( GetDesignIcon( "close" ), ph, ph, 0, 0, YRPGetColor( "6" ) )
  end
  function HELPMENU.close:DoClick()
    HELPMENU.window:Close()
  end
end
