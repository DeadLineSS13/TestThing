/obj/item/weapon/storage/wallet/stalker
	storage_slots = 10
	can_hold = list(
		/obj/item/spacecash,
		/obj/item/clothing/mask/cigarette,
		/obj/item/weapon/lighter,
		/obj/item/weapon/match)

/obj/item/weapon/storage/wallet/stalker/New()
	..()
	var/item1_type = pick(/obj/item/spacecash/c100,/obj/item/spacecash/c50)
	var/item2_type
	if(prob(50))
		item2_type = pick(/obj/item/spacecash/c100,/obj/item/spacecash/c50)

	spawn(2)
		if(item1_type)
			new item1_type(src)
		if(item2_type)
			new item2_type(src)


/obj/item/weapon/storage/backpack/stalker
	name = "backpack"
	name_ru = "рюкзак"
	desc = "Common stalker backpack with average holding capacity. Cheap, but practical."
	desc_ru = "Обыкновенный сталкерский рюкзак средней вместимости. Дешево и сердито."
	icon_state = "backpack-stalker"
	item_state = "backpack-stalker"
	w_class = 4
	weight = 0.5
	slot_flags = SLOT_BACK
	max_w_class = 3
	max_combined_w_class = 40
	storage_slots = 28
	max_weight = 30
	weight_alpha = 0.6
	back_open = 0

/obj/item/weapon/storage/backpack/satchel
	name = "satchel"
	name_ru = "сумка"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel-civilian"
	w_class = 4
	weight = 0.5
	slot_flags = SLOT_BACK | SLOT_BACK2
	max_w_class = 3
	max_combined_w_class = 26
	storage_slots = 16
	max_weight = 20
	weight_alpha = 0.8
	back_open = 1

/obj/item/weapon/storage/backpack/stalker/bandit
	desc = "Common stalker backpack, carelessly painted in black colors. Commonly used by bandits and others criminal-wide stalkers."
	desc_ru = "Обыкновенный сталкерский рюкзак, небрежно перекрашенный балончиком в черный цвет. Широко используется бандитами."
	icon_state = "backpack-bandit"
	item_state = "backpack-bandit"

/obj/item/weapon/storage/backpack/stalker/dolg
	desc = "This backpack was made on the special order for \"Duty\" faction. Special material and additional sections allow to bring more things."
	desc_ru = "Этот рюкзак был сшит на заказ специально для группировки \"Долг\". Особый материал и дополнительные отделения позволяют брать с собой больше вещей."
	icon_state = "backpack-dolg"
	item_state = "backpack-dolg"
	weight = 0.8
	max_combined_w_class = 46
	max_weight = 35

/obj/item/weapon/storage/backpack/stalker/svoboda
	desc = "This backpack was made on the special order for \"Freedom\" faction. Special material and additional sections allow to bring more things."
	desc_ru = "Этот рюкзак был сшит на заказ специально для группировки \"Свобода\". Особый материал и дополнительные отделения позволяют брать с собой больше вещей."
	icon_state = "backpack-svoboda"
	item_state = "backpack-svoboda"
	weight = 0.8
	max_combined_w_class = 46
	max_weight = 35

/obj/item/weapon/storage/backpack/stalker/mercenary
	desc = "This backpack was made on the special order for \"Mercenaries\" faction. Special material and additional sections allow to bring more things."
	desc_ru = "Этот рюкзак был сшит на заказ специально для группировки \"Наемники\". Особый материал и дополнительные отделения позволяют брать с собой больше вещей."
	icon_state = "backpack-mercenary"
	item_state = "backpack-mercenary"
	weight = 0.8
	max_combined_w_class = 46
	max_weight = 35

