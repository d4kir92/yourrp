--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
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

local hascontent = false
local hasfakecontent = false
local searchedforcontent = false
function YRPTestContentAddons()
	if engine.GetAddons() and table.Count(engine.GetAddons()) <= 0 then
		YRP.msg("note", "CAN'T GET ADDON LIST")
	end

	if (not searchedforcontent or hascontent == false) and SERVER and engine.GetAddons() and table.Count(engine.GetAddons()) > 0 then
		searchedforcontent = true
		for i, addon in pairs(engine.GetAddons()) do
			if addon.wsid then
				addon.wsid = tostring(addon.wsid)
				if addon.wsid == "1189643820" then
					hascontent = true
					SetGlobalYRPBool("yrp_hascontent", true)
					if not addon.mounted or not addon.downloaded then
						YRP.msg("note", "YOURRP CONTENT IS NOT MOUNTED/DOWNLOADED!")
					end
				elseif addon.wsid == "1964961396" and addon.mounted and addon.downloaded then
					hasfakecontent = true
					SetGlobalYRPBool("hasfakecontent", true)
				end
			else
				YRP.msg("note", "Addon list is broken?")
			end
		end
	end
end

function YRPTestDarkrpmodification()
	if file.Exists("addons/darkrpmodification", "GAME") then
		SetGlobalYRPBool("hasdarkrpmodification", true)
	else
		SetGlobalYRPBool("hasdarkrpmodification", false)
	end
end

hook.Add(
	"PostGamemodeLoaded",
	"Check_YourRP_Content",
	function()
		YRPTestContentAddons()
		YRPTestDarkrpmodification()
	end
)

function HasYRPContent()
	return GetGlobalYRPBool("yrp_hascontent", false) or hascontent
end

function HasYRPFakeContent()
	return GetGlobalYRPBool("hasfakecontent", false) or hasfakecontent
end

function HasDarkrpmodification()
	return GetGlobalYRPBool("hasdarkrpmodification", false)
end

function PrintLIDError(var)
	if not string.find(var, " ", 1, true) and not string.find(var, ":", 1, true) and not string.find(var, "-", 1, true) and HasYRPContent() and not HasYRPFakeContent() then
		YRP.msg("error", "Translation string [" .. tostring(var) .. "] not found, sent to Dev. Wait for next update!")
	end
end

local nf = {}
function YRP.trans(var, vals)
	var = tostring(var)
	if string.StartWith(var, "LID_") then
		local va = "LID_" .. string.lower(string.sub(var, 5))
		-- if is not modified
		if va == var then
			local translation = yrp_current_lang[string.lower(var)]
			-- IF NOT FOUND
			if not IsNotNilAndNotFalse(translation) then
				if CLIENT then
					LocalPlayer().badyourrpcontent = LocalPlayer().badyourrpcontent or ""
					if nf[var] == nil and LocalPlayer().LoadedGamemode and LocalPlayer():LoadedGamemode() and LocalPlayer().badyourrpcontent ~= "" then
						nf[var] = var
						PrintLIDError(var)
					end
				end

				return var
			end

			-- IF HAVE VALS
			if IsNotNilAndNotFalse(vals) then
				if type(vals) == "string" then
					return YRP.trans(var)
				else
					for id, val in pairs(vals) do
						translation = string.Replace(translation, "%" .. id .. "%", val)
					end
				end
			end
			-- RETURN TRANSLATION

			return translation
		end
	end
	-- RETURN VAR

	return var
end

function YRP.GetAllLanguages()
	return yrp_button_info
end

function YRP.GetCurrentLanguage()
	return yrp_cur_lang
end

function YRP.GetCurrentLanguageInEnglish()
	if yrp_button_info[YRP.GetCurrentLanguage()] then
		return yrp_button_info[YRP.GetCurrentLanguage()].inenglish
	else
		return "FAIL!!!"
	end
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
		YRP.msg("lang", "Send Language to Server: [" .. tostring(short) .. "]")
		net.Start("nws_yrp_client_lang")
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

	if not init then
		YRP.read_lang("resource/localization/yrp/init/lang_" .. short .. ".properties")
		if not default then
			YRP.msg("lang", "Get Language-Pack [" .. YRP.trans("LID_initshort") .. "] " .. YRP.trans("LID_initlanguage") .. "/" .. YRP.trans("LID_initinenglish"))
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
		YRP.read_lang("resource/localization/yrp/settingsscale/lang_" .. short .. ".properties")
		YRP.read_lang("resource/localization/yrp/settingsblacklist/lang_" .. short .. ".properties")
	else
		YRP.read_lang("resource/localization/yrp/init/lang_" .. short .. ".properties")
	end

	yrp_cur_lang = short
end

function YRP.LoadLanguage(short, init)
	if short == nil then
		YRP.msg("note", "LoadLanguage ERROR!")

		return false
	end

	short = tostring(short)
	if init then
		YRP.read_language(short, init)
	else
		if short == "auto" then
			YRP.msg("lang", "[AUTOMATIC DETECTION]")
			YRP.search_language()
			if yrp_current_lang.get_language ~= "" then
				short = string.lower(yrp_current_lang.get_language)
				YRP.msg("lang", "Found Language: " .. "[" .. short .. "]")
				if not YRP.check_languagepack() then
					short = "en"
					if CLIENT then
						YRP.msg("lang", "Can't find Language-Pack, using Default-Language-Pack.")
					end
				end
			else
				short = "en"
				if CLIENT then
					YRP.msg("lang", "Can't find Language from Game, using Default-Language-Pack.")
				end
			end
		else
			yrp_current_lang.get_language = short
			YRP.msg("lang", "Manually change to Language [" .. short .. "]")
		end

		--have to read en first, so incomplete translations have en as base
		if short == "en" then
			YRP.read_language(short, init)
		else
			YRP.read_language("en", init)
			YRP.read_language(short, init)
		end

		YRP.msg("lang", "Language changed to [" .. YRP.trans("LID_initshort") .. "] " .. YRP.trans("LID_initlanguage"))
		YRP.send_lang(short) -- Send To Server
		hook.Run("yrp_current_language_changed") -- Update Chat
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
		yrp_button_info[short]["inenglish"] = YRP.trans("LID_initinenglish")
		yrp_button_info[short]["language"] = YRP.trans("LID_initlanguage")
		yrp_button_info[short]["short"] = YRP.trans("LID_initshort")
		yrp_button_info[short]["author"] = YRP.trans("LID_initauthor")
		yrp_button_info[short]["steamid64"] = YRP.trans("LID_steamid64")
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
		if short ~= nil and YRP.AddDesignIcon then
			YRP.AddDesignIcon("lang_" .. short, "vgui/iso_639/" .. short .. ".png")
		end
	end
end

function YRP.initLang()
	--YRP.msg( "lang", "... SEARCHING FOR LANGUAGE ..." )
	YRP.LoadLanguage("auto", false)
end

timer.Simple(0.1, YRP.initLang)