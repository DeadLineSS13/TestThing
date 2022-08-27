/mob/dead/observer/DblClickOn(var/atom/A, var/params)
	if(client.buildmode)
//		build_click(src, client.buildmode, params, A)
		return
	if(can_reenter_corpse && mind && mind.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return									// seems legit.

	// Things you might plausibly want to follow
	if(istype(A, /mob/living/carbon/human))
//		if(!client.holder)  // Only admin-ghosts can follow mobs
//			return
//		else
		ManualFollow(A)

	// Otherwise jump
//	else if(A.loc)
//		if(!client.holder)  // Only admin-ghosts can travel using doubleclick
//			return
//		else
//			loc = get_turf(A)

/mob/dead/observer/ClickOn(var/atom/A, var/params)
	if(client.buildmode)
//		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"])
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(world.time <= next_move)
		return
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/dead/observer/user)
	if(user.client)
//		if(IsAdminGhost(user))
//			attack_ai(user)
		if(user.client.prefs.inquisitive_ghost)
			user.examinate(src)
	return

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/item/weapon/storage/attack_ghost(mob/user)
	orient2hud(user)
	show_to(user)

// -------------------------------------------
// This was supposed to be used by adminghosts
// I think it is a *terrible* idea
// but I'm leaving it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user as mob)
	if(!user || !user.client || !user.client.holder)
		return
	attack_hand(user)

*/
