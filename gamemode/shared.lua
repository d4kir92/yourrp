--[[
Copyright (C) 2017-2018 Arno Zura

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
]]--

_yrp = {}

function add_luas( string )
  AddCSLuaFile( string )
  include( string )
end

add_luas( "yrp/apis/api_includes.lua" )

add_luas( "yrp/shared/sh_includes.lua" )

add_luas( "yrp/integration/integration.lua" )

add_luas( "yrp/public/public.lua" )
