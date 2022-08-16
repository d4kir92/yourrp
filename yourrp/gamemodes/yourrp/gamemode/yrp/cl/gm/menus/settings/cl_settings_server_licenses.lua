--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local _li = {}

local _licenses = nil

local function GetResult()
	net.Start( "get_licenses" )
	net.SendToServer()	
end

local function UpdateList( value )
	local dbList = _li._lic
	if pa( dbList ) then
		dbList.list:Clear()

		local li = dbList:GetList()
		if li then
			for i, license in SortedPairsByMemberValue( _licenses, "name" ) do
				if strEmpty( value ) or string.find( string.lower( license.name ), string.lower( value ), 1, true ) then
					dbList:AddEntry( license )
				end
			end
		end
	end
end

net.Receive( "get_licenses", function()
	_licenses = net.ReadTable()

	local PARENT = GetSettingsSite()
	if pa(PARENT) then

		local spw = PARENT:GetWide()
		local sph = PARENT:GetTall()

		_li.ea = YRPCreateD( "DPanel", PARENT, ScW() - YRP.ctr(40 + 480 + 40 + 40), sph - YRP.ctr(80), YRP.ctr(40 + 480 + 40), YRP.ctr(40)	)
		function _li.ea:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 0, 0, 200) )
		end

		_li._lic = YRPCreateD( "DYRPDBList", PARENT, YRP.ctr(480), YRP.ctr(1600), YRP.ctr(40), YRP.ctr(40 + 50 + 10) )
		_li._lic:SetListHeader(YRP.lang_string( "LID_licenses" ) )
		--_li._lic:SetDStrForAdd( "license_add" )
		_li._lic:SetEditArea(_li.ea)
		function _li.eaf(tbl)
			for i, child in pairs(_li.ea:GetChildren() ) do
				child:Remove()
			end

			--[[ NAME ]]--
			_li.name = YRPCreateD( "DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, 0)
			_li.name.textentry.tbl = tbl
			_li.name:SetHeader(YRP.lang_string( "LID_name" ) )
			_li.name:SetText(tbl.name)
			function _li.name.textentry:OnChange()
				self.tbl.name = self:GetValue()
				net.Start( "edit_license_name" )
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.name)
				net.SendToServer()
			end

			--[[ Description ]]--
			_li.desc = YRPCreateD( "DYRPTextEntry", _li.ea, YRP.ctr(800), YRP.ctr(400), 0, YRP.ctr(150) )
			_li.desc.textentry.tbl = tbl
			_li.desc:SetHeader(YRP.lang_string( "LID_description" ) )
			_li.desc:SetText(tbl.description)
			function _li.desc.textentry:OnChange()
				self.tbl.description = self:GetValue()
				net.Start( "edit_license_description" )
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.description)
				net.SendToServer()
			end

			--[[ Price ]]--
			_li.price = YRPCreateD( "DYRPNumberWang", _li.ea, YRP.ctr(800), YRP.ctr(100), 0, YRP.ctr(600) )
			_li.price.numberwang.tbl = tbl
			_li.price:SetHeader(YRP.lang_string( "LID_price" ) )
			_li.price:SetValue(tbl.price)
			function _li.price.numberwang:OnChange()
				self.tbl.price = self:GetValue()
				net.Start( "edit_license_price" )
					net.WriteString(self.tbl.uniqueID)
					net.WriteString(self.tbl.price)
				net.SendToServer()
			end
		end
		_li._lic:SetEditFunc(_li.eaf)
		function _li._lic:AddFunction()
			net.Start( "license_add" )
			net.SendToServer()
		end
		function _li._lic:RemoveFunction()
			net.Start( "license_rem" )
				net.WriteString(self.uid)
			net.SendToServer()
		end 

		for i, license in SortedPairsByMemberValue(_licenses, "name") do
			_li._lic:AddEntry(license)
		end
	end
end)

function OpenSettingsLicenses()
	local lply = LocalPlayer()

	local PARENT = GetSettingsSite()
	if pa(PARENT) then
		_li._search = YRPCreateD( "DTextEntry", PARENT, YRP.ctr(480), YRP.ctr(50), YRP.ctr(40), YRP.ctr(40) )
		_li._search:SetPlaceholderText( "SEARCH" )
		function _li._search:OnTextChanged()
			local value = string.lower( self:GetText() )
			UpdateList( value )
		end

		GetResult()
	end
end