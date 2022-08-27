/area
	var/electro_storm = 0
	var/outdoors = 0
	var/darkning = 0	//От 0 до 1 степень затемнение дневного освещения
	ambient_environment = list('sound/stalker/ambience/rnd_outdoor/rnd_bird_1.ogg','sound/stalker/ambience/rnd_outdoor/rnd_bird_2.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_bird_3.ogg','sound/stalker/ambience/rnd_outdoor/rnd_bird_4.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_bird_5.ogg','sound/stalker/ambience/rnd_outdoor/rnd_bird_6.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_bird_7.ogg','sound/stalker/ambience/rnd_outdoor/rnd_bird_8.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_bird_9.ogg','sound/stalker/ambience/rnd_outdoor/rnd_bird_10.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_bird_11.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_dog1.ogg','sound/stalker/ambience/rnd_outdoor/rnd_dog2.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_dog3.ogg','sound/stalker/ambience/rnd_outdoor/rnd_dog4.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_dog5.ogg','sound/stalker/ambience/rnd_outdoor/rnd_dog6.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_dog7.ogg','sound/stalker/ambience/rnd_outdoor/rnd_dog8.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_dog9.ogg','sound/stalker/ambience/rnd_outdoor/rnd_dog10.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_crow_1.ogg','sound/stalker/ambience/rnd_outdoor/rnd_crow_2.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_crow_3.ogg','sound/stalker/ambience/rnd_outdoor/rnd_crow_4.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_crow_5.ogg','sound/stalker/ambience/rnd_outdoor/rnd_crow_6.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_crow_7.ogg','sound/stalker/ambience/rnd_outdoor/rnd_crow_8.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_crow_9.ogg','sound/stalker/ambience/rnd_outdoor/rnd_crow_10.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_crow_11.ogg','sound/stalker/ambience/rnd_outdoor/rnd_crow_12.ogg',
					'sound/stalker/ambience/rnd_outdoor/ambient_wind_1.ogg','sound/stalker/ambience/rnd_outdoor/ambient_wind_2.ogg',
					'sound/stalker/ambience/rnd_outdoor/ambient_wind_3.ogg','sound/stalker/ambience/rnd_outdoor/ambient_wind_4.ogg',
					'sound/stalker/ambience/rnd_outdoor/rnd_insect_8.ogg',
					)

	ambient_environment_night = list('sound/stalker/ambience/rnd_outdoor_night/rnd_moan.ogg','sound/stalker/ambience/rnd_outdoor_night/rnd_moan2.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/rnd_moan3.ogg','sound/stalker/ambience/rnd_outdoor_night/rnd_moan4.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/rnd_moan5.ogg','sound/stalker/ambience/rnd_outdoor_night/rnd_moan6.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/ambient_night_1.ogg','sound/stalker/ambience/rnd_outdoor_night/ambient_night_2.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/ambient_night_3.ogg','sound/stalker/ambience/rnd_outdoor_night/ambient_night_4.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/ambient_night_5.ogg','sound/stalker/ambience/rnd_outdoor_night/ambient_night_6.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/ambient_night_7.ogg','sound/stalker/ambience/rnd_outdoor_night/ambient_night_8.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/ambient_night_9.ogg','sound/stalker/ambience/rnd_outdoor_night/ambient_night_10.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/wolf_howl_01.ogg','sound/stalker/ambience/rnd_outdoor_night/wolf_howl_02.ogg',
					'sound/stalker/ambience/rnd_outdoor_night/wolf_howl_03.ogg','sound/stalker/ambience/rnd_outdoor_night/wolf_howl_04.ogg',
					)
	ambient_environment_cooldown = 420
	ambient_background = list(null, null,'sound/stalker/ambience/rnd_outdoor_night/zat_bkg_tuman.ogg', 'sound/stalker/ambience/rnd_outdoor_night/ambient_night_11.ogg', null) // 'sound/stalker/ambience/rnd_outdoor/rnd_insect_5.ogg' - evening
	ambient_background_cooldown = list(null, null, 220, 420, null) //280 - evening
	environment = 15


/area/stalker
	icon = 'icons/stalker/turfs/areas.dmi'
	name = "Strange Location"
	icon_state = "away"
	has_gravity = 1
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

	var/anomaly_chance = 5
	var/list/anomalies_to_spawn = list()
	var/blowout_sleep = 1
//	requires_power = 0
/*
/area/Enter(mob/living/carbon/human/H)
	..()

	if(electro_storm)
		var/list/items = H.get_all_slots()
		for(var/obj/item/clothing/head/with_vision/I in items)
			if(I.matrix_on)
				I.ToggleMatrix()
			I.turnable = 0

	return 1

/area/Exit(mob/living/carbon/human/H)
	..()

	if(electro_storm)
		var/list/items = H.get_all_slots()
		for(var/obj/item/clothing/head/with_vision/I in items)
			I.turnable = 1

	return 1
*/

