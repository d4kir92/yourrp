--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #ERROR #BUGS

function wk(obj)
	if obj != nil and obj != false then
		return true
	else
		return false
	end
end

function worked(obj, name, _silence)
	if obj != nil and obj != false then
		return true
	else
		if !_silence then
			YRP.msg( "note", "NOT WORKED: " .. tostring(obj) .. " " .. tostring(name) )
		end
		return false
	end
end

function ea(ent)
	if ent != nil and ent != NULL and tostring(ent) != "[NULL Entity]" then
		if ent:IsValid() then
			return true
		end
	end
	return false
end

function pa(panel)
	if tostring(panel) != "[NULL Panel]" and panel != nil then
		return true
	end
	return false
end

function yts(str , str2)
	return string.find(string.lower(str), string.lower(str2) )
end