/obj/item/weapon/storage/backpack/stalker/tourist
	desc = "Hiking backpack, made from expensive and sturdy material. The abundance of various pockets and special system of weight distribution allow to take much heavier burden with less effort. A rare thing in the Zone"
	desc_ru = "Туристический рюкзак, сшитый из дорогой и прочной ткани. Обилие всевозможных карманов и специальная система распределения нагрузки по всей спине позволяют переносить огромный вес с наименьшим затратом сил. Редкая для зоны вещь."
	icon_state = "backpack-tourist"
	item_state = "backpack-tourist"
	weight = 3
	max_combined_w_class = 70
	max_weight = 50
	weight_alpha = 0.4

/obj/item/weapon/storage/backpack/stalker/attackby(obj/item/weapon/W, mob/user, params)
	playsound(src.loc, "sound/stalker/objects/inv_open.ogg", 50, 1, -5, channel = "regular", time = 5)
	..()

//Some suit internal slots

/obj/item/weapon/storage/internal_slot
	name = "internal slot"
	desc = "You shouldn't see this."
	w_class = 4
	max_w_class = 2
	max_combined_w_class = 2
	storage_slots = 1
	w_class = 5
	takeout_speed = 0
	touch_sound = 'sound/stalker/objects/internal_slot_toggle.ogg'
	insert_sound = null

/obj/item/weapon/storage/internal_slot/attack_hand(mob/user)
	playsound(loc, touch_sound, 50, 1, -5, channel = "regular", time = 5)

	orient2hud(user)
	if(loc && loc.loc && (loc == user || loc.loc == user))
		if(user.s_active)
			user.s_active.close(user)
		show_to(user)
	add_fingerprint(user)

/obj/item/weapon/storage/internal_slot/MouseDrop(atom/over_object)
	if(iscarbon(usr)) //all the check for item manipulation are in other places, you can safely open any storages as anything and its not buggy, i checked
		var/mob/M = usr

		if(!over_object)
			return

//		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
//			return

		if(over_object == M && Adjacent(M)) // this must come before the screen objects only block
			orient2hud(M)					// dunno why it wasn't before
			if(M.s_active)
				M.s_active.close(M)
			show_to(M)
			return

		if(!M.restrained() && !M.stat)
			if(!istype(over_object, /obj/screen))
				return content_can_dump(over_object, M)

			if(loc != usr || (loc && loc.loc == usr))
				return

			playsound(loc, touch_sound, 50, 1, -5, channel = "regular", time = 5)
			add_fingerprint(usr)


//artefact container//

/obj/item/weapon/storage/internal_slot/container
	name = "mounted artefact container"
	can_hold = list(/obj/item/artefact)
	storage_slots = 1

/obj/item/weapon/storage/internal_slot/container/advanced
	name = "mounted advanced artefact container"
	max_combined_w_class = 4
	storage_slots = 2

/obj/item/weapon/storage/internal_slot/container/modern
	name = "mounted modern artefact container"
	max_combined_w_class = 4
	storage_slots = 2
	radiation_protection = 1

//Item slots//

/obj/item/weapon/storage/internal_slot/webbing
	name = "mounted webbing"
	max_w_class = 2
	max_combined_w_class = 4
	storage_slots = 2

/obj/item/weapon/storage/internal_slot/webbing/advanced
	name = "mounted advanced webbing"
	max_w_class = 2
	max_combined_w_class = 6
	storage_slots = 3

/obj/item/weapon/storage/internal_slot/webbing/modern
	name = "mounted modern webbing"
	max_w_class = 3
	max_combined_w_class = 12
	storage_slots = 4

//Gun slot//

/obj/item/weapon/storage/internal_slot/gun_case
	name = "mounted gan case"
	max_w_class = 4
	max_combined_w_class = 4
	storage_slots = 1

/obj/item/weapon/storage/stalker/polka
	name = "shelf"
	desc = "Typical soviet shelving."
	desc_ru = "Деревянный стеллаж."
	icon = 'icons/stalker/polka.dmi'
	icon_state = "polka"
	layer = 3.1
	w_class = 5
	weight = 15
	storage_slots = 35
	max_w_class = 5
	max_combined_w_class = 60
	max_weight = 100
	density = 0
	anchored = 1

