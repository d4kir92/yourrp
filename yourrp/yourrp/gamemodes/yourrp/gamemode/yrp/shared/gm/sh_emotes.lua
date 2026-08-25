--Copyright (C) 2017-2026 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _emotes = {}
local _emotes_lookup = {}
function GetEmotes()
	return _emotes
end

function AddEmote(name, cmd)
	local _new = {}
	_new.name = name
	_new.cmd = cmd
	table.insert(_emotes, _new)
	if cmd ~= nil then _emotes_lookup[tostring(cmd)] = true end
end

function YRPIsValidEmote(cmd)
	if cmd == nil then return false end
	return _emotes_lookup[tostring(cmd)] or false
end

AddEmote("LID_emotedancenormal", ACT_GMOD_TAUNT_DANCE) --"dance"
AddEmote("LID_emotedancesexy", ACT_GMOD_TAUNT_MUSCLE) --"muscle"
AddEmote("LID_emotedancerobot", ACT_GMOD_TAUNT_ROBOT) --"robot"
AddEmote("LID_emoteimitiationzombie", ACT_GMOD_GESTURE_TAUNT_ZOMBIE) --"zombie"
AddEmote("LID_emotewave", ACT_GMOD_GESTURE_WAVE) --"wave"
AddEmote("LID_emotesalute", ACT_GMOD_TAUNT_SALUTE) --"salute"
AddEmote("LID_emotebow", ACT_GMOD_GESTURE_BOW) --"bow"
AddEmote("LID_emotebecon", ACT_GMOD_GESTURE_BECON) --"becon"
AddEmote("LID_emotelaugh", ACT_GMOD_TAUNT_LAUGH) --"laugh"
AddEmote("LID_emotepers", ACT_GMOD_TAUNT_PERSISTENCE) --"pers"
AddEmote("LID_emotecheer", ACT_GMOD_TAUNT_CHEER) --"cheer"
AddEmote("LID_emoteagree", ACT_GMOD_GESTURE_AGREE) --"agree"
AddEmote("LID_emotedisagree", ACT_GMOD_GESTURE_DISAGREE) --"disagree"
AddEmote("LID_emotehalt", ACT_SIGNAL_HALT) --"halt"
AddEmote("LID_emotegroup", ACT_SIGNAL_GROUP) --"group"
AddEmote("LID_emoteforward", ACT_SIGNAL_FORWARD) --"forward"
AddEmote("LID_give", ACT_GMOD_GESTURE_ITEM_GIVE)
