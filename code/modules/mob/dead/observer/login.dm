/mob/dead/observer/Login()
	..()

	if(check_rights(R_ADMIN, 0))
		has_unlimited_silicon_privilege = 1

	if(client.prefs && client.prefs.unlock_content)
		icon_state = client.prefs.ghost_form
		if (ghostimage)
			ghostimage.icon_state = src.icon_state
		ghost_orbit = client.prefs.ghost_orbit

	updateghostimages()
	client.show_popup_menus = 0


	update_interface()