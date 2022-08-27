#define STATE_PERFECT 4
#define STATE_GOOD 3
#define STATE_WORN 2
#define STATE_BAD 1
#define STATE_BROKEN 0


/obj/item/weapon/gun
	name = "gun"
	icon = 'icons/stalker/items/weapons/projectile.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT
	materials = list(MAT_METAL=2000)
	w_class = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 5
	origin_tech = "combat=1"
	needs_permit = 1
	attack_verb = list("struck", "hit", "bashed")
	ismetal = 1

	var/fire_sound = "gunshot"
	var/suppressed = 0					//whether or not a message is displayed when fired
	var/can_suppress = 0
	var/can_unsuppress = 1
	var/recoil = 0						//boom boom shake the room
	var/clumsy_check = 1
	var/obj/item/ammo_casing/chambered = null
	var/trigger_guard = 1				//trigger guard on the weapon, hulks can't fire them with their big meaty fingers
	var/sawn_desc = null				//description change if weapon is sawn-off
	var/sawn_state = SAWN_INTACT
	var/burst_size = 0					//how large a burst is
	var/fire_delay = 0					//rate of fire for burst firing and semi auto
	var/firing_burst = 0				//Prevent the weapon from firing again while already firing
	var/semicd = 0						//cooldown handler
	var/weapon_weight = WEAPON_LIGHT

	var/spread = 0						//Spread induced by the gun itself.
	var/randomspread = 0				//Set to 0 for shotguns. This is used for weapons that don't fire all their bullets at once.

	var/unique_rename = 0 //allows renaming with a pen
	var/unique_reskin = 0 //allows one-time reskinning
	var/current_skin = null //the skin choice if we had a reskin
	var/list/options = list()

	lefthand_file = 'icons/stalker/items/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/stalker/items/weapons/guns_righthand.dmi'

	var/obj/item/device/flashlight/F = null
	var/can_flashlight = 0

	var/list/upgrades = list()

	var/ammo_x_offset = 0 //used for positioning ammo count overlay on sprite
	var/ammo_y_offset = 0
	var/flight_x_offset = 0
	var/flight_y_offset = 0

	//Zooming
	var/zoomable = FALSE //whether the gun generates a Zoom action on creation
	var/zoomed = FALSE //Zoom toggle
	var/zoom_amt = 3 //Distance in TURFs to move the user's screen forward (the "zoom" effect)
	var/datum/action/toggle_scope_zoom/azoom
	var/can_scope = 0

	///////////////////////STALKER////////////////////////////////

	var/drawsound = 'sound/stalker/weapons/draw/ak74_draw.ogg'
	var/damagelose = 0		 //1 урона за 1 тайл = 0.33 ед
	var/distro = 0			 //Зазор между дробью для дробовиков
	var/jam = 0              //is weapon jammed or not
	var/list/obj/item/weapon/attachment/addons = list()
	var/obj/item/weapon/attachment/gl = null

	var/gun_type = "rifle"			//Тип оружия
	var/accuracy = 4				//Бонус к точности при стрельбе с двух рук
	var/damage_add = 0				//Дополнительный урон при попадании
	var/reliability_add = 0			//Дополнительная надежность оружия
	var/durability_state = STATE_PERFECT
	var/durability = 12

	var/burst_penalty = 1			//Штраф к точности при стрельбе очередью
	var/delay_message = 0

	var/list/l_sounds_shots = list('sound/stalker/weapons/fading/rnd_shooting_1.ogg','sound/stalker/weapons/fading/rnd_shooting_2.ogg',
								'sound/stalker/weapons/fading/rnd_shooting_4.ogg','sound/stalker/weapons/fading/rnd_shooting_5.ogg',
								'sound/stalker/weapons/fading/rnd_shooting_6.ogg','sound/stalker/weapons/fading/rnd_shooting_7.ogg',
								'sound/stalker/weapons/fading/rnd_shooting_9.ogg','sound/stalker/weapons/fading/rnd_shooting_10.ogg',
								'sound/stalker/weapons/fading/rnd_shooting_11.ogg')

