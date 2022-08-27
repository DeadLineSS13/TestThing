/mob/living/carbon/human/getarmor(def_zone, type, var/random_zone = 1)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(islimb(def_zone))
			return checkarmor(def_zone, type)
		var/obj/item/organ/limb/affecting
		if(random_zone)
			affecting = get_organ(ran_zone(def_zone))
		else
			affecting = get_organ(check_zone(def_zone))
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/obj/item/organ/limb/organ in organs)
		armorval += checkarmor(organ, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(obj/item/organ/limb/def_zone, type)
	if(!type)	return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				if(C.durability != -1)
					var/percentage = (C.durability/initial(C.durability))*100

					switch(percentage)

						if(75 to 100)
							protection += C.armor[type]

						if(50 to 75)
							protection += C.armor[type] * 0.8

						if(25 to 50)
							protection += C.armor[type] * 0.6

						if(0 to 25)
							protection = 0

					if(type != "rad")

						if(istype(C, /obj/item/clothing/suit))
							var/obj/item/clothing/suit/S = C
							S.durability -= 0.2

						if(istype(C, /obj/item/clothing/head))
							var/obj/item/clothing/head/H = C
							H.durability -= 0.2

						if(istype(C, /obj/item/clothing/mask))
							var/obj/item/clothing/mask/M = C
							M.durability -= 0.2

						if(C.durability <= 0)
							visible_message("<span class='danger'>[C] falls into pices!</span>", "<span class='warning'>[C] falls into pieces!</span>")
							qdel(C)
						update_icons()
				else
					protection += C.armor[type]

	return protection + global_armor[type]



/mob/living/carbon/human/on_hit(proj_type)
	dna.species.on_hit(proj_type, src)
/*
/mob/living/carbon/human/bullet_act(obj/item/projectile/P, def_zone)
	if(!(P.original == src && P.firer == src)) //can't block or reflect when shooting yourself
		if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
			if(check_reflect(def_zone)) // Checks if you've passed a reflection% check
				visible_message("<span class='danger'>The [P.name] gets reflected by [src]!</span>", \
								"<span class='userdanger'>The [P.name] gets reflected by [src]!</span>")
				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.current = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x

				return -1 // complete projectile permutation

		if(check_shields(P.damage_add, "the [P.name]", P, PROJECTILE_ATTACK, P.armour_penetration))
			P.on_hit(src, 100, def_zone)
			return 2
	return (..(P , def_zone))
*/
/mob/living/carbon/human/proc/check_reflect(def_zone) //Reflection checks for anything in your l_hand, r_hand, or wear_suit based on the reflection chance of the object
	if(wear_suit)
		if(wear_suit.IsReflect(def_zone) == 1)
			return 1
	if(l_hand)
		if(l_hand.IsReflect(def_zone) == 1)
			return 1
	if(r_hand)
		if(r_hand.IsReflect(def_zone) == 1)
			return 1
	return 0

/mob/living/carbon/human/proc/check_shields(damage = 0, attack_text = "the attack", atom/movable/AM, attack_type = MELEE_ATTACK, armour_penetration = 0)
	var/block_chance_modifier = round(damage / -3)

	if(l_hand && !istype(l_hand, /obj/item/clothing))
		var/final_block_chance = l_hand.block_chance - (Clamp((armour_penetration-l_hand.armour_penetration)/2,0,100)) + block_chance_modifier //So armour piercing blades can still be parried by other blades, for example
		if(l_hand.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	if(r_hand && !istype(r_hand, /obj/item/clothing))
		var/final_block_chance = r_hand.block_chance - (Clamp((armour_penetration-r_hand.armour_penetration)/2,0,100)) + block_chance_modifier //Need to reset the var so it doesn't carry over modifications between attempts
		if(r_hand.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	if(wear_suit)
		var/final_block_chance = wear_suit.block_chance - (Clamp((armour_penetration-wear_suit.armour_penetration)/2,0,100)) + block_chance_modifier
		if(wear_suit.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	if(w_uniform)
		var/final_block_chance = w_uniform.block_chance - (Clamp((armour_penetration-w_uniform.armour_penetration)/2,0,100)) + block_chance_modifier
		if(w_uniform.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	return 0


/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/carbon/human/user, def_zone)
	if(istype(I, /obj/item/device/pager))
		var/obj/item/device/pager/P = I
		if(stat == DEAD && user.current_quest)
			if(user.current_quest.name_kill == name)
				if(!P.made_photo)
					user << user.client.select_lang("Ты сделал фото убитого","You've made a photo of the corpse")
					P.made_photo = 1
				else
					user << user.client.select_lang("Ты уже сделал фото убитого","You've already made a photo of the corpse")
					return ..()
			else
				return ..()
		else
			return ..()
	else
		return ..()

/*
	if(!I || !user)	return 0
	var/obj/item/organ/limb/target_limb = get_organ(check_zone(user.zone_selected))
	var/obj/item/organ/limb/affecting = get_organ(ran_zone(user.zone_selected))
	var/hit_area = parse_zone(affecting.name)
	var/target_area = parse_zone(target_limb.name)

	feedback_add_details("item_used_for_combat","[I.type]|[I.force]")
	feedback_add_details("zone_targeted","[target_area]")

	// the attacked_by code varies among species
	return dna.species.spec_attacked_by(I,user,def_zone,affecting,hit_area,src.a_intent,target_limb,target_area,src)
*/
/mob/living/carbon/human/emp_act(severity)
	var/informed = 0
	for(var/obj/item/organ/limb/L in src.organs)
		if(L.status == ORGAN_ROBOTIC)
			if(!informed)
				src << "<span class='userdanger'>You feel a sharp pain as your robotic limbs overload.</span>"
				informed = 1
			switch(severity)
				if(1)
					L.take_damage(0,10)
					src.Stun(10)
				if(2)
					L.take_damage(0,5)
					src.Stun(5)
	..()

/mob/living/carbon/human/acid_act(acidpwr, toxpwr, acid_volume)
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/acidity = min(acidpwr*acid_volume/200, toxpwr)
	var/acid_volume_left = acid_volume
	var/acid_decay = 100/acidpwr // how much volume we lose per item we try to melt. 5 for fluoro, 10 for sulphuric

	//HEAD//
	var/obj/item/clothing/head_clothes = null
	if(glasses)
		head_clothes = glasses
	if(wear_mask)
		head_clothes = wear_mask
	if(head)
		head_clothes = head
	if(head_clothes)
		if(!head_clothes.unacidable)
			head_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0) //We remove some of the acid volume.
			update_inv_glasses()
			update_inv_wear_mask()
			update_inv_head()
		else
			src << "<span class='notice'>Your [head_clothes.name] protects your head and face from the acid!</span>"
	else
		. = get_organ("head")
		if(.)
			damaged += .
		if(ears)
			inventory_items_to_kill += ears

	//CHEST//
	var/obj/item/clothing/chest_clothes = null
	if(w_uniform)
		chest_clothes = w_uniform
	if(wear_suit)
		chest_clothes = wear_suit
	if(chest_clothes)
		if(!chest_clothes.unacidable)
			chest_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [chest_clothes.name] protects your body from the acid!</span>"
	else
		. = get_organ("chest")
		if(.)
			damaged += .
		if(wear_id)
			inventory_items_to_kill += wear_id
		if(r_store)
			inventory_items_to_kill += r_store
		if(l_store)
			inventory_items_to_kill += l_store
		if(s_store)
			inventory_items_to_kill += s_store


	//ARMS & HANDS//
	var/obj/item/clothing/arm_clothes = null
	if(gloves)
		arm_clothes = gloves
	if(w_uniform && (w_uniform.body_parts_covered & HANDS) || w_uniform && (w_uniform.body_parts_covered & ARMS))
		arm_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & HANDS) || wear_suit && (wear_suit.body_parts_covered & ARMS))
		arm_clothes = wear_suit
	if(arm_clothes)
		if(!arm_clothes.unacidable)
			arm_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_gloves()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [arm_clothes.name] protects your arms and hands from the acid!</span>"
	else
		. = get_organ("r_arm")
		if(.)
			damaged += .
		. = get_organ("l_arm")
		if(.)
			damaged += .


	//LEGS & FEET//
	var/obj/item/clothing/leg_clothes = null
	if(shoes)
		leg_clothes = shoes
	if(w_uniform && (w_uniform.body_parts_covered & FEET) || w_uniform && (w_uniform.body_parts_covered & LEGS))
		leg_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & FEET) || wear_suit && (wear_suit.body_parts_covered & LEGS))
		leg_clothes = wear_suit
	if(leg_clothes)
		if(!leg_clothes.unacidable)
			leg_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_shoes()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [leg_clothes.name] protects your legs and feet from the acid!</span>"
	else
		. = get_organ("r_leg")
		if(.)
			damaged += .
		. = get_organ("l_leg")
		if(.)
			damaged += .


	//DAMAGE//
	for(var/obj/item/organ/limb/affecting in damaged)
		affecting.take_damage(acidity, 2*acidity)

		if(affecting.name == "head")
			if(prob(min(acidpwr*acid_volume/10, 90))) //Applies disfigurement
				affecting.take_damage(acidity, 2*acidity)
				emote("scream")
				facial_hair_style = "Shaved"
				hair_style = "Bald"
				update_hair()
				status_flags |= DISFIGURED

		update_damage_overlays()

	//MELTING INVENTORY ITEMS//
	//these items are all outside of armour visually, so melt regardless.
	if(back)
		inventory_items_to_kill += back
	if(back2)
		inventory_items_to_kill += back2
	if(belt)
		inventory_items_to_kill += belt
	if(r_hand)
		inventory_items_to_kill += r_hand
	if(l_hand)
		inventory_items_to_kill += l_hand

	for(var/obj/item/I in inventory_items_to_kill)
		I.acid_act(acidpwr, acid_volume_left)
		acid_volume_left = max(acid_volume_left - acid_decay, 0)

