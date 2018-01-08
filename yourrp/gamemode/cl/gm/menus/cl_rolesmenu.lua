--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_rolesmenu.lua

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
  roleInfoPanel = createVGUI( "DPanel", roleMenuWindow, 2160 - 1600 - 10, 2160-60, 1600 + 10 - 4, 60 )
  function roleInfoPanel:Paint( pw, ph )
    --
  end

  local tmpY = 0
  local tmpH = 550
  local tmpBr = 10

  local rolePMPanel = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function rolePMPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )
  end

  local rolePM = createVGUI( "DModelPanel", roleInfoPanel, 550, 550, 0, 0 )
  if model != nil and model != "" then
    rolePM:SetModel( model )
    if rolePM.Entity != nil then
      rolePM.Entity:SetModelScale( modelsize, 0 )
    end
  elseif model == "" then
    rolePM:SetModel( "models/player/skeleton.mdl" )
  end

  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48+48

  local roleName = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function roleName:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctr( 48 ), get_header_col() )
    draw.SimpleTextOutlined( lang_string( "role" ), "roleInfoHeader", ctr( 10 ), ctr( 24 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, 0, ctr( 48 ), w, h - ctr( 48 ), get_dbg_col() )
    draw.SimpleTextOutlined( name, "roleInfoText", ctr( 10 ), ctr( 48 + 24 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48 + 12 + 6*24 + 12

  local roleDescription = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )

  local descTable = string.Split( desc, " " )
  local descTpl = {}
  local stringL = 0
  local nextT = 1

  for i = 1, 6 do
    if descTpl[i] == nil then
      descTpl[i] = ""
    end
  end

  for k, v in pairs( descTable ) do
    local addSize = surface.GetTextSize( v ) + surface.GetTextSize( "," )
    if (stringL + addSize) > ctr( 550 - 20 ) then
      stringL = addSize
      nextT = nextT + 1
    else
      stringL = stringL + addSize
    end
    if nextT <= 6 then
      descTpl[nextT] = descTpl[nextT] .. v .. " "
    else
      break
    end
  end

  function roleDescription:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctr( 48 ), get_header_col() )
    draw.SimpleTextOutlined( lang_string( "description" ), "roleInfoHeader", ctr( 10 ), ctr( 24 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, 0, ctr( 48 ), w, h - ctr( 48 ), get_dbg_col() )

    draw.SimpleTextOutlined( descTpl[1], "roleInfoText", ctr( 10 ), ctr( 50 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( descTpl[2], "roleInfoText", ctr( 10 ), ctr( 75 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( descTpl[3], "roleInfoText", ctr( 10 ), ctr( 100 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( descTpl[4], "roleInfoText", ctr( 10 ), ctr( 125 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( descTpl[5], "roleInfoText", ctr( 10 ), ctr( 150 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( descTpl[6], "roleInfoText", ctr( 10 ), ctr( 175 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48 + 12 + 6*24 + 12

  local roleSWEPs = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )

  local swepTable = string.Split( sweps, "," )
  local swepList = {}
  local stringL = 0
  local nextT = 1

  for i = 1, 6 do
    if swepList[i] == nil then
      swepList[i] = ""
    end
  end

  for k, v in pairs( swepTable ) do
    local addSize = surface.GetTextSize( v ) + surface.GetTextSize( "," )
    if (stringL + addSize) > ctr( 550 - 20 ) then
      stringL = addSize
      nextT = nextT + 1
    else
      stringL = stringL + addSize
    end
    if nextT <= 6 then
      if swepList[1] == "" then
        swepList[nextT] = swepList[nextT] .. v
      else
        swepList[nextT] = swepList[nextT] .. ", " .. v
      end
    else
      break
    end
  end

  function roleSWEPs:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctr( 48 ), get_header_col() )
    draw.SimpleTextOutlined( lang_string( "sweps" ), "roleInfoHeader", ctr( 10 ), ctr( 24 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, 0, ctr( 48 ), w, h - ctr( 48 ), get_dbg_col() )

    draw.SimpleTextOutlined( swepList[1], "roleInfoText", ctr( 10 ), ctr( 50 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( swepList[2], "roleInfoText", ctr( 10 ), ctr( 75 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( swepList[3], "roleInfoText", ctr( 10 ), ctr( 100 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( swepList[4], "roleInfoText", ctr( 10 ), ctr( 125 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( swepList[5], "roleInfoText", ctr( 10 ), ctr( 150 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( swepList[6], "roleInfoText", ctr( 10 ), ctr( 175 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  tmpY = tmpY + tmpH + tmpBr
  tmpH = 48+48

  local roleSalary = createVGUI( "DPanel", roleInfoPanel, 2160 - 1600 - 10, tmpH, 0, tmpY )
  function roleSalary:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, ctr( 48 ), get_header_col() )
    draw.SimpleTextOutlined( lang_string( "salary" ), "roleInfoHeader", ctr( 10 ), ctr( 24 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.RoundedBox( 0, 0, ctr( 48 ), w, h - ctr( 48 ), get_dbg_col() )
    draw.SimpleTextOutlined( ply:GetNWString( "moneyPre" ) .. capital .. ply:GetNWString( "moneyPost" ), "roleInfoText", ctr( 10 ), ctr( 48 + 24 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  tmpY = tmpY + tmpH + 3*tmpBr
  tmpH = 60

  if maxamount <= 0 or uses < maxamount then
    local roleGetRole = createVGUI( "DButton", roleInfoPanel, 2160 - 1600 - 10, 120, 0, tmpY )
    roleGetRole:SetText( "" )
    roleGetRole.text = ""
    if adminonly == 1 and !ply:IsAdmin() and !ply:IsSuperAdmin() then
      roleGetRole.text = lang_string( "adminonly" )
    elseif ply:IsSuperAdmin() or ply:IsAdmin() or adminonly == 0 then
      if ply:IsSuperAdmin() or ply:IsAdmin() then
        roleGetRole.text = lang_string( "getrole" ) .. ": " .. name
      elseif whitelist == 1 and allowed == 1 or whitelist == 0 then
        roleGetRole.text = lang_string( "getrole" ) .. ": " .. name
      elseif whitelist == 1 and adminonly != 1 and voteable == 1 then
        roleGetRole.text = "start Vote" .. ": " .. name
      elseif whitelist == 1 and adminonly != 1 and voteable == 0 then
        roleGetRole.text = lang_string( "needwhitelist" )
      else
        --print("getrole else2")
      end
    else
      --print("getrole else")
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
    function roleGetRole:Paint( pw, ph )
      paintButton( self, pw, ph, self.text )
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
    draw.SimpleTextOutlined( name, "roleInfoText", ctr( 25 ), ctr( 25 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    if maxamount != nil then
      if maxamount > 0 then
        local maxbr = 4
        local maxbbr = 10
        local maxcolor = Color( 0, 255, 0, 160 )
        draw.RoundedBox( ctr( maxbbr ), ctr( 10 ), ctr( 100 ), pw - ctr( maxbbr * 2 ), ph - ctr( 100 ), Color( 255, 255, 255, 160 ) )
        if uses >= maxamount then
          maxcolor = Color( 255, 0, 0, 255 )
        end
        draw.RoundedBox( ctr( maxbbr ), ctr( 10 + maxbr ), ctr( 100 + maxbr ), ( pw - ctr( maxbr*2 + maxbbr*2 ) ) / maxamount * uses, ph - ctr( 100 + maxbr*2 ), maxcolor )

        draw.SimpleTextOutlined( uses .. "/" .. maxamount, "roleInfoText", pw/2, ctr( 100 + 25 ), get_font_col(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      end
    end
  end

  local tmpRoleModelBG = createVGUI( "DPanel", parent, h, h, x, y )
  function tmpRoleModelBG:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
  end

  local tmpRoleModel = createVGUI( "DModelPanel", parent, h, h, x, y )
  local randModel = ""
  local randNumb = 1
  if model != nil then
    randModel = string.Explode( ",", model )
    randNumb = math.Round( math.Rand( 1, #randModel ) )
    if randModel[randNumb] != nil and randModel[randNumb] != "" then
      tmpRoleModel:SetModel( randModel[randNumb] )
    elseif randModel[randNumb] == "" then
      tmpRoleModel:SetModel( "models/player/skeleton.mdl" )
    end
    if tmpRoleModel.Entity != nil then
      tmpRoleModel.Entity:SetModelScale( modelsize, 0 )
      if tmpRoleModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
        local eyepos = tmpRoleModel.Entity:GetBonePosition( tmpRoleModel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
        tmpRoleModel:SetLookAt( eyepos )
        tmpRoleModel:SetCamPos( eyepos - Vector( -25 * modelsize, 0, 0 ) )	-- Move cam in front of eyes
      end
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
    --draw.SimpleTextOutlined( lang_string( "moreinfo" ), "roleInfoHeader", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
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
    local newX = x + ctr( 60 )
    local newY = y
    for k, v in pairs( tmpTable ) do
      if tonumber( v.prerole ) == -1 or isInWhitelist( v.uniqueID ) then
        newY = addRole( tostring( v.roleID ), parent, v.uniqueID, newX, newY, v.color, v.uniqueID, v.description, v.sweps, tonumber( v.capital ), v.playermodels, tonumber( v.playermodelsize ), tonumber( v.maxamount ), tonumber( v.uses ), tonumber( v.whitelist ), tonumber( v.adminonly ), tonumber( v.voteable ) )
      end
    end
    return newY
  end
  return nil
end

function addGroup( name, parent, uppergroup, x, y, color )
  y = y + ctr( 100 )

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

  tmpGroup:SetSize( ctr( w ), ctr( newH ) )

  function tmpGroup:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, gColor )
    draw.SimpleTextOutlined( name, "roleInfoHeader", ctr( 25 ), ctr( 25 ), get_font_col(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  if parent != nil and parent != NULL and parent != "NULL" and ispanel( parent ) and parent.AddItem != nil then
    parent:AddItem( tmpGroup )
  end
  return y + 20
end

function addGroups( uppergroupname, parent, uppergroup, x, y )
  local tmpTable = tmpGroupsTable
  if #tmpTable > 0 then
    local newX = x + ctr( 50 )
    local newY = y
    for k, v in pairs( tmpTable ) do
      newY = addGroup( v.groupID, parent, v.uniqueID, newX, newY, v.color )
    end
    return newY
  end
  return y
end

function toggleRoleMenu()
  if isNoMenuOpen() then
    openRoleMenu()
  else
    closeRoleMenu()
  end
end

function closeRoleMenu()
  if roleMenuWindow != nil then
    closeMenu()
    roleMenuWindow:Remove()
    roleMenuWindow = nil
  end
end

function openRoleMenu()
  openMenu()

  roleMenuWindow = createVGUI( "DFrame", nil, 2160, 2160, 0, 0 )
  roleMenuWindow:Center()
  roleMenuWindow:ShowCloseButton( true )
  roleMenuWindow:SetDraggable( true )
  roleMenuWindow:SetTitle( lang_string( "rolemenu" ) )
  function roleMenuWindow:Paint( pw, ph )
    paintWindow( self, pw, ph, "" )
  end
  function roleMenuWindow:OnClose()
    closeMenu()
  end
  function roleMenuWindow:OnRemove()
    closeMenu()
  end

  local roleDPanelList = createVGUI( "DScrollPanel", roleMenuWindow, 1600, 2100-4, 4, 60 )
  function roleDPanelList:Paint( w, h )
    draw.RoundedBox( 0, 0, 0, w, h, get_dbg_col() )
  end

  net.Start( "getAllGroups" )
  net.SendToServer()

  net.Receive( "getAllGroups", function()
    AllGroups = net.ReadTable() or {}
    AllRoles = net.ReadTable() or {}
    Whitelist = net.ReadTable() or {}

    findChildGroups( -1 )
    addGroups( "No uppergroup", roleDPanelList, -1, -30, -60 )
  end)

  roleMenuWindow:MakePopup()
end
