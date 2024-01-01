--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _load = 0
timer.Create(
	"_load",
	1,
	0,
	function()
		_load = _load + 25
		if _load > 100 then
			_load = 0
		end
	end
)

function drawBattery(x)
	local y = ctrb(6)
	local _bp = system.BatteryPower()
	local _ba = {}
	_ba.h = 28
	_ba.w = 16
	_ba.hs = 3
	_ba.ws = 8
	--Grey Form of Battery
	draw.RoundedBox(0, x + ctrb(_ba.w - _ba.ws) / 2, y, ctrb(_ba.ws), ctrb(_ba.hs), Color(100, 100, 100, 200))
	draw.RoundedBox(0, x, y + ctrb(_ba.hs), ctrb(_ba.w), ctrb(_ba.h - _ba.hs), Color(100, 100, 100, 200))
	if _bp > 100 then
		_bp = _load
		_text = 100
	else
		_text = _bp
	end

	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation(STENCILOPERATION_INCR)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	--Form of Battery
	draw.RoundedBox(0, x + ctrb(_ba.w - _ba.ws) / 2, y, ctrb(_ba.ws), ctrb(_ba.hs), Color(255, 255, 255, 255))
	draw.RoundedBox(0, x, y + ctrb(_ba.hs), ctrb(_ba.w), ctrb(_ba.h - _ba.hs), Color(255, 255, 255, 255))
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	--Percent of Form
	draw.RoundedBox(0, x, y + ctrb(_ba.h - _ba.h * (_bp / 100)), ctrb(_ba.w), ctrb(_ba.h), Color(255, 255, 255, 255))
	render.SetStencilEnable(false)
	draw.SimpleTextOutlined(_text .. "%", "DermaDefault", x - ctrb(10), ctrb(20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, ctrb(1), Color(0, 0, 0, 255))
end

function appPosition(parent, x, y, nr)
	local _tmp = YRPCreateD("DPanel", parent, ctrb(64), ctrb(64), x, y)
	_tmp.nr = nr
	function _tmp:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 1))
		end
	end

	_tmp:Receiver(
		"APP",
		function(receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY)
			if isDropped and receiver:IsHovered() then
				local _x, _y = receiver:GetPos()
				tableOfDroppedPanels[1]:SetPos(_x + YRP.ctr(1), _y + YRP.ctr(1))
				changeAppPosition(tableOfDroppedPanels[1].tbl.ClassName, receiver.nr)
			end
		end, {}
	)

	return _tmp
end

