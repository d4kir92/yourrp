--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("open_client_keybinds", "open_client_keybinds", function()
	SaveLastSite()
end)
