--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_shops"

sql_add_column( _db_name, "name", "TEXT DEFAULT 'UNNAMED'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "get_shops" )

function send_shops( ply )
  local _all = db_select( _db_name, "*", nil )
  local _nm = _all
  if _nm == nil or _nm == false then
    _nm = {}
  end
  net.Start( "get_shops" )
    net.WriteTable( _nm )
  net.Send( ply )
end

net.Receive( "get_shops", function( len, ply )
  send_shops( ply )
end)

util.AddNetworkString( "shop_add" )

net.Receive( "shop_add", function( len, ply )
  local _new = db_insert_into( _db_name, "name", "'new shop'" )
  printGM( "db", "shop_add: " .. db_worked( _new ) )

  send_shops( ply )
end)

util.AddNetworkString( "shop_rem" )

net.Receive( "shop_rem", function( len, ply )
  local _uid = net.ReadString()
  local _new = db_delete_from( _db_name, "uniqueID = " .. _uid )
  printGM( "db", "shop_rem: " .. tostring( _uid ) )

  send_shops( ply )
end)

util.AddNetworkString( "shop_edit_name" )

net.Receive( "shop_edit_name", function( len, ply )
  local _uid = net.ReadString()
  local _new_name = net.ReadString()
  local _new = db_update( _db_name, "name = '" .. db_in_str( _new_name ) .. "'", "uniqueID = " .. _uid )
  printGM( "db", "shop_edit_name: " .. tostring( _uid ) )
end)

util.AddNetworkString( "shop_get_tabs" )

function openBuyMenu( ply, uid )
  printGM( "note", "openBuyMenu | ply: " .. tostring( ply:RPName() ) .. " | uid: " .. tostring( uid ) )
  local _dealer = db_select( "yrp_dealers", "*", "uniqueID = '" .. uid .. "'" )

  if _dealer != nil then
    _dealer = _dealer[1]
    local _tabs = string.Explode( ",", _dealer.tabs )
    local _nw_tabs = {}
    if _tabs[1] != "" then
      for i, tab in pairs( _tabs ) do
        local _tab = db_select( "yrp_shops", "*", "uniqueID = " .. tab )
        if _tab != false and _tab != nil then
          _tab = _tab[1]
          table.insert( _nw_tabs, _tab )
        end
      end
    end

    net.Start( "shop_get_tabs" )
      net.WriteString( uid )
      net.WriteTable( _nw_tabs )
    net.Send( ply )
  end
end

net.Receive( "shop_get_tabs", function( len, ply )
  local _uid = net.ReadString()
  openBuyMenu( ply, _uid )
end)

util.AddNetworkString( "shop_get_all_tabs" )

net.Receive( "shop_get_all_tabs", function( len, ply )
  local _tabs = db_select( _db_name, "name, uniqueID", nil )
  local _nw = {}
  if _tabs != nil then
    _nw = _tabs
  end
  net.Start( "shop_get_all_tabs" )
    net.WriteTable( _nw )
  net.Send( ply )
end)