/mob/living/carbon/human/grabbedby(mob/living/user)
	if(w_uniform)
		w_uniform.add_fingerprint(user)
	..()


/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M)
	if(..())
		var/damage_s = dice6(M.dice_number) + M.add_damage
		var/damage_a = damage_s
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/obj/item/organ/limb/affecting = get_organ(ran_zone(dam_zone))
		var/armt = A_EMPTY
		var/obj/item/clothing/L = null
		//Определяем откуда брать тип армора, с головы или с тела
		if(affecting.name == "head")
			L = get_item_by_slot(slot_head_hard)
			if(L)
				armt = L.armor_type
			else
				L = get_item_by_slot(slot_head)
				if(L)
					armt = L.armor_type
		else
			L = get_item_by_slot(slot_wear_suit_hard)
			if(L)
				armt = L.armor_type
			else
				L = get_item_by_slot(slot_wear_suit)
				if(L)
					armt = L.armor_type
		var/armor = get_newarmor(affecting, M.damtype)

	//Если нет типа армора, то нет и армора - просто наносим урон с его модификаторами
		if(!armt)
			if((damage_a || damage_s) < 0)
				return
			switch(M.damtype)
				if("crush")
					if(M.dmgvalue == "straight")
						apply_damage(damage_s, CRUSH, affecting, 0)
					else if(M.dmgvalue == "amplitude")
						apply_damage(damage_a, CRUSH, affecting, 0)
				if("cut")
					apply_damage(round(damage_a*1.5), CUT, affecting, 0)
				if("imp")
					apply_damage(damage_s*2, CUT, affecting, 0)
		else if(armt == A_HARD)									//Урон по "жеской" броне
			L.handle_durability(min((damage_a + damage_s), armor))
			var/dmg_a = damage_a - armor
			var/dmg_s = damage_s - armor
			if((dmg_a || dmg_s) < 0 )
				return
			switch(M.damtype)
				if("crush")
					if(M.dmgvalue == "straight")
						apply_damage(dmg_s, CRUSH, affecting, 0)
					else if(M.dmgvalue == "amplitude")
						apply_damage(dmg_a, CRUSH, affecting, 0)
				if("cut")
					apply_damage(round(dmg_a*1.5), CUT, affecting, 0)
				if("imp")
					apply_damage(dmg_s*2, CUT, affecting, 0)
		else if(armt == A_SOFT || armt == A_SOFT_LIGHT)									//Урон по гибкой броне. Особенность в том, что после блока урона наносится 1/10 от заблокированного без каких-либо модификаторов
			var/dmg_a = max(0, (damage_a - armor))
			var/dmg_s = max(0, (damage_s - armor))
			var/dmg_add_a = round(min(damage_a, armor)/10)
			var/dmg_add_s = round(min(damage_s, armor)/10)

			switch(M.damtype)
				if("crush")
					if(M.dmgvalue == "straight")
						apply_damage(dmg_s+dmg_add_s, CRUSH, affecting, 0)
					else if(M.dmgvalue == "amplitude")
						apply_damage(dmg_a+dmg_add_a, CRUSH, affecting, 0)
				if("cut")
					L.handle_durability(min(damage_a, armor))
					apply_damage(round(dmg_a*1.5), CUT, affecting, 0)
					apply_damage(dmg_add_a, CRUSH, affecting, 0)
				if("imp")
					apply_damage(round(dmg_s*2), CUT, affecting, 0)
					apply_damage(dmg_add_s, CRUSH, affecting, 0)
			if((dmg_a && dmg_s) == 0)
				return
		else
			world << "Smth gone wrong"

		updatehealth()
