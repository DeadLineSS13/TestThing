/datum/hud
	var/mob/mymob

	var/hud_shown = 1			//Used for the HUD toggle (F12)
	var/hud_version = 1			//Current displayed version of the HUD
	var/inventory_shown = 0		//Equipped item inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/list/static_inventory = list() //the screen objects which are static
	var/list/toggleable_inventory = list() //the screen objects which can be hidden
	var/list/obj/screen/hotkeybuttons = list() //the buttons that can be used via hotkeys
	var/list/infodisplay = list() //the screen objects that display mob info (health, alien plasma, etc...)
	var/list/screenoverlays = list() //the screen objects used as whole screen overlays (flash, damageoverlay, etc...)
	var/list/inv_slots[slots_amt] // /obj/screen/inventory objects, ordered by their slot ID.
	var/list/hand_slots // /obj/screen/inventory/hand objects, assoc list of "[held_index]" = object
	var/list/obj/screen/plane_master/plane_masters = list() // see "appearance_flags" in the ref, assoc list of "[plane]" = object
	var/list/bars = list()

	var/obj/screen/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = 0

	var/obj/screen/action_intent
	var/obj/screen/zone_select
	var/obj/screen/pull_icon
	var/obj/screen/throw_icon
	var/obj/screen/mov_intent
	var/obj/screen/rest_icon

	var/obj/screen/healthdoll
	var/obj/screen/stamina
	var/obj/screen/internals

	var/obj/screen/stats/str
	var/obj/screen/stats/agi
	var/obj/screen/stats/hlt
	var/obj/screen/stats/int

	var/obj/screen/hunger
	var/obj/screen/thirst
	var/obj/screen/weight
	var/obj/screen/mental

	var/obj/screen/maptext/maptext = null

/datum/hud/New(mob/owner)
	mymob = owner
	hide_actions_toggle = new
	hide_actions_toggle.InitialiseIcon(mymob)
	hand_slots = list()
	for(var/mytype in subtypesof(/obj/screen/plane_master))
		var/obj/screen/plane_master/instance = new mytype()
		plane_masters["[instance.plane]"] = instance

/datum/hud/Destroy()
	if(mymob.hud_used == src)
		mymob.hud_used = null

	if(hide_actions_toggle)
		qdel(hide_actions_toggle)
	hide_actions_toggle = null

	if(static_inventory.len)
		for(var/thing in static_inventory)
			qdel(thing)
		static_inventory.Cut()

	if(inv_slots.len)
		for(var/thing in toggleable_inventory)
			if(!isnull(thing))
				qdel(thing)
		inv_slots.Cut()

	if(toggleable_inventory.len)
		for(var/thing in toggleable_inventory)
			qdel(thing)
		toggleable_inventory.Cut()

	if(hotkeybuttons.len)
		for(var/thing in hotkeybuttons)
			qdel(thing)
		hotkeybuttons.Cut()

	if(infodisplay.len)
		for(var/thing in infodisplay)
			qdel(thing)
		infodisplay.Cut()

	hand_slots.Cut()

	if(bars.len)
		for(var/thing in hand_slots)
			qdel(thing)
		bars.Cut()


	action_intent = null
	zone_select = null
	pull_icon = null
	throw_icon = null
	mov_intent = null
	rest_icon = null

	healthdoll = null
	stamina = null
	internals = null

	str = null
	agi = null
	hlt = null
	int = null

	hunger = null
	thirst = null
	weight = null
	mental = null

	if(maptext)
		qdel(maptext)
	maptext = null


	if(plane_masters.len)
		for(var/thing in plane_masters)
			qdel(plane_masters[thing])
		plane_masters.Cut()

	if(screenoverlays.len)
		for(var/thing in screenoverlays)
			qdel(thing)
		screenoverlays.Cut()


	mymob = null
	return ..()

/mob/proc/create_mob_hud()
	if(client && !hud_used)
		hud_used = new /datum/hud(src)

//Version denotes which style should be displayed. blank or 0 means "next version"
/datum/hud/proc/show_hud(version = 0,mob/viewmob)
	if(!ismob(mymob))
		return 0
	if(!mymob.client)
		return 0

	var/mob/screenmob = viewmob || mymob

	screenmob.client.screen = list()

	var/display_hud_version = version
	if(!display_hud_version)	//If 0 or blank, display the next hud version
		display_hud_version = hud_version + 1
	if(display_hud_version > HUD_VERSIONS)	//If the requested version number is greater than the available versions, reset back to the first version
		display_hud_version = 1

	maptext = new(src)
	screenmob.client.screen += maptext

	switch(display_hud_version)
		if(HUD_STYLE_STANDARD)	//Default HUD
			hud_shown = 1	//Governs behavior of other procs
			if(bars.len)
				screenmob.client.screen += bars
			if(static_inventory.len)
				screenmob.client.screen += static_inventory
			if(toggleable_inventory.len && screenmob.hud_used && screenmob.hud_used.inventory_shown)
				screenmob.client.screen += toggleable_inventory
			if(hotkeybuttons.len && !hotkey_ui_hidden)
				screenmob.client.screen += hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen += infodisplay

			mymob.client.screen += hide_actions_toggle

			if(action_intent)
				action_intent.screen_loc = initial(action_intent.screen_loc) //Restore intent selection to the original position

		if(HUD_STYLE_REDUCED)	//Reduced HUD
			hud_shown = 0	//Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				screenmob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				screenmob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen += infodisplay

			//These ones are a part of 'static_inventory', 'toggleable_inventory' or 'hotkeybuttons' but we want them to stay
			if(action_intent)
				screenmob.client.screen += action_intent		//we want the intent switcher visible
				action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.

		if(HUD_STYLE_NOHUD)	//No HUD
			hud_shown = 0	//Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				screenmob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				screenmob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen -= infodisplay

	if(plane_masters.len)
		for(var/thing in plane_masters)
			screenmob.client.screen += plane_masters[thing]

