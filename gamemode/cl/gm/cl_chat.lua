--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

yrpChat = yrpChat or {}

function update_chat_choices()
  yrpChat.comboBox:Clear()
  yrpChat.comboBox:AddChoice( lang_string( "ooc" ) .. " /OOC", "ooc", false )
  yrpChat.comboBox:AddChoice( lang_string( "looc" ) .. " /LOOC", "looc", false )
  yrpChat.comboBox:AddChoice( lang_string( "say" ) .. " /SAY", "say", true )
  yrpChat.comboBox:AddChoice( lang_string( "advert" ) .. " /ADVERT", "advert", false )
  yrpChat.comboBox:AddChoice( lang_string( "yell" ) .. " /YELL", "yell", false )
  yrpChat.comboBox:AddChoice( lang_string( "me" ) .. " /ME", "me", false )
  yrpChat.comboBox:AddChoice( lang_string( "admin" ) .. " /ADMIN", "admin", false )
  yrpChat.comboBox:AddChoice( lang_string( "group" ) .. " /GROUP", "group", false )
  yrpChat.comboBox:AddChoice( lang_string( "role" ) .. " /ROLE", "role", false )
end

if yrpChat.window == nil then
  yrpChat.window = createVGUI( "DFrame", nil, 100, 100, 100, 100 )
  yrpChat.window:SetTitle( "" )
  yrpChat.window:ShowCloseButton( false )
  yrpChat.window:SetDraggable( false )

  yrpChat.richText = createVGUI( "RichText", yrpChat.window, 1, 1, 1, 1 )

  yrpChat.comboBox = createD( "DComboBox", yrpChat.window, 1, 1, 1, 1 )
  update_chat_choices()

  function yrpChat.comboBox:OnSelect( index, value, data )
    net.Start( "set_chat_mode" )
      net.WriteString( string.lower( data ) )
    net.SendToServer()
  end

  yrpChat.writeField = createVGUI( "DTextEntry", yrpChat.window, 1, 1, 1, 1 )
end

hook.Add( "yrp_language_changed", "chat_language_changed", function()
  update_chat_choices()
end)

function yrpChat.richText:PerformLayout()
	self:SetFontInternal( "cbsf" )
end

local _delay = 4
local _fadeout = CurTime() + _delay
local _chatIsOpen = false
_showChat = true
function checkChatVisible()
  if _chatIsOpen then
    _fadeout = CurTime() + _delay
  end
  if CurTime() > _fadeout and !yrpChat.writeField:HasFocus() then
    _showChat = false
  else
    _showChat = true
  end
  yrpChat.richText:SetVisible( _showChat )
  yrpChat.writeField:SetVisible( _showChat )
  yrpChat.comboBox:SetVisible( _showChat )
end

function isFullyCommand( com, iscom, iscom2 )
  if com == "/" .. iscom .. " " or com == "!" .. iscom .. " " or com == "/" .. string.lower( iscom2 ) .. " " or com == "!" .. string.lower( iscom2 ) .. " " then
    return true
  end
  return false
end

