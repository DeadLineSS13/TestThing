/mob/living/Life()
	set invisibility = 0


//	if(digitalinvis)
//		handle_diginvis() //AI becomes unable to see mob

	if (notransform)
		return
	if(!loc)
		return
//	var/datum/gas_mixture/environment = loc.return_air()

	if(stat != DEAD)

		//Breathing, if applicable
		//handle_breathing()

		//radiation
		handle_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Blud
		handle_blood()

		//Random events (vomiting etc)
		handle_random_events()

		if(client)
			handle_regular_hud_updates()

		if(last_passive_heal + 3000 < world.time)
			last_passive_heal = world.time
			heal_overall_damage(1)

		. = 1

	//Handle temperature/pressure differences between body and environment
//	if(environment)
//		handle_environment(environment)

	handle_fire()

	handle_wet()

	//stuff in the stomach
	handle_stomach()

//	update_gravity(mob_has_gravity())

	update_pulling()

//	for(var/obj/item/weapon/grab/G in src)
//		G.process()

	if(handle_regular_status_updates()) // Status & health update, are we dead or alive etc.
//		handle_disabilities() // eye, ear, brain damages
		handle_status_effects() //all special effects, stunned, weakened, jitteryness, hallucination, sleeping, etc

	update_canmove()


/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	return

/mob/living/proc/handle_diginvis()
	if(!digitaldisguise)
		src.digitaldisguise = image(loc = src)
	src.digitaldisguise.override = 1

/mob/living/proc/handle_blood()
	return

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(datum/gas_mixture/environment)
	return

/mob/living/proc/handle_stomach()
	return

/mob/living/proc/handle_wet()
	if(israin)
		wet = min(300, wet + 1)
	else
		wet = max(0, wet - 1)

/mob/living/proc/update_pulling()
	if(pulling)
		if(incapacitated())
			stop_pulling()


/mob/living/proc/handle_statsicons_update()
	if(!hud_used)
		return

	switch(str)
		if(0 to 5)
			hud_used.str.icon_state = "stat_xxlow"
		if(6 to 7)
			hud_used.str.icon_state = "stat_xlow"
		if(8 to 9)
			hud_used.str.icon_state = "stat_low"
		if(10)
			hud_used.str.icon_state = "stat_medium"
		if(11 to 12)
			hud_used.str.icon_state = "stat_good"
		if(13 to 14)
			hud_used.str.icon_state = "stat_xgood"
		if(15 to INFINITY)
			hud_used.str.icon_state = "stat_xxgood"

	switch(agi)
		if(0 to 5)
			hud_used.agi.icon_state = "stat_xxlow"
		if(6 to 7)
			hud_used.agi.icon_state = "stat_xlow"
		if(8 to 9)
			hud_used.agi.icon_state = "stat_low"
		if(10)
			hud_used.agi.icon_state = "stat_medium"
		if(11 to 12)
			hud_used.agi.icon_state = "stat_good"
		if(13 to 14)
			hud_used.agi.icon_state = "stat_xgood"
		if(15 to INFINITY)
			hud_used.agi.icon_state = "stat_xxgood"

	switch(hlt)
		if(0 to 5)
			hud_used.hlt.icon_state = "stat_xxlow"
		if(6 to 7)
			hud_used.hlt.icon_state = "stat_xlow"
		if(8 to 9)
			hud_used.hlt.icon_state = "stat_low"
		if(10)
			hud_used.hlt.icon_state = "stat_medium"
		if(11 to 12)
			hud_used.hlt.icon_state = "stat_good"
		if(13 to 14)
			hud_used.hlt.icon_state = "stat_xgood"
		if(15 to INFINITY)
			hud_used.hlt.icon_state = "stat_xxgood"

	switch(int)
		if(0 to 5)
			hud_used.int.icon_state = "stat_xxlow"
		if(6 to 7)
			hud_used.int.icon_state = "stat_xlow"
		if(8 to 9)
			hud_used.int.icon_state = "stat_low"
		if(10)
			hud_used.int.icon_state = "stat_medium"
		if(11 to 12)
			hud_used.int.icon_state = "stat_good"
		if(13 to 14)
			hud_used.int.icon_state = "stat_xgood"
		if(15 to INFINITY)
			hud_used.int.icon_state = "stat_xxgood"

	if(hud_used.weight)
		switch(stamina_coef)
			if(-1)
				hud_used.weight.icon_state = "weight"
			if(0)
				hud_used.weight.icon_state = "weight_light"
			if(1)
				hud_used.weight.icon_state = "weight_medium"
			if(2)
				hud_used.weight.icon_state = "weight_heavy"
			if(3)
				hud_used.weight.icon_state = "weight_heavy"
			else
				hud_used.weight.icon_state = "weight_vheavy"

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_status_updates()

	updatehealth()

	if(stat != DEAD)

		if(paralysis)
			stat = UNCONSCIOUS

		else if (status_flags & FAKEDEATH)
			stat = UNCONSCIOUS

		else
			stat = CONSCIOUS

		return 1