/obj/item/weapon/gun/New()
	..()

	rebuild_zooming()


/obj/item/weapon/gun/dropped(mob/user)
	..()
	if(isliving(user))
		var/mob/living/L = user
		L.reset_targeting()


/obj/item/weapon/gun/examine(mob/user)
	..()

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.education == "Military college" || H.profession == "Soldier" || H.trait == "Gun nut")
			switch(durability_state)
				if(STATE_PERFECT)
					user << "<span class='notice'>Почти как новое.</span>"
				if(STATE_GOOD)
					user << "<span class='warning'>Несколько потрепано.</span>"
				if(STATE_WORN)
					user << "<span class='warning'>Серьезно побито.</span>"
				if(STATE_BAD)
					user << "<span class='danger'>Почти металлолом.</span>"

	if(unique_reskin && !current_skin)
		user << "<span class='notice'>Alt-click it to reskin it.</span>"
	if(unique_rename)
		user << "<span class='notice'>Use a pen on it to rename it.</span>"
//	if(pin)
//		user << "It has [pin] installed."
//	else
//		user << "It doesn't have a firing pin installed, and won't fire."


/obj/item/weapon/gun/proc/process_chamber()
	return 0


//check if there's enough ammo/energy/whatever to shoot one time
//i.e if clicking would make it shoot
/obj/item/weapon/gun/proc/can_shoot()
	return 1


/obj/item/weapon/gun/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	user << user.client.select_lang("<span class='danger'>Оружие грустно клацает!</span>","<span class='danger'>Weapon makes an upset click!</span>")
	playsound(user, 'sound/weapons/empty.ogg', 100, 1, channel = "regular", time = 5)
	return


/obj/item/weapon/gun/proc/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)

	var/shot_sound = pick(l_sounds_shots)
	var/turf/epicenter = get_turf(user)

	if(user.light_range < 2)
		var/light_range_old = user.light_range
		user.add_light_range(2 - user.light_range)
		spawn(5)
			if(user)
				user.add_light_range(-2 + light_range_old)

//	if(recoil)
//		shake_camera(user, 2 + recoil * 8, recoil)

	if(suppressed)
		playsound(user, fire_sound, 10, 1, channel = "regular", time = 5)
	else
		playsound(user, fire_sound, 50, 1, channel = "regular", time = 5)
		if(!message)
			return
		if(pointblank)
			user.direct_visible_message("<span class='danger'>DOER makes a point-blank shot on TARGET with [src].</span>",\
								 "<span class='danger'>You pull the trigger, making a point-blank shot on TARGET with your [src]!</span>",\
								 "<span class='danger'>DOER разряжает свой [name_ru] в упор по TARGET.</span>",\
								 "<span class='danger'>Ты вжимаешь спусковой крючок, стреляя в упор по TARGET из [name_ru]!</span>","danger",user,pbtarget)
		else if(burst_size > 1)
			if(!delay_message)
				user.direct_visible_message("<span class='danger'>DOER shoots from his [src].</span>",\
								"<span class='danger'>You shoot from your [src].</span>",\
								"<span class='danger'>DOER выпускает очередь из [name_ru].</span>",\
								"<span class='danger'>Ты выпускаешь очередь из [name_ru].</span>","danger",user)
				delay_message = 1
				spawn(burst_size*2)
					delay_message = 0
		else
			user.direct_visible_message("<span class='danger'>DOER shoots from his [src].</span>",\
								"<span class='danger'>You shoot from your [src].</span>",\
								"<span class='danger'>DOER стреляет из [name_ru].</span>",\
								"<span class='danger'>Ты стреляешь из [name_ru].</span>","danger",user)
		var/frequency = get_rand_frequency()
		for(var/mob/M in range(20))
			if(istype(M, /mob/living/carbon/human/guard))
				GLOB.guards_targets |= user
			// Double check for client
			if(M && M.client)
				var/turf/M_turf = get_turf(M)
				if(M_turf && M_turf.z == epicenter.z)
					var/dist = get_dist(M_turf, epicenter)
					if(dist <= 40 && dist >= 8)
						var/far_volume = Clamp(40, 30, 50) // Volume is based on explosion size and dist
						far_volume += (dist <= 40 * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
						M.playsound_local(epicenter, shot_sound, far_volume, 1, frequency, falloff = 5)

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)


