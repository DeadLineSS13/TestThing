GLOBAL_LIST_EMPTY(free_hatches)

/obj/structure/stalker/hatch
	name = "hatch"
	name_ru = "люк"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "luk1"

	var/obj/structure/stalker/ladder/ladder = null

/obj/structure/stalker/hatch/Initialize()
	..()
	GLOB.free_hatches += src

/obj/structure/stalker/hatch/Destroy()
	ladder = null
	GLOB.free_hatches -= src

/obj/structure/stalker/hatch/attack_hand(mob/M)
	if(ladder)
		if(flags & IN_PROGRESS)
			return

		var/turf/stalker/T = M.loc
		if(!T.Exit(M, loc))
			return
		M.Move(loc)
		flags += IN_PROGRESS
		playsound(src, 'sound/effects/ladder4.ogg', extrarange = -3)
		playsound(ladder, 'sound/effects/ladder4.ogg', extrarange = -3)
		if(!do_after(M, 50, 1, src))
			flags &= ~IN_PROGRESS
			return
		M.loc = ladder.loc
		var/area/A = get_area(ladder.loc)
		A.Entered(M)
		flags &= ~IN_PROGRESS
	else
		M << "<span class='notice'>Люк не поддаётся!</span>"

/obj/structure/stalker/hatch/RightClick(mob/user)
	if(!ladder)
		return
	if(!Adjacent(user))
		return
	if(user.client)
		user.set_focus(ladder)
		user.overlay_fullscreen("hatch", /obj/screen/fullscreen/nvg, 2)
		user.screens["fov"].alpha = 0


/obj/structure/stalker/ladder
	name = "ladder"
	name_ru = "лестница"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "ladder"

	var/obj/structure/stalker/hatch/hatch = null

/obj/structure/stalker/ladder/Initialize()
	..()
	spawn(100)
		var/obj/structure/stalker/hatch/H = pick(GLOB.free_hatches)
		if(!H.ladder)
			H.ladder = src
			hatch = H
			GLOB.free_hatches -= H

/obj/structure/stalker/ladder/Destroy()
	hatch = null

/obj/structure/stalker/ladder/attack_hand(mob/M)
	if(hatch)
		if(flags & IN_PROGRESS)
			return

		var/turf/stalker/T = M.loc
		if(!T.Exit(M, loc))
			return
		M.Move(loc)
		flags += IN_PROGRESS
		playsound(src, 'sound/effects/ladder4.ogg', extrarange = -3)
		playsound(hatch, 'sound/effects/ladder4.ogg', extrarange = -3)
		if(!do_after(M, 50, 1, src))
			flags &= ~IN_PROGRESS
			return
		for(var/atom/A in M.loc)
			A.Uncrossed(M)
		M.loc = hatch.loc
		var/area/A = get_area(hatch.loc)
		A.Entered(M)
		flags &= ~IN_PROGRESS

/obj/structure/stalker/ladder/RightClick(mob/user)
	if(!hatch)
		return
	if(!Adjacent(user))
		return
	if(user.client)
		user.set_focus(hatch)
		user.overlay_fullscreen("hatch", /obj/screen/fullscreen/nvg, 2)
		user.screens["fov"].alpha = 0
