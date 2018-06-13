--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _appe = {}
_appe.r = {}
local _yrp_appearance = {}

net.Receive( "get_menu_bodygroups", function( len )
  local _tbl = net.ReadTable()
  local _skin = tonumber( _tbl.skin )
  local _pms = combineStringTables( _tbl.playermodels, _tbl.playermodelsnone )

  local _pmid = tonumber( _tbl.playermodelID )
  if _pmid > #_pms then
    _pmid = 1
  end
  local _pm = _pms[_pmid]
  if pa( _yrp_appearance.left ) then
    if pm != "" then
      local _cbg = {}
      _cbg[1] = tonumber( _tbl.bg0 )
      _cbg[2] = tonumber( _tbl.bg1 )
      _cbg[3] = tonumber( _tbl.bg2 )
      _cbg[4] = tonumber( _tbl.bg3 )
      _cbg[5] = tonumber( _tbl.bg4 )
      _cbg[6] = tonumber( _tbl.bg5 )
      _cbg[7] = tonumber( _tbl.bg6 )
      _cbg[8] = tonumber( _tbl.bg7 )

      function _yrp_appearance.left:Paint( pw, ph )
        --surfacePanel( self, pw, ph )
        --draw.SimpleTextOutlined( lang_string( "appearance" ), "HudBars", pw/2, ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
      end

      _appe.r.pm = createD( "DModelPanel", _yrp_appearance.left, ScrH2() - ctr( 30 ), ScrH2() - ctr( 30 ), 0, 0 )
      _appe.r.pm:SetModel( _pm )
      _appe.r.pm:SetAnimated( true )
      _appe.r.pm.Angles = Angle( 0, 0, 0 )
      _appe.r.pm:RunAnimation()

      function _appe.r.pm:DragMousePress()
    		self.PressX, self.PressY = gui.MousePos()
    		self.Pressed = true
    	end
      function _appe.r.pm:DragMouseRelease() self.Pressed = false end

    	function _appe.r.pm:LayoutEntity( ent )

    		if ( self.bAnimated ) then self:RunAnimation() end

    		if ( self.Pressed ) then
    			local mx, my = gui.MousePos()
    			self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

    			self.PressX, self.PressY = gui.MousePos()
          if ent != nil then
      	    ent:SetAngles( self.Angles )
          end
        end
    	end

      --[[ Playermodel changing ]]--
      local _tmpPM = createD( "DPanel", _yrp_appearance.left, ScrH2() - ctr( 30 ), ctr( 80 ), ctr( 10 ), ScrH2() - ctr( 30+80 ) )
      _tmpPM.cur = _pmid
      _tmpPM.max = #_pms
      _tmpPM.name = lang_string( "appearance" )
      function _tmpPM:Paint( pw, ph )
        surfacePanel( self, pw, ph )
        draw.SimpleTextOutlined( self.name .. " (" .. _tmpPM.cur .. "/" .. _tmpPM.max .. ")", "DermaDefault", ctr( 60 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
      end

      local _tmpPMUp = createD( "DButton", _tmpPM, ctr( 50 ), ctr( 80/2 - 2 ), ctr( 1 ), ctr( 1 ) )
      _tmpPMUp:SetText( "" )
      function _tmpPMUp:Paint( pw, ph )
        if _tmpPM.cur >= _tmpPM.max then

        else
          surfaceButton( self, pw, ph, "↑" )
        end
      end
      function _tmpPMUp:DoClick()
        if _tmpPM.cur < _tmpPM.max then
          _tmpPM.cur = _tmpPM.cur + 1
        end
        net.Start( "inv_pm_up" )
          net.WriteInt( _tmpPM.cur, 16 )
        net.SendToServer()
        _appe.r.pm.Entity:SetModel( _pms[_tmpPM.cur] )
      end

      local _tmpPMDo = createD( "DButton", _tmpPM, ctr( 50 ), ctr( 80/2 - 2), ctr( 1 ), ctr( 1+40 ) )
      _tmpPMDo:SetText( "" )
      function _tmpPMDo:Paint( pw, ph )
        if _tmpPM.cur > 1 then
          surfaceButton( self, pw, ph, "↓" )
        end
      end
      function _tmpPMDo:DoClick()
        if _tmpPM.cur > 1 then
          _tmpPM.cur = _tmpPM.cur - 1
        end
        net.Start( "inv_pm_do" )
          net.WriteInt( _tmpPM.cur, 16 )
        net.SendToServer()
        _appe.r.pm.Entity:SetModel( _pms[_tmpPM.cur] )
      end

      --[[ Skin changing ]]--
      _tbl.bgs = _appe.r.pm.Entity:GetBodyGroups()

      local _tmpSkin = createD( "DPanel", _yrp_appearance.left, ScrH2() - ctr( 30 ), ctr( 80 ), ctr( 10 ), ScrH2() - ctr( 30 ) )
      _tmpSkin.cur = _appe.r.pm.Entity:GetSkin()
      _tmpSkin.max = _appe.r.pm.Entity:SkinCount()
      _tmpSkin.name = lang_string( "skin" )
      function _tmpSkin:Paint( pw, ph )
        surfacePanel( self, pw, ph )
        draw.SimpleTextOutlined( self.name .. " (" .. _tmpSkin.cur+1 .. "/" .. _tmpSkin.max .. ")", "DermaDefault", ctr( 60 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
      end

      local _tmpSkinUp = createD( "DButton", _tmpSkin, ctr( 50 ), ctr( 80/2 - 2 ), ctr( 1 ), ctr( 1 ) )
      _tmpSkinUp:SetText( "" )
      function _tmpSkinUp:Paint( pw, ph )
        if _tmpSkin.cur >= _tmpSkin.max-1 then

        else
          surfaceButton( self, pw, ph, "↑" )
        end
      end
      function _tmpSkinUp:DoClick()
        if _tmpSkin.cur < _tmpSkin.max-1 then
          _tmpSkin.cur = _tmpSkin.cur + 1
        end
        net.Start( "inv_skin_up" )
          net.WriteInt( _tmpSkin.cur, 16 )
        net.SendToServer()
        _appe.r.pm.Entity:SetSkin( _tmpSkin.cur )
      end

      local _tmpSkinDo = createD( "DButton", _tmpSkin, ctr( 50 ), ctr( 80/2 - 2), ctr( 1 ), ctr( 1+40 ) )
      _tmpSkinDo:SetText( "" )
      function _tmpSkinDo:Paint( pw, ph )
        if _tmpSkin.cur > 0 then
          surfaceButton( self, pw, ph, "↓" )
        end
      end
      function _tmpSkinDo:DoClick()
        if _tmpSkin.cur > 0 then
          _tmpSkin.cur = _tmpSkin.cur - 1
        end
        net.Start( "inv_skin_do" )
          net.WriteInt( _tmpSkin.cur, 16 )
        net.SendToServer()
        if ea( _appe.r.pm.Entity ) then
          _appe.r.pm.Entity:SetSkin( _tmpSkin.cur )
        end
      end

      -- Bodygroups changing
      for k, v in pairs( _tbl.bgs ) do
        if k <= 8 then
          _appe.r.pm.Entity:SetBodygroup( k-1, _cbg[k])
          local _height = 80
          local _tmpBg = createD( "DPanel", _yrp_appearance.left, ScrH2() - ctr( 30 ), ctr( _height ), ctr( 10 ), ScrH2() - ctr( 30 ) + (k) * ctr( _height+2 ) )
          _tmpBg.name = v.name
          _tmpBg.max = v.num
          _tmpBg.cur = _cbg[k]
          _tmpBg.id = v.id
          function _tmpBg:Paint( pw, ph )
            surfacePanel( self, pw, ph )
            draw.SimpleTextOutlined( self.name .. " (" .. _tmpBg.cur+1 .. "/" .. _tmpBg.max .. ")", "DermaDefault", ctr( 60 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
          end
          _tmpBgUp = createD( "DButton", _tmpBg, ctr( 50 ), ctr( _height/2 - 2 ), ctr( 1 ), ctr( 1 ) )
          _tmpBgUp:SetText( "" )
          function _tmpBgUp:Paint( pw, ph )
            if _tmpBg.cur >= _tmpBg.max-1 then

            else
              surfaceButton( self, pw, ph, "↑" )
            end
          end
          function _tmpBgUp:DoClick()
            if _tmpBg.cur < _tmpBg.max-1 then
              _tmpBg.cur = _tmpBg.cur + 1
            end
            net.Start( "inv_bg_up" )
              net.WriteInt( _tmpBg.cur, 16 )
              net.WriteInt( _tmpBg.id, 16 )
            net.SendToServer()
            _appe.r.pm.Entity:SetBodygroup( _tmpBg.id, _tmpBg.cur )
          end

          _tmpBgDo = createD( "DButton", _tmpBg, ctr( 50 ), ctr( _height/2 - 2 ), ctr( 1 ), ctr( _height/2 - 1 ) )
          _tmpBgDo:SetText( "" )
          function _tmpBgDo:Paint( pw, ph )
            if _tmpBg.cur > 0 then
              surfaceButton( self, pw, ph, "↓" )
            else

            end
          end
          function _tmpBgDo:DoClick()
            if _tmpBg.cur > 0 then
              _tmpBg.cur = _tmpBg.cur - 1
            end
            net.Start( "inv_bg_do" )
              net.WriteInt( _tmpBg.cur, 16 )
              net.WriteInt( _tmpBg.id, 16 )
            net.SendToServer()
            _appe.r.pm.Entity:SetBodygroup( _tmpBg.id, _tmpBg.cur )
          end
        end
      end
    end
  end
end)

function toggleAppearanceMenu()
  if isNoMenuOpen() then
    open_appearance()
  else
    close_appearance()
  end
end

function close_appearance()
  if _yrp_appearance.window != nil then
    closeMenu()
    _yrp_appearance.window:Remove()
    if _yrp_appearance.drop_panel != nil then
      _yrp_appearance.drop_panel:Remove()
    end
    _yrp_appearance.window = nil
  end
end

net.Receive( "openAM", function( len )
  toggleAppearanceMenu()
end)

function open_appearance()
  openMenu()

  local ply = LocalPlayer()

  _yrp_appearance.window = createD( "DFrame", nil, BScrW() - ctr( 100 ), ScrH(), 0, 0 )
  _yrp_appearance.window:SetTitle( "" )
  _yrp_appearance.window:Center()
  _yrp_appearance.window:SetDraggable( false )
  _yrp_appearance.window:ShowCloseButton( true )
  _yrp_appearance.window:SetSizable( true )
  function _yrp_appearance.window:OnClose()
    _yrp_appearance.window:Remove()
  end
  function _yrp_appearance.window:Paint( pw, ph )
    surfaceWindow( self, pw, ph, lang_string( "appearance" ) .. " - " .. lang_string( "menu" ) .. " [PROTOTYPE]" )
  end

  _yrp_appearance.left = createD( "DPanel", _yrp_appearance.window, BScrW() - ctr( 100 ), ScrH() - ctr( 200 ), 0, ctr( 100 ) )
  function _yrp_appearance.left:Paint( pw, ph )
    --surfacePanel( self, pw, ph )
    --paintBr( pw, ph, Color( 255, 0, 0, 255 ))
  end

  if ply:GetNWBool( "bool_appearance_system", false ) then
    net.Start( "get_menu_bodygroups" )
    net.SendToServer()
  else
    function _yrp_appearance.left:Paint( pw, ph )
      surfacePanel( self, pw, ph, lang_string( "disabled" ) )
    end
  end

  _yrp_appearance.window:MakePopup()
end