/obj/item/weapon/gun/afterattack(atom/target, mob/living/user, flag, params)

	if(firing_burst)
		return

	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(ismob(target) && user.a_intent == "harm") //melee attack
			return
		if(target == user && user.zone_selected != "mouth") //so we can't shoot ourselves (unless mouth selected)
			return
		if(istype(target, /obj/structure/table))
			return

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

	if(!can_shoot()) //Just because you can pull the trigger doesn't mean it can't shoot.
		shoot_with_empty_chamber(user)
		return

	if(flag && user == target)
		if(user.zone_selected == "mouth")
			handle_suicide(user, target, params)
			return


	//Exclude lasertag guns from the CLUMSY check.
	if(clumsy_check)
		if(istype(user))
			if (user.disabilities & CLUMSY && prob(40))
				user << "<span class='userdanger'>You shoot yourself in the foot with \the [src]!</span>"
				var/shot_leg = pick("l_leg", "r_leg")
				process_fire(user,user,0,params, zone_override = shot_leg, damagelose)
				user.drop_item()
				return

	/*if(weapon_weight == WEAPON_HEAVY && user.get_inactive_held_item())
		user << "<span class='userdanger'>You need both hands free to fire \the [src]!</span>"
		return*/

	process_fire(target, user, 1, params, null, damagelose)


/obj/item/weapon/gun/proc/can_trigger_gun(mob/living/carbon/user)

	if(trigger_guard)
		if(user.has_dna())
			if(user.dna.check_mutation(HULK))
				user << "<span class='warning'>Your meaty finger is much too large for the trigger guard!</span>"
				return 0
			if(NOGUNS in user.dna.species.specflags)
				user << "<span class='warning'>Your fingers don't fit in the trigger guard!</span>"
				return 0
	/*
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.martial_art && H.martial_art.name == "The Sleeping Carp") //great dishonor to famiry
			user << "<span class='warning'>Use of ranged weaponry would bring dishonor to the clan.</span>"
			return 0*/
	return 1


obj/item/weapon/gun/proc/newshot()
	return


