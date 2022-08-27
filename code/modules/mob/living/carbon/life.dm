/mob/living/carbon/Life()
	set invisibility = 0

	if(damageoverlaytemp)
		damageoverlaytemp = 0
		update_damage_hud()

	if(client)
		handle_regular_hud_updates()

	//Эмбиенты
	handle_sounds()

	if (notransform)
		return
	if(!loc)
		return

	if(..())
		. = 1
		for(var/obj/item/organ/internal/O in internal_organs)
			O.on_life()

/mob/living/carbon/handle_regular_hud_updates()
	..()
	update_damage_hud()


///////////////
// BREATHING //
///////////////

//Start of a breath chain, calls breathe()
/mob/living/carbon/handle_breathing()
	if(SSmobs.times_fired%4==2 || failed_last_breath)
		breathe() //Breathe per 4 ticks, unless suffocating
	else
		if(istype(loc, /obj/))
			var/obj/location_as_object = loc
			location_as_object.handle_internal_lifeform(src,0)

//Second link in a breath chain, calls check_breath()
/mob/living/carbon/proc/breathe()
	if(reagents.has_reagent("lexorin"))
		return
//	if(istype(loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
//		return
	if(hold_breath)
		return

	var/datum/gas_mixture/environment
	if(loc)
		environment = loc.return_air()

	var/datum/gas_mixture/breath

	if(health <= HEALTH_THRESHOLD_CRIT)
		losebreath++

	//Suffocate
	if(losebreath > 0)
		losebreath--
		if(prob(10))
			spawn emote("gasp")
		if(istype(loc, /obj/))
			var/obj/loc_as_obj = loc
			loc_as_obj.handle_internal_lifeform(src,0)
	else
		//Breathe from internal
		breath = get_breath_from_internal(BREATH_VOLUME)

		if(!breath)

			if(isobj(loc)) //Breathe from loc as object
				var/obj/loc_as_obj = loc
				breath = loc_as_obj.handle_internal_lifeform(src, BREATH_VOLUME)

			else if(isturf(loc)) //Breathe from loc as turf
				var/breath_moles = 0
				if(environment)
					breath_moles = environment.total_moles()*BREATH_PERCENTAGE

				breath = loc.remove_air(breath_moles)
		else //Breathe from loc as obj again
			if(istype(loc, /obj/))
				var/obj/loc_as_obj = loc
				loc_as_obj.handle_internal_lifeform(src,0)

	check_breath(breath)

	if(breath)
		loc.assume_air(breath)

/mob/living/carbon/proc/has_smoke_protection()
	return 0


//Third link in a breath chain, calls handle_breath_temperature()
/mob/living/carbon/proc/check_breath(datum/gas_mixture/breath)
	return 1
