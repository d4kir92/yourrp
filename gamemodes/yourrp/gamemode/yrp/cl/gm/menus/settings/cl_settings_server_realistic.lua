--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

net.Receive( "Connect_Settings_Realistic", function(len)
	local PARENT = GetSettingsSite()
	if pa(PARENT) then

		function PARENT:OnRemove()
			net.Start( "Disconnect_Settings_Realistic" )
			net.SendToServer()
		end

		local REL = net.ReadTable()
		local br = YRP.ctr(20)
		local scroller = {}
		scroller.parent = PARENT
		scroller.x = br
		scroller.y = br
		scroller.w = PARENT:GetWide() - 2 * br
		scroller.h = PARENT:GetTall() - 2 * br
		local Scroller = DHorizontalScroller(scroller)

		local General = YRPCreateD( "YGroupBox", Scroller, YRP.ctr(800), Scroller:GetTall(), 0, 0)
		General:SetText( "LID_generalsettings" )
		function General:Paint(pw, ph)
			hook.Run( "YGroupBoxPaint", self, pw, ph)
		end
		Scroller:AddPanel(General)
		function Scroller:Paint(pw, ph)
			if self.w != PARENT:GetWide() or self.h != PARENT:GetTall() then
				self.w = PARENT:GetWide()
				self.w = PARENT:GetTall()

				self:SetSize(PARENT:GetWide() - YRP.ctr(2 * 20), PARENT:GetTall() - YRP.ctr(2 * 20) )
				self:SetPos(YRP.ctr(20), YRP.ctr(20) )
			end
		end

		local dhr = {}
		dhr.parent = General
		dhr.color = YRPGetColor( "2" )
		local bl = {}
		bl.parent = General
		bl.color = YRPGetColor( "2" )
		local ble = {}
		ble.parent = General
		ble.color = YRPGetColor( "2" )
		ble.brx = YRP.ctr(50)
		DBoolLine( bl, REL.bool_bonefracturing, "LID_bonefracturing", "update_bool_bonefracturing" )
		DFloatLine( ble, REL.float_bonechance_legs, "% " .. YRP.lang_string( "LID_breakchancelegs" ), "update_float_bonechance_legs" )
		DFloatLine( ble, REL.float_bonechance_arms, "% " .. YRP.lang_string( "LID_breakchancearms" ), "update_float_bonechance_arms" )
		DHR( dhr)
		DBoolLine( bl, REL.bool_bleeding, "LID_bleeding", "update_bool_bleeding" )
		DFloatLine( ble, REL.float_bleedingchance, "% " .. YRP.lang_string( "LID_bleedingchance" ), "update_float_bleedingchance" )
		DHR( dhr)
		DBoolLine( bl, REL.bool_slowing, "LID_slowing", "update_bool_slowing" )
		DFloatLine( ble, REL.float_slowingtime, "LID_slowingtime", "update_float_slowingtime" )
		DFloatLine( ble, REL.float_slowingfactor, "LID_slowingfactor", "update_float_slowingfactor" )
		DHR( dhr)
		DBoolLine( bl, REL.bool_custom_falldamage, "LID_customfalldamage", "update_bool_custom_falldamage" )
		DBoolLine( ble, REL.bool_custom_falldamage_percentage, "LID_percentage", "update_bool_custom_falldamage_percentage" )
		DFloatLine( ble, REL.float_custom_falldamage_muliplier, "LID_multiplier", "update_float_custom_falldamage_muliplier" )



		local Damage = YRPCreateD( "YGroupBox", Scroller, YRP.ctr(1000), Scroller:GetTall(), 0, 0)
		Damage:SetText( "LID_damagesettings" )
		function Damage:Paint(pw, ph)
			hook.Run( "YGroupBoxPaint", self, pw, ph)
		end
		Scroller:AddPanel(Damage)

		Damage.dmg = 1
		dhr = {}
		dhr.parent = Damage
		dhr.color = YRPGetColor( "2" )
		bl = {}
		bl.parent = Damage
		bl.color = YRPGetColor( "2" )
		ble = {}
		ble.parent = Damage
		ble.color = YRPGetColor( "2" )
		ble.brx = YRP.ctr(50)
		local dmg = DFloatLine( bl, Damage.dmg, "LID_damage", "" )
		DHR( dhr)
		DHeader( bl, "LID_players" )
		DBoolLine( bl, REL.bool_headshotdeadly_player, "LID_headshotisdeadly", "update_bool_headshotdeadly_player" )
		DFloatLine( ble, REL.float_hitfactor_player_head, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_head" ), "update_float_hitfactor_player_head", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_player_ches, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_chest" ), "update_float_hitfactor_player_ches", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_player_stom, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_stomach" ), "update_float_hitfactor_player_stom", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_player_arms, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_arms" ), "update_float_hitfactor_player_arms", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_player_legs, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_legs" ), "update_float_hitfactor_player_legs", nil, nil, dmg)
		DHR( dhr)
		DHeader( bl, "LID_npcs" )
		DBoolLine( bl, REL.bool_headshotdeadly_npc, "LID_headshotisdeadly", "update_bool_headshotdeadly_npc" )
		DFloatLine( ble, REL.float_hitfactor_npc_head, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_head" ), "update_float_hitfactor_npc_head", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_npc_ches, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_chest" ), "update_float_hitfactor_npc_ches", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_npc_stom, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_stomach" ), "update_float_hitfactor_npc_stom", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_npc_arms, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_arms" ), "update_float_hitfactor_npc_arms", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_npc_legs, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_legs" ), "update_float_hitfactor_npc_legs", nil, nil, dmg)
		DHR( dhr)
		DFloatLine( ble, REL.float_hitfactor_entities, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_entities" ), "update_float_hitfactor_entities", nil, nil, dmg)
		DFloatLine( ble, REL.float_hitfactor_vehicles, YRP.lang_string( "LID_hitfactor" ) .. " - " .. YRP.lang_string( "LID_vehicles" ), "update_float_hitfactor_vehicles", nil, nil, dmg)
	end
end)

function OpenSettingsRealistic()
	net.Start( "Connect_Settings_Realistic" )
	net.SendToServer()
end
