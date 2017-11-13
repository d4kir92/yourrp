--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function createFont( _name, _font, _size, __weight, _outline )
	--printGM( "db", "createFont: " .. _name )
	--printGM( "db", _font .. ", " .. _size .. ", " .. __weight )
	_size = ctr( _size*2 )
	surface.CreateFont( _name, {
		font = _font, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = true,
		size = _size,
		weight = __weight,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = _outline
	} )
end

local tmpFont = "Roboto-Regular"
local _weight = 1

function changeFontSizeOf( _font, _size )
	printGM( "note", "changeFontSizeOf" .. _font .. _size)
	createFont( _font, tmpFont, _size, weight, false )
end

function updateDBFonts()
	createFont( "mmsf", tmpFont, cl_db["mmsf"], _weight, false )
	createFont( "hpsf", tmpFont, cl_db["hpsf"], _weight, false )
	createFont( "arsf", tmpFont, cl_db["arsf"], _weight, false )
	createFont( "wpsf", tmpFont, cl_db["wpsf"], _weight, false )
	createFont( "wssf", tmpFont, cl_db["wssf"], _weight, false )
	createFont( "wnsf", tmpFont, cl_db["wnsf"], _weight, false )
	createFont( "ttsf", tmpFont, cl_db["ttsf"], _weight, false )
	createFont( "mosf", tmpFont, cl_db["mosf"], _weight, false )
	createFont( "mhsf", tmpFont, cl_db["mhsf"], _weight, false )
	createFont( "mtsf", tmpFont, cl_db["mtsf"], _weight, false )
	createFont( "mssf", tmpFont, cl_db["mssf"], _weight, false )
	createFont( "vtsf", tmpFont, cl_db["vtsf"], _weight, false )
	createFont( "cbsf", tmpFont, cl_db["cbsf"], _weight, false )
	createFont( "masf", tmpFont, cl_db["masf"], _weight, false )
	createFont( "casf", tmpFont, cl_db["casf"], _weight, false )
	createFont( "stsf", tmpFont, cl_db["stsf"], _weight, false )
	createFont( "xpsf", tmpFont, cl_db["xpsf"], _weight, false )
end

function changeFontSize()
	printGM( "db", "changeFontSize" )

	createFont( "HudSettings", tmpFont, 24, _weight, false )

	createFont( "HudDefault", tmpFont, 72, _weight, false )

	createFont( "SettingsNormal", tmpFont, 30, _weight, false )
	createFont( "SettingsHeader", tmpFont, 30, _weight, false )

	createFont( "roleInfoHeader", tmpFont, 24, _weight, false )
	createFont( "roleInfoText", tmpFont, 20, _weight, false )

	createFont( "charTitle", tmpFont, 18, _weight, false )
	createFont( "charHeader", tmpFont, 18, _weight, false )
	createFont( "charText", tmpFont, 18, _weight, false )

	createFont( "pmT", tmpFont, 18, _weight, false )
	createFont( "weaponT", tmpFont, 14, _weight, false )

	createFont( "HudBars", tmpFont, 24, _weight, false )
	createFont( "HudHeader", tmpFont, 36, _weight, false )
	createFont( "HudVersion", tmpFont, 30, 1000, false )

	--Creating
	createFont( "mmsf", tmpFont, 24, _weight, false )
	createFont( "hpsf", tmpFont, 24, _weight, false )
	createFont( "arsf", tmpFont, 24, _weight, false )
	createFont( "wpsf", tmpFont, 24, _weight, false )
	createFont( "wssf", tmpFont, 24, _weight, false )
	createFont( "wnsf", tmpFont, 24, _weight, false )
	createFont( "ttsf", tmpFont, 24, _weight, false )
	createFont( "mosf", tmpFont, 24, _weight, false )
	createFont( "mhsf", tmpFont, 24, _weight, false )
	createFont( "mtsf", tmpFont, 24, _weight, false )
	createFont( "mssf", tmpFont, 24, _weight, false )
	createFont( "vtsf", tmpFont, 24, _weight, false )
	createFont( "cbsf", tmpFont, 24, _weight, false )
	createFont( "masf", tmpFont, 24, _weight, false )
	createFont( "casf", tmpFont, 24, _weight, false )
	createFont( "stsf", tmpFont, 24, _weight, false )
	createFont( "xpsf", tmpFont, 24, _weight, false )

	createFont( "sef", tmpFont, 24, _weight, false )

	timer.Create( "createFontDB", 0.1, 0, function()
		if cl_db["_loaded"] then
			--Changing to right values
			updateDBFonts()

			printGM( "db", "HUD Fonts loaded." )

			timer.Remove( "createFontDB" )
		end
	end)

	createFont( "ScoreBoardTitle", tmpFont, 24, _weight, false )
	createFont( "ScoreBoardNormal", tmpFont, 20, _weight, false )

	createFont( "ATM_Header", tmpFont, 80, _weight, false )
	createFont( "ATM_Normal", tmpFont, 60, _weight, false )
	createFont( "ATM_Name", tmpFont, 40, _weight, false )

	--DarkRP Fonts
	createFont( "DarkRPHUD1", tmpFont, 16, _weight, false )
	createFont( "DarkRPHUD2", tmpFont, 24, _weight, false )
	createFont( "Trebuchet18", tmpFont, 16, _weight, false )
	createFont( "Trebuchet20", tmpFont, 20, _weight, false )
	createFont( "Trebuchet24", tmpFont, 24, _weight, false )
	createFont( "Trebuchet48", tmpFont, 48, _weight, false )
	createFont( "TabLarge", tmpFont, 16, 700, false )
	createFont( "UiBold", tmpFont, 16, 800, false )
	createFont( "HUDNumber5", tmpFont, 30, 800, false )
	createFont( "ScoreboardHeader", tmpFont, 32, _weight, false )
	createFont( "ScoreboardSubtitle", tmpFont, 24, _weight, false )
	createFont( "ScoreboardPlayerName", tmpFont, 19, _weight, false )
	createFont( "ScoreboardPlayerName2", tmpFont, 15, _weight, false )
	createFont( "ScoreboardPlayerNameBig", tmpFont, 24, _weight, false )
	createFont( "AckBarWriting", tmpFont, 20, _weight, false )
	createFont( "DarkRP_tipjar", tmpFont, 100, _weight, false )
