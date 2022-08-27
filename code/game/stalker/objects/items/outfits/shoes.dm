/obj/item/clothing/shoes/jackboots/warm
	name = "jackboots"
	name_ru = "сапоги"
	desc_ru = "Старые и потертые."
	desc = "Old and worn up."
	weight = 0.65
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	var/obj/item/weapon/kitchen/knife/knife
	var/armor_stage = 0

//Knife slot
/obj/item/clothing/shoes/jackboots/warm/attack_hand(var/mob/living/M)
	if(knife && src.loc == M && !M.stat) //Only allow someone to take out the knife if it's being worn or held. So you can pick them up off the floor
		knife.loc = get_turf(src)
		if(M.put_in_active_hand(knife))
			M << M.client.select_lang("<div class='notice'>Ты достаешь ножик из сапога.</div>", "<div class='notice'>You slide the [knife] out of [src].</div>")
			playsound(M, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
			knife = 0
			weight = 0.65
			update_icon()
		return
	..()

/obj/item/clothing/shoes/jackboots/warm/attackby(var/obj/item/I, var/mob/living/M)
	if(istype(I, /obj/item/weapon/kitchen/knife/))
		if(knife)	return
		M.drop_item()
		knife = I
		I.loc = src
		M << M.client.select_lang("<div class='notice'>Ты прячешь ножик в сапоге.</div>", "<div class='notice'>You slide the [I] into [src].</div>")
		playsound(M, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
		weight = 1
		update_icon()

/obj/item/clothing/shoes/jackboots/warm/update_icon()
	if(knife && !armor_stage)
		icon_state = "jackboots-1"
	else if(!armor_stage)
		icon_state = initial(icon_state)

/obj/item/clothing/shoes/mob_can_equip(mob/M, slot, disable_warning = 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.sticky_pit)
			return 0

	return ..()

/mob/living/carbon/human/unEquip(obj/item/I, force, delay = 1)
	if(sticky_pit && !force)
		if(istype(I, /obj/item/clothing/shoes))
			return 0
	return ..()

/obj/item/clothing/shoes/jackboots/ozk
	name = "rubber boots"
	name_ru = "резиновые сапоги"
	desc_ru = "Плотно закрепляются на ногах. По идее, защитят от какой-нибудь... гадости."
	desc = "They sit tight on your feet. Should protect from... acid?"
	icon_state = "rubber"
	item_state = "rubber"
	icon_ground = "rubber_ground"
	weight = 1
	equip_delay = 50
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 2, cut = 2, imp = 2, bullet = 2, burn = 2, bio = 5, rad = 0, psy = 0)
	body_parts_covered = FEET
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT