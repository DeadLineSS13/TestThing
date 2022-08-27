
/obj/screen/action_button
	var/datum/action/linked_action
	var/actiontooltipstyle = ""
	screen_loc = null

/obj/screen/action_button/Click(location,control,params)
	if(usr.next_move >= world.time) // Is this needed ?
		return
	linked_action.Trigger()
	return 1

//Hide/Show Action Buttons ... Button
/obj/screen/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/mob/actions.dmi'
	icon_state = "bg_default"
	var/hidden = 0

/obj/screen/action_button/hide_toggle/Click(location,control,params)
	usr.hud_used.action_buttons_hidden = !usr.hud_used.action_buttons_hidden

	hidden = usr.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	UpdateIcon()
	usr.update_action_buttons()


/obj/screen/action_button/hide_toggle/proc/InitialiseIcon(mob/living/user)
	icon_state = "bg_default"
	UpdateIcon()

/obj/screen/action_button/hide_toggle/proc/UpdateIcon()
	cut_overlays()
	var/image/img = image(icon, src, hidden ? "show" : "hide")
	add_overlay(img)


/*/obj/screen/action_button/MouseEntered(location,control,params)
	openToolTip(usr,src,params,title = name,content = desc,theme = actiontooltipstyle)


/obj/screen/action_button/MouseExited()
	closeToolTip(usr)*/


/mob/proc/update_action_buttons_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

//This is the proc used to update all the action buttons.
/mob/proc/update_action_buttons(reload_screen)
	if(!hud_used || !client)
		return

	var/button_number = 0

	if(hud_used.action_buttons_hidden)
		for(var/datum/action/A in actions)
			A.button.screen_loc = null
			if(reload_screen)
				client.screen += A.button
	else
		for(var/datum/action/A in actions)
			button_number++
			A.UpdateButtonIcon()
			var/obj/screen/action_button/B = A.button
			B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			if(reload_screen)
				client.screen += B

		if(hud_used && !button_number)
			hud_used.hide_actions_toggle.screen_loc = null
			return

	hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
	if(reload_screen)
		client.screen += hud_used.hide_actions_toggle



#define AB_MAX_COLUMNS 10

/datum/hud/proc/ButtonNumberToScreenCoords(number) // TODO : Make this zero-indexed for readabilty
	var/row = round((number - 1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1

	var/coord_col = "+[col-1]"
	var/coord_col_offset = 4 + 2 * col

	var/coord_row = "[row ? -row : "+0"]"

	return "WEST[coord_col]:[coord_col_offset],NORTH[coord_row]:-6"