/obj/item/weapon/storage/stalker/polka/update_icon()
	overlays = 0

	if(!contents)
		return

	for(var/I in contents)
		var/overlayed = 0
		if(istype(I, /obj/item/ammo_box/stalker/b545) || istype(I, /obj/item/ammo_box/stalker/b545ap))
			overlays += image('icons/stalker/polka.dmi', icon_state = "5x45", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/ammo_box/stalker/b12x70) || istype(I, /obj/item/ammo_box/stalker/b12x70P) || istype(I, /obj/item/ammo_box/stalker/b12x70D))
			overlays += image('icons/stalker/polka.dmi', icon_state = "drob", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/ammo_box/stalker/b9x19) || istype(I, /obj/item/ammo_box/stalker/b9x19P))
			overlays += image('icons/stalker/polka.dmi', icon_state = "9x19", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/ammo_box/stalker/b9x18) || istype(I, /obj/item/ammo_box/stalker/b9x18P))
			overlays += image('icons/stalker/polka.dmi', icon_state = "9x18", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/weapon/storage/firstaid/stalker))
			overlays += image('icons/stalker/polka.dmi', icon_state = "firstaid", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/weapon/storage/firstaid/army))
			overlays += image('icons/stalker/polka.dmi', icon_state = "army", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/weapon/storage/firstaid/science))
			overlays += image('icons/stalker/polka.dmi', icon_state = "science", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/stack/medical/bruise_pack) || istype(I, /obj/item/stack/medical/ointment) || istype(I, /obj/item/weapon/reagent_containers/hypospray/medipen/stalker/antirad) || istype(I, /obj/item/weapon/reagent_containers/pill/antirad))
			overlays += image('icons/stalker/polka.dmi', icon_state = "med", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/stalker))
			overlays += image('icons/stalker/polka.dmi', icon_state = "food", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/weapon/reagent_containers/food/drinks))
			overlays += image('icons/stalker/polka.dmi', icon_state = "drinks", layer = 3)
			overlayed = 1
		if(istype(I, /obj/item/weapon/gun))
			overlays += image('icons/stalker/polka.dmi', icon_state = "guns", layer = 3)
			overlayed = 1
		if(!overlayed)
			overlays += image('icons/stalker/polka.dmi', icon_state = "other", layer = 3)

/obj/item/weapon/storage/stalker/polka/polka/left
	icon_state = "polka_l"
/obj/item/weapon/storage/stalker/polka/polka/left/update_icon()
	return
/obj/item/weapon/storage/stalker/polka/polka/right
	icon_state = "polka_r"
/obj/item/weapon/storage/stalker/polka/polka/right/update_icon()
	return

/obj/item/weapon/storage/stalker/polka/left
	icon_state = "polka_left"
/obj/item/weapon/storage/stalker/polka/left/l
	icon_state = "polka_left_l"
/obj/item/weapon/storage/stalker/polka/left/l/update_icon()
	return
/obj/item/weapon/storage/stalker/polka/left/r
	icon_state = "polka_left_r"
/obj/item/weapon/storage/stalker/polka/left/r/update_icon()
	return

/obj/item/weapon/storage/stalker/polka/right
	icon_state = "polka_right"
/obj/item/weapon/storage/stalker/polka/right/l
	icon_state = "polka_right_l"
/obj/item/weapon/storage/stalker/polka/right/l/update_icon()
	return
/obj/item/weapon/storage/stalker/polka/right/r
	icon_state = "polka_right_r"
/obj/item/weapon/storage/stalker/polka/right/r/update_icon()
	return

/obj/item/weapon/storage/stalker/polka/middle
	icon_state = "polka_middle"
/obj/item/weapon/storage/stalker/polka/middle/l
	icon_state = "polka_middle_l"
