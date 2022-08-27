
//	Артефакты огненные по своей природе	//

/obj/item/artefact/fire
	light_color = COLOUR_LTEMP_CANDLE

/obj/item/artefact/fire/crystalblood
	name = "Crystal Blood"
	name_ru = "Кристальная кровь"
	icon_state = "crystallblood"

	lick_message = "Tastes like a piece of warm glass."
	lick_message_ru = "На вкус как теплое стекло."

	effects = list("bleeding_close" = 150, "stamina_coef" = -25, "starvation" = 25)
	var/rubbed = 0

/obj/item/artefact/fire/crystalblood/rub()
	..()
	if(rubbed)
		return
	icon_state = "crystallblood-use"
	icon_hands = "crystallblood-use"
	icon_ground = "crystallblood_ground-use"
	effects = list("bleeding_close" = 1, "stamina_coef" = -50, "starvation" = 300, "burn_armor" = 10)
	owner.recalc_artefact_effects(src)
	initial_effects = effects.Copy()
	rubbed = 1
	spawn(dice6(1) MINUTES)
		if(prob(40))
			qdel(src)
			return
		icon_state = "crystallblood"
		icon_hands = "crystallblood"
		icon_ground = "crystallblood_ground"
		effects = list("bleeding_close" = 150, "stamina_coef" = -25, "starvation" = 25)
		owner.recalc_artefact_effects(src)
		initial_effects = effects.Copy()
		rubbed = 0

/obj/item/artefact/fire/crystalblood/hit()
	..()
	icon_state = "crystallblood-use"
	icon_hands = "crystallblood-use"
	icon_ground = "crystallblood_ground-use"
	spawn(dice6(1) SECONDS)
		for(var/mob/living/carbon/human/H in range(3, get_turf(src)))
			H.fire_act()
			for(var/obj/item/organ/limb/L in H.organs)
				L.take_damage(0, 0, dice6(1)+1)
		remove_effects(usr)
		qdel(src)




/obj/item/artefact/fire/chertovrog
	name = "Devil Horn"
	name_ru = "Чёртов рог"
	icon_state = "chertovrog"

	lick_message = ""
	lick_message_ru = "На вкус как тёплый камень."

	effects = list("all_dices_penalty" = 2, "str" = 1, "agi" = 1, "int" = 1, "hlt" = 1)

	var/shaked = 0

/obj/item/artefact/fire/chertovrog/shake()
	..()
	if(shaked)
		return
	shaked = 1

	usr << usr.client.select_lang("<i><span class='notice'>[name_ru] начал теплеть.</span></i>", "<i><span class='notice'>[name] feels warmer.</span></i>")

	spawn(dice6(1) SECONDS)
		var/time_to_del = dice6(2) MINUTES

		var/obj/anomaly/natural/fire/jarka/J = new(get_turf(src))
		for(var/mob/living/carbon/human/H in range(0, src))
			H.dust()

		spawn(time_to_del)
			qdel(J)

		var/list/in_range = list()
		for(var/turf/stalker/T in range(5, get_turf(src)))
			in_range.Add(T)

		for(var/i = 1 to dice6(1))
			var/turf/stalker/T = pick(in_range)
			var/obj/anomaly/natural/fire/jarka/JA = new(T)
			in_range.Remove(T)

			spawn(time_to_del)
				qdel(JA)

		qdel(src)


/obj/item/artefact/fire/korsar
	name = "Korsar"
	name_ru = "Корсар"
	icon_state = "korsar"

	lick_message = ""
	lick_message_ru = "На вкус как тёплый камень."

	effects = list("korsar" = 1, "str" = 1, "agi" = 1, "int" = 1, "hlt" = 1)

/obj/item/artefact/fire/korsar/shake()
	..()
	if(isliving(usr))
		var/mob/living/L = usr
		L.fire_act()