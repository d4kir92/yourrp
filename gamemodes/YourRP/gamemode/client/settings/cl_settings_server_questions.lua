//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_server_questions.lua

function tabServerQuestions( sheet )
  local ply = LocalPlayer()

  local sv_questionPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( "Questions", sv_questionPanel, "icon16/user_comment.png" )
  function sv_questionPanel:Paint()
    //draw.RoundedBox( 4, 0, 0, sv_questionPanel:GetWide(), sv_questionPanel:GetTall(), yrpsettings.color.panel )
    draw.SimpleText( "Questions (NOT AVAILABLE AT THE MOMENT: Is in work)", "SettingsNormal", calculateToResu( 5 + 30 + 10 ), calculateToResu( 10 + 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Question", "SettingsNormal", calculateToResu( 5 + 30 + 10 + 400 ), calculateToResu( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Right Answer", "SettingsNormal", calculateToResu( 5 + 30 + 10 + 800 + 10 + 150 ), calculateToResu( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Wrong Answer", "SettingsNormal", calculateToResu( 5 + 30 + 10 + 800 + 300 + 10 + 150 + 10 ), calculateToResu( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local sv_questiontoggle = vgui.Create( "DCheckBox", sv_questionPanel )
  sv_questiontoggle:SetSize( calculateToResu( 30 ), calculateToResu( 30 ) )
  sv_questiontoggle:SetPos( calculateToResu( 5 ), calculateToResu( 5 ) )
  function sv_questiontoggle:OnChange( bVal )
    local tmp = 1
    if ( !bVal ) then
      tmp = 0
    end
    net.Start( "setQuestionToggle" )
      net.WriteString( tmp )
      net.WriteString( "0" )
    net.SendToServer()
  end

  net.Start("dbGetQuestions")
  net.SendToServer()

  function createQuestion( pos_y, tmp, toggle, question, a_true, a_false )
    tmp = vgui.Create( "DCheckBox", sv_questionPanel )
    tmp:SetSize( calculateToResu( 30 ), calculateToResu( 30 ) )
    tmp:SetPos( calculateToResu( 5 ), calculateToResu( 45 + pos_y * 70 ) )
    tmp:SetValue( toggle )
    function tmp:OnChange( bVal )
      local tmpChecked = 1
      if ( !bVal ) then
        tmpChecked = 0
      end
      net.Start( "setQuestionToggle" )
        net.WriteString( tmpChecked )
        net.WriteString( pos_y )
      net.SendToServer()
    end

    tmp.question = vgui.Create( "DTextEntry", sv_questionPanel )
    tmp.question:SetSize( calculateToResu( 800 ), calculateToResu( 60 ) )
    tmp.question:SetPos( calculateToResu( 5 + 30 + 10 ), calculateToResu( 30 + pos_y * 70 ) )
    tmp.question:SetText( question )
    function tmp.question:OnChange()
      net.Start( "updateQuestions" )
        net.WriteString( "question" )
        net.WriteString( tmp.question:GetText() )
        net.WriteString( pos_y )
      net.SendToServer()
    end

    tmp.answer_true = vgui.Create( "DTextEntry", sv_questionPanel )
    tmp.answer_true:SetSize( calculateToResu( 300 ), calculateToResu( 60 ) )
    tmp.answer_true:SetPos( calculateToResu( 5 + 30 + 10 + 800 + 10 ), calculateToResu( 30 + pos_y * 70 ) )
    tmp.answer_true:SetText( a_true )
    function tmp.answer_true:OnChange()
      net.Start( "updateQuestions" )
        net.WriteString( "a_true" )
        net.WriteString( tmp.answer_true:GetText() )
        net.WriteString( pos_y )
      net.SendToServer()
    end

    tmp.answer_false = vgui.Create( "DTextEntry", sv_questionPanel )
    tmp.answer_false:SetSize( calculateToResu( 300 ), calculateToResu( 60 ) )
    tmp.answer_false:SetPos( calculateToResu( 5 + 30 + 10 + 800 + 10 + 300 + 10 ), calculateToResu( 30 + pos_y * 70 ) )
    tmp.answer_false:SetText( a_false )
    function tmp.answer_false:OnChange()
      net.Start( "updateQuestions" )
        net.WriteString( "a_false" )
        net.WriteString( tmp.answer_false:GetText() )
        net.WriteString( pos_y )
      net.SendToServer()
    end
  end

  local questions = {}
  net.Receive( "dbGetQuestions", function( len, ply )
    local tmpTable = net.ReadTable()
    for k, v in pairs( tmpTable ) do
      if k == 1 then
        if v.toggle != nil then
          sv_questiontoggle:SetValue( v.toggle )
        end
      end
      if k > 1 then
        if questions[k] == nil then
          createQuestion( k-1, questions[k], v.toggle, v.question, v.a_true, v.a_false )
        end
      end
    end
  end)
end
