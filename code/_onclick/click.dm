/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
//This is mainly modified by click code, to modify click delays elsewhere, use next_move and changeNext_move()
/mob/var/next_click	= 0

// THESE DO NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK
/mob/var/next_move_adjust = 0 //Amount to adjust action/click delays by, + or -
/mob/var/next_move_modifier = 1 //Value to multiply action/click delays by


//Delays the mob's next click/action by num deciseconds
// eg: 10-3 = 7 deciseconds of delay
// eg: 10*0.5 = 5 deciseconds of delay
// DOES NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK

/mob/proc/changeNext_move(num)
	next_move = world.time + ((num+next_move_adjust)*next_move_modifier)

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/
/atom/Click(location,control,params)
	usr.ClickOn(src, params)
/atom/DblClick(location,control,params)
	usr.DblClickOn(src,params)

/*
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/

/mob/proc/ClickOn( atom/A, params )
	if(world.time <= next_click)
		return
	next_click = world.time + 1
//	if(client.buildmode)
//		build_click(src, client.buildmode, params, A)
//		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["ctrl"] && modifiers["right"])
		RightCtrlClickOn(A)
		return
	if(modifiers["shift"] && modifiers["right"])
		RightShiftClickOn(A)
		return
	if(modifiers["right"])
		RightClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(stat || paralysis || stunned || weakened)
		return

	face_atom(A)

	if(next_move > world.time) // in the year 2000...
		return

	if(restrained())
		changeNext_move(CLICK_CD_HANDCUFFED)   //Doing shit in cuffs shall be vey slow
		RestrainedClickOn(A)
		return

	if(in_throw_mode)
		throw_item(A)
		return

	var/obj/item/W = get_active_held_item()


	if(W == A)
		W.attack_self(src)
		if(hand)
			update_inv_hands()
		return

	// operate three levels deep here (item in backpack in src; item in box in backpack in src, not any deeper)
	if(!isturf(A) && A == loc || (A in contents) || (A.loc in contents) || (A.loc && (A.loc.loc in contents)))
		// No adjacency needed
		if(W)
			var/resolved = A.attackby(W,src)
			if(!resolved && A && W)
				W.afterattack(A,src,1,params) // 1 indicates adjacency
		else
			if(ismob(A))
				changeNext_move(CLICK_CD_MELEE)
			UnarmedAttack(A)
		return

	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	// Allows you to click on a box's contents, if that box is on the ground, but no deeper than that
	if(isturf(A) || isturf(A.loc) || (A.loc && isturf(A.loc.loc)) || (istype(A.loc, /obj/item/weapon/storage/internal) && isturf(A.loc.loc.loc)))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = A.attackby(W,src,params)
				if(!resolved && A && W)
					W.afterattack(A,src,1,params) // 1: clicking something Adjacent
			else
				if(ismob(A))
					changeNext_move(CLICK_CD_MELEE)
				UnarmedAttack(A, 1)
			return
		else // non-adjacent click
			if(W)
				W.afterattack(A,src,0,params) // 0: not Adjacent
			else
				RangedAttack(A, params)

// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	return


/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(atom/A, proximity_flag)
	if(ismob(A))
		changeNext_move(CLICK_CD_MELEE)
	return

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(atom/A, params)
/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(atom/A)
	return

/mob/living/carbon/MiddleClickOn(atom/A)
	face_atom(A)
	toggle_zoom()

/*
	Right click
*/

/mob/living/simple_animal/drone/MiddleClickOn(atom/A)
	swap_hand()

/mob
	var/zoomed = 0

/mob/proc/RightClickOn(atom/A)
	face_atom(A)
	A.RightClick(src)

