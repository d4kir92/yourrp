--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
end

function ENT:Use(activator, caller)
end

--
function ENT:StartTouch(ent)
end
--