/datum/admins/key_down(_key, client/user)
	switch(_key)
//		if("F3")
//			user.get_admin_say()
//			return
		if("F5")
			user.cmd_admin_say(input(user,, "Admin Say") as text)
			return
		if("F6")
			user.player_panel_new()
			return
//		if("F7")
//			user.Admin_PM()
//			return
		if("F8")
			if(user.keys_held["Ctrl"])
				user.stealth()
			else
				user.invisimin()
			return
//		if("F10")
//			user.get_dead_say()
//			return
	..()
