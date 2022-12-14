//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/client/proc/reroll_chunks,
	/client/proc/deadmin_self,			/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,
	/client/proc/reload_admins,
	/client/proc/reestablish_db_connection,/*reattempt a connection to the database*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,		/*admin-pm list*/
	/client/proc/stop_sounds
	)
var/list/admin_verbs_admin = list(
	/client/proc/player_panel_new,		/*shows an interface for all players, with links to various panels*/
	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/set_admin_notice,/*announcement all clients see when joining the server.*/
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/datum/admins/proc/view_txt_log,	/*shows the server log (diary) for today*/
	/datum/admins/proc/view_atk_log,	/*shows the server combat-log, doesn't do anything presently*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/giveruntimelog,		/*allows us to give access to runtime logs to somebody*/
	/client/proc/getruntimelog,			/*allows us to access runtime logs to somebody*/
	/client/proc/getserverlog,			/*allows us to fetch server logs (diary) for other days*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage
	/client/proc/jumptoarea,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_local_narrate,	/*sends text to all mobs within view of atom*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/edit_sidormat_datums,
	/client/proc/toggle_AI_interact /*toggle admin ability to interact with machines as an AI*/
	///client/proc/set_daytime
	)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/DB_ban_panel,
	/client/proc/stickybanpanel
	)
var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	)
var/list/admin_verbs_fun = list(
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/object_say,
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
//	/client/proc/forceEvent,
//	/client/proc/bluespace_artillery
	)
var/list/admin_verbs_spawn = list(
	/client/proc/SetRealCooldownBlowout,
	/datum/admins/proc/spawn_atom,		/*allows us to spawn instances*/
	/client/proc/respawn_character
	)
var/list/admin_verbs_server = list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/end_round,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/client/proc/everyone_random,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
#if SERVERTOOLS
	/client/proc/forcerandomrotate,
	/client/proc/adminchangemap,
#endif
	/client/proc/panicbunker


	)
var/list/admin_verbs_debug = list(
	/client/proc/toggle_popups,
	/client/proc/SetTimeOfDay,
	/client/proc/SetAverageCooldownBlowout,
	/client/proc/SetRespawnRate,
	/client/proc/StopBlowout,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/SDQL2_query,
	/client/proc/test_movable_UI,
	/client/proc/test_snap_UI,
	/client/proc/check_bomb_impacts,
	/client/proc/cmd_display_del_log,
	/client/proc/reset_latejoin_spawns,
	/client/proc/create_outfits,
	/client/proc/debug_huds,
	/client/proc/count_objects_all
	)
var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions,
	/client/proc/create_poll
	)
var/list/admin_verbs_rejuv = list(
	/client/proc/respawn_character
	)

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/deadmin_self,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/datum/admins/proc/set_admin_notice,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/datum/admins/proc/view_txt_log,
	/datum/admins/proc/view_atk_log,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_check_contents,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/object_say,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/client/proc/everyone_random,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/proc/possess,
	/proc/release,
	/client/proc/reload_admins,
	/client/proc/panicbunker,
	/client/proc/cmd_display_del_log,
	/client/proc/debug_huds
	)

