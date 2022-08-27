GLOBAL_LIST_EMPTY(ACs)

/obj/item/ammo_casing
	name_ru = "патрон"
	name = "bullet casing"
	desc = ""
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 1
	weight = 0.01
	stackable = 10
	var/fire_sound = null						//What sound should play when this ammo is fired
	var/caliber = null							//Which kind of guns it can be loaded into
	var/projectile_type = null					//The bullet type to create when New() is called
	var/obj/item/projectile/BB = null 			//The loaded bullet
	var/pellets = 0								//Pellets for spreadshot
	var/variance = 0							//Variance for inaccuracy fundamental to the casing
	var/randomspread = 0						//Randomspread for automatics
	var/delay = 0								//Delay for energy weapons
	var/click_cooldown_override = 0				//Override this to make your gun have a faster fire rate, in tenths of a second. 4 is the default gun cooldown.
	var/multiple_sprites = 1

	var/firing_effect_type = /obj/effect/overlay/temp/dir_setting/firing_effect

/obj/item/ammo_casing/Initialize()
	if(projectile_type)
		BB = new projectile_type(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	dir = pick(GLOB.alldirs)
	update_icon()
	..()

/obj/item/ammo_casing/Destroy()
	if(BB)
		BB = null
	return ..()

/obj/item/ammo_casing/update_icon()
	..()
	if(multiple_sprites)
		icon_state = "[initial(icon_state)][BB ? "-live" : ""]-[current_stack]"
	else
		icon_state = "[initial(icon_state)][BB ? "-live" : ""]"
	icon_hands = icon_state
	icon_ground = "[icon_state]_ground"
	name_ru = "[BB ? "патрон" : "гильза"]"
	name = "[BB ? "bullet casing" : "spent bullet casing"]"

/obj/item/ammo_casing/proc/newshot() //For energy weapons, shotgun shells and wands (!).
	if (!BB)
		BB = new projectile_type(src)
	return

/obj/item/ammo_casing/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_box))
		var/obj/item/ammo_box/box = I
		if(isturf(loc))
			var/boolets = 0
			for(var/obj/item/ammo_casing/bullet in loc)
				if (box.stored_ammo.len >= box.max_ammo)
					break
				if (bullet.BB)
					if (box.give_round(bullet, 0))
						boolets++
				else
					continue
			if (boolets > 0)
				box.update_icon()
				user << user.client.select_lang("<span class='notice'>Ты собираешь [boolets] патронов. Теперь их внутри [box.stored_ammo.len] штук.</span>","<span class='danger'><span class='notice'>You collect [boolets] ammo casings. There are [box.stored_ammo.len] of them inside now.</span>")
			else
				user << user.client.select_lang("<span class='notice'>На земле нет подходящих патронов.</span>","<span class='danger'><span class='notice'>There is no fitting ammo on the ground.</span>")
	else
		..()

//Boxes of ammo
/obj/item/ammo_box
	name = "ammo box (null_reference_exception)"

	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	materials = list(MAT_METAL=30000)
	throwforce = 2
	w_class = 2
	throw_speed = 3
	throw_range = 7
	var/auto_filling = 1
	var/list/stored_ammo = list()
	var/ammo_type = /obj/item/ammo_casing
	var/max_ammo = 7
	var/multiple_sprites = 0
	var/caliber
	var/can_be_opened = 0
	var/opened = 0


/obj/item/ammo_box/New()
	..()
	//stored_ammo = list()
	if(auto_filling)
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new ammo_type(src)
	//		stored_ammo += PoolOrNew(ammo_type, src)
			var/obj/item/I = stored_ammo[i]
			weight += I.weight
	update_icon()

/obj/item/ammo_box/proc/get_round(keep = 0)
	if(can_be_opened && !opened)
		return
	if (!stored_ammo.len)
		return null
	else
		var/obj/item/b = stored_ammo[stored_ammo.len]
		stored_ammo -= b
		weight -= b.weight
		if (keep)
			stored_ammo.Insert(1,b)
		return b

