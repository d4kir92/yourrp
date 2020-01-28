--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

YRP = YRP or {}

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
table.insert(yrp_shorts, "bg")
table.insert(yrp_shorts, "ca")
table.insert(yrp_shorts, "cs")
table.insert(yrp_shorts, "es")
table.insert(yrp_shorts, "fr")
table.insert(yrp_shorts, "hu")
table.insert(yrp_shorts, "it")
table.insert(yrp_shorts, "ja")
table.insert(yrp_shorts, "ko")
table.insert(yrp_shorts, "lt")
table.insert(yrp_shorts, "pl")
table.insert(yrp_shorts, "pt-br")
table.insert(yrp_shorts, "ro")
table.insert(yrp_shorts, "ru")
table.insert(yrp_shorts, "sv")
table.insert(yrp_shorts, "th")
table.insert(yrp_shorts, "tr")
table.insert(yrp_shorts, "uk")
table.insert(yrp_shorts, "zh-cn")
table.insert(yrp_shorts, "zh-tw")

function YRP.GetLanguageAutoInfo()
	local auto = {}
	auto.inenglish = "Automatic"
	auto.language = "Automatic"
	auto.author = "D4KiR"
	auto.short = "auto"

	return auto
end

AddCSLuaFile("read_lang.lua")
include("read_lang.lua")

function YRP.set_lang_string(var, str)
	var = tostring(var)
	str = tostring(str)
	yrp_current_lang[string.lower(var)] = str
end

function YRP.get_language_name(ls)
	for k, lang in pairs(yrp_button_info) do
		if lang.short == ls then return lang["inenglish"] end
	end

	return "FAILED"
end

function YRP.search_language()
	yrp_current_lang.get_language = string.lower(GetConVar("gmod_language"):GetString())
end

function YRP.replace_string(in_str, tab)
	for i, str in pairs(tab) do
		in_str = string.Replace(in_str, "[" .. tostring(i) .. "]", tab[i])
	end

	return in_str
end

function HasYRPContent()
	local hascontent = false
	for i, addon in pairs(engine.GetAddons()) do
		if addon.wsid == "1189643820" and addon.mounted and addon.downloaded then
			hascontent = true
			break
		end
	end
	return hascontent
end

local nf = {}
function YRP.lang_string(var, vals)
	var = tostring(var)
	if yrp_current_lang["lid_initauthor"] != nil then
		local _string = yrp_current_lang[string.lower(var)]
		if !wk(_string) then
			if nf[var] == nil and string.StartWith(var, "LID_") then
				nf[var] = var
				if !string.find(var, " ") and !string.find(var, ":") and !string.find(var, "-") and HasYRPContent() then
					printGM("error", "Translation string [" .. var .. "] not found, sent to Dev. Wait for next update!")
				end
			end
			return var
		end
		if wk(vals) then
			if type(vals) == "string" then
				return YRP.lang_string(var)
			else
				for id, val in pairs(vals) do
					_string = string.Replace(_string, "%" .. id .. "%", val)
				end
			end
		end
		return _string
	else
		return var
	end
end

-- Translate
local searching = {}	-- Anti spam
local translations = {}	-- finished translations
function GetTranslation(sentence, target, source)
	if yrp_current_lang["lid_initauthor"] != nil then
		target = target or YRP.lang_string("LID_initshort")
		source = source or "auto"
		searching[sentence] = searching[sentence] or false
		if translations[sentence] == nil and !searching[sentence] then
			searching[sentence] = true
			local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=" .. source .. "&tl=" .. target .. "&dt=t&q=" .. sentence .. ""
			http.Fetch(
				url,
				function(body)
					local tomuchtraffic = string.find(body, "unusual traffic")
					if tomuchtraffic then
						YRP.msg("note", "[GetTranslation] To much Translations")
					else
						body = string.sub(body, 5)
						local result = string.sub(body, 1, string.find(body, "\"") - 1)
						if result then
							translations[sentence] = result
							searching[sentence] = false
						end
					end
				end,
				function(error)
					YRP.msg("note", "[GetTranslation] failed " .. error)
				end
			)
		elseif translations[sentence] != nil then
			return translations[sentence]
		end
	end
	return sentence
end
--GetTranslation("Lockdown")

