#define NORTH_EDGING	"north"
#define SOUTH_EDGING	"south"
#define EAST_EDGING		"east"
#define WEST_EDGING		"west"

/turf/simulated/floor/plating/asteroid/snow/lite
	name = "snow"
	name_ru = "снег"
	icon = 'icons/turf/snow.dmi'
	baseturf = /turf/simulated/floor/plating/asteroid/snow
	icon_state = "snow"
	icon_plating = "snow"
	temperature = 293
	slowdown = 4

/obj/structure/grille/stalker
	name = "fence"
	name_ru = "забор"
	icon = 'icons/stalker/structure/structure.dmi'
	icon_state = "fence1"
	density = 1
	anchored = 1
	flags = CONDUCT
	layer = 4.2
	health = 10000000

/obj/structure/grille/stalker/metal
	desc_ru = "Хороший, крепкий железный забор."
	desc = "Strong metal fence."
	name = "fence"
	icon = 'icons/stalker/structure/fence.dmi'
	layer = 6

/obj/structure/grille/stalker/metal/middle
	icon_state = "middle1"

/obj/structure/grille/stalker/metal/middle/New()
	..()
	icon_state = "middle[rand(1, 2)]"

/obj/structure/grille/stalker/metal/left_middle
	icon_state = "left_middle1"

/obj/structure/grille/stalker/metal/left_middle/New()
	..()
	icon_state = "left_middle[rand(1, 3)]"

/obj/structure/grille/stalker/metal/right_middle
	icon_state = "right_middle1"

/obj/structure/grille/stalker/metal/right_middle/New()
	..()
	icon_state = "right_middle[rand(1, 3)]"

/obj/structure/grille/stalker/metal/left_corner
	icon_state = "left_corner1"

/obj/structure/grille/stalker/metal/left_corner/New()
	..()
	icon_state = "left_corner[rand(1, 2)]"

/obj/structure/grille/stalker/metal/left_corner_down
	icon_state = "left_corner_down"

/obj/structure/grille/stalker/metal/right_corner
	icon_state = "right_corner1"

/obj/structure/grille/stalker/metal/right_corner/New()
	..()
	icon_state = "right_corner[rand(1, 2)]"

/obj/structure/grille/stalker/metal/right_corner_down
	icon_state = "right_corner_down"

/obj/structure/grille/stalker/metal/left_corner_up
	icon_state = "left_corner_up1"

/obj/structure/grille/stalker/metal/left_corner_up/New()
	..()
	icon_state = "left_corner_up[rand(1, 2)]"

/obj/structure/grille/stalker/metal/right_corner_up
	icon_state = "right_corner_up1"

/obj/structure/grille/stalker/metal/right_corner_up/New()
	..()
	icon_state = "right_corner_up[rand(1, 2)]"

/obj/structure/grille/stalker/metal/vertical
	icon_state = "vertical"

/obj/structure/grille/stalker/ex_act(severity, target)
	return

/obj/structure/grille/stalker/attack_paw(mob/user)
	return

/obj/structure/grille/stalker/attack_hand(mob/living/user)
	user.do_attack_animation(src)
	return

/obj/structure/grille/stalker/attack_animal(var/mob/living/simple_animal/M)
	M.do_attack_animation(src)
	return

/obj/structure/grille/stalker/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return
	..()
	if((Proj.damage_type != STAMINA)) //Grilles can't be exhausted to death
		return
	return

/obj/structure/grille/stalker/attackby(obj/item/weapon/W, mob/user, params)
	return

/obj/structure/grille/hitby(AM as mob|obj)
	..()
	return

/obj/structure/grille/stalker/wood
	desc = "Хороший, старый деревянный забор."
	icon_state = "zabor_horizontal1"
	density = 1
	opacity = 0
	can_leap_over = 1

