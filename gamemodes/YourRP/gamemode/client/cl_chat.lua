//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "yrp_player_say", function( len )
  local _tmp = net.ReadTable()

  chat.AddText( unpack( _tmp ) )
  chat.PlaySound()
end)
