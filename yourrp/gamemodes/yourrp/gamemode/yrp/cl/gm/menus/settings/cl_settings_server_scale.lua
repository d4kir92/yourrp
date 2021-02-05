--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #scale

function BuildScaleSite()
	local PARENT = GetSettingsSite()
	if pa(PARENT) then
		
		local SW = 500

		local Y = 20

		local scale_hunger = createD("YNumberWang", PARENT, YRP.ctr(SW), YRP.ctr(100), YRP.ctr(20), YRP.ctr(Y))
		scale_hunger:SetHeader("LID_scale_hunger")
		scale_hunger:SetMin(0.01)
		scale_hunger:SetMax(100.0)
		scale_hunger:SetValue(GetGlobalDFloat("float_scale_hunger", 0))
		function scale_hunger:OnValueChanged(val)
			net.Start("update_float_scale_hunger")
				net.WriteFloat(val)
			net.SendToServer()
		end
		Y = Y + 120
	
		local scale_thirst = createD("YNumberWang", PARENT, YRP.ctr(SW), YRP.ctr(100), YRP.ctr(20), YRP.ctr(Y))
		scale_thirst:SetHeader("LID_scale_thirst")
		scale_thirst:SetMin(0.01)
		scale_thirst:SetMax(100.0)
		scale_thirst:SetValue(GetGlobalDFloat("float_scale_thirst", 0))
		function scale_thirst:OnValueChanged(val)
			net.Start("update_float_scale_thirst")
				net.WriteFloat(val)
			net.SendToServer()
		end
		Y = Y + 120

		local scale_hygiene = createD("YNumberWang", PARENT, YRP.ctr(SW), YRP.ctr(100), YRP.ctr(20), YRP.ctr(Y))
		scale_hygiene:SetHeader("LID_scale_hygiene")
		scale_hygiene:SetMin(0.01)
		scale_hygiene:SetMax(100.0)
		scale_hygiene:SetValue(GetGlobalDFloat("float_scale_hygiene", 0))
		function scale_hygiene:OnValueChanged(val)
			net.Start("update_float_scale_hygiene")
				net.WriteFloat(val)
			net.SendToServer()
		end
		Y = Y + 120 + 50

		local scale_radiation_in = createD("YNumberWang", PARENT, YRP.ctr(SW), YRP.ctr(100), YRP.ctr(20), YRP.ctr(Y))
		scale_radiation_in:SetHeader("LID_scale_radiation_in")
		scale_radiation_in:SetMin(0.01)
		scale_radiation_in:SetMax(100.0)
		scale_radiation_in:SetValue(GetGlobalDFloat("float_scale_radiation_in", 0))
		function scale_radiation_in:OnValueChanged(val)
			net.Start("update_float_scale_radiation_in")
				net.WriteFloat(val)
			net.SendToServer()
		end
		Y = Y + 120

		local scale_radiation_out = createD("YNumberWang", PARENT, YRP.ctr(SW), YRP.ctr(100), YRP.ctr(20), YRP.ctr(Y))
		scale_radiation_out:SetHeader("LID_scale_radiation_out")
		scale_radiation_out:SetMin(0.01)
		scale_radiation_out:SetMax(100.0)
		scale_radiation_out:SetValue(GetGlobalDFloat("float_scale_radiation_out", 0))
		function scale_radiation_out:OnValueChanged(val)
			net.Start("update_float_scale_radiation_out")
				net.WriteFloat(val)
			net.SendToServer()
		end
		Y = Y + 120 + 50

		local scale_stamina_jump = createD("YNumberWang", PARENT, YRP.ctr(SW), YRP.ctr(100), YRP.ctr(20), YRP.ctr(Y))
		scale_stamina_jump:SetHeader("LID_scale_stamina_jump")
		scale_stamina_jump:SetMin(0.01)
		scale_stamina_jump:SetMax(100.0)
		scale_stamina_jump:SetValue(GetGlobalDFloat("float_scale_stamina_jump", 0))
		function scale_stamina_jump:OnValueChanged(val)
			net.Start("update_float_scale_stamina_jump")
				net.WriteFloat(val)
			net.SendToServer()
		end
		Y = Y + 120 + 50
	end
end

function OpenSettingsScale()
	BuildScaleSite()
end
