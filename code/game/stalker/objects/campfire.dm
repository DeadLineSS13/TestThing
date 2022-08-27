/obj/machinery/campfire
	name = "Campfire"
	desc = "Bonfire in the barrel."
	desc_ru = "Костер в бочке."
	icon = 'icons/stalker/stalker.dmi'
	icon_state = "campfire0"
	anchored = 1
	var/on = 0
	var/fuel = 500

	light_color = COLOUR_LTEMP_CANDLE

obj/machinery/campfire/barrel
	name = "barrel"
	name_ru = "костёр"
	icon = 'icons/stalker/machinery/bochka.dmi'
	icon_state = "barrel0"
	density = 1


/obj/machinery/campfire/attack_hand(mob/user)
	..()
	if(on)
		user.direct_visible_message("<span class='notice'>DOER started to extinguish the campfire...</span>",\
									 "<span class='notice'>You started to extinguish the campfire...</span>",\
									 "<span class='notice'>DOER начал тушить костёр...</span>",\
									 "<span class='notice'>Ты начал тушить костёр...</span>","notice",user)
		if(!do_after(user, 50, 1, src))	return
		user.direct_visible_message("<span class='green'>DOER extinguished the campfire.</span>",\
									 "<span class='green'>You extinguished the campfire.</span>",\
									 "<span class='green'>DOER потушил костёр.</span>",\
									 "<span class='green'>Ты потушил костёр.</span>","green",user)
		on = !on
		update_icon()
		set_light(0)
		update_state()

/obj/machinery/campfire/update_icon()
	icon_state = "campfire[on]"
	return

/obj/machinery/campfire/barrel/update_icon()
	icon_state = "barrel[on]"
	return

/obj/machinery/campfire/New()
	..()
	spawn while(1)
		sound_play()
		sleep(40)

/obj/machinery/campfire/proc/sound_play()
	if(on)
		playsound(src, 'sound/stalker/objects/sounded/campfire/campfire.ogg', 100, 0, -4, 1, channel = SSchannels.get_reserved_channel(19))
		if(prob(10))
			playsound(src, "fire_cracking", 100, 0, -4, 1, channel = SSchannels.get_reserved_channel(20))

/obj/machinery/campfire/proc/update_state()
	if(on)
		if(src.fuel > 750)
			set_light(5)
		else

			if(src.fuel > 500)
				set_light(4)
			else
				if(src.fuel > 250)
					set_light(3)
				else
					if(src.fuel > 0)
						set_light(2)
	else
		set_light(0)


/obj/machinery/campfire/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stalker/brushwood) && src.fuel < 850)
		fuel += 250
		qdel(I)
		update_state()
		if(fuel > 850)
			if(on)
				user << user.client.select_lang("Костёр горит достаточно ярко.","The fire burns bright enough.")
			else
				user << user.client.select_lang("В костре достаточно дров.","There is enough wood in the bonfire.")
		else
			if(on)
				user << user.client.select_lang("Ты подложил хвороста в костёр. Костёр начал гореть ярче.","You added brushwood in the bonfire. The fire began to light brighter.")
			else
				user << user.client.select_lang("Ты подложил хвороста в костёр.", "You added some brushwood in the bonfire.")

	else if(src.fuel > 50)
		if(istype(I, /obj/item/weapon/match))
			var/obj/item/weapon/match/M = I
			if(M.lit == 1 && !on)
				on = !on
				user.direct_visible_message("<span class='notice'>DOER fires the bonfire.</span>", "<span class='notice'>You lit the bonfire.</span>",\
											"<span class='notice'>DOER разжёг костёр.</span>", "<span class='notice'>Ты разжёг костёр.</span>","notice",user)
				update_icon()
			else
				if(M.lit == 0 && on)
					M.fire_act()
		else
			if(istype(I, /obj/item/weapon/lighter))
				var/obj/item/weapon/lighter/L = I
				if(L.lit == 1 && !on)
					on = !on
					user.direct_visible_message("<span class='notice'>DOER fires the bonfire.</span>", "<span class='notice'>You lit the bonfire.</span>",\
											"<span class='notice'>DOER разжёг костёр.</span>", "<span class='notice'>Ты разжёг костёр.</span>","notice",user)
					update_icon()

			else
				if(on)
					I.fire_act()
	else
		user << user.client.select_lang("<span class='warning'>В костре нечему гореть!</span>","<span class='warning'>There's nothing to burn in the campfire!</span>")
		return



/obj/machinery/campfire/process()
	if(!on || (stat & BROKEN))
		return
	if(on)
		src.fuel -= 2.5
		update_state()

	if(src.fuel < 0)
		on = 0
		update_state()
		update_icon()

	var/mob/living/L
	for(L in range(2, src))
		if(L.wet)
			L.wet -= 10

/obj/item/stalker/brushwood
	name = "brushwood"
	icon = 'icons/stalker/items.dmi'
	icon_state = "brushwood"
	icon_ground = "brushwood_ground"
	desc = "A small bale of tree branches."
	desc_ru = "Небольшая кипа древесных веток."
	weight = 1.5
	w_class = 3