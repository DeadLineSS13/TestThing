var/list/image/ghost_darkness_images = list() //this is a list of images for things ghosts should still be able to see when they toggle darkness
/mob/dead/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = MOB_LAYER + 1
	stat = DEAD
	density = 0
	canmove = 1
	anchored = 1	//  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER
	languages = ALL
	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/atom/movable/following = null
	var/fun_verbs = 0
	var/image/ghostimage = null //this mobs ghost image, for deleting and stuff
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/seedarkness = 1
	var/ghost_hud_enabled = 1 //did this ghost disable the on-screen HUD?
	var/data_hud_seen = 0 //this should one of the defines in __DEFINES/hud.dm
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/base_mob = null
	var/base_turf = null

/mob/dead/observer/New(mob/body, can_reenter = 1)
	if(body)
		if(body.client && body.client.holder)
			sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	else
		sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	verbs += /mob/dead/observer/proc/dead_tele
	stat = DEAD
	if(!can_reenter)
		add_client_colour(/datum/client_colour/full_black)

	ghostimage = image(src.icon,src,src.icon_state)
	ghost_darkness_images |= ghostimage
	updateallghostimages()
	var/turf/T
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost
		clients_names = body.clients_names.Copy()
		clients_names[src] = clients_names[body]

		gender = body.gender
		base_mob = body
		base_turf = T
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				name = random_unique_name(gender)

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.
	else
		base_turf = get_turf(loc)

	if(!T)
		if(GLOB.latejoin.len)
			T = pick(GLOB.latejoin)			//Safety in case we cannot find the body's position
		T = locate(1, 1, 1)
		base_turf = T
	loc = T


	if(!name)							//To prevent nameless ghosts
		name = random_unique_name(gender)
	else
		real_name = name

	if(!fun_verbs)
		verbs -= /mob/dead/observer/verb/boo
		verbs -= /mob/dead/observer/verb/possess

	animate(src, pixel_y = 2, time = 10, loop = -1)
	spawn(1)
//		set_focus(src)
//		if(SSinput.initialized && client)
//			client.set_macros()
		if(!client.holder)
			verbs -= /mob/dead/observer/verb/toggle_darkness

	..()

/mob/dead/observer/Destroy()
	if (ghostimage)
		ghost_darkness_images -= ghostimage
		qdel(ghostimage)
		ghostimage = null
		updateallghostimages()
	return ..()

/mob/dead/CanPass(atom/movable/mover, turf/target, height=0)
	return 1

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/proc/ghostize(can_reenter_corpse = 1)
	if(key)
		if(!cmptext(copytext(key,1,2),"@")) // Skip aghosts.
			if(can_reenter_corpse && timeofdeath + 150 > world.time)
				src << "You must wait 15 seconds before you can ghost!"
				return 0
			var/mob/dead/observer/ghost = new(src, can_reenter_corpse)	// Transfer safety to observer spawning proc.
			SStgui.on_transfer(src, ghost) // Transfer NanoUIs.
			ghost.can_reenter_corpse = can_reenter_corpse
			ghost.key = key
//			ghost.client.show_popup_menus = 0
			ghost.timeofdeath = timeofdeath

			return ghost

/mob/living/carbon/human/ghostize()
	if(softdead)
		switch(alert("You still can be revived! Do you really want to leave your body?",,"Yes", "No"))
			if("Yes")
				softdead = 0
				return ..()
			if("No")
				return 0

	return ..()
/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/

/*
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat != DEAD)
		succumb()
	if(stat == DEAD)
		ghostize(1)
	else
		var/response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost whilst still alive you may not play again this round! You can't change your mind so choose wisely!!)","Are you sure you want to ghost?","Ghost","Stay in body")
		if(response != "Ghost")	return	//didn't want to ghost after-all
		src.timeofdeath = world.time
		ghostize(0)						//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
	return
*/

/mob/dead/observer/Move(NewLoc, direct)
	if(following && NewLoc != following.loc)
		following = null
		if(!client.holder)
			if(base_mob)
				loc = get_turf(base_mob)
			else if(base_turf)
				loc = base_turf
			return

//	if(updatedir)
//		setDir(direct )//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own

	if(client.holder)
		if(NewLoc)
			loc = NewLoc
			for(var/obj/effect/step_trigger/S in NewLoc)
				S.Crossed(src)

			return
		loc = get_turf(src) //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

		for(var/obj/effect/step_trigger/S in NewLoc)	//<-- this is dumb
			S.Crossed(src)
	else if(!following)
		if(world.time < client.move_delay)
			return 0

		client.move_delay = world.time + 3

		if(base_mob)
			var/mob_dist = get_dist(base_mob, src)
			var/newloc_dist = get_dist(base_mob, NewLoc)
			if(mob_dist > 6 && mob_dist < newloc_dist)
				src << client.select_lang("“ы не можешь отлететь более чем на 7 тайлов от своего персонажа.","You can only move 7 tiles from human.")
				return 0
		else if(base_turf)
			var/turf_dist = get_dist(base_turf, src)
			var/newloc_dist = get_dist(base_turf, NewLoc)
			if(turf_dist > 6 && turf_dist < newloc_dist)
				src << client.select_lang("“ы не можешь отлететь более чем на 7 тайлов от своего места смерти.","You can only move 7 tiles from place of death.")
				return 0


		..()

