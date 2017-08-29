/*
Copyright (C) 2017 Arno Zura

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see < http://www.gnu.org/licenses/ >.
*/

//shared.lua

/*
content ->
           data -- Put data files in here
           materials -- Put all your materials here.
           models -- Put all your models here.
           resource  -- Don't need to touch this.
           scripts -- Don't need to touch this.
           settings -- Server settings are in here.

entities ->
            effects -- All effects you made go here.
            entities -- All SENTs go here.
            weapons -- All SWEPs go here.

gamemode ->
            shared.lua
            cl_init.lua
            init.lua
*/

AddCSLuaFile( "database/db_lang.lua" )
include( "database/db_lang.lua" )

//include("database/db_lang.lua")

function GM:Initialize()
	self.BaseClass.Initialize(self)
	//initLang()
end

team.SetUp( 1, "Players", Color( 40, 40, 40 ), false )

function util.QuickTrace( origin, dir, filter )
	local trace = {}

	trace.start = origin
	trace.endpos = origin + dir
	trace.filter = filter

	return util.TraceLine( trace )
end

//GetGameDescription returns the name for the Server Browser
function GM:GetGameDescription()
	return GAMEMODE.Name
end
