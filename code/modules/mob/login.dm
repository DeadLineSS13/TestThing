//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]")
	if(CONFIG_GET(flag/log_access))
		for(var/mob/M in GLOB.player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(M.client)
						message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name_admin(src)] has the same [matches] as [key_name_admin(M)].</font>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B><font color='blue'>[key_name_admin(src)] has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>")
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()
	GLOB.player_list |= src
	update_Login_details()
	world.update_status()

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = list()				//remove hud items just in case
	client.show_popup_menus = 0

	if(!hud_used)
		create_mob_hud()
	if(hud_used)
		hud_used.show_hud(hud_used.hud_version)

	next_move = 1
	sight |= SEE_SELF

	..()
	if (key != client.key)
		key = client.key
	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

//	if(isobj(loc))
//		var/obj/Loc=loc
//		Loc.on_log()

//	reset_perspective(loc)

//	get_asset_datum(/datum/asset/simple/kpk).send(src)
	//readd this mob's HUDs (antag, med, etc)
	reload_huds()

	if(ckey in GLOB.deadmins)
		verbs += /client/proc/readmin

	last_ckey = ckey

	add_click_catcher()

	reload_fullscreen()

	sync_mind()

	update_client_colour(0)
	overlay_fullscreen("whitenoise", /obj/screen/fullscreen/whitenoise)


// Calling update_interface() in /mob/Login() causes the Cyborg to immediately be ghosted; because of winget().
// Calling it in the overriden Login, such as /mob/living/Login() doesn't cause this.
/mob/proc/update_interface()
	if(client)
		if(winget(src, "mainwindow.hotkey_toggle", "is-checked") == "true")
			update_hotkey_mode()
		else
			update_normal_mode()

/mob/proc/update_hotkey_mode()
	if(client)
		winset(src, null, "mainwindow.macro=hotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true")

/mob/proc/update_normal_mode()
	if(client)
		winset(src, null, "mainwindow.macro=macro hotkey_toggle.is-checked=false input.focus=true")

