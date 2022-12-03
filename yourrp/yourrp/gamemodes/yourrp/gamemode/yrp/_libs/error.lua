--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- #ERROR #BUGS

function IsNilOrFalse( obj )
	if obj == nil or obj == false then
		return true
	end
	return false
end

function IsNotNilAndNotFalse( obj )
	if obj != nil and obj != false then
		return true
	end
	return false
end

function WORKED(obj, name, _silence)
	if obj != nil and obj != false then
		return true
	else
		if !_silence then
			YRP.msg( "note", "NOT WORKED: " .. tostring(obj) .. " " .. tostring(name) )
		end
		return false
	end
end

function EntityAlive(ent)
	if ent != nil and ent != NULL and tostring(ent) != "[NULL Entity]" then
		if ent:IsValid() then
			return true
		end
	end
	return false
end

function PanelAlive(panel)
	if tostring(panel) != "[NULL Panel]" and panel != nil then
		return true
	end
	return false
end
