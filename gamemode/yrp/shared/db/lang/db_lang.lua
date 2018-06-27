--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
local yrp_cur_lang = "auto"
local yrp_current_lang = {}
yrp_current_lang.get_language = "Unknown"
yrp_current_lang.not_found = "not found, using default one."
yrp_current_lang["language"] = "Unknown"
local yrp_button_info = {}
local yrp_shorts = {}
local _translationProgress = {}
table.insert(yrp_shorts, "en")
table.insert(yrp_shorts, "de")
--table.insert( yrp_shorts, "bg" )
--table.insert( yrp_shorts, "ca" )
table.insert(yrp_shorts, "cs")
--table.insert( yrp_shorts, "es" )
table.insert(yrp_shorts, "fr")
--table.insert( yrp_shorts, "hu" )
table.insert(yrp_shorts, "it")
--table.insert( yrp_shorts, "ko" )
table.insert(yrp_shorts, "lt")
table.insert(yrp_shorts, "pl")
table.insert(yrp_shorts, "pt_br")
table.insert(yrp_shorts, "ro")
table.insert(yrp_shorts, "ru")
--table.insert( yrp_shorts, "sv" )
--table.insert( yrp_shorts, "th" )
table.insert(yrp_shorts, "tr")
table.insert(yrp_shorts, "uk")

function GetLanguageAutoInfo()
	local auto = {}
	auto.inenglish = "Automatic"
	auto.language = "Automatic"
	auto.author = "D4KiR"
	auto.short = "auto"

	return auto
end

AddCSLuaFile("read_lang.lua")
include("read_lang.lua")

function set_lang_string(var, str)
	var = tostring(var)
	str = tostring(str)
	yrp_current_lang[string.lower(var)] = str
end

function get_language_name(ls)
	for k, lang in pairs(yrp_button_info) do
		if lang.short == ls then return lang["inenglish"] end
	end

	return "FAILED"
end

function search_language()
	yrp_current_lang.get_language = string.lower(GetConVar("gmod_language"):GetString())
end

function replace_string(in_str, tab)
	for i, str in pairs(tab) do
		in_str = string.Replace(in_str, "[" .. tostring(i) .. "]", tab[i])
	end

	return in_str
end

function lang_string(var)
	var = tostring(var)
	local _string = yrp_current_lang[string.lower(var)] or var

	if CLIENT and LocalPlayer():GetNWBool("yrp_debug", false) then
		printGM("note", "lang_string failed! string " .. var .. " not found")
	end

	return _string
end

local auto = {}
auto.short = "auto"
auto.language = "Automatic"
auto.inenglish = "Automatic"

function GetAllLanguages()
	return yrp_button_info
end

function GetCurrentLanguage()
	return yrp_cur_lang
end

function check_languagepack()
	for k, v in pairs(yrp_shorts) do
		if yrp_current_lang.get_language == v then return true end
	end

	return false
end

function send_lang(short)
--[[ send info to server, to let others know what language i chose ]]
--
	if CLIENT then
		printGM("lang", "Send Language to Server: [" .. tostring(short) .. "]")
		net.Start("client_lang")
		net.WriteString(tostring(short))
		net.SendToServer()
	end
end

function read_language(short, init)
	short = tostring(short)
	local default = false

	if short == "en" then
		default = true
	end

	if (not init) then
		read_lang("resource/localization/yrp/init/lang_" .. short .. ".properties")

		if not default then
			printGM("lang", "Get Language-Pack [" .. lang_string("short") .. "] " .. lang_string("language") .. "/" .. lang_string("inenglish"))
		end

		read_lang("resource/localization/yrp/_old/lang_" .. "en" .. ".properties")
		read_lang("resource/localization/yrp/general/lang_" .. short .. ".properties", default)
		read_lang("resource/localization/yrp/settings/lang_" .. short .. ".properties")
		read_lang("resource/localization/yrp/settingsfeedback/lang_" .. short .. ".properties")
		read_lang("resource/localization/yrp/settingsgeneral/lang_" .. short .. ".properties")
		read_lang("resource/localization/yrp/settingsrealistic/lang_" .. short .. ".properties")
		read_lang("resource/localization/yrp/settingsusergroups/lang_" .. short .. ".properties")
		read_lang("resource/localization/yrp/settingsdatabase/lang_" .. short .. ".properties")
	else
		read_lang("resource/localization/yrp/init/lang_" .. short .. ".properties")
	end

	yrp_cur_lang = short
end

