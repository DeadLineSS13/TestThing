/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, channel = "regular", surround = 1, repeat_sound = 0, time = 600)

	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		throw EXCEPTION("playsound(): source is an area")
		return

	var/frequency

	var/turf/turf_source = get_turf(source)

	switch(channel)
		if("reserved")
			channel = SSchannels.get_reserved_channel()
		if("regular")
			channel = SSchannels.get_channel(time)

	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/P in GLOB.player_list)
		var/mob/M = P
		if(!M || !M.client)
			continue
		if(get_dist(M, turf_source) <= world.view + extrarange)
			var/turf/T = get_turf(M)
			if(T && T.z == turf_source.z)
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, surround, channel, repeat_sound)

/atom/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, surround = 1, channel, repeat_sound = 0)
	soundin = get_sfx(soundin)

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	if(channel)
		S.channel = channel
	else
		S.channel = 0 //Any channel
	S.volume = vol
	S.repeat = repeat_sound
	var/area/A = get_area(turf_source)
	S.environment = A.environment


	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/T = get_turf(src)

		//Atmosphere affects sound
	//	var/pressure_factor = 1
	//	var/datum/gas_mixture/hearer_env = T.return_air()
	//	var/datum/gas_mixture/source_env = turf_source.return_air()

	//	if(hearer_env && source_env)
	//		var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
	//		if(pressure < ONE_ATMOSPHERE)
	//			pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
	//	else //space
	//		pressure_factor = 0

	//	var/distance = get_dist(T, turf_source)
	//	if(distance <= 1)
	//		pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

	//	S.volume *= pressure_factor
		//End Atmosphere affecting sound

		if(S.volume <= 0)
			return //No sound

		// 3D sounds, the technology is here!
		if (surround)
			var/dx = turf_source.x - T.x // Hearing from the right/left
			S.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)

			var/dz = turf_source.y - T.y // Hearing from infront/behind
			S.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)

		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	src << S

/mob/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, surround = 1)
	if(!client || ear_deaf > 0)
		return
	..()

/mob/proc/stopLobbySound()
	src << sound(null, 0, 0, 1, 85)

