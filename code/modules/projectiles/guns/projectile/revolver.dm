/obj/item/weapon/gun/projectile/revolver
	name = "\improper .357 revolver"
	desc = "A suspicious revolver. Uses .357 ammo." //usually used by syndicates
	icon_state = "revolver"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder
	origin_tech = "combat=3;materials=2"
	var/opened = 0

/obj/item/weapon/gun/projectile/revolver/New()
	..()
	if (!magazine)
		magazine = new mag_type(src)
	chamber_round()
	if(!istype(magazine, /obj/item/ammo_box/magazine/internal/cylinder))
		verbs -= /obj/item/weapon/gun/projectile/revolver/verb/spin

/obj/item/weapon/gun/projectile/revolver/chamber_round(var/spin = 1)
	if(spin)
		chambered = magazine.get_round(1)
	else
		chambered = magazine.stored_ammo[1]
	return

/obj/item/weapon/gun/projectile/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round(1)

/obj/item/weapon/gun/projectile/revolver/process_chamber()
	return ..(0, 1)

/obj/item/weapon/gun/projectile/revolver/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return
	if(!opened)
		return
	if(!user.is_holding(src))
		return
	var/num_loaded = magazine.attackby(A, user, params, 0, 0, 1)
	if(num_loaded)
		playsound(user, loadsound, 50, 1, channel = "regular", time = 5)
		//user << "<span class='notice'>You load [num_loaded] shell\s into \the [src].</span>"
		update_icon()
		chamber_round(0)

//	if(unique_rename)
//		if(istype(A, /obj/item/weapon/pen))
//			rename_gun(user)
	update_icon()

/obj/item/weapon/gun/projectile/revolver/attack_self(mob/living/user)
	if(wielded || user.stat)
		return
	if(!opened)
		opened = 1
		playsound(user, opensound, 50, 1, channel = "regular", time = 10)
	else
		opened = 0
		playsound(user, opensound, 50, 1, channel = "regular", time = 10)
	update_icon()
/*
	if(jam)
		jam = 0
		user << user.client.select_lang("<span class='notice'>Оружие снова в норме.</span>", "<span class='notice'>Gun is working again.</span>")
	var/num_unloaded = 0
	chambered = null
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		if(CB)
			CB.loc = get_turf(src.loc)
			CB.SpinAnimation(10, 1)
			CB.update_icon()
			num_unloaded++
	if (num_unloaded)
		user << user.client.select_lang("<span class='notice'>Ты извлекаешь [num_unloaded] патронов из оружия.</span>", "<span class='notice'>You unload [num_unloaded] shell\s from [src].</span>")
	else
		user << user.client.select_lang("<span class='warning'>Внутри пусто.</span>", "<span class='warning'>It's so empty inside.</span>")
*/
/obj/item/weapon/gun/projectile/revolver/attack_hand(mob/user)
	if(!user.is_holding(src))
		return ..()

	if(!opened)
		return ..()

	if(user.restrained() || user.stat || !Adjacent(user))
		return

	var/obj/item/ammo_casing/CB
	for(var/i in magazine.stored_ammo)
		CB = magazine.get_round(0)
		if(!CB)
			var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
			C.rotate()
			continue
		user.put_in_active_hand(CB)
		CB.update_icon()
		chambered = null
		update_icon()
		playsound(user, loadsound, 50, 1, channel = "regular", time = 5)
		return

