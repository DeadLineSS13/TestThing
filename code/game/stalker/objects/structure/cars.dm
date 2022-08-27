/obj/structure/stalker/car
	density = 1
	layer = 4.1

/obj/structure/stalker/car/gryzovik
	name = "gruzovik"
	name_ru = "грузовик"
	desc_ru = "Старый советский грузовик со спущенными шинами."
	desc = "Old soviet truck."
	can_storage = 1
	max_w_class = 5
	max_slots = 4

/obj/structure/stalker/car/gryzovik/south
	icon = 'icons/stalker/cars/gruzovik_south.dmi'
	icon_state = "1"

/obj/structure/stalker/car/gryzovik/north
	icon = 'icons/stalker/cars/gruzovik_north.dmi'
	icon_state = "1"

/obj/structure/stalker/car/gryzovik/west
	icon = 'icons/stalker/cars/gruzovik_west.dmi'
	icon_state = "1"

/obj/structure/stalker/car/gryzovik/east
	icon = 'icons/stalker/cars/gruzovik_east.dmi'
	icon_state = "1"

/obj/structure/stalker/car/gryzovik2
	name = "gruzovik"
	name_ru = "грузовик"
	desc = "Старый советский грузовик со спущенными шинами."
	can_storage = 1
	max_w_class = 5
	max_slots = 4

/obj/structure/stalker/car/gryzovik2/south
	icon = 'icons/stalker/cars/gruzovik2_south.dmi'
	icon_state = "1"

/obj/structure/stalker/car/moskvich
	can_storage = 1
	max_w_class = 5
	max_slots = 4

/obj/structure/stalker/car/moskvich/south
	icon = 'icons/stalker/cars/moskvich1_south.dmi'
	icon_state = "1"

/obj/structure/stalker/car/moskvich/south/hyi
	icon = 'icons/stalker/cars/moskvich2_south.dmi'

/obj/structure/stalker/car/moskvich/south/dead
	icon = 'icons/stalker/cars/moskvich3_south.dmi'

/obj/structure/stalker/car/uaz
	name = "UAZ"
	name_ru = "УАЗ"
	icon = 'icons/stalker/cars/uaz-469_south.dmi'
	desc_ru = "Ржавый, но все еще работает. Только бензин закончился."
	desc = "Old UAZ."
	can_storage = 1
	max_w_class = 5
	max_slots = 4

/obj/structure/stalker/car/mi24
	name = "MI24"
	name_ru = "МИ-24"
	icon = 'icons/stalker/cars/mi-24.dmi'

/obj/structure/stalker/car/gryzovik_army
	name = "gruzovik"
	name_ru = "грузовик"
	desc_ru = "Старый советский армейские грузовик со спущенными шинами."
	desc = "Old soviet truck."
	can_storage = 1
	max_w_class = 5
	max_slots = 4

/obj/structure/stalker/car/gryzovik_army/south
	icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	icon_state = "1"

/obj/structure/stalker/car/gryzovik_army/north
	icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	icon_state = "1"

/obj/structure/stalker/car/tractor
	name = "tractor"
	name_ru = "трактор"
	icon = 'icons/stalker/cars/tractor.dmi'
	desc = "Old soviet tractor"
	desc_ru = "Старый советский трактор."

/obj/structure/stalker/car/bmp
	name = "BMP"
	name_ru = "БМП"
	icon = 'icons/stalker/cars/bmp.dmi'
	desc = "BMP"
	desc_ru = "БМП"


/obj/item/army_car_keys
	name = "keys"
	name_ru = "ключи"
	desc = "Army car keys"
	desc_ru = "Ключ от армейского грузовика"
	icon = 'icons/stalker/items.dmi'
	icon_state = "gruzkey"
	icon_ground = "gruzkey_ground"
	w_class = 1
	weight = 0.01

/obj/structure/stalker/car/allow_drop()
	return 0

