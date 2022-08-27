/obj/structure/stalker/ex_act()
	return

/obj/structure/stalker/Crossed(atom/A)
	if(cast_shadow)
		if(isliving(A))
			for(var/obj/shadow/S in vis_contents)
				if(S.anomaly)
					var/mob/living/L = A
					L.dust()

/obj/structure/table/stalker
	smooth = SMOOTH_FALSE
	canSmoothWith = list(/obj/structure/table/stalker)
	flags = NODECONSTRUCT
	pass_flags = LETPASSTHROW

/obj/structure/table/stalker/CanPass(atom/movable/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	if(istype(A, /obj/item))
		return 1

	if(istype(A, /obj/item/projectile))
		if(!anchored)
			return 1
		var/obj/item/projectile/proj = A
		if(proj.firer && Adjacent(proj.firer))
			return 1
		return 0
	else
		return 0

	var/obj/structure/bed/B = A
	if(istype(A, /obj/structure/bed) || B.density)//if it's a bed/chair and is dense or someone is buckled, it will not pass
		return 0

//	if(istype(A, /obj/structure/closet/cardboard))
//		var/obj/structure/closet/cardboard/C = A
//		if(C.move_delay)
//			return 0

//	if(istype(A, /obj/mecha))
//		return 0

	return ..()


/obj/structure/table
	name = "table"
	name_ru = "стол"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/smooth_structures/table.dmi'
	icon_state = "table"
	density = 1
	anchored = 1
	layer = 2.8
	pass_flags = LETPASSTHROW //You can throw objects over this, despite it's density.")
	var/busy = 0
	var/deconstructable = 1
	var/unpassable = 0
	smooth = SMOOTH_TRUE
	var/connections = list("nw0", "ne0", "sw0", "se0")

/obj/structure/table/New()
	..()
	for(var/obj/structure/table/T in src.loc)
		if(T != src)
			qdel(T)
	update_connections(1)
	update_icon()

/obj/structure/table/update_icon()
	overlays.Cut()
	var/image/I

	for(var/i = 1 to 4)
		I = image(icon, "[icon_state][connections[i]]", dir = 1<<(i-1))
//		I.color = base_color
		overlays += I

	return

/obj/structure/table/attack_paw(mob/user)
	attack_hand(user)

/obj/structure/table/attack_hand(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	..()

/obj/structure/table/attackby(obj/item/I, mob/user, params)
	if(!(I.flags & ABSTRACT)) //rip more parems rip in peace ;_;
		if(user.drop_item())
			I.loc = loc
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			I.pixel_x = Clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			I.pixel_y = Clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)


/obj/structure/table/proc/update_connections(propagate = 0)
	var/list/connection_dirs = list()
	var/list/blocked_dirs = list()

	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	for(var/obj/structure/table/T in orange(src, 1))
		if(!T.can_connect()) continue
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs) continue
		if(icon == T.icon)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	connections = dirs_to_corner_states(connection_dirs)

/obj/structure/table/proc/can_connect()
	return TRUE


/obj/structure/table/stalker/wood
	desc = "A plain wooden scratched table."
	desc_ru = "Обычный деревянный слегка пошарпанный стол."
	icon = 'icons/stalker/structure/stol_stalker.dmi'
	icon_state = "stol"
//	deconstructable = 0
	smooth = SMOOTH_FALSE
	canSmoothWith = list(/obj/structure/table/stalker/wood)

/obj/structure/table/stalker/wood/bar
	desc = "Handmade bar counter."
	desc_ru = "Самодельная барная стойка."
	icon = 'icons/stalker/structure/stol_stalker_bar.dmi'
	icon_state = "stol"
	smooth = SMOOTH_FALSE
	canSmoothWith = list(/obj/structure/table/stalker/wood/bar)

/obj/structure/table/stalker/wood/bar100rentgen
	desc = "Quality bar counter."
	desc_ru = "Качественная барная стойка."
	icon = 'icons/stalker/structure/bartables.dmi'
	icon_state = "table"
	smooth = SMOOTH_FALSE

/obj/structure/table/stalker/wood/bar100rentgen/can_connect()
	return FALSE

/obj/structure/stalker/okno
	name = "Window"
	desc = "Old wooden window."
	desc_ru = "Старое деревянное окно."
	icon = 'icons/stalker/structure/decor2.dmi'
	pass_flags = LETPASSTHROW
	density = 1
	opacity = 0
	can_storage = 1
	max_w_class = 4
	max_slots = 2
	var/proj_pass_rate = 50

/obj/structure/stalker/okno/Initialize()
	..()
	if(!opacity && isturf(loc))
		spawn(100)
			var/turf/T = loc
			T.has_opaque_atom = 0

