/obj/effect/decal/warning_stripes
	icon = 'icons/stalker/effects/warning_stripes.dmi'
	layer = 2.5
	pixel_x = 0
	pixel_y = 0

/obj/effect/decal/warning_stripes/cross
	icon_state = "cross"

/obj/effect/decal/warning_stripes/cross/New()
	..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/effect/decal/warning_stripes/bordur
	layer = 2.21

/obj/effect/decal/warning_stripes/bordur/side/north
	icon_state = "road_b5"
	pixel_y = 5

/obj/effect/decal/warning_stripes/bordur/side/south
	icon_state = "road_b6"
	pixel_y = -5

/obj/effect/decal/warning_stripes/bordur/side/west
	icon_state = "road_b7"
	pixel_x = -5

/obj/effect/decal/warning_stripes/bordur/side/east
	icon_state = "road_b8"
	pixel_x = 5

/obj/effect/decal/warning_stripes/bordur/corner/one
	icon_state = "road_b3"

/obj/effect/decal/warning_stripes/bordur/corner/two
	icon_state = "road_b2"

/obj/effect/decal/warning_stripes/bordur/corner/three
	icon_state = "road_b1"

/obj/effect/decal/warning_stripes/bordur/corner/four
	icon_state = "road_b4"

/obj/effect/decal/warning_stripes/hatch
	icon_state = "hatch"
	layer = 2.2

/obj/effect/decal/warning_stripes/hatch/broken
	icon_state = "hatchbroken"

/obj/effect/decal/warning_stripes/pits
	icon = 'icons/stalker/effects/asphalt_pits.dmi'
	icon_state = "pit_1"

/obj/effect/decal/warning_stripes/Initialize()
	. = ..()

	loc.overlays += image(src.icon, src, src.icon_state, src.dir)
	qdel(src)

/obj/effect/stalker/pipes
	name = "pipe"
	icon = 'icons/stalker/effects/mining.dmi'
	desc = "Old rusty under-ceiling pipes."
	desc_ru = "Старые ржавые подпотолочные трубы."
	layer = 6

/obj/effect/decal/warning_stripes/small_things
	icon = 'icons/stalker/structure/decor3.dmi'

/obj/effect/decal/warning_stripes/small_things/shifer
	name = "shifer"
	icon_state = "shifer"
	layer = 3.1

/obj/effect/decal/warning_stripes/small_things/cigs_trash
	name = "cigs trash"
	icon_state = "cigs_trash"
	layer = 2.23

/obj/effect/decal/warning_stripes/small_things/chair_trash
	name = "broken chair"
	icon_state = "chair_trash"
	layer = 2.24


/obj/effect/stalker/shadows
	anchored = 1
	density = 0

/obj/effect/stalker/shadows/New()
	name = null

/obj/effect/stalker/shadows/rails
	name = "rail shadow"
	icon = 'icons/stalker/effects/rail_shadows.dmi'
	layer = 2.29

/obj/effect/stalker/shadows/rails/r1
	icon_state = "1"

/obj/effect/stalker/shadows/rails/r2
	icon_state = "2"

/obj/effect/stalker/shadows/rails/r3
	icon_state = "3"

/obj/effect/stalker/shadows/rails/r4
	icon_state = "4"

/obj/effect/stalker/shadows/rails/r5
	icon_state = "5"

/obj/effect/stalker/shadows/cave
	name = "cave shadow"
	icon = 'icons/stalker/effects/cave_shadows.dmi'
	layer = 3.2

/obj/effect/stalker/shadows/cave/c1
	icon_state = "1"

/obj/effect/stalker/shadows/cave/c2
	icon_state = "2"

/obj/effect/stalker/shadows/cave/c3
	icon_state = "3"

/obj/effect/stalker/shadows/cave/light/c1
	icon_state = "1l"

/obj/effect/stalker/shadows/cave/light/c2
	icon_state = "2l"

/obj/effect/stalker/shadows/cave/light/c3
	icon_state = "3l"

/obj/effect/stalker/rain
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "rain"
	name = null
	layer = 5.1
	anchored = 1