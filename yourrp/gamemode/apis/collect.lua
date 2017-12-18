--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

if SERVER then
	local _url = "https://docs.google.com/forms/d/e/1FAIpQLSe9L51y9uV7EExUuxE2VWuwWagVpLMO-BDD8OXEaXTr2u1rUw/formResponse"
	function send_info( status )
	  --printGM( "db", "send_info( " .. tostring( status ) .. " )" )
	  local entry = {}
		timer.Create( "wait_for_server", 1, 0, function()
			if gmod.GetGamemode() != nil then
			  entry["entry.1233170431"] = GetHostName() or "UNKNOWN"
			  entry["entry.524147216"] = game.GetIPAddress() or "UNKNOWN"
				entry["entry.1924789651"] = gmod.GetGamemode().rpbase or "UNKNOWN"
			  entry["entry.2036955482"] = gmod.GetGamemode().Version or "UNKNOWN"
				entry["entry.1879186298"] = string.upper( tostring( gmod.GetGamemode().VersionSort ) ) or "UNKNOWN"
				entry["entry.989542136"] = string.upper( game.GetMap() ) or "UNKNOWN"
				entry["entry.1836113647"] = gmod.GetGamemode():GetGameDescription() or "UNKNOWN"
				entry["entry.1862304741"] = tostring( game.MaxPlayers() ) or "UNKNOWN"
				entry["entry.1969171778"] = tostring( #player.GetAll() ) or "UNKNOWN"
				entry["entry.1821263531"] = string.upper( tostring( game.IsDedicated() ) ) or "UNKNOWN"

			  http.Post( _url, entry, function( result )
			    if result then end
			  end, function( failed )
			    print( failed )
			  end )

				timer.Remove( "wait_for_server" )
			end
		end)
	end

	local _minutes = 30
	local _tick = _minutes*59

	timer.Create( "update_info", tonumber( _tick ), 0, function()
	  send_info( "auto ( " .. tostring( _tick ) .. " )" )
	end)

	timer.Simple( 10, function()
		send_info( "startup" )
	end)
end
