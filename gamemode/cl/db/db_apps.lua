--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--[[ APP ]]--
local APP = {}

function APP:Init()
	self:SetText( "" )
end

function APP:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0, 255 ) )
	draw.SimpleTextOutlined( "NO", "HudHintTextSmall", w/2, h/3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb( 1 ), Color( 0, 0, 0, 255 ) )
	draw.SimpleTextOutlined( "ICON", "HudHintTextSmall", w/2, h*2/3, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctrb( 1 ), Color( 0, 0, 0, 255 ) )
end

vgui.Register( "YRPAPP", APP, "DButton" )

function appSize()
  return 64
end

function addApp( app )
	printGM( "db", "Add App: " .. tostring( app.PrintName ) .. " [" .. tostring( app.ClassName ).. "]" )
	if app.PrintName == nil then
		printGM( "note", "-> app.PrintName is missing!" )
	end
	if app.ClassName == nil then
		printGM( "note", "-> app.ClassName is missing!" )
	end
	if app.OpenApp == nil then
		printGM( "note", "-> function app:OpenApp is missing!" )
	end

	list.Add( "yrp_apps", app )
end

function getAllApps()
  return list.Get( "yrp_apps" ) --yrp_apps
end

function createApp( app, parent, x, y )
	local _tmp = createD( "YRPAPP", parent, ctrb( 64 ), ctrb( 64 ), x, y )
  _tmp.tbl = app
	_tmp.oldpaint = _tmp.Paint
	function _tmp:Paint( pw, ph )
		if app.AppIcon == nil then
			self:oldpaint( pw, ph )
		else
			app:AppIcon( pw, ph )
		end
	end
	_tmp.olddoclick = _tmp.DoClick
	function _tmp:DoClick()
		if app.OpenApp == nil then
			self:olddoclick()
		else
			parent:ClearDisplay()
			if app.Fullscreen then
				parent:OpenFullscreen()
			end

			app:OpenApp( parent, 0, ctrb( 40 ), parent:GetWide(), parent:GetTall() - ctrb( 40+40 ) )
		end
	end

  _tmp:Droppable( "APP" )

	return _tmp
end

--[[ Database ]]--
local yrp_apps = {}

local _db_name = "yrp_apps"

function changeAppPosition( cname, nr )
  local _upt = SQL_UPDATE( _db_name, "Position = " .. nr, "ClassName = '" .. cname .. "'" )
end

function getAllDBApps()
  for i, app in pairs( getAllApps() ) do
    local _sel = SQL_SELECT( _db_name, "*", "ClassName = '" .. tostring( app.ClassName ) .. "'" )
    if _sel == nil then
      local _pos = 1
      for i=0, 200 do
        local _p = SQL_SELECT( _db_name, "*", "Position = " .. i )
        if _p == nil then
          _pos = i
          break
        end
      end
      local _ins = SQL_INSERT_INTO( _db_name, "ClassName, Position", "'" .. tostring( app.ClassName ) .. "', " .. _pos )
    end
  end

  local _apps = SQL_SELECT( _db_name, "*", nil )
  local apps = {}

  for i, app in pairs( _apps ) do
    local _app = nil
    for j, a in pairs( getAllApps() ) do
      if a.ClassName == app.ClassName then
        _app = a
        _app.Position = app.Position
        break
      end
    end
    table.insert( apps, app.Position, _app )
  end

  return apps
end

--db_drop_table( _db_name )
function check_yrp_apps()
  SQL_INIT_DATABASE( _db_name )

  SQL_ADD_COLUMN( _db_name, "ClassName", "TEXT DEFAULT 'new'" )
  SQL_ADD_COLUMN( _db_name, "Position", "INT DEFAULT '0'" )

  local _sp = SQL_SELECT( _db_name, "*", nil )
  if _sp != nil and _sp != false then
    yrp_apps = _sp[1]
  end
end
check_yrp_apps()
