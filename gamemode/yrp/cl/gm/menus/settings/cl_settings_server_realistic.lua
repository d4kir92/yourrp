--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DrawText( tab )
	tab = tab or {}
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.br = tab.br or 1
	tab.brcolor = tab.brcolor or Color( 0, 0, 0 )
	tab.ax = tab.ax or 1
	tab.ay = tab.ay or 1
	tab.text = tab.text or "NoText"
	tab.font = tab.font or "DermaDefault"
	draw.SimpleTextOutlined( tab.text, tab.font, tab.x, tab.y, tab.color, tab.ax, tab.ay, tab.br, tab.brcolor )
end

function DHorizontalScroller( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.color = tab.color or Color( 255, 0, 0, 0 )
	local dhorizontalscroller = createD( "DHorizontalScroller", tab.parent, tab.w, tab.h, tab.x, tab.y )
	function dhorizontalscroller:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
	end

	return dhorizontalscroller
end

function DGroup( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.w = tab.w or 100
	tab.h = tab.h or 100
	tab.br = tab.br or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.bgcolor = tab.bgcolor or Color( 80, 80, 80 )
	tab.name = tab.name or "Unnamed Header"
	local dgroup = {}
	dgroup.header = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.y )
	function dgroup.header:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		ph = ctr( 50 )
		local text = {}
		text.text = lang_string( tab.name )
		text.x = pw/2
		text.y = ph/2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		DrawText( text )
	end

	dgroup.content = createD( "DPanelList", tab.parent, tab.w - 2*tab.br, tab.h - 2*tab.br - ctr( 50 ), tab.x + tab.br, tab.y + tab.br + ctr( 50 ) )
	function dgroup.content:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.bgcolor )
	end

	return dgroup.content
end

