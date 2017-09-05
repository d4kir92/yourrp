--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_rolesmenu.lua
yrp.colors.background = Color( 0, 0, 0, 160 )
yrp.colors.header = Color( 0, 255, 0, 200 )
yrp.colors.font = Color( 255, 255, 255, 255 )

local AllGroups = {}
local tmpGroupsTable = {}

local AllRoles = {}
local tmpRolesTable = {}

local Whitelist = {}

function getRoleInfos( name, uniqueID, desc, sweps, capital, model, modelsize, uses, maxamount, adminonly, whitelist, allowed, voteable )
  local ply = LocalPlayer()

  if roleInfoPanel != nil then
    roleInfoPanel:Remove()
  end
  roleInfoPanel = createVGUI( "DPanel", roleMenuWindow, 2160 - 1600 - 10, 2160-60, 1600 + 10, 60 )
  function roleInfoPanel:Paint( w, h )
    --draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 255, 120 ) )
  end

  local tmpY = 0
  local tmpH = 550
  local tmpBr = 10

  local rolePMPanel = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function rolePMPanel:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.background )
  end

  local rolePM = createVGUI( "DModelPanel", roleInfoPanel, 550, 550, 0, 0 )
  if model != nil and model != "" then
    rolePM:SetModel( model )
    rolePM.Entity:SetModelScale( modelsize, 0 )
  end
  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48+48

  local roleName = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function roleName:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctrW( 48 ), yrp.colors.header )
    draw.SimpleText( lang.role, "roleInfoHeader", ctrW( 10 ), ctrW( 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    draw.RoundedBox( 0, 0, ctrW( 48 ), w, h - ctrW( 48 ), yrp.colors.background )
    draw.SimpleText( name, "roleInfoText", ctrW( 10 ), ctrW( 48 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end

  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48 + 12 + 6*24 + 12

  local roleDescription = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function roleDescription:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctrW( 48 ), yrp.colors.header )
    draw.SimpleText( lang.description, "roleInfoHeader", ctrW( 10 ), ctrW( 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    draw.RoundedBox( 0, 0, ctrW( 48 ), w, h - ctrW( 48 ), yrp.colors.background )
    local descTable = string.Split( desc, " " )
    local tmpTable = {}
    local stringL = 0
    local nextT = 1

    for i = 1, 6 do
      if tmpTable[i] == nil then
        tmpTable[i] = ""
      end
    end

    for k, v in pairs( descTable ) do
      if nextT <= 6 then
        if stringL == 0 then
          stringL = stringL + surface.GetTextSize( v )
        else
          stringL = stringL + surface.GetTextSize( v ) + surface.GetTextSize( " " )
        end
        if stringL < ctrW( 550 - 20 - 20 ) then
          tmpTable[nextT] = tmpTable[nextT] .. " " .. v
        else
          stringL = 0
          nextT = nextT + 1
        end
      end
    end

    draw.SimpleText( tmpTable[1], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[2], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[3], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[4], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[5], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[6], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 + 24 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48 + 12 + 6*24 + 12

  local roleSWEPs = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function roleSWEPs:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctrW( 48 ), yrp.colors.header )
    draw.SimpleText( lang.sweps, "roleInfoHeader", ctrW( 10 ), ctrW( 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    draw.RoundedBox( 0, 0, ctrW( 48 ), w, h - ctrW( 48 ), yrp.colors.background )
    local swepTable = string.Split( sweps, "," )
    local tmpTable = {}
    local stringL = 0
    local nextT = 1

    for i = 1, 6 do
      if tmpTable[i] == nil then
        tmpTable[i] = ""
      end
    end

    for k, v in pairs( swepTable ) do
      if stringL == 0 then
        stringL = stringL + surface.GetTextSize( v )
      else
        stringL = stringL + surface.GetTextSize( v ) + surface.GetTextSize( "," )
      end
      if stringL < ctrW( 550 - 20 - 20 ) then
        if tmpTable[1] == "" then
          tmpTable[nextT] = tmpTable[nextT] .. v
        else
          tmpTable[nextT] = tmpTable[nextT] .. ", " .. v
        end
      else
        stringL = 0
        nextT = nextT + 1
      end
    end

    draw.SimpleText( tmpTable[1], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[2], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[3], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[4], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[5], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( tmpTable[6], "roleInfoText", ctrW( 10 ), ctrW( 48 + 12 + 24 + 24 + 24 + 24 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48+48

  local roleSalary = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function roleSalary:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctrW( 48 ), yrp.colors.header )
    draw.SimpleText( lang.salary, "roleInfoHeader", ctrW( 10 ), ctrW( 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    draw.RoundedBox( 0, 0, ctrW( 48 ), w, h - ctrW( 48 ), yrp.colors.background )
    draw.SimpleText( ply:GetNWString( "moneyPre" ) .. capital .. ply:GetNWString( "moneyPost" ), "roleInfoText", ctrW( 10 ), ctrW( 48 + 24 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end

  tmpY = tmpY + tmpH + 3*tmpBr
  tmpH = 60

  if maxamount == -1 or uses < maxamount then
    local roleGetRole = createVGUI( "DButton", roleInfoPanel, 2160 - 1600 - 10, 120, 0, tmpY )
    if adminonly == 1 and !ply:IsAdmin() and !ply:IsSuperAdmin() then
      roleGetRole:SetText( lang.adminonly )
    elseif ply:IsSuperAdmin() or ply:IsAdmin() or adminonly == 0 then
      if ply:IsSuperAdmin() or ply:IsAdmin() then
        roleGetRole:SetText( lang.getrole .. ": " .. name )
      elseif whitelist == 1 and allowed == 1 or whitelist == 0 then
        roleGetRole:SetText( lang.getrole .. ": " .. name )
      elseif whitelist == 1 and adminonly != 1 and voteable == 1 then
        roleGetRole:SetText( "start Vote" .. ": " .. name )
      elseif whitelist == 1 and adminonly != 1 and voteable == 0 then
        roleGetRole:SetText( lang.needwhitelist )
      else
        print("getrole else2")
      end
    else
      print("getrole else")
    end
    function roleGetRole:DoClick()
      if ply:IsSuperAdmin() or ply:IsAdmin() or adminonly == 0 then
        --if ply:IsSuperAdmin() or ply:IsAdmin() or whitelist == 1 and allowed == 1 or whitelist == 0 then
          net.Start( "wantRole" )
            net.WriteInt( uniqueID, 16 )
          net.SendToServer()
          roleMenuWindow:Close()
        --end
      end
    end
  end
end

function findRoles( id )
  local tmpTable = {}
  for k, v in pairs( AllRoles ) do
    if tonumber( v.groupID ) == tonumber( id ) then
      table.insert( tmpTable, v )
    end
  end
  tmpRolesTable = tmpTable
end

function findChildGroups( id )
  local tmpTable = {}
  for k, v in pairs( AllGroups ) do
    if tonumber( v.uppergroup ) == tonumber( id ) then
      table.insert( tmpTable, v )
    end
  end
  tmpGroupsTable = tmpTable
end

function addRole( name, parent, uppergroup, x, y, color, roleID, desc, sweps, capital, model, modelsize, maxamount, uses, whitelist, adminonly, voteable )
  y = y + 50
  local w = 1600
  local h = 150
  local scrollbar = 32

  local tmpRole = createVGUI( "DPanel", parent, w - x - 1 * h - scrollbar, h, x + h, y )
  function tmpRole:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 160 ) )
    draw.SimpleText( name, "roleInfoText", ctrW( 25 ), ctrW( 25 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if maxamount > 0 then
      local maxbr = 4
      local maxbbr = 10
      local maxcolor = Color( 0, 255, 0, 160 )
      draw.RoundedBox( ctrW( maxbbr ), ctrW( 10 ), ctrW( 100 ), pw - ctrW( maxbbr * 2 ), ph - ctrW( 100 ), Color( 255, 255, 255, 160 ) )
      if uses >= maxamount then
        maxcolor = Color( 255, 0, 0, 255 )
      end
      draw.RoundedBox( ctrW( maxbbr ), ctrW( 10 + maxbr ), ctrW( 100 + maxbr ), ( pw - ctrW( maxbr*2 + maxbbr*2 ) ) / maxamount * uses, ph - ctrW( 100 + maxbr*2 ), maxcolor )

      draw.SimpleText( uses .. "/" .. maxamount, "roleInfoText", pw/2, ctrW( 100 + 25 ), yrp.colors.font, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
  end

  local tmpRoleModelBG = createVGUI( "DPanel", parent, h, h, x, y )
  function tmpRoleModelBG:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
  end

  local tmpRoleModel = createVGUI( "DModelPanel", parent, h, h, x, y )
  local randModel = string.Explode( ",", model )
  local randNumb = math.Round( math.Rand( 1, #randModel ) )
  if randModel[randNumb] != nil and randModel[randNumb] != "" then
    tmpRoleModel:SetModel( randModel[randNumb] )
    tmpRoleModel.Entity:SetModelScale( modelsize, 0 )
    if tmpRoleModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
      local eyepos = tmpRoleModel.Entity:GetBonePosition( tmpRoleModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
      tmpRoleModel:SetLookAt( eyepos )
      tmpRoleModel:SetCamPos( eyepos - Vector( -25 * modelsize, 0, 0 ) )	-- Move cam in front of eyes
    end
  end

  local tmpButtonSelect = createVGUI( "DButton", parent, w-x-scrollbar, h, x, y )
  tmpButtonSelect:SetText( "" )
  function tmpButtonSelect:Paint( pw, ph )
    if tmpButtonSelect:IsHovered() then
      if maxamount > 0 and uses >= maxamount then
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 0, 0, 100 ) )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 100 ) )
      end
    else

    end
    --draw.SimpleText( lang.moreinfo, "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function tmpButtonSelect:DoClick()
    local tmpAllowed = 0
    for k, v in pairs( Whitelist ) do
      if tonumber( roleID ) == tonumber( v.roleID ) then
        tmpAllowed = 1
        break
      end
    end
    getRoleInfos( name, roleID, desc, sweps, capital, randModel[randNumb], modelsize, uses, maxamount, adminonly, whitelist, tmpAllowed, voteable )
  end

  --Init on Start UP First Role
  if tonumber( roleID ) == 1 then
    getRoleInfos( name, roleID, desc, sweps, capital, randModel[randNumb], modelsize, uses, maxamount, adminonly, whitelist, 1, 1 )
  end
  -----------------------------------------

  y = y + h - 50 + 10
  return y
end

function isInWhitelist( id )
  for k, v in pairs( Whitelist ) do
    if tonumber( id ) == tonumber( v.roleID ) then
      return true
    end
  end
  return false
end

function addRoles( uppergroupname, parent, uppergroup, x, y )
  local tmpTable = tmpRolesTable
  if #tmpTable > 0 then
    local newX = x + ctrW( 60 )
    local newY = y
    for k, v in pairs( tmpTable ) do
      if tonumber( v.prerole ) == -1 then
        newY = addRole( v.roleID, parent, v.uniqueID, newX, newY, v.color, v.uniqueID, v.description, v.sweps, v.capital, v.playermodel, tonumber( v.playermodelsize ), tonumber( v.maxamount ), tonumber( v.uses ), tonumber( v.whitelist ), tonumber( v.adminonly ), tonumber( v.voteable ) )
      end
    end
    return newY
  end
  return nil
end

function addGroup( name, parent, uppergroup, x, y, color )
  y = y + ctrW( 100 )

  local expColor = string.Explode( ",", color )
  local gColor = Color( expColor[1], expColor[2], expColor[3], 200 )
  local w = 1600
  local h = 50
  local tmpGroup = createVGUI( "DPanel", parent, w-x, h, x, y )

  local newH = h

  findRoles( uppergroup )
  local result = addRoles( name, parent, uppergroup, x, y )

  if result != nil then
    newH = newH + result - y
    y = result
  end

  findChildGroups( uppergroup )
  local result2 = addGroups( name, parent, uppergroup, x, y )

  if result2 != nil then
    newH = newH + result2 - y
    y = result2
  end

  tmpGroup:SetSize( ctrW( w ), ctrW( newH ) )

  function tmpGroup:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, gColor )
    draw.SimpleText( name, "roleInfoHeader", ctrW( 25 ), ctrW( 25 ), yrp.colors.font, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end

  parent:AddItem( tmpGroup )
  return y + ctrW( 20 )
end

function addGroups( uppergroupname, parent, uppergroup, x, y )
  local tmpTable = tmpGroupsTable
  if #tmpTable > 0 then
    local newX = x + ctrW( 50 )
    local newY = y
    for k, v in pairs( tmpTable ) do
      newY = addGroup( v.groupID, parent, v.uniqueID, newX, newY, v.color )
    end
    return newY
  end
  return y
end

function openRoleMenu()
  cl_rolesMenuOpen = 1

  roleMenuWindow = createVGUI( "DFrame", nil, 2160, 2160, 0, 0 )
  roleMenuWindow:Center()
  roleMenuWindow:ShowCloseButton( true )
  roleMenuWindow:SetDraggable( true )
  roleMenuWindow:SetTitle( lang.rolemenu )
  function roleMenuWindow:OnClose()
    cl_rolesMenuOpen = 0
    _menuIsOpen = 0
  end
  function roleMenuWindow:Paint( w, h )
    --nothing
  end

  local roleDPanelList = createVGUI( "DScrollPanel", roleMenuWindow, 1600, 2100, 0, 60 )
  function roleDPanelList:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, yrp.colors.background )
  end

  net.Start( "getAllGroups" )
  net.SendToServer()

  net.Receive( "getAllGroups", function()
    AllGroups = net.ReadTable()
    AllRoles = net.ReadTable()
    Whitelist = net.ReadTable()

    findChildGroups( -1 )
    addGroups( "No uppergroup", roleDPanelList, -1, -30, -60 )
  end)

  roleMenuWindow:MakePopup()
end