/obj/structure/grille/stalker/beton
	icon = 'icons/stalker/beton_zabor.dmi'
	desc = "Слишком крепкий."
	icon_state = "1"
	density = 1
	opacity = 1
	layer = 6.1

/obj/structure/grille/stalker/beton/green
	icon = 'icons/stalker/green_zabor.dmi'
	desc = "Зелённый забор. Лучше, чем серый."
	icon_state = "1"
	layer = 6.1

obj/structure/grille/stalker/beton/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0) return 1
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return 1
	else
		if(istype(mover, /obj/item/projectile) && density)
			return prob(0)
		else
			return !density

/turf/stalker
	name = "stalker turf"
	icon = 'icons/stalker/turfs/grass.dmi'
	var/list/obj/anomaly/triggers = null

/turf/stalker/New()
	..()
	var/area/A = get_area(src)
	if(A.outdoors)
		outdoor = 1

/turf/stalker/Entered(atom/A)
	if(triggers && triggers.len)
		for(var/obj/anomaly/N in triggers)
			N.Activate(A)
	..()

/turf/stalker/Exit(atom/A, newloc)
	if(triggers && triggers.len)
		for(var/obj/anomaly/N in triggers)
			if(isliving(A) && istype(N, /obj/anomaly/natural/gravy/trap))
				var/turf/stalker/T = get_turf(newloc)
				var/obj/anomaly/natural/gravy/trap/trap = N
				if(istype(T, /turf/stalker))
					if((!T.triggers && trap.trapped.len < 2) || (trap.trapped.len < 2 && !T.triggers.Find(trap) && trap.trapped.Find(A)))
						if(prob(50))
							A << "<span class='notice'><i>Тебе так уютно в этом месте, что не хочется уходить, вот бы забрать сюда кого-нибудь еще...</i></span>"
						return FALSE

	return TRUE

/turf/stalker/Exited(atom/A)
	var/turf/stalker/T = get_turf(A)
	if(triggers && triggers.len)
		for(var/obj/anomaly/N in triggers)
			if(!T.triggers || (T.triggers && !T.triggers.Find(N)))
				N.Deactivate(A)

	..()

/turf/stalker/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(H.weakened || H.stunned || H.paralysis || H.sleeping || H.magniting)
			return
		if(H.stat)
			return
		if(!H.Adjacent(src))
			return ..()
		if(H.lying && !H.get_active_held_item())
			if(get_dir(H, src) != NORTH && get_dir(H, src) != SOUTH && get_dir(H, src) != WEST && get_dir(H, src) != EAST)
				return ..()
			if(H.flags & IN_PROGRESS)
				return
			H.flags += IN_PROGRESS
			var/time = 10
			if(H.stamina_coef > 1)
				time *= 1*2**(H.stamina_coef)
			if(!do_mob(H, src, time, 1))
				if(H)
					H.flags &= ~IN_PROGRESS
				return
			step_to(H, src)
			H.flags &= ~IN_PROGRESS
			return
	..()


/turf/stalker/floor
	name = "grass"
	name_ru = "трава"
	icon = 'icons/stalker/turfs/grass.dmi'
	icon_state = "grass1"
	layer = TURF_LAYER
	plane = GAME_PLANE
	overlay_priority = 0

/turf/stalker/floor/digable

/turf/stalker/floor/digable/grass
	icon = 'icons/stalker/turfs/zemlya.dmi'
	icon_state = "grass1"

/turf/stalker/floor/digable/grass/New()
	..()
	icon_state = "grass1"

/turf/stalker/floor/digable/transit

/turf/stalker/floor/digable/transit/to_zone
	icon = 'icons/stalker/turfs/zemlya.dmi'
	icon_state = "grass_to_zone"

/turf/stalker/floor/digable/transit/to_zone2
	name = "road"
	name_ru = "дорога"
	icon = 'icons/stalker/turfs/zemlya.dmi'
	icon_state = "road_to_zone"

