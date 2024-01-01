--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/specializations/gpl.txt)
local _li = {}
net.Receive(
	"nws_yrp_get_specializations",
	function()
		local _specializations = net.ReadTable()
		local PARENT = GetSettingsSite()
		if YRPPanelAlive(PARENT) then
			local sph = PARENT:GetTall()
			_li.ea = YRPCreateD("DPanel", PARENT, ScW() - YRP.ctr(40 + 480 + 40 + 40), sph - YRP.ctr(80), YRP.ctr(40 + 480 + 40), YRP.ctr(40))
			function _li.ea:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
			end

			_li._spe = YRPCreateD("DYRPDBList", PARENT, YRP.ctr(480), YRP.ctr(500), YRP.ctr(40), YRP.ctr(40))
			_li._spe:SetListHeader(YRP.trans("LID_specializations"))
			--_li._spe:SetDStrForAdd( "specialization_add" )
			_li._spe:SetEditArYRPEntityAlive(_li.ea)
			function _li.eaf(tbl)
				for i, child in pairs(_li.ea:GetChildren()) do
					child:Remove()
				end

				--[[ NAME ]]
				--
				_li.name = YRPCreateD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, 0)
				_li.name.textentry.tbl = tbl
				_li.name:SetHeader(YRP.trans("LID_name"))
				_li.name:SetText(tbl.name)
				function _li.name.textentry:OnChange()
					self.tbl.name = self:GetValue()
					net.Start("nws_yrp_edit_specialization_name")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.name)
					net.SendToServer()
				end

				--[[ Prefix ]]
				--
				_li.prefix = YRPCreateD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, YRP.ctr(110))
				_li.prefix.textentry.tbl = tbl
				_li.prefix:SetHeader(YRP.trans("LID_prefix"))
				_li.prefix:SetText(tbl.prefix)
				function _li.prefix.textentry:OnChange()
					self.tbl.prefix = self:GetValue()
					net.Start("nws_yrp_edit_specialization_prefix")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.prefix)
					net.SendToServer()
				end

				--[[ Suffix ]]
				--
				_li.suffix = YRPCreateD("DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, YRP.ctr(220))
				_li.suffix.textentry.tbl = tbl
				_li.suffix:SetHeader(YRP.trans("LID_suffix"))
				_li.suffix:SetText(tbl.suffix)
				function _li.suffix.textentry:OnChange()
					self.tbl.suffix = self:GetValue()
					net.Start("nws_yrp_edit_specialization_suffix")
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.suffix)
					net.SendToServer()
				end

				--[[ sweps ]]
				--
				local sweps = {}
				sweps.parent = _li.ea
				sweps.uniqueID = tbl.uniqueID
				sweps.header = "LID_sweps"
				sweps.value = tbl.sweps or ""
				sweps.uniqueID = tbl.uniqueID
				sweps.w = YRP.ctr(800)
				sweps.h = YRP.ctr(325)
				sweps.x = YRP.ctr(0)
				sweps.y = YRP.ctr(330)
				sweps.doclick = function()
					local lply = LocalPlayer()
					lply.yrpseltab = {}
					for i, v in pairs(string.Explode(",", tbl.sweps or "")) do
						if not table.HasValue(lply.yrpseltab) then
							table.insert(lply.yrpseltab, v)
						end
					end

					local allsweps = YRPGetSWEPsList()
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
						local lply2 = LocalPlayer()
						net.Start("nws_yrp_spec_add_swep")
						net.WriteInt(tbl.uniqueID, 32)
						net.WriteTable(lply2.yrpseltab)
						net.SendToServer()
						tbl.sweps = table.concat(lply2.yrpseltab, ",")
					end

					YRPOpenSelector(cl_sweps, true, "classname", YRPUpdateSpecSweps)
				end

				_li.sweps = DStringListBox(sweps)
				net.Receive(
					"nws_yrp_get_specialization_sweps",
					function()
						local tab_pm = net.ReadTable()
						local cl_sweps = {}
						for i, v in pairs(tab_pm) do
							local swep = {}
							swep.uniqueID = i
							swep.string_models = GetSwepWorldModel(v)
							swep.string_classname = v
							swep.string_name = v
							swep.doclick = function()
								net.Start("nws_yrp_spec_rem_swep")
								net.WriteInt(tbl.uniqueID, 32)
								net.WriteString(swep.string_classname)
								net.SendToServer()
								local tmp = {}
								for id, w in pairs(string.Explode(",", tbl.sweps or "")) do
									if w ~= swep.string_classname then
										table.insert(tmp, w)
									end
								end

								tbl.sweps = table.concat(tmp, ",")
							end

							swep.h = YRP.ctr(120)
							table.insert(cl_sweps, swep)
						end

						if _li.sweps.dpl.AddLines ~= nil then
							_li.sweps.dpl:AddLines(cl_sweps)
						end
					end
				)

				net.Start("nws_yrp_get_specialization_sweps")
				net.WriteInt(tbl.uniqueID, 32)
				net.SendToServer()
				--[[ pms ]]
				--
				local pms = {}
				pms.parent = _li.ea
				pms.uniqueID = tbl.uniqueID
				pms.header = "LID_playermodels"
				pms.value = tbl.pms or ""
				pms.uniqueID = tbl.uniqueID
				pms.w = YRP.ctr(800)
				pms.h = YRP.ctr(600)
				pms.x = YRP.ctr(0)
				pms.y = YRP.ctr(665)
				pms.doclick = function()
					local lply = LocalPlayer()
					lply.yrpseltab = {}
					for i, v in pairs(string.Explode(",", tbl.pms or "")) do
						if not table.HasValue(lply.yrpseltab) then
							table.insert(lply.yrpseltab, v)
						end
					end

					local noneplayermodels = {}
					for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
						if not addon.downloaded or not addon.mounted then continue end
						AddToTabRecursive(noneplayermodels, "models/", addon.title, "*.mdl")
					end

					local allvalidmodels = player_manager.AllValidModels()
					local cl_pms = {}
					for k, v in pairs(allvalidmodels) do
						cl_pms[v] = {}
						cl_pms[v].WorldModel = v
						cl_pms[v].ClassName = v
						cl_pms[v].PrintName = player_manager.TranslateToPlayerModelName(v)
					end

					for k, v in pairs(noneplayermodels) do
						cl_pms[v] = {}
						cl_pms[v].WorldModel = v
						cl_pms[v].ClassName = v
						cl_pms[v].PrintName = v
					end

					function YRPUpdateSpecPMs()
						local lply2 = LocalPlayer()
						net.Start("nws_yrp_spec_add_pm")
						net.WriteInt(tbl.uniqueID, 32)
						net.WriteTable(lply2.yrpseltab)
						net.SendToServer()
						tbl.pms = table.concat(lply2.yrpseltab, ",")
					end

					YRPOpenSelector(cl_pms, true, "classname", YRPUpdateSpecPMs)
				end

				_li.pms = DStringListBox(pms)
				net.Receive(
					"nws_yrp_get_specialization_pms",
					function()
						local tab_pm = net.ReadTable()
						local cl_pms = {}
						for i, v in pairs(tab_pm) do
							local pms2 = {}
							pms2.uniqueID = i
							pms2.string_models = v
							pms2.string_classname = v
							pms2.string_name = v
							pms2.doclick = function()
								net.Start("nws_yrp_spec_rem_pm")
								net.WriteInt(tbl.uniqueID, 32)
								net.WriteString(pms2.string_classname)
								net.SendToServer()
								local tmp = {}
								for id, w in pairs(string.Explode(",", tbl.pms or "")) do
									if w ~= pms2.string_classname then
										table.insert(tmp, w)
									end
								end

								tbl.pms = table.concat(tmp, ",")
							end

							pms2.h = YRP.ctr(120)
							table.insert(cl_pms, pms2)
						end

						if _li.pms.dpl.AddLines ~= nil then
							_li.pms.dpl:AddLines(cl_pms)
						end
					end
				)

				net.Start("nws_yrp_get_specialization_pms")
				net.WriteInt(tbl.uniqueID, 32)
				net.SendToServer()
			end

			_li._spe:SetEditFunc(_li.eaf)
			function _li._spe:AddFunction()
				net.Start("nws_yrp_specialization_add")
				net.SendToServer()
			end

			function _li._spe:RemoveFunction()
				net.Start("nws_yrp_specialization_rem")
				net.WriteString(self.uid)
				net.SendToServer()
			end

			for i, specializations in pairs(_specializations) do
				_li._spe:AddEntry(specializations)
			end
		end
	end
)

function OpenSettingsSpecializations()
	net.Start("nws_yrp_get_specializations")
	net.SendToServer()
end