/*	if(!screenmob.dark_plane)
		screenmob.dark_plane = new(screenmob.client)
	else
		screenmob.client.screen |= screenmob.dark_plane
	if(!screenmob.master_plane)
		screenmob.master_plane = new(screenmob.client)
	else
		screenmob.client.screen |= screenmob.master_plane

	if(istype(screenmob,/mob/living/carbon))
		var/mob/living/carbon/C = screenmob
		if(!C.fov)
			C.fov = new(C.client)
		else
			C.client.screen |= C.fov*/

	hud_version = display_hud_version
	persistant_inventory_update(screenmob)
	mymob.update_action_buttons(1)
	reorganize_alerts()
	mymob.reload_fullscreen()


/datum/hud/human/show_hud(version = 0,mob/viewmob)
	..()
	hidden_inventory_update(viewmob)

/datum/hud/proc/hidden_inventory_update()
	return

/datum/hud/proc/persistant_inventory_update(mob/viewer)
	return

/*/Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12()
	set name = "F12"
	set hidden = 1

	if(hud_used && client)
		hud_used.show_hud() //Shows the next hud preset
		usr << "<span class ='info'>Switched HUD mode. Press F12 to toggle.</span>"
	else
		usr << "<span class ='warning'>This mob type does not use a HUD.</span>"*/


//(re)builds the hand ui slots, throwing away old ones
//not really worth jugglying existing ones so we just scrap+rebuild
//9/10 this is only called once per mob and only for 2 hands
/datum/hud/proc/build_hand_slots(ui_style = 'icons/mob/screen_midnight.dmi')
	for(var/h in hand_slots)
		var/obj/screen/inventory/hand/H = hand_slots[h]
		if(H)
			static_inventory -= H
	hand_slots = list()
	var/obj/screen/inventory/hand/hand_box
	for(var/i = 1 to mymob.held_items.len)
		hand_box = new /obj/screen/inventory/hand()
		hand_box.name = mymob.get_held_index_name(i)
		if(hand_box.name == "right hand")
			hand_box.name_ru = "правая рука"
		else
			hand_box.name_ru = "левая рука"
		hand_box.icon = ui_style
		hand_box.icon_state = "hand_[mymob.held_index_to_dir(i)]"
		hand_box.screen_loc = ui_hand_position(i)
		hand_box.held_index = i
		hand_slots["[i]"] = hand_box
		hand_box.hud = src
		static_inventory += hand_box
		hand_box.update_icon()

/*	var/i = 1
	for(var/obj/screen/swap_hand/SH in static_inventory)
		SH.screen_loc = ui_swaphand_position(mymob,!(i % 2) ? 2: 1)
		i++
	for(var/obj/screen/human/equip/E in static_inventory)
		E.screen_loc = ui_equip_position(mymob)
	if(mymob.hud_used)
		show_hud(HUD_STYLE_STANDARD,mymob)*/
