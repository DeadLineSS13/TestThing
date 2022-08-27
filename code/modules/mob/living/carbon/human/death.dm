/mob/living/carbon/human/gib_animation(animate)
	..(animate, "gibbed-h")

/mob/living/carbon/human/dust_animation(animate)
	..(animate, "dust-h")

/mob/living/carbon/human/dust(animation = 1)
	..()

/mob/living/carbon/human/spawn_gibs()
	hgibs(loc, viruses, dna)

/mob/living/carbon/human/spawn_dust()
	new /obj/effect/decal/remains/human(loc)

/client/proc/screen_fade()
	if(mob)
		mob.clear_fullscreen("brute", 50)
		src << sound(get_sfx("death"), 0, 0, SSchannels.get_channel(60), 100)
		animate(src, color = "#000000", time = 50)
		mob.add_client_colour(/datum/client_colour/full_black)
		spawn(50)
			if(!mob)
				if(ismob(eye))
					mob = eye
			src << sound('sound/stalker/mobs/death/Ur_dead.ogg', 0, 0, SSchannels.get_channel(160), 100)
			var/obj/screen/text = new()
			text.screen_loc = "4:-14, 7"
			text.maptext_height = 320
			text.maptext_width = 320
			text.maptext = "<span style='font-family: Wingdings; font-size: 24px; color: red;'><b>You CAN'T change the reality and the Zone KICK you out!</b></span>"
			text.alpha = 0
			screen.Add(text)
			animate(text, alpha = 255, 100)
			spawn(250)
				mob.remove_client_colour(/datum/client_colour/full_black)
				screen.Remove(text)
				if(!istype(mob, /mob/dead))
					if(ishuman(mob))
						var/mob/living/carbon/human/H = mob
						if(!H.softdead)
							H.send_to_kyrilka()
							return
					spawn(1510)
						mob.send_to_kyrilka()
				else
					mob.send_to_kyrilka()

/mob/living/carbon/human/death(gibbed, softdeath)
	..(gibbed)

	if(s_active)
		s_active.close(src)

	if(client)
		client.screen_fade()
	if(softdeath && stat != DEAD)
		softdead = 1
		spawn(1800)
			softdead = 0
			if(job)
				var/datum/job/J = SSjob.GetJob(job)
				//if(GetJob.total_positions != -1)
				J.current_positions--
				if(J.faction_s == "RU")
					RU_count--
				if(J.faction_s == "UA")
					UA_count--
				job = null

	if(stat == DEAD)
		return

	dizziness = 0
	jitteriness = 0
	heart_attack = 0
	handle_hud_icons_health(0)
	update_action_buttons_icon()
	stat = DEAD
	if(hud_used)
		hud_used.healthdoll.icon_state = "hdoll_harddeath"

	if(((SSblowout.lasttime + SSblowout.cooldown <= world.time + 6000) || isblowout) && temp_experience == MAX_EXPERIENCE)
		give_achievement("Stay calm, drink tea")

//	if(istype(loc, /obj/mecha))
//		var/obj/mecha/M = loc
//		if(M.occupant == src)
//			M.go_out()

	if(!gibbed)
		emote("deathgasp") //let the world KNOW WE ARE DEAD

		update_canmove()
		if(client)
			blind.layer = 0
			blind.alpha = 0
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		layer -= 0.3
		drop_all_held_items()

	if(zombiefied)
		LoseTarget()

	if(!softdead)
		if(job)
			var/datum/job/J = SSjob.GetJob(job)
			//if(GetJob.total_positions != -1)
			J.current_positions--
			if(J.faction_s == "RU")
				RU_count--
			if(J.faction_s == "UA")
				UA_count--
			job = null

	if(current_quest)
		quest_list_available += current_quest
		current_quest = null

	dna.species.spec_death(gibbed,src)

//Загробная жизнь
//	var/mob/living/carbon/human/dead_character = new(loc)
//	client.prefs.copy_to(dead_character)
//	dead_character.dna.update_dna_identity()
//	if(mind)
//		mind.active = 0					//we wish to transfer the key manually
//		mind.transfer_to(dead_character)					//won't transfer key since the mind is not active

	//dead_character.name = real_name

//	dead_character.key = last_ckey
//	dead_character.loc = hell.loc
//	dead_character.equipOutfit(/datum/outfit/phantom)

//	if (GetKarma(dead_character.key) <= 800)
	//	if(TR_HASHNAME)
//		dead_character.real_name = "bad phantom ([dead_character.name])"
//		dead_character.name = dead_character.real_name			//[copytext(md5(real_name), 2, 6)
//
//	else //if (GetKarma(dead_character.key) <= 1100)
//		dead_character.real_name = "phantom ([dead_character.name])"
//		dead_character.name = dead_character.real_name

//	var/mob/DEADONE = dead_character

	//var/mob/dead/observer/dead_character = new(loc)
	//dead_character.ckey = client.ckey
	//dead_character.real_name = "phantom ([dead_character.name])"
	//dead_character.name = dead_character.real_name
	//dead_character.can_spawn = 0

//	spawn(60)
//		dead_character.can_spawn = 1
//	return
//	if (onelive == 0)
//		qdel(DEADONE)
//	if (onelive != 0)
//		onelive = 0
//		spawn(9000)
//			var/mob/new_player/NP = new()
//			NP.ckey = dead_character.ckey
//			onelive = 1
//

	timeofdeath = world.time
	tod = worldtime2text()		//weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)
	if(SSticker && SSticker.mode)
//		world.log << "k"
		//sql_report_death(src)
		SSticker.mode.check_win()		//Calls the rounds wincheck, mainly for wizard, malf, and changeling now
		if(SSticker.mode.name == "Battle Royale" && GLOB.living_mob_list.len > 0)
			if(client)
				world << "<span class='danger'>[client] has died! Only [GLOB.living_mob_list.len] people left!</span>"
			else
				world << "<span class='danger'>Someone who has left died! Only [GLOB.living_mob_list.len] people left!</span>"

	return

/mob/living/carbon/human/proc/makeSkeleton()
	status_flags |= DISFIGURED
	set_species(/datum/species/skeleton)
	return 1

/mob/living/carbon/proc/ChangeToHusk()
	if(disabilities & HUSK)	return
	disabilities |= HUSK
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	return 1

/mob/living/carbon/human/ChangeToHusk()
	. = ..()
	if(.)
		update_hair()
		update_body()

/mob/living/carbon/proc/Drain()
	ChangeToHusk()
	disabilities |= NOCLONE
	return 1
