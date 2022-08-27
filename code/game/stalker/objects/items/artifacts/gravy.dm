
//	Артефакты гравитационные по своей природе	//

/obj/item/artefact/gravy
	light_color = LIGHT_COLOR_TUNGSTEN

/obj/item/artefact/gravy/puzir
	name = "Bubble"
	name_ru = "Пузырь"
	icon_state = "puzir"
	weight = 0
	lick_message = ""
	lick_message_ru = "На вкус как земля"

	effects = list("weight" = -10)

/obj/item/artefact/gravy/puzir/cut()
	..()
	playsound(get_turf(src), 'sound/effects/Explosion2.ogg', 100, time = 20)
	var/obj/anomaly/natural/gravy/vortex/V = new(get_turf(src))
	remove_effects(usr)
	qdel(src)
	for(var/mob/living/L in range(V.range, V))
		V.trapped.Add(L)
	V.Think()
	qdel(V)

/obj/item/artefact/gravy/puzir/proc/plesh()
	icon_state = "puzir-use"
	icon_hands = "puzir-use"
	icon_ground = "puzir_ground-use"
	usr << usr.client.select_lang("<i><span class='notice'>[name_ru] начал теплеть.</span></i>", "<i><span class='notice'>[name] feels warmer.</span></i>")
	spawn(dice6(1) SECONDS)
		var/obj/anomaly/natural/gravy/mosquito_net/MN = new(get_turf(src))
		for(var/turf/stalker/T in range(MN.range, MN))
			if(T.triggers)
				T.triggers.Remove(MN)
		MN.range = 3
		MN.weight_rise = 4
		for(var/turf/stalker/T in range(MN.range, MN))
			if(!T.triggers)
				T.triggers = list()
			T.triggers.Add(MN)
		for(var/atom/A in range(MN.range, MN))
			MN.Activate(A)

		spawn(dice6(2)*5 SECONDS)
			remove_effects(usr)
			qdel(src)
			qdel(MN)

/obj/item/artefact/gravy/puzir/compress()
	..()
	plesh()

/obj/item/artefact/gravy/puzir/shake()
	..()
	plesh()