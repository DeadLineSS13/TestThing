/obj/item/clothing
	var/durability = -1

/obj/item/clothing/suit
	var/obj/item/weapon/storage/internal_slot/internal_slot = null
	equip_delay = 50

/obj/item/clothing/examine(mob/user)
	..()

/obj/item/clothing/examine(mob/user)
	..()
	if(durability)
		var/percentage = (durability / (initial(durability)))*100
		switch(percentage)
			if(75 to 100)
				user << user.client.select_lang("Почти как новый.", "It is almost new.")
			if(40 to 74)
				user << user.client.select_lang("Значительно поврежден.", "It is damaged badly.")
			if(0 to 39)
				user << user.client.select_lang("Изодран до дыр.", "It is barely protecting you.")


/obj/item/clothing/update_icon()
	..()
	overlays.Cut()

	if(unique)
		overlays += image('icons/stalker/items/weapons/projectile_overlays32x32.dmi', "unique", layer = FLOAT_LAYER)

/obj/item/clothing/New()
	..()
	update_icon()

/obj/item/clothing/suit/MouseDrop(atom/over_object)
	if(!usr)
		return
	if(usr.restrained() || usr.stat || !Adjacent(usr))
		return
	src.throwing = 0
	if (loc == usr)
		if(!usr.unEquip(src))
			return

	pickup(usr)
	add_fingerprint(usr)
	if(!usr.put_in_active_hand(src))
		dropped(usr)
	return