/*
/mob/living/carbon/human/mech_melee_attack(obj/mecha/M)

	if(M.occupant.a_intent == "harm")
		if(M.damtype == "brute")
			step_away(src,M,15)
		var/obj/item/organ/limb/temp = get_organ(pick("chest", "chest", "chest", "head"))
		if(temp)
			var/update = 0
			switch(M.damtype)
				if("brute")
					if(M.force > 20)
						Paralyse(1)
					update |= temp.take_damage(rand(M.force/2, M.force), 0)
					playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
				if("fire")
					update |= temp.take_damage(0, rand(M.force/2, M.force))
					playsound(src, 'sound/items/Welder.ogg', 50, 1)
				if("tox")
					M.mech_toxin_damage(src)
				else
					return
			if(update)
				update_damage_overlays(0)
			updatehealth()

		visible_message("<span class='danger'>[M.name] has hit [src]!</span>", \
								"<span class='userdanger'>[M.name] has hit [src]!</span>")
		add_logs(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")

	else
		..()
*/
/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = 0, hitpush = 1, blocked = 0)
	var/obj/item/I
	var/throwpower = 30
	if(istype(AM, /obj/item))
		I = AM
		throwpower = I.throwforce
		if(I.thrownby != src && check_shields(throwpower, "\the [AM.name]", AM, THROWN_PROJECTILE_ATTACK))
			hitpush = 0
			skipcatch = 1
			blocked = 1
		else if(I)
			if(I.throw_speed >= EMBED_THROWSPEED_THRESHOLD)
				if(can_embed(I))
					if(prob(I.embed_chance) && !(dna && (PIERCEIMMUNE in dna.species.specflags)))
//						throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
						var/obj/item/organ/limb/L = pick(organs)
						L.embedded_objects |= I
						I.add_blood(src)//it embedded itself in you, of course it's bloody!
						I.loc = src
						L.take_damage(I.w_class*I.embedded_impact_pain_multiplier)
						visible_message("<span class='danger'>\the [I.name] embeds itself in [src]'s [L.getDisplayName()]!</span>","<span class='userdanger'>\the [I.name] embeds itself in your [L.getDisplayName()]!</span>")
						hitpush = 0
						skipcatch = 1 //can't catch the now embedded item

	return ..()