/obj/structure/stalker/car/army_moveable
	name = "gruzovik"
	name_ru = "грузовик"
	desc_ru = "Старый советский армейский грузовик, всё еще в рабочем состоянии."
	desc = "Old soviet truck."
	icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	layer = 9

	var/can_be_entered = 1
	var/in_move = 0
	var/obj/structure/stalker/car/army_moveable/main_cabin/cabin = null

/obj/structure/stalker/car/army_moveable/main_cabin
	icon_state = "1"

	var/obj/structure/stalker/car/army_moveable/rd
	var/obj/structure/stalker/car/army_moveable/l1
	var/obj/structure/stalker/car/army_moveable/l2
	var/obj/structure/stalker/car/army_moveable/l3
	var/obj/structure/stalker/car/army_moveable/r1
	var/obj/structure/stalker/car/army_moveable/r2
	var/obj/structure/stalker/car/army_moveable/r3

	var/obj/structure/stalker/car/army_moveable/home/hm
	var/obj/structure/stalker/car/army_moveable/first_loc/fl
	var/obj/structure/stalker/car/army_moveable/second_loc/sl
	var/obj/structure/stalker/car/army_moveable/third_loc/tl
	var/obj/structure/stalker/car/army_moveable/transit_to_zone/trtz
	var/obj/structure/stalker/car/army_moveable/transit_from_zone/trfz

	var/current_location = "Home"

	var/list/passengers = list()
	var/mob/living/carbon/human/driver = null

	var/last_throwed = 0


/obj/structure/stalker/car/army_moveable/home
	icon_state = "1"
	invisibility = 101
	density = 0

	Initialize()
		for(var/obj/structure/stalker/car/army_moveable/main_cabin/MC in world)
			MC.hm = src
		..()

/obj/structure/stalker/car/army_moveable/first_loc
	icon_state = "1"
	invisibility = 101
	density = 0

	Initialize()
		for(var/obj/structure/stalker/car/army_moveable/main_cabin/MC in world)
			MC.fl = src
		..()

/obj/structure/stalker/car/army_moveable/second_loc
	icon_state = "1"
	invisibility = 101
	density = 0

	Initialize()
		for(var/obj/structure/stalker/car/army_moveable/main_cabin/MC in world)
			MC.sl = src
		..()

/obj/structure/stalker/car/army_moveable/third_loc
	icon_state = "1"
	invisibility = 101
	density = 0

	Initialize()
		for(var/obj/structure/stalker/car/army_moveable/main_cabin/MC in world)
			MC.tl = src
		..()

/obj/structure/stalker/car/army_moveable/transit_to_zone
	icon_state = "1"
	invisibility = 101
	density = 0

	Initialize()
		for(var/obj/structure/stalker/car/army_moveable/main_cabin/MC in world)
			MC.trtz = src
		..()

/obj/structure/stalker/car/army_moveable/transit_from_zone
	icon_state = "1"
	invisibility = 101
	density = 0

	Initialize()
		for(var/obj/structure/stalker/car/army_moveable/main_cabin/MC in world)
			MC.trfz = src
		..()

/obj/structure/stalker/car/army_moveable/main_cabin/New()
	..()
	rd = new(locate(src.x+1,src.y,src.z))
	rd.icon_state = "2"
	rd.can_be_entered = 0
	rd.cabin = src
	l1 = new(locate(src.x,src.y-1,src.z))
	l1.icon_state = "3"
	l1.cabin = src
	l1.can_be_entered = 0
	l2 = new(locate(src.x,src.y-2,src.z))
	l2.icon_state = "5"
	l2.cabin = src
	l2.can_be_entered = 0
	l3 = new(locate(src.x,src.y-3,src.z))
	l3.icon_state = "7"
	l3.cabin = src
	r1 = new(locate(src.x+1,src.y-1,src.z))
	r1.icon_state = "4"
	r1.cabin = src
	r1.can_be_entered = 0
	r2 = new(locate(src.x+1,src.y-2,	src.z))
	r2.icon_state = "6"
	r2.cabin = src
	r2.can_be_entered = 0
	r3 = new(locate(src.x+1,src.y-3,src.z))
	r3.icon_state = "8"
	r3.cabin = src