/*
/mob/dead/observer/proc/ManualFollow(var/atom/movable/target)
	if(target && target != src)
		if(following && following == target)
			return
		following = target
		src << "\blue Now following [target]"
		spawn(0)
			while(target && following == target && client)
				var/turf/T = get_turf(target)
				if(!T)
					break
				if(loc != T)
					loc = T
				sleep(5)
*/
/mob/dead/observer/is_active()
	//return 0

/mob/dead/observer/Stat()
	..()

/mob/dead/observer/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"
	if(!client)	return
	if(!(mind && mind.current))
		src << "<span class='warning'>You have no body.</span>"
		return
	if(!can_reenter_corpse)
		src << "<span class='warning'>You cannot re-enter your body.</span>"
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		usr << "<span class='warning'>Another consciousness is in your body...It is resisting you.</span>"
		return
	SStgui.on_transfer(src, mind.current) // Transfer NanoUIs.
	mind.current.key = key
	return 1

/mob/dead/observer/proc/notify_cloning(var/message, var/sound, var/atom/source)
	if(message)
		src << "<span class='ghostalert'>[message]</span>"
		if(source)
			var/obj/screen/alert/A = throw_alert("\ref[source]_notify_cloning", /obj/screen/alert/notify_cloning)
			if(A)
				A.desc = message
				var/old_layer = source.layer
				source.layer = FLOAT_LAYER
				A.overlays += source
				source.layer = old_layer
	src << "<span class='ghostalert'><a href=?src=\ref[src];reenter=1>(Click to re-enter)</a></span>"
	if(sound)
		src << sound(sound)

/mob/dead/observer/proc/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"
	if(!istype(usr, /mob/dead/observer))
		usr << "Not when you're not dead!"
		return
	//if(!(client && client.holder))
	//	usr << "No."
		return
	usr.verbs -= /mob/dead/observer/proc/dead_tele
	spawn(30)
		usr.verbs += /mob/dead/observer/proc/dead_tele
	var/A
	A = input("Area to jump to", "BOOYEA", A) as null|anything in GLOB.sortedAreas
	var/area/thearea = A
	if(!thearea)	return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		L+=T

	if(!L || !L.len)
		usr << "No area available."

	usr.loc = pick(L)

/mob/dead/observer/proc/follow()
	var/list/mobs = getpois(skip_mindless=1)
	var/input = input("Please, select a mob!", "Haunt", null, null) as null|anything in mobs
	var/mob/target = mobs[input]

	//if (!(client && client.holder))
	//	return
	ManualFollow(target)

// This is the ghost's follow verb with an argument
/mob/dead/observer/proc/ManualFollow(atom/movable/target)
	if(!target)
		return
	if(target != src)
		if(following && following == target)
			return
		following = target

	var/icon/I = icon(target.icon,target.icon_state,target.dir)

	var/orbitsize = (I.Width()+I.Height())*0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

	if(orbiting != target)
		src << "<span class='notice'>Now orbiting [target].</span>"

	var/rot_seg

	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36 //360/10 bby, smooth enough aproximation of a circle

	orbit(target,orbitsize, FALSE, 20, rot_seg)

/mob/dead/observer/orbit()
	..()
	//restart our floating animation after orbit is done.
	sleep 2  //orbit sets up a 2ds animation when it finishes, so we wait for that to end
	if (!orbiting) //make sure another orbit hasn't started
		pixel_y = 0
		animate(src, pixel_y = 2, time = 10, loop = -1)

/mob/dead/observer/proc/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak

	if(istype(usr, /mob/dead/observer)) //Make sure they're an observer!
		//if (!(client && client.holder))
		//	return

		var/list/dest = list() //List of possible destinations (mobs)
		var/target = null	   //Chosen target.

		dest += getpois(mobs_only=1) //Fill list, prompt user with list
		target = input("Please, select a player!", "Jump to Mob", null, null) as null|anything in dest

		if (!target)//Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] //Destination mob
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(M) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.loc = T
			else
				A << "This mob is not located in the game world."

/mob/dead/observer/verb/boo()
	set category = "Ghost"
	set name = "Boo!"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time) return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return

/*
/mob/dead/observer/memory()
	set hidden = 1
	src << "<span class='danger'>You are dead! You have no mind to store memory!</span>"
*/
//mob/dead/observer/add_memory()
//	set hidden = 1
//	src << "<span class='danger'>You are dead! You have no mind to store memory!</span>"