function createSmartphone(parent, w, h, x, y)
	local _tmp = YRPCreateD("DFrame", parent, w, h, x, y)
	_tmp.tbl = {}
	_tmp.tbl.w = w
	_tmp.tbl.h = h
	_tmp.tbl.x = x
	_tmp.tbl.y = y
	--[[ Elements ]]
	--
	_tmp.display = YRPCreateD("DPanel", _tmp, w, h, 0, 0)
	function _tmp.display:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, YRPGetSpBackColor())
		if self.apps ~= nil then
			for i, app in pairs(getAllDBApps()) do
				local _x = getTblX(app.Position, 5)
				local _y = getTblY(app.Position, 5)
				local _appName = app.PrintName
				if app.LangName ~= nil then
					local _name = YRP.trans(app.LangName, app.PrintName)
					_appName = _name
				end

				if #_appName > 8 then
					_appName = string.sub(_appName, 1, 8) .. "..."
				end

				draw.SimpleTextOutlined(_appName, "Y_14_500", ctrb(40) + _x * ctrb(64) + _x * ctrb(40) + ctrb(64 / 2), ctrb(40) + ctrb(40) + _y * ctrb(64) + _y * ctrb(40 + 30) + ctrb(64 + 20), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb(1), Color(0, 0, 0, 255))
			end
		end
	end

	--[[ TOP BAR ]]
	--
	_tmp.topbar = YRPCreateD("DPanel", _tmp, w, ctrb(40), 0, 0)
	function _tmp.topbar:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
		local _clock = {}
		_clock.sec = os.date("%S")
		_clock.min = os.date("%M")
		_clock.hours = os.date("%I")
		drawBattery(pw - ctrb(90))
		draw.SimpleTextOutlined(_clock.hours .. ":" .. _clock.min, "DermaDefault", pw - ctrb(10), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, ctrb(1), Color(0, 0, 0, 255))
	end

	--[[ BOT BAR ]]
	--
	_tmp.botbar = YRPCreateD("DPanel", _tmp, w, ctrb(40), 0, h - ctrb(40))
	function _tmp.botbar:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(100, 100, 100, 255))
	end

	_tmp.botbar.buttonhome = YRPCreateD("DButton", _tmp.botbar, w / 3, ctrb(40), w / 3, 0)
	_tmp.botbar.buttonhome:SetText("")
	function _tmp.botbar.buttonhome:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 100, 255))
		else
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
		end

		draw.SimpleTextOutlined("O", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb(1), Color(0, 0, 0, 255))
	end

	function _tmp.botbar.buttonhome:DoClick()
		_tmp.display:HomeScreen()
	end

	_tmp.botbar.buttonback = YRPCreateD("DButton", _tmp.botbar, w / 3, ctrb(40), (w / 3) * 2, 0)
	_tmp.botbar.buttonback:SetText("")
	function _tmp.botbar.buttonback:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 100, 255))
		else
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
		end
		--draw.SimpleTextOutlined(YRP.trans( "LID_wip" ), "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb(1), Color( 0, 0, 0, 255 ) )
	end

	_tmp.botbar.buttonapps = YRPCreateD("DButton", _tmp.botbar, w / 3, ctrb(40), 0, 0)
	_tmp.botbar.buttonapps:SetText("")
	function _tmp.botbar.buttonapps:Paint(pw, ph)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 100, 255))
		else
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
		end
		--draw.SimpleTextOutlined(YRP.trans( "LID_wip" ), "DermaDefault", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb(1), Color( 0, 0, 0, 255 ) )
	end

	--[[ Clear Display ]]
	--
	function _tmp.display:ClearDisplay()
		local _childs = self:GetChildren()
		for i, child in pairs(_childs) do
			child:Remove()
		end
	end

	--[[ Getter ]]
	--
	function _tmp:GetDisplay()
		return _tmp.display
	end

	function _tmp:GetTopBar()
		return _tmp.display.topbar
	end

	function _tmp:GetTable()
		return self.tbl
	end

	function _tmp.display:OpenFullscreen()
		self:ClearDisplay()
		local _w = ScW()
		local _h = _w / 16 * 9
		_tmp:SetPos(0, 0)
		_tmp.display:SetPos(0, 0)
		_tmp:SetSize(_w, _h)
		_tmp.display:SetSize(_w, _h)
		_tmp.topbar:SetPos(0, 0)
		_tmp.botbar:SetPos(0, _h - ctrb(40))
		_tmp.topbar:SetSize(_w, ctrb(40))
		_tmp.botbar:SetSize(_w, ctrb(40))
		_tmp:Center()
	end

	function _tmp.display:HomeScreen()
		self:ClearDisplay()
		_tmp:SetPos(_tmp.tbl.x, _tmp.tbl.y)
		_tmp.display:SetPos(0, 0)
		_tmp:SetSize(_tmp.tbl.w, _tmp.tbl.h)
		_tmp.display:SetSize(_tmp.tbl.w, _tmp.tbl.h)
		_tmp.topbar:SetPos(0, 0)
		_tmp.botbar:SetPos(0, _tmp.tbl.h - ctrb(40))
		_tmp.topbar:SetSize(_tmp.tbl.w, ctrb(40))
		_tmp.botbar:SetSize(_tmp.tbl.w, ctrb(40))
		--[[ App Positions ]]
		--
		_tmp.pos = {}
		local _x = 0
		local _y = 0
		for i = 0, 24 do
			_tmp.pos[i] = appPosition(_tmp.display, ctrb(40) + _x * ctrb(64) + _x * ctrb(40), ctrb(40) + ctrb(40) + _y * ctrb(64) + _y * ctrb(40 + 30), i)
			_x = _x + 1
			if _x > 4 then
				_x = 0
				_y = _y + 1
			end
		end

		--[[ Apps ]]
		--
		_tmp.display.apps = {}
		local _px = 0
		local _py = 0
		for i, app in pairs(getAllDBApps()) do
			_px = getTblX(app.Position, 5)
			_py = getTblY(app.Position, 5)
			_tmp.display.apps[app.Position] = createApp(app, _tmp.display, ctrb(40) + _px * ctrb(64) + _px * ctrb(40), ctrb(40) + ctrb(40) + _py * ctrb(64) + _py * ctrb(40 + 30))
		end
	end

	_tmp.display:HomeScreen()
	_tmp:MakePopup()
	input.SetCursorPos(_tmp.tbl.x + _tmp.tbl.w / 2, _tmp.tbl.y + _tmp.tbl.h / 2)

	return _tmp
end