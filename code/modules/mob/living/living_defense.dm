/mob/living/proc/run_armor_check(def_zone = null, attack_flag = "melee", absorb_text = null, soften_text = null, armour_penetration, penetrated_text, var/ignore_limit = 0)
	var/armor = getarmor(def_zone, attack_flag)
	armor += src.global_armor[attack_flag]
	//the if "armor" check is because this is used for everything on /living, including humans
	if(armor && armour_penetration)
		armor = max(0, armor - armour_penetration)
		if(penetrated_text)
			src << "<span class='userdanger'>[penetrated_text]</span>"
		else
			src << "<span class='userdanger'>Your armor was penetrated!</span>"

	if(armor >= 100)
		if(absorb_text)
			src << "<span class='userdanger'>[absorb_text]</span>"
		else
			src << "<span class='userdanger'>Your armor absorbs the blow!</span>"
	//else if(armor > 0)
	//	if(soften_text)
	//		src << "<span class='userdanger'>[soften_text]</span>"
	//	else
	//		src << "<span class='userdanger'>Your armor softens the blow!</span>"
	if(!ignore_limit)
		armor = min(90, armor)
	return armor


/mob/living/proc/getarmor(def_zone, type)
	return 0

/mob/living/proc/on_hit(obj/item/projectile/proj_type)
	return