/*

var/datum/global_hud/global_hud = new()
var/list/global_huds = list(
		global_hud.druggy,
		global_hud.blurry,
		global_hud.vimpaired,
		global_hud.darkMask,
		global_hud.nvg,)

/datum/global_hud
	var/obj/screen/druggy
	var/obj/screen/blurry
	var/list/vimpaired
	var/list/darkMask
	var/obj/screen/nvg

/datum/global_hud/proc/setup_overlay(var/icon_state)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = "1,1"
	screen.icon = 'icons/stalker/hud_full.dmi'
	screen.icon_state = icon_state
	screen.layer = SCREEN_LAYER
	screen.mouse_opacity = 0

/datum/global_hud/New()
	//420erryday psychedellic colours screen overlay for when you are high
	druggy = new /obj/screen()
	druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	druggy.icon_state = "druggy"
	druggy.blend_mode = BLEND_MULTIPLY
	druggy.layer = 17
	druggy.mouse_opacity = 0

	//that white blurry effect you get when you eyes are damaged
	blurry = new /obj/screen()
	blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	blurry.icon_state = "blurry"
	blurry.layer = 17
	blurry.mouse_opacity = 0

//	nvg = setup_overlay("nvg_hud")
	nvg = new /obj/screen()
	nvg.screen_loc = "WEST,SOUTH to EAST,NORTH"
	nvg.icon = 'icons/stalker/hud_full.dmi'
	nvg.icon_state = "nvg_hud1"
	nvg.layer = 17
	nvg.mouse_opacity = 0

	var/obj/screen/O
	var/i
	//that nasty looking dither you  get when you're short-sighted
	vimpaired = newlist(/obj/screen,/obj/screen,/obj/screen,/obj/screen)
	O = vimpaired[1]
	O.screen_loc = "WEST,SOUTH to CENTER-3,NORTH"	//West dither
	O = vimpaired[2]
	O.screen_loc = "WEST,SOUTH to EAST,CENTER-3"	//South dither
	O = vimpaired[3]
	O.screen_loc = "CENTER+3,SOUTH to EAST,NORTH"	//East dither
	O = vimpaired[4]
	O.screen_loc = "WEST,CENTER+3 to EAST,NORTH"	//North dither

	//welding mask overlay black/dither
	darkMask = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = darkMask[1]
	O.screen_loc = "CENTER-5,CENTER-5 to CENTER-3,CENTER+5" //West dither
	O = darkMask[2]
	O.screen_loc = "CENTER-5,CENTER-5 to CENTER+5,CENTER-3"	//South dither
	O = darkMask[3]
	O.screen_loc = "CENTER+3,CENTER-5 to CENTER+5,CENTER+5"	//East dither
	O = darkMask[4]
	O.screen_loc = "CENTER-5,CENTER+3 to CENTER+5,CENTER+5"	//North dither
	O = darkMask[5]
	O.screen_loc = "WEST,SOUTH to CENTER-5,NORTH"	//West black
	O = darkMask[6]
	O.screen_loc = "WEST,SOUTH to EAST,CENTER-5"	//South black
	O = darkMask[7]
	O.screen_loc = "CENTER+5,SOUTH to EAST,NORTH"	//East black
	O = darkMask[8]
	O.screen_loc = "WEST,CENTER+5 to EAST,NORTH"	//North black


	for(i = 1, i <= 4, i++)
		O = vimpaired[i]
		O.icon_state = "dither50"
		O.blend_mode = BLEND_MULTIPLY
		O.layer = 17
		O.mouse_opacity = 0

		O = darkMask[i]
		O.icon_state = "dither50"
		O.blend_mode = BLEND_MULTIPLY
		O.layer = 17
		O.mouse_opacity = 0

	for(i = 5, i <= 8, i++)
		O = darkMask[i]
		O.icon_state = "black"
		O.blend_mode = BLEND_MULTIPLY
		O.layer = 17
		O.mouse_opacity = 0
*/


/obj/screen/maptext
	screen_loc = "NORTH:14,WEST"
	plane = 20
	layer = 20
	maptext_height = 32
	maptext_width = 480
	var/last_word = null

/client/MouseEntered(object, location)
	..()
	if(!maptext_toggle)
		return
	if(istype(object, /atom) && !istype(object, /obj/lobby))
		var/atom/A = object
		if(mob.hud_used)
			var/obj_name = A.name
			if(language == "Russian")
				if(A.name_ru)
					obj_name = A.name_ru
//			if(istype(A, /obj/anomaly))
//				obj_name = "Anomaly"
//				if(language == "Russian")
//					obj_name = "Аномалия"
//			if(istype(A, /obj/item/artefact))
//				obj_name = "Artefact"
//				if(language == "Russian")
//					obj_name = "Артефакт"
			if(istype(A, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = A
				obj_name = mob.clients_names[H]
				if(!obj_name)
					obj_name = select_lang(H.get_uniq_name("RU"), H.get_uniq_name("EN"))
			if(mob.hud_used.maptext.last_word == obj_name)
				return
//			var/letter = copytext(obj_name, 1, 1)
//			obj_name = uppertext(obj_name)
//			obj_name = replacetextEx(obj_name, letter, letter, 1, 1)
//			mob.hud_used.maptext.alpha = 255
//			var/offset = round(max(0, length_char(obj_name)*4.8-32))
			mob.hud_used.maptext.maptext = "<span style='font-family: Arial; font-size: 12px; text-align: center;text-shadow: 1px 1px 2px black;'>[obj_name]</span>"
			mob.hud_used.maptext.last_word = obj_name
//			animate(mob.hud_used.maptext, alpha = 0, 15, flags = ANIMATION_END_NOW)
//			mob.hud_used.maptext.maptext = obj_name

/client
	var/maptext_toggle = 1

/client/verb/togglemaptext()
	set category = "Preferences"
	set name = "Toggle Maptext"

	maptext_toggle = !maptext_toggle
	mob.hud_used.maptext.maptext = ""