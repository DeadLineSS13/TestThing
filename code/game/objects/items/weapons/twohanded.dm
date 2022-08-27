/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 *		Spears
 *		CHAINSAWS
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.




/*
 * Twohanded
 */
/obj/item/weapon
	var/wielded = 0
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null
	var/str_need = 0

/obj/item/weapon/proc/unwield(mob/living/carbon/user)
	if(!wielded || !user)
		return
	if(user.stat)
		return
	if(!(flags & TWOHANDED))
		return

	wielded = 0

	if(force_unwielded)
		force = force_unwielded
//	var/sf = findtext(name,"")
//	if(sf)
//		name = copytext(name,1,sf)
//	else //something wrong
//		name = "[initial(name)]"
	name = initial(name)
	update_icon()
	if(istype(src, /obj/item/weapon/twohanded/offhand))
		user << user.client.select_lang("<span class='notice'>Ты выпускаешь из рук [name_ru].</span>", "<span class='notice'>You drop \the [name].</span>")
	if(unwieldsound)
		playsound(loc, unwieldsound, 50, 1, channel = "regular", time = 10)
	var/obj/item/weapon/twohanded/offhand/O = user.get_inactive_held_item()
	if(O && istype(O))
		O.unwield()
		user << user.client.select_lang("<span class='notice'>Ты выпускаешь из рук [name_ru].</span>", "<span class='notice'>You drop \the [name].</span>")
	return

/obj/item/weapon/proc/wield(mob/user)
	if(user.stat)
		return
	if(wielded)
		return
	if(!(flags & TWOHANDED))
		return
	if(user.get_inactive_held_item())
		if(user.get_active_held_item())
			user << user.client.select_lang("<span class='warning'>Мои руки ЗАНЯТЫ.</span>", "<span class='warning'>My hands are BUSY.</span>")
			return
	if(!user.has_hand_for_held_index(user.get_inactive_hand_index()))
		user << user.client.select_lang("<span class='warning'>Моя вторая рука меня не слушается!</span>","<span class='warning'>My other hand is bad</span>")
		return
	wielded = 1
	if(force_wielded)
		force = force_wielded
	//name = "[name] (Wielded)"
	update_icon()
	if(user.client)
		user << user.client.select_lang("<span class='notice'>Ты хватаешь [name_ru] двумя руками.</span>", "<span class='notice'>You are now carrying the [name] with two hands.</span>")
	if (wieldsound)
		playsound(loc, wieldsound, 50, 1, channel = "regular", time = 10)
	var/obj/item/weapon/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name]"
	O.name_ru = "[name_ru]"
	O.desc = "Your second grip on the [name]"
	O.desc_ru = "Держу [name_ru] второй ручкой."
	O.weight = 0
	if(!user.get_inactive_held_item())
		user.put_in_inactive_hand(O)
	else
		user.put_in_active_hand(O)
		user.swap_hand()
	return

/obj/item/weapon/mob_can_equip(mob/M, slot)
	//Cannot equip wielded items.
//	if(wielded)
//		M << M.client.select_lang("<span class='notice'>Сначала бы ОСВОБОДИТЬ РУКУ.</span>", "<span class='notice'>I have to EMPTY MY HAND.</span>")
//		return 0
	unwield(M)
	return ..()

/obj/item/weapon/dropped(mob/user)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(!(flags & TWOHANDED))
		return ..()
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_held_item()
		if(istype(O))
			O.unwield(user)
	unwield(user)

	..()

/obj/item/weapon/attack_self(mob/user)
	if(!(flags & TWOHANDED))
		return ..()

	if(wielded) //Trying to unwield it
		unwield(user)
	else //Trying to wield it
		wield(user)

///////////OFFHAND///////////////
/obj/item/weapon/twohanded/offhand
	name = "offhand"
	name_ru = "ухват"
	icon_state = "offhand"
	w_class = 5
	flags = ABSTRACT | TWOHANDED

/obj/item/weapon/twohanded/offhand/dropped(mob/user)
	var/obj/item/weapon/main_hand = user.get_inactive_held_item()
	if(main_hand)
		main_hand.unwield(user)
		main_hand.update_icon()

	..()

/obj/item/weapon/twohanded/offhand/unwield()
	if(!QDELING(src))
		qdel(src)

/obj/item/weapon/twohanded/offhand/wield()
	if(!QDELING(src))
		qdel(src)

/obj/item/weapon/twohanded/offhand/hit_reaction()//if the actual twohanded weapon is a shield, we count as a shield too!
	var/mob/user = loc
	if(!istype(user))
		return 0
	var/obj/item/I = user.get_active_held_item()
	if(I == src)
		I = user.get_inactive_held_item()
	if(!I)
		return 0
	return I.hit_reaction()

///////////Two hand required objects///////////////
//This is for objects that require two hands to even pick up
/obj/item/weapon/twohanded/required/
	w_class = 5

/obj/item/weapon/twohanded/required/attack_self()
	return

/obj/item/weapon/twohanded/required/mob_can_equip(mob/M, slot)
	if(wielded)
		M << "<span class='warning'>\The [src] is too cumbersome to carry with anything but your hands!</span>"
		return 0
	return ..()

/obj/item/weapon/twohanded/required/attack_hand(mob/user)//Can't even pick it up without both hands empty
	var/obj/item/weapon/twohanded/required/H = user.get_inactive_held_item()
	if(get_dist(src,user) > 1)
		return 0
	if(H != null)
		user << "<span class='notice'>\The [src] is too cumbersome to carry in one hand!</span>"
		return
	wield(user)
	..()


/obj/item/weapon/twohanded/

/*
 * Fireaxe
 */
