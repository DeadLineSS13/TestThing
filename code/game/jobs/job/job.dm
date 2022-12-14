/datum/job
	//The name of the job
	var/title = "NOPE"

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Determines who can demote this position
	var/department_head = list()

	//Bitflags for the job
	var/flag = 0
	var/department_flag = 0

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0
	var/locked = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Sellection screen color
	var/selection_color = "#ffffff"

	var/whitelist_only = 1

	var/activated = 1

	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/outfit = null

	var/limit_per_player = 0

	var/faction_s = "Loners"

	var/real_rank = "Private"

//Only override this proc
/datum/job/proc/equip_items(mob/living/carbon/human/H)

//But don't override this
/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return 0

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	if(outfit)
		H.equipOutfit(outfit, visualsOnly)

	H.dna.species.after_equip_job(src, H, visualsOnly)

/datum/job/proc/apply_fingerprints(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.back)
		H.back.add_fingerprint(H,1)	//The 1 sets a flag to ignore gloves
		for(var/obj/item/I in H.back.contents)
			I.add_fingerprint(H,1)
	if(H.wear_id)
		H.wear_id.add_fingerprint(H,1)
	if(H.w_uniform)
		H.w_uniform.add_fingerprint(H,1)
	if(H.wear_suit)
		H.wear_suit.add_fingerprint(H,1)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H,1)
	if(H.head)
		H.head.add_fingerprint(H,1)
	if(H.shoes)
		H.shoes.add_fingerprint(H,1)
	if(H.gloves)
		H.gloves.add_fingerprint(H,1)
	if(H.ears)
		H.ears.add_fingerprint(H,1)
	if(H.glasses)
		H.glasses.add_fingerprint(H,1)
	if(H.belt)
		H.belt.add_fingerprint(H,1)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H,1)
	if(H.s_store)
		H.s_store.add_fingerprint(H,1)
	if(H.l_store)
		H.l_store.add_fingerprint(H,1)
	if(H.r_store)
		H.r_store.add_fingerprint(H,1)
	return 1

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	. = list()

	if(CONFIG_GET(flag/jobs_have_minimal_access))
		. = src.minimal_access.Copy()
	else
		. = src.access.Copy()

//	if(config.jobs_have_maint_access & EVERYONE_HAS_MAINT_ACCESS) //Config has global maint access set
//		. |= list(access_maint_tunnels)

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return 1	//Available in 0 days = available right now = player is old enough to play.
	return 0


/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!isnum(C.player_age))
		return 0 //This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

/datum/job/proc/config_check()
	return 1

/datum/outfit/job
	name = "Standard Gear"

	var/backpack = /obj/item/weapon/storage/backpack/stalker
	var/satchel  = /obj/item/weapon/storage/backpack/stalker
	var/box// = /obj/item/weapon/storage/box/survival

	var/pda_slot = slot_belt

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H.backbag == 1) //Backpack
		back =  backpack
	else //Satchel
		back = satchel

	backpack_contents[box] = 1

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	//var/obj/item/weapon/card/id/C = H.wear_id
	//var/obj/item/device/stalker_pda/C = H.wear_id
	//if(istype(C))
		//var/datum/job/J = SSjob.GetJob(H.job) // Not sure the best idea
		//C.access = J.get_access()
		//C.registered_name = H.real_name
		//C.faction_s = src.faction_s
		//C.rank = H.rank
		//C.owner = H
		//var/image = get_id_photo(H)
		//var/obj/item/weapon/photo/photo_kpk_f = new()
		//var/obj/item/weapon/photo/photo_kpk_s = new()
		//photo_kpk_f.photocreate(null, icon(image, dir = SOUTH))
		//photo_kpk_s.photocreate(null, icon(image, dir = WEST))
		//C.owner_photo_f = photo_kpk_f
		//C.owner_photo_s = photo_kpk_s

		//C.assignment = H.job
		//C.update_label()
		//H.sec_hud_set_ID()

//	var/obj/item/device/pda/PDA = H.get_item_by_slot(pda_slot)
//	if(istype(PDA))
//		PDA.owner = H.real_name
//		PDA.ownjob = H.job
//		PDA.update_label()

//datum/outfit/job/proc/announce_head(var/mob/living/carbon/human/H, var/channels) //tells the given channel that the given mob is the new department head. See communications.dm for valid channels.
//	spawn(4) //to allow some initialization
//		if(H && announcement_systems.len)
//			var/obj/machinery/announcement_system/announcer = pick(announcement_systems)
//			announcer.announce("NEWHEAD", H.real_name, H.job, channels)
/*
/datum/job/proc/SetTotalPositions()
	total_positions = initial(total_positions)
	for(var/obj/machinery/stalker/sidorpoint/SP in SPs)
		if(SP && SP.controlled_by == faction_s && SP.control_percent == 100)
			total_positions += 3
*/