/obj/item/weapon/gun/proc/process_fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, message = 1, params, zone_override, damagelose)

	add_fingerprint(user)

	if(semicd)
		return

	if(weapon_weight)
		if(user.get_inactive_held_item())
			recoil = 4 //one-handed kick
		else
			recoil = initial(recoil)

	if(burst_size > 1)
		firing_burst = 1
		spread = spread*5
		for(var/i = 1 to burst_size)
			if(!user)
				break
			if(iscarbon(user))
				if( i>1 && !(user.is_holding(src))) //for burst firing
					break
			if(chambered)
				var/burst_pen
				if(i > 1)
					burst_pen = burst_penalty
				durability_check(user)
				if(!chambered.fire(target, user, params, distro, suppressed, zone_override, burst_pen))
					shoot_with_empty_chamber(user)
					break
				else
					if(!jam)
						if(ismob(target) && get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
							shoot_live_shot(user, 1, target, message)
						else
							shoot_live_shot(user, 0, target, message)
					else
						if(!chambered.fire(target, user, params, distro, suppressed, zone_override, burst_pen))
							shoot_with_empty_chamber(user)
							playsound(user, fire_sound, 50, 1, channel = "regular", time = 5)
							user << user.client.select_lang("<span class='warning'>Оружие заклинило. Надобно перезарядить.</span>","<span class='danger'>Your little gun is jammed. You got to reload it.</span>")
							firing_burst = 0
							burst_penalty = 0
							return
						else
							user << user.client.select_lang("<span class='warning'>Оружие заклинило. Надобно перезарядить.</span>","<span class='danger'>Your little gun is jammed. You got to reload it.</span>")
			else
				shoot_with_empty_chamber(user)
				break
			process_chamber()
			update_icon()
			sleep(fire_delay)

		firing_burst = 0
		spread = initial(spread)

	else
		if(chambered)
			durability_check(user)
			var/sprd = round(rand(-1, 1) * spread)
			if(!chambered.fire(target, user, params, distro, suppressed, zone_override, sprd))
				shoot_with_empty_chamber(user)
				return
			else
				if(!jam)
					if(ismob(target) && get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
						shoot_live_shot(user, 1, target, message)
					else
						shoot_live_shot(user, 0, target, message)
				else
					if(!chambered.fire(target, user, params, distro, suppressed, zone_override, sprd))
						shoot_with_empty_chamber(user)
						playsound(user, fire_sound, 50, 1, channel = "regular", time = 5)
						user << user.client.select_lang("<span class='warning'>Оружие заклинило. Надобно перезарядить.</span>","<span class='danger'>Your little gun is jammed. You got to reload it.</span>")
						return
					else
						user << user.client.select_lang("<span class='warning'>Оружие заклинило. Надобно перезарядить.</span>","<span class='danger'>Your little gun is jammed. You got to reload it.</span>")
		else
			shoot_with_empty_chamber(user)
			return
		process_chamber()
		update_icon()
		semicd = 1
		spawn(fire_delay)
			semicd = 0

	if(user)
		user.update_inv_hands()
		if(burst_size > 1)
			user.reset_targeting(20)
		else
			user.reset_targeting()
	feedback_add_details("gun_fired","[src.type]")

/obj/item/weapon/gun/proc/durability_check(mob/user)   //Gun durability
	if(!jam)
		switch(durability_state)
			if(STATE_BROKEN)
				shake_camera(user, 4, 2)
				explosion(src.loc,-2,-2,2,flame_range = 0)
				qdel(src)
				src = null
				user << "<span class='userdanger'>Оружие разорвалось прямо у вас в руках!</span>"

			if(STATE_BAD)
				if(dice6(3) >= 17+reliability_add)
					shake_camera(user, 4, 2)
					explosion(src.loc,-2,-2,2,flame_range = 0)
					qdel(src)
					src = null
					user << user.client.select_lang("<span class='warning'>Оружие кончилось...</span>","<span class='danger'>Your gun's over...</span>")
					return
				else
					if(dice6(3) >= 15+reliability_add)
						jam = 1
						durability_state--

			if(STATE_WORN)
				if(dice6(3) >= 16+reliability_add)
					user.drop_item()
					shake_camera(user, 4, 2)
					user << user.client.select_lang("<span class='warning'>Этот хлам едва работает.</span>","<span class='danger'>This crap is barely working.</span>")
					jam = 1
					durability_state--

			if(STATE_GOOD)
				if(dice6(3) >= 17+reliability_add)
					jam = 1
					durability_state--

			if(STATE_PERFECT)
				if(dice6(3) >= 18+reliability_add)
					jam = 1
					durability_state--
	else if(jam)
		return

/obj/item/weapon/gun/attack(mob/M as mob, mob/user)
	if(user.a_intent == "harm") //Flogging
		..()
	else
		return

/obj/item/weapon/gun/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/device/flashlight/seclite))
		var/obj/item/device/flashlight/seclite/S = A
		if(can_flashlight)
			if(!F)
				if(!user.unEquip(A))
					return
				user << "<span class='notice'>You click [S] into place on [src].</span>"
				if(S.on)
					set_light(0)
				F = S
				A.loc = src
				update_icon()
				update_gunlight(user)
				verbs += /obj/item/weapon/gun/proc/toggle_gunlight

	if(istype(A, /obj/item/weapon/screwdriver))
		if(F && can_flashlight)
			for(var/obj/item/device/flashlight/seclite/S in src)
				user << "<span class='notice'>You unscrew the seclite from [src].</span>"
				F = null
				S.loc = get_turf(user)
				update_gunlight(user)
				S.update_brightness(user)
				update_icon()
				verbs -= /obj/item/weapon/gun/proc/toggle_gunlight