/client/proc/playtitlemusic()
	if(!SSticker || !SSticker.login_music)	return
	if(prefs && (prefs.toggles & SOUND_LOBBY))
		src << sound(SSticker.login_music, 1, wait = 0, volume = 85, channel = 1) // MAD JAMS

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if ("explosion") soundin = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg')
			if ("sparks") soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
			if ("rustle") soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if ("bodyfall") soundin = pick('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg')
			if ("punch") soundin = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if ("clownstep") soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if ("swing_hit") soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if ("hiss") soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if ("pageturn") soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if ("gunshot") soundin = pick('sound/weapons/Gunshot.ogg', 'sound/weapons/Gunshot2.ogg','sound/weapons/Gunshot3.ogg','sound/weapons/Gunshot4.ogg')
			if ("ricochet") soundin = pick('sound/weapons/effects/ric1.ogg', 'sound/weapons/effects/ric2.ogg','sound/weapons/effects/ric3.ogg','sound/weapons/effects/ric4.ogg','sound/weapons/effects/ric5.ogg')
			if ("erikafootsteps") soundin = pick('sound/effects/footsteps/tile1.wav','sound/effects/footsteps/tile2.wav','sound/effects/footsteps/tile3.wav','sound/effects/footsteps/tile4.wav')
			if ("grassfootsteps") soundin = pick('sound/effects/footsteps/grass/grass1.wav','sound/effects/footsteps/grass/grass2.wav','sound/effects/footsteps/grass/grass3.wav','sound/effects/footsteps/grass/grass4.wav')
			if ("dirtfootsteps") soundin = pick('sound/effects/footsteps/dirt/dirt1.ogg','sound/effects/footsteps/dirt/dirt2.ogg','sound/effects/footsteps/dirt/dirt3.ogg','sound/effects/footsteps/dirt/dirt4.ogg','sound/effects/footsteps/dirt/dirt5.ogg','sound/effects/footsteps/dirt/dirt6.ogg')
			if ("waterfootsteps") soundin = pick('sound/effects/footsteps/water/slosh1.wav','sound/effects/footsteps/water/slosh2.wav','sound/effects/footsteps/water/slosh3.wav','sound/effects/footsteps/water/slosh4.wav')
			if ("sandfootsteps") soundin = pick('sound/effects/footsteps/sand/sand_step1.ogg','sound/effects/footsteps/sand/sand_step2.ogg','sound/effects/footsteps/sand/sand_step3.ogg','sound/effects/footsteps/sand/sand_step4.ogg','sound/effects/footsteps/sand/sand_step5.ogg','sound/effects/footsteps/sand/sand_step6.ogg','sound/effects/footsteps/sand/sand_step7.ogg','sound/effects/footsteps/sand/sand_step8.ogg')
			if ("woodfootsteps") soundin = pick('sound/effects/footsteps/wood/wood_step1.ogg','sound/effects/footsteps/wood/wood_step2.ogg','sound/effects/footsteps/wood/wood_step3.ogg','sound/effects/footsteps/wood/wood_step4.ogg','sound/effects/footsteps/wood/wood_step5.ogg','sound/effects/footsteps/wood/wood_step6.ogg')
			if ("carpetfootsteps") soundin = pick('sound/effects/footsteps/carpet/carpet_step1.ogg','sound/effects/footsteps/carpet/carpet_step2.ogg','sound/effects/footsteps/carpet/carpet_step3.ogg','sound/effects/footsteps/carpet/carpet_step4.ogg','sound/effects/footsteps/carpet/carpet_step5.ogg','sound/effects/footsteps/carpet/carpet_step6.ogg','sound/effects/footsteps/carpet/carpet_step7.ogg','sound/effects/footsteps/carpet/carpet_step8.ogg')
			if("propaganda")
				soundin = pick('sound/stalker/objects/sounded/propaganda/propaganda1.ogg','sound/stalker/objects/sounded/propaganda/propaganda2.ogg',
								'sound/stalker/objects/sounded/propaganda/propaganda3.ogg','sound/stalker/objects/sounded/propaganda/propaganda4.ogg',
								'sound/stalker/objects/sounded/propaganda/propaganda5.ogg','sound/stalker/objects/sounded/propaganda/propaganda6.ogg',
								'sound/stalker/objects/sounded/propaganda/propaganda7.ogg')
			if("spatial bubble")
				soundin = pick('sound/stalker/objects/sounded/spatial_bubble/sos1.ogg','sound/stalker/objects/sounded/spatial_bubble/sos2.ogg',
								'sound/stalker/objects/sounded/spatial_bubble/sos3.ogg')
			if("snoring")
				soundin = pick('sound/stalker/mobs/stalker/snoring/snoring_1.ogg','sound/stalker/mobs/stalker/snoring/snoring_2.ogg',
								'sound/stalker/mobs/stalker/snoring/snoring_3.ogg','sound/stalker/mobs/stalker/snoring/snoring_4.ogg',
								'sound/stalker/mobs/stalker/snoring/snoring_5.ogg','sound/stalker/mobs/stalker/snoring/snoring_6.ogg')
			if("fire_cracking")
				soundin = pick('sound/stalker/objects/sounded/campfire/crackle_1.ogg','sound/stalker/objects/sounded/campfire/crackle_2.ogg','sound/stalker/objects/sounded/campfire/crackle_3.ogg')
			if("gasp_sounds")
				soundin = pick('sound/stalker/mobs/stalker/gasp/gasp_1.ogg','sound/stalker/mobs/stalker/gasp/gasp_2.ogg','sound/stalker/mobs/stalker/gasp/gasp_3.ogg')
			if("sidor_enter")
				soundin = pick('sound/stalker/mobs/sidor/sidor_enter1.ogg','sound/stalker/mobs/sidor/sidor_enter2.ogg','sound/stalker/mobs/sidor/sidor_enter3.ogg','sound/stalker/mobs/sidor/sidor_enter4.ogg','sound/stalker/mobs/sidor/sidor_enter5.ogg','sound/stalker/mobs/sidor/sidor_enter6.ogg')
			if("sidor_exit")
				soundin = pick('sound/stalker/mobs/sidor/sidor_exit1.ogg','sound/stalker/mobs/sidor/sidor_exit2.ogg')
			if("sidor_bad")
				soundin = pick('sound/stalker/mobs/sidor/sidor_bad1.ogg','sound/stalker/mobs/sidor/sidor_bad2.ogg','sound/stalker/mobs/sidor/sidor_bad3.ogg','sound/stalker/mobs/sidor/sidor_bad4.ogg')
			if("sidor_good")
				soundin = pick('sound/stalker/mobs/sidor/sidor_good1.ogg','sound/stalker/mobs/sidor/sidor_good2.ogg','sound/stalker/mobs/sidor/sidor_good3.ogg')
			if("sidor_afk")
				soundin = pick('sound/stalker/mobs/sidor/sidor_afk1.ogg','sound/stalker/mobs/sidor/sidor_afk2.ogg','sound/stalker/mobs/sidor/sidor_afk3.ogg','sound/stalker/mobs/sidor/sidor_afk4.ogg','sound/stalker/mobs/sidor/sidor_afk5.ogg')
			if("stalker_death")
				soundin = pick('sound/stalker/mobs/stalker/death/death_1.ogg','sound/stalker/mobs/stalker/death/death_2.ogg','sound/stalker/mobs/stalker/death/death_3.ogg','sound/stalker/mobs/stalker/death/death_4.ogg','sound/stalker/mobs/stalker/death/death_5.ogg','sound/stalker/mobs/stalker/death/death_6.ogg','sound/stalker/mobs/stalker/death/death_7.ogg')
			if("bandit_death")
				soundin = pick('sound/stalker/mobs/bandit/death/death_1.ogg','sound/stalker/mobs/bandit/death/death_2.ogg','sound/stalker/mobs/bandit/death/death_3.ogg','sound/stalker/mobs/bandit/death/death_4.ogg','sound/stalker/mobs/bandit/death/death_5.ogg','sound/stalker/mobs/bandit/death/death_6.ogg','sound/stalker/mobs/bandit/death/death_7.ogg','sound/stalker/mobs/bandit/death/death_8.ogg','sound/stalker/mobs/bandit/death/death_9.ogg','sound/stalker/mobs/bandit/death/death_10.ogg','sound/stalker/mobs/bandit/death/death_11.ogg')
			if("dolg_death")
				soundin = pick('sound/stalker/mobs/dolg/death/death_1.ogg','sound/stalker/mobs/dolg/death/death_2.ogg','sound/stalker/mobs/dolg/death/death_3.ogg')
			if("army_death")
				soundin = pick('sound/stalker/mobs/army/death/death_1.ogg','sound/stalker/mobs/army/death/death_2.ogg','sound/stalker/mobs/army/death/death_3.ogg','sound/stalker/mobs/army/death/death_4.ogg','sound/stalker/mobs/army/death/death_5.ogg')
			if("ecolog_death")
				soundin = pick('sound/stalker/mobs/ecolog/death/death_1.ogg','sound/stalker/mobs/ecolog/death/death_2.ogg','sound/stalker/mobs/ecolog/death/death_3.ogg','sound/stalker/mobs/ecolog/death/death_4.ogg','sound/stalker/mobs/ecolog/death/death_5.ogg','sound/stalker/mobs/ecolog/death/death_6.ogg','sound/stalker/mobs/ecolog/death/death_7.ogg','sound/stalker/mobs/ecolog/death/death_8.ogg','sound/stalker/mobs/ecolog/death/death_9.ogg')
			if("merc_death")
				soundin = pick('sound/stalker/mobs/merc/death/death_1.ogg','sound/stalker/mobs/merc/death/death_2.ogg','sound/stalker/mobs/merc/death/death_3.ogg','sound/stalker/mobs/merc/death/death_4.ogg','sound/stalker/mobs/merc/death/death_5.ogg','sound/stalker/mobs/merc/death/death_6.ogg','sound/stalker/mobs/merc/death/death_7.ogg')
			if("stalker_hit")
				soundin = pick('sound/stalker/mobs/stalker/hit/hit_1.ogg','sound/stalker/mobs/stalker/hit/hit_2.ogg','sound/stalker/mobs/stalker/hit/hit_3.ogg','sound/stalker/mobs/stalker/hit/hit_4.ogg','sound/stalker/mobs/stalker/hit/hit_5.ogg','sound/stalker/mobs/stalker/hit/hit_6.ogg','sound/stalker/mobs/stalker/hit/hit_7.ogg','sound/stalker/mobs/stalker/hit/hit_8.ogg','sound/stalker/mobs/stalker/hit/hit_9.ogg','sound/stalker/mobs/stalker/hit/hit_10.ogg')
			if("bandit_hit")
				soundin = pick('sound/stalker/mobs/bandit/hit/hit_1.ogg','sound/stalker/mobs/bandit/hit/hit_2.ogg','sound/stalker/mobs/bandit/hit/hit_3.ogg','sound/stalker/mobs/bandit/hit/hit_4.ogg','sound/stalker/mobs/bandit/hit/hit_5.ogg','sound/stalker/mobs/bandit/hit/hit_6.ogg','sound/stalker/mobs/bandit/hit/hit_7.ogg','sound/stalker/mobs/bandit/hit/hit_8.ogg')
			if("dolg_hit")
				soundin = pick('sound/stalker/mobs/dolg/hit/hit_1.ogg','sound/stalker/mobs/dolg/hit/hit_2.ogg','sound/stalker/mobs/dolg/hit/hit_3.ogg','sound/stalker/mobs/dolg/hit/hit_4.ogg','sound/stalker/mobs/dolg/hit/hit_5.ogg','sound/stalker/mobs/dolg/hit/hit_6.ogg','sound/stalker/mobs/dolg/hit/hit_7.ogg','sound/stalker/mobs/dolg/hit/hit_8.ogg','sound/stalker/mobs/dolg/hit/hit_9.ogg','sound/stalker/mobs/dolg/hit/hit_10.ogg')
			if("army_hit")
				soundin = pick('sound/stalker/mobs/army/hit/hit_1.ogg','sound/stalker/mobs/army/hit/hit_2.ogg','sound/stalker/mobs/army/hit/hit_3.ogg','sound/stalker/mobs/army/hit/hit_4.ogg','sound/stalker/mobs/army/hit/hit_5.ogg')
			if("ecolog_hit")
				soundin = pick('sound/stalker/mobs/ecolog/hit/hit_1.ogg','sound/stalker/mobs/ecolog/hit/hit_2.ogg','sound/stalker/mobs/ecolog/hit/hit_3.ogg','sound/stalker/mobs/ecolog/hit/hit_4.ogg','sound/stalker/mobs/ecolog/hit/hit_5.ogg','sound/stalker/mobs/ecolog/hit/hit_6.ogg','sound/stalker/mobs/ecolog/hit/hit_7.ogg','sound/stalker/mobs/ecolog/hit/hit_8.ogg')
			if("merc_hit")
				soundin = pick('sound/stalker/mobs/merc/hit/hit_1.ogg','sound/stalker/mobs/merc/hit/hit_2.ogg','sound/stalker/mobs/merc/hit/hit_3.ogg','sound/stalker/mobs/merc/hit/hit_4.ogg','sound/stalker/mobs/merc/hit/hit_5.ogg','sound/stalker/mobs/merc/hit/hit_6.ogg','sound/stalker/mobs/merc/hit/hit_7.ogg','sound/stalker/mobs/merc/hit/hit_8.ogg')
			if("stalker_friendlyhit")
				soundin = pick('sound/stalker/mobs/stalker/friendly_fire/friendly_fire_1.ogg','sound/stalker/mobs/stalker/friendly_fire/friendly_fire_2.ogg','sound/stalker/mobs/stalker/friendly_fire/friendly_fire_3.ogg','sound/stalker/mobs/stalker/friendly_fire/friendly_fire_4.ogg','sound/stalker/mobs/stalker/friendly_fire/friendly_fire_5.ogg')
			if("bandit_friendlyhit")
				soundin = pick('sound/stalker/mobs/bandit/friendly_fire/friendly_fire_1.ogg','sound/stalker/mobs/bandit/friendly_fire/friendly_fire_2.ogg','sound/stalker/mobs/bandit/friendly_fire/friendly_fire_3.ogg','sound/stalker/mobs/bandit/friendly_fire/friendly_fire_4.ogg','sound/stalker/mobs/bandit/friendly_fire/friendly_fire_5.ogg')
			if("dolg_friendlyhit")
				soundin = pick('sound/stalker/mobs/dolg/friendly_fire/friendly_fire_1.ogg','sound/stalker/mobs/dolg/friendly_fire/friendly_fire_2.ogg','sound/stalker/mobs/dolg/friendly_fire/friendly_fire_3.ogg','sound/stalker/mobs/dolg/friendly_fire/friendly_fire_4.ogg','sound/stalker/mobs/dolg/friendly_fire/friendly_fire_5.ogg')
			if("army_friendlyhit")
				soundin = pick('sound/stalker/mobs/army/friendly_fire/friendly_fire_1.ogg','sound/stalker/mobs/army/friendly_fire/friendly_fire_2.ogg','sound/stalker/mobs/army/friendly_fire/friendly_fire_3.ogg','sound/stalker/mobs/army/friendly_fire/friendly_fire_4.ogg','sound/stalker/mobs/army/friendly_fire/friendly_fire_5.ogg')
			if("ecolog_friendlyhit")
				soundin = pick('sound/stalker/mobs/ecolog/friendly_fire/friendly_fire_1.ogg','sound/stalker/mobs/ecolog/friendly_fire/friendly_fire_2.ogg','sound/stalker/mobs/ecolog/friendly_fire/friendly_fire_3.ogg','sound/stalker/mobs/ecolog/friendly_fire/friendly_fire_4.ogg','sound/stalker/mobs/ecolog/friendly_fire/friendly_fire_5.ogg')
			if("merc_friendlyhit")
				soundin = pick('sound/stalker/mobs/merc/friendly_fire/friendly_fire_1.ogg','sound/stalker/mobs/merc/friendly_fire/friendly_fire_2.ogg','sound/stalker/mobs/merc/friendly_fire/friendly_fire_3.ogg','sound/stalker/mobs/merc/friendly_fire/friendly_fire_4.ogg','sound/stalker/mobs/merc/friendly_fire/friendly_fire_5.ogg')
			if("fartsound")
				soundin = pick('sound/stalker/mobs/fart_1.ogg', 'sound/stalker/mobs/fart_2.ogg', 'sound/stalker/mobs/fart_3.ogg')
			if("SOFT_HIT")
				soundin = pick('sound/stalker/mobs/hit/flesh1.wav','sound/stalker/mobs/hit/flesh2.wav','sound/stalker/mobs/hit/flesh3.wav','sound/stalker/mobs/hit/flesh4.wav','sound/stalker/mobs/hit/flesh5.wav')
			if("death")
				soundin = pick('sound/stalker/mobs/death/secretScream1.ogg', 'sound/stalker/mobs/death/secretScream2.ogg', 'sound/stalker/mobs/death/secretScream3.ogg')
			if("weapon_drop")
				soundin = pick('sound/stalker/mobs/army/dropweapon_1.ogg','sound/stalker/mobs/army/dropweapon_2.ogg','sound/stalker/mobs/army/dropweapon_3.ogg','sound/stalker/mobs/army/dropweapon_4.ogg','sound/stalker/mobs/army/dropweapon_5.ogg','sound/stalker/mobs/army/dropweapon_6.ogg','sound/stalker/mobs/army/dropweapon_7.ogg','sound/stalker/mobs/army/dropweapon_8.ogg','sound/stalker/mobs/army/dropweapon_9.ogg')


	return soundin
