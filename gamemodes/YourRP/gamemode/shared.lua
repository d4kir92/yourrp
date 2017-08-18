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

//##############################################################################
//Convars
concommand.Add( "yrp__help", function( ply, cmd, args )

end )
//##############################################################################

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
