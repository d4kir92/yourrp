--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function GM:InitPostEntity()
  printGM( "note", "InitPostEntity()" )

  timer.Simple( 2, function()
    check_map_doors()
  end)

  timer.Simple( 4, function()
    get_map_coords()
  end)
end