function LoadLanguage(short, init)
	if short == nil then
		printGM("note", "LoadLanguage ERROR!")

		return false
	end

	short = tostring(short)

	if (init) then
		read_language(short, init)
	else
		hr_pre()

		if short == "auto" then
			printGM("lang", "[AUTOMATIC DETECTION]")
			search_language()

			if yrp_current_lang.get_language ~= "" then
				short = string.lower(yrp_current_lang.get_language)
				printGM("lang", "Found Language: " .. "[" .. short .. "]")

				if not check_languagepack() then
					short = "en"
					printGM("lang", "Can't find Language-Pack, using Default-Language-Pack.")
				end
			else
				short = "en"
				printGM("lang", "Can't find Language from Game, using Default-Language-Pack.")
			end
		else
			yrp_current_lang.get_language = short
			printGM("lang", "Manually change to Language [" .. short .. "]")
		end

		--have to read en first, so incomplete translations have en as base
		if (short == "en") then
			read_language(short, init)
		else
			read_language("en", init)
			read_language(short, init)
		end

		printGM("lang", "Language changed to [" .. lang_string("short") .. "] " .. lang_string("language"))
		send_lang(short) -- Send To Server
		hook.Run("yrp_current_language_changed") -- Update Chat
		hr_pos()
	end

	return true
end

function sendTranslationProgress(player)
	if (IsValid(player) and player:IsPlayer()) then
		net.Start("receiveTranslationProgress")
		local percentages = {}

		for key, value in pairs(yrp_button_info) do
			key = tostring(key)
			percentages[key] = value.percentage
		end

		net.WriteTable(percentages)
		printGM("lang", "Send translation progress to " .. player:GetName())
		net.Send(player)
	end
end

if SERVER then
	util.AddNetworkString("requestTranslationProgress")

	local requestTranslationProgress = function(len, player)
		sendTranslationProgress(player)
	end

	net.Receive("requestTranslationProgress", requestTranslationProgress)
	util.AddNetworkString("receiveTranslationProgress")
elseif CLIENT then
	local receiveTranslationProgress = function(len)
		local percentages = net.ReadTable()

		for key, value in pairs(percentages) do
			key = tostring(key)

			if (yrp_button_info[key] ~= nil) then
				yrp_button_info[key]["percentage"] = value
			end
		end

		printGM("lang", "Received translation progress from server.")
	end

	net.Receive("receiveTranslationProgress", receiveTranslationProgress)
end

function fetch_translation_progress()
	hook.Remove("Tick", "translation_progress_fetch")

	if SERVER then
		printGM("lang", "Trying to fetch translation progress from weblate server...")

		http.Fetch("https://yourrp.noserver4u.de/api/projects/yourrp/statistics/?format=json", function(body, len, headers, code)
			if tonumber(code) == 200 then
				for key, value in pairs(util.JSONToTable(body)) do
					if yrp_button_info[string.lower(value.code)] == nil then
						yrp_button_info[string.lower(value.code)] = {}
					end

					yrp_button_info[string.lower(value.code)]["percentage"] = value.translated_percent
				end

				printGM("lang", "Fetched translation progress successfully!")
			else
				printGM("lang", "Could not fetch translation progress: " .. code)
			end
		end, function(error)
			printGM("lang", "http.fetch error:" .. error)
		end, {
			Authorization = "Token WmgbTcBqV7oS4KgxegwzWfvdfJZZk90b1KRafwej"
		})
	elseif CLIENT then
		printGM("lang", "Request translation progress from server.")
		net.Start("requestTranslationProgress")
		net.SendToServer()
	end
end

function add_language(short)
	short = tostring(short)

	if yrp_button_info[short] == nil then
		yrp_button_info[short] = {}
	end

	if short == "auto" then
		yrp_button_info[short]["inenglish"] = "Automatic"
		yrp_button_info[short]["language"] = "Automatic"
		yrp_button_info[short]["short"] = short
		yrp_button_info[short]["author"] = "D4KiR"
	else
		yrp_button_info[short]["inenglish"] = lang_string("inenglish")
		yrp_button_info[short]["language"] = lang_string("language")
		yrp_button_info[short]["short"] = lang_string("short")
		yrp_button_info[short]["author"] = lang_string("author")
	end
end

for i, short in pairs(yrp_shorts) do
	LoadLanguage(short, true)
	add_language(short)
end

if CLIENT then
	--[[ FLAGS ]]
	--
	for i, short in pairs(yrp_shorts) do
		if short ~= nil then
			AddDesignIcon(short, "vgui/flags/lang_" .. short .. ".png")
		end
	end
end

hook.Add("Tick", "translation_progress_fetch", fetch_translation_progress)

function initLang()
	hr_pre()
	printGM("lang", "... SEARCHING FOR LANGUAGE ...")
	LoadLanguage("auto", false)
	hr_pos()
end

initLang()
--##############################################################################