/turf/stalker/floor/digable/transit/from_zone
	icon = 'icons/stalker/turfs/zemlya.dmi'
	icon_state = "grass_from_zone"

/turf/stalker/floor/digable/transit/from_zone2
	name = "road"
	name_ru = "дорога"
	icon = 'icons/stalker/turfs/zemlya.dmi'
	icon_state = "road_from_zone"

/turf/stalker/floor/digable/grass/with_grass
	icon_state = "grass_with_grass"

/turf/stalker/floor/digable/grass/with_grass/Initialize()
	. = ..()
	new /obj/structure/stalker/flora/grass/forest(src)
	if(prob(50))
		new /obj/structure/stalker/flora/grass/forest(src)


/turf/stalker/floor/digable/grass/dump
	icon = 'icons/stalker/turfs/zemlya.dmi'
	icon_state = "dump_grass1"
/*
/turf/stalker/floor/digable/grass/dump/New()
	icon_state = "dump_grass[rand(1, 3)]"
*/
/turf/stalker/floor/digable/gryaz_rocky
	icon_state = "gryaz_rocky1"

/turf/stalker/floor/digable/gryaz_rocky/New()
	icon_state = "gryaz_rocky[rand(1, 3)]"

/turf/stalker/floor/sidor
	name_ru = "пол"
	name = "floor"
	icon = 'icons/turf/beton.dmi'
	icon_state = "sidorpol"

/turf/stalker/floor/asphalt
	name_ru = "асфальт"
	name = "road"
	icon = 'icons/stalker/turfs/asphalt.dmi'
	icon_state = "road1"
	layer = 2
	overlay_priority = 3
	var/obj/effect/asphalt_pit/AP

GLOBAL_LIST_EMPTY(AsphaltEdgeCache)

/turf/stalker/floor/asphalt/Initialize()
	icon_state = "road[rand(1, 4)]"
	if(!GLOB.AsphaltEdgeCache || !GLOB.AsphaltEdgeCache.len)
		GLOB.AsphaltEdgeCache = list()
		GLOB.AsphaltEdgeCache.len = 10
		GLOB.AsphaltEdgeCache[NORTH] = image('icons/stalker/turfs/asphalt.dmi', "roadn", layer = 2.01)
		GLOB.AsphaltEdgeCache[SOUTH] = image('icons/stalker/turfs/asphalt.dmi', "roads", layer = 2.01)
		GLOB.AsphaltEdgeCache[EAST] = image('icons/stalker/turfs/asphalt.dmi', "roade", layer = 2.01)
		GLOB.AsphaltEdgeCache[WEST] = image('icons/stalker/turfs/asphalt.dmi', "roadw", layer = 2.01)

	spawn(1)
		var/turf/T
		for(var/i = 0, i <= 3, i++)
			if(!get_step(src, 2**i))
				continue
			if(overlay_priority > get_step(src, 2**i).overlay_priority)
				T = get_step(src, 2**i)
				if(T && !istype(T, /turf/stalker/floor/water))
					T.add_overlay(GLOB.AsphaltEdgeCache[2**i])

	if(prob(5))
		AP = new(src)
		AP.icon_state = "pit[rand(1,5)]"
		AP.pixel_x = rand(-8,8)
		AP.pixel_y = rand(-8,8)
		if(prob(1))
			AP.anomaly = 1
			AP.icon_state = "[AP.icon_state]_water"
	..()

/obj/effect/asphalt_pit
	name = "pit"
	name_ru = "яма"
	icon = 'icons/stalker/effects/asphalt_pits.dmi'
	icon_state = "pit"
	layer = 2.1
	var/anomaly = 0

/obj/effect/asphalt_pit/Crossed(atom/A)
	if(!anomaly)
		return ..()

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.sticky_pit = 1
		H.pixel_x = pixel_x
		H.pixel_y = pixel_y+12

