--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function util.QuickTrace(origin, dir, filter)
	local trace = {}

	trace.start = origin
	trace.endpos = origin + dir
	trace.filter = filter

	return util.TraceLine(trace)
end