/obj/item/clothing/suit/attack_hand(mob/user)
	if(!ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user

	if(!internal_slot || H.wear_suit != src)
		return ..()

	internal_slot.attack_hand(user)


/////////////////////////////////////////////////////////////////////ШЛЕМЫ НОЧНОГО ВИДЕНЬЯ, ВНУТРЕННИЕ ХРАНИЛИЩА И Т.Д./////////////////////////////////////////////////////////////////////////////////////////

/obj/item/clothing
	var/obj/item/nightvision/nvg = null

/obj/item/nightvision
	var/vision_flags = 0
	var/darkness_view = 4//Base human is 2
	var/invis_view = SEE_INVISIBLE_LIVING
	var/active = 0
	var/nvg_type = 2
	actions_types = list(/datum/action/item_action/toggle_matrix)

/obj/item/nightvision/advanced
	nvg_type = 1

/obj/item/nightvision/New(var/newloc)
	//..()
	/*
	if(newloc)
		loc = newloc
		if(loc.loc && istype(loc.loc, /obj/item/clothing/suit/hooded/sealed))
			var/obj/item/clothing/suit/hooded/sealed/S = loc.loc
			S.modifications["visor_suit"] = 1
		else if(istype(newloc, /obj/item/clothing/head))
			var/obj/item/clothing/head/H = newloc
			H.modifications["visor_head"] = 1
		else if(istype(newloc, /obj/item/clothing/mask))
			var/obj/item/clothing/mask/M = newloc
			//M.modifications["visor_mask"] = 1
			M.modifications["visor_head"] = 1
	*/
	if(istype(newloc, /obj/item/clothing))
		var/obj/item/clothing/C = newloc
		C.nvg = src

/obj/item/nightvision/advanced/New(var/newloc)
	if(newloc)
		loc = newloc
		if(loc.loc && istype(loc.loc, /obj/item/clothing/suit/hooded/sealed))
			var/obj/item/clothing/suit/hooded/sealed/S = loc.loc
			S.modifications["visor_suit"] = 2
		else if(istype(newloc, /obj/item/clothing/head))
			var/obj/item/clothing/head/H = newloc
			H.modifications["visor_head"] = 2
		else if(istype(newloc, /obj/item/clothing/mask))
			var/obj/item/clothing/mask/M = newloc
			//M.modifications["visor_mask"] = 2
			M.modifications["visor_head"] = 2
	if(istype(newloc, /obj/item/clothing))
		var/obj/item/clothing/C = newloc
		C.nvg = src

/obj/item/nightvision/attack_self(mob/user)

	if(!loc || !loc.loc || !istype(loc.loc, /mob/living/carbon))
		return

	var/mob/living/carbon/C = loc.loc


	if(active)
		active = 0
		playsound(usr, 'sound/stalker/nv_off.ogg', 50, 1, -1, channel = "regular", time = 5)
		usr << "You deactivate the optical matrix on the [src]."
		//if(istype(usr, /mob/living/carbon/human))
			//var/mob/living/carbon/human/H = usr
			//H.nightvision.alpha = 0
		//overlay = null
		invis_view = SEE_INVISIBLE_LIVING
		C.remove_client_colour(/datum/client_colour/glass_colour/green)
		C.clear_fullscreen("nvg", 0)
		//sleep(5)
	else
		if(C.head != src.loc && C.wear_mask != src.loc)
			return

		active = 1
		playsound(usr, 'sound/stalker/nv_start.ogg', 50, 1, -1, channel = "regular", time = 10)
		usr << "You activate the optical matrix on the [src]."
		//if(istype(usr, /mob/living/carbon/human))
			//var/mob/living/carbon/human/H = usr
			//H.nightvision.alpha = 125
		//overlay = global_hud.nvg
		invis_view = SEE_INVISIBLE_MINIMUM
		C.add_client_colour(/datum/client_colour/glass_colour/green)
		C.overlay_fullscreen("nvg", /obj/screen/fullscreen/nvg, nvg_type)
		sleep(5)

/obj/item/nightvision/proc/TurnOff(mob/user)
	if(active)
		attack_self(user)
/*
	if(active)
		active = 0
		playsound(usr, 'sound/stalker/nv_off.ogg', 50, 1, -1)
		user << "You deactivate the optical matrix on the [src]."
		//if(istype(usr, /mob/living/carbon/human))
		//	var/mob/living/carbon/human/H = user
		//	H.nightvision.alpha = 0
		invis_view = SEE_INVISIBLE_LIVING
		user.remove_client_colour()
		user.clear_fullscreen("nvg")
*/
/obj/item/clothing/ui_action_click()
	if(nvg)
		nvg.attack_self()
	else
		..()

/obj/item/nightvision/ui_action_click()
	attack_self()


/obj/item/clothing/proc/handle_durability(var/damage)
	var/reduction = round(damage/10)

	if(armor_type == A_SOFT)
		if(armor_new["cut"] > armor_new["crush"])
			if(!reduction)
				armor_new["cut"] -= 1
			armor_new["cut"] -= reduction
		if(armor_new["bullet"] > armor_new["crush"])
			if(!reduction)
				armor_new["bullet"] -= 1
			armor_new["bullet"] -= reduction

	if(armor_type == A_HARD)
		if(armor_new["cut"] > 0)
			if(!reduction)
				armor_new["cut"] -= 1
			armor_new["cut"] -= reduction
		if(armor_new["crush"] > 0)
			if(!reduction)
				armor_new["crush"] -=1
			armor_new["crush"] -= reduction
		if(armor_new["imp"] > 0)
			if(!reduction)
				armor_new["imp"] -= 1
			armor_new["imp"] -= reduction
		if(armor_new["bullet"] > 0)
			if(!reduction)
				armor_new["bullet"] -=1
			armor_new["bullet"] -= reduction

	if(reduction)
		durability -= reduction*10
	else if(durability > (durability/5))
		durability -= damage


/obj/item/clothing
	var/last_degrade = 0

/obj/item/clothing/proc/degrade()
	SSobj.processing |= src

/obj/item/clothing/process()
	if(last_degrade + 1 MINUTES < world.time)
		last_degrade = world.time
		var/n = 0
		for(var/i in armor_new)
			if(armor_new[i] > 0)
				armor_new[i] = max(armor_new[i]-1, 0)
				if(!armor_new[i])
					n++
			else
				n++
			if(n == armor_new.len)
				SSobj.processing.Remove(src)
				qdel(src)

/////////////////////////////////////////////////////////////////////Нарцисс хуесос


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/clothing/suit/hooded/kozhanka
	name = "leather jacket"
	desc_ru = "Обычная плотная кожаная куртка, каких много. Слегка усиливает противопулевую и осколочную защиту. Неэффективна против аномальных и других воздействий."
	desc = "Common grab of a novice stalker. It won’t save you from bullets or anomalies, but it’s still better than nothing."
	icon_state = "kozhanka"
	item_state = "det_suit"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
//	armor = list(melee = 10, bullet = 10, laser = 10,burn = 10, bomb = 10, bio = 10, rad = 10, electro = 10, psy = 0)
	allowed = list(/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/weapon/kitchen/knife/tourist)
	hooded = 1
	unacidable = 1
	hoodtype = /obj/item/clothing/head/winterhood/stalker
	durability = 75
	weight = 3
	pockets = /obj/item/weapon/storage/internal/pocket
	//МОДИФИКАЦИИ//
	modifications = list("lining_suit" = 0, "padding_suit" = 0, "material_suit" = 0, "accessory_slot" = 0)

/obj/item/clothing/head/winterhood/stalker
	name = "hood"
	name_ru = "капюшон"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor_type = A_SOFT
	slot_flags = SLOT_HEAD
	flags = NODROP
	flags_inv = HIDEHAIR
	durability = -1
	weight = 0

/obj/item/clothing/suit/leatherjacket
	name_ru = "кожанка"
	name = "leather jacket"
	desc_ru = "Твоя стиляжность в безопасности."
	desc = "Your style is safe now."
	icon_state = "leatherjacket"
	blood_overlay_type = "leatherjacket"
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 1, cut = 1, imp = 1, bullet = 1, burn = 1, bio = 1, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	durability = 150
	weight = 1.5

/obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack
	name_ru = "кожаный плащ"
	name = "leather coat"
	desc_ru = "Толстая, прочная кожа способна смягчить укус или порез, но на большее плащ не годен."
	desc = "A heavy leather trench coat. Has no special purpose other than to keep the wearer warm at night."
	icon_state = "coatblack"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 1, cut = 1, imp = 1, bullet = 1, burn = 1, bio = 1, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	hoodtype = /obj/item/clothing/head/winterhood/stalker/coatblack
	durability = 150
	weight = 2.5
	var/closed = 0

/obj/item/clothing/head/winterhood/stalker/coatblack
	armor_new = list(crush = 1, cut = 1, imp = 1, bullet = 1, burn = 1, bio = 1, rad = 0, psy = 0)
	icon_state = "winterhood_coatblack"

/obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack/coatbrown
	icon_state = "coatbrown"
	hoodtype = /obj/item/clothing/head/winterhood/stalker/coatblack/coatbrown

/obj/item/clothing/head/winterhood/stalker/coatblack/coatbrown
	icon_state = "winterhood_coatbrown"

/obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack/AltClick(mob/user)
	if(icon_state == "[initial(icon_state)]_t")
		icon_state = "[initial(icon_state)][closed ? "_t" : "_t_c"]"
	else
		icon_state = "[initial(icon_state)][closed ? "" : "_c"]"
	closed = !closed
	user.update_inv_wear_suit()


/obj/item/clothing/suit/coatgar
	name_ru = "тяжелый синтетический плащ"
	name = "heavy synthetic coat"
	desc_ru = "Вы о такой штуке не слыхали, но выглядит солидно."
	desc = "You never heard of a thing like this, but it looks stylish."
	icon_state = "coatgar"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 7, cut = 18, imp = 7, bullet = 18, burn = 7, bio = 7, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	durability = 150
	weight = 8

/obj/item/clothing/suit/obolochka
	name_ru = "старый бронежилет"
	name = "old armor vest"
	desc_ru = "Твои кишочки не в безопасности."
	desc = "Your guts are not safe."
	icon_state = "old"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 2, cut = 8, imp = 2, bullet = 8, burn = 2, bio = 2, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING_HARD
	durability = 150
	weight = 4.5
	ismetal = 1

/obj/item/clothing/suit/kazak
	name_ru = "легкий бронежилет 'Казак'"
	name = "'Kazak' light armor vest"
	desc_ru = "Теперь твои кишочки в безопасности."
	desc = "Your guts are safe now."
	icon_state = "kazak"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 5, cut = 12, imp = 5, bullet = 12, burn = 5, bio = 5, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING_HARD
	durability = 150
	weight = 3
	ismetal = 1

/obj/item/clothing/suit/kazak/pindos
	name_ru = "легкий бронежилет 'Пиндос'"
	name = "'Pindos' light armor vest"
	desc_ru = "Теперь твои кишочки в безопасности."
	desc = "Your guts are safe now."
	icon_state = "pindos"

/obj/item/clothing/suit/hawk
	name_ru = "легкий бронежилет 'Ястреб'"
	name = "'Hawk' light armor vest"
	desc_ru = "Теперь твои кишочки в безопасности."
	desc = "Your guts are safe now."
	icon_state = "hawk"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 7, cut = 18, imp = 7, bullet = 18, burn = 7, bio = 7, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING_HARD
	durability = 150
	weight = 3
	ismetal = 1

/obj/item/clothing/suit
	var/plates_toplace											//Путь к объекту, выступающему в качестве пластин
	var/obj/item/clothing/suit/plates/plates = null				//Ютилити переменная

/obj/item/clothing/suit/mob_can_equip(mob/M, slot, disable_warning = 0)
	if(!plates_toplace)
		return ..()

	if(!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M

	if(H.wear_suit_hard)
		H << "<span class='warning'>Освободите слот бронежилета!</span>"
		return 0

	if(slot == slot_wear_suit && !H.wear_suit)
		return ..()

/obj/item/clothing/suit/equipped(mob/user, slot)
	if(!plates_toplace)
		return ..()
	if(!ishuman(user))
		return 0

	if(!plates)
		plates = new plates_toplace(src)

	var/mob/living/carbon/human/H = user

	if(slot == slot_wear_suit)
		H.equip_to_slot_if_possible(plates, slot_wear_suit_hard, delay = 0)
		weight -= plates.weight

	if(slot != slot_wear_suit)
		H.unEquip(plates, 1, 0)
		plates.loc = src
		weight = initial(weight)

	..()

/obj/item/clothing/suit/karatel
	name_ru = "тяжелый бронежилет 'Каратель'"
	name = "'Karatel' heavy armor vest"
	desc_ru = "Возможно, стоит защитить не только кишочки."
	desc = "Maybe now you should protect something other than guts."
	icon_state = "karatel"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 5, cut = 12, imp = 5, bullet = 12, burn = 5, bio = 5, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	durability = 150
	weight = 4
	ismetal = 1
	plates_toplace = /obj/item/clothing/suit/plates/karatel_plates

/obj/item/clothing/suit/plates/karatel_plates
	name_ru = "пластины бронежилета 'Каратель'"
	name = "'Karatel' trauma plates"
	desc_ru = ""
	icon_state = "karatel"
	blood_overlay_type = "armor"
	armor_type = A_SOFT
	slot_flags = SLOT_OCLOTHING_HARD
	flags = NODROP
	body_parts_covered = CHEST
	cold_protection = CHEST
	durability = 150
	armor_new = list(crush = 23, cut = 23, imp = 23, bullet = 23, burn = 23, bio = 23, rad = 0, psy = 0)
	weight = 4
	ismetal = 1

/obj/item/clothing/suit/heracles
	name_ru = "тяжелый бронежилет 'Геракл'"
	name = "'Heracles' heavy armor vest"
	desc_ru = "Возможно, стоит защитить не только кишочки."
	desc = "Maybe now you should protect something other than guts."
	icon_state = "heracles"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 7, cut = 18, imp = 7, bullet = 18, burn = 7, bio = 7, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	durability = 150
	weight = 6
	ismetal = 1
	plates_toplace = /obj/item/clothing/suit/plates/heracles_plates

/obj/item/clothing/suit/plates/heracles_plates
	name_ru = "пластины бронежилета 'Геракл'"
	name = "'Heracles' trauma plates"
	desc_ru = ""
	icon_state = "heracles"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	cold_protection = CHEST
	armor_type = A_SOFT
	armor_new = list(crush = 34, cut = 34, imp = 34, bullet = 34, burn = 34, bio = 34, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING_HARD
	flags = NODROP
	durability = 150
	weight = 6
	ismetal = 1

/obj/item/clothing/suit/heracles2
	name_ru = "тяжелый бронежилет 'Геракл MkII'"
	name = "'Heracles MkII' heavy armor vest"
	desc_ru = "Возможно, стоит защитить не только кишочки."
	desc = "Maybe now you should protect something other than guts."
	icon_state = "heracles_mk2"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 7, cut = 18, imp = 7, bullet = 18, burn = 7, bio = 7, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	durability = 150
	weight = 7.5
	ismetal = 1
	plates_toplace = /obj/item/clothing/suit/plates/heracles_plates2

/obj/item/clothing/suit/plates/heracles_plates2
	name_ru = "пластины бронежилета 'Геракл'"
	name = "'Heracles' trauma plates"
	desc_ru = ""
	icon_state = "heracles_mk2"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor_type = A_SOFT
	armor_new = list(crush = 34, cut = 34, imp = 34, bullet = 34, burn = 34, bio = 34, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING_HARD
	flags = NODROP
	durability = 150
	weight = 7.5
	ismetal = 1

/obj/item/clothing/suit/hooded/sealed/mechanised
	name_ru = "механизированный скафандр"
	name = "mechanised pressure suit"
	desc_ru = ""
	icon_state = "mechsuit"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	flags_inv = HIDEJUMPSUIT
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	burn_state = FIRE_PROOF
	armor_type = A_HARD
	armor_new = list(crush = 60, cut = 60, imp = 60, bullet = 60, burn = 60, bio = 60, rad = 60, psy = 60)
	hoodtype = /obj/item/clothing/head/winterhood/stalker/sealed/mechanised
	slot_flags = SLOT_OCLOTHING
	durability = 150
	weight = 30
	ismetal = 1
	plates_toplace = /obj/item/clothing/suit/plates/mech_plates

/obj/item/clothing/head/winterhood/stalker/sealed/mechanised
	name_ru = "шлем скафандра"
	name = "pressure suit helmet"
	armor_new = list(crush = 60, cut = 60, imp = 60, bullet = 60, burn = 60, bio = 60, rad = 60, psy = 60)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	flags = NODROP
	equip_delay = 0
	armor_type = A_HARD
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	icon_state = "mechanised"
	burn_state = FIRE_PROOF

/obj/item/clothing/suit/plates/mech_plates
	name_ru = "механизированный скафандр"
	name = "механизированный скафандр"
	desc_ru = ""
	icon_state = "mechsuit"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	cold_protection = CHEST
	armor_type = A_HARD
	armor_new = list(crush = 40, cut = 40, imp = 40, bullet = 40, burn = 40, bio = 40, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING_HARD
	flags = NODROP
	durability = 150
	weight = 10


/obj/item/clothing/suit/hooded/kozhanka/ozk
	name = "OZK"
	name_ru = "ОЗК"
	desc = "Неудобный костюм из плотного материала. Призван для защиты от контактных газов, биологического оружия и напалма... по идее, будет чуть лучше, чем плащ, в Зоне. Советуется носить с противогазом."
	desc_ru = "Cumbersome suit made of thick rubbery material. Meant to protect against contact gases, biological weapons and napalm... would probably be somewhat better compared to leather coats. Advised to use together with a gasmask."
	icon_state = "ozk"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	armor_new = list(crush = 2, cut = 2, imp = 2, bullet = 2, burn = 2, bio = 5, rad = 2, psy = 0)
	hoodtype = /obj/item/clothing/head/winterhood/stalker/ozk
	weight = 2
	slowdown = 1
	var/closed = 0

/obj/item/clothing/head/winterhood/stalker/ozk
	icon_state = "winterhood_ozk"
	armor_new = list(crush = 2, cut = 2, imp = 2, bullet = 2, burn = 2, bio = 5, rad = 2, psy = 0)


/obj/item/clothing/suit/hooded/kozhanka/ozk/AltClick(mob/user)
	if(flags & IN_PROGRESS)
		return
	if(!closed)
		user << "<span class='notice'>Ты начал заворачивать ОЗК вокруг ног...</span>"
	else
		user << "<span class='notice'>Ты начал разворачивать ОЗК...</span>"
	flags += IN_PROGRESS
	if(!do_mob(user, user, 50))
		flags &= ~IN_PROGRESS
		return
	flags &= ~IN_PROGRESS
	if(!closed)
		user << "<span class='notice'>Ты завернул ОЗК вокруг ног!</span>"
	else
		user << "<span class='notice'>Ты развернул ОЗК!</span>"
	if(icon_state == "[initial(icon_state)]_t")
		icon_state = "[initial(icon_state)][closed ? "_t" : "_t_c"]"
	else
		icon_state = "[initial(icon_state)][closed ? "" : "_c"]"
	closed = !closed
	if(closed)
		slowdown = 0
	else
		slowdown = 1
	user.update_inv_wear_suit()

/obj/item/clothing/suit/hooded/kozhanka/ozk/MouseDrop()
	if(closed)
		usr << "<span class='warning'>Сначала разверни ОЗК!</span>"
		return 0
	..()

/obj/item/clothing/suit/hooded/kozhanka/robe
	name_ru = "светлые робы"
	name = "bright robes"
	desc_ru = "Какая странная штука."
	desc = "What a strange thing."
	icon_state = "robe"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 1, cut = 1, imp = 1, bullet = 1, burn = 1, bio = 1, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	hoodtype = /obj/item/clothing/head/winterhood/stalker/robe
	durability = 150
	weight = 2.5
	var/closed = 0

/obj/item/clothing/head/winterhood/stalker/robe
	armor_new = list(crush = 1, cut = 1, imp = 1, bullet = 1, burn = 1, bio = 1, rad = 0, psy = 0)
	icon_state = "winterhood_robe"

/obj/item/clothing/mask/robe // ЗАПИЛИТЬ ЧТО ПРИ ПКМ НА КАПЮШОН ВЫШЕ, В СЛОТЕ МАСКИ ПОЯВЛЯЕТСЯ ЭТОТ ОБЪЕКТ
	armor_new = list(crush = 1, cut = 1, imp = 1, bullet = 1, burn = 1, bio = 1, rad = 2, psy = 0)
	icon_state = "robe"
	flags = BLOCKFACIALHAIR
	flags_cover = MASKCOVERSMOUTH
	armor_type = A_SOFT