/turf/stalker/floor/tropa
	name_ru = "тропа"
	name = "road"
	icon = 'icons/stalker/turfs/tropa.dmi'
	icon_state = "road1"
	layer = 2
	overlay_priority = 2

GLOBAL_LIST_EMPTY(TropaEdgeCache)

/turf/stalker/floor/tropa/New()
	if(!GLOB.TropaEdgeCache || !GLOB.TropaEdgeCache.len)
		GLOB.TropaEdgeCache = list()
		GLOB.TropaEdgeCache.len = 10
		GLOB.TropaEdgeCache[NORTH] = image('icons/stalker/turfs/tropa.dmi', "tropa_side_n", layer = 2.01)
		GLOB.TropaEdgeCache[SOUTH] = image('icons/stalker/turfs/tropa.dmi', "tropa_side_s", layer = 2.01)
		GLOB.TropaEdgeCache[EAST] = image('icons/stalker/turfs/tropa.dmi', "tropa_side_e", layer = 2.01)
		GLOB.TropaEdgeCache[WEST] = image('icons/stalker/turfs/tropa.dmi', "tropa_side_w", layer = 2.01)

	spawn(1)
		var/turf/T
		for(var/i = 0, i <= 3, i++)
			if(!get_step(src, 2**i))
				continue
			if(overlay_priority > get_step(src, 2**i).overlay_priority)
				T = get_step(src, 2**i)
				if(T)
					T.overlays += GLOB.TropaEdgeCache[2**i]
	return

/turf/stalker/floor/road
	name_ru = "дорога"
	name = "road"
	icon = 'icons/stalker/turfs/building_road.dmi'
	icon_state = "road2"
	layer = 2
	overlay_priority = 4
/*
var/global/list/WhiteRoadCache

/turf/stalker/floor/road/New()
	switch(rand(1, 100))
		if(1 to 65)
			icon_state = "road2"
		if(66 to 85)
			icon_state = "road1"
		if(86 to 90)
			icon_state = "road3"
		if(91 to 95)
			icon_state = "road4"
		if(96 to 100)
			icon_state = "road5"

	if(!WhiteRoadCache || !WhiteRoadCache.len)
		WhiteRoadCache = list()
		WhiteRoadCache.len = 10
		WhiteRoadCache[NORTH] = image('icons/stalker/effects/warning_stripes.dmi', "road_b5", layer = 2.02)
		WhiteRoadCache[SOUTH] = image('icons/stalker/effects/warning_stripes.dmi', "road_b6", layer = 2.02)
		WhiteRoadCache[EAST] = image('icons/stalker/effects/warning_stripes.dmi', "road_b8", layer = 2.02)
		WhiteRoadCache[WEST] = image('icons/stalker/effects/warning_stripes.dmi', "road_b7", layer = 2.02)

	spawn(1)
		var/turf/T
		for(var/i = 0, i <= 3, i++)
			if(!get_step(src, 2**i))
				continue
			if(overlay_priority > get_step(src, 2**i).overlay_priority)
				T = get_step(src, 2**i)
				if(T)
					var/image/I = WhiteRoadCache[2**i]
					switch(2**i)
						if(1)
							I.pixel_y = 5
						if(2)
							I.pixel_y = -5
						if(4)
							I.pixel_x = 5
						if(8)
							I.pixel_x = -5
					add_overlay(I)

	return
*/
/turf/stalker/floor/gryaz
	name_ru = "земля"
	name = "dirt"
	icon = 'icons/stalker/turfs/zemlya.dmi'
	icon_state = "gryaz1"
	layer = 2.01
	overlay_priority = 5

GLOBAL_LIST_EMPTY(GryazEdgeCache)

