/obj/structure/closet/grave
	name = "grave"
	name_ru = "могила"
	desc = ""
	icon = 'icons/stalker/Prishtina/decor.dmi'
	icon_state = "mogila"
	anchored = 1
	opened = 1
	density = 0
	pass_flags = PASSTABLE | PASSGRILLE

/obj/structure/closet/grave/attackby(obj/item/weapon/W, mob/user, params)
	if(flags & IN_PROGRESS)
		return
	if(istype(W, /obj/item/weapon/shovel))
		new /obj/structure/closet/grave(src)
		user.direct_visible_message("<span class='notice'>DOER started to bury the grave..</span>",
									"<span class='notice'>You started to bury the grave...</span>",
									"<span class='notice'>DOER начал закапывать могилу...</span>",
									"<span class='notice'>¬ы начали закапывать могилу...</span>",
									"notice", user)
		flags += IN_PROGRESS
		if(!do_after(user, 300, 1, src))
			flags &= ~IN_PROGRESS
			return

		close()
		flags &= ~IN_PROGRESS
		user.direct_visible_message("<span class='notice'>DOER buried the grave.</span>",
									"<span class='notice'>You buried the grave.</span>",
									"<span class='notice'>DOER закопал могилу.</span>",
									"<span class='notice'>¬ы закопали могилу.</span>",
									"notice", user)

/obj/structure/closet/grave/attack_hand(mob/user)
	return

/obj/structure/closet/grave/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0
	take_contents()

	opened = 0
	density = 1
	update_icon()
	qdel(src)
	return

/obj/structure/closet/grave/can_open()
	return 0

/obj/structure/closet/grave/insert(atom/movable/AM)

	if(contents.len >= storage_capacity)
		return -1

	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(L.buckled || L.buckled_mob || L.mob_size > max_mob_size) //buckled mobs, mobs with another mob attached, and mobs too big for the container don't get inside closets.
			return 0
		if(L.mob_size > MOB_SIZE_TINY) //decently sized mobs take more space than objects.
			var/mobs_stored = 0
			for(var/mob/living/M in contents)
				mobs_stored++
				if(mobs_stored >= mob_storage_capacity)
					return 0
		if(!L.stat)
			L.stat = DEAD
			L.send_to_kyrilka()
/*
		if(L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
			L.client.screen.Cut()
			L.client.screen += L.client.void
			var/mob/new_player/NP = new()
			NP.ckey = L.ckey
		else if(L.last_ckey)
			var/mob/new_player/NP = new()
			NP.ckey = L.last_ckey
*/
		L.stop_pulling()
	else if(!istype(AM, /obj/item))
		return 0
	else if(AM.density || AM.anchored)
		return 0
	else if(AM.flags & NODROP)
		return 0
	if(AM.pulledby)
		AM.pulledby.stop_pulling()
	qdel(AM)
	return 1