/obj/item/weapon/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	force = 5
	throwforce = 15
	w_class = 4
	slot_flags = SLOT_BACK
	force_unwielded = 5
	force_wielded = 24 // Was 18, Buffed - RobRichards/RR
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = IS_SHARP

/obj/item/weapon/twohanded/fireaxe/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "fireaxe[wielded]"
	return

/obj/item/weapon/twohanded/fireaxe/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] axes \himself from head to toe! It looks like \he's trying to commit suicide..</span>")
	return (BRUTELOSS)

/obj/item/weapon/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	if(!proximity) return
	if(wielded) //destroys windows and grilles in one hit
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.spawnfragments() // this will qdel and spawn shards
		else if(istype(A,/obj/structure/grille))
			var/obj/structure/grille/G = A
			G.health = -6
			G.destroyed += prob(25) // If this is set, healthcheck will completely remove the grille
			G.healthcheck()


/*
 * Double-Bladed Energy Swords - Cheridan
 */
/obj/item/weapon/twohanded/dualsaber
	icon_state = "dualsaber0"
	name = "double-bladed energy sword"
	desc = "Handle with care."
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = 2
	force_unwielded = 3
	force_wielded = 34
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	hitsound = "swing_hit"
	armour_penetration = 75
	origin_tech = "magnets=3;syndicate=4"
	item_color = "green"
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 50
	var/hacked = 0

/obj/item/weapon/twohanded/dualsaber/New()
	item_color = pick("red", "blue", "green", "purple")

/obj/item/weapon/twohanded/dualsaber/update_icon()
	if(wielded)
		icon_state = "dualsaber[item_color][wielded]"
	else
		icon_state = "dualsaber0"
	clean_blood()//blood overlays get weird otherwise, because the sprite changes.
	return

/obj/item/weapon/twohanded/dualsaber/attack(mob/target, mob/living/carbon/human/user)
	..()
	if(user.disabilities & CLUMSY && (wielded) && prob(40))
		impale(user)
		return
	if((wielded) && prob(50))
		spawn(0)
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
				user.dir = i
				if(i == 8)
					user.emote("flip")
				sleep(1)

/obj/item/weapon/twohanded/dualsaber/proc/impale(mob/living/user)
	user << "<span class='warning'>You twirl around a bit before losing your balance and impaling yourself on \the [src].</span>"
	if (force_wielded)
		user.take_organ_damage(20,25)
	else
		user.adjustStaminaLoss(25)

/obj/item/weapon/twohanded/dualsaber/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance)
	if(wielded)
		return ..()
	return 0

/obj/item/weapon/twohanded/dualsaber/attack_hulk(mob/living/carbon/human/user)  //In case thats just so happens that it is still activated on the groud, prevents hulk from picking it up
	if(wielded)
		user << "<span class='warning'>You can't pick up such dangerous item with your meaty hands without losing fingers, better not to!</span>"
		return 1

/obj/item/weapon/twohanded/dualsaber/wield(mob/living/carbon/M) //Specific wield () hulk checks due to reflection chance for balance issues and switches hitsounds.
	if(M.has_dna())
		if(M.dna.check_mutation(HULK))
			M << "<span class='warning'>You lack the grace to wield this!</span>"
			return
	..()
	hitsound = 'sound/weapons/blade1.ogg'

/obj/item/weapon/twohanded/dualsaber/unwield() //Specific unwield () to switch hitsounds.
	..()
	hitsound = "swing_hit"

/obj/item/weapon/twohanded/dualsaber/IsReflect()
	if(wielded)
		return 1

/obj/item/weapon/twohanded/dualsaber/green
	New()
		item_color = "green"

/obj/item/weapon/twohanded/dualsaber/red
	New()
		item_color = "red"

//spears
/obj/item/weapon/twohanded/spear
	icon_state = "spearglass0"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 10
	w_class = 4
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 18
	throwforce = 20
	throw_speed = 4
	embedded_impact_pain_multiplier = 3
	armour_penetration = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	sharpness = IS_SHARP
	var/war_cry = "AAAAARGH!!!"

/obj/item/weapon/twohanded/spear/update_icon()
	icon_state = "spearglass[wielded]"

/obj/item/weapon/twohanded/spear/afterattack(atom/movable/AM, mob/user, proximity)
	if(!proximity)
		return
	if(istype(AM, /turf/simulated/floor)) //So you can actually melee with it
		return
	if(istype(AM, /turf/space)) //So you can actually melee with it
		return

/obj/item/weapon/twohanded/spear/AltClick()
	..()
	if(ismob(loc))
		var/mob/M = loc
		var/input = sanitize_russian(stripped_input(M,"What do you want your war cry to be? You will shout it when you hit someone in melee.", ,"", 50))
		if(input)
			src.war_cry = input

// CHAINSAW
/obj/item/weapon/twohanded/required/chainsaw
	name = "chainsaw"
	desc = "A versatile power tool. Useful for limbing trees and delimbing humans."
	icon_state = "chainsaw_off"
	flags = CONDUCT
	force = 13
	w_class = 5
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	materials = list(MAT_METAL=13000)
	origin_tech = "materials=2;engineering=2;combat=2"
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = "swing_hit"
	sharpness = IS_SHARP
	var/on = 0

/obj/item/weapon/twohanded/required/chainsaw/attack_self(mob/user)
	on = !on
	user << "As you pull the starting cord dangling from \the [src], [on ? "it begins to whirr." : "the chain stops moving."]"
	force = on ? 21 : 13
	throwforce = on ? 21 : 13
	icon_state = "chainsaw_[on ? "on" : "off"]"

	if(hitsound == "swing_hit")
		hitsound = 'sound/weapons/chainsawhit.ogg'
	else
		hitsound = "swing_hit"

	if(src == user.get_active_held_item()) //update inhands
		user.update_inv_hands()