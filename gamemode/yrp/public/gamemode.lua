--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--[[ Here are the public functions (FOR DEVELOPERS) ]]

--[[ Gamemode functions ]]--
if SERVER then
  function GM:IsAutomaticServerReloadingEnabled()
    return YRPIsAutomaticServerReloadingEnabled()
  end


  function GM:IsNoclipEffectEnabled()
    return IsNoClipEffectEnabled()
  end

  function GM:IsNoclipStealthEnabled()
    return IsNoClipStealthEnabled()
  end

  function GM:IsNoclipUsergroupEnabled()
    return IsNoClipTagsEnabled()
  end

  function GM:IsNoclipModelEnabled()
    return IsNoClipModelEnabled()
  end


end
