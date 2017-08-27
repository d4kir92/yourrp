--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_func.lua

function sendRoleWhitelist( ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    local _tmpWhiteList = dbSelect( "yrp_role_whitelist", "*", nil )
    local _tmpRoleList = dbSelect( "yrp_roles", "*", nil )
    local _tmpGroupList = dbSelect( "yrp_groups", "*", nil )
    if _tmpWhiteList != nil and _tmpRoleList != nil and _tmpGroupList != nil then
      net.Start( "getRoleWhitelist" )
        net.WriteTable( _tmpWhiteList )
        net.WriteTable( _tmpRoleList )
        net.WriteTable( _tmpGroupList )
      net.Send( ply )
    else
      _tmpWhiteList = {}
      net.Start( "getRoleWhitelist" )
        net.WriteTable( _tmpWhiteList )
        net.WriteTable( _tmpRoleList )
        net.WriteTable( _tmpGroupList )
      net.Send( ply )
    end
  end
end
