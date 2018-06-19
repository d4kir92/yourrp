local TheReturnedHTML = "" -- Blankness
local _translationProgress = {}

http.Fetch( "https://yourrp.noserver4u.de/api/projects/yourrp/statistics/?format=json",
	function( body, len, headers, code )
		-- The first argument is the HTML we asked for.
		TheReturnedHTML = body
	end,
	function( error )
		-- We failed. =(
	end
)

function get_translation_progress()
	if TheReturnedHTML != "" then
		--print("GET TRANSLATION PROGRESS")
		for key,value in pairs(util.JSONToTable( TheReturnedHTML )) do
			--PrintTable(value)
			_translationProgress[value.code]=value.translated_percent
		end
		--PrintTable(_translationProgress)
		--print("END GET TRANSLATION PROGRESS")
	end
end