/obj/structure/stalker/car/army_moveable/attack_hand(mob/living/carbon/human/user)
	if(cabin && cabin.in_move)
		return

	if(icon == 'icons/stalker/cars/gruzovik_army_south.dmi' && icon_state == "3")
		if(cabin)
			cabin.attack_hand(user)
			return

	if(!can_be_entered)
		return

	if(cabin)
		if(istype(user.get_active_held_item(), /obj/item/army_car_keys) || istype(user.get_inactive_held_item(), /obj/item/army_car_keys))
			switch(alert(user, "Are you sure want to throw everyone out?",, "Yes", "No"))
				if("No")
					return
			cabin.last_throwed = world.time
			for(var/mob/M in cabin.passengers)
				M.loc.attack_hand(M)
			return
		if(cabin.passengers.Find(user))
			if(icon == 'icons/stalker/cars/gruzovik_army_south.dmi')
				user.loc = loc
				user.Move(get_step(src, NORTH), NORTH)
			else
				user.loc = loc
				user.Move(get_step(src, SOUTH), SOUTH)
			cabin.passengers.Remove(user)
			user.screens["fov"].alpha = 255
			user.reset_view(null)
			return
		if(cabin.passengers.len < 10)
			if(cabin.last_throwed + 150 > world.time)
				user << user.client.select_lang("<span class='notice'>Водитель выкинул всех, тебе нужно подождать!</span>","<span class='notice'>The drive threw everyone out, you must wait!</span>")
				return
			if(flags & IN_PROGRESS)
				return

			flags += IN_PROGRESS
			if(!do_after(user, 30, 1, src))
				flags &= ~IN_PROGRESS
				return
			user << "You've entered [src]"
			flags &= ~IN_PROGRESS

			user.loc = src
			cabin.passengers.Add(user)
			user.screens["fov"].alpha = 0
			if(israin)
				for(var/turf/stalker/T in range(7, user.loc))
					if(T.rained)
						var/image/I = image('icons/stalker/structure/decor.dmi', T, "rain", layer = 10)
						if(I)
							if(!user.client.rain_overlays.Find("[T.x],[T.y],[T.z]"))
								user.client.rain_overlays["[T.x],[T.y],[T.z]"] = I
								user.client.images |= user.client.rain_overlays["[T.x],[T.y],[T.z]"]

		else
			user << "There's no more room inside!"
			return

	var/datum/light_source/L
	var/thing
	for(thing in user.light_sources) // Cycle through the light sources on this atom and tell them to update.
		L = thing
		L.source_atom.update_light()