/obj/item/weapon/gun/projectile/revolver/RightClick(mob/user)
	if(opened)
		if(user.get_active_held_item() == src)
			return
		if(magazine.stored_ammo.len)
			var/obj/item/ammo_casing/CB
			for(var/i in magazine.stored_ammo)
				CB = magazine.get_round(0)
				if(!CB)
					var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
					C.rotate()
					continue
				var/obj/I = user.get_active_held_item()
				if(!I)
					user.put_in_active_hand(CB)
					CB.update_icon()
				else
					if(istype(I, /obj/item/ammo_casing))
						var/obj/item/ammo_casing/AC = I
						if(CB.type != AC.type)
							magazine.stored_ammo.Insert(1,CB)
							continue
						else if(CB.BB && AC.BB && CB.BB.type != AC.BB.type)
							magazine.stored_ammo.Insert(1,CB)
							continue
						else if((CB.BB && !AC.BB) || (!CB.BB && AC.BB))
							magazine.stored_ammo.Insert(1,CB)
							continue
						AC.current_stack++
						AC.weight += CB.weight
						AC.show_count()
						qdel(CB)
				chambered = null
				update_icon()
			playsound(user, loadsound, 50, 1, channel = "regular", time = 5)
		return
	if(flags & TWOHANDED && user.is_holding(src))
		if(wielded)
			unwield(user)
		else
			wield(user)



/obj/item/weapon/gun/projectile/revolver/MouseDrop(atom/over_object)
	if(!opened)
		return

	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return

	if(!istype(over_object, /obj/screen/inventory/hand))
		return

	if(jam)
		jam = 0
		M << "<span class='notice'>Оружие снова в норме.</span>"

	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		if(CB)
			CB.loc = get_turf(src.loc)
			CB.update_icon()
			num_unloaded++
	if (num_unloaded)
		M << M.client.select_lang("<span class='notice'>Ты извлекаешь [num_unloaded] патронов из оружия.</span>", "<span class='notice'>You unload [num_unloaded] shell\s from [src].</span>")
	else
		M << "<span class='warning'>[src] is empty!</span>"

	update_icon()

/obj/item/weapon/gun/projectile/revolver/update_icon()
	..()
	if(opened)
		var/ammo_count = 0
		for(var/i in magazine.stored_ammo)
			if(i != null)
				ammo_count++
		icon_state = "[icon_state]_open-[ammo_count]"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/gun/projectile/revolver/verb/spin()
	set name = "Spin Chamber"
	set category = "Object"
	set desc = "Click to spin your revolver's chamber."

	var/mob/M = usr

	if(M.stat || !in_range(M,src))
		return

	if(istype(magazine, /obj/item/ammo_box/magazine/internal/cylinder))
		var/obj/item/ammo_box/magazine/internal/cylinder/C = magazine
		C.spin()
		chamber_round(0)
		usr.visible_message("[usr] spins [src]'s chamber.", "<span class='notice'>You spin [src]'s chamber.</span>", "[usr] прокручивает барабан револьвера.", "<span class='notice'>Ты прокручиваешь барабан револьвера.</span>")
	else
		verbs -= /obj/item/weapon/gun/projectile/revolver/verb/spin


/obj/item/weapon/gun/projectile/revolver/can_shoot()
	if(opened)
		return 0
	else
		return get_ammo(0,0)

/obj/item/weapon/gun/projectile/revolver/get_ammo(countchambered = 0, countempties = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/*
/obj/item/weapon/gun/projectile/revolver/examine(mob/user)
	..()
	if(opened)
		user << user.client.select_lang("Еще [get_ammo(0,0)] нестрелянных патрончиков.", "[get_ammo(0,0)] of those are live rounds.")*/

/obj/item/weapon/gun/projectile/revolver/detective
	name = "\improper .38 Mars Special"
	desc = "A cheap Martian knock-off of a classic law enforcement firearm. Uses .38-special rounds."
	icon_state = "detective"
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	unique_rename = 1
	unique_reskin = 1

/obj/item/weapon/gun/projectile/revolver/detective/New()
	..()
	options["Default"] = "detective"
	options["Leopard Spots"] = "detective_leopard"
	options["Black Panther"] = "detective_panther"
	options["Gold Trim"] = "detective_gold"
	options["The Peacemaker"] = "detective_peacemaker"
	options["Cancel"] = null

/obj/item/weapon/gun/projectile/revolver/detective/process_fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, message = 1, params, zone_override = "")
	if(magazine.caliber != initial(magazine.caliber))
		if(prob(70 - (magazine.ammo_count() * 10)))	//minimum probability of 10, maximum of 60
			playsound(user, fire_sound, 50, 1, channel = "regular", time = 10)
			user << "<span class='userdanger'>[src] blows up in your face!</span>"
			user.take_organ_damage(0,20)
			user.unEquip(src)
			return 0
	..()