/area/Entered(atom/A)
	..()
	if(!ishuman(A))
		return

	var/mob/living/carbon/human/H = A

	if(!H.client)
		return

	if(!darkning)
		return

	for(var/obj/screen/plane_master/sunlighting/P in H.client.screen)
		P.darkning = darkning

/area/Exited(atom/A)
	..()
	if(!ishuman(A))
		return

	var/mob/living/carbon/human/H = A

	if(!H.client)
		return

	for(var/obj/screen/plane_master/sunlighting/P in H.client.screen)
		P.darkning = 0

/area/stalker/blowout
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED

/area/stalker/blowout/buildings
	name = "Buildings"
	icon_state = "buildings"

/area/stalker/blowout/buildings/factory
	name = "Factory"

/area/stalker/blowout/buildings/factory/administrative

/area/stalker/blowout/buildings/factory/garages

/area/stalker/blowout/buildings/factory/cargo

/area/stalker/blowout/buildings/factory/production

/area/stalker/blowout/buildings/factory/kpp


/area/stalker/blowout/buildings/lelev
	name = "Lelev"

/area/stalker/blowout/buildings/lelev/hangar

/area/stalker/blowout/buildings/lelev/administrative

/area/stalker/blowout/buildings/lelev/house


/area/stalker/blowout/buildings/farm
	name = "Farm"

/area/stalker/blowout/buildings/farm/south

/area/stalker/blowout/buildings/farm/north

/area/stalker/blowout/buildings/farm/utility


/area/stalker/blowout/buildings/wild
	name = "Wild Territories"

/area/stalker/blowout/buildings/wild/house

/area/stalker/blowout/outdoor
	name = "Outdoor"
	icon_state = "outdoor"
	open_space = 1
	outdoors = 1

/area/stalker/blowout/outdoor/unanomaly

/area/stalker/blowout/outdoor/prezone
	name = "prezone"
	blowout_sleep = 0

/area/stalker/blowout/outdoor/anomaly
	name = "Anomaly place"
	anomaly_chance = 7
	anomalies_to_spawn = list(/obj/anomaly/natural/gravy/tramplin = 2200, /obj/anomaly/natural/gravy/vortex = 1900,
							/obj/anomaly/natural/gravy/mosquito_net = 100,/obj/anomaly/natural/gravy/trap = 50, /obj/anomaly/natural/gravy/mobius = 5,
							/obj/anomaly/natural/electro = 1900, /obj/anomaly/natural/tesla_ball = 5, /obj/anomaly/natural/tesla_ball_double = 2,
							/obj/anomaly/natural/fire/jarka = 1900, /obj/anomaly/natural/fire/demon = 3, /obj/anomaly/natural/toxic/vedmin_studen = 100)


/area/stalker/blowout/outdoor/anomaly/high
	name = "Anomaly place"
	anomaly_chance = 20


/area/stalker/blowout/outdoor/map_edge
	name = "Map Edge"

/area/stalker/blowout/outdoor/lelev
	name = "Lelev"
	anomaly_chance = 4
	anomalies_to_spawn = list(/obj/anomaly/natural/gravy/tramplin = 2200, /obj/anomaly/natural/gravy/vortex = 1900,
							/obj/anomaly/natural/gravy/mosquito_net = 100,/obj/anomaly/natural/gravy/trap = 50, /obj/anomaly/natural/gravy/mobius = 5,
							/obj/anomaly/natural/electro = 1900, /obj/anomaly/natural/tesla_ball = 5, /obj/anomaly/natural/tesla_ball_double = 2,
							/obj/anomaly/natural/fire/jarka = 1900, /obj/anomaly/natural/fire/demon = 3, /obj/anomaly/natural/toxic/vedmin_studen = 100)


/area/stalker/blowout/outdoor/anomaly/PUSO
	name = "PUSO"
	anomaly_chance = 3
	anomalies_to_spawn = list(/obj/anomaly/natural/gravy/tramplin = 2200, /obj/anomaly/natural/gravy/vortex = 1900,
							/obj/anomaly/natural/gravy/mosquito_net = 100,/obj/anomaly/natural/gravy/trap = 50, /obj/anomaly/natural/gravy/mobius = 5,
							/obj/anomaly/natural/electro = 1900, /obj/anomaly/natural/tesla_ball = 5, /obj/anomaly/natural/tesla_ball_double = 2,
							/obj/anomaly/natural/fire/jarka = 1900, /obj/anomaly/natural/fire/demon = 3,
							/obj/anomaly/natural/toxic/rust_puddle = 775, /obj/anomaly/natural/toxic/vedmin_studen = 100)


/area/stalker/blowout/outdoor/lelev_village
	name = "Village"

/area/stalker/blowout/outdoor/factory

