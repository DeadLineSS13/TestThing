#define HARD 0
#define SOFT 1

/mob
	var/list/artefacts_effects = list()

//Список эффектов артефактов на текущий момент, НЕ ПЕРЕПУТАЙ

//"str", "agi", "hlt", "int", "stamina_coef", "all_dices_penalty", "weight", "regen", "bleeding_close", "starvation", "hlt_dice", "korsar", "zapzap", "kirpich", "mind_reading"

//Как уже написано ниже, названия !!!ОБЯЗАНЫ!!! совпадать, иначе всё сломается
//(шучу, работать оно будет, но только добавление/убирание из листа, а сам эффект - нет. Код - не магия)

/obj/item/artefact
	name = "artefact"
	icon = 'icons/stalker/artefacts.dmi'
	icon_state = "meduza"
	w_class = 2
	layer = 3.61
	weight = 0.5
	slot_flags = SLOT_BELT
	var/lick_message = "tastes like dick"
	var/lick_message_ru = "на вкус как хер"
	var/mob/living/carbon/human/owner = null

	var/list/effects = list()						//Название эффекта у артефакта ОБЯЗАНО совпадать с этим же эффектом в artefacts_effects у моба
	var/list/initial_effects = list()
	var/exp_give = 10

	var/effects_applied = 0
	var/picked = 0
	var/rare = 0		//1 = Редкий, 2 = Уникальный
	var/is_lit = 1


/obj/item/artefact/examine(mob/user)
	var/word = pick("Это", "А это", "Перед тобой")

	if(desc_ru)
		user << user.client.select_lang("\icon[src]  [word] [name_ru]. [desc_ru]","\icon[src] That's an artefact [desc]")
	else
		user << user.client.select_lang("\icon[src]  [word] [name_ru]. [desc]","\icon[src] That's an artefact [desc]")

/obj/item/artefact/Initialize()
	..()
//	name = "artefact"
//	name_ru = "артефакт"
	name = name_ru
	icon_hands = icon_state
	icon_ground = "[icon_state]_ground"
//	icon_state = icon_ground
	initial_effects = effects.Copy()
	if(is_lit)
		set_light(1, 1, light_color)

/obj/item/artefact/pickup(mob/user)
	..()
	if(!picked)
		picked = 1
		SSstat.artefacts_picked++
		user.give_achievement("Odd garbage")
		if(rare > 0)
			user.give_achievement("Alien tool")
		if(rare > 1)
			user.give_achievement("God's sculpture")
		for(var/mob/living/carbon/human/H in view(7, user))
			H.give_exp(exp_give, "[name]_pickup", 10)

/obj/item/artefact/equipped(mob/user, slot)
	..()
	add_effects(user)
	if(is_lit)
		set_light(1, 1, light_color)

/obj/item/artefact/on_enter_storage()
	..()
	if(is_lit)
		set_light(0, 0)

/obj/item/artefact/on_exit_storage()
	..()
	add_effects(usr)
	if(is_lit)
		set_light(1, 1, light_color)

/obj/item/artefact/dropped/(mob/user)
	..()
	remove_effects(user)
	if(is_lit)
		set_light(1, 1, light_color)

/obj/item/artefact/Destroy()
	remove_effects(owner)
	if(is_lit)
		set_light(0, 0)
	return ..()

/obj/item/artefact/proc/add_effects(mob/user)
	if(effects && effects.len && !effects_applied)
		owner = user
		for(var/i in effects)
			if(effects[i])
				user.artefacts_effects[i] += effects[i]
		SSartefacts.humans_affected.Add(user)
		effects_applied = 1

/obj/item/artefact/proc/remove_effects(mob/user)
	if(effects && effects.len && effects_applied)
		owner = null
		for(var/i in effects)
			if(effects[i])
				user.artefacts_effects[i] -= effects[i]
				if(!user.artefacts_effects[i])
					user.artefacts_effects.Remove(i)
		SSartefacts.humans_affected.Remove(user)
		effects_applied = 0


/obj/item/artefact/proc/compress()						//Сжать артефакт
	usr.direct_visible_message("<span class='notice'>DOER squeezed TARGET</span>", message_ru = "<span class='notice'>DOER сжал TARGET</span>", span_class = "notice", doer = usr, target = src)
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_compress", 1)