/obj/item/weapon/gun/projectile/revolver/detective/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/weapon/screwdriver))
		if(magazine.caliber == "38")
			user << "<span class='notice'>You begin to reinforce the barrel of [src]...</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//you know the drill
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='userdanger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30/A.toolspeed, target = src))
				if(magazine.ammo_count())
					user << "<span class='warning'>You can't modify it!</span>"
					return
				magazine.caliber = "357"
				desc = "The barrel and chamber assembly seems to have been modified."
				user << "<span class='notice'>You reinforce the barrel of [src]. Now it will fire .357 rounds.</span>"
		else
			user << "<span class='notice'>You begin to revert the modifications to [src]...</span>"
			if(magazine.ammo_count())
				afterattack(user, user)	//and again
				user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='userdanger'>[src] goes off in your face!</span>")
				return
			if(do_after(user, 30/A.toolspeed, target = src))
				if(magazine.ammo_count())
					user << "<span class='warning'>You can't modify it!</span>"
					return
				magazine.caliber = "38"
				desc = initial(desc)
				user << "<span class='notice'>You remove the modifications on [src]. Now it will fire .38 rounds.</span>"


/obj/item/weapon/gun/projectile/revolver/mateba
	name = "\improper Unica 6 auto-revolver"
	desc = "A retro high-powered autorevolver typically used by officers of the New Russia military. Uses .357 ammo."
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/projectile/revolver/golden
	name = "\improper Golden revolver"
	desc = "This ain't no game, ain't never been no show, And I'll gladly gun down the oldest lady you know. Uses .357 ammo."
	icon_state = "goldrevolver"
	fire_sound = 'sound/weapons/resonator_blast.ogg'
	recoil = 8

// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.

/obj/item/weapon/gun/projectile/revolver/russian
	name = "\improper russian revolver"
	desc = "A Russian-made revolver for drinking games. Uses .357 ammo, and has a mechanism requiring you to spin the chamber before each trigger pull."
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/rus357
	var/spun = 0

/obj/item/weapon/gun/projectile/revolver/russian/New()
	..()
	Spin()
	update_icon()

/obj/item/weapon/gun/projectile/revolver/russian/proc/Spin()
	chambered = null
	var/random = rand(1, magazine.max_ammo)
	if(random <= get_ammo(0,0))
		chamber_round()
	spun = 1

/obj/item/weapon/gun/projectile/revolver/russian/attackby(obj/item/A, mob/user, params)
	var/num_loaded = ..()
	if(num_loaded)
		user.visible_message("[user] loads a single bullet into the revolver and spins the chamber.", "<span class='notice'>You load a single bullet into the chamber and spin it.</span>")
	else
		user.visible_message("[user] spins the chamber of the revolver.", "<span class='notice'>You spin the revolver's chamber.</span>")
	if(get_ammo() > 0)
		Spin()
	update_icon()
	A.update_icon()
	return

/obj/item/weapon/gun/projectile/revolver/russian/attack_self(mob/user)
	if(!spun && can_shoot())
		user.visible_message("[user] spins the chamber of the revolver.", "<span class='notice'>You spin the revolver's chamber.</span>")
		Spin()
	else
		var/num_unloaded = 0
		while (get_ammo() > 0)
			var/obj/item/ammo_casing/CB
			CB = magazine.get_round()
			chambered = null
			CB.loc = get_turf(src.loc)
			CB.update_icon()
			num_unloaded++
		if (num_unloaded)
			user << "<span class='notice'>You unload [num_unloaded] shell\s from [src].</span>"
		else
			user << "<span class='notice'>[src] is empty.</span>"

