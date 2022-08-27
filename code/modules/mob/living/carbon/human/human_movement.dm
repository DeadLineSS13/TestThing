/mob/living/carbon/human/movement_delay()

	. += dna.species.movement_delay(src)

	. += ..()

	if(crippled_leg)
		. *= 2
//	. += config.human_delay

/mob/living/carbon/human/Process_Spacemove(movement_dir = 0)

	if(..())
		return 1

	//Do we have a working jetpack
//	if(istype(back, /obj/item/weapon/tank/jetpack) && isturf(loc)) //Second check is so you can't use a jetpack in a mech
//		var/obj/item/weapon/tank/jetpack/J = back
//		if((movement_dir || J.stabilization_on) && J.allow_thrust(0.01, src))
//			return 1

	return 0


/mob/living/carbon/human/slip(s_amount, w_amount, obj/O, lube)
	if(isobj(shoes) && (shoes.flags&NOSLIP) && !(lube&GALOSHES_DONT_HELP))
		return 0
	.=..()

/mob/living/carbon/human/experience_pressure_difference()
	playsound(src, 'sound/effects/space_wind.ogg', 50, 1, channel = "regular", time = 10)
	if(shoes && shoes.flags&NOSLIP)
		return 0
	. = ..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return shoes && shoes.negates_gravity()

/mob/living/carbon/human/Move(NewLoc, direct)
	if(sticky_pit)
		return 0

	var/oldloc = loc

	if(crippled_leg)
		if(m_intent == "run")
			if(!resting)
				src << "<span class='warning'>You have fallen because of crippled leg!</span>"
				resting = 1
			update_canmove()
		else if(crippled_leg > 1)
			if(!resting)
				src << "<span class='warning'>You have fallen because of crippled leg!</span>"
				resting = 1
			update_canmove()
	. = ..()

//	for(var/datum/mutation/human/HM in dna.mutations)
//		HM.on_move(src, NewLoc)
	if(shoes)
		if(!lying && !buckled)
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
				var/obj/item/clothing/shoes/S = shoes

				S.step_action()


	if(loc != oldloc)
		if(m_intent == "run")
			reset_targeting()
			adjustEnduranceLoss(-6*(2**stamina_coef))
				//Bloody footprints
				/*
				var/turf/T = get_turf(src)
				if(S.bloody_shoes && S.bloody_shoes[S.blood_state])
					var/obj/effect/decal/cleanable/blood/footprints/oldFP = locate(/obj/effect/decal/cleanable/blood/footprints) in T
					if(oldFP && oÙldFP.blood_state == S.blood_state)
						return
					else
						//No oldFP or it's a different kind of blood
						S.bloody_shoes[S.blood_state] = max(0, S.bloody_shoes[S.blood_state]-BLOOD_LOSS_PER_STEP)
						var/obj/effect/decal/cleanable/blood/footprints/FP = new /obj/effect/decal/cleanable/blood/footprints(T)
						FP.blood_state = S.blood_state
						FP.entered_dirs |= dir
						FP.bloodiness = S.bloody_shoes[S.blood_state]
						FP.update_icon()
						update_inv_shoes()
				//End bloody footprints
				*/
/*
	if(israin && client)

////	RAIN OVERLAY CODE	////

		var/x_offset = 0
		var/y_offset = 0
		switch(direct)
			if(NORTH)
				y_offset = 8
			if(SOUTH)
				y_offset = -8
			if(EAST)
				x_offset = 8
			if(WEST)
				x_offset = -8
		for(var/i = -7 to 7)
			var/turf/stalker/TF = locate(x+(x_offset ? x_offset : i), y+(y_offset ? y_offset : i), z)
			var/image/I = image('icons/stalker/structure/decor.dmi', TF, "rain", layer = 10)
			if(TF && TF.rained)
				if(!client.rain_overlays.Find("[TF.x],[TF.y],[TF.z]"))
					client.rain_overlays["[TF.x],[TF.y],[TF.z]"] = I
					client.images -= client.rain_overlays["[TF.x],[TF.y],[TF.z]"]
					client.images |= client.rain_overlays["[TF.x],[TF.y],[TF.z]"]

			var/turf/stalker/TB = locate(x-(x_offset ? ((x_offset > 0) ? x_offset+1 : x_offset-1) : i), y-(y_offset ? ((y_offset > 0) ? y_offset+1 : y_offset-1) : i), z)		//Yeah, I know it's unreadable, but anyway
			if(TB && TB.rained)
				client.images -= client.rain_overlays["[TB.x],[TB.y],[TB.z]"]
				client.rain_overlays.Remove("[TB.x],[TB.y],[TB.z]")
*/
////	SOUND CODE	////

		var/turf/TT = loc
		if(TT && !TT.outdoor)
			var/turf/T
			for(var/i = 1, i <= 7, i++)
				for(T in range(i, src))
					if(T.rained)
						break
			if(T)
				rain.volume = 50
				rain_wind.volume = 100
				rain_thunder.volume = 100
				var/turf/Tf = get_turf(src)
				var/dx = T.x - Tf.x
				rain.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)
				rain_wind.x = rain.x
				rain_thunder.x = rain.x
				var/dz = T.y - Tf.y
				rain.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)
				rain_wind.z = rain.z
				rain_thunder.z = rain.z
				rain.status = SOUND_UPDATE
			else
				rain.volume = 0
				rain_wind.volume = 0
				rain_thunder.volume = 0
				rain.status = SOUND_UPDATE
//				rain_wind.status = SOUND_UPDATE
//				rain_thunder.status = SOUND_UPDATE
		else
			rain.volume = 50
			rain.x = 0
			rain.z = 0
			rain_wind.volume = 100
			rain_wind.x = 0
			rain_wind.z = 0
			rain_thunder.volume = 100
			rain_thunder.x = 0
			rain_thunder.z = 0
			rain.status = SOUND_UPDATE

	steps++
	SSstat.total_steps++
	if(steps >= 50)
		steps = 0
		give_exp(1, "walking", 25)