/mob/living/carbon/human/RightClick(mob/living/carbon/human/user)
	if(Adjacent(user) && ishuman(user) && stat != DEAD)
		var/obj/item/I = user.get_active_held_item()
		if(I && user.a_intent != "harm")
			give()
		else
			if(user.flags & IN_PROGRESS)
				return
			user << user.client.select_lang("<span class='notice'>“ы начал нащупывать пульс...</span>","<span class='notice'>You've started checking pulse...</span>")
			user.flags += IN_PROGRESS
			if(!do_after(user, 20, 1, src))
				user.flags &= ~IN_PROGRESS
				return
			user.flags &= ~IN_PROGRESS
			user << user.client.select_lang("[stat ? "<span class='warning'>ѕульса нет!" : "<span class='notice'>ѕульс есть!"]</span>",
			"[stat ? "<span class='warning'>They don't have" : "<span class='notice'>They have"] a pulse!</span>")

/turf/RightClick(mob/user)
	if(user.listed_turf == src)
		user.listed_turf = null
	else
		user.listed_turf = src
		user.client.statpanel = "Turf"
	..()

/atom/proc/RightClick(mob/user)
	return

/mob/proc/RightShiftClickOn(atom/A)
	face_atom(A)
	A.RightShiftClick(src)
	return

/atom/proc/RightShiftClick(mob/user)
	user.pointed(src)
	return

/mob/proc/RightCtrlClickOn(atom/A)
	A.RightCtrlClick(src)
	return

/atom/proc/RightCtrlClick(mob/user)
	return

/mob/proc/toggle_zoom()
	if(!src || !src.client)
		return

//	if(israin && !zoomed)
//		src << "¬ такую погоду ничего не разглядеть!"
//		return

	zoomed = !zoomed

	if(loc != get_turf(src))
		return

	var/_x = 0
	var/_y = 0
	switch(dir)
		if(NORTH)
			_y = 7
		if(EAST)
			_x = 7
		if(SOUTH)
			_y = -7
		if(WEST)
			_x = -7

	if(zoomed)
//		set_focus(locate(x+_x, y+_y, z))
//		reset_perspective(locate(x+_x, y+_y, z))
		client.pixel_x = world.icon_size*_x
		client.pixel_y = world.icon_size*_y
		if(screens["fov"].icon_state == "helmet")
			screens["fov"].icon_state = "helmet_zoom"
		else
			screens["fov"].alpha = 0

/*
		if(israin)
			for(var/i = -7 to 7)
				for(var/j = 1 to 7)
					var/turf/stalker/TF = locate(x+(_x ? ((_x > 0) ? _x+j : _x-j) : i), y+(_y ? ((_y > 0) ? _y+j : _y-j) : i), z)
					if(TF && TF.rained)
						var/image/I = image('icons/stalker/structure/decor.dmi', TF, "rain", layer = 10)
						if(I)
							if(!client.rain_overlays.Find("[TF.x],[TF.y],[TF.z]"))
								client.rain_overlays["[TF.x],[TF.y],[TF.z]"] = I
								client.images -= client.rain_overlays["[TF.x],[TF.y],[TF.z]"]
								client.images |= client.rain_overlays["[TF.x],[TF.y],[TF.z]"]
*/
	else
		client.pixel_x = 0
		client.pixel_y = 0
//		set_focus(src)
//		reset_perspective(src)
		if(screens["fov"].icon_state == "helmet_zoom")
			screens["fov"].icon_state = "helmet"
		else
			screens["fov"].alpha = 255
/*
		if(israin)
			for(var/i = -7 to 7)
				for(var/j = 1 to 7)
					var/turf/stalker/TB = locate(x+(_x ? ((_x > 0) ? _x+j : _x-j) : i), y+(_y ? ((_y > 0) ? _y+j : _y-j) : i), z)
					if(TB && TB.rained)
						client.images -= client.rain_overlays["[TB.x],[TB.y],[TB.z]"]
						client.rain_overlays.Remove("[TB.x],[TB.y],[TB.z]")
*/
	client.fovProcess()

// In case of use break glass
/*
/atom/proc/MiddleClick(mob/M as mob)
	return
*/

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return
/atom/proc/ShiftClick(mob/user)
	if(user.client && user.client.eye == user || user.client.eye == user.loc)
		user.examinate(src)
	return

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(atom/A)
	A.CtrlClick(src)
	return
/atom/proc/CtrlClick(mob/user)
	return
/*
/atom/movable/CtrlClick(mob/living/user)
	var/mob/living/ML = user
	if(istype(ML))
		ML.pulled(src)
*/
/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(atom/A)
	A.AltClick(src)
	return

/mob/proc/TurfAdjacent(turf/T)
	return T.Adjacent(src)

/atom/proc/AltClick(mob/user)
	return
/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(mob/user)
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(atom/A)
	if(!A || !x || !y || !A.x || !A.y || stat == DEAD)
		return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy)
		return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)
			direction = NORTH
		else
			direction = SOUTH
	else
		if(dx > 0)
			direction = EAST
		else
			direction = WEST
	if(direction != dir)
		if(facing_dir)
			facing_dir = direction
		facedir(direction)

/obj/screen/click_catcher
	icon = 'icons/mob/screen_full.dmi'
	icon_state = "passage0"
	layer = 0
	alpha = 0
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(modifiers["screen-loc"], get_turf(usr))
		T.Click(location, control, params)
	return 1
