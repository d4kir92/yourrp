
net.Receive( "yrp_player_say", function( len )
  local _tmp = net.ReadTable()

  chat.AddText( unpack( _tmp ) )
  chat.PlaySound()
end)