/obj/item/ammo_box/proc/give_round(obj/item/ammo_casing/R, replace_spent = 0)
	// Boxes don't have a caliber type, magazines do. Not sure if it's intended or not, but if we fail to find a caliber, then we fall back to ammo_type.
	if(!can_give_round(R))
		return 0

	if (stored_ammo.len < max_ammo)
		stored_ammo += R
		weight += R.weight
		R.loc = src
		return 1

	//for accessibles magazines (e.g internal ones) when full, start replacing spent ammo
	else if(replace_spent)
		for(var/obj/item/ammo_casing/AC in stored_ammo)
			if(!AC.BB)//found a spent ammo
				stored_ammo -= AC
				AC.loc = get_turf(src.loc)

				stored_ammo += R
				R.loc = src
				return 1

	return 0

/obj/item/ammo_box/proc/can_give_round(obj/item/ammo_casing/R)
	if(!R || (caliber && R.caliber != caliber) || (!caliber && R.type != ammo_type))
		return 0
	return 1

/obj/item/ammo_box/proc/can_load(mob/user)
	if(loc != user && loc.loc != user)
		return 0
	if(can_be_opened)
		return 0
	return 1

/obj/item/ammo_box/RightClick(mob/user)
	if(user.stat || !Adjacent(user))
		return
	if(can_be_opened && !opened)
		return
	if(loc != user && loc.loc != user)
		return
	var/obj/item/I = user.get_active_held_item()
	if(I)
		if(istype(I, /obj/item/ammo_casing))
			var/obj/item/ammo_casing/AM = I
			if(AM.current_stack < AM.stackable)
				I = get_round()
				if(I)
					AM.attackby(I, user)
	else
		I = get_round()
		if(I)
			user.put_in_active_hand(I)
			playsound(user, 'sound/stalker/weapons/load/ammo_manip.wav', 50, 1, channel = "regular", time = 5)
	update_icon()

/obj/item/ammo_box/attackby(obj/item/A, mob/user, params, silent = 0, replace_spent = 0, with_delay = 1)
	if(user.stat || !Adjacent(user))
		return
	if(flags & IN_PROGRESS)
		return
	var/num_loaded = 0
	if(!can_load(user))
//		world << "cant load"
		return

/*
	if(istype(A, /obj/item/ammo_box))
		var/obj/item/ammo_box/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			var/did_load = give_round(AC, replace_spent)
			if(did_load)
				AM.stored_ammo -= AC
				AM.weight -= AC.weight
				num_loaded++
			if(!did_load || !multiload)
				break
*/

	flags += IN_PROGRESS
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = A
		if(!can_give_round(AC))
			flags &= ~IN_PROGRESS
			return 0
		if(stored_ammo.len == max_ammo)
			flags &= ~IN_PROGRESS
			return 0
		for(var/i = 1 to AC.current_stack)
			if(stored_ammo.len == max_ammo)
				break
			if(with_delay)
				var/atom/target = src
				if(istype(src.loc, /obj/item/weapon))
					target = src.loc
					var/obj/item/weapon/W = target
					W.update_icon()
				if(!do_after(user, round(100 / user.agi, 0.1), 1, target, 1, 1))
					break
			if(!AC)
				flags &= ~IN_PROGRESS
				return
			var/obj/item/ammo_casing/NewAC = new AC.type(loc)
			if(!AC.BB)
				NewAC.BB = null
				NewAC.update_icon()
			if(give_round(NewAC, replace_spent))
				user.unEquip(NewAC, 0, 0)
				NewAC.loc = src
				num_loaded++
				AC.weight -= NewAC.weight
				AC.current_stack--
				AC.show_count()
				update_icon()
				if(!AC.current_stack)
					qdel(AC)
				playsound(user, 'sound/stalker/weapons/load/ammo_manip.wav', 50, 1, channel = "regular", time = 5)
			else
				qdel(NewAC)
				break
	flags &= ~IN_PROGRESS

	if(num_loaded)
		if(!silent)
			user << user.client.select_lang("<span class='notice'>Ты заряжаешь [num_loaded] патронов в [name_ru].</span>","<span class='notice'>You load [num_loaded] ammo casings in the [src].</span>")
		update_icon()

	return num_loaded

