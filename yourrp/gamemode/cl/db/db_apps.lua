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

local yrp_apps = {}

function addApp( derma )
  table.insert( yrp_apps, derma )
end

function getAllApps()
  return yrp_apps
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
  local _upt = db_update( _db_name, "Position = " .. nr, "ClassName = '" .. cname .. "'" )
end

function getAllDBApps()
  for i, app in pairs( getAllApps() ) do
    local _sel = db_select( _db_name, "*", "ClassName = '" .. tostring( app.ClassName ) .. "'" )
    if _sel == nil then
      local _pos = 1
      for i=0, 200 do
        local _p = db_select( _db_name, "*", "Position = " .. i )
        if _p == nil then
          _pos = i
          break
        end
      end
      local _ins = db_insert_into( _db_name, "ClassName, Position", "'" .. tostring( app.ClassName ) .. "', " .. _pos )
    end
  end

  local _apps = db_select( _db_name, "*", nil )
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
  init_database( _db_name )

  sql_add_column( _db_name, "ClassName", "TEXT DEFAULT 'new'" )
  sql_add_column( _db_name, "Position", "INT DEFAULT '0'" )

  local _sp = db_select( _db_name, "*", nil )
  if _sp != nil then
    yrp_apps = _sp[1]
  end
end
check_yrp_apps()