function YRP.GetAllLanguages()
	return yrp_button_info
end

function YRP.GetCurrentLanguage()
	return yrp_cur_lang
end

function YRP.check_languagepack()
	for k, v in pairs(yrp_shorts) do
		if yrp_current_lang.get_language == v then return true end
	end

	return false
end

function YRP.send_lang(short)
	-- send info to server, to let others know what language i chose
	if CLIENT then
		printGM("lang", "Send Language to Server: [" .. tostring(short) .. "]")
		net.Start("client_lang")
		net.WriteString(tostring(short))
		net.SendToServer()
	end
end

function YRP.read_language(short, init)
	short = tostring(short)
	local default = false

	if short == "en" then
		default = true
	end

	if !init then
		YRP.read_lang("resource/localization/yrp/init/lang_" .. short .. ".properties")

		if !default then
			printGM("lang", "Get Language-Pack [" .. YRP.lang_string("LID_initshort") .. "] " .. YRP.lang_string("LID_initlanguage") .. "/" .. YRP.lang_string("LID_initinenglish"))
		end

		YRP.read_lang("resource/localization/yrp/general/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/hud/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/menuappearance/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/menuatm/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/menubuilding/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/menubuy/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/menucharacter/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/menuinteract/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settings/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsdatabase/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsfeedback/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsgeneral/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsgroupsandroles/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsdesign/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsmap/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsplayers/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsrealistic/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsstatus/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsusergroups/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsyourrpaddons/lang_" .. short .. ".properties")
	else
		YRP.read_lang("resource/localization/yrp/init/lang_" .. short .. ".properties")
	end

	yrp_cur_lang = short
end

function YRP.LoadLanguage(short, init)
	if short == nil then
		printGM("note", "LoadLanguage ERROR!")

		return false
	end

	short = tostring(short)

	if (init) then
		YRP.read_language(short, init)
	else
		hr_pre("lang")

		if short == "auto" then
			printGM("lang", "[AUTOMATIC DETECTION]")
			YRP.search_language()

			if yrp_current_lang.get_language != "" then
				short = string.lower(yrp_current_lang.get_language)
				printGM("lang", "Found Language: " .. "[" .. short .. "]")

				if !YRP.check_languagepack() then
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
			YRP.read_language(short, init)
		else
			YRP.read_language("en", init)
			YRP.read_language(short, init)
		end

		printGM("lang", "Language changed to [" .. YRP.lang_string("LID_initshort") .. "] " .. YRP.lang_string("LID_initlanguage"))
		YRP.send_lang(short) -- Send To Server
		hook.Run("yrp_current_language_changed") -- Update Chat
		hr_pos("lang")
	end

	return true
end

function YRP.add_language(short)
	short = tostring(short)

	if yrp_button_info[short] == nil then
		yrp_button_info[short] = {}
	end

	if short == "auto" then
		yrp_button_info[short]["inenglish"] = "Automatic"
		yrp_button_info[short]["language"] = "Automatic"
		yrp_button_info[short]["short"] = short
		yrp_button_info[short]["author"] = "D4KiR"
		yrp_button_info[short]["steamid64"] = ""
	else
		yrp_button_info[short]["inenglish"] = YRP.lang_string("LID_initinenglish")
		yrp_button_info[short]["language"] = YRP.lang_string("LID_initlanguage")
		yrp_button_info[short]["short"] = YRP.lang_string("LID_initshort")
		yrp_button_info[short]["author"] = YRP.lang_string("LID_initauthor")
		yrp_button_info[short]["steamid64"] = YRP.lang_string("LID_steamid64")
	end
end

for i, short in pairs(yrp_shorts) do
	YRP.LoadLanguage(short, true)
	YRP.add_language(short)
end

if CLIENT then
	--[[ FLAGS ]]
	--
	for i, short in pairs(yrp_shorts) do
		if short != nil then
			YRP.AddDesignIcon("lang_" .. short, "vgui/iso_639/" .. short .. ".png")
		end
	end
end

function YRP.initLang()
	hr_pre("lang")
	printGM("lang", "... SEARCHING FOR LANGUAGE ...")
	YRP.LoadLanguage("auto", false)
	hr_pos("lang")
end
YRP.initLang()
