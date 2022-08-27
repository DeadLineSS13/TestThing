//This file is just for the necessary /world definition
//Try looking in game/world.dm

/world
	mob = /mob/new_player
	turf = /turf/stalker/floor/digable/grass
	area = /area/stalker
	view = "15x15"
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Ashen Sky"
	fps = 40
#ifdef FIND_REF_NO_CHECK_TICK
	loop_checks = FALSE
#endif

