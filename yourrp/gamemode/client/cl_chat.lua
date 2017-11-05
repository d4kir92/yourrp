--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "yrp_player_say", function( len )
  local _tmp = net.ReadTable()

  chat.AddText( unpack( _tmp ) )
  chat.PlaySound()
end)

if yrpChat == nil then
  yrpChat = {}
  yrpChat.window = createVGUI( "DFrame", nil, 100, 100, 100, 100 )
  yrpChat.window:SetTitle( "" )
  yrpChat.window:ShowCloseButton( false )
  yrpChat.window:SetDraggable( false )

  yrpChat.writeField = createVGUI( "DTextEntry", yrpChat.window, 1, 1, 1, 1 )

  yrpChat.richText = createVGUI( "RichText", yrpChat.window, 1, 1, 1, 1 )
else
  yrpChat = yrpChat
end

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
  if CurTime() > _fadeout then
    _showChat = false
  else
    _showChat = true
  end
  yrpChat.writeField:SetVisible( _showChat )
  yrpChat.richText:SetVisible( _showChat )
end

function yrpChat.window:Paint( pw, ph )
  checkChatVisible()
  if _showChat then
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
    drawRBoxBr(  0, 0, 0, ctrF( ScrH() ) * pw, ctrF( ScrH() ) * ph, Color( 0, 0, 0, 255 ), ctr( 8 ) )

    if cl_db["_loaded"] then
      local x, y = yrpChat.window:GetPos()
      local w, h = yrpChat.window:GetSize()
      if ctr( cl_db["cbpx"] ) != x or ctr( cl_db["cbpy"] ) != y or ctr( cl_db["cbsw"] ) != w or ctr( cl_db["cbsh"] ) != h then
        yrpChat.window:SetPos( anchorW( HudV( "cbaw" ) ) + ctr( cl_db["cbpx"] ), anchorH( HudV( "cbah" ) ) + ctr( cl_db["cbpy"] ) )
        yrpChat.window:SetSize( ctr( cl_db["cbsw"] ), ctr( cl_db["cbsh"] ) )

        yrpChat.writeField:SetPos( ctr( 10 ), ctr( cl_db["cbsh"] - 40 - 10 ) )
        yrpChat.writeField:SetSize( ctr( cl_db["cbsw"] - 2*10 ), ctr( 40 ) )

        yrpChat.richText:SetPos( ctr( 10 ), ctr( 10 ) )
        yrpChat.richText:SetSize( ctr( cl_db["cbsw"] - 2*10 ), ctr( cl_db["cbsh"] - 2*10 - 40 - 10 ) )
      end
    end
  end
end

yrpChat.writeField.OnKeyCodeTyped = function( self, code )
  if code == KEY_ESCAPE then
    yrpChat.closeChatbox()
    gui.HideGameUI()
  elseif code == KEY_ENTER then
    if string.Trim( self:GetText() ) != "" then
      LocalPlayer():ConCommand( "say "..self:GetText() )
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

hook.Add( "PlayerBindPress", "overrideChatbind", function( ply, bind, pressed )
  local bTeam = nil
  if bind == "messagemode" then
    bTeam = false
  elseif bind == "messagemode2" then
  	bTeam = true
  else
  	return
  end

  yrpChat.openChatbox( bTeam )

  return true
end )

hook.Add( "ChatText", "serverNotifications", function( index, name, text, type )
  if type == "joinleave" or type == "none" then
    yrpChat.richText:AppendText( text.."\n" )
  end
end )

hook.Add( "HUDShouldDraw", "noMoreDefault", function( name )
  if name == "CHudChat" then
  	return false
  end
end )

local oldAddText = chat.AddText
function chat.AddText( ... )
local args = { ... }

yrpChat.richText:AppendText( "\n" )
  for _, obj in pairs( args ) do
    if type( obj ) == "table" then
      yrpChat.richText:InsertColorChange( obj.r, obj.g, obj.b, 255 )
    elseif type( obj ) == "string" then
      yrpChat.richText:AppendText( obj )
    elseif obj:IsPlayer() then
      local col = GAMEMODE:GetTeamColor( obj )
      yrpChat.richText:InsertColorChange( col.r, col.g, col.b, 255 )
      yrpChat.richText:AppendText( obj:Nick() )
    end
  end

  _fadeout = CurTime() + _delay

  oldAddText ( ... )
end
