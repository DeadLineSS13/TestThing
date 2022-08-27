/obj/structure/barricade/stalker
	icon = 'icons/stalker/structure/decor.dmi'
	var/debriss_type
	var/loot
	var/lootenable = 0
	var/doubleloot = 0

/obj/structure/barricade/stalker/take_damage(damage, leave_debris=1, message)
	health -= damage
	if(health <= 0)
		if(message)
			visible_message(message)
		else
			visible_message("<span class='warning'>\The [src] is smashed apart!</span>")
		if(leave_debris && debriss_type)
			new debriss_type(get_turf(src))
			if(lootenable)
				if(loot)
					var/lootspawn = pickweight(loot)
					if(doubleloot)
						new lootspawn(get_turf(src))
						lootspawn = pickweight(loot)
						new lootspawn(get_turf(src))
						qdel(src)
					else
						new lootspawn(get_turf(src))
						qdel(src)
		qdel(src)

/obj/structure/barricade/stalker/wood
	name = "wooden barricade"
	desc = "Barricaded passage."
	desc_ru = "Забаррикадированный досками проход."
	icon_state = "zabitiy_proxod"
	debriss_type = /obj/structure/stalker/doski
//	obj_integrity = 50
//	max_integrity = 50

/obj/structure/barricade/stalker/yashik/lootable
	name = "wooden box"
	name_ru = "деревянный ящик"
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "yashik"
	density = 1
	desc = "Boarded up wooden box. Who knows what can be inside."
	desc_ru = "Заколоченный деревянный ящик. Кто знает, что может быть внутри."
	debriss_type = /obj/structure/stalker/doski/doski2
	lootenable = 0
	doubleloot = 1
	health = 50
	loot = list(/obj/item/weapon/storage/firstaid/stalker = 30,
					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva = 55,
					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/shproti = 40,
					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup = 50,
					/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa = 60,
					/obj/item/weapon/reagent_containers/food/snacks/stalker/baton = 75,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/kazaki = 35,
					/obj/item/stack/medical/bruise_pack/bint = 80,
					/obj/item/weapon/reagent_containers/hypospray/medipen/stalker/antirad = 10,
					/obj/item/clothing/suit/hooded/kozhanka/banditka = 1,
					/obj/item/ammo_box/stalker/b9x18 = 55,
					/obj/item/ammo_box/stalker/b12x70 = 40)

/obj/structure/barricade/stalker/yashik/lootable/New()
	..()
	if(prob(50))
		lootenable = 1

/obj/structure/stalker/blocks
	name = "blocks"
	name_ru = "бетонные блоки"
	icon = 'icons/stalker/structure/decor2.dmi'
	desc = "Solid, but sometimes chipped, concrete blocks."
	desc_ru = "Цельные, но местами со сколами, бетонные блоки."
	density = 1
	opacity = 1

/obj/structure/stalker/blocks/block1
	icon_state = "block1"

/obj/structure/stalker/blocks/block1/r
	icon_state = "block1r"

/obj/structure/stalker/blocks/block1/m
	icon_state = "block1m"

/obj/structure/stalker/blocks/block1/l
	icon_state = "block1l"

/obj/structure/stalker/blocks/block2
	icon_state = "block4"

/obj/structure/stalker/blocks/block2/r
	icon_state = "block4r"

/obj/structure/stalker/blocks/block2/m
	icon_state = "block4m"

/obj/structure/stalker/blocks/block2/l
	icon_state = "block4l"

/obj/structure/stalker/blocks/block3
	icon_state = "block3"

/obj/structure/stalker/blocks/block3/r
	icon_state = "block3r"

/obj/structure/stalker/blocks/block3/m
	icon_state = "block3m"

/obj/structure/stalker/blocks/block3/l
	icon_state = "block3l"

/obj/structure/stalker/blocks/vanish
	opacity = 0
	var/proj_pass_rate = 50
	pass_flags = LETPASSTHROW
	can_leap_over = 1

