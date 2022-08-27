//proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, channel, surround = 1, repeat_sound = 0)
//extrarange - к стандартному вижену добавл€етс€ в рендж число, может быть отрицательным

/obj/machinery/light/small/red
	icon_state = "firelight1"
	base_state = "firelight"
	fitting = "fire_bulb"
	brightness = 4
	light_color = rgb(220, 0, 0)
	var/channel_

/obj/machinery/light/small/red/New()
	..()
	channel_ = SSchannels.get_reserved_channel()
	switch(src.dir)
		if(1)
			pixel_y = 7
		if(2)
			pixel_y = -7
		if(4)
			pixel_x = 7
		if(8)
			pixel_x = -7

	if(on)
		spawn while(1)
			set_light(4)
			sleep(3)
			set_light(3.5)
			sleep(3)
			set_light(3)
			playsound(src, 'sound/stalker/objects/sounded/lamp_squeaks_2.ogg', 100, 0, -3, 1, channel_)
			sleep(3)
			set_light(2.5)
			sleep(3)
			set_light(2)
			sleep(3)
			set_light(2.5)
			sleep(3)
			set_light(3)
			sleep(3)
			set_light(3.5)
			sleep(3)

/obj/machinery/power/port_gen/pacman/sounded
	name = "Generator"
	icon = 'icons/stalker/machinery/machinery.dmi'
	icon_state = "generator"
	var/channel_

/obj/machinery/power/port_gen/pacman/sounded/New()
	..()
	channel_ = SSchannels.get_reserved_channel()
	spawn while(1)
		playsound(src, 'sound/stalker/objects/sounded/generator.ogg', 100, 0, 0, 1, channel_)
		if(prob(1))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(2, 1, src)
			s.start()
		sleep(4)

/obj/effect/stalker/propaganda_megaphone
	name = "megaphone"
	invisibility = 101
	var/channel_

/obj/effect/stalker/propaganda_megaphone/New()
	channel_ = SSchannels.get_reserved_channel()
	spawn while(1)
		sleep(rand(300, 600))
		playsound(src, "propaganda", 100, 0, 33, 1, channel_)

/obj/effect/stalker/spatial_bubble
	name = "Anomaly bubble"
	invisibility = 101
	var/channel_

/obj/effect/stalker/spatial_bubble/New()
	channel_ = SSchannels.get_reserved_channel()
	spawn while(1)
		sleep(rand(200, 500))
		playsound(src, "spatial bubble", 100, 0, 8, 0, channel_)

/area/stalker/buildings/bar
	blowout_sleep = 0
	var/list/people = list()

/area/stalker/buildings/bar/Entered(A)
	if(ishuman(A))
		people |= A

	if(people.len >= 4)
		var/mob/living/carbon/human/H = A
		for(H in get_area(H))
			H << sound('sound/stalker/objects/sounded/bar_noise.ogg', repeat = 1, SSchannels.get_reserved_channel(33))

	..()

/area/stalker/buildings/bar/Exit(A)
	..()

	if(ishuman(A))
		people -= A

	if(people.len < 4)
		var/mob/living/carbon/human/H = A
		for(H in get_area(H))
			H << sound(null, channel = SSchannels.get_reserved_channel(33))

	return 1

/obj/structure/stalker/electric/radio
	name_ru = "радио"
	name = "radio"
	desc = "Old broken soviet radio."
	desc_ru = "—тарое сломанное советское радио."
	icon = 'icons/stalker/structure/electric.dmi'
	icon_state = "radio"


/obj/structure/stalker/electric/radio/UVB76
	name = "strange radio"
	desc = "Strange soviet radio."
	desc_ru = "—транное старое советское радио."
	var/channel_

/obj/structure/stalker/electric/radio/UVB76/New()
	..()
	channel_ = SSchannels.get_reserved_channel()
	spawn while(1)
		playsound(src, 'sound/stalker/objects/sounded/UVB-76.ogg', 10, 0, -2, 1, channel_)
		sleep(20.5)