--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "client.lua" )

if CLIENT then
  include( "client.lua" )
else
  include( "server.lua" )
end

function DarkRP.addChatCommandsLanguage( languageCode, translations )
  --Description: Add a translation table for chat command descriptions. See darkrpmod/lua/darkrp_language/chatcommands.lua for an example.
  printDRP( "addChatCommandsLanguage( " .. languageCode .. ", table )" )
  printDRP( g_yrp._not )
end

function DarkRP.addHitmanTeam( teamnumber )
  --Description: Make this team a hitman.
  printDRP( "addHitmanTeam( " .. teamnumber .. " )" )
  printDRP( g_yrp._not )
end

function DarkRP.addLanguage( Languagename, Languagecontents )
  --Description: Create a language/translation.
  printDRP( "addLanguage( " .. Languagename .. ", table )" )
  printDRP( g_yrp._not )
end

function DarkRP.addPhrase( Languagename, key, translation )
  --Description: Add a phrase to the existing translation.
  printDRP( "addPhrase( " .. Languagename .. ", " .. key .. ", " .. translation .. " )" )
  printDRP( g_yrp._not )
end

function DarkRP.addPlayerGesture( anim, text )
  --Description: Add a player gesture to the DarkRP animations menu (the one that opens with the keys weapon.). Note: This function must be called BOTH serverside AND clientside!
  printDRP( "addPlayerGesture( " .. anim .. ", " .. text .. " )" )
  printDRP( g_yrp._not )
end

function DarkRP.addToCategory( item, kind, cat )
  --Description: Create a category for the F4 menu.
  printDRP( "addToCategory( table, " .. kind .. ", " .. cat .. " )" )
  printDRP( g_yrp._not )
end

function DarkRP.chatCommandAlias( command, alias )
  --Description: Create an alias for a chat command
  printDRP( "addToCategory( " .. command .. ", alias )" )
  printDRP( g_yrp._not )
end

function DarkRP.createAgenda( title, manager, listeners )
  --Description: Create an agenda for groups of jobs to communicate.
  printDRP( "createAgenda( " .. title .. ", " .. tostring( manager ) .. ", listeners )" )
  printDRP( g_yrp._not )
end

function DarkRP.createAmmoType( name, tbl )
  --Description: Create an ammo type.
  printDRP( "createAmmoType( " .. name .. ", tbl )" )
  printDRP( g_yrp._not )
end

function DarkRP.createCategory( tbl )
  --Description: Create a category for the F4 menu.
  printDRP( "createCategory( tbl )" )
  printDRP( g_yrp._not )
end

function DarkRP.createDemoteGroup( name, tbl )
  --Description: Create a demote group. When you get banned (demoted) from one of the jobs in this group, you will be banned from every job in this group.
  printDRP( "createDemoteGroup( " .. name .. ", tbl )" )
  printDRP( g_yrp._not )
end

function DarkRP.createEntity( name, tbl )
  --Description: Create an entity for DarkRP.
  printDRP( "createEntity( " .. name .. ", tbl )" )
  print(name)
  print(tbl)
  PrintTable( tbl )
end
AddEntity = DarkRP.createEntity

function DarkRP.createEntityGroup( name, teamNrs )
  --Description: Create an entity group for DarkRP.
  printDRP( "createEntityGroup( " .. name .. ", " .. tostring( teamNrs ) .. " )" )
  printDRP( g_yrp._not )
end

function DarkRP.createFood( name, tbl )
  --Description: Create food for DarkRP.
  printDRP( "createFood( " .. name .. ", tbl )" )
  printDRP( g_yrp._not )
end

function DarkRP.createGroupChat( functionOrJob, teamNr )
  --Description: Create a group chat.
  printDRP( "createGroupChat( functionOrJob, " .. tostring( teamNr ) .. " )" )
  printDRP( g_yrp._not )
end