//	if(unique_rename)
//		if(istype(A, /obj/item/weapon/pen))
//			rename_gun(user)
	..()

/obj/item/weapon/gun/proc/toggle_gunlight()
	set name = "Toggle Gunlight"
	set category = "Object"
	set desc = "Click to toggle your weapon's attached flashlight."

	if(!F)
		return

	var/mob/living/carbon/human/user = usr
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot turn the light on while in this [user.loc]!</span>"
	F.on = !F.on
	user << "<span class='notice'>You toggle the gunlight [F.on ? "on":"off"].</span>"

	playsound(user, 'sound/weapons/empty.ogg', 100, 1, channel = "regular", time = 5)
	update_gunlight(user)
	return

/obj/item/weapon/gun/proc/update_gunlight(mob/user = null)
	if(F)
//		action_button_name = "Toggle Gunlight"
		if(F.on)
			if(loc == user)
				user.add_light_range(F.brightness_on)
			else if(isturf(loc))
				set_light(F.brightness_on)
		else
			if(loc == user)
				user.add_light_range(-F.brightness_on)
			else if(isturf(loc))
				set_light(0)
		update_icon()
	else
//		action_button_name = null
		if(loc == user)
			user.add_light_range(-5)
		else if(isturf(loc))
			set_light(0)
		return

/obj/item/weapon/gun/pickup(mob/user)
	if(F)
		if(F.on)
			user.add_light_range(F.brightness_on)
			set_light(0)
	if(azoom)
		azoom.Grant(user)

/obj/item/weapon/gun/dropped(mob/user)
	. = ..()
	if(F)
		if(F.on)
			user.add_light_range(-F.brightness_on)
			set_light(F.brightness_on)
	zoom(user,FALSE)
	if(azoom)
		azoom.Remove(user)


/obj/item/weapon/gun/AltClick(mob/user)
	..()
	if(user.incapacitated())
		user << "<span class='warning'>Ain't working.</span>"
		return
	if(unique_reskin && !current_skin && loc == user)
		reskin_gun(user)


/obj/item/weapon/gun/proc/reskin_gun(mob/M)
	var/choice = input(M,"Warning, you can only reskin your weapon once!","Reskin Gun") in options

	if(src && choice && !M.stat && in_range(M,src) && !M.restrained() && M.canmove)
		if(options[choice] == null)
			return
		if(sawn_state == SAWN_OFF)
			icon_state = options[choice] + "-sawn"
		else
			icon_state = options[choice]
		M << "Your gun is now skinned as [choice]. Say hello to your new friend."
		current_skin = 1
		return

/obj/item/weapon/gun/proc/rename_gun(mob/M)
	var/input = sanitize_russian(stripped_input(M,"What do you want to name the gun?", ,"", MAX_NAME_LEN))

	if(src && input && !M.stat && in_range(M,src) && !M.restrained() && M.canmove)
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		return


