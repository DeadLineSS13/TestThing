#define UPGRADE_COOLDOWN	40
#define UPGRADE_KILL_TIMER	100

/obj/item/weapon/grab
	name = "grab"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "reinforce"
	flags = NOBLUDGEON | ABSTRACT
	var/state = GRAB_PASSIVE
	var/mob/owner = null

	var/allow_upgrade = 1
	var/last_upgrade = 0

	layer = 21
	item_state = "nothing"
	w_class = 5


/obj/item/weapon/grab/Initialize()
	..()
	spawn(1)
		if(ismob(loc))
			owner = loc
			if(!owner.pulling || !owner.Adjacent(owner.pulling))
				qdel(src)
				return

/obj/item/weapon/grab/dropped()
	. = ..()
	if(!QDELETED(src))
		qdel(src)

/obj/item/weapon/grab/Destroy()
	if(owner)
		if(ismob(owner.pulling))
			var/mob/M = owner.pulling
			M.pulledby = null
			owner.pulling = null

	..()

/mob/living/CtrlClick(mob/living/carbon/user)
	if(stat && !Adjacent(user))
		return
	grabbedby(user)
/*
/obj/item/weapon/grab/New(mob/living/user, mob/living/victim)
	..()
	loc = user
	assailant = user
	affecting = victim

	if(affecting.anchored || !user.Adjacent(victim))
		qdel(src)
		return

	icon_state = "reinforce"
	name = "reinforce grab"

	affecting.grabbed_by += src

	if(assailant.pulling != affecting)
		assailant.pulled(affecting)


/obj/item/weapon/grab/Destroy()
	if(assailant)
		if(assailant.pulling == affecting)
			assailant.stop_pulling()
		assailant = null
	if(affecting)
		affecting.grabbed_by -= src
		affecting = null

	..()

//Used by throw code to hand over the mob, instead of throwing the grab. The grab is then deleted by the throw code.
/obj/item/weapon/grab/proc/get_mob_if_throwable()
	if(affecting)
		if(affecting.buckled)
			return null
		if(state >= GRAB_AGGRESSIVE)
			return affecting
	return null


//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/weapon/grab/proc/synch()
	return
/*
	if(affecting)
		if(assailant.r_hand == src)
			hud.screen_loc = ui_rhand
		else
			hud.screen_loc = ui_lhand
*/

/obj/item/weapon/grab/process()
	if(!confirm())
		return 0

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 1
		if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.l_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.r_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if(state == GRAB_AGGRESSIVE)
			affecting.drop_all_held_items()
			for(var/obj/item/weapon/grab/G in affecting.grabbed_by)
				if(G == src) continue
				if(G.state == GRAB_AGGRESSIVE)
					allow_upgrade = 0
		if(allow_upgrade)
			icon_state = "reinforce"
		else
			icon_state = "!reinforce"
	else
		if(!affecting.buckled)
			affecting.loc = assailant.loc

	if(state >= GRAB_NECK)
		affecting.Stun(5)	//It will hamper your voice, being choked and all.
		if(isliving(affecting))
			var/mob/living/L = affecting
			L.adjustOxyLoss(1)

	if(state >= GRAB_KILL)
		affecting.Weaken(5)	//Should keep you down unless you get help.
		affecting.losebreath = min(affecting.losebreath + 2, 3)

/obj/item/weapon/grab/attack_self(mob/user)
	s_click()

/obj/item/weapon/grab/proc/s_click(obj/screen/S)
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(world.time < (last_upgrade + UPGRADE_COOLDOWN))
		return
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return

	last_upgrade = world.time

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		if(do_after(assailant, 30, target = affecting))
			assailant.visible_message("<span class='warning'>[assailant] grabs [affecting] aggressively!</span>")
			state = GRAB_AGGRESSIVE
			icon_state = "reinforce"
			assailant.changeNext_move(CLICK_CD_TKSTRANGLE)
		else
			state = GRAB_PASSIVE
	else
		if(state < GRAB_NECK)

			assailant.visible_message("<span class='warning'>[assailant] moves \his grip to [affecting]'s neck!</span>")
			state = GRAB_NECK
			if(!affecting.buckled)
				affecting.loc = assailant.loc
			add_logs(assailant, affecting, "neck-grabbed")
			icon_state = "disarm/kill"
			name = "disarm/kill"
		else
			if(state < GRAB_UPGRADING)
				assailant.visible_message("<span class='danger'>[assailant] starts to tighten \his grip on [affecting]'s neck!</span>")
				icon_state = "disarm/kill1"
				state = GRAB_UPGRADING
				if(do_after(assailant, UPGRADE_KILL_TIMER, target = affecting))
					if(state == GRAB_KILL)
						return
					if(!affecting)
						qdel(src)
						return
					if(!assailant.canmove || assailant.lying)
						qdel(src)
						return
					state = GRAB_KILL
					assailant.visible_message("<span class='danger'>[assailant] tightens \his grip on [affecting]'s neck!</span>")
					add_logs(assailant, affecting, "strangled")

					assailant.changeNext_move(CLICK_CD_TKSTRANGLE)
					affecting.losebreath += 1
				else
					if(assailant)
						assailant.visible_message("<span class='warning'>[assailant] is unable to tighten \his grip on [affecting]'s neck!</span>")
						icon_state = "disarm/kill"
						state = GRAB_NECK


//This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/weapon/grab/proc/confirm()
	if(!assailant || !affecting)
		qdel(src)
		return 0

	if(affecting)
		if(!isturf(assailant.loc) || ( !isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1) )
			qdel(src)
			return 0

	return 1


/obj/item/weapon/grab/attack(mob/M, mob/user)
	if(!affecting)
		return

	if(M == affecting)
		s_click()
		return

	add_logs(user, affecting, "attempted to put", src, "into [M]")

/obj/item/weapon/grab/dropped()
	. = ..()
	if(!QDELETED(src))
		qdel(src)

#undef UPGRADE_COOLDOWN
#undef UPGRADE_KILL_TIMER
*/