
function OpenSettingsImportDarkRP()
	local PARENT = GetSettingsSite()
	if pa(PARENT) then
		local btn = YRPCreateD( "YButton", PARENT, YRP.ctr( 300 ), YRP.ctr( 60 ), 20, 20 )
		btn:SetText( "Import DarkRP" )
		function btn:DoClick()
			net.Start( "yrp_import_darkrp" )
			net.SendToServer()

			notification.AddLegacy( "Look at SERVER console", NOTIFY_GENERIC, 12 )
		end
	end
end