/obj/structure/stalker/blocks/vanish/block1
	icon_state = "block2"

/obj/structure/stalker/blocks/vanish/block1/r
	icon_state = "block2r"

/obj/structure/stalker/blocks/vanish/block1/m
	icon_state = "block2m"

/obj/structure/stalker/blocks/vanish/block1/l
	icon_state = "block2l"

/obj/structure/stalker/blocks/vanish/block2
	icon_state = "block5"

/obj/structure/stalker/blocks/vanish/block2/r
	icon_state = "block5r"

/obj/structure/stalker/blocks/vanish/block2/m
	icon_state = "block5m"

/obj/structure/stalker/blocks/vanish/block2/l
	icon_state = "block5l"

/obj/structure/stalker/blocks/vanish/CanPass(atom/movable/mover, turf/target)//So bullets will fly over and stuff.
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return 1
		if(proj.def_zone == "r_leg" || proj.def_zone == "l_leg") //|| proj.def_zone == "groin")
			return 0
		if(proj.def_zone == "head" || proj.def_zone == "eyes" || proj.def_zone == "face" || proj.def_zone == "mouth")
			return 1
		if(prob(proj_pass_rate))
			return 1
		return 0
	else if(istype(mover, /obj/item))
		return 1

	return 0

/obj/structure/stalker/blocks/vanish/pipe
	name = "pipe"
	name_ru = "труба"
	desc = "A huge reinforced concrete pipe."
	desc_ru = "Громадная железобетонная труба."
	icon = 'icons/stalker/structure/decor2.dmi'
	icon_state = "truba1"
	can_leap_over = 1

/obj/structure/stalker/blocks/vanish/pipe/pipe2
	icon_state = "truba2"
	can_storage = 1
	max_slots = 7
	max_w_class = 5

/obj/structure/stalker/blocks/vanish/pipe/pipe3
	icon_state = "truba3"

/obj/structure/stalker/blocks/vanish/pipe/beton
	icon_state = "pipe_round"

/obj/structure/stalker/blocks/vanish/shlagbaum1
	name = "barrier"
	name_ru = "шлагбаум"
	icon = 'icons/stalker/structure/decor2.dmi'
	icon_state = "shlagbaum1"
	layer = 4
	can_leap_over = 1

/obj/structure/stalker/blocks/vanish/shlagbaum1/shlagbaum2
	icon_state = "shlagbaum2"

/obj/structure/stalker/blocks/vanish/sandbags
	name = "sandbags"
	name_ru = "мешки с песком"
	desc = "The usual mound of bags of sand."
	desc_ru = "Обычная насыпь из мешков с песком."
	icon = 'icons/stalker/structure/sandbags.dmi'
	icon_state = "solo"
	can_leap_over = 1


/obj/structure/stalker/armor_window
	name = "Window"
	name_ru = "Стекло"
	desc = "Armored window"
	desc_ru = "Бронестекло"
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "armorglass2"
	density = 1
	opacity = 0
	anchored = 1
	pixel_y = 12


/obj/structure
	var/can_leap_over = 0

/obj/structure/MouseDrop_T(atom/dropping, mob/user)
	if(user.stat || user.restrained() || !user.Adjacent(src))
		return

	if(can_leap_over)
		if(flags & IN_PROGRESS)
			return
		user << user.client.select_lang("<span class='notice'>Ты начал перелезать через [name_ru]</span>", "<span class='notice'>You started climbing over [src]</span>")
		flags += IN_PROGRESS
		if(!do_after(user, 50, 1, src))
			flags &= ~IN_PROGRESS
			return
		flags &= ~IN_PROGRESS
		var/dirr = get_dir(user, src)
		user.Move(loc, dirr)
		user.Move(get_step(src, dirr), dirr)
		user << user.client.select_lang("<span class='notice'>Ты перелез через [name_ru]</span>", "<span class='notice'>You climbed over [src]</span>")
		return
	..()