//this updates all special effects: stunned, sleeping, weakened, druggy, stuttering, etc..
/mob/living/proc/handle_status_effects()
	if(paralysis)
		paralysis = max(paralysis-1,0)
		if(boosted)
			paralysis = 0
	if(stunned)
		stunned = max(stunned-1,0)
		if(boosted)
			stunned = 0
		if(!stunned)
			update_icons()

	if(weakened)
		weakened = max(weakened-1,0)
		if(boosted)
			weakened = 0
		if(!weakened)
			update_icons()
/*
/mob/living/proc/handle_disabilities()
	//Eyes
	if(disabilities & BLIND || stat)	//blindness from disability or unconsciousness doesn't get better on its own
		eye_blind = max(eye_blind, 1)
	else if(eye_blind)			//blindness, heals slowly over time
		eye_blind = max(eye_blind-1,0)
	else if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)

	//Ears
	if(disabilities & DEAF)		//disabled-deaf, doesn't get better on its own
		setEarDamage(-1, max(ear_deaf, 1))
	else
		// deafness heals slowly over time, unless ear_damage is over 100
		if(ear_damage < 100)
			adjustEarDamage(-0.05,-1)

/mob/living/proc/handle_actions()
	//Pretty bad, i'd use picked/dropped instead but the parent calls in these are nonexistent
	for(var/datum/action/A in actions)
		if(A.CheckRemoval(src))
			A.Remove(src)
	for(var/obj/item/I in src)
		give_action_button(I, 1)
	return

/mob/living/proc/give_action_button(var/obj/item/I, recursive = 0)
	if(I.action_button_name)
		if(!I.action)
			if(istype(I, /obj/item/organ/internal))
				I.action = new/datum/action/item_action/organ_action
			else if(I.action_button_is_hands_free)
				I.action = new/datum/action/item_action/hands_free
			else
				I.action = new/datum/action/item_action
			I.action.name = I.action_button_name
			I.action.target = I
		I.action.Grant(src)

	if(recursive)
		for(var/obj/item/T in I)
			give_action_button(I, recursive - 1)
*/

//this handles hud updates. Calls update_vision() and handle_hud_icons()
/mob/living/proc/handle_regular_hud_updates()
	if(!client)	return 0

	if(stat == DEAD)
		return 0

	handle_vision()
	handle_hud_icons()
	update_action_buttons()

	return 1

/mob/living/proc/handle_vision()

//	client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask)
//	clear_fullscreens()

	update_sight()

	if(stat != DEAD)
		if(blind)
			if(eye_blind)
//				throw_alert("blind", /obj/screen/alert/blind)
				overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
			else
//				clear_alert("blind")
				clear_fullscreen("blind")

				if (disabilities & NEARSIGHT)
					overlay_fullscreen("impared", /obj/screen/fullscreen/impaired)

				if (eye_blurry)
					overlay_fullscreen("blurry", /obj/screen/fullscreen/blurry)
				else
					clear_fullscreen("blurry")

				if (druggy)
					overlay_fullscreen("high", /obj/screen/fullscreen/high)
//					throw_alert("high", /obj/screen/alert/high)
				else
//					clear_alert("high")
					clear_fullscreen("high")

//				if(eye_stat > 20)
//					if(eye_stat > 30)
//						client.screen += global_hud.darkMask
//					else
//						overlay_fullscreen("impared", /obj/screen/fullscreen/impaired)

		if(machine)
			if (!( machine.check_eye(src) ))
				reset_view(null)
//		else
//			if(!remote_view && !client.adminobs)
//				reset_view(null)
	else
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)

/mob/living/proc/update_sight()
	return

/mob/living/proc/handle_hud_icons()
	handle_hud_icons_health(health)
	handle_hud_icons_stamina(enduranceloss)
	return

/mob/living/proc/handle_hud_icons_health()
	return

/mob/living/proc/handle_hud_icons_stamina()
	return

/mob/living/proc/update_damage_hud()
	return
/*
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
*/