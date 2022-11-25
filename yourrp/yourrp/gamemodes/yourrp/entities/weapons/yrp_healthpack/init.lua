--This makes sure clients download the file
AddCSLuaFile ( "shared.lua" )
AddCSLuaFile ( "cl_init.lua" )

include( "shared.lua" )

--How heavy the SWEP is
SWEP.Weight = 5

--Allow automatic switching to/from this weapon when weapons are picked up
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