function DBoolLine( tab, value, name, netstr )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end
	tab.h = tab.h or ctr( 50 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.brx = tab.brx or 0

	local dboolline = {}

	dboolline.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function dboolline.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = name
		text.x = tab.brx + tab.h + ctr( 10 )
		text.y = ph/2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		text.ax = 0
		DrawText( text )
	end

	dboolline.dcheckbox = createD( "DCheckBox", dboolline.line, tab.h, tab.h, tab.brx, 0 )
	dboolline.dcheckbox:SetValue( value )
	function dboolline.dcheckbox:Paint( pw, ph )
		surfaceCheckBox( self, ph, ph, "done" )
	end
	dboolline.dcheckbox.serverside = false
	function dboolline.dcheckbox:OnChange( bVal )
		if !self.serverside then
			if netstr != "" then
				net.Start( netstr )
					net.WriteBool( bVal )
				net.SendToServer()
			end
		end
	end
	net.Receive( netstr, function( len )
		local b = btn( net.ReadString() )
		if pa( dboolline.dcheckbox ) then
			dboolline.dcheckbox.serverside = true
			dboolline.dcheckbox:SetValue( b )
			dboolline.dcheckbox.serverside = false
		end
	end)

	if tab.parent != nil then
		tab.parent:AddItem( dboolline.line )
	end
	return dboolline.dcheckbox
end

function DFloatLine( tab, value, name, netstr, max, min, dmg )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr( 50 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )
	tab.brx = tab.brx or 0

	local dfloatline = {}

	dfloatline.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function dfloatline.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		text.text = name
		text.x = tab.brx + ctr( 200 ) + ctr( 10 )
		text.y = ph/2
		text.font = "mat1header"
		text.color = Color( 0, 0, 0, 255 )
		text.br = 0
		text.ax = 0
		DrawText( text )

		if dmg != nil then
			local DMG = {}
			DMG.text = dmg
			DMG.x = pw - ctr( 10 )
			DMG.y = ph/2
			DMG.font = "mat1header"
			DMG.color = Color( 0, 0, 0, 255 )
			DMG.br = 0
			DMG.ax = 2
			DrawText( DMG )
		end
	end

	dfloatline.dnumberwang = createD( "DNumberWang", dfloatline.line, ctr( 200 ), tab.h, tab.brx, 0 )
	dfloatline.dnumberwang:SetMax( max or 100 )
	dfloatline.dnumberwang:SetMin( min or 0 )
	dfloatline.dnumberwang:SetDecimals( 6 )
	dfloatline.dnumberwang:SetValue( value )
	dfloatline.dnumberwang.serverside = false
	function dfloatline.dnumberwang:OnChange()
		local value = self:GetValue()
		if value >= self:GetMin() then
			if value <= self:GetMax() then
				if !self.serverside then
					if netstr != "" then
						net.Start( netstr )
							net.WriteFloat( value )
						net.SendToServer()
					end
				end
			else
				dfloatline.dnumberwang:SetText( self:GetMax() )
			end
		else
			dfloatline.dnumberwang:SetText( self:GetMin() )
		end
	end
	net.Receive( netstr, function( len )
		local f = net.ReadFloat()
		if pa( dfloatline.dnumberwang ) then
			dfloatline.dnumberwang.serverside = true
			dfloatline.dnumberwang:SetValue( f )
			dfloatline.dnumberwang.serverside = false
		end
	end)

	if tab.parent != nil then
		tab.parent:AddItem( dfloatline.line )
	end
	return dfloatline.dnumberwang
end

function DHR( tab )
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 100
	else
		tab.w = tab.w or 100
	end
	tab.h = tab.h or ctr( 30 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	local hr = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function hr:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		draw.RoundedBox( 0, 0, ph/3, pw, ph/3, Color( 0, 0, 0, 255 ) )
	end

	if tab.parent != nil then
		tab.parent:AddItem( hr )
	end
	return hr
end

net.Receive( "Connect_Settings_Realistic", function( len )
	if pa( settingsWindow ) then
		if pa( settingsWindow.window ) then
			function settingsWindow.window.site:Paint( pw, ph )
				draw.RoundedBox( 4, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )

				surfaceText( lang_string( "wip" ), "mat1text", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
			end

			local PARENT = settingsWindow.window.site

			function PARENT:OnRemove()
				net.Start( "Disconnect_Settings_Realistic" )
				net.SendToServer()
			end

			local REL = net.ReadTable()
			printTab( REL )

			local br = ctr( 20 )

			local scroller = {}
			scroller.parent = PARENT
			scroller.x = br
			scroller.y = br
			scroller.w = BScrW() - 2*br
			scroller.h = ScrH() - ctr( 100 ) - 2*br
			local Scroller = DHorizontalScroller( scroller )

			local general = {}
			general.parent = Scroller
			general.x = 0
			general.y = 0
			general.w = ctr( 800 )
			general.h = Scroller:GetTall()
			general.br = br/2
			general.name = "generalsettings"
			local General = DGroup( general )

			local dhr = {}
			dhr.parent = General
			dhr.color = YRPGetColor( "2" )

			local bl = {}
			bl.parent = General
			bl.color = YRPGetColor( "2" )
			local ble = {}
			ble.parent = General
			ble.color = YRPGetColor( "2" )
			ble.brx = ctr( 50 )

			DBoolLine( bl, REL.bool_bonefracturing, "bonefracturing", "update_bool_bonefracturing" )
			DFloatLine( ble, REL.float_bonechance_legs, "% " .. lang_string( "breakchancelegs" ), "update_float_bonechance_legs" )
			DFloatLine( ble, REL.float_bonechance_arms, "% " .. lang_string( "breakchancearms" ), "update_float_bonechance_arms" )
			DHR( dhr )
			DBoolLine( bl, REL.bool_bleeding, "bleeding", "update_bool_bleeding" )
			DFloatLine( ble, REL.float_bleedingchance, "% " .. lang_string( "bleedingchance" ), "update_float_bleedingchance" )
			DHR( dhr )
			DBoolLine( bl, REL.bool_custom_falldamage, "customfalldamage", "update_bool_custom_falldamage" )
			DBoolLine( ble, REL.bool_custom_falldamage_percentage, "percentage", "update_bool_custom_falldamage_percentage" )
			DFloatLine( ble, REL.float_custom_falldamage_muliplier, "multiplier", "update_float_custom_falldamage_muliplier" )

			local damage = {}
			damage.parent = Scroller
			damage.x = ctr( 800 ) + br
			damage.y = 0
			damage.w = ctr( 800 )
			damage.h = Scroller:GetTall()
			damage.br = br/2
			damage.name = "damagesettings"
			local Damage = DGroup( damage )
			Damage.dmg = 1

			local dhr = {}
			dhr.parent = Damage
			dhr.color = YRPGetColor( "2" )

			local bl = {}
			bl.parent = Damage
			bl.color = YRPGetColor( "2" )
			local ble = {}
			ble.parent = Damage
			ble.color = YRPGetColor( "2" )
			ble.brx = ctr( 50 )

			DFloatLine( bl, Damage.dmg, "damage", "" )
			DHR( dhr )
			DBoolLine( bl, REL.bool_headshotdeadly_player, "shotinheadisdeadly", "update_bool_headshotdeadly_player" )
			DFloatLine( ble, REL.float_hitfactor_player_head, lang_string( "hitfactor" ) .. " - " .. lang_string( "head" ), "update_float_hitfactor_player_head", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_player_ches, lang_string( "hitfactor" ) .. " - " .. lang_string( "chest" ), "update_float_hitfactor_player_ches", nil, nil, Damage.dmg )
			--[[
			DFloatLine( ble, REL.float_hitfactor_player_stom, lang_string( "hitfactor" ) .. " - " .. lang_string( "stomach" ), "update_float_hitfactor_player_stom", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_player_arms, lang_string( "hitfactor" ) .. " - " .. lang_string( "arms" ), "update_float_hitfactor_player_arms", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_player_legs, lang_string( "hitfactor" ) .. " - " .. lang_string( "legs" ), "update_float_hitfactor_player_legs", nil, nil, Damage.dmg )
			DHR( dhr )
			DBoolLine( bl, REL.bool_headshotdeadly_npc, "shotinheadisdeadly", "update_bool_headshotdeadly_npc" )
			DFloatLine( ble, REL.float_hitfactor_npc_head, lang_string( "hitfactor" ) .. " - " .. lang_string( "head" ), "update_float_hitfactor_npc_head", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_npc_ches, lang_string( "hitfactor" ) .. " - " .. lang_string( "chest" ), "update_float_hitfactor_npc_ches", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_npc_stom, lang_string( "hitfactor" ) .. " - " .. lang_string( "stomach" ), "update_float_hitfactor_npc_stom", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_npc_arms, lang_string( "hitfactor" ) .. " - " .. lang_string( "arms" ), "update_float_hitfactor_npc_arms", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_npc_legs, lang_string( "hitfactor" ) .. " - " .. lang_string( "legs" ), "update_float_hitfactor_npc_legs", nil, nil, Damage.dmg )
			DHR( dhr )
			DFloatLine( ble, REL.float_hitfactor_entities, lang_string( "hitfactor" ) .. " - " .. lang_string( "entities" ), "update_float_hitfactor_entities", nil, nil, Damage.dmg )
			DFloatLine( ble, REL.float_hitfactor_vehicles, lang_string( "hitfactor" ) .. " - " .. lang_string( "vehicles" ), "update_float_hitfactor_vehicles", nil, nil, Damage.dmg )
			]]--
		end
	end
end)

hook.Add( "open_server_realistic", "open_server_realistic", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

	net.Start( "Connect_Settings_Realistic" )
	net.SendToServer()
end)
