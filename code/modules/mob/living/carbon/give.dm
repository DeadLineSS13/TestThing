/mob/living/carbon/verb/give()
	set category = "IC"
	set name = "Give"
	set src in view(1)
	if(!ishuman(src)||src.stat&(UNCONSCIOUS|DEAD)|| usr.stat&(UNCONSCIOUS|DEAD)|| src.client == null)
		usr << "<span class='warning'>[src.name] can't take anything</span>"
		return
	if(src == usr)
		usr << "<span class='warning'>I feel stupider, suddenly.</span>"
		return
	var/obj/item/I
	if(!usr.get_active_held_item())
		usr << "<span class='warning'>You don't have anything in your hands to give to [src.name]</span>"
		return
	else
		I = usr.get_active_held_item()
	if(!I || I.flags&(ABSTRACT|NODROP))
		return

	if(!get_active_held_item() || !get_inactive_held_item())
		switch(alert(src,"[usr] wants to give you \a [I]?",,"Yes","No"))
			if("Yes")
				if(!I)
					return
				if(!Adjacent(usr))
					usr << "<span class='warning'>You need to stay in reaching distance while giving an object.</span>"
					src << "<span class='warning'>[usr.name] moved too far away.</span>"
					return
				if(usr.get_active_held_item() != I)
					usr << "<span class='warning'>You need to keep the item in your active hand.</span>"
					src << "<span class='warning'>[usr.name] seem to have given up on giving \the [I.name] to you.</span>"
					return
				if(src.handcuffed)
					usr << "<span class='warning'>He is restrained.</span>"
					return
				if(get_active_held_item() && get_inactive_held_item())
					src << "<span class='warning'>Your hands are full.</span>"
					usr << "<span class='warning'>Their hands are full.</span>"
					return
				else
					if(!get_active_held_item())
						put_in_active_hand(I)
						usr.drop_item()
					else if(!get_inactive_held_item())
						put_in_inactive_hand(I)
						usr.drop_item()
					else
						src << "<span class='warning'>You can't take [I.name], so [usr.name] gave up!</span>"
						usr << "<span class='warning'>[src.name] can't take [I.name]!</span>"
						return
				if(istype(I, /obj/item/device/flashlight))
					var/obj/item/device/flashlight/F = I
					if (F.on)
						F.on = 0
						if(F.icon_hands)
							F.icon_state = F.icon_hands
						else
							F.icon_state = initial(F.icon_state)
						F.set_light(0)
				if(istype(I, /obj/item/artefact))
					var/obj/item/artefact/AR = I
					AR.add_effects(src)
				I.loc = src
				I.layer = 20
				I.add_fingerprint(src)
				I.plane = 20
				if(I.icon_hands)
					I.icon_state = I.icon_hands
				src.update_inv_hands()
				usr.update_inv_hands()


				src.direct_visible_message("<span class='notice'>DOER handed \the [I.name] to TARGET.</span>", message_ru = "<span class='notice'>DOER передал [I.name_ru] TARGET.</span>",
											span_class = "notice", doer = usr, target = src)
			if("No")
				src.direct_visible_message("<span class='warning'>DOER tried to hand [I.name] to TARGET but TARGET didn't want it.</span>",
									message_ru = "<span class='warning'>DOER попытался дать [I.name_ru] TARGET, но TARGET отказался.</span>",
									span_class = "notice", doer = usr, target = src)
	else
		usr << "<span class='warning'>[src.name]'s hands are full.</span>"