/mob/dead/observer/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost"
	ghostvision = !(ghostvision)
	updateghostsight()
	usr << "You [(ghostvision?"now":"no longer")] have ghost vision."

/mob/dead/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"
	seedarkness = !(seedarkness)
	updateghostsight()

/mob/dead/observer/proc/updateghostsight()
	if (!seedarkness)
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING
	else
		see_invisible = SEE_INVISIBLE_OBSERVER
		if (!ghostvision)
			see_invisible = SEE_INVISIBLE_LIVING;
	updateghostimages()

/proc/updateallghostimages()
	for (var/mob/dead/observer/O in GLOB.player_list)
		O.updateghostimages()

/mob/dead/observer/proc/updateghostimages()
	if (!client)
		return
	if (seedarkness || !ghostvision)
		client.images -= ghost_darkness_images
	else
		//add images for the 60inv things ghosts can normally see when darkness is enabled so they can see them now
		client.images |= ghost_darkness_images
		if (ghostimage)
			client.images -= ghostimage //remove ourself

/mob/dead/observer/verb/possess()
	set category = "Ghost"
	set name = "Possess!"
	set desc= "Take over the body of a mindless creature!"

	var/list/possessible = list()
	for(var/mob/living/L in GLOB.living_mob_list)
		if(!(L in GLOB.player_list) && !L.mind)
			possessible += L

	var/mob/living/target = input("Your new life begins today!", "Possess Mob", null, null) as null|anything in possessible

	if(!target)
		return 0
	if(can_reenter_corpse || (mind && mind.current))
		if(alert(src, "Your soul is still tied to your former life as [mind.current.name], if you go foward there is no going back to that life. Are you sure you wish to continue?", "Move On", "Yes", "No") == "No")
			return 0
	if(target.key)
		src << "<span class='warning'>Someone has taken this body while you were choosing!</span>"
		return 0

	target.key = key
	return 1

/mob/dead/observer/Life()
	set invisibility = 0

	if(!src.client)
		return

	handle_sounds()

//this is a mob verb instead of atom for performance reasons
//see /mob/verb/examinate() in mob.dm for more info
//overriden here and in /mob/living for different point span classes and sanity checks
/mob/dead/observer/pointed(atom/A as mob|obj|turf in view())
	if(!..())
		return 0
	usr.direct_visible_message("<span class='deadsay'><b>[src]</b> points to [A].</span>",
							"<span class='deadsay'><b>[src]</b> points to [A].</span>",
							"<span class='deadsay'><b>[src]</b> показывает на [A].</span>",
							"<span class='deadsay'><b>[src]</b> показывает на [A].</span>",
							"deadsay",src,A)
	return 1

/mob/dead/observer/verb/view_manifest()
	set name = "View Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += GLOB.data_core.get_manifest()

	src << browse(dat, "window=manifest;size=387x420;can_close=1")

//this is called when a ghost is drag clicked to something.
/mob/dead/observer/MouseDrop(atom/over)
	if(!usr || !over) return
	if (isobserver(usr) && usr.client.holder && isliving(over))
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()

/mob/dead/observer/Topic(href, href_list)
	..()
	if(usr == src)
		if(href_list["follow"])
			var/atom/movable/target = locate(href_list["follow"])
			if(istype(target) && (target != src))
				ManualFollow(target)
		if(href_list["reenter"])
			reenter_corpse()

//We don't want to update the current var
//But we will still carry a mind.
/mob/dead/observer/mind_initialize()
	return
/*
/mob/dead/observer/proc/show_me_the_hud(hud_index)
	var/datum/atom_hud/H = huds[hud_index]
	H.add_hud_to(src)
	data_hud_seen = hud_index

/mob/dead/observer/verb/toggle_ghost_med_sec_diag_hud()
	set name = "Toggle Sec/Med/Diag HUD"
	set desc = "Toggles whether you see medical/security/diagnostic HUDs"
	set category = "Ghost"

	if(data_hud_seen) //remove old huds
		var/datum/atom_hud/H = huds[data_hud_seen]
		H.remove_hud_from(src)

	switch(data_hud_seen) //give new huds
		if(0)
			show_me_the_hud(DATA_HUD_SECURITY_BASIC)
			src << "<span class='notice'>Security HUD set.</span>"
		if(DATA_HUD_SECURITY_BASIC)
			show_me_the_hud(DATA_HUD_MEDICAL_ADVANCED)
			src << "<span class='notice'>Medical HUD set.</span>"
		if(DATA_HUD_MEDICAL_ADVANCED)
			show_me_the_hud(DATA_HUD_DIAGNOSTIC)
			src << "<span class='notice'>Diagnostic HUD set.</span>"
		if(DATA_HUD_DIAGNOSTIC)
			data_hud_seen = 0
			src << "<span class='notice'>HUDs disabled.</span>"
*/
/mob/dead/observer/canUseTopic()
	if(check_rights(R_ADMIN, 0))
		return 1
	return