/client/proc/add_admin_verbs()
	if(holder)
		control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS

		var/rights = holder.rank.rights
		verbs += admin_verbs_default
		if(rights & R_BUILDMODE)	verbs += /client/proc/togglebuildmodeself
		if(rights & R_ADMIN)		verbs += admin_verbs_admin
		if(rights & R_BAN)			verbs += admin_verbs_ban
		if(rights & R_FUN)			verbs += admin_verbs_fun
		if(rights & R_SERVER)		verbs += admin_verbs_server
		if(rights & R_DEBUG)		verbs += admin_verbs_debug
		if(rights & R_POSSESS)		verbs += admin_verbs_possess
		if(rights & R_PERMISSIONS)	verbs += admin_verbs_permissions
		if(rights & R_STEALTH)		verbs += /client/proc/stealth
		if(rights & R_REJUVINATE)	verbs += admin_verbs_rejuv
		if(rights & R_SOUNDS)		verbs += admin_verbs_sounds
		if(rights & R_SPAWN)		verbs += admin_verbs_spawn

		for(var/path in holder.rank.adds)
			verbs += path
		for(var/path in holder.rank.subs)
			verbs -= path

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		/*Debug verbs added by "show debug verbs"*/
		/client/proc/Cell,
		/client/proc/air_status,
		/client/proc/count_objects_all,
		/client/proc/cmd_assume_direct_control,
		/client/proc/fps511,
		/client/proc/readmin
		)
	if(holder)
		verbs.Remove(holder.rank.adds)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	src << "<span class='interface'>Most of your adminverbs have been hidden.</span>"
	feedback_add_details("admin_verb","HMV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	src << "<span class='interface'>Almost all of your adminverbs have been hidden.</span>"
	feedback_add_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	src << "<span class='interface'>All of your adminverbs are now visible.</span>"
	feedback_add_details("admin_verb","TAVVS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/*
/client/proc/GetRank()
	set name = "Get Rank"
	set category = "Stalker"

	var/mob/living/carbon/human/selected = input("Please, select a stalker!", "S.T.A.L.K.E.R.", null) as null|anything in sortRealNames(KPK_mobs)

	if(!selected)
		return

	var/datum/data/record/sk = find_record("sid", selected.sid, GLOB.data_core.stalkers)

	if(!sk)
		usr << "<span class='warning'>Stalker profile not found.</span>"
		return

	var/sk_name = sk.fields["name"]
	var/sk_rating = sk.fields["rating"]

	usr << "<span class='interface'>[sk_name] rating is [sk_rating]. He is [get_rank_name(sk_rating)]</span>"

/client/proc/SetRank()
	set name = "Set Rank"
	set category = "Stalker"

	var/mob/living/carbon/human/selected = input("Please, select a stalker!", "S.T.A.L.K.E.R.", null) as null|anything in sortRealNames(KPK_mobs)

	if(!selected)
		return

	var/datum/data/record/sk = find_record("sid", selected.sid, GLOB.data_core.stalkers)

	if(!sk)
		usr << "<span class='warning'>Stalker profile not found.</span>"
		return

	var/newrank = input(usr, "??????? ????? ???? ???????? ?? 0 ?? ?????????????.", "Rating System") as num|null

	if(!newrank)
		return

	var/oldrank = sk.fields["rating"]
	var/sk_name = sk.fields["name"]

	sk.fields["rating"] = newrank

	usr << "<span class='interface'>Rating successfully updated from [oldrank] to [newrank].</span>"
	log_admin("[key_name(usr)] changed [sk_name] rank from [oldrank] to [newrank].")
	message_admins("[key_name_admin(usr)] changed [sk_name] rank from [oldrank] to [newrank].")

/client/proc/SetMoney()
	set name = "Set Money"
	set category = "Stalker"

	var/mob/living/carbon/human/selected = input("Please, select a stalker!", "S.T.A.L.K.E.R.", null) as null|anything in sortRealNames(KPK_mobs)

	if(!selected)
		return

	var/datum/data/record/sk = find_record("sid", selected.sid, GLOB.data_core.stalkers)

	if(!sk)
		usr << "<span class='warning'>Stalker profile not found.</span>"
		return

	var/sk_name = sk.fields["name"]
	var/sk_money = sk.fields["money"]

	src << "<span class='interface'>[sk_name] holds [sk_money] RU in his account.</span>"
	var/newbalance = input(usr, "Input new balance.", "S.T.A.L.K.E.R.") as num|null

	if(!newbalance)
		return

	sk.fields["money"] = newbalance
	usr << "<span class='interface'>Balance successfully updated from [sk_money] to [newbalance].</span>"

	log_admin("[key_name(usr)] updated [sk_name] money balance from [sk_money] to [newbalance].")
	message_admins("[key_name_admin(usr)] updated [sk_name] money balance from [sk_money] to [newbalance].")



/client/proc/GetMoney()
	set name = "Get Money"
	set category = "Stalker"

	var/mob/living/carbon/human/selected = input("Please, select a stalker!", "S.T.A.L.K.E.R.", null) as null|anything in sortRealNames(KPK_mobs)

	if(!selected)
		return

	var/datum/data/record/sk = find_record("sid", selected.sid, GLOB.data_core.stalkers)

	if(!sk)
		usr << "<span class='warning'>Stalker profile not found.</span>"
		return

	var/sk_name = sk.fields["name"]
	var/sk_money = sk.fields["money"]

	src << "<span class='interface'>[sk_name] holds [sk_money] RU in his account.</span>"
	log_admin("[key_name(usr)] checked [sk_name] account balance.")
	message_admins("[key_name_admin(usr)] checked [sk_name] account balance.")

/client/proc/GetFaction()
	set name = "Get Faction"
	set category = "Stalker"

	var/mob/living/carbon/human/selected = input("Please, select a stalker!", "S.T.A.L.K.E.R.", null) as null|anything in sortRealNames(KPK_mobs)

	if(!selected)
		return

	var/datum/data/record/sk = find_record("sid", selected.sid, GLOB.data_core.stalkers)

	if(!sk)
		usr << "<span class='warning'>Stalker profile not found.</span>"
		return

	var/sk_name = sk.fields["name"]
	var/sk_faction_s = sk.fields["faction_s"]

	src << "<span class='interface'>[sk_name] is a part of [sk_faction_s].</span>"

/client/proc/SetFaction()
	set name = "Set Faction"
	set category = "Stalker"

	var/mob/living/carbon/human/selected = input("Please, select a stalker!", "S.T.A.L.K.E.R.", null) as null|anything in sortRealNames(KPK_mobs)

	if(!selected)
		return

	var/datum/data/record/sk = find_record("sid", selected.sid, GLOB.data_core.stalkers)

	if(!sk)
		usr << "<span class='warning'>Stalker profile not found.</span>"
		return

	var/newfaction = input(usr, "Insert new faction with a BIG first letter.", "S.T.A.L.K.E.R.") as text|null

	if(!newfaction)
		return

	var/sk_name = sk.fields["name"]
	var/sk_faction_s = sk.fields["faction_s"]

	src << "<span class='interface'>[sk_name] was a part of [sk_faction_s].</span>"
	sk.fields["faction_s"] = newfaction

	usr << "<span class='interface'>[sk_name] joined [sk_faction_s].</span>"

	log_admin("[key_name(usr)] changed [sk_name] faction from [sk_faction_s] to [newfaction].")
	message_admins("[key_name_admin(usr)] changed [sk_name] faction from [sk_faction_s] to [newfaction].")

*/
/client/proc/SetTimeOfDay()
	set name = "Set Time of Day"
	set category = "Stalker"

	var/daytime = input(usr, "Choose time of day to set)", "S.T.A.L.K.E.R.") as null|anything in list("Morning", "Day", "Evening", "Night")

	if(!daytime)
		return

	switch(daytime)
		if("Morning")
			daytime = 1
		if("Day")
			daytime = 2
		if("Evening")
			daytime = 3
		if("Night")
			daytime = 4

	set_time_of_day(daytime)
	usr << "<span class='interface'>Time of day successfully updated.</span>"
	log_admin("[key_name(usr)] changed time of day to [daytime].")
	message_admins("[key_name_admin(usr)] changed time of day to [daytime].")

/client/proc/SetAverageCooldownBlowout()
	set name = "Set Blowout Cooldown"
	set category = "Stalker"

	var/cooldown = input(usr, "Input blowout average cooldown.", " S.T.A.L.K.E.R.") as num|null

	if(!cooldown)
		return

	log_admin("[key_name(usr)] changed blowout average cooldown from [SSblowout.cooldown] to [cooldown].")
	message_admins("[key_name(usr)] changed blowout average cooldown from [SSblowout.cooldown] to [cooldown].")

	SSblowout.cooldown = cooldown
	src << "<span class='interface'>Blowout average cooldown successfully changed.</span>"

/client/proc/SetRealCooldownBlowout()
	set name = "Start Blowout"
	set category = "Stalker"

	var/cooldown = input(usr, "Input the blowout timer", "S.T.A.L.K.E.R.") as num|null

	if(!cooldown)
		return

	SSblowout.lasttime = world.time
	SSblowout.cooldown = cooldown
	src << "<span class='interface'>Blowout will start in [round((SSblowout.lasttime + cooldown - world.time)/10/60) + 1] min.</span>"

	log_admin("[key_name(usr)] forced blowout to start in [round((SSblowout.lasttime + cooldown - world.time)/10/60) + 1].")
	message_admins("[key_name_admin(usr)] forced blowout to start in [round((SSblowout.lasttime + cooldown - world.time)/10/60) + 1].")

/client/proc/StopBlowout()
	set name = "Stop Blowout"
	set category = "Stalker"

	if(!isblowout)
		src << "<span class='warning'>There is no blowout going on.</span>"
		return

	if(alert("Are you sure you want to stop the blowout?", "S.T.A.L.K.E.R.", "Yes", "No") == "No")
		return

	SSblowout.cleaned = 1
	SSblowout.starttime = world.time - BLOWOUT_DURATION_STAGE_III + 1

	log_admin("[key_name(usr)] stoped the blowout.")
	message_admins("[key_name_admin(usr)] stoped the blowout.")


/client/proc/SetRespawnRate()
	set name = "Set Respawn Rate"
	set category = "Stalker"

	var/newrespawnrate = input(usr, "Input new respawn rate in minutes", "S.T.A.L.K.E.R.") as num|null

	if(!newrespawnrate)
		return

	world << "<font color='red'><b>Respawn rate has been changed by admins from [round(CONFIG_GET(number/respawn_timer)/600)] min to [newrespawnrate] min!</b></font color>"

	log_admin("[key_name(usr)] changed respawn rate from [round(CONFIG_GET(number/respawn_timer)/600)] to [newrespawnrate].")
	message_admins("[key_name_admin(usr)] changed respawn rate from [round(CONFIG_GET(number/respawn_timer)/600)] to [newrespawnrate].")

	CONFIG_SET(number/respawn_timer, round(newrespawnrate * 600))

/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(istype(mob,/mob/dead/observer))
		//re-enter
		var/mob/dead/observer/ghost = mob
		if (!ghost.can_reenter_corpse)
			log_admin("[key_name(usr)] re-entered corpse")
			message_admins("[key_name_admin(usr)] re-entered corpse")
		ghost.can_reenter_corpse = 1			//just in-case.
		ghost.reenter_corpse()
		feedback_add_details("admin_verb","P") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else if(istype(mob,/mob/new_player))
		src << "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>"
	else
		//ghostize
		log_admin("[key_name(usr)] admin ghosted")
		message_admins("[key_name_admin(usr)] admin ghosted")
		var/mob/body = mob
		body.ghostize(1)
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		feedback_add_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			mob << "<span class='boldannounce'>Invisimin off. Invisibility reset.</span>"
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			mob << "<span class='adminnotice'><b>Invisimin on. You are now as invisible as a ghost.</b></span>"

/client/proc/player_panel_new()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()
	feedback_add_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
		if(!isobserver(usr))
			message_admins("[key_name_admin(usr)] checked antagonists.")
	feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(CONFIG_GET(flag/ban_legacy_system))
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	feedback_add_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	feedback_add_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return


/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in GLOB.stealthminID)
			if(GLOB.stealthminID[P] == txt)
				return P
	txt = GLOB.stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	GLOB.stealthminID["[ckey]"] = "@[num2text(num)]"

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)	return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
			createStealthKey()
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
	feedback_add_details("admin_verb","SM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_bomb()
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as null|num
			if(devastation_range == null)
				return
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as null|num
			if(heavy_impact_range == null)
				return
			var/light_impact_range = input("Light impact range (in tiles):") as null|num
			if(light_impact_range == null)
				return
			var/flash_range = input("Flash range (in tiles):") as null|num
			if(flash_range == null)
				return
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("<span class='adminnotice'>[ckey] creating an admin explosion at [epicenter.loc].</span>")
	feedback_add_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
/client/proc/give_spell(mob/T in mob_list)
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."

	var/list/spell_list = list()
	var/type_length = length("/obj/effect/proc_holder/spell") + 2
	for(var/A in spells)
		spell_list[copytext("[A]", type_length)] = A
	var/obj/effect/proc_holder/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spell_list
	if(!S)
		return
	S = spell_list[S]
	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] gave [key_name(T)] the spell [S].</span>")
	if(T.mind)
		T.mind.AddSpell(new S)
	else
		T.AddSpell(new S)
		message_admins("<span class='danger'>Spells given to mindless mobs will not be transferred in mindswap or cloning!</span>")