function yrpChat.window:Paint( pw, ph )
  if !IsScreenshotting() then
    if HudV( "cbto" ) == 1 then
      checkChatVisible()
      if _showChat then
        if is_hud_db_loaded() then
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
          drawRBoxBr(  0, 0, 0, ctrF( ScrH() ) * pw, ctrF( ScrH() ) * ph, Color( HudV("colbrr"), HudV("colbrg"), HudV("colbrb"), HudV("colbra") ), ctr( 8 ) )

          local x, y = yrpChat.window:GetPos()
          local w, h = yrpChat.window:GetSize()
          if ctr( HudV("cbpx") ) != x or ctr( HudV("cbpy") ) != y or ctr( HudV("cbsw") ) != w or ctr( HudV("cbsh") ) != h then
            yrpChat.window:SetPos( anchorW( HudV( "cbaw" ) ) + ctr( HudV("cbpx") ), anchorH( HudV( "cbah" ) ) + ctr( HudV("cbpy") ) )
            yrpChat.window:SetSize( ctr( HudV("cbsw") ), ctr( HudV("cbsh") ) )

            yrpChat.comboBox:SetPos( ctr( 10 ), ctr( HudV("cbsh") - 40 - 10 ) )
            yrpChat.comboBox:SetSize( ctr( 100 ), ctr( 40 ) )

            yrpChat.writeField:SetPos( ctr( 110 ), ctr( HudV("cbsh") - 40 - 10 ) )
            yrpChat.writeField:SetSize( ctr( HudV("cbsw") - 2*10 - 100 ), ctr( 40 ) )

            yrpChat.richText:SetPos( ctr( 10 ), ctr( 10 ) )
            yrpChat.richText:SetSize( ctr( HudV("cbsw") - 2*10 ), ctr( HudV("cbsh") - 2*10 - 40 - 10 ) )
          end
        end

        local _com = yrpChat.writeField:GetText()
        if isFullyCommand( _com, "sooc", lang_string( "ooc" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "ooc" ), 1 )
        elseif isFullyCommand( _com, "slooc", lang_string( "looc" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "looc" ), 2 )
        elseif isFullyCommand( _com, "ssay", lang_string( "say" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "say" ), 3 )
        elseif isFullyCommand( _com, "sme", lang_string( "me" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "me" ), 6 )
        elseif isFullyCommand( _com, "syell", lang_string( "yell" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "yell" ), 5 )
        elseif isFullyCommand( _com, "sadvert", lang_string( "advert" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "advert" ), 4 )
        elseif isFullyCommand( _com, "sadmin", lang_string( "admin" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "admin" ), 7 )
        elseif isFullyCommand( _com, "sgroup", lang_string( "group" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "group" ), 8 )
        elseif isFullyCommand( _com, "srole", lang_string( "role" ) ) then
          yrpChat.writeField:SetText("")
          yrpChat.comboBox:ChooseOption( lang_string( "role" ), 9 )
        end
      end
    end
  else
    yrpChat.richText:SetVisible( false )
    yrpChat.writeField:SetVisible( false )
    yrpChat.comboBox:SetVisible( false )
  end
end

yrpChat.writeField.OnKeyCodeTyped = function( self, code )
  if code == KEY_ESCAPE then
    yrpChat.closeChatbox()
    gui.HideGameUI()
  elseif code == KEY_ENTER then
    if string.Trim( self:GetText() ) != "" then
      LocalPlayer():ConCommand( "say \""..self:GetText() .. "\"" )
    end
    yrpChat.closeChatbox()
  end
end

function yrpChat.openChatbox()
	yrpChat.window:MakePopup()
	yrpChat.writeField:RequestFocus()

  _chatIsOpen = true
  gamemode.Call( "StartChat" )
end

function yrpChat.closeChatbox()

	yrpChat.window:SetMouseInputEnabled( false )
	yrpChat.window:SetKeyboardInputEnabled( false )
	gui.EnableScreenClicker( false )

  _chatIsOpen = false
	gamemode.Call( "FinishChat" )

	yrpChat.writeField:SetText( "" )
	gamemode.Call( "ChatTextChanged", "" )
end

hook.Add( "PlayerBindPress", "yrp_overrideChatbind", function( ply, bind, pressed )
  local bTeam = nil
  if bind == "messagemode" then
    bTeam = false
  elseif bind == "messagemode2" then
    bTeam = true
  else
    return
  end
  if HudV( "cbto" ) == 1 then
    yrpChat.openChatbox( bTeam )
  end
  return true
end )

hook.Add( "ChatText", "yrp_serverNotifications", function( index, name, text, type )
  if type == "joinleave" or type == "none" then
    yrpChat.richText:AppendText( text.."\n" )
  end
end )

hook.Add( "HUDShouldDraw", "noMoreDefault", function( name )
  if name == "CHudChat" then
  	return false
  end
end )