/obj/item/weapon/gun/proc/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params)
	if(!ishuman(user) || !ishuman(target))
		return

	if(semicd)
		return

	if(user == target)
		target.visible_message("<span class='warning'>[user] sticks [src] in their mouth, ready to pull the trigger...</span>", \
			"<span class='userdanger'>You decide that this is the time to end your miserable life, so you stick [src] between your teeth.</span>", \
			"<span class='warning'>[user] засовывает ствол [name_ru] меж своих зубов.</span>", \
			"<span class='userdanger'>Ты решаешь, что с тебя достаточно, и пропихиваешь ствол [name_ru] меж своих зубов.</span>")
	else
		target.visible_message("<span class='warning'>[user] points [src] at [target]'s head, ready to pull the trigger...</span>", \
			"<span class='userdanger'>[user] points [src] at your head, ready to blow your brains out for good.</span>", \
			"<span class='warning'>[user] приставляет [name_ru] к виску [target].</span>", \
			"<span class='userdanger'>[user] приставляет [name_ru] к твоему виску.</span>")

	semicd = 1

	if(!do_mob(user, target, 120) || user.zone_selected != "mouth")
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] decided to live a little more.</span>", message_ru = "<span class='notice'>[user] решил пожить еще немного.</span>", self_message_ru = "<span class='notice'>Ты решил пожить еще немного.</span>")
			else if(target && target.Adjacent(user))
				target.visible_message("<span class='notice'>[user] couldn't make himself shoot [target].</span>", "<span class='notice'>[user] was merciful enough to decide not to shoot you.</span>", "<span class='notice'>[user] опускает оружие, оставив [target] в живых.</span>", "<span class='notice'>[user] сжалился над тобой.</span>")
		semicd = 0
		return

	semicd = 0

	if(!can_trigger_gun(user))
		return

	target.visible_message("<span class='warning'>[user] maliciously pulls the trigger!</span>", "<span class='userdanger'>[user] maliciously pulls the trigger!</span>", "<span class='warning'>[user] вжимает спусковой крючок!</span>", "<span class='userdanger'>[user] вжимает спусковой крючок!</span>")

	if(chambered && chambered.BB)
		chambered.BB.damage_add += 100

	process_fire(target, user, 1, params)


/////////////
// ZOOMING //
/////////////

/datum/action/toggle_scope_zoom
	name = "Toggle Scope"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING
	button_icon_state = "sniper_zoom"
	var/obj/item/weapon/gun/gun = null

/datum/action/toggle_scope_zoom/Trigger()
	gun.zoom(owner)

/datum/action/toggle_scope_zoom/IsAvailable()
	. = ..()
	if(!. && gun)
		gun.zoom(owner, FALSE)

/datum/action/toggle_scope_zoom/Remove(mob/living/L)
	gun.zoom(L, FALSE)
	..()
/*
/datum/action/toggle_scope_zoom/Checks()
	. = ..()

	if(owner.get_active_held_item() != gun)
		return 0

	return .
*/
/obj/item/weapon/gun/proc/zoom(mob/living/user, forced_zoom)
	if(!user || !user.client)
		return

	switch(forced_zoom)
		if(FALSE)
			zoomed = FALSE
		if(TRUE)
			zoomed = TRUE
		else
			zoomed = !zoomed

	if(zoomed)
		var/_x = 0
		var/_y = 0
		switch(user.dir)
			if(NORTH)
				_y = zoom_amt
			if(EAST)
				_x = zoom_amt
			if(SOUTH)
				_y = -zoom_amt
			if(WEST)
				_x = -zoom_amt

		user.client.pixel_x = world.icon_size*_x
		user.client.pixel_y = world.icon_size*_y
	else
		user.client.pixel_x = 0
		user.client.pixel_y = 0


//Proc, so that gun accessories/scopes/etc. can easily add zooming.
/obj/item/weapon/gun/proc/rebuild_zooming()
	if(azoom)
		if(!zoomable)
			zoom_amt = initial(zoom_amt)
			zoom(usr, FALSE)
			azoom = null
		return

	if(zoomable)
		for(var/obj/item/weapon/attachment/scope/S in addons)
			zoom_amt += S.zoom_add
		azoom = new()
		azoom.gun = src

/*
/mob/living/RightClickOn(atom/A)
	if(!istype(A, /mob/living))
		return ..()

	var/obj/item/weapon/gun/G = get_active_held_item()
	if(!istype(G, /obj/item/weapon/gun))
		return ..()

	var/mob/living/L = A
	if(L.client)
		var/mob_name = src.name
		if(L.clients_names[src])
			mob_name = L.clients_names[src]
		L << L.client.select_lang("<span class='danger'>[mob_name] угрожающе направляет ствол оружия на тебя!</span>",\
								"<span class='danger'>[mob_name] threateningly points a weapon at you!</span>")
*/