/turf/stalker/floor/gryaz/New()
	icon_state = "gryaz[rand(1, 3)]"
	if(!GLOB.GryazEdgeCache || !GLOB.GryazEdgeCache.len)
		GLOB.GryazEdgeCache = list()
		GLOB.GryazEdgeCache.len = 10
		GLOB.GryazEdgeCache[NORTH] = image('icons/stalker/turfs/zemlya.dmi', "gryaz_side_n", layer = 2.01)
		GLOB.GryazEdgeCache[SOUTH] = image('icons/stalker/turfs/zemlya.dmi', "gryaz_side_s", layer = 2.01)
		GLOB.GryazEdgeCache[EAST] = image('icons/stalker/turfs/zemlya.dmi', "gryaz_side_e", layer = 2.01)
		GLOB.GryazEdgeCache[WEST] = image('icons/stalker/turfs/zemlya.dmi', "gryaz_side_w", layer = 2.01)
		GLOB.GryazEdgeCache[NORTHEAST] = image('icons/stalker/turfs/zemlya.dmi', "gr5", layer = 2.01)
		GLOB.GryazEdgeCache[NORTHWEST] = image('icons/stalker/turfs/zemlya.dmi', "gr6", layer = 2.01)
		GLOB.GryazEdgeCache[SOUTHEAST] = image('icons/stalker/turfs/zemlya.dmi', "gr8", layer = 2.01)
		GLOB.GryazEdgeCache[SOUTHWEST] = image('icons/stalker/turfs/zemlya.dmi', "gr7", layer = 2.01)

	spawn(1)
		var/turf/stalker/T
		for(var/i = 0, i <= 3, i++)
			if(!get_step(src, 2**i))
				continue
			if(overlay_priority > get_step(src, 2**i).overlay_priority)
				T = get_step(src, 2**i)
				if(T)
					T.overlays += GLOB.GryazEdgeCache[2**i]
		if(overlay_priority > get_step(src, NORTHEAST).overlay_priority)
			T = get_step(src, NORTHEAST)
			T.add_overlay(GLOB.GryazEdgeCache[NORTHEAST])
		if(overlay_priority > get_step(src, NORTHWEST).overlay_priority)
			T = get_step(src, NORTHWEST)
			T.add_overlay(GLOB.GryazEdgeCache[NORTHWEST])
		if(overlay_priority > get_step(src, SOUTHEAST).overlay_priority)
			T = get_step(src, SOUTHEAST)
			T.add_overlay(GLOB.GryazEdgeCache[SOUTHEAST])
		if(overlay_priority > get_step(src, SOUTHWEST).overlay_priority)
			T = get_step(src, SOUTHWEST)
			T.add_overlay(GLOB.GryazEdgeCache[SOUTHWEST])

	return

/turf/stalker/floor/gryaz/gryaz2
	icon_state = "gryaz2"

/turf/stalker/floor/gryaz/gryaz3
	icon_state = "gryaz3"

/obj/structure/stalker/rails
	name = "rails"
	name_ru = "рельсы"
	icon = 'icons/stalker/rails.dmi'
	icon_state = "sp"
	layer = 2.01
	anchored = 1
	density = 0
	opacity = 0

/turf/stalker/floor/plasteel
	name = "floor"
	name_ru = "пол"
	icon = 'icons/stalker/turfs/floor.dmi'

/turf/stalker/floor/plasteel/plita
	icon_state = "plita1"

/turf/stalker/floor/plasteel/plita/New()
	icon_state = "plita[rand(1, 4)]"

/turf/stalker/floor/plasteel/plitochka
	icon_state = "plitka1"

/turf/stalker/floor/plasteel/plitochka/New()
	icon_state = "plitka[rand(1, 7)]"

/turf/stalker/floor/plasteel/plitka
	icon_state = "plitka_old1"

/turf/stalker/floor/plasteel/plitka/New()
	icon_state = "plitka_old[rand(1, 8)]"

/turf/stalker/floor/plasteel/plit
	icon_state = "plit"

/turf/stalker/floor/plasteel/plitkasoviet
	icon_state = "soviet"

/turf/stalker/floor/plasteel/chess_plitka
	icon_state = "chess_plitka1"

