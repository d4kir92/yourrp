--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

--[[ ITEM ]]
sql_add_column( "yrp_item", "ClassName", "TEXT DEFAULT '[EMPTY]'" )
sql_add_column( "yrp_item", "PrintName", "TEXT DEFAULT ''" )
sql_add_column( "yrp_item", "amount", "TEXT DEFAULT '1'" )
sql_add_column( "yrp_item", "origin", "TEXT DEFAULT 'inv'" )

--[[ MODEL ]] --
sql_add_column( "yrp_item", "Model", "TEXT DEFAULT ''" )
sql_add_column( "yrp_item", "aw", "TEXT DEFAULT 'x'" )
sql_add_column( "yrp_item", "ah", "TEXT DEFAULT 'y'" )
sql_add_column( "yrp_item", "w", "INT DEFAULT 0" )
sql_add_column( "yrp_item", "h", "INT DEFAULT 0" )
sql_add_column( "yrp_item", "center", "TEXT DEFAULT '0,0,0'" )

--db_drop_table( "yrp_item" )
--db_is_empty( "yrp_item" )

function get_item_size( item )
  local _item = {}
  _item.mins = item:OBBMins()
  _item.maxs = item:OBBMaxs()

  local _values = {}
  _values.x = math.Round( math.abs( _item.mins.x - _item.maxs.x )/8, 0 )
  _values.y = math.Round( math.abs( _item.mins.y - _item.maxs.y )/8, 0 )
  _values.z = math.Round( math.abs( _item.mins.z - _item.maxs.z )/8, 0 )

  local _sort = {}
  for axis, value in SortedPairsByValue( _values, true ) do
    local _tbl = {}
    _tbl.axis = axis
    _tbl.value = value
    table.insert( _sort, _tbl )
  end
  --PrintTable( _sort )

  local _center = item:OBBCenter()

  _item.aw = _sort[1].axis
  _item.w = _sort[1].value
  _item.ah = _sort[2].axis
  _item.h = _sort[2].value

  if _item.w < 1 then
    _item.w = 1
  elseif _item.w > 8 then
    _item.w = 8
  end
  if _item.h < 1 then
    _item.h = 1
  elseif _item.h > 2 then
    _item.h = 2
  end
  _item.center = math.Round( _center.x, 2 ) .. "," .. math.Round( _center.y, 2 ) .. "," .. math.Round( _center.z, 2 )
  return _item
end

function get_item( id )
  local _result = db_select( "yrp_item", "*", "uniqueID = " .. id )
  if _result != nil then
    return _result[1]
  else
    printGM( "error", "item with id " .. id .. " not exists" )
  end
end

function create_item( cname, origin )
  --print("create_item " .. cname )
  local _item = {}

  local _ent = ents.Create( cname )
  _ent:Spawn()
  _item = get_item_size( _ent )
  _item.Model = tostring( _ent:GetModel() )
  _item.PrintName = _ent:GetPrintName()
  _item.ClassName = _ent:GetClass()
  _item.origin = origin or "inv"
  _ent:Remove()

  local _cols = "ClassName, PrintName, Model, aw, ah, w, h, center, origin"
  if amount != nil then
    _cols = _cols .. ", amount"
  end
  local _vals = "'" .. _item.ClassName .. "', '" .. _item.PrintName .. "', '" .. _item.Model .. "', '" .. _item.aw .. "', '" .. _item.ah .. "', " .. _item.w .. ", " .. _item.h .. ", '" .. _item.center .. "', '" .. _item.origin .. "'"
  if amount != nil then
    _vals = _vals .. ", '" .. amount .. "'"
  end
  local _result = db_insert_into( "yrp_item", _cols, _vals )

  if _result == nil then
    local _sel = db_select( "yrp_item", "*", nil )
    if _sel != nil then
      return _sel[#_sel]
    else
      printGM( "error", "create_item FAILED" )
      return false
    end
  else
    printGM( "error", "Item insertion FAILED" )
    return false
  end
end