/obj/item/weapon/gun/projectile/revolver/russian/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params)
	if(flag)
		if(!(target in user.contents) && ismob(target))
			if(user.a_intent == "harm") // Flogging action
				return

	if(isliving(user))
		if(!can_trigger_gun(user))
			return
	if(target != user)
		if(ismob(target))
			user << "<span class='warning'>A mechanism prevents you from shooting anyone but yourself!</span>"
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!spun)
			user << "<span class='warning'>You need to spin the revolver's chamber first!</span>"
			return

		spun = 0

		if(chambered)
			var/obj/item/ammo_casing/AC = chambered
			if(AC.fire(user, user))
				playsound(user, fire_sound, 50, 1, channel = "regular", time = 10)
				var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_selected))
				var/limb_name = affecting.getDisplayName()
				if(affecting.name == "head" || affecting.name == "eyes" || affecting.name == "mouth")
					user.apply_damage(300, BRUTE, affecting)
					user.visible_message("<span class='danger'>[user.name] fires [src] at \his head!</span>", "<span class='userdanger'>You fire [src] at your head!</span>", "<span class='italics'>You hear a gunshot!</span>")
				else
					user.visible_message("<span class='danger'>[user.name] cowardly fires [src] at \his [limb_name]!</span>", "<span class='userdanger'>You cowardly fire [src] at your [limb_name]!</span>", "<span class='italics'>You hear a gunshot!</span>")
				return

		user.visible_message("<span class='danger'>*click*</span>")
		playsound(user, 'sound/weapons/empty.ogg', 100, 1, channel = "regular", time = 5)

/////////////////////////////
// DOUBLE BARRELED SHOTGUN //
/////////////////////////////

/obj/item/weapon/gun/projectile/revolver/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "shotgun"
	w_class = 4
	force = 10
	flags = CONDUCT
	slot_flags = SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual
	sawn_desc = "Omar's coming!"
	unique_rename = 1
	unique_reskin = 1

/obj/item/weapon/gun/projectile/revolver/doublebarrel/New()
	..()
	options["Default"] = "dshotgun"
	options["Dark Red Finish"] = "dshotgun-d"
	options["Ash"] = "dshotgun-f"
	options["Faded Grey"] = "dshotgun-g"
	options["Maple"] = "dshotgun-l"
	options["Rosewood"] = "dshotgun-p"
	options["Cancel"] = null

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attack_self(mob/living/user)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.loc = get_turf(src.loc)
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		user << "<span class='notice'>You break open \the [src] and unload [num_unloaded] shell\s.</span>"
	else
		user << "<span class='warning'>[src] is empty!</span>"




// IMPROVISED SHOTGUN //

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised
	name = "improvised shotgun"
	desc = "Essentially a tube that aims shotgun shells."
	icon_state = "ishotgun"
	item_state = "shotgun"
	w_class = 4
	force = 10
	slot_flags = null
	mag_type = /obj/item/ammo_box/magazine/internal/shot/improvised
	sawn_desc = "I'm just here for the gasoline."
	unique_rename = 0
	unique_reskin = 0
	var/slung = 0

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/stack/cable_coil) && !sawn_state)
		var/obj/item/stack/cable_coil/C = A
		if(C.use(10))
			slot_flags = SLOT_BACK
			user << "<span class='notice'>You tie the lengths of cable to the shotgun, making a sling.</span>"
			slung = 1
			update_icon()
		else
			user << "<span class='warning'>You need at least ten lengths of cable if you want to make a sling!</span>"

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/update_icon()
	..()
	if(slung)
		icon_state += "sling"

/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised/sawoff(mob/user)
	. = ..()
	if(. && slung) //sawing off the gun removes the sling
		new /obj/item/stack/cable_coil(get_turf(src), 10)
		slung = 0
		update_icon()