/obj/structure/stalker/car/army_moveable/main_cabin/attack_hand(mob/living/carbon/human/user)
	if(in_move)
		return
	if(!can_be_entered)
		return
	if(!driver)
		if(!istype(user.get_active_held_item(), /obj/item/army_car_keys) && !istype(user.get_inactive_held_item(), /obj/item/army_car_keys))
			user << user.client.select_lang("<span class='warning'>Тебе нужны ключи чтобы залезть в грузовик!</span>","<span class='warning'>You need keys to enter!</span>")
			return
		if(flags & IN_PROGRESS)
			return

		flags += IN_PROGRESS
		if(!do_after(user, 30, 1, src))
			flags &= ~IN_PROGRESS
			return
		user << "You've entered [src]"
		flags &= ~IN_PROGRESS

		user.loc = src
		driver = user
		user.screens["fov"].alpha = 0
		if(icon == 'icons/stalker/cars/gruzovik_army_south.dmi')
			l1.icon_state = "3-man"
		if(israin)
			for(var/turf/stalker/T in range(7, user.loc))
				if(T.rained)
					var/image/I = image('icons/stalker/structure/decor.dmi', T, "rain", layer = 10)
					if(I)
						if(!user.client.rain_overlays.Find("[T.x],[T.y],[T.z]"))
							user.client.rain_overlays["[T.x],[T.y],[T.z]"] = I
							user.client.images |= user.client.rain_overlays["[T.x],[T.y],[T.z]"]

		var/datum/light_source/L
		var/thing
		for(thing in user.light_sources) // Cycle through the light sources on this atom and tell them to update.
			L = thing
			L.source_atom.update_light()
		return
	else if(user != driver)
		user << "There's already someone inside!"
		return
	switch(alert("What do you want to do?",,"Exit","Start driving","Cancel"))
		if("Cancel")
			return
		if("Exit")
			if(icon == 'icons/stalker/cars/gruzovik_army_south.dmi')
				l1.icon_state = "3"
				user.loc = loc
				user.Move(get_step(src, NORTHEAST), NORTHEAST)
			else
				user.loc = loc
				user.Move(get_step(src, SOUTHWEST), SOUTHWEST)
			driver = null
			user.screens["fov"].alpha = 255
			user.reset_view(null)
			return
		if("Start driving")
			if(current_location == "Home")
				move_to(alert("Where do you want to drive?",,"First","Second","Third"))
			else
				move_to("Home")

/obj/structure/stalker/car/army_moveable/main_cabin/proc/move_to(location)
	if(location == current_location)
		usr << "You're already there!"
		return
	switch(location)
		if("Home")
			move_from_zone()
			sleep(600)
			icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
			loc = hm.loc
			icon_state = "1"
			rd.loc = locate(hm.x+1,hm.y,hm.z)
			rd.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
			rd.icon_state = "2"
			l1.loc = locate(hm.x,hm.y-1,hm.z)
			l1.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
			l1.icon_state = "3"
			l2.loc = locate(hm.x,hm.y-2,hm.z)
			l2.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
			l3.loc = locate(hm.x,hm.y-3,hm.z)
			l3.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
			r1.loc = locate(hm.x+1,hm.y-1,hm.z)
			r1.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
			r2.loc = locate(hm.x+1,hm.y-2,hm.z)
			r2.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
			r3.loc = locate(hm.x+1,hm.y-3,hm.z)
			r3.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
		if("First")
			move_to_zone()
			sleep(600)
			loc = locate(fl.x+1,fl.y,fl.z)
			icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			rd.loc = locate(fl.x,fl.y,fl.z)
			rd.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l1.loc = locate(fl.x+1,fl.y+1,fl.z)
			l1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			if(driver)
				l1.icon_state = "3-man"
			l2.loc = locate(fl.x+1,fl.y+2,fl.z)
			l2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l3.loc = locate(fl.x+1,fl.y+3,fl.z)
			l3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l3.icon_state = "7"
			r1.loc = locate(fl.x,fl.y+1,fl.z)
			r1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r2.loc = locate(fl.x,fl.y+2,fl.z)
			r2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r3.loc = locate(fl.x,fl.y+3,fl.z)
			r3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r3.icon_state = "8"
		if("Second")
			move_to_zone()
			sleep(600)
			loc = locate(sl.x+1,sl.y,sl.z)
			icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			rd.loc = locate(sl.x,sl.y,sl.z)
			rd.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l1.loc = locate(sl.x+1,sl.y+1,sl.z)
			l1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			if(driver)
				l1.icon_state = "3-man"
			l2.loc = locate(sl.x+1,sl.y+2,sl.z)
			l2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l3.loc = locate(sl.x+1,sl.y+3,sl.z)
			l3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l3.icon_state = "7"
			r1.loc = locate(sl.x,sl.y+1,sl.z)
			r1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r2.loc = locate(sl.x,sl.y+2,sl.z)
			r2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r3.loc = locate(sl.x,sl.y+3,sl.z)
			r3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r3.icon_state = "8"
		if("Third")
			move_to_zone()
			sleep(600)
			loc = locate(tl.x+1,tl.y,tl.z)
			icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			rd.loc = locate(tl.x,tl.y,tl.z)
			rd.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l1.loc = locate(tl.x+1,tl.y+1,tl.z)
			l1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			if(driver)
				l1.icon_state = "3-man"
			l2.loc = locate(tl.x+1,tl.y+2,tl.z)
			l2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l3.loc = locate(tl.x+1,tl.y+3,tl.z)
			l3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			l3.icon_state = "7"
			r1.loc = locate(tl.x,tl.y+1,tl.z)
			r1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r2.loc = locate(tl.x,tl.y+2,tl.z)
			r2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r3.loc = locate(tl.x,tl.y+3,tl.z)
			r3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
			r3.icon_state = "8"
	if(SSsunlighting.current_step == STEP_NIGHT)
		set_light(0)
		rd.set_light(0)
	current_location = location
	in_move = 0
	for(var/mob/user in passengers + driver)
		user << sound(null,channel = SSchannels.get_reserved_channel(21))
		if(israin)
			for(var/turf/stalker/T in range(7, user.loc))
				if(T.rained)
					var/image/I = image('icons/stalker/structure/decor.dmi', T, "rain", layer = 10)
					if(I)
						if(!user.client.rain_overlays.Find("[T.x],[T.y],[T.z]"))
							user.client.rain_overlays["[T.x],[T.y],[T.z]"] = I
							user.client.images |= user.client.rain_overlays["[T.x],[T.y],[T.z]"]