/*
/mob/living/bullet_act(obj/item/projectile/P, def_zone)
	var/armor = run_armor_check(def_zone, P.flag, "","",P.armour_penetration)
	if(!P.nodamage)
		apply_damage(P.damage_add, P.damage_type, def_zone, armor)
	return P.on_hit(src, armor, def_zone)
*/
/proc/vol_by_throwforce_and_or_w_class(obj/item/I)
		if(!I)
				return 0
		if(I.throwforce && I.w_class)
				return Clamp((I.throwforce + I.w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
		else if(I.w_class)
				return Clamp(I.w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
		else
				return 0

/mob/living/hitby(atom/movable/AM, skipcatch, hitpush = 1, blocked = 0)
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		var/zone = ran_zone("chest", 65)//Hits a random part of the body, geared towards the chest
		var/dtype = BRUTE
		var/volume = vol_by_throwforce_and_or_w_class(I)
		if(istype(I,/obj/item/weapon)) //If the item is a weapon...
			var/obj/item/weapon/W = I
			dtype = W.damtype

			if (W.throwforce > 0) //If the weapon's throwforce is greater than zero...
				if (W.throwhitsound) //...and throwhitsound is defined...
					playsound(loc, W.throwhitsound, volume, 1, -1, channel = "regular", time = 10) //...play the weapon's throwhitsound.
				else if(W.hitsound) //Otherwise, if the weapon's hitsound is defined...
					playsound(loc, W.hitsound, volume, 1, -1, channel = "regular", time = 10) //...play the weapon's hitsound.
				else if(!W.throwhitsound) //Otherwise, if throwhitsound isn't defined...
					playsound(loc, 'sound/weapons/genhit.ogg',volume, 1, -1, channel = "regular", time = 10) //...play genhit.ogg.

		else if(!I.throwhitsound && I.throwforce > 0) //Otherwise, if the item doesn't have a throwhitsound and has a throwforce greater than zero...
			playsound(loc, 'sound/weapons/genhit.ogg', volume, 1, -1, channel = "regular", time = 10)//...play genhit.ogg
		if(!I.throwforce)// Otherwise, if the item's throwforce is 0...
			playsound(loc, 'sound/weapons/throwtap.ogg', 1, volume, -1, channel = "regular", time = 10)//...play throwtap.ogg.
		if(!blocked)
			visible_message("<span class='danger'>[src] has been hit by [I].</span>", \
							"<span class='userdanger'>[src] has been hit by [I].</span>")
			var/armor = run_armor_check(zone, "melee", "Your armor has protected your [parse_zone(zone)].", "Your armor has softened hit to your [parse_zone(zone)].",I.armour_penetration)
			apply_damage(I.throwforce, dtype, zone, armor, I)
			if(I.thrownby)
				add_logs(I.thrownby, src, "hit", I)
	else
		playsound(loc, 'sound/weapons/genhit.ogg', 50, 1, -1, channel = "regular", time = 10)
	..()

//Mobs on Fire
/mob/living/proc/IgniteMob()
	if(!on_fire && !wet)
		on_fire = 1
		src.direct_visible_message("<span class='warning'>TARGET catches fire!</span>",
						"<span class='warning'>You're set on fire!</span>",
						"<span class='warning'>TARGET catches fire!</span>",
						"<span class='warning'>You're set on fire!</span>",target = src, span_class = "warning")
		src.add_light_range(3)
//		throw_alert("fire", /obj/screen/alert/fire)
		update_fire()
	else if(wet)
		wet = 0

/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		src.add_light_range(-3)
//		clear_alert("fire")
		update_fire()

/mob/living/proc/handle_fire()
	return

//Share fire evenly between the two mobs
//Called in MobBump() and Crossed()
/mob/living/proc/spreadFire(mob/living/L)
	if(!istype(L))
		return
	var/L_old_on_fire = L.on_fire

	if(on_fire) //Only spread fire stacks if we're on fire
		L.IgniteMob()

	if(L_old_on_fire) //Only ignite us and gain their stacks if they were onfire before we bumped them
		IgniteMob()

//Mobs on Fire end


/mob/living/acid_act(acidpwr, toxpwr, acid_volume)
	take_organ_damage(min(10*toxpwr, acid_volume * toxpwr))

/mob/living/proc/grabbedby(mob/living/carbon/user)
	changeNext_move(CLICK_CD_GRABBING)
	if(user == src || anchored || user == pulling || user.stat)
		return 0
	if(!(status_flags & CANPUSH))
		return 0

	var/def_dice = agi + skills["melee"] - dice6(3)
	var/atack_dice = user.agi + user.skills["melee"] - dice6(3)
	if(rolld(def_dice, atack_dice) && !lying)
		direct_visible_message("<span class='warning'>DOER tried to grab TARGET, but TARGET managed to escape!</span>",\
								"<span class='warning'>DOER tried to grab you, but you managed to escape!</span>",\
								"<span class='warning'>DOER попытался схватить TARGET, но TARGET успел ускользнуть!</span>",\
								"<span class='warning'>DOER попытался схватить тебя, но ты успел ускользнуть!</span>","warning",user,src)
		return 0

	add_logs(user, src, "grabbed", addition="passively")

	if(buckled)
		user << "<span class='warning'>You cannot grab [src], \he is buckled in!</span>"
		return 0
	var/obj/item/weapon/grab/G = new /obj/item/weapon/grab()
	if(!G)	//the grab will delete itself in New if src is anchored
		return 0
	user.put_in_active_hand(G)
	user.pulling = src
	pulledby = user
	if(pulling)
		var/obj/item/weapon/grab/grab = locate() in src
		if(grab)
			qdel(grab)
	direct_visible_message("<span class='warning'>DOER has grabbed TARGET!</span>",\
								"<span class='warning'>DOER has grabbed you!</span>",\
								"<span class='warning'>DOER схватил TARGET!</span>",\
								"<span class='warning'>DOER схватил тебя!</span>","warning",user,src)
//	G.synch()

	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1, channel = "regular", time = 10)

/mob/living/attack_animal(mob/living/simple_animal/M)
	if(M.dice_number == 0)
		M.visible_message("<span class='notice'>\The [M] [M.friendly] [src]!</span>")
		return 0
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1, channel = "regular", time = 10)
		M.do_attack_animation(src)/*, M.attack_type)*/
		visible_message("<span class='danger'>\The [M] [M.attacktext] [src]!</span>", \
						"<span class='userdanger'>\The [M] [M.attacktext] [src]!</span>",\
						"<span class='danger'>[M.name_ru] [M.attacktext_ru] [name_ru]!</span>", \
						"<span class='userdanger'>[M.name_ru] [M.attacktext_ru] [name_ru]!</span>")
		add_logs(M, src, "attacked")
		return 1

/mob/living/incapacitated()
	if(stat || paralysis || stunned || weakened || restrained())
		return 1

//Looking for irradiate()? It's been moved to radiation.dm under the rad_act() for mobs.