/obj/structure/stalker/okno/CanPass(atom/movable/A, turf/T)
	if(istype(A, /obj/item/projectile))
		var/obj/item/projectile/proj = A
		if(proj.firer && Adjacent(proj.firer))
			return 1
		if(proj.def_zone == "r_leg" || proj.def_zone == "l_leg") //|| proj.def_zone == "groin")
			return 0
		if(proj.def_zone == "head" || proj.def_zone == "eyes" || proj.def_zone == "face" || proj.def_zone == "mouth")
			return 1
		if(prob(proj_pass_rate))
			return 1
		return 0
	else if(istype(A, /obj/item))
		return 1

	return 0

/obj/structure/stalker/okno/army
	icon_state = "window_army"

/obj/structure/stalker/okno/farm
	icon_state = "window_farm"

/obj/structure/stalker/okno/one
	icon_state = "window_one"

/obj/structure/stalker/okno/double1
	icon_state = "window_two1"

/obj/structure/stalker/okno/double1/barricaded
	icon_state = "window_two1_barricaded"
	opacity = 1

/obj/structure/stalker/okno/double2
	icon_state = "window_two2"

/obj/structure/stalker/okno/double2/barricaded
	icon_state = "window_two2_barricaded"
	opacity = 1

/obj/structure/stalker/okno/Initialize()
	..()
	var/turf/T = get_turf(src)
	T.set_opacity(opacity)

/obj/structure/stalker/shina
	name = "tire"
	desc = "The old shabby tire."
	desc_ru = "Старая потертая шина."
	density = 0
	icon = 'icons/stalker/structure/decor2.dmi'
	icon_state = "shina"

/obj/structure/stalker/shina/gruda
	desc_ru = "Груда старых шин."
	density = 1

/obj/structure/stalker/shina/gruda/two
	icon_state = "shina2"

/obj/structure/stalker/shina/gruda/two/a
	icon_state = "shina2a"

/obj/structure/stalker/shina/gruda/two/b
	icon_state = "shina2b"

/obj/structure/stalker/shina/gruda/three
	icon_state = "shina3"

/obj/structure/stalker/shina/gruda/three/floor
	icon_state = "shina3a"

/obj/structure/bunker
	icon = 'icons/stalker/structure/bunker.dmi'
	density = 1
	anchored = 1


/obj/structure/door
	density = 1
	opacity = 1
	anchored = 1
	layer = 6
	var/opened = 0
	var/id = 0
	var/locked = 0

/obj/structure/door/Initialize()
	..()
	if(id)
		name = "[name] #[id]"
		name_ru = "[name_ru] #[id]"

/obj/structure/door/attack_hand(mob/user)
	if(locked)
		user << user.client.select_lang("<span class='warning'>Дверь заперта!</span>", "<span class='warning'>The door is locked!</span>")
		return
	if(flags & IN_PROGRESS)
		return
	flags += IN_PROGRESS
	if(!opened)
		flick("opening", src)
		icon_state = "opened"
		sleep(10)
		density = 0
		opacity = 0
		opened = 1
	else
		flick("closing", src)
		icon_state = "closed"
		sleep(10)
		density = 1
		opacity = 1
		opened = 0
		var/list/turfs = list()
		for(var/i = 0 to 3)
			var/turf/T = get_step(src, 2**i)
			if(!T.density)
				turfs += T
		for(var/mob/M in loc)
			M.Move(pick(turfs))
	flags &= ~IN_PROGRESS


/obj/structure/door/attackby(obj/item/I, mob/user, params)
	if(!Adjacent(user) || user.stat)
		return

	if(istype(I, /obj/item/weapon/key))
		var/obj/item/weapon/key/K = I
		if(!id)
			return

		if(id == K.id)
			if(locked)
				locked = 0
				user << user.client.select_lang("<span class='notice'>Ты отпер дверь</span>", "<span class='notice'>The unlocked the door!</span>")
			else
				locked = 1
				user << user.client.select_lang("<span class='notice'>Ты запер дверь</span>", "<span class='notice'>The locked the door!</span>")
		else
			user << user.client.select_lang("<span class='warning'>Ключ не подходит!</span>", "<span class='warning'>The key is not from that door!</span>")
		return
	..()


/obj/structure/door/hotel
	name = "door"
	name_ru = "дверь"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/door.dmi'
	icon_state = "opened"
	opened = 1
	density = 0
	opacity = 0


/obj/item/weapon/key
	name = "key"
	name_ru = "ключ"
	desc = ""
	desc_ru = ""
	w_class = 1
	weight = 0.01
	var/id = 0

/obj/item/weapon/key/hotel
	icon = 'icons/stalker/items.dmi'
	icon_state = "hotelkey"
	icon_ground = "hotelkey_ground"