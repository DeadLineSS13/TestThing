/obj/item/weapon/reagent_containers/food/cauldron
	name = "cauldron"
	name_ru = "котелок"
	icon = 'icons/stalker/cooking.dmi'
	icon_state = "cauldron"
	desc = "A large metal pot with a lid and handle, used for cooking over an open fire."
	desc_ru = "Маленький котёл, сосуд для варки пищи, для еды из него."
	possible_transfer_amounts = list()
	weight = 0.4
	force = 5
	var/c_contents
	var/eatverb
	var/cooked = 0
	var/have_food


/obj/item/weapon/reagent_containers/food/cauldron/attackby(obj/item/weapon/reagent_containers/food/snacks/stalker/R, mob/user, params)
	..()
	if(istype(R, /obj/item/weapon/reagent_containers/food/snacks/stalker))
		if(R.wrapped)
			return

		if(!R.can_be_cooked)
			return

		if(!c_contents)
			if(istype(R, /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup))
				c_contents = "soup"
			if(istype(R, /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/bobi))
				c_contents = "bobi"
			if(istype(R, /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/govyadina2))
				c_contents = "beef"
			if(istype(R, /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/buckwheat))
				c_contents = "buckwheat"
			if(istype(R, /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/cmilk))
				c_contents = "cmilk"

			icon_state = c_contents
			weight = initial(weight) + (R.weight - 0.1)

/obj/item/weapon/reagent_containers/food/cauldron/proc/On_Consume()
	if(!reagents.total_volume)
		icon_state = initial(icon_state)
		c_contents = null
		cooked = 0
		have_food = 0
	return

/obj/item/weapon/reagent_containers/food/cauldron/attack(mob/M, mob/user, def_zone)
	if(user.a_intent == "harm")
		return ..()
	if(!c_contents)
		return
	if(!eatverb)
		eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	if(iscarbon(M))
		if(!canconsume(M, user))
			return 0

		var/fullness = M.nutrition + 10
		for(var/datum/reagent/consumable/C in M.reagents.reagent_list) //we add the nutrition value of what we're currently digesting
			fullness += C.nutriment_factor * C.volume / C.metabolization_rate

		if(M == user)								//If you're eating it yourself.
			if(fullness <= 150)
				M << "<span class='notice'>You hungrily begin to eat from \the [src].</span>"
			else if(fullness > 150 && fullness < 500)
				M << "<span class='notice'>You eat from \the [src].</span>"
			else if(fullness > 500 && fullness < 600)
				M << "<span class='notice'>You unwillingly eat from \the [src].</span>"
			else if(fullness > (600 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				M << "<span class='warning'>You cannot force any more of \the food to go down your throat!</span>"
				return 0
		else
			user << "<span class='warning'>[M] doesn't seem to have a mouth!</span>"
			return

		if(reagents)								//Handle ingestion of the reagent.
			playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1, channel = "regular", time = 10)
			if(reagents.total_volume)
				var/fraction = min(3/reagents.total_volume, 1)
				reagents.reaction(M, INGEST, fraction)
				reagents.trans_to(M, 3)
//				if(istype(M, /mob/living/carbon/human))
//					var/mob/living/carbon/human/H = M
//					H.not_digested += 1
				On_Consume()
			return 1

	return 0

/obj/machinery/campfire/attackby(obj/item/I, mob/user, params)
	..()
	if(flags & IN_PROGRESS)
		return

	if((istype(I, /obj/item/weapon/reagent_containers/food/cauldron)) && (on))
		for(var/obj/item/weapon/reagent_containers/food/cauldron/C)
			if(C.cooked)
				return
			if(C.c_contents != null)
				user << user.client.select_lang("<span class='notice'>Вы начали готовить на костре.</span>","<span class='notice'>You start cooking at the bonfire.</span>")
				flags += IN_PROGRESS
				if(!do_after(user, 300, 1, src))
					flags &= ~IN_PROGRESS
					return
				user << user.client.select_lang("<span class='notice'>Вы закончили готовку.</span>","<span class='notice'>You've finished cooking.</span>")
				flags &= ~IN_PROGRESS
				C.icon_state = "[C.c_contents]_cooked"
				C.reagents.add_reagent("nutriment", 8)
				C.cooked = 1
			else
				return

	else
		return

/obj/item/weapon/reagent_containers/food/snacks/stalker/afterattack(obj/target, mob/user, proximity)
	..()

	if(wrapped)
		return

	if(istype(target, /obj/item/weapon/reagent_containers/food/cauldron))
		if(!can_be_cooked)
			user << user.client.select_lang("<span class='warning'>Вы не можете это приготовить.</span>","<span class='warning'>You cant cook it.</span>")
			return
		for(var/obj/item/weapon/reagent_containers/food/cauldron/C)
			if(C.have_food)
				return
			if(!C.reagents)
				reagents.trans_to(C, reagents.total_volume)
				user << user.client.select_lang("<span class='notice'>Вы опустошили содержимое банки в котелок.</span>","<span class='notice'>You've emptied the contents of the can into the cauldron.</span>")
				On_Consume()
				C.have_food = 1