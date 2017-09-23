--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_resources.lua

printGMPre( "db", "Loading Resources" )

--resource.AddWorkshop( "1114204152" )

--##############################################################################
--fonts
resource.AddSingleFile( "resource/fonts/BankGothic_Bold.ttf" )

resource.AddSingleFile( "resource/fonts/Roboto-Bold.ttf" )
resource.AddSingleFile( "resource/fonts/Roboto-Light.ttf" )
resource.AddSingleFile( "resource/fonts/Roboto-Medium.ttf" )
resource.AddSingleFile( "resource/fonts/Roboto-Regular.ttf" )
resource.AddSingleFile( "resource/fonts/Roboto-Thin.ttf" )
--##############################################################################

--##############################################################################
--materials
resource.AddFile( "materials/models/yrp/yrp_grey.vmt" )
resource.AddFile( "materials/models/yrp/yrp_white.vmt" )
resource.AddFile( "materials/vgui/entities/yrp_key.vmt" )
resource.AddFile( "materials/yrp/yrp_grey.vmt" )
resource.AddFile( "materials/yrp/yrp_icon.vmt" )
resource.AddFile( "materials/yrp/yrp_white.vmt" )
--##############################################################################

--##############################################################################
--models
resource.AddFile( "models/yrp/yrp_atm.mdl" )
--##############################################################################

printGM( "db", "Loaded Resources" )
printGMPos()