function DarkRP.createJob( name, tbl )
  --Description: Create a job for DarkRP.
  printDRP( "createJob( " .. name .. ", tbl )" )
  printDRP( g_yrp._not )
  return -1
end

function DarkRP.createShipment( name, tbl )
  --Description: Create a vehicle for DarkRP.
  printDRP( "createShipment( " .. name .. ", tbl )" )
  printDRP( g_yrp._not )
end

function DarkRP.createVehicle( name, tbl )
  --Description: Create a shipment for DarkRP.
  printDRP( "createVehicle( " .. name .. ", tbl )" )
  printDRP( g_yrp._not )
end

function DarkRP.declareChatCommand( table )
  --Description: Declare a chat command (describe it)
  printDRP( "declareChatCommand( table )" )
  printDRP( g_yrp._not )
end

function DarkRP.error( message, stack, hints, path, line )
  --Description: Throw a simplerr formatted error. Also halts the stack, which means that statements after calling this function will not execute.
  printDRP( "error( " .. message .. ", " .. tostring( stack ) .. ", hints, " .. path .. ", " .. tostring( line ) .. " )" )
  printDRP( g_yrp._not )

  return false, "this say nothing"
end

function DarkRP.errorNoHalt( message, stack, hints, path, line )
  --Description: Throw a simplerr formatted error. Unlike DarkRP.error, this does not halt the stack. This means that statements after
  --             calling this function will be executed like normal.
  printDRP( "errorNoHalt( " .. message .. ", " .. tostring( stack ) .. ", hints, " .. path .. ", " .. tostring( line ) .. " )" )
  printDRP( g_yrp._not )

  return false, "this say nothing"
end

function DarkRP.explodeArg( arg )
  --Description: String arguments exploded into a table. It accounts for substrings in quotes, which makes it more intelligent than string.Explode
  printDRP( "explodeArg( " .. arg .. " )" )
  printDRP( g_yrp._not )

  return {}
end

function DarkRP.findPlayer( info )
  --Description: Find a single player based on vague information.
  printDRP( "findPlayer( " .. info .. " )" )
  printDRP( g_yrp._not )
  return NULL
end