/*
	if((status_flags & GODMODE))
		return

	//CRIT
	if(!breath || (breath.total_moles() == 0))
		if(reagents.has_reagent("epinephrine"))
			return
		adjustOxyLoss(1)
		failed_last_breath = 1
//		throw_alert("oxy", /obj/screen/alert/oxy)

		return 0

	var/safe_oxy_min = 16
	var/safe_co2_max = 10
	var/safe_tox_max = 0.05
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/oxygen_used = 0
	var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	var/O2_partialpressure = (breath.oxygen/breath.total_moles())*breath_pressure
	var/Toxins_partialpressure = (breath.toxins/breath.total_moles())*breath_pressure
	var/CO2_partialpressure = (breath.carbon_dioxide/breath.total_moles())*breath_pressure


	//OXYGEN
	if(O2_partialpressure < safe_oxy_min) //Not enough oxygen
		if(prob(20))
			spawn(0)
				emote("gasp")
		if(O2_partialpressure > 0)
			var/ratio = safe_oxy_min/O2_partialpressure
			adjustOxyLoss(min(5*ratio, 3))
			failed_last_breath = 1
			oxygen_used = breath.oxygen*ratio/6
		else
			adjustOxyLoss(3)
			failed_last_breath = 1
//		throw_alert("oxy", /obj/screen/alert/oxy)

	else //Enough oxygen
		failed_last_breath = 0
		adjustOxyLoss(-5)
		oxygen_used = breath.oxygen/6
		clear_alert("oxy")

	breath.oxygen -= oxygen_used
	breath.carbon_dioxide += oxygen_used

	//CARBON DIOXIDE
	if(CO2_partialpressure > safe_co2_max)
		if(!co2overloadtime)
			co2overloadtime = world.time
		else if(world.time - co2overloadtime > 120)
			Paralyse(3)
			adjustOxyLoss(3)
			if(world.time - co2overloadtime > 300)
				adjustOxyLoss(8)
		if(prob(20))
			spawn(0) emote("cough")

	else
		co2overloadtime = 0

	//TOXINS/PLASMA
	if(Toxins_partialpressure > safe_tox_max)
		var/ratio = (breath.toxins/safe_tox_max) * 10
		if(reagents)
			reagents.add_reagent("plasma", Clamp(ratio, MIN_PLASMA_DAMAGE, MAX_PLASMA_DAMAGE))
//		throw_alert("tox_in_air", /obj/screen/alert/tox_in_air)
//	else
//		clear_alert("tox_in_air")

	//TRACE GASES
	if(breath.trace_gases.len)
		for(var/datum/gas/sleeping_agent/SA in breath.trace_gases)
			var/SA_partialpressure = (SA.moles/breath.total_moles())*breath_pressure
			if(SA_partialpressure > SA_para_min)
				Paralyse(3)
				if(SA_partialpressure > SA_sleep_min)
					sleeping = max(sleeping+2, 10)
			else if(SA_partialpressure > 0.01)
				if(prob(20))
					spawn(0) emote(pick("giggle","laugh"))

	//BREATH TEMPERATURE
	handle_breath_temperature(breath)

	return 1
*/

//Fourth and final link in a breath chain
/mob/living/carbon/proc/handle_breath_temperature(datum/gas_mixture/breath)
	return

/mob/living/carbon/proc/get_breath_from_internal(volume_needed)
	if(internal)
		if (!contents.Find(internal))
			internal = null
		if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
			internal = null
		if(internal)
			if (internals)
				internals.icon_state = "internal1"
			return internal.remove_air_volume(volume_needed)
		else
			if (internals)
				internals.icon_state = "internal0"
	return


/mob/living/carbon/handle_radiation()
	return
/*
	if(dna && dna.temporary_mutations.len)
		var/datum/mutation/human/HM
		for(var/mut in dna.temporary_mutations)
			if(dna.temporary_mutations[mut] < world.time)
				if(mut == UI_CHANGED)
					if(dna.previous["UI"])
						dna.uni_identity = merge_text(dna.uni_identity,dna.previous["UI"])
						updateappearance(mutations_overlay_update=1)
						dna.previous.Remove("UI")
					dna.temporary_mutations.Remove(mut)
					continue
				if(mut == UE_CHANGED)
					if(dna.previous["name"])
						real_name = dna.previous["name"]
						name = real_name
						dna.previous.Remove("name")
					if(dna.previous["UE"])
						dna.unique_enzymes = dna.previous["UE"]
						dna.previous.Remove("UE")
					if(dna.previous["blood_type"])
						dna.blood_type = dna.previous["blood_type"]
						dna.previous.Remove("blood_type")
					dna.temporary_mutations.Remove(mut)
					continue
				HM = mutations_list[mut]
				HM.force_lose(src)
				dna.temporary_mutations.Remove(mut)

	if(radiation)
		radiation -= 0.5
		switch(radiation)
			if(100 to INFINITY)
				adjustFireLoss(radiation*0.002)
				updatehealth()

		radiation = Clamp(radiation, 0, 750)
*/

/mob/living/carbon/handle_chemicals_in_body()
	if(reagents)
		reagents.metabolize(src)


