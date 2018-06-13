--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _fb = {}

function toggleFeedbackMenu()
  if isNoMenuOpen() then
    openFeedbackMenu()
  else
    closeFeedbackMenu()
  end
end

function closeFeedbackMenu()
  if _fb.window != nil then
    closeMenu()
    _fb.window:Remove()
    _fb.window = nil
  end
end

local _url = "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/formResponse"

function openFeedbackMenu()
  openMenu()
  _fb.window = createD( "DFrame", nil, BScrW(), ScrH(), 0, 0 )
  _fb.window:Center()
  _fb.window:SetTitle( "" )
  function _fb.window:OnClose()
    closeMenu()
  end
  function _fb.window:OnRemove()
    closeMenu()
  end

  _fb.langu = derma_change_language( _fb.window, ctr( 400 ), ctr( 50 ), BScrW()/2, ctr( 50 ) )

  function _fb.window:Paint( pw, ph )
    surfaceWindow( self, pw, ph, lang_string( "givefeedback" ) .. " [PROTOTYPE]" )
  end

  _fb.discord = createD( "DButton", _fb.window, ctr( 800 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
  _fb.discord:SetText( "" )
  function _fb.discord:Paint( pw, ph )
    surfaceButton( self, pw, ph, lang_string( "livesupport" ) )
  end
  function _fb.discord:DoClick()
    gui.OpenURL( "https://discord.gg/sEgNZxg" )
  end

  _fb.titleP = createD( "DPanel", _fb.window, BScrW() - ctr( 20 ), ctr( 50 ), ctr( 10 ), ctr( 120 ) )
  function _fb.titleP:Paint( pw, ph )
    surfaceText( lang_string( "title" ), "roleInfoHeader", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
  end
  _fb.titleT = createD( "DTextEntry", _fb.window, BScrW() - ctr( 20 ), ctr( 50 ), ctr( 10 ), ctr( 170 ) )

  _fb.feedbackP = createD( "DPanel", _fb.window, BScrW() - ctr( 20 ), ctr( 50 ), ctr( 10 ), ctr( 250 ) )
  function _fb.feedbackP:Paint( pw, ph )
    surfaceText( lang_string( "feedback" ) .. " (" .. lang_string( "problems" ) .. ", " .. lang_string( "suggestions" ) .. ", ...)", "roleInfoHeader", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
  end
  _fb.feedbackT = createD( "DTextEntry", _fb.window, BScrW() - ctr( 20 ), ctr( 500 ), ctr( 10 ), ctr( 300 ) )
  _fb.feedbackT:SetMultiline( true )

  _fb.contactP = createD( "DPanel", _fb.window, BScrW() - ctr( 20 ), ctr( 50 ), ctr( 10 ), ctr( 850 ) )
  function _fb.contactP:Paint( pw, ph )
    surfaceText( lang_string( "contact" ) .. " (" .. lang_string( "notrequired" ) .. ")", "roleInfoHeader", ctr( 10 ), ph/2, Color( 255, 255, 255 ), 0, 1 )
  end
  _fb.contactT = createD( "DTextEntry", _fb.window, BScrW() - ctr( 20 ), ctr( 50 ), ctr( 10 ), ctr( 900 ) )

  _fb.send = createD( "DButton", _fb.window, ctr( 600 ), ctr( 50 ), ctr( 10 ), ctr( 1000 ) )
  _fb.send:SetText( "" )
  function _fb.send:Paint( pw, ph )
    surfaceButton( self, pw, ph, string.upper( lang_string( "sendfeedback" ) ) )
  end
  function _fb.send:DoClick()
    printGM( "gm", "send feedback" )

    if _fb.titleT:GetText() != "" or _fb.feedbackT:GetText() != "" or _fb.contactT:GetText() != "" then
      local entry = {}
      entry["entry.1141598078"] = _fb.titleT:GetText() or "FAILED"
      entry["entry.761186932"] = _fb.feedbackT:GetText() or "FAILED"
      entry["entry.1633448754"] = _fb.contactT:GetText() or "FAILED"
      entry["entry.1109864644"] = LocalPlayer():SteamID() or "FAILED"

      http.Post( _url, entry, function( result )
        if result then end
      end, function( failed )
        printGM( "error", "Feedback-API: " .. tostring( failed ) )
      end )

      local _net_table = {}
      _net_table.title = _fb.titleT:GetText() or "FAILED"
      _net_table.feedback = _fb.feedbackT:GetText() or "FAILED"
      _net_table.contact = _fb.contactT:GetText() or "FAILED"
      _net_table.steamid = LocalPlayer():SteamID() or "FAILED"
      _net_table.steamname = LocalPlayer():SteamName() or "FAILED"
      net.Start( "add_feedback" )
        net.WriteTable( _net_table )
      net.SendToServer()
    end

    closeFeedbackMenu()
  end

  _fb.window:MakePopup()
end