function DarkRP.findPlayers( info )
  --Description: Find a list of players based on vague information.
  printDRP( "findPlayers( " .. info .. " )" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.formatMoney( amount )
  --Description: Format a number as a money value. Includes currency symbol.
  --printDRP( "formatMoney( " .. tostring( amount ) .. " )" )
  local ply = LocalPlayer()
  return formatMoney( ply, amount )
end

function DarkRP.getAgendas()
  --Description: Get all agendas. Note: teams that share an agenda use the exact
  --             same agenda table. E.g. when you change the agenda of the CP,
  --             the agenda of the Chief will automatically be updated as well.
  --             Make sure this property is maintained when modifying the agenda
  --             table. Not maintaining that property will lead to players not
  --             seeing the right agenda text.
  printDRP( "getAgendas()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getAvailableVehicles()
  --Description: Get the available vehicles that DarkRP supports.
  printDRP( "getAvailableVehicles()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getCategories()
  --Description: Get all categories for all F4 menu tabs.
  printDRP( "getCategories()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getChatCommand( command )
  --Description: Get the information on a chat command.
  printDRP( "getChatCommand( " .. command .. ")" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getChatCommandDescription( command )
  --Description: Get the translated description of a chat command.
  printDRP( "getChatCommandDescription( " .. command .. ")" )
  printDRP( g_yrp._not )
  return "OLD getChatCommandDescription"
end

function DarkRP.getChatCommands()
  --Description: Get every chat command.
  printDRP( "getChatCommands()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getDemoteGroup( teamNr )
  --Description: Get the demote group of a team. Every team in the same group will return the same object.
  printDRP( "getDemoteGroup( " .. tostring( teamNr ) .. " )" )
  printDRP( g_yrp._not )
  --set(Disjoint-Set) the demote group identifier
end

function DarkRP.getDemoteGroups()
  --Description: Get all demote groups Every team in the same group will return the same object.
  printDRP( "getDemoteGroups()" )
  printDRP( g_yrp._not )
  --set(table) Table in which the keys are team numbers and the values Disjoint-Set.
end

function DarkRP.getDoorVars()
  --Description: Internal function, retrieves all the registered door variables.
  printDRP( "getDoorVars()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getDoorVarsByName()
  --Description: Internal function, retrieves all the registered door variables, indeded by their names.
  printDRP( "getDoorVarsByName()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getFoodItems()
  --Description: Get all food items.
  printDRP( "getFoodItems()" )
  printDRP( g_yrp._not )
  --set (table) Table with food items.
end

function DarkRP.getGroupChats()
  --Description: Get all group chats.
  printDRP( "getGroupChats()" )
  printDRP( g_yrp._not )
  --set (table) Table with food items.
end

function DarkRP.getIncompleteChatCommands()
  --Description: chat commands that have been defined, but not declared. Information about these chat commands is missing.
  printDRP( "getIncompleteChatCommands()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getJobByCommand( command )
  --Description: Get the job table and number from the command of the job.
  printDRP( "getJobByCommand( " .. command .. " )" )
  printDRP( g_yrp._not )
  return {}, 0
end

function DarkRP.getLaws()
  --Description: Get the table of all current laws.
  printDRP( "getLaws()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.getMissingPhrases( languageCode )
  --Description: Get all the phrases a language is missing.
  printDRP( "getMissingPhrases( " .. languageCode .. " )" )
  printDRP( g_yrp._not )
  return "Old getMissingPhrases"
end

function DarkRP.getPhrase( key, parameters )
  --Description: Get a phrase from the selected language.
  --printDRP( "getMissingPhrases( " .. key .. ", parameters )" )
  --printDRP( g_yrp._not )
  return "Old getPhrase"
end

function DarkRP.getSortedChatCommands()
  --Description: Get every chat command, sorted by their name.
  printDRP( "getSortedChatCommands()" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.readNetDarkRPVar()
  --Description: Internal function. You probably shouldn't need this. DarkRP
  --             calls this function when reading DarkRPVar net messages.
  --             This function reads the net data for a specific DarkRPVar.
  printDRP( "readNetDarkRPVar()" )
  printDRP( g_yrp._not )
  return "Old readNetDarkRPVar", nil
end

function DarkRP.readNetDarkRPVarRemoval()
  --Description: Internal function. You probably shouldn't need this. DarkRP
  --             calls this function when reading DarkRPVar net messages.
  --             This function the removal of a DarkRPVar.
  printDRP( "readNetDarkRPVar()" )
  local DarkRPVarId = net.ReadUInt(DARKRP_ID_BITS)
  local DarkRPVar = DarkRPVarById[DarkRPVarId]

  if DarkRPVarId == UNKNOWN_DARKRPVAR then
      local name, value = readUnknown()

      return name, value
  end

  local val = DarkRPVar.readFn(value)

  return DarkRPVar.name, val
end

local maxId = 0
local DarkRPVars = {}
local DarkRPVarById = {}
local DARKRP_ID_BITS = 8
local UNKNOWN_DARKRPVAR = 255 -- Should be equal to 2^DARKRP_ID_BITS - 1
DarkRP.DARKRP_ID_BITS = DARKRP_ID_BITS
function DarkRP.registerDarkRPVar( name, writeFn, readFn )
  --Description: Register a DarkRPVar by name. You should definitely register
  --             DarkRPVars. Registering DarkRPVars will make networking much
  --             more efficient.
  printDRP( "registerDarkRPVar( name, writeFn, readFn )" )
  maxId = maxId + 1
  -- UNKNOWN_DARKRPVAR is reserved for unknown values
  if maxId >= UNKNOWN_DARKRPVAR then DarkRP.error(string.format("Too many DarkRPVar registrations! DarkRPVar '%s' triggered this error", name), 2) end

  DarkRPVars[name] = {id = maxId, name = name, writeFn = writeFn, readFn = readFn}
  DarkRPVarById[maxId] = DarkRPVars[name]
end

function DarkRP.registerDoorVar( name, writeFn, readFn )
  --Description: Register a door variable by name. You should definitely
  --             register door variables. Registering DarkRPVars will make
  --             networking much more efficient.
  printDRP( "registerDoorVar( name, writeFn, readFn )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeAgenda( name )
  --Description: Remove a agenda from DarkRP. NOTE: Must be called from BOTH
  --             server AND client to properly get it removed!
  printDRP( "removeAgenda( name )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeAmmoType( i )
  --Description: Remove an ammotype from DarkRP. NOTE: Must be called from BOTH
  --             server AND client to properly get it removed!
  printDRP( "removeAmmoType( i )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeChatCommand( command )
  --Description: Remove a chat command
  printDRP( "removeChatCommand( command )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeDemoteGroup( name )
  --Description: Remove an demotegroup from DarkRP. NOTE: Must be called from
  --             BOTH server AND client to properly get it removed!
  printDRP( "removeDemoteGroup( name )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeEntity( i )
  --Description: Remove an entity from DarkRP. NOTE: Must be called from BOTH
  --             server AND client to properly get it removed!
  printDRP( "removeEntity( i )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeEntityGroup( name )
  --Description: Remove an entitygroup from DarkRP. NOTE: Must be called from
  --             BOTH server AND client to properly get it removed!
  printDRP( "removeEntityGroup( name )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeFoodItem( i )
  --Description: Remove a food item from DarkRP. NOTE: Must be called from BOTH
  --             server AND client to properly get it removed!
  printDRP( "removeFoodItem( i )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeFromCategory( item, kind )
  --Description: "Create a category for the F4 menu." <- Remove not create :D
  printDRP( "removeFromCategory( item, kind )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeGroupChat( i )
  --Description: Remove a groupchat from DarkRP. NOTE: Must be called from BOTH
  --             server AND client to properly get it removed!
  printDRP( "removeGroupChat( i )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeJob( i )
  --Description: Remove a job from DarkRP.
  printDRP( "removeJob( i )" )
  printDRP( g_yrp._not )
end

function DarkRP.removePlayerGesture( anim )
  --Description: Removes a player gesture from the DarkRP animations menu (the
  --             one that opens with the keys weapon.). Note: This function must
  --             be called BOTH serverside AND clientside!
  printDRP( "removePlayerGesture( anim )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeShipment( i )
  --Description: Remove a shipment from DarkRP. NOTE: Must be called from BOTH
  --             server AND client to properly get it removed!
  printDRP( "removeShipment( i )" )
  printDRP( g_yrp._not )
end

function DarkRP.removeVehicle( i )
  --Description: Remove a vehicle from DarkRP. NOTE: Must be called from BOTH
  --             server AND client to properly get it removed!
  printDRP( "removeVehicle( i )" )
  printDRP( g_yrp._not )
end

function DarkRP.simplerrRun( f, args )
  --Description: Run a function with the given parameters and send any runtime
  --             errors to admins.
  printDRP( "simplerrRun( f, args )" )
  printDRP( g_yrp._not )
  return {}
end

function DarkRP.writeNetDarkRPVar( name, value )
  --Description: Internal function. You probably shouldn't need this. DarkRP
  --             calls this function when sending DarkRPVar net messages. This
  --             function writes the net data for a specific DarkRPVar.
  printDRP( "writeNetDarkRPVar( name, value )" )
  printDRP( g_yrp._not )
end

function DarkRP.writeNetDarkRPVarRemoval( name )
  --Description: Internal function. You probably shouldn't need this. DarkRP
  --             calls this function when sending DarkRPVar net messages. This
  --             function sets a DarkRPVar to nil.
  printDRP( "writeNetDarkRPVarRemoval( name )" )
  printDRP( g_yrp._not )
end