/turf/stalker/floor/plasteel/chess_plitka/New()
	icon_state = "chess_plitka[rand(1, 4)]"

/turf/stalker/floor/plasteel/orange_plitka
	icon_state = "orange_plitka1"

/turf/stalker/floor/plasteel/orange_plitka/New()
	icon_state = "orange_plitka[rand(1, 4)]"

/turf/stalker/floor/water
	name = "water"
	name_ru = "вода"
	icon = 'icons/stalker/water.dmi'
	icon_state = "water"
	layer = TURF_LAYER
	overlay_priority = 5
	slowdown = 4.5
	var/busy = 0

/turf/stalker/floor/water/attack_hand(mob/living/user)
	if(!user || !istype(user))
		return
	if(!iscarbon(user))
		return
	if(!Adjacent(user))
		return

	if(busy)
		user << "<span class='notice'>Someone's already washing here.</span>"
		return
	var/selected_area = parse_zone(user.zone_selected)
	var/washing_face = 0
	if(selected_area in list("head", "mouth", "eyes"))
		washing_face = 1
	user.direct_visible_message("<span class='notice'>DOER start washing their [washing_face ? "face" : "hands"]...</span>",\
								"<span class='notice'>You start washing your [washing_face ? "face" : "hands"]...</span>",\
								"<span class='notice'>DOER начал мыть [washing_face ? "лицо" : "руки"]...</span>",\
								"<span class='notice'>Ты начал мыть [washing_face ? "лицо" : "руки"]...</span>","notice",user)
	busy = 1

	if(!do_after(user, 40, target = src))
		busy = 0
		return

	busy = 0

	user.direct_visible_message("<span class='notice'>DOER washes their [washing_face ? "face" : "hands"] using [src].</span>",\
								"<span class='notice'>You wash your [washing_face ? "face" : "hands"] using [src].</span>",\
								"<span class='notice'>DOER умыл [washing_face ? "face" : "hands"] в [name_ru].</span>", \
								"<span class='notice'>Ты умыл [washing_face ? "face" : "hands"] в [name_ru].</span>","notice",user)
	if(washing_face)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.lip_style = null //Washes off lipstick
			H.lip_color = initial(H.lip_color)
			H.regenerate_icons()
		user.drowsyness -= rand(2,3) //Washing your face wakes you up if you're falling asleep
		user.drowsyness = Clamp(user.drowsyness, 0, INFINITY)
	else
		user.clean_blood()


