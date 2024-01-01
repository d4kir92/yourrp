--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile()
DEFINE_BASECLASS("base_anim")
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Splint"
ENT.Author = "D4KiR"
ENT.Contact = "-"
ENT.Purpose = ""
ENT.Information = ""
ENT.Instructions = ""
ENT.Category = "[YourRP] Ammunation"
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
game.AddAmmoType(
	{
		name = "splint",
		dmgtype = DMG_BULLET,
		tracer = TRACER_LINE,
		plydmg = 0,
		npcdmg = 0,
		force = 2000,
		minsplash = 10,
		maxsplash = 5
	}
)