/obj/item/ammo_box/attack_self(mob/user)
	if(can_be_opened && !opened)
		user << user.client.select_lang("<span class='notice'>Ты вскрываешь [name_ru].</span>","<span class='notice'>You've opened [src].</span>")
		opened = 1
		update_icon()

/obj/item/ammo_box/update_icon()
	if(can_be_opened)
		if(opened)
			icon_state = "[initial(icon_state)]_open"
		else
			icon_state = initial(icon_state)
	switch(multiple_sprites)
		if(1)
			icon_state = "[initial(icon_state)]-[stored_ammo.len]"
		if(2)
			icon_state = "[initial(icon_state)]-[stored_ammo.len ? "[max_ammo]" : "0"]"
	if(!can_be_opened)
		var/ammo_word
		var/ammo_word_ru
		var/ammo_percents = 100/max_ammo*stored_ammo.len
		switch(ammo_percents)
			if(0)
				ammo_word = "no"
				ammo_word_ru = "нет"
			if(1 to 20)
				ammo_word = "barely any"
				ammo_word_ru = "совсем мало"
			if(21 to 40)
				ammo_word = "less than half"
				ammo_word_ru = "меньше половины"
			if(41 to 60)
				ammo_word = "half load of"
				ammo_word_ru = "примерно половина"
			if(61 to 80)
				ammo_word = "more than half"
				ammo_word_ru = "больше половины"
			if(81 to 99)
				ammo_word = "almost full load of"
				ammo_word_ru = "почти полный боезапас"
			if(100)
				ammo_word = "full load of"
				ammo_word_ru = "полный боезапас"
		desc = "[initial(desc)]There's [ammo_word] ammo inside."
		desc_ru = "[initial(desc_ru)]Внутри [ammo_word_ru] патронов."

//Behavior for magazines
/obj/item/ammo_box/magazine/proc/ammo_count()
	return stored_ammo.len




/obj/item/zinc
	name = "Zinc"
	name_ru = "Цинк"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/ammo.dmi'
	icon_state = "zinc"
	w_class = 6
	weight = 2

	var/opened = 0
	var/obj/item/weapon/storage/internal/storage = null
	var/obj/item/ammo_box/ammo = null
	var/ammo_amount = 1

/obj/item/zinc/Initialize()
	..()
	if(!storage)
		storage = new/obj/item/weapon/storage/internal(src)
		storage.storage_slots = ammo_amount
		storage.max_w_class = 2
		storage.max_combined_w_class = 2 * ammo_amount
	if(ammo)
		for(var/i = 1 to ammo_amount)
			storage.handle_item_insertion(new ammo(src), 1)

/obj/item/zinc/get_weight()
	return weight + storage.get_weight()


/obj/item/zinc/attack_self(mob/user)
	if(!opened)
		user << user.client.select_lang("<span class='notice'>Ты вскрываешь [name_ru].</span>","<span class='notice'>You've opened [src].</span>")
		opened = 1
		icon_state = "zinc_open"

/obj/item/zinc/MouseDrop(atom/over_object)
	if(!opened)
		return
	var/mob/M = usr

	if(storage && over_object == M)
		playsound(loc, "rustle", 50, 1, -5, channel = "regular", time = 5)
		return storage.MouseDrop(over_object)

/obj/item/zinc/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, speed_sleep = 1)
	if(storage)
		storage.close_all()
	return ..()

/obj/item/zinc/attack_hand(mob/user)
	if(storage && ismob(loc))
		if(!opened)
			return ..()
		playsound(loc, "rustle", 50, 1, -5, channel = "regular", time = 5)
		storage.show_to(user)
	else
		return ..()

/obj/item/zinc/attackby(obj/item/W, mob/user, params)
	if(storage && ismob(loc))
		if(!opened)
			return ..()
		storage.attackby(W, user, params)
	else
		return ..()