/obj/item/artefact/proc/hit(mob/user, str_bonus = 0)				//Ударить артефакт
	usr.direct_visible_message("<span class='warning'>DOER hitted TARGET</span>", message_ru = "<span class='warning'>DOER ударил TARGET</span>", span_class = "warning", doer = usr, target = src)
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_hit", 1)

/obj/item/artefact/proc/rub()							//Потереть артефакт
	usr.direct_visible_message("<span class='notice'>DOER rubbed TARGET</span>", message_ru = "<span class='notice'>DOER потёр TARGET</span>", span_class = "notice", doer = usr, target = src)
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_rub", 1)

/obj/item/artefact/proc/shake()							//Потрясти артефакт
	usr.direct_visible_message("<span class='notice'>DOER shaked TARGET</span>", message_ru = "<span class='notice'>DOER встряхнул TARGET</span>", span_class = "notice", doer = usr, target = src)
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_shake", 1)

/obj/item/artefact/proc/lick()							//Лизнуть артефакт
	usr.direct_visible_message("<span class='notice'>DOER licked TARGET</span>", message_ru = "<span class='notice'>DOER лизнул TARGET</span>", span_class = "notice", doer = usr, target = src)
	usr << sanitize_russian(usr.client.select_lang("<i><span class='notice'>[lick_message_ru]</span></i>", "<i><span class='notice'>[lick_message]</span></i>"))
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_lick", 1)

/obj/item/artefact/proc/cut()							//Порезать артефакт
	usr.direct_visible_message("<span class='warning'>DOER cutted TARGET</span", message_ru = "<span class='warning'>DOER резанул TARGET</span>", span_class = "warning", doer = usr, target = src)
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_cut", 1)

/obj/item/artefact/proc/limb_attack(mob/living/carbon/human/H, def_zone)	//Атака артефактом в какую-либо часть тела

/obj/item/artefact/proc/passive_effect()

/obj/item/artefact/attackby(obj/item/I, mob/user)
	if(user.get_inactive_held_item() == src)
		if(I.sharpness)
			cut()
			return
		else
			hit(user, 2)
	..()

/obj/item/artefact/attack_self()
	var/action
	switch(usr.client.language)
		if("English")
			action = input("What do you want to do with the artefact?","Action","Nothing") in list("Nothing", "Compress", "Hit", "Rub", "Shake", "Lick")
		if("Russian")
			var/action_ru = input("Что ты хочешь сделать с артефактом?","Действие","Ничего") in list("Ничего", "Сжать", "Ударить", "Потереть", "ПотрЯсти", "Лизнуть")
			switch(action_ru)
				if("Сжать")
					action = "Compress"
				if("Ударить")
					action = "Hit"
				if("Потереть")
					action = "Rub"
				if("ПотрЯсти")
					action = "Shake"
				if("Лизнуть")
					action = "Lick"
				if("Ничего")
					action = "Nothing"

	switch(action)
		if("Nothing")
			return
		if("Compress")
			compress()
		if("Hit")
			hit(usr)
		if("Rub")
			rub()
		if("Shake")
			shake()
		if("Lick")
			lick()

/obj/item/artefact/attack(mob/living/M, mob/living/user, def_zone)
	if(ishuman(M))
		limb_attack(M, def_zone)
		return


/mob/living/carbon/human/proc/recalc_artefact_effects(obj/item/artefact/A)
	for(var/i in A.initial_effects)
		if(A.initial_effects[i])
			artefacts_effects[i] -= A.initial_effects[i]

	for(var/i in A.effects)
		if(A.effects[i])
			artefacts_effects[i] += A.effects[i]

/mob/living/carbon/human/proc/get_artefacts()
	var/list/items = list(r_store, l_store, belt)
	items += get_active_held_item()
	items += get_inactive_held_item()
	var/list/clothing = list(wear_suit, wear_suit_hard)
	for(var/obj/item/clothing/C in clothing)
		if(C.pockets)
			for(var/obj/item/I in C.pockets)
				items += I

	var/list/artefacts = list()
	for(var/obj/item/artefact/A in items)
		artefacts += A

	if(!artefacts.len)
		return

	return artefacts