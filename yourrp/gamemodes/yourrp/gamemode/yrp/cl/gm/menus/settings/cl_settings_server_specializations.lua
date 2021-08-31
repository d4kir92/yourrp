--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/specializations/gpl.txt)

local _li = {}
net.Receive("get_specializations", function()
	local _specializations = net.ReadTable()

	local PARENT = GetSettingsSite()
	if pa(PARENT) then

		local spw = PARENT:GetWide()
		local sph = PARENT:GetTall()

		_li.ea = createD("DPanel", PARENT, ScW() - YRP.ctr(40 + 480 + 40 + 40), sph - YRP.ctr(80), YRP.ctr(40 + 480 + 40), YRP.ctr(40)	)
		function _li.ea:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
		end

		_li._spe = createD("DYRPDBList", PARENT, YRP.ctr(480), YRP.ctr(500), YRP.ctr(40), YRP.ctr(40))
		_li._spe:SetListHeader(YRP.lang_string("LID_specializations"))
		--_li._spe:SetDStrForAdd("specialization_add")
		_li._spe:SetEditArea(_li.ea)
		function _li.eaf(tbl)
			for i, child in pairs(_li.ea:GetChildren()) do
				child:Remove()
			end

			--[[ NAME ]]--
			_li.name = createD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, 0)
			_li.name.textentry.tbl = tbl
			_li.name:SetHeader(YRP.lang_string("LID_name"))
			_li.name:SetText(SQL_STR_OUT(tbl.name))
			function _li.name.textentry:OnChange()
				self.tbl.name = self:GetValue()
				net.Start("edit_specialization_name")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.name)
				net.SendToServer()
			end

			--[[ Prefix ]]--
			_li.prefix = createD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, YRP.ctr(110))
			_li.prefix.textentry.tbl = tbl
			_li.prefix:SetHeader(YRP.lang_string("LID_prefix"))
			_li.prefix:SetText(SQL_STR_OUT(tbl.prefix))
			function _li.prefix.textentry:OnChange()
				self.tbl.prefix = self:GetValue()
				net.Start("edit_specialization_prefix")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.prefix)
				net.SendToServer()
			end

			--[[ Suffix ]]--
			_li.suffix = createD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, YRP.ctr(220))
			_li.suffix.textentry.tbl = tbl
			_li.suffix:SetHeader(YRP.lang_string("LID_suffix"))
			_li.suffix:SetText(SQL_STR_OUT(tbl.suffix))
			function _li.suffix.textentry:OnChange()
				self.tbl.suffix = self:GetValue()
				net.Start("edit_specialization_suffix")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.suffix)
				net.SendToServer()
			end

			--[[ sweps ]]--
			-- SWEPS
			local sweps = {}
			sweps.parent = _li.ea
			sweps.uniqueID = tbl.uniqueID
			sweps.header = "LID_sweps"
			sweps.netstr = "edit_specialization_sweps"
			sweps.value = tbl.string_sweps
			sweps.uniqueID = tbl.uniqueID
			sweps.w = YRP.ctr(800)
			sweps.h = YRP.ctr(325)
			sweps.x = YRP.ctr(0)
			sweps.y = YRP.ctr(330)
			sweps.doclick = function()
				local allsweps = GetSWEPsList()
				local cl_sweps = {}
				local count = 0
				for k, v in pairs(allsweps) do
					count = count + 1
					cl_sweps[count] = {}
					cl_sweps[count].WorldModel = v.WorldModel or ""
					cl_sweps[count].ClassName = v.ClassName or "NO CLASSNAME"
					cl_sweps[count].PrintName = v.PrintName or v.ClassName or "NO PRINTNAME"
				end
				function YRPUpdateSpecSweps()
					local lply = LocalPlayer()
					net.Start("spec_add_swep")
						net.WriteInt(tbl.uniqueID, 32)
						net.WriteString(lply.yrpseltab[1])
					net.SendToServer()
				end

				YRPOpenSelector(cl_sweps, false, "classname", YRPUpdateSpecSweps)
			end
			_li.sweps = DStringListBox(sweps)
			net.Receive("get_specialization_sweps", function()
				local tab_pm = net.ReadTable()
				local cl_sweps = {}
				for i, v in pairs(tab_pm) do
					local swep = {}
					swep.uniqueID = i
					swep.string_models = GetSwepWorldModel(v)
					swep.string_classname = v
					swep.string_name = v
					swep.doclick = function()
						net.Start("spec_rem_swep")
							net.WriteInt(tbl.uniqueID, 32)
							net.WriteString(swep.string_classname)
						net.SendToServer()
					end
					swep.h = YRP.ctr(120)
					table.insert(cl_sweps, swep)
				end
				if _li.sweps.dpl.AddLines != nil then
					_li.sweps.dpl:AddLines(cl_sweps)
				end
			end)
			net.Start("get_specialization_sweps")
				net.WriteInt(tbl.uniqueID, 32)
			net.SendToServer()
		end
		_li._spe:SetEditFunc(_li.eaf)
		function _li._spe:AddFunction()
			net.Start("specialization_add")
			net.SendToServer()
		end
		function _li._spe:RemoveFunction()
			net.Start("specialization_rem")
				net.WriteString(self.uid)
			net.SendToServer()
		end
		for i, specializations in pairs(_specializations) do
			_li._spe:AddEntry(specializations)
		end
	end
end)

function OpenSettingsSpecializations()
	local lply = LocalPlayer()

	net.Start("get_specializations")
	net.SendToServer()
end