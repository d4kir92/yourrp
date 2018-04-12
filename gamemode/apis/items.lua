--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--[[ GLOBAL ]]--
ITEM_MAXH = 2
INV_MAXW = 8

--[[ SHARED ]]--

function PrintStorage( tab )
  printGM( "db", tostring( tab ) )
  for y=1, #tab do
    local _row = ""
    for x=1, INV_MAXW do
      local _item = tab[y][x].value
      if tostring( _item ) == "" then
        _item = "[EMPTY]"
      end
      _row = _row .. tostring( _item ) .. "\t"
    end
    printGM( "db", _row )
  end
  printGM( "db", "________________________________")
end

function distance( num1, num2 )
  return math.abs( num1 ) + math.abs( num2 )
end

function AddItemToTable( tab, item )
  local x = item.posx
  local y = item.posy
  local w = item.sizew
  local h = item.sizeh
  for _y = y, y+h-1 do
    for _x = x, x+w-1 do
      tab[_y][_x].value = item.uniqueID
    end
  end
  return tab
end

function AddTableAxis( tab, axis, value )
  local _tmp = {}
  _tmp.axis = axis
  _tmp.value = value
  table.insert( tab, _tmp )
end

function GetEntityItemSize( ent )
  local _maxs = ent:OBBMaxs()
  local _mins = ent:OBBMins()
  local _axis = {}
  AddTableAxis( _axis, "x", distance( _mins.x, _maxs.x ) )
  AddTableAxis( _axis, "y", distance( _mins.y, _maxs.y ) )
  AddTableAxis( _axis, "z", distance( _mins.z, _maxs.z ) )
  table.SortByMember( _axis, "value" )

  local _result = {}
  local _scale = 6
  _result.sizew = _axis[1].value/_scale - _axis[1].value/_scale%1
  _result.sizeh = _axis[2].value/_scale - _axis[2].value/_scale%1
  if _result.sizew < 1 then
    _result.sizew = 1
  end
  if _result.sizeh < 1 then
    _result.sizeh = 1
  end
  if _result.sizew > INV_MAXW then
    _result.sizew = INV_MAXW
  end
  if _result.sizeh > 2 then
    _result.sizeh = 2
  end
  return _result
end

function GetSurroundingEntities( ply )
  local _ents = ents.FindInSphere( ply:GetPos(), 60 )
  local _tab = {}
  for i, ent in pairs( _ents ) do
    if ent:GetOwner() == NULL and ent:IsWeapon() then
      table.insert( _tab, ent )
    end
  end
  return _tab
end

function FormatEntityToItem( ent )
  local _item = {}
  _item.ClassName = ent:GetClass()
  _item.PrintName = ent:GetPrintName()
  _item.WorldModel = ent:GetModel()
  _item.storageID = 0
  _item.entity = ent
  local _size = GetEntityItemSize( ent )
  _item.sizew = _size.sizew
  _item.sizeh = _size.sizeh
  _item.posx = 0
  _item.posy = 0
  _item.uniqueID = ent:EntIndex()
  return _item
end

function GetSurroundingItems( ply )
  local _ents = GetSurroundingEntities( ply )
  local _items = {}
  for i, ent in pairs( _ents ) do
    table.insert( _items, FormatEntityToItem( ent ) )
  end
  return _items
end

function IsEnoughSpace( stor, w, h, x, y, uid )
  for _y = y, y+h-1 do
    for _x = x, x+w-1 do
      if stor[_y][_x] != nil then
        if stor[_y][_x].value != "" and stor[_y][_x].value != tostring( uid ) then
          return false
        end
      else
        return false
      end
    end
  end
  return true
end

function FindPlace( stor, w, h )
  for y = 1, #stor do
    for x = 1, #stor[y] do
      if stor[y][x].value == "" then
        if IsEnoughSpace( stor, w, h, x, y, "" ) then
          return true, x, y
        end
      end
    end
  end
  return false
end

function AddToStorage( stor, item )
  local _w = item.sizew
  local _h = item.sizeh

  for y = 1, #stor do
    for x = 1, #stor[y] do
      if stor[y][x].value == "" then
        if IsEnoughSpace( stor, _w, _h, x, y, "" ) then
          item.posx = x
          item.posy = y
          --[[ Add to stor ]]--
          for _y = y, y+_h-1 do
            for _x = x, x+_w-1 do
              stor[_y][_x].value = item.uniqueID
            end
          end
          return stor
        end
      end
    end
  end
  return stor
end

function GetSurroundingStorageSize( tab )
  local _size = {}
  _size.sizew = INV_MAXW
  _size.sizeh = 1

  local _arr = {}
  for y=1, #tab*ITEM_MAXH do
    _arr[y] = {}
    for x=1, INV_MAXW do
      _arr[y][x] = {}
      _arr[y][x].value = ""
    end
  end

  for i, item in pairs( tab ) do
    _arr = AddToStorage( _arr, item )
  end

  local _h = 1
  for y = 1, #_arr do
    for x = 1, INV_MAXW do
      if _arr[y][x].value != "" then
        _size.sizeh = y
      end
    end
  end
  return _size
end

function GetSurroundingStorage( ply )
  local _sur = {}
  _sur.ClassName = "WORLD"
  _sur.ParentID = ply:SteamID()
  _sur.name = "NearbyItems"
  _sur.posx = ply:GetPos().x
  _sur.posy = ply:GetPos().y
  _sur.posz = ply:GetPos().z
  _sur.uniqueID = 0
  _sur.map = game.GetMap()

  local _items = GetSurroundingItems( ply )
  local _size = GetSurroundingStorageSize( _items )
  _sur.sizew = _size.sizew
  _sur.sizeh = _size.sizeh + 2
  return _sur