/client/proc/MakeController(mob/user in mob_list)
	set category = "Fun"
	set name = "Make Controller"
	set desc = "??????? ???????????."
	if(user.stat || !user)
		return
	var/mob/living/carbon/human/H = user
	for(var/obj/item/I in H) //drops all items
		H.unEquip(I)
	H.real_name = "Controller"
	H.name = "Controller"
	H.stunned = 0 //Same as above. Due to hulks.
	H.visible_message("<span class='warning'>The chrysalis explodes in a shower of purple flesh and fluid!</span>")
	H.underwear = "Nude"
	H.undershirt = "Nude"
	H.socks = "Nude"
	H.equip_to_slot_or_del(new /obj/item/clothing/under/shadowling(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/shadowling(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/shadowling(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/shadowling(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/shadowling(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/shadowling(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/shadowling(H), slot_glasses)
	H << "<span class='shadowling'><b><i>Your powers are awoken. You may now live to your fullest extent. Remember your goal. Cooperate with your thralls and allies.</b></i></span>"
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/glare(null))

/client/proc/give_disease(mob/T in mob_list)
	set category = "Fun"
	set name = "Give Disease"
	set desc = "Gives a Disease to a mob."
	var/datum/disease/D = input("Choose the disease to give to that guy", "ACHOO") as null|anything in diseases
	if(!D) return
	T.ForceContractDisease(new D)
	feedback_add_details("admin_verb","GD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the disease [D].")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] gave [key_name(T)] the disease [D].</span>")
*/
/client/proc/object_say(obj/O in world)
	set category = "Special Verbs"
	set name = "OSay"
	set desc = "Makes an object say something."
	var/message = sanitize_russian(input(usr, "What do you want the message to be?", "Make Sound") as text | null)
	if(!message)
		return
	var/templanguages = O.languages
	O.languages |= ALL
	O.say(message)
	O.languages = templanguages
	log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z] say \"[message]\"")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. say \"[message]\"</span>")
	feedback_add_details("admin_verb","OS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
//	if(src.mob)
//		togglebuildmode(src.mob)
	feedback_add_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		log_admin("[src] deadmined themself.")
		message_admins("[src] deadmined themself.")
		deadmin()
		verbs += /client/proc/readmin
		GLOB.deadmins += ckey
		src << "<span class='interface'>You are now a normal player.</span>"
	feedback_add_details("admin_verb","DAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(CONFIG_GET(flag/log_admin))
			CONFIG_SET(flag/log_admin, 0)
			src << "<b>Stopped logging hrefs</b>"
		else
			CONFIG_SET(flag/log_admin, 1)
			src << "<b>Started logging hrefs</b>"

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/readmin()
	set name = "Re-admin self"
	set category = "Admin"
	set desc = "Regain your admin powers."
	var/list/rank_names = list()
	for(var/datum/admin_rank/R in admin_ranks)
		rank_names[R.name] = R
	var/datum/admins/D = admin_datums[ckey]
	var/rank = null
	if(CONFIG_GET(flag/admin_legacy_system))
		//load text from file
		var/list/Lines = file2list("config/admins.txt")
		for(var/line in Lines)
			var/list/splitline = text2list(line, " = ")
			if(ckey(splitline[1]) == ckey)
				if(splitline.len >= 2)
					rank = ckeyEx(splitline[2])
				break
			continue
	else
		if(!dbcon.IsConnected())
			message_admins("Warning, mysql database is not connected.")
			src << "Warning, mysql database is not connected."
			return
		var/sql_ckey = sanitizeSQL(ckey)
		var/DBQuery/query = dbcon.NewQuery("SELECT rank FROM [format_table_name("admin")] WHERE ckey = '[sql_ckey]'")
		query.Execute()
		while(query.NextRow())
			rank = ckeyEx(query.item[1])
	if(!D)
		if(rank_names[rank] == null)
			var/error_extra = ""
			if(!CONFIG_GET(flag/admin_legacy_system))
				error_extra = " Check mysql DB connection."
			src << "Error while re-adminning, admin rank ([rank]) does not exist.[error_extra]"
			WARNING("Error while re-adminning [src], admin rank ([rank]) does not exist.[error_extra]")
			return
		D = new(rank_names[rank],ckey)
		var/client/C = GLOB.directory[ckey]
		D.associate(C)
		message_admins("[src] re-adminned themselves.")
		log_admin("[src] re-adminned themselves.")
		GLOB.deadmins -= ckey
		feedback_add_details("admin_verb","RAS")
		return
	else
		src << "You are already an admin."
		verbs -= /client/proc/readmin
		GLOB.deadmins -= ckey
		return

/client/proc/toggle_AI_interact()
 	set name = "Toggle Admin AI Interact"
 	set category = "Admin"
 	set desc = "Allows you to interact with most machines as an AI would as a ghost"

 	AI_Interact = !AI_Interact
 	log_admin("[key_name(usr)] has [AI_Interact ? "activated" : "deactivated"] Admin AI Interact")
 	message_admins("[key_name_admin(usr)] has [AI_Interact ? "activated" : "deactivated"] their AI interaction")