/obj/structure/stalker/car/army_moveable/main_cabin/proc/move_to_zone()
	if(SSsunlighting.current_step == STEP_NIGHT)
		dir = 1
		rd.dir = 1
		set_light(6, 0.5, angle = 90)
		rd.set_light(6, 0.5, angle = 90)
	in_move = 1
	for(var/mob/user in passengers + driver)
		user << sound('sound/stalker/objects/sounded/car_driving.ogg', 1, SSchannels.get_reserved_channel(21))
	icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	loc = trtz.loc
	rd.loc = locate(trtz.x+1,trtz.y,trtz.z)
	rd.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	l1.loc = locate(trtz.x,trtz.y-1,trtz.z)
	l1.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	l2.loc = locate(trtz.x,trtz.y-2,trtz.z)
	l2.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	l3.loc = locate(trtz.x,trtz.y-3,trtz.z)
	l3.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	l3.icon_state = "7-anim"
	r1.loc = locate(trtz.x+1,trtz.y-1,trtz.z)
	r1.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	r2.loc = locate(trtz.x+1,trtz.y-2,trtz.z)
	r2.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	r3.loc = locate(trtz.x+1,trtz.y-3,trtz.z)
	r3.icon = 'icons/stalker/cars/gruzovik_army_north.dmi'
	r3.icon_state = "8-anim"
	if(israin)
		for(var/mob/user in passengers + driver)
			for(var/turf/stalker/T in range(7, user.loc))
				if(T.rained)
					var/image/I = image('icons/stalker/structure/decor.dmi', T, "rain", layer = 10)
					if(I)
						if(!user.client.rain_overlays.Find("[T.x],[T.y],[T.z]"))
							user.client.rain_overlays["[T.x],[T.y],[T.z]"] = I
							user.client.images |= user.client.rain_overlays["[T.x],[T.y],[T.z]"]

