--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local APP = {}
APP.PrintName = "SP Settings"
APP.LangName = "settings"
APP.ClassName = "sp_settings"

APP.Icon = Material( "vgui/yrp/dark_settings.png" )

function APP:AppIcon(pw, ph)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.Icon	)
	surface.DrawTexturedRect(0, 0, pw, ph)

	--draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 255) )
end

function APP:OpenApp( display, x, y, w, h)

	local _tmp = createD( "DPanel", display, w, h, x, y)
	function _tmp:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(200, 200, 200, 255) )

		draw.RoundedBox(0, 0, 0, pw, ctrb(60), Color(40, 40, 40, 255) )
		surfaceText(YRP.lang_string( "LID_settings" ), "Y_36_500", ctrb(10), ctrb(30), Color(255, 255, 255), 0, 1)
	end

	_tmp.colors = createD( "DButton", display, w, ctrb(60), x, y + ctrb(60) )
	_tmp.colors:SetText( "" )
	function _tmp.colors:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 200, 255) )
		else
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255) )
		end
		surfaceText( "Color settings", "Y_36_500", pw/2, ph/2, Color(0, 0, 0, 255), 1, 1)
	end
	function _tmp.colors:DoClick()

		_tmp.menu_color = createD( "DScrollPanel", display, w, h, x, y)
		function _tmp.menu_color:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(200, 200, 200, 255) )
		end

		_tmp.menu_color_header = createD( "DPanel", display, w, ctrb(60), x, y)
		function _tmp.menu_color_header:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255) )
			surfaceText( "Color settings", "Y_36_500", ctrb(10), ctrb(30), Color(255, 255, 255), 0, 1)
		end

		--[[ Case Color ]]--
		local _cc = createD( "DPanel", _tmp.menu_color, w-ctrb(30), ctrb(60), 0, ctrb(60) )
		function _cc:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255) )
			surfaceText( "Case Color", "Y_36_500", pw/2, ph/2, Color(0, 0, 0), 1, 1)
		end
		local _ccm = createD( "DColorMixer", _tmp.menu_color, w-ctrb(30), ctrb(400), 0, ctrb(120) )
		_ccm:SetPalette(true)
		_ccm:SetAlphaBar(true)
		_ccm:SetWangs(true)
		_ccm:SetColor(YRPGetSpCaseColor() )
		function _ccm:ValueChanged( col)
			setSpCaseColor( col)
		end

		--[[ Background Color ]]--
		local _bc = createD( "DPanel", _tmp.menu_color, w-ctrb(30), ctrb(60), 0, ctrb(120+400) )
		function _bc:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255) )
			surfaceText( "Background Color", "Y_36_500", pw/2, ph/2, Color(0, 0, 0), 1, 1)
		end
		local _bcm = createD( "DColorMixer", _tmp.menu_color, w-ctrb(30), ctrb(400), 0, ctrb(120+400+60) )
		_bcm:SetPalette(true)
		_bcm:SetAlphaBar(true)
		_bcm:SetWangs(true)
		_bcm:SetColor(YRPGetSpBackColor() )
		function _bcm:ValueChanged( col)
			setSpBackColor( col)
		end

		_tmp.menu_color:AddItem(_cc)
		_tmp.menu_color:AddItem(_ccm)
		_tmp.menu_color:AddItem(_bc)
		_tmp.menu_color:AddItem(_bcm)

	end
end

addApp(APP)