/obj/item/weapon/storage/stalker/polka/middle/l/update_icon()
	return
/obj/item/weapon/storage/stalker/polka/middle/r
	icon_state = "polka_middle_r"
/obj/item/weapon/storage/stalker/polka/middle/r/update_icon()
	return


/obj/item/weapon/storage/stalker/polka/Initialize()
	..()
/*
	switch (pickweight(list("food" = 20, "med" = 12, "common_med" = 10, "army_med" = 5, "science_med" = 2, "9x18" = 10, "9x19" = 7, "12x70" = 7, "545" = 3, "nothing" = 85)))
		if ("food")
			new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva(src)
			new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva(src)
			new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup(src)
			new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/bobi(src)

		if ("med")
			new /obj/item/stack/medical/bruise_pack/bint(src)
			new /obj/item/stack/medical/bruise_pack/bint(src)
		if ("common_med")
			new /obj/item/weapon/storage/firstaid/stalker(src)

		if ("army_med")
			new /obj/item/weapon/storage/firstaid/army(src)

		if ("science_med")
			new /obj/item/weapon/storage/firstaid/science(src)

		if ("9x18")
			new /obj/item/ammo_box/stalker/b9x18(src)
			new /obj/item/ammo_box/stalker/b9x18(src)

		if ("9x19")
			new /obj/item/ammo_box/stalker/b9x19(src)
			new /obj/item/ammo_box/stalker/b9x19(src)

		if ("545")
			new /obj/item/ammo_box/stalker/b545(src)
			new /obj/item/ammo_box/stalker/b545(src)

		if ("12x70")
			new /obj/item/ammo_box/stalker/b12x70(src)
			new /obj/item/ammo_box/stalker/b12x70(src)

		if ("nothing")
			new /obj/nothing(src)
*/
	update_icon()

/obj/item/weapon/storage/stalker/plita
	name = "stove"
	desc = "Rusty and old gas stove. You still can see some withered fat mixed with dust and mud on it."
	desc_ru = "Ржавая и очень старая газовая плита. Где-то еще можно различить частички засохшего жира, вперемешку с грязью и пылью."
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "gazovaya_plita"
	layer = 3.1
	w_class = 5
	weight = 15
	storage_slots = 7
	max_w_class = 3
	max_combined_w_class = 9
	max_weight = 6
	density = 0
	anchored = 1

/obj/item/weapon/storage/stalker/pech
	name = "furnace"
	desc = "Just old furnace"
	desc_ru = "Старая печь."
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "pech"
	layer = 3.1
	w_class = 5
	weight = 80
	storage_slots = 7
	max_w_class = 3
	max_combined_w_class = 9
	max_weight = 6
	density = 0
	anchored = 1

/obj/item/weapon/storage/stalker/shkaf64
	name = "Shkaf"
	desc = "Big wooden wardrobe. Fancy, but it's so old it has worn out in some places, and you can see some scratches on the glass"
	desc_ru = "Большой деревянный шкаф. Красивый, но в некоторых местах стерся и облез, на стекле видны царапины."
	icon = 'icons/stalker/structure/decorations_32x64.dmi'
	icon_state = "shkaf64"
	layer = 3.1
	w_class = 5
	weight = 25
	storage_slots = 35
	max_w_class = 4
	max_combined_w_class = 48
	max_weight = 100
	density = 0
	anchored = 1
	pixel_y = 12

/obj/item/weapon/storage/stalker/metal_polka
	name = "shelf"
	icon = 'icons/stalker/polka.dmi'
	icon_state = "metal_polka"
	desc = "Typical soviet shelving."
	desc_ru = "Металлический стеллаж."
	layer = 3.1
	w_class = 5
	weight = 15
	storage_slots = 15
	max_w_class = 5
	max_combined_w_class = 25
	max_weight = 50
	density = 0
	anchored = 1


/obj/item/weapon/storage/stalker/attack_hand(mob/user)
	MouseDrop(user)