/turf/stalker/floor/water/attackby(obj/item/O, mob/user, params)
	if(busy)
		user << "<span class='warning'>Someone's already washing here!</span>"
		return

	if(istype(O, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/RG = O
		if(RG.flags & OPENCONTAINER)
			RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
			user << "<span class='notice'>You fill [RG] from [src].</span>"
			return

	var/obj/item/I = O
	if(!I || !istype(I))
		return
	if(I.flags & ABSTRACT) //Abstract items like grabs won't wash. No-drop items will though because it's still technically an item in your hand.
		return

	user << "<span class='notice'>You start washing [I]...</span>"
	busy = 1
	if(!do_after(user, 40, target = src))
		busy = 0
		return
	busy = 0
	O.clean_blood()
	user.direct_visible_message("<span class='notice'>DOER washes [I] using [src].</span>",\
						"<span class='notice'>You wash [I] using [src].</span>",\
						"<span class='notice'>DOER вымыл [I.name_ru] в [name_ru].</span>",\
						"<span class='notice'>Ты вымыл [I.name_ru] в [name_ru].</span>","notice",user)

/turf/stalker/floor/water/Entered(atom/movable/A)
	..()
	if(istype(A, /mob/living))
		var/mob/living/L = A
		L.update_top_overlay('icons/stalker/water.dmi', "water_overlay", "water_overlay_turned")
		if(L.wet < 600)
			L.wet = 600
		if(istype(A, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = A
			if(H.wet)
				H.get_items_wet()
			if(H.shoes)
				H.shoes.clean_blood()
			if(H.fire_stacks)
				H.fire_stacks = 0
				H.ExtinguishMob()

/turf/stalker/floor/water/Exited(atom/movable/A)
	..()
	if(istype(A, /mob/living))
		var/mob/living/L = A
		spawn(1)
			L.update_top_overlay()
		add_overlay(image('icons/stalker/water.dmi', "splash"))
		spawn(8)
			cut_overlays()

//		flick("water_splash_movement", src)

GLOBAL_LIST_EMPTY(WaterEdgeCache)

/turf/stalker/floor/water/New()
	if(!GLOB.WaterEdgeCache || !GLOB.WaterEdgeCache.len)
		GLOB.WaterEdgeCache = list()
		GLOB.WaterEdgeCache.len = 10
		GLOB.WaterEdgeCache[NORTH] = image('icons/stalker/water.dmi', "water_north", layer = 2.02)
		GLOB.WaterEdgeCache[SOUTH] = image('icons/stalker/water.dmi', "water_south", layer = 2.02)
		GLOB.WaterEdgeCache[EAST] = image('icons/stalker/water.dmi', "water_east", layer = 2.02)
		GLOB.WaterEdgeCache[WEST] = image('icons/stalker/water.dmi', "water_west", layer = 2.02)

	spawn(1)
		var/turf/T
		for(var/i = 0, i <= 3, i++)
			if(!get_step(src, 2**i))
				continue
			if(overlay_priority > get_step(src, 2**i).overlay_priority)
				T = get_step(src, 2**i)
				if(T && !istype(T, /turf/stalker/floor/asphalt))
					T.overlays += GLOB.WaterEdgeCache[2**i]
	return

/turf/stalker/floor/water/river
	name = "river"
	icon_state = "river"

/turf/stalker/floor/wood
	icon = 'icons/stalker/turfs/floor.dmi'
	name = "boards"
	name_ru = "доски"

/turf/stalker/floor/wood/brown
	icon_state = "wooden_floor"

/turf/stalker/floor/wood/grey
	icon_state = "wooden_floor2"

/turf/stalker/floor/wood/black
	icon_state = "wooden_floor3"

/turf/stalker/floor/wood/oldgor
	icon_state = "wood1"


/turf/stalker/floor/wood/oldgor/New()
	icon_state = "wood[rand(1, 12)]"


/turf/stalker/floor/wood/oldvert
	icon_state = "woodd1"


/turf/stalker/floor/wood/oldvert/New()
	icon_state = "woodd[rand(1, 12)]"


/turf/stalker/floor/agroprom/beton
	name_ru = "бетонный пол"
	name = "floor"
	icon = 'icons/stalker/turfs/pol_agroprom.dmi'
	icon_state = "beton1"

/turf/stalker/floor/agroprom/beton/New()
	icon_state = "beton[rand(1, 4)]"

/turf/stalker/floor/agroprom/gryaz
	name_ru = "земля"
	name = "dirt"
	icon = 'icons/stalker/turfs/pol_agroprom.dmi'
	icon_state = "gryaz1"

/turf/stalker/floor/agroprom/gryaz/New()
	icon_state = "gryaz[rand(1, 11)]"

/turf/stalker/floor/lattice
	name_ru = "решетчатый пол"
	name = "lattice"
	icon = 'icons/stalker/turfs/floor.dmi'
	icon_state = "lattice"
	overlay_priority = 100

/turf/stalker/floor/exotic
	name_ru = "странный пол"
	name = "exotic floor"
	icon = 'icons/stalker/turfs/floor.dmi'
	overlay_priority = 100

/turf/stalker/floor/exotic/New()
	icon_state = "exotic[rand(1, 4)]"


/turf/stalker/floor/plasteel/plita/orange
	icon_state = "plita_orange"