/obj/structure/stalker/car/army_moveable/main_cabin/proc/move_from_zone()
	if(SSsunlighting.current_step == STEP_NIGHT)
		dir = 2
		rd.dir = 2
		set_light(6, 0.5, angle = 90)
		rd.set_light(6, 0.5, angle = 90)
	in_move = 1
	for(var/mob/user in passengers + driver)
		user << sound('sound/stalker/objects/sounded/car_driving.ogg', 1, SSchannels.get_reserved_channel(21))
	icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	icon_state = "1-anim"
	loc = locate(trfz.x+1,trfz.y,trfz.z)
	rd.loc = locate(trfz.x,trfz.y,trfz.z)
	rd.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	rd.icon_state = "2-anim"
	l1.loc = locate(trfz.x+1,trfz.y+1,trfz.z)
	l1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	l2.loc = locate(trfz.x+1,trfz.y+2,trfz.z)
	l2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	l3.loc = locate(trfz.x+1,trfz.y+3,trfz.z)
	l3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	r1.loc = locate(trfz.x,trfz.y+1,trfz.z)
	r1.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	r2.loc = locate(trfz.x,trfz.y+2,trfz.z)
	r2.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	r3.loc = locate(trfz.x,trfz.y+3,trfz.z)
	r3.icon = 'icons/stalker/cars/gruzovik_army_south.dmi'
	if(israin)
		for(var/mob/user in passengers + driver)
			for(var/turf/stalker/T in range(7, user.loc))
				if(T.rained)
					var/image/I = image('icons/stalker/structure/decor.dmi', T, "rain", layer = 10)
					if(I)
						if(!user.client.rain_overlays.Find("[T.x],[T.y],[T.z]"))
							user.client.rain_overlays["[T.x],[T.y],[T.z]"] = I
							user.client.images |= user.client.rain_overlays["[T.x],[T.y],[T.z]"]


/obj/effect/flora_spawner
	name = ""

/obj/effect/flora_spawner/Initialize()
	..()
	for(var/i = 1 to 20)
		spawn(1.8 * i)
			create_flora()

/obj/effect/flora_spawner/proc/create_flora()
	var/obj/structure/stalker/flora/F = new(loc)
	F.icon = 'icons/obj/flora/ausflora.dmi'
	F.layer = 2.75
	var/pixeling = 1
	var/state = pickweight(list("greengrass" = 48,"trees" = 21, "rocks" = 4, "darkbush" = 7, "treebush" = 10, "branch" = 5, "tall_grass" = 3, "stump" = 2))
	switch(state)
		if("greengrass")
			F.icon_state = "greengrass_[rand(1, 6)]"
		if("rocks")
			F.name = "rocks"
			F.icon = 'icons/obj/flora/rocks.dmi'
			F.icon_state = "rocks_[rand(1, 5)]"
			F.layer = 2.74
		if("darkbush")
			F.name = "bush"
			F.icon_state = "firstbush_[rand(1, 4)]"
		if("treebush")
			F.name = "bush"
			F.opacity = 0
			F.layer = 2.76
			if(prob(50))
				F.icon_state = "treebush_[rand(1, 4)]"
			else
				F.icon_state = "palebush_[rand(1, 4)]"
		if("branch")
			F.name = "branch"
			F.icon = 'icons/obj/flora/wasteland.dmi'
			F.icon_state = "branch_[rand(1, 4)]"
			F.layer = 2.73
		if("stump")
			del F
			F = new /obj/structure/stalker/pen(loc)
		if("tall_grass")
			F.icon_state = "tall_grass_[rand(1, 4)]"
//		if("flowers")
//			icon_state = "flowers_[rand(1, 14)]"
		if("trees")
			var/obj/structure/stalker/flora/trees/tree = pick(typesof(/obj/structure/stalker/flora/trees/alive))
			del F
			F = new tree(loc)

	if(pixeling)
		F.pixel_x = rand(-16,16)

	if(F)
		if(dir == NORTH)
			F.pixel_y = -160
			animate(F, pixel_y = 480, time = 32, loop = -1)
		else if(dir == SOUTH)
			F.pixel_y = 160
			animate(F, pixel_y = -480, time = 32, loop = -1)