end
changeFontSize()

local searchIcon = Material( "icon16/magnifier.png" )

--##############################################################################
function derma_change_language( parent, w, h, x, y )
  local _tmp = createD( "DComboBox", parent, w, h, x, y )
  _tmp:AddChoice( "[AUTOMATIC]", "auto" )
  for k, v in pairs( get_all_lang() ) do
    local _select = false
    if lang_string( "language" ) == v.lang then
      _select = true
    end
    _tmp:AddChoice( v.ineng .. "/" .. v.lang, v.short, _select )
  end
  _tmp.OnSelect = function( panel, index, value, data )
    change_language( data )
  end
  return _tmp
end
--##############################################################################

function isInTable( table, item )
  for k, v in pairs( table ) do
    if string.lower( tostring( v ) ) == string.lower( tostring( item.ClassName ) ) then
      return true
    end
  end
  return false
end

function openSelector( table, dbTable, dbSets, dbWhile, closeF )
  local table2 = string.Explode( ",", _globalWorking )
  local frame = createVGUI( "DFrame", nil, 2000, 2000, 0, 0 )
  frame:Center()
  frame:SetTitle( "" )
  function frame:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )
  end
  function frame:OnClose()
    hook.Call( closeF )
  end

  local searchButton = createD( "DButton", frame, ctr( 40 ), ctr( 40 ), ctr( 10 ), ctr( 50 ) )
  searchButton:SetText( "" )
  function searchButton:Paint( pw, ph )
    local _br = 4
    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( searchIcon	)
  	surface.DrawTexturedRect( ctr( _br ), ctr( _br ), ctr( 40-2*_br ), ctr( 40-2*_br ) )
  end

  local search = createVGUI( "DTextEntry", frame, 2000 - 20 - 40, 40, 10 + 40, 50 )
	function search:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )
		local _string = search:GetText()
		if _string == "" then
			_string = lang_string( "search" )
		end
		draw.SimpleTextOutlined( _string, "DermaDefault", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end

  local site = {}
  site.cur = 1
  site.max = 1
  site.count = #table
  function getMaxSite()
    local tmpMax = math.Round( site.count/42, 2 )
    site.max = math.Round( site.count/42, 0 )
    if tmpMax > site.max then
      site.max = site.max + 1
    end
  end
  getMaxSite()

  local scrollpanel = createVGUI( "DPanel", frame, 2000 - 20, 2000 - 50 - 40 - 10 - 10, 10, 50+40+10 )
  function scrollpanel:Paint( pw, ph )
    //draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
    draw.SimpleTextOutlined( site.cur .. "/" .. site.max, "sef", pw/2, ph - 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local tmpCache = {}
  local tmpSelected = {}

  function showList()
    for k, v in pairs( tmpCache ) do
      v:Remove()
    end

    local itemSize = 320

    local tmpBr = 25
    local tmpX = 0
    local tmpY = 0

    site.count = 0
    local count = 0
    for k, v in pairs( table ) do
      if v.WorldModel == nil then
        v.WorldModel = v.Model or ""
      end
      if v.PrintName == nil then
        v.PrintName = v.Name or ""
      end
      if v.ClassName == nil then
        v.ClassName = v.Class or ""
      end

      tmpSelected[k] = {}
      tmpSelected[k].ClassName = v.ClassName
      if isInTable( table2, v ) then
        tmpSelected[k].selected = true
      else
        tmpSelected[k].selected = false
      end

      if string.find( string.lower( v.WorldModel ), search:GetText() ) or string.find( string.lower( v.PrintName ), search:GetText() ) or string.find( string.lower( v.ClassName ), search:GetText() ) then
        site.count = site.count + 1
        if ( site.count - 1 ) >= ( site.cur - 1 ) * 25 and ( site.count - 1 ) < ( site.cur ) * 25 then
          count = count + 1
          tmpCache[k] = createVGUI( "DPanel", scrollpanel, itemSize, itemSize, tmpX, tmpY )

          local tmpPointer = tmpCache[k]
          function tmpPointer:Paint( pw, ph )
            if tmpSelected[k].selected then
              draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 0, 200 ) )
            else
              draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
            end
          end

          if v.WorldModel != nil and v.WorldModel != "" then
            local icon = createVGUI( "SpawnIcon", tmpPointer, itemSize, itemSize, 0, 0 )
            icon.item = v
            icon:SetText( "" )
            timer.Create( "shop" .. count, 0.5*count, 1, function()
              if icon != nil and icon != NULL and icon.item != nil then
                icon:SetModel( icon.item.WorldModel )
                if icon.Entity != nil then
                  icon.Entity:SetModelScale( 1, 0 )
                  icon:SetLookAt( Vector( 0, 0, 0 ) )
                  icon:SetCamPos( Vector( 0, -30, 15 ) )
                end
              end
            end)
          end

          local tmpButton = createVGUI( "DButton", tmpPointer, 256, 256, 0, 0 )
          tmpButton:SetText( "" )
          function tmpButton:Paint( pw, ph )
            draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 0 ) )
            local text = lang_string( "notadded" )
            if tmpSelected[k].selected then
              text = lang_string( "added" )
            end
            draw.SimpleTextOutlined( text, "sef", pw/2, ctr( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
            draw.SimpleTextOutlined( v.PrintName, "sef", pw/2, ph - ctr( 20 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          end
          function tmpButton:DoClick()
            if tmpSelected[k].selected then
              tmpSelected[k].selected = false
            else
              tmpSelected[k].selected = true
            end
            local tmpString = ""
            for k, v in pairs( tmpSelected ) do
              if v.selected and v.ClassName != nil then
                if tmpString == "" then
                  tmpString = v.ClassName
                else
                  tmpString = tmpString .. "," .. v.ClassName
                end
              end
            end
            net.Start( "dbUpdate" )
              net.WriteString( dbTable )
              net.WriteString( dbSets .. " = '" .. tmpString .. "'" )
              net.WriteString( dbWhile )
            net.SendToServer()
            _globalWorking = tmpString
          end

          tmpX = tmpX + itemSize + tmpBr
          if tmpX > 2000 - itemSize - tmpBr then
            tmpX = 0
            tmpY = tmpY + itemSize + tmpBr
          end
        end
      end
    end
  end

  local nextB = createVGUI( "DButton", frame, 200, 50, 2000 - 10 - 200, 1800 )
  nextB:SetText( "" )
  function nextB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleTextOutlined( lang_string( "nextsite" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function nextB:DoClick()
    if site.max > site.cur then
      site.cur = site.cur + 1
      showList()
    end
  end

  local prevB = createVGUI( "DButton", frame, 200, 50, 10, 1800 )
  prevB:SetText( "" )
  function prevB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleTextOutlined( lang_string( "prevsite" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function prevB:DoClick()
    site.cur = site.cur - 1
    if site.cur < 1 then
      site.cur = 1
    end
    showList()
  end

  function search:OnChange()
    site.cur = 1
    showList()
    getMaxSite()
  end
  showList()

  frame:MakePopup()
end

function openSingleSelector( table )
  local site = {}
  site.cur = 1
  site.max = 1
  site.count = #table
  function getMaxSite()
    local tmpMax = math.Round( site.count/42, 2 )
    site.max = math.Round( site.count/42, 0 )
    if tmpMax > site.max then
      site.max = site.max + 1
    end
  end
  getMaxSite()

  local shopsize = ScrH()
  local frame = vgui.Create( "DFrame" )
  frame:SetSize( shopsize, shopsize )
  frame:SetPos( ScrW2() - shopsize/2, ScrH2() - shopsize/2 )
  frame:SetTitle( lang_string( "itemMenu" ) )
  function frame:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, g_yrp.colors.dbackground )
  end

  local PanelSelect = createD( "DPanel", frame, shopsize - ctr( 20 ), shopsize - ctr( 100 ), ctr( 10 ), ctr( 100 ) )
  PanelSelect:SetText( "" )
  function PanelSelect:Paint( pw, ph )
    //draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 0, 255 ) )
    draw.SimpleTextOutlined( site.cur .. "/" .. site.max, "sef", pw/2, ph - ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local searchButton = createD( "DButton", frame, ctr( 40 ), ctr( 40 ), ctr( 10 ), ctr( 50 ) )
  searchButton:SetText( "" )
  function searchButton:Paint( pw, ph )
    local _br = 4
    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( searchIcon	)
  	surface.DrawTexturedRect( ctr( _br ), ctr( _br ), ctr( 40-2*_br ), ctr( 40-2*_br ) )
  end

  local search = createD( "DTextEntry", frame, shopsize - ctr( 20+40 ), ctr( 40 ), ctr( 10+40 ), ctr( 50 ) )
	function search:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )
		local _string = search:GetText()
		if _string == "" then
			_string = lang_string( "search" )
		end
		draw.SimpleTextOutlined( _string, "DermaDefault", ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  end
	
  function showList()
    local tmpBr = 25
    local tmpX = 0
    local tmpY = 0

    PanelSelect:Clear()
    local _cat = nil
    if tab == "vehicles" then
      _cat = "Category"
    end

    site.count = 0
    local count = 0
    local iconsize = 384
    local amount = 20
    for k, item in SortedPairsByMemberValue( table, _cat, false ) do
      item.PrintName = item.PrintName or item.Name or ""
      item.ClassName = item.ClassName or item.Class or ""
      item.WorldModel = item.WorldModel or item.Model or ""
      if string.find( string.lower( item.WorldModel or "XXXXXXXXX" ), search:GetText() ) or string.find( string.lower( item.PrintName or "XXXXXXXXX" ), search:GetText() ) or string.find( string.lower( item.ClassName or "XXXXXXXXX" ), search:GetText() ) then
        site.count = site.count + 1
        if ( site.count - 1 ) >= ( site.cur - 1 ) * amount and ( site.count - 1 ) < ( site.cur ) * amount then
          count = count + 1

          if item.WorldModel == nil then
            item.WorldModel = item.Model or ""
          end
          if item.ClassName == nil then
            item.ClassName = item.Class or ""
          end
          if item.PrintName == nil then
            item.PrintName = item.Name or ""
          end

          local icon = createD( "SpawnIcon", PanelSelect, ctr( iconsize ), ctr( iconsize ), ctr( tmpX ), ctr( tmpY ) )
          icon.item = item
          icon:SetText( "" )
          timer.Create( "shop" .. count, 0.6*count, 1, function()
            if icon != nil and icon != NULL and icon.item != nil then
              icon:SetModel( icon.item.WorldModel )
            end
          end)
          icon:SetTooltip( item.PrintName )
          local _tmpName = createVGUI( "DButton", icon, iconsize, iconsize, 10, 10 )
          _tmpName:SetText( "" )
          function _tmpName:Paint( pw, ph )
            draw.SimpleTextOutlined( item.PrintName, "pmT", pw/2, ph-ctr( 35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          end
          function _tmpName:DoClick()
            LocalPlayer():SetNWString( "WorldModel", item.WorldModel )
            LocalPlayer():SetNWString( "ClassName", item.ClassName )
            LocalPlayer():SetNWString( "PrintName", item.PrintName )
            LocalPlayer():SetNWString( "Skin", item.Skin )
            frame:Close()
          end
          tmpX = tmpX + iconsize + tmpBr
          if ctr( tmpX ) > shopsize - ctr( iconsize ) - tmpBr then
            tmpX = 0
            tmpY = tmpY + iconsize + tmpBr
          end
        end
      end
    end
  end

  local nextB = createD( "DButton", frame, ctr( 200 ), ctr( 50 ), shopsize - ctr( 10 ) - ctr( 200 ), ctr( 1800 ) )
  nextB:SetText( "" )
  function nextB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleTextOutlined( lang_string( "nextsite" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function nextB:DoClick()
    if site.max > site.cur then
      site.cur = site.cur + 1
      showList()
    end
  end

  local prevB = createD( "DButton", frame, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 1800 ) )
  prevB:SetText( "" )
  function prevB:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    draw.SimpleTextOutlined( lang_string( "prevsite" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function prevB:DoClick()
    site.cur = site.cur - 1
    if site.cur < 1 then
      site.cur = 1
    end
    showList()
  end

  function search:OnChange()
    site.cur = 1
    showList()
    getMaxSite()
  end
  showList()

  frame:MakePopup()
end

net.Receive( "yrpInfoBox", function( len )
  local _tmp = createVGUI( "DFrame", nil, 800, 400, 0, 0 )
  _tmp:SetTitle( "Notification" )
  local _text = net.ReadString()
  function _tmp:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 80 ) )
    draw.SimpleTextOutlined( _text, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local closeButton = createVGUI( "DButton", _tmp, 200, 50, 400 - 100, 400 - 50 )
  closeButton:SetText( "Close" )
  function closeButton:DoClick()
    _tmp:Close()
  end
  _tmp:Center()
  _tmp:MakePopup()
end)

local testingversion = false
local serverVersion = "-1.-1.-1"
function testVersion()
  if !testingversion then
    testingversion = true
    net.Start( "getServerVersion" )
    net.SendToServer()
  end
end

function showVersion()
  local ply = LocalPlayer()

  http.Fetch( "https://docs.google.com/document/d/1mvyVK5OzHajMuq6Od74-RFaaRV7flbR2pYBiyuWVGxA/edit?usp=sharing",
    function( body, len, headers, code )
      local StartPos = string.find( body, "#", 1, false )
      local EndPos = string.find( body, "*", 1, false )
      local versionOnline = string.sub( body, StartPos+1, EndPos-1 )

      --Client
      local cur2num = string.Replace( GAMEMODE.Version, ".", "" )
      local new2num = string.Replace( versionOnline, ".", "" )
      local verart = "Up-To-Date"
      g_yrp.versionCol = Color( 0, 255, 0, 255 )
      if cur2num < new2num then
        verart = lang_string( "versionnewpre" ) .. " " .. GAMEMODE.Name .. " " .. lang_string( "versionnewpos" )
        g_yrp.versionCol = Color( 255, 0, 0, 255 )
      elseif cur2num > new2num then
        verart = lang_string( "versionoldpre" ) .. " " .. GAMEMODE.Name .. " " .. lang_string( "versionoldpos" )
        g_yrp.versionCol = Color( 100, 100, 255, 255 )
      end

      --Server
      local cur2num2 = string.Replace( GAMEMODE.Version, ".", "" )
      local new2num2 = string.Replace( versionOnline, ".", "" )
      local verart2 = "Up-To-Date"
      local outcol2 = Color( 0, 255, 0, 255 )
      if cur2num2 < new2num2 then
        verart2 = lang_string( "versionnewpre" ) .. " " .. GAMEMODE.Name .. " " .. lang_string( "versionnewpos" )
        outcol2 = Color( 255, 0, 0, 255 )
      elseif cur2num2 > new2num2 then
        verart2 = lang_string( "versionoldpre" ) .. " " .. GAMEMODE.Name .. " " .. lang_string( "versionoldpos" )
        outcol2 = Color( 100, 100, 255, 255 )
      end

      local _serverSort = ""
      if serverIsDedicated then
        GAMEMODE.dedicated = "Dedicated"
        _serverSort = lang_string( "serverdedicated" )
      else
        GAMEMODE.dedicated = "Local"
        _serverSort = lang_string( "serverlocal" )
      end

      local _versionsort = ""
      if GAMEMODE.VersionSort == "unstable" then
        _versionsort = lang_string( "unstable" )
      elseif GAMEMODE.VersionSort == "stable" then
        _versionsort = lang_string( "stable" )
      end

      if versionOnline != GAMEMODE.Version then
        g_yrp.outdated = true
        local frame = createVGUI( "DFrame", nil, 1000, 500, 0, 0 )
        frame:Center()
        frame:SetTitle( "" )
        function frame:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
          draw.SimpleTextOutlined( "Language:", "HudBars", ctr( 300 ), ctr( 25 + 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( verart .. "! (" .. _versionsort .. ")", "HudBars", pw/2, ctr( 100 ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( lang_string( "currentversion" ) .. ":", "HudBars", pw/2, ctr( 175 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( lang_string( "client" ) .. ": ", "HudBars", pw/2, ctr( 225 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( GAMEMODE.Version, "HudBars", pw/2, ctr( 225 ), g_yrp.versionCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( "(" .. _serverSort .. ") " .. lang_string( "server" ) .. ": ", "HudBars", pw/2, ctr( 275 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( serverVersion, "HudBars", pw/2, ctr( 275 ), outcol2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

          draw.SimpleTextOutlined( lang_string( "workshopversion" ) .. ": ", "HudBars", pw/2, ctr( 375 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined( versionOnline .. " (" .. _versionsort .. ")", "HudBars", pw/2, ctr( 375 ), Color( 0, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end

        local _langu = derma_change_language( frame, ctr( 400 ), ctr( 50 ), ctr( 310 ), ctr( 10 ) )

        local showChanges = createVGUI( "DButton", frame, 460, 50, 0, 0 )
        showChanges:SetText( "" )
        function showChanges:DoClick()
          gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152" )
        end
        function showChanges:Paint( pw, ph )
          draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
          draw.SimpleTextOutlined( lang_string( "showchanges" ), "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
        end

        if ply:IsAdmin() or ply:IsSuperAdmin() then
          local restartServer = createVGUI( "DButton", frame, 460, 50, 0, 0 )
          restartServer:SetText( "" )
          function restartServer:DoClick()
            net.Start( "restartServer" )
            net.SendToServer()
          end
          function restartServer:Paint( pw, ph )
            draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )
            draw.SimpleTextOutlined( lang_string( "updateserver" ), "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          end

          showChanges:SetPos( ctr( 500-460-10 ), ctr( 425 ) )
          restartServer:SetPos( ctr( 500+10 ), ctr( 425 ) )
        else
          showChanges:SetPos( ctr( 500-230 ), ctr( 425 ) )
        end

        frame:MakePopup()
      else
        g_yrp.outdated = false
        printGM( "note", "YourRP is on the newest version (unstable)")
      end
      testingversion = false
    end,
    function( error )
      -- We failed. =(
    end
   )
end

net.Receive( "getServerVersion", function( len )
  serverVersion = net.ReadString()
  serverIsDedicated = net.ReadBool()
  showVersion()
end)

function GM:InitPostEntity()
  printGM( "note", "All entities are loaded." )
  playerready = true
  timer.Simple( 4, function()
    playerfullready = true
  end)

  loadCompleteHUD()
  testVersion()
end

--Remove Ragdolls after 60 sec
function RemoveDeadRag( ent )
	if (ent == NULL) or (ent == nil) then return end
	if (ent:GetClass() == "class C_ClientRagdoll") then
		if ent:IsValid() and !(ent == NULL) then
			SafeRemoveEntityDelayed( ent, 60 )
		end
	end
end
hook.Add("OnEntityCreated", "RemoveDeadRag", RemoveDeadRag)

function GM:HUDDrawTargetID()
  return false
end

function drawPlate( ply, string )
  if ply:Alive() and ply:LookupBone( "ValveBiped.Bip01_Head1" ) != nil then
    local pos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_Head1" ) ) + Vector( 0, 0, ply:GetModelScale() * 20 )
    local ang = Angle( 0, ply:GetAngles().y-90, 90 )
    local sca = ply:GetModelScale()/4
    local str = string
    local strSize = string.len( str ) + 3
    cam.Start3D2D( pos , ang, sca )
      draw.RoundedBox( 0, -( ( strSize * 10 )/2 ), 0, strSize*10, 24, Color( 0, 0, 0, 200 ) )
      draw.SimpleTextOutlined( str, "HudBars", 0, 12, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    cam.End3D2D()
  end
end

function drawPlates()
  for k, v in pairs( player.GetAll() ) do
    if v:GetNWBool( "tag", false ) then
      if tostring( v:SteamID() ) == "STEAM_0:1:20900349" then
        drawPlate( v, "DEVELOPER" )
      end
    end
  end
end
hook.Add( "PostPlayerDraw", "DrawName", drawPlates )