/mob/living/carbon/handle_stomach()
	for(var/mob/living/M in stomach_contents)
		if(M.loc != src)
			stomach_contents.Remove(M)
			continue
		if(istype(M, /mob/living/carbon) && stat != 2)
			if(M.stat == 2)
				M.death(1)
				stomach_contents.Remove(M)
				qdel(M)
				continue
			if(SSmobs.times_fired%3==1)
				if(!(M.status_flags & GODMODE))
					M.adjustBruteLoss(5)
				nutrition += 10

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/carbon/handle_regular_status_updates()

	if(..()) //alive

		if(health <= 0)
			death()
			return

		if(getOxyLoss() > 50)
			Paralyse(3)
			stat = UNCONSCIOUS

		if(sleeping)
			stat = UNCONSCIOUS

		return 1

/mob/living/carbon/proc/CheckStamina()
	if(staminaloss)
		var/total_health = staminaloss
		if(total_health >= 100 && !stat)
			src << "<span class='notice'>Вы слишком устали...</span>"
//			Weaken(5)
			if(!resting)
				resting = 1
			setStaminaLoss(staminaloss - 2)
			return
		setStaminaLoss(max((staminaloss - 2), 0))

//this updates all special effects: stunned, sleeping, weakened, druggy, stuttering, etc..
/mob/living/carbon/handle_status_effects()
	..()

	CheckStamina()

	if(sleeping)
//		throw_alert("asleep", /obj/screen/alert/asleep)
		handle_dreams()
/*
		if(buckled && (buckled.type == /obj/structure/bed/stalker/matras || buckled.type == /obj/structure/bed/stalker/metal/matras))
			adjustStaminaLoss(-10)
			adjustBruteLoss(-0.5)
			adjustFireLoss(-0.5)
			adjustToxLoss(-0.5)
			adjustPsyLoss(-2)
*/
		sleeping = max(sleeping-1, 0)
		if(prob(10) && health)
			emote("snore")
//	else
//		clear_alert("asleep")


	var/restingpwr = 1 + 4 * resting

	//Dizziness
	if(dizziness)
		var/client/C = client
		var/pixel_x_diff = 0
		var/pixel_y_diff = 0
		var/temp
		var/saved_dizz = dizziness
		if(C)
			var/oldsrc = src
			var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70 // This shit is annoying at high strength
			src = null
			spawn(0)
				if(C)
					temp = amplitude * sin(0.008 * saved_dizz * world.time)
					pixel_x_diff += temp
					C.pixel_x += temp
					temp = amplitude * cos(0.008 * saved_dizz * world.time)
					pixel_y_diff += temp
					C.pixel_y += temp
					sleep(3)
					if(C)
						temp = amplitude * sin(0.008 * saved_dizz * world.time)
						pixel_x_diff += temp
						C.pixel_x += temp
						temp = amplitude * cos(0.008 * saved_dizz * world.time)
						pixel_y_diff += temp
						C.pixel_y += temp
					sleep(3)
					if(C)
						C.pixel_x -= pixel_x_diff
						C.pixel_y -= pixel_y_diff
			src = oldsrc
		dizziness = max(dizziness - restingpwr, 0)

	if(drowsyness)
		drowsyness = max(drowsyness - restingpwr, 0)
		eye_blurry = max(2, eye_blurry)
		if(prob(5))
			sleeping += 1
			Paralyse(5)

	if(confused)
		confused = max(0, confused - 1)

	if(boosted)
		boosted = max(boosted, 0)

	if(morphied)
		morphied = max(morphied, 0)

	//Jitteryness
	if(jitteriness)
		do_jitter_animation(jitteriness)
		jitteriness = max(jitteriness - restingpwr, 0)

	if(stuttering)
		stuttering = max(stuttering-1, 0)

//	if(getBruteLoss() + getFireLoss() >= 50)
//		stuttering += 1

	if(slurring)
		slurring = max(slurring-1,0)

	if(silent)
		silent = max(silent-1, 0)

	if(druggy)
		druggy = max(druggy-1, 0)

	if(hallucination)
		spawn handle_hallucinations()

		if(hallucination<=2)
			hallucination = 0
		else
			hallucination -= 2

