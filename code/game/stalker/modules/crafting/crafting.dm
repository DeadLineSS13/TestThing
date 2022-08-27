/obj/item/ammo_casing/shotgun/attackby(obj/item/I, mob/user, params)
	..()
	if(BB)
		return
	if(!user.client)
		return
	if(flags & IN_PROGRESS)
		return
	if(!craft_step && istype(I, /obj/item/stalker/crafting/gunpowder))
		var/obj/item/stalker/crafting/gunpowder/GP = I
		if(GP.amount >= powder_need)
			GP.amount -= powder_need
			if(!GP.amount)
				qdel(GP)
			flags += IN_PROGRESS
			if(!do_after(user, 50, 1, src))
				flags &= ~IN_PROGRESS
				return
			user << user.client.select_lang("<span class='notice'>Ты добавил пороха в оболочку.</span>","<span class='notice'>You've added some gunpowder</span>")
			flags &= ~IN_PROGRESS
			craft_step++

	if(craft_step == 1 && istype(I, /obj/item/weapon/stalker/bolt))
		var/obj/item/weapon/stalker/bolt/B = I
		flags += IN_PROGRESS
		if(!do_after(user, 50, 1, src))
			flags &= ~IN_PROGRESS
			return
		user << user.client.select_lang("<span class='notice'>Ты добавил болтов в оболочку.</span>","<span class='notice'>You've added some bolts</span>")
		qdel(B)
		flags &= ~IN_PROGRESS
		BB = new projectile_type(src)
		update_icon()
		craft_step = 0