local oldAddText = oldAddText or chat.AddText
function chat.AddText( ... )
  local args = { ... }

  yrpChat.richText:AppendText( "\n" )
  for _, obj in pairs( args ) do
    if type( obj ) == "table" then
      if isnumber( tonumber( obj.r ) ) and isnumber( tonumber( obj.g ) ) and isnumber( tonumber( obj.b ) ) then
        yrpChat.richText:InsertColorChange( obj.r, obj.g, obj.b, 255 )
      end
    elseif type( obj ) == "string" then
      local _text = string.Explode( " ", obj )
      for k, str in pairs( _text ) do
        if k > 1 then
          yrpChat.richText:AppendText( " " )
        end

        --[[ find link start ]]--
        local _l = {}
        _l.l_start = string.find( str, "https://", 1 )
        if _l.l_start != nil then
          _l.l_secure = true
        else
          _l.l_secure = false
          _l.l_start = string.find( str, "http://", 1 )
          if _l.l_start == nil then
            _l.l_www = true
            _l.l_start = string.find( str, "www.", 1 )
          end
        end

        if _l.l_start != nil then
          --[[ is link ]]--

          --[[ link end ]]--
          _l.l_end = #str

          local _link = string.sub( str, _l.l_start, _l.l_end )
          if _l.l_www then
            _link = "https://" .. _link
          end
          if _link != "" then
            if _l.secure then
              yrpChat.richText:InsertColorChange( 200, 200, 255, 255 )
            else
              yrpChat.richText:InsertColorChange( 255, 100, 100, 255 )
            end
            yrpChat.richText:InsertClickableTextStart( _link )	-- Make incoming text fire the "OpenWiki" value when clicked
            yrpChat.richText:AppendText( _link )
            yrpChat.richText:InsertClickableTextEnd()	-- End clickable text here
            yrpChat.richText:InsertColorChange( 255, 255, 255, 255 )

            function yrpChat.richText:ActionSignal( signalName, signalValue )
            	if ( signalName == "TextClicked" ) then
            		if ( signalValue == _link ) then
            			gui.OpenURL( _link )
            		end
            	end
            end
          end
        else
          yrpChat.richText:AppendText( str )
        end
      end
    elseif obj:IsPlayer() then
      local col = GAMEMODE:GetTeamColor( obj )
      if isnumber( tonumber( obj.r ) ) and isnumber( tonumber( obj.g ) ) and isnumber( tonumber( obj.b ) ) then
        yrpChat.richText:InsertColorChange( col.r, col.g, col.b, 255 )
        yrpChat.richText:AppendText( obj:Nick() )
      end
    end
  end

  _fadeout = CurTime() + _delay

  oldAddText ( ... )
end

function niceCommand( com )
  if com == "say" then
    return lang_string( "say" )
  elseif com == "yell" then
    return lang_string( "yell" )
  elseif com == "advert" then
    return LocalPlayer():GetNWString( "channel_advert", lang_string( "advert" ) )
  elseif com == "admin" then
    return lang_string( "admin" )
  elseif com == "group" then
    return lang_string( "group" )
  elseif com == "role" then
    return lang_string( "role" )
  end
  return com
end

net.Receive( "yrp_player_say", function( len )
  local _tmp = net.ReadTable()

  local _write = false
  if _tmp.command == "say" or _tmp.command == "yell" or _tmp.command == "advert" or _tmp.command == "ooc" or _tmp.command == "looc" or _tmp.command == "me" or _tmp.command == "roll" or _tmp.command == "admin" or _tmp.command == "group" or _tmp.command == "role" then
    _write = true
    _tmp.name = _tmp.rolename .. " " .. _tmp.rpname
  end

  local _usergroup = false
  if _tmp.command == "ooc" or _tmp.command == "looc" or _tmp.command == "admin" then
    _usergroup = true
    _tmp.name = _tmp.steamname
  end

  if true then
    local _unpack = {}

    _tmp._lokal = ""
    _tmp.lokal_color = Color( 255, 100, 100 )
    if !_tmp.lokal then
      _tmp._lokal = lang_string( "globalchat" )
      _tmp.lokal_color = Color( 255, 165, 0 )

      table.insert( _unpack, _tmp.lokal_color )
      table.insert( _unpack, "[" )
      table.insert( _unpack, string.upper( _tmp._lokal ) )
      table.insert( _unpack, "]" )

      table.insert( _unpack, " " )

      if _usergroup then
        table.insert( _unpack, Color( 0, 0, 100 ) )
        table.insert( _unpack, "[" )
        table.insert( _unpack, string.upper( _tmp.usergroup ) )
        table.insert( _unpack, "]" )

        table.insert( _unpack, " " )
      end
    end

    if _tmp.command != "me" then
      table.insert( _unpack, _tmp.command_color )
      table.insert( _unpack, "[" )
      table.insert( _unpack, string.upper(  niceCommand( _tmp.command ) ) )
      table.insert( _unpack, "]" )
      table.insert( _unpack, " " )
    end


    table.insert( _unpack, _tmp.command_color )
    table.insert( _unpack, _tmp.name )
    if _tmp.command != "me" then
      table.insert( _unpack, ":\n" )
    else
      table.insert( _unpack, " " )
    end

    table.insert( _unpack, _tmp.text_color )
    table.insert( _unpack, tostring( _tmp.text ) )

    chat.AddText( unpack( _unpack ) )
    chat.PlaySound()
  end
end)