end

--[[ CLIENT ]]--
if CLIENT then

  local item_handler = {}

  function getItemHandler()
    return item_handler
  end

  function AddStorage( pnl, uid, w, h )
    item_handler[tonumber(uid)] = {}
    item_handler[tonumber(uid)].pnl = pnl
    for y = 1, h do
      item_handler[tonumber(uid)][y] = {}
      for x = 1, w do
        item_handler[tonumber(uid)][y][x] = {}
        item_handler[tonumber(uid)][y][x].slot = createD( "DPanel", item_handler[tonumber(uid)].pnl, ctr( 128 ), ctr( 128 ), ctr( (x-1)*128 ), ctr( (y-1)*128 ) )
        local _edit_slot = item_handler[tonumber(uid)][y][x].slot
        item_handler[tonumber(uid)][y][x].value = ""
        _edit_slot.storageID = uid
        _edit_slot.posy = y
        _edit_slot.posx = x
        _edit_slot:Receiver( "slot", function( receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY )
          if isDropped then
            local _item = tableOfDroppedPanels[1].item
            local _slot1 = {}
            _slot1.storageID = _item.storageID
            _slot1.posy = _item.posy
            _slot1.posx = _item.posx
            local _slot2 = {}
            _slot2.storageID = receiver.storageID
            _slot2.posy = receiver.posy
            _slot2.posx = receiver.posx
            net.Start( "moveitem" )
              net.WriteTable( _slot1 )
              net.WriteTable( _slot2 )
              net.WriteTable( _item )
            net.SendToServer()
          end
        end, {} )
        function _edit_slot:Paint( pw, ph )
          self.color = Color( 0, 0, 0, 0 )
          if self:IsHovered() then
            self.color = Color( 255, 255, 255, 200 )
          end
          surfaceBox( 0, 0, pw, ph, self.color )
          drawRBBR( 0, 0, 0, pw, ph, Color( 0, 0, 0 ), ctr( 4 ) )
        end
      end
    end
  end

  function ResetStorages()
    item_handler = {}
  end

  function AddItemToStorage( tab )
    local _storage = item_handler[tonumber(tab.storageID)].pnl
    local _parent = item_handler[tonumber(tab.storageID)].pnl:GetParent()
    local _x, _y = item_handler[tonumber(tab.storageID)].pnl:GetPos()
    local _item = createD( "SpawnIcon", _parent, ctr( 128*tab.sizew ), ctr( 128*tab.sizeh ), _x + ctr( (tab.posx-1)*128 ), _y + ctr( (tab.posy-1)*128 ) )
    item_handler[tonumber(tab.storageID)][tonumber(tab.posy)][tonumber(tab.posx)].item = _item
    item_handler[tonumber(tab.storageID)][tonumber(tab.posy)][tonumber(tab.posx)].value = tonumber( tab.uniqueID )
    local _i = item_handler[tonumber(tab.storageID)][tonumber(tab.posy)][tonumber(tab.posx)].item
    _i.item = tab
    _i:SetModel( tab.WorldModel )
    _i:Droppable( "slot" )
    function _i:Paint( pw, ph )
      surfaceBox( 0, 0, pw, ph, Color( 0, 0, 0, 240 ) )
    end
    _i:SetToolTip( _i.item.PrintName )
    function _i:PaintOver( pw, ph )
      local _br = 2
      surfaceBox( 0, 0, pw, ctr( _br ), Color( 0, 0, 255, 255 ) )
      surfaceBox( 0, ph-ctr( _br ), pw, ctr( _br ), Color( 0, 0, 255, 255 ) )

      surfaceBox( 0, ctr( _br ), ctr( _br ), ph - ctr( _br*2 ), Color( 0, 0, 255, 255 ) )
      surfaceBox( pw-ctr( _br ), ctr( _br ), ctr( _br ), ph - ctr( _br*2 ), Color( 0, 0, 255, 255 ) )
    end
    return _item
  end

  net.Receive( "additemtostorage", function( len )
    local _item = net.ReadTable()
    AddItemToStorage( _item )
  end)

  net.Receive( "moveitem_slot1", function( len )
    local _slot1 = net.ReadTable()

    --[[ ITEM ]]--
    if item_handler[tonumber(_slot1.storageID)][tonumber(_slot1.posy)][tonumber(_slot1.posx)].item != nil then
      item_handler[tonumber(_slot1.storageID)][tonumber(_slot1.posy)][tonumber(_slot1.posx)].item:Remove()
      item_handler[tonumber(_slot1.storageID)][tonumber(_slot1.posy)][tonumber(_slot1.posx)].item = nil
      item_handler[tonumber(_slot1.storageID)][tonumber(_slot1.posy)][tonumber(_slot1.posx)].value = ""
    end
  end)

  net.Receive( "moveitem_slot2", function( len )
    local _s2 = net.ReadTable()
    local _i = net.ReadTable()

    _i.storageID = tonumber( _s2.storageID )
    _i.posy = tonumber( _s2.posy )
    _i.posx = tonumber( _s2.posx )

    _i.ClassName = tostring( _i.ClassName )
    _i.PrintName = tostring( _i.PrintName )
    _i.WorldModel = tostring( _i.WorldModel )
    _i.sizeh = tonumber( _i.sizeh )
    _i.sizew = tonumber( _i.sizew )
    _i.uniqueID = tonumber( _i.uniqueID )

    --[[ Target ]]--
    local _item = AddItemToStorage( _i )
  end)
end

--[[ SERVER ]]--
if SERVER then

end