/mob/living/carbon/proc/pulse_image(image, maxalpha = 200, animtime = 10)
	pulseimage.icon_state = image
	pulseimage.alpha = 0
	var/halftime = animtime / 2
	animate(pulseimage, alpha = maxalpha, time = halftime)
	spawn(halftime)
		animate(pulseimage, alpha = 0, halftime)


//this handles hud updates. Calls update_vision() and handle_hud_icons()
/mob/living/carbon/update_damage_hud()
	if(!client)
		return

/*	if(stat == UNCONSCIOUS && health <= HEALTH_THRESHOLD_CRIT)
		var/severity = 0
		switch(health)
			if(-20 to -10) severity = 1
			if(-30 to -20) severity = 2
			if(-40 to -30) severity = 3
			if(-50 to -40) severity = 4
			if(-60 to -50) severity = 5
			if(-70 to -60) severity = 6
			if(-80 to -70) severity = 7
			if(-90 to -80) severity = 8
			if(-95 to -90) severity = 9
			if(-INFINITY to -95) severity = 10
		overlay_fullscreen("crit", /obj/screen/fullscreen/crit, severity)
	else
		clear_fullscreen("crit")*/
	if(oxyloss)
		var/severity = 0
		switch(oxyloss)
			if(10 to 20) severity = 1
			if(20 to 25) severity = 2
			if(25 to 30) severity = 3
			if(30 to 35) severity = 4
			if(35 to 40) severity = 5
			if(40 to 45) severity = 6
			if(45 to INFINITY) severity = 7
		overlay_fullscreen("oxy", /obj/screen/fullscreen/oxy, severity)
	else
		clear_fullscreen("oxy")

	//Fire and Brute damage overlay (BSSR)
	var/hurtdamage = getBruteLoss() + getFireLoss()
	if(hurtdamage)
		if(!morphied)
			var/severity = 0
			switch(hurtdamage)
				if(1 to 5) severity = 1
				if(5 to 10) severity = 2
				if(10 to 15) severity = 3
				if(15 to 20) severity = 4
				if(20 to 30) severity = 5
				if(30 to INFINITY) severity = 6
			overlay_fullscreen("brute", /obj/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")
	else
		clear_fullscreen("brute")

//	if(istype(src, /mob/living/carbon/human))
//		var/mob/living/carbon/human/H = src
//		var/whitenoisealpha = 0
//		if(stat != DEAD)
//			whitenoisealpha = 100 - max(health * 2, 100) + H.toxloss * 3
//		overlay_fullscreen_alpha("whitenoise", /obj/screen/fullscreen/whitenoise, min(whitenoisealpha, 100))

	return 1

/mob/living/carbon/update_sight()
	if(stat == DEAD)
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else
		if(!(SEE_TURFS & permanent_sight_flags))
			sight &= ~SEE_TURFS
		if(!(SEE_MOBS & permanent_sight_flags))
			sight &= ~SEE_MOBS
		if(!(SEE_OBJS & permanent_sight_flags))
			sight &= ~SEE_OBJS
		if(remote_view)
			sight |= SEE_TURFS
			sight |= SEE_MOBS
			sight |= SEE_OBJS
		see_in_dark = (sight == SEE_TURFS|SEE_MOBS|SEE_OBJS) ? 8 : 2  //Xray flag combo
		see_invisible = SEE_INVISIBLE_LIVING
		if(see_override)
			see_invisible = see_override
/*
/mob/living/carbon
	var/old_shown_health_amount = 100
	var/old_hpos = HEALTH_BAR_Y_SIZE
	var/old_shown_stamina_amount = 2000
	var/old_spos = HEALTH_BAR_Y_SIZE
*/
/mob/living/carbon/handle_hud_icons_health(shown_health_amount)
	if(!hud_used)
		return
/*	var/coef = maxHealth / HEALTH_BAR_Y_SIZE
	var/num_pos = round(shown_health_amount/coef)
	if(num_pos <= 0)
		num_pos = 1
	if(shown_health_amount <= 100)
		if(shown_health_amount < old_shown_health_amount)
			for(old_hpos, num_pos <= old_hpos, old_hpos--)
				var/obj/screen/O = hud_used.healths[old_hpos]
				animate(O, alpha = 0, time = 10)
			old_hpos = num_pos
		else if(shown_health_amount > old_shown_health_amount)
			for(old_hpos, old_hpos <= num_pos, old_hpos++)
				var/obj/screen/O = hud_used.healths[old_hpos]
				animate(O, alpha = 255, time = 10)
			old_hpos = num_pos
		old_shown_health_amount = shown_health_amount						//Не верю, что оно заработало. Угробил на это часа 3-4 с кучей дебага, спасибо бьенду и моей криворукости. Vallat
																			//Update(спустя еще 4 часа занятием другой хуйней). Не верьте бьенду, он говорит, что все работает. однако это не так.
																			//Спасибо за еще один час потраченной жизни на дебаг и окончательные фиксы
*/
//А теперь мы отказываемся от полосок и делаем жепу снизу, заебись. Люблю разработку

	if(hud_used.healthdoll)
		if(stat != DEAD)
			if(!shown_health_amount)
				shown_health_amount = health
			if(morphied)
				hud_used.healthdoll.icon_state = "hdoll_morphite"
			else if(shown_health_amount >= maxHealth)
				hud_used.healthdoll.icon_state = "hdoll"
			else if(shown_health_amount > maxHealth-2*str)
				hud_used.healthdoll.icon_state = "hdoll"
			else if(shown_health_amount > 0)
				hud_used.healthdoll.icon_state = "hdoll_softdeath"
			else
				hud_used.healthdoll.icon_state = "hdoll_harddeath"
		else
			hud_used.healthdoll.icon_state = "hdoll_harddeath"


//used in human and monkey handle_environment()
/mob/living/carbon/proc/natural_bodytemperature_stabilization()
	var/body_temperature_difference = 310.15 - bodytemperature
	switch(bodytemperature)
		if(-INFINITY to 260.15) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
			if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
				nutrition -= 2
			bodytemperature += max((body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		if(260.15 to 310.15)
			bodytemperature += max(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, min(body_temperature_difference, BODYTEMP_AUTORECOVERY_MINIMUM/4))
		if(310.15 to 360.15)
			bodytemperature += min(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, max(body_temperature_difference, -BODYTEMP_AUTORECOVERY_MINIMUM/4))
		if(360.15 to INFINITY) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
			//We totally need a sweat system cause it totally makes sense...~
			bodytemperature += min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
/*
/mob/living/carbon/update_action_buttons()
	if(!hud_used) return
	if(!client) return

	if(hud_used.hud_shown != 1)	//Hud toggled to minimal
		return

	client.screen -= hud_used.hide_actions_toggle
	for(var/datum/action/A in actions)
		if(A.button)
			client.screen -= A.button

	if(hud_used.action_buttons_hidden)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.UpdateIcon()

		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,1)

		client.screen += hud_used.hide_actions_toggle
		return

	var/button_number = 0
	for(var/datum/action/A in actions)
		button_number++
		if(A.button == null)
			var/obj/screen/action_button/N = new(hud_used)
			N.owner = A
			A.button = N

		var/obj/screen/action_button/B = A.button

		B.UpdateIcon()

		B.name = A.UpdateName()

		client.screen += B

		if(!B.moved)
			B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			//hud_used.SetButtonCoords(B,button_number)

	if(button_number > 0)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.InitialiseIcon(src)
		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,button_number+1)
		client.screen += hud_used.hide_actions_toggle


/mob/living/carbon/handle_actions()
	..()
	for(var/obj/item/I in internal_organs)
		give_action_button(I, 1)
*/