/area/stalker/blowout/outdoor/anomaly/factory
	name = "Factory outdoor"
	anomaly_chance = 3
	anomalies_to_spawn = list(/obj/anomaly/natural/gravy/tramplin = 2200, /obj/anomaly/natural/gravy/vortex = 1900,
							/obj/anomaly/natural/gravy/mosquito_net = 100,/obj/anomaly/natural/gravy/trap = 50, /obj/anomaly/natural/gravy/mobius = 5,
							/obj/anomaly/natural/electro = 1900, /obj/anomaly/natural/tesla_ball = 5, /obj/anomaly/natural/tesla_ball_double = 2,
							/obj/anomaly/natural/fire/jarka = 1900, /obj/anomaly/natural/fire/demon = 3,
							/obj/anomaly/natural/toxic/rust_puddle = 775, /obj/anomaly/natural/toxic/vedmin_studen = 100)


/area/stalker/blowout/outdoor/anomaly/farm
	name = "Farm outdoor"
	anomaly_chance = 3


/area/stalker/buildings
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	icon_state = "buildingsS"

/area/stalker/buildings/prezone
	name = "prezone"
	blowout_sleep = 0


/area/stalker/buildings/hotel
	name = "hotel"
	blowout_sleep = 0

/area/stalker/buildings/hangar
	environment = 10

/area/stalker/buildings/sidor
	name = "Sidorovich Basement"
	icon_state = "sidor"
	blowout_sleep = 0

/area/stalker/buildings/caves
	name = "Agroprom caves"
	icon_state = "caves"
	electro_storm = 1
	ambient_background = list('sound/stalker/ambience/ugrnd/howled_4.ogg', 'sound/stalker/ambience/ugrnd/howled_4.ogg', 'sound/stalker/ambience/ugrnd/howled_4.ogg', 'sound/stalker/ambience/ugrnd/howled_4.ogg')
	ambient_background_cooldown = list(270, 270, 270, 270)
	ambient_environment = list('sound/stalker/ambience/ugrnd/rnd_ugrnd_amb_1.ogg','sound/stalker/ambience/ugrnd/rnd_ugrnd_amb_2.ogg',
				'sound/stalker/ambience/ugrnd/rnd_ugrnd_amb_3.ogg','sound/stalker/ambience/ugrnd/rnd_ugrnd_amb_4.ogg',
				'sound/stalker/ambience/ugrnd/rnd_ugrnd_amb_5.ogg','sound/stalker/ambience/ugrnd/rnd_ugrnd_amb_6.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_5.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_6.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_7.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_banging_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_banging_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_banging_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_banging_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_banging_5.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_banging_6.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_banging_7.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_machine_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_machine_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_machine_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_ambient_machine_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_ambient_machine_5.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drip_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_drip_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drip_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_drip_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drip_5.ogg','sound/stalker/ambience/ugrnd/ugrnd_drip_6.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drip_7.ogg','sound/stalker/ambience/ugrnd/ugrnd_drip_8.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drip_9.ogg','sound/stalker/ambience/ugrnd/ugrnd_drip_10.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drip_11.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drone_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_drone_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_drone_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_drone_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_lab_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_lab_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_lab_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_lab_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_lab_5.ogg','sound/stalker/ambience/ugrnd/ugrnd_lab_6.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_metal_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_metal_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_metal_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_metal_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_metal_5.ogg','sound/stalker/ambience/ugrnd/ugrnd_metal_6.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_metal_7.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_noise_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_noise_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_noise_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_noise_4.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_noise_5.ogg','sound/stalker/ambience/ugrnd/ugrnd_noise_6.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_noise_7.ogg','sound/stalker/ambience/ugrnd/ugrnd_noise_8.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_noise_9.ogg','sound/stalker/ambience/ugrnd/ugrnd_noise_10.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_noise_11.ogg','sound/stalker/ambience/ugrnd/ugrnd_noise_12.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_whispers_1.ogg','sound/stalker/ambience/ugrnd/ugrnd_whispers_2.ogg',
				'sound/stalker/ambience/ugrnd/ugrnd_whispers_3.ogg','sound/stalker/ambience/ugrnd/ugrnd_whispers_4.ogg',
				)
	ambient_environment_cooldown = 800
	environment = 8



/area/stalker/buildings/cellar
	name = "Cellar"

/area/stalker/buildings/cellar/lelev

/area/stalker/buildings/cellar/wild

/area/stalker/buildings/cellar/farm

/area/stalker/buildings/cellar/factory

/area/stalker/buildings/cellar/wild

/area/stalker/buildings/cellar/wild/first

/area/stalker/buildings/cellar/wild/second

/area/stalker/buildings/cellar/wild/third

/area/stalker/buildings/cellar/wild/fourth

/area/stalker/buildings/cellar/wild/fifth

/area/stalker/buildings/cellar/wild/sixth

/area/stalker/buildings/cellar/wild/seventh