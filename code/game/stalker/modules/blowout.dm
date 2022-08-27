var/isblowout = 0

/mob/living/carbon
	var/inshelter = 0

/area/stalker/blowout/Entered(var/atom/movable/A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(istype(src, /area/stalker/blowout/outdoor/prezone))
			C.inshelter = 1
			return ..()
//		if(C.client && isblowout && C.inshelter)
//			C << C.client.select_lang("<big><span class='warning'>Вы покидаете укрытие.</span></big>",
//									"<big><span class='warning'>You leave the shelter.</span></big>")
		C.inshelter = 0
		if(isblowout && SSblowout.blowoutphase == 3)
			C.dust()
	..()

/area/stalker/buildings/Entered(var/atom/movable/A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
//		if(C.client && isblowout && !C.inshelter)
//			C << C.client.select_lang("<big><span class='notice'>Вы заходите в укрытие.</span></big>",
//									"<big><span class='notice'>You enter the shelter.</span></big>")
		C.inshelter = 1
	..()

SUBSYSTEM_DEF(blowout)
	name = "Blowout"
	priority = 1
	wait = 20
	var/blowoutphase = 0
	var/cooldown = 27000
	var/lasttime = 0
	var/starttime = 0
	var/cleaned = 0
	var/players_num = 0
	var/list/ambient = list('sound/stalker/blowout/blowout_amb_01.ogg', 'sound/stalker/blowout/blowout_amb_02.ogg',
						'sound/stalker/blowout/blowout_amb_03.ogg', 'sound/stalker/blowout/blowout_amb_04.ogg',
						'sound/stalker/blowout/blowout_amb_05.ogg', 'sound/stalker/blowout/blowout_amb_06.ogg',
						'sound/stalker/blowout/blowout_amb_07.ogg', 'sound/stalker/blowout/blowout_amb_08.ogg')

	var/list/rumble = list('sound/stalker/blowout/blowout_ambient_rumble_01.ogg', 'sound/stalker/blowout/blowout_ambient_rumble_02.ogg',
							'sound/stalker/blowout/blowout_ambient_rumble_03.ogg', 'sound/stalker/blowout/blowout_ambient_rumble_04.ogg')

	var/list/wave = list('sound/stalker/blowout/blowout_wave_01.ogg', 'sound/stalker/blowout/blowout_wave_02.ogg',
						'sound/stalker/blowout/blowout_wave_03.ogg')

	var/list/boom = list('sound/stalker/blowout/blowout_boom_01.ogg', 'sound/stalker/blowout/blowout_boom_02.ogg',
						'sound/stalker/blowout/blowout_boom_03.ogg')

	var/list/lightning = list('sound/stalker/blowout/blowout_lightning_01.ogg', 'sound/stalker/blowout/blowout_lightning_02.ogg',
								'sound/stalker/blowout/blowout_lightning_03.ogg', 'sound/stalker/blowout/blowout_lightning_04.ogg',
								'sound/stalker/blowout/blowout_lightning_05.ogg', 'sound/stalker/blowout/blowout_flare_01.ogg',
								'sound/stalker/blowout/blowout_flare_02.ogg', 'sound/stalker/blowout/blowout_flare_03.ogg',
								'sound/stalker/blowout/blowout_flare_04.ogg')

	var/list/wind = list('sound/stalker/blowout/blowout_wind_01.ogg', 'sound/stalker/blowout/blowout_wind_02.ogg',
							'sound/stalker/blowout/blowout_wind_03.ogg')

/datum/controller/subsystem/blowout/Initialize()
	cooldown = 27000 + dice6(1) * 6000
	..()

/datum/controller/subsystem/blowout/fire()
	if(world.time >= lasttime + cooldown - (SStext.pre_blowout_1 ? 3000 : 6000))
		if(!SStext.pre_blowout_1)
			SStext.pre_blowout()
		else if(!SStext.pre_blowout_2)
			SStext.pre_blowout()

	if(world.time <= lasttime + cooldown)
		return

	if(!isblowout)
		StartBlowout()

	if(starttime)
		if((starttime + BLOWOUT_DURATION_STAGE_I + BLOWOUT_DURATION_STAGE_II + BLOWOUT_DURATION_STAGE_III) < world.time)
			if(blowoutphase == 3)
				AfterBlowout()

		else if((starttime + BLOWOUT_DURATION_STAGE_I + BLOWOUT_DURATION_STAGE_II) < world.time)
			if(blowoutphase == 2)
				BlowoutThirdStage()

		else if((starttime + BLOWOUT_DURATION_STAGE_I) < world.time)
			if(blowoutphase == 1)
				BlowoutSecondStage()
				PsyWave()
			ProcessBlowout()

		else if(starttime < world.time)
			ProcessBlowout()


/datum/controller/subsystem/blowout/proc/StartBlowout()
	SSsunlighting.blowout_started = world.time
	isblowout = 1
	blowoutphase = 1
	starttime = world.time

//	add_lenta_message(null, "0", "Sidorovich", "Loners", "ATTENTION, STALKERS! Blowout is starting! Find a shelter quick!")
	world << sound('sound/stalker/blowout/blowout_first_stage.ogg', wait = 0, channel = SSchannels.get_reserved_channel(4), volume = 100)
//	world << sound('sound/stalker/blowout/blowout_siren.ogg', wait = 0, channel = SSchannels.get_reserved_channel(5), volume = 60)

/datum/controller/subsystem/blowout/proc/BlowoutSecondStage()
	blowoutphase = 2
	world << sound('sound/stalker/blowout/blowout_second_stage.ogg', wait = 0, channel = SSchannels.get_reserved_channel(4), volume = 70)

/datum/controller/subsystem/blowout/proc/PsyWave()
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(!H.inshelter)
			H.adjustPsyLoss(-12)
	spawn(27 SECONDS)
		for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
			if(!H.inshelter)
				H.adjustPsyLoss(-12)

/datum/controller/subsystem/blowout/proc/BlowoutThirdStage()
	set background = 1
	blowoutphase = 3
	world << sound('sound/stalker/blowout/blowout_particle_wave.ogg', wait = 0, channel = SSchannels.get_reserved_channel(4), volume = 70, repeat = 1)

	for(var/client/C in GLOB.clients)
		C.fps = 40

	world.fps = 10

	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(H.client)
			if(!H.inshelter)
				H.dust()

			else
				H.convert_temp_exp()
				H.client.loadout.exp_actions.Remove("walking")
			H.SetParalysis(5000)
			spawn(30)
				H.blowout_occupation()

	if(!players_num)
		players_num = GLOB.clients.len

	for(var/datum/data/stalker_equipment/se in real_sidormat_items)
		se.estimated_demand = round(/*se.estimated_demand / 2 + */se.total_sold / players_num / 2, 0.01)
		se.total_sold = 0
		se.estimated_supply = round(/*se.estimated_supply / 2 + */se.total_bought / players_num / 2, 0.01)
		se.total_bought = 0
		if(!se.assortment_level)
			se.assortment_level += max(1, round((se.estimated_demand - se.estimated_supply) * GLOB.clients.len))
		else
			se.assortment_level += max(0, round((se.estimated_demand - se.estimated_supply) * GLOB.clients.len))
		se.cost = se.initial_cost

	players_num = GLOB.clients.len

	BlowoutClean()

	SSzonegenerator.regenerate_chunks()

	for(var/obj/effect/mob_spawner/MS in GLOB.mob_spawners)
		MS.mob_spawn()

//	SSgarbage.Everything_to_HD()

	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		H.SetParalysis(0)
		H.medkit_was_used = 0

	world.fps = 40

	for(var/client/C in GLOB.clients)
		C.fps = 0


/datum/controller/subsystem/blowout/proc/BlowoutClean()
	set background = 1

	for(var/obj/item/ammo_casing/AC in GLOB.ACs)
		GLOB.ACs.Remove(AC)
		qdel(AC)
		CHECK_TICK

	for(var/mob/living/L in GLOB.dead_mob_list)
		qdel(L)
		CHECK_TICK

	for(var/mob/living/simple_animal/hostile/H in GLOB.living_mob_list)
		if(H.z == 2)
			qdel(H)
		CHECK_TICK

	for(var/obj/structure/closet/grave/G in world)
		qdel(G)
		CHECK_TICK

	for(var/obj/item/artefact/A in world)
		if(!A.picked)
			qdel(A)
		CHECK_TICK


/datum/controller/subsystem/blowout/proc/AfterBlowout()
	world << sound('sound/stalker/blowout/blowout_outro.ogg', wait = 0, channel = SSchannels.get_reserved_channel(4), volume = 100)

	cooldown = 27000 + dice6(1) * 6000
	isblowout = 0
	lasttime = world.time
	starttime = 0
	blowoutphase = 0
	SSstat.blowouts_happened++

	SStext.pre_blowout_1 = 0
	SStext.pre_blowout_2 = 0

	world << sound(null, wait = 0, channel = SSchannels.get_reserved_channel(6))
	world << sound(null, wait = 0, channel = SSchannels.get_reserved_channel(7))
	world << sound(null, wait = 0, channel = SSchannels.get_reserved_channel(8))
	world << sound(null, wait = 0, channel = SSchannels.get_reserved_channel(9))
	world << sound(null, wait = 0, channel = SSchannels.get_reserved_channel(10))
	world << sound(null, wait = 0, channel = SSchannels.get_reserved_channel(11))
/*
	/////////////////////////////////////
	////Deleting old stalker profiles////
	//for(var/datum/data/record/sk in data_core.stalkers)
	//	if(sk.fields["lastlogin"] + 27000 < world.time)
	//		data_core.stalkers -= sk
	/////////////////////////////////////

	//Очистка ленты
	global_lentahtml = ""
	for(var/obj/item/device/stalker_pda/KPK in KPKs)
		KPK.lentahtml = ""

	add_lenta_message(null, "0", "Sidorovich", "Loners", "Blowout is over! Leave the shelter.")
*/
/datum/controller/subsystem/blowout/proc/ProcessBlowout()
	if(isblowout)
		for(var/mob/living/carbon/human/H)
			if(!H.inshelter)
				if(prob(25))
					switch(blowoutphase)
						if(1)
							shake_camera(H, 1, 1)
						if(2)
							shake_camera(H, 2, 1)

	if(prob(20))
		var/a = pick(ambient)
		world << sound(a, wait = 1, channel = SSchannels.get_reserved_channel(6), volume = 70)

	if(prob(30))
		var/a = pick(wave)
		world << sound(a, wait = 1, channel = SSchannels.get_reserved_channel(7), volume = 70)

	if(prob(20))
		var/a = pick(wind)
		world << sound(a, wait = 1, channel = SSchannels.get_reserved_channel(8), volume = 70)

	if(prob(30))
		var/a = pick(rumble)
		world << sound(a, wait = 1, channel = SSchannels.get_reserved_channel(9), volume = 70)

	if(prob(50))
		var/a = pick(boom)
		world << sound(a, wait = 1, channel = SSchannels.get_reserved_channel(10), volume = 70)

	if(prob(50))
		var/a = pick(lightning)
		world << sound(a, wait = 1, channel = SSchannels.get_reserved_channel(11), volume = 70)