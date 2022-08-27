/proc/dice6(var/time)
	var/sum = 0
	for(time, time > 0, time--)
		var/num = rand(1, 6)
		sum += num
	return sum

/mob/proc/rolld(dice, value, strictly = 1)
	if(artefacts_effects["all_dices_penalty"])
		value -= artefacts_effects["all_dices_penalty"]
	if(strictly)
		if(dice < value)
			if(client && value <= 12)
				var/exp_value = value - round((client.loadout.level+1)/2)
				if(dice < exp_value)
					give_exp(2)
			return value - dice
	else
		if(dice <= value)
			if(client && value <= 12)
				var/exp_value = value - round((client.loadout.level+1)/2)
				if(dice < exp_value)
					give_exp(2)
			return value - dice + 1
	return FALSE

/mob
	var/str = 10
	var/hlt = 10
	var/agi = 10
	var/int = 10
	var/str_const = 10
	var/agi_const = 10
	var/int_const = 10
	var/hlt_const = 10
	var/list/gun_skills = list("smallarm" = 0, "longarm" = 0, "heavy" = 0)
	var/list/skills = list("melee" = 0, "medic" = 0)
	var/boosted = 0
	var/morphied = 0

	var/body_armor = A_EMPTY

/obj/item
	damtype = "crush"
	var/list/armor_new = list("crush" = 0, "cut" = 0, "imp" = 0, "bullet" = 0, "burn" = 0, "bio" = 0, "rad" = 0, "psy" = 0)
	var/add_dmg = 0
	var/dmgvalue = "straight"			//"straight" или "amplitude"
	var/additional_slot = 0

/obj/item/clothing
	var/armor_type = A_EMPTY

/mob/living/carbon/human/hitby(atom/movable/AM, skipkatch)
	if(!skipkatch)	//ugly, but easy
		if(in_throw_mode && !get_active_held_item())	//empty active hand and we're in throw mode
			if(canmove && !restrained())
				if(istype(AM, /obj/item))
					var/obj/item/I = AM
					if(isturf(I.loc))
						put_in_active_hand(I)
						direct_visible_message("<span class='warning'>TARGET catches [I]!</span>", message_ru = "<span class='warning'>TARGET ловит [I.name_ru]</span>", span_class = "warning", target = src)
						throw_mode_off()
						return 1


	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		direct_visible_message("<span class='danger'>TARGET has been hit by [I].</span>", \
							"<span class='danger'>TARGET has been hit by [I].</span>",\
							"<span class='danger'>[I] прилетел в TARGET.</span>", \
							"<span class='danger'>В тебя прилетел [I].</span>","danger",target = src)
		var/obj/item/organ/limb/def_zone = get_organ(ran_zone("chest", 65))//Hits a random part of the body, geared towards the chest
		var/armor = get_newarmor(def_zone, I.damtype)
		var/armt = body_armor
		var/obj/item/clothing/L = null
		//Определяем откуда брать тип армора, с головы или с тела
		if(def_zone.name == "head")
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

		if(!armt)
			if(I.throwforce < 0)
				return
			switch(I.damtype)
				if("crush")
					apply_damage(I.throwforce, BRUTE, def_zone, 0)
				if("cut")
					apply_damage(round(I.throwforce*1.5), BRUTE, def_zone, 0)
				if("imp")
					apply_damage(I.throwforce*2, BRUTE, def_zone, 0)
		else if(armt == A_HARD)									//Урон по "жеской" броне
			if(L)
				L.handle_durability(min((I.throwforce), armor))
			var/dmg = I.throwforce - armor
			if(dmg < 0 )
				return
			switch(I.damtype)
				if("crush")
					apply_damage(dmg, BRUTE, def_zone, 0)
				if("cut")
					apply_damage(round(dmg*1.5), BRUTE, def_zone, 0)
				if("imp")
					apply_damage(dmg*2, BRUTE, def_zone, 0)
		else if(armt == A_SOFT || armt == A_SOFT_LIGHT)									//Урон по гибкой броне. Особенность в том, что после блока урона наносится 1/10 или 1/5 от заблокированного без каких-либо модификаторов
			var/dmg = max(0, (I.throwforce - armor))
			var/dmg_add
			if(armt == A_SOFT)
				dmg_add = round(min(I.throwforce, armor)/10)
			else
				dmg_add = round(min(I.throwforce, armor)/5)

			switch(I.damtype)
				if("crush")
					apply_damage(dmg+dmg_add, BRUTE, def_zone, 0)
				if("cut")
					if(L)
						L.handle_durability(min(dmg, armor))
					apply_damage(round(dmg*1.5), CUT, def_zone, 0)
					apply_damage(dmg_add, CRUSH, def_zone, 0)
				if("imp")
					apply_damage(round(dmg*2), CUT, def_zone, 0)
					apply_damage(dmg_add, CRUSH, def_zone, 0)
			if(dmg == 0)
				return
		else
			world << "Smth gone wrong"

/mob/living/proc/get_newarmor(obj/item/organ/limb/def_zone, type, without = null)
	return 0

/mob/living/carbon/human/get_newarmor(obj/item/organ/limb/def_zone, type, without)
	if(!def_zone)
		return 0
	var/total_armor = 0
	var/list/body_parts = list(wear_suit, wear_suit_hard, head, head_hard, shoes) - without
	for(var/obj/item/clothing/C in body_parts)
		if(!C)
			continue
		if(CHECK_BITFIELD(C.body_parts_covered, def_zone.body_part))
			total_armor += C.armor_new[type]

	return total_armor

/mob/living/carbon/human/proc/get_armorpart(obj/item/organ/limb/def_zone)
	if(!def_zone)
		return 0
	var/list/body_parts = list(wear_suit, wear_suit_hard, head, head_hard, shoes)
	for(var/obj/item/clothing/C in body_parts)
		if(!C)
			continue
		if(CHECK_BITFIELD(C.body_parts_covered, def_zone.body_part))
			return C

/mob/proc/get_strdmg(add_dmg, var/type, mob/M)
	if(type == "straight")
		switch(M.str)
			if(1 to 2)
				return dice6(1) - 6 + add_dmg
			if(3 to 4)
				return dice6(1) - 5 + add_dmg
			if(5 to 6)
				return dice6(1) - 4 + add_dmg
			if(7 to 8)
				return dice6(1) - 3 + add_dmg
			if(9 to 10)
				return dice6(1) - 2 + add_dmg
			if(11 to 12)
				return dice6(1) - 1 + add_dmg
			if(13 to 14)
				return dice6(1) + add_dmg
			if(15 to 16)
				return dice6(1) + 1 + add_dmg
			if(17 to 18)
				return dice6(1) + 2 + add_dmg
			if(19 to 20)
				return dice6(2) - 1 + add_dmg
	else if(type == "amplitude")
		switch(M.str)
			if(1 to 2)
				return dice6(1) - 5 + add_dmg
			if(3 to 4)
				return dice6(1) - 4 + add_dmg
			if(5 to 6)
				return dice6(1) - 3 + add_dmg
			if(7 to 8)
				return dice6(1) - 2 + add_dmg
			if(9)
				return dice6(1) - 1 + add_dmg
			if(10)
				return dice6(1) + add_dmg
			if(11)
				return dice6(1) + 1 + add_dmg
			if(12)
				return dice6(1) + 2 + add_dmg
			if(13)
				return dice6(2) - 1 + add_dmg
			if(14)
				return dice6(2) + add_dmg
			if(15)
				return dice6(2) + 1 + add_dmg
			if(16)
				return dice6(2) + 2 + add_dmg
			if(17)
				return dice6(3) - 1 + add_dmg
			if(18)
				return dice6(3) + add_dmg
			if(19)
				return dice6(3) + 1 + add_dmg
			if(20)
				return dice6(3) + 2 + add_dmg

/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
//	if(..())	//to allow surgery to return properly.
//		return
	if(!M)
		return

	if(M.a_intent == "harm")
		M.do_attack_animation(src)

		var/atk_verb = "punch"
		var/atk_verb_ru = "удар"
		if(lying)
			atk_verb = "kick"
			atk_verb_ru = "пинок"

		var/parm = 2 + M.skills["melee"] > 2 ? 1 : 0

		parm += M.agi
		parm += M.skills["melee"]

		var/zone_penalty = 0
		switch(M.zone_selected)
			if("eyes")
				zone_penalty = 8
			if("head")
				zone_penalty = 6
			if("mouth")
				zone_penalty = 4
			if("face")
				zone_penalty = 4
			if("chest")
				zone_penalty = 0
			if("groin")
				zone_penalty = 4
			if("r_arm" || "l_arm" || "r_leg" || "l_leg")
				zone_penalty = 2

		parm -= zone_penalty

		if(!istype(check_target_facings(M, src), FACING_SAME_DIR))
			if(M != src)
				if(!rolld(dice6(3), parm))
					playsound(src.loc, M.dna.species.miss_sound, 25, 1, -1, channel = "regular", time = 5)
					direct_visible_message("<span class='warning'>DOER has attempted to [atk_verb] TARGET!</span>", message_ru = "<span class='warning'>DOER промазал, нанося [atk_verb_ru] TARGET!</span>", span_class = "danger",doer = M,target = src)
					return 0

		var/damage = max(0, get_strdmg(0, "straight", M)-1)

		var/obj/item/organ/limb/affecting = get_organ(M.zone_selected)
		var/armor_block = get_newarmor(affecting, "crush")

		playsound(loc, M.dna.species.attack_sound, 25, 1, -1, channel = "regular", time = 5)

		direct_visible_message("<span class='danger'>DOER has [atk_verb]ed TARGET in [parse_zone(M.zone_selected)]!</span>", \
						"<span class='danger'>DOER has [atk_verb]ed TARGET in [parse_zone(M.zone_selected)]!</span>", \
						"<span class='danger'>DOER нанес [atk_verb_ru] TARGET в [parse_zone_ru(M.zone_selected)]!</span>", \
						"<span class='danger'>DOER нанес [atk_verb_ru] TARGET в [parse_zone_ru(M.zone_selected)]!</span>", "danger",M,src)

		if(damage)
			try_knock(damage, M)
		damage = max(0, (damage - armor_block))

		apply_damage(damage, BRUTE, affecting)
		add_logs(M, src, "punched")
		/*
		if((H.stat != DEAD) && damage >= 9)
			H.visible_message("<span class='boldannounce'>[M] has weakened [H]!</span>", \
							"<span class='boldannounce'>[M] has weakened [H]!</span>")
			H.apply_effect(4, WEAKEN, armor_block)
			H.forcesay(hit_appends)
		else if(H.lying)
			H.forcesay(hit_appends)
			*/
	else
//		world << "<b> SPECIES ATTACK </b>"
		dna.species.spec_attack_hand(M, src)


/mob/living/attacked_by(obj/item/I, mob/living/M, obj/item/organ/limb/def_zone)
	if(M != src)
		M.do_attack_animation(src)

	var/parm = M.skills["melee"] > 2 ? 1 : 0

	parm += M.agi
	parm += M.skills["melee"]

//	world << "Start parm: [parm]"

	var/zone_penalty = 0
	switch(M.zone_selected)
		if("eyes")
			zone_penalty = 7
		if("head")
			zone_penalty = 5
		if("mouth")
			zone_penalty = 5
		if("face")
			zone_penalty = 5
		if("chest")
			zone_penalty = 0
//		if("groin")
//			zone_penalty = 3
		if("r_arm" || "l_arm" || "r_leg" || "l_leg")
			zone_penalty = 2

	parm -= zone_penalty

	if(lying && !M.lying)
		parm += 4 + (stat ? 0 : 6)

	if(M.lying && M != src)
		parm -= 2
		if((M.zone_selected != "r_leg") || (M.zone_selected != "l_leg"))
			M.zone_selected = pick("r_leg","l_leg")

	if(istype(I, /obj/item/weapon))
		var/obj/item/weapon/W = I
		if(W.flags & TWOHANDED)
			if(W.wielded)
				parm += min(0, M.str - W.str_need)
			else
				parm += round(min(0, M.str - W.str_need*1.5))
		else
			parm += min(0, M.str - W.str_need)


//	world << "Zone penalty param: [parm]"

	var/mob/living/carbon/human/H = src
	var/hit_area
	var/armt = body_armor
	var/obj/item/clothing/L = null
	if(ishuman(H))
		def_zone = H.get_organ(check_zone(M.zone_selected))
		hit_area = parse_zone(M.zone_selected)
		//Определяем откуда брать тип армора, с головы или с тела
		if(def_zone.name == "head")
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
	else
		def_zone = "chest"
		hit_area = "chest"

	if(M != src)
		if(!istype(check_target_facings(M, src), FACING_SAME_DIR))
			var/dice = dice6(3)
//			world << "Dice: [dice]"
			if(!rolld(dice, parm))
				direct_visible_message("<span class='warning'>DOER has attempted to attack TARGET!</span>",\
										"<span class='warning'>DOER has attempted to attack you!</span>",\
										"<span class='warning'>DOER попытался атаковать TARGET!</span>",\
										"<span class='warning'>DOER попытался тебя атаковать!</span>","warning",M,src)
				if(I.missound)
					playsound(loc, I.missound, I.get_clamped_volume(), 1, -1, channel = "regular", time = 5)
				return 0

	var/idmg_a = get_strdmg(I.add_dmg, I.dmgvalue, M)
	var/idmg_s = get_strdmg(I.add_dmg, I.dmgvalue, M)

	var/armor = get_newarmor(def_zone, I.damtype)

	if(I && I.attack_verb && I.attack_verb.len && I.attack_verb_ru && I.attack_verb_ru.len)
		direct_visible_message("<span class='danger'>DOER has [pick(I.attack_verb)] TARGET in the [parse_zone(hit_area)] with [I]!</span>",\
							"<span class='danger'>DOER has [pick(I.attack_verb)] you in your [parse_zone(hit_area)] with [I]!</span>",\
							"<span class='danger'>DOER [pick(I.attack_verb_ru)] TARGET в [parse_zone_ru(hit_area)] с помощью [I]!</span>",\
							"<span class='danger'>DOER [pick(I.attack_verb_ru)] тебя в [parse_zone_ru(hit_area)] с помощью [I]!</span>","danger",M,src)

	var/mob/living/carbon/human/guard/guard = locate() in view(src)
	if(guard)
		GLOB.guards_targets |= M


	if(I.hitsound && (idmg_a || idmg_s) > 0)
		playsound(loc, I.hitsound, I.get_clamped_volume(), 1, -1, channel = "regular", time = 5)


//Если нет типа армора, то нет и армора - просто наносим урон с его модификаторами
	if(!armt)
		if(idmg_a <= 0 && idmg_s <= 0)
			return
		switch(I.damtype)
			if("crush")
				if(I.dmgvalue == "straight")
					apply_damage(idmg_s, CRUSH, def_zone, 0)
					try_knock(idmg_s, M)
				else if(I.dmgvalue == "amplitude")
					apply_damage(idmg_a, CRUSH, def_zone, 0)
					try_knock(idmg_a, M)
			if("cut")
				apply_damage(round(idmg_a*1.5), CUT, def_zone, 0)
				try_knock(idmg_a, M, 0)
			if("imp")
				apply_damage(idmg_s*2, CUT, def_zone, 0)
				try_knock(idmg_s, M, 0)
	else if(armt == A_HARD)									//Урон по "жеской" броне
		if(L)
			L.handle_durability(min((idmg_a + idmg_s), armor))
		var/dmg_a = idmg_a - armor
		var/dmg_s = idmg_s - armor
		if(dmg_a <= 0 && dmg_s <= 0)
			return
		switch(I.damtype)
			if("crush")
				if(I.dmgvalue == "straight")
					apply_damage(dmg_s, CRUSH, def_zone, 0)
					try_knock(idmg_s, M)
				else if(I.dmgvalue == "amplitude")
					apply_damage(dmg_a, CRUSH, def_zone, 0)
					try_knock(idmg_a, M)
			if("cut")
				apply_damage(round(dmg_a*1.5), CUT, def_zone, 0)
				try_knock(idmg_a-dmg_a, M)
			if("imp")
				apply_damage(dmg_s*2, CUT, def_zone, 0)
				try_knock(idmg_s-dmg_s, M)
	else if(armt == A_SOFT || armt == A_SOFT_LIGHT)									//Урон по гибкой броне. Особенность в том, что после блока урона наносится 1/10 или 1/5 от заблокированного без каких-либо модификаторов
		var/dmg_a = max(0, (idmg_a - armor))
		var/dmg_s = max(0, (idmg_s - armor))
		var/dmg_add_a
		var/dmg_add_s
		if(armt == A_SOFT)
			dmg_add_a = round(min(idmg_a, armor)/10)
			dmg_add_s = round(min(idmg_s, armor)/10)
		else
			dmg_add_a = round(min(idmg_a, armor)/5)
			dmg_add_s = round(min(idmg_s, armor)/5)

		switch(I.damtype)
			if("crush")
				if(I.dmgvalue == "straight")
					apply_damage(dmg_s+dmg_add_s, CRUSH, def_zone, 0)
					try_knock(idmg_s, M)
				else if(I.dmgvalue == "amplitude")
					apply_damage(dmg_a+dmg_add_a, CRUSH, def_zone, 0)
					try_knock(idmg_a, M)
			if("cut")
				if(L)
					L.handle_durability(min(idmg_a, armor))
				apply_damage(round(dmg_a*1.5), CUT, def_zone, 0)
				apply_damage(dmg_add_a, CRUSH, def_zone, 0)
				try_knock(idmg_a-dmg_a, M)
			if("imp")
				apply_damage(round(dmg_s*2), CUT, def_zone, 0)
				apply_damage(dmg_add_s, CRUSH, def_zone, 0)
				try_knock(idmg_s-dmg_s, M)
		if(dmg_a <= 0 && dmg_s <= 0)
			return
	else
		world << "Smth gone wrong"

	var/bloody = 0
	if((idmg_a || idmg_s) && prob(25))
		I.add_blood(src)	//Make the weapon bloody, not the person.
		if(prob(idmg_s * 5))	//blood spatter!
			bloody = 1
			var/turf/location = src.loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(M))
				var/mob/living/carbon/human/HM = M
				if(get_dist(HM, src) <= 1)	//people with TK won't get smeared with blood
					if(HM.wear_suit)
						HM.wear_suit.add_blood(src)
						HM.update_inv_wear_suit()	//updates mob overlays to show the new blood (no refresh)
					else if(HM.w_uniform)
						HM.w_uniform.add_blood(src)
						HM.update_inv_w_uniform()	//updates mob overlays to show the new blood (no refresh)
					if (HM.gloves)
						var/obj/item/clothing/gloves/G = HM.gloves
						G.add_blood(src)
					else
						HM.add_blood(src)

		switch(hit_area)
			if("head")	//Harder to score a stun but if you do it lasts a bit longer
				/*
				if(H.stat == CONSCIOUS && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='boldannounce'>[H] has been knocked unconscious!</span>", \
										"<span class='boldannounce'>[H] has been knocked unconscious!</span>")
						H.apply_effect(20, PARALYZE, armor_block)
					if(prob(I.force + ((100 - H.health)/2)) && H != user && I.damtype == BRUTE)
						ticker.mode.remove_revolutionary(H.mind)
				*/

				if(bloody)	//Apply blood
					if(H.wear_mask)
						H.wear_mask.add_blood(src)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_blood(src)
						H.update_inv_head()
					if(H.glasses && prob(33))
						H.glasses.add_blood(src)
						H.update_inv_glasses()

			if("chest")	//Easier to score a stun but lasts less time
				/*
				if(H.stat == CONSCIOUS && I.force && prob(I.force + 10))
					H.visible_message("<span class='boldannounce'>[H] has been knocked down!</span>", \
									"<span class='boldannounce'>[H] has been knocked down!</span>")
					H.apply_effect(5, WEAKEN, armor_block)
				*/
				if(bloody)
					if(H.wear_suit)
						H.wear_suit.add_blood(src)
						H.update_inv_wear_suit()
					if(H.w_uniform)
						H.w_uniform.add_blood(src)
						H.update_inv_w_uniform()

/mob/living/bullet_act(obj/item/projectile/P)
	var/mob/living/M = P.firer
	var/armor

	var/parm
	if(M == src)
		parm += 100

	parm += M.agi
//	world << "Agi parm: [parm]"

	if(P.gun && P.gun.gun_type)
		switch(P.gun.gun_type)
			if("smallarm")
				parm += M.gun_skills["smallarm"]
			if("longarm")
				parm += M.gun_skills["longarm"]
			if("heavy")
				parm += M.gun_skills["heavy"]


//	world << "Skill parm: [parm]"

	parm += P.add_accuracy

//	world << "Accuracy parm: [parm]"

	parm += mob_size

//	world << "Mob size parm: [parm]"

	var/distance = get_dist(get_turf(src), P.starting)
//	world << "distance [distance]"
	var/dist_penalty = 0
	switch(distance)
		if(-INFINITY to 0)
			dist_penalty = -50
		if(1)
			dist_penalty = -10
			if(P.gun && is_A_facing_B(M,src))
				if(!lying && ishuman(src))
					if(getEnduranceLoss() > hlt*hlt*3)
						var/melee_parm = round(agi/2) + skills["melee"] + P.gun.w_class - 4
						var/melee_dice = dice6(3)
//						world << "Melee parm: [melee_parm]"
//						world << "Melee dice: [melee_dice]"
						if(rolld(melee_dice, melee_parm, 0))
							src.direct_visible_message("<span class='danger'>DOER has deflected TARGET shot", \
								"<span class='danger'>DOER have deflected TARGET shot</span>",\
								"<span class='danger'>DOER увел в сторону оружие TARGET", \
								"<span class='danger'>DOER увел в сторону оружие TARGET</span>","danger",src,M)
							P.forcedodge = 1
							adjustEnduranceLoss(-100)
							return P.forcedodge
		if(2)
			dist_penalty = 0
			if(P.gun && is_A_facing_B(M,src))
				if(!lying && ishuman(src))
					if(getEnduranceLoss() > hlt*hlt*3)
						var/melee_parm = round(agi/2) + skills["melee"] + P.gun.w_class - 4
						var/melee_dice = dice6(3)
//						world << "Melee parm: [melee_parm]"
//						world << "Melee dice: [melee_dice]"
						if(rolld(melee_dice, melee_parm, 0))
							src.direct_visible_message("<span class='danger'>DOER has successfully evaded line of fire!", \
								"<span class='danger'>DOER have successfully evaded line of fire!</span>",\
								"<span class='danger'>DOER уходит с линии огня!", \
								"<span class='danger'> DOER успеваешь уйти с линии огня!</span>","danger",src)
							P.forcedodge = 1
							adjustEnduranceLoss(-100)
							return P.forcedodge
		if(2)
			dist_penalty = 1
		if(3)
			dist_penalty = 2
		if(4)
			dist_penalty = 3
		if(5)
			dist_penalty = 4
		if(6 to 7)
			dist_penalty = 5
		if(8 to 10)
			dist_penalty = 6
		if(11 to 15)
			dist_penalty = 7
		if(16 to 25)
			dist_penalty = 8
		if(26 to 35)
			dist_penalty = 9
		if(36 to INFINITY)
			dist_penalty = 10

	parm -= dist_penalty

//	world << "Dist penalty parm: [parm]"

	if(lying)
		if(distance > 4)
			parm -= 2
		else if(distance > 2)
			parm -= 1

	if(M.lying)
		parm -= 2

//	world << "Lying penalty parm: [parm]"

	if(P.gun && P.gun.flags & TWOHANDED)
		if(P.gun.wielded)
			parm += min(0, M.str - P.gun.str_need)
		else
			parm += round(min(0, M.str - P.gun.str_need*1.5))
	else if(P.gun)
		parm += min(0, M.str - P.gun.str_need)

//	world << "Wielded parm: [parm]"

	parm -= P.burst_penalty

//	world << "Burst penalty parm: [parm]"


	var/zone_penalty = 0
	switch(P.def_zone)
		if("eyes")
			zone_penalty = 9
		if("head")
			zone_penalty = 5
		if("mouth")
			zone_penalty = 5
		if("face")
			zone_penalty = 5
		if("chest")
			zone_penalty = 0
//		if("groin")
//			zone_penalty = 3
		if("r_arm" || "l_arm" || "r_leg" || "l_leg")
			zone_penalty = 4

	parm -= zone_penalty

	if(P.isfraction)
		parm += 2
//	world << "Zone penalty parm: [parm]"

	parm -= M.artefacts_effects["all_dices_penalty"]

	if(artefacts_effects["kirpich"])
		parm -= artefacts_effects["kirpich"]
	if(M.artefacts_effects["kirpich"])
		parm -= 2*artefacts_effects["kirpich"]

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.blowout_effects["guns"])
			parm += 1

//	world << "<b>FULL PARM = [parm]</b>"

//Начинаем бросать кубики

	var/dice = dice6(3)
//	world << "Dice: [dice]"
	var/luck_coef = 1
	switch(dice)
		if(3 to 4)
			luck_coef = 2
		if(17 to 18)
			P.forcedodge = 1
			return P.forcedodge
	if(dice != 3 && dice != 4)
		if(((parm - dice) >= -3) && ((parm - dice) < 0) && P.def_zone != "chest")
			P.def_zone = "chest"
		else if((parm - dice) < -3)
			if(lying)
				qdel(P)
				return
			P.forcedodge = 1
			return P.forcedodge

	if(P.pul && P.pul < PUL3)
		if(P.armp)
			P.pul--
		if(P.expan)
			P.pul++

	var/armt = body_armor
	var/ignore_armor = 0
	if(P.def_zone == "chest" && prob(100/3))
		luck_coef = 2

	var/obj/item/organ/limb/organ = null
	var/obj/item/clothing/C = null

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(islimb(P.def_zone))
			organ = P.def_zone
		else
			organ = H.get_organ(check_zone(P.def_zone))
		if(organ.name == "head")
			luck_coef = 4
			C = H.get_item_by_slot(slot_head_hard)
			if(C)
				armt = C.armor_type
				if(P.def_zone == "eyes")
					if(!C.eyes_protect)
						luck_coef = 4
						ignore_armor = 1
				else if(P.def_zone == "face")
					if(!C.face_protect)
						if(prob(100/6))
							P.def_zone = "eyes"
							luck_coef = 4
							ignore_armor = 1
				else if(P.def_zone != "mouth")
					armor += 2
			else
				C = H.get_item_by_slot(slot_head)
				if(C)
					armt = C.armor_type
		else
			C = H.get_item_by_slot(slot_wear_suit_hard)
			if(C)
				armt = C.armor_type
			else
				C = H.get_item_by_slot(slot_wear_suit)
				if(C)
					armt = C.armor_type

	armor = get_newarmor(organ, "bullet")

	var/damage = 0
	if(P.isfraction)
		switch(distance)
			if(-INFINITY to 1)
				damage += (dice6(P.dice_num)+P.damage_add+P.gun.damage_add)
				armor *= 8
			if(2 to 3)
				for(var/i = 1 to 2)
					damage += (dice6(P.dice_num-5)+P.damage_add+P.gun.damage_add)
				armor *= 4
			if(4 to 5)
				for(var/i = 1 to 4)
					damage += (dice6(P.dice_num-8)+P.damage_add+2+P.gun.damage_add)
				armor *= 2
			if(6 to INFINITY)
				for(var/i = 1 to 8)
					damage += (dice6(P.dice_num-9)+P.damage_add+1+P.gun.damage_add)
	else if(P.gun)
		damage = (dice6(P.dice_num) + P.damage_add + P.gun.damage_add)
	else
		damage = (dice6(P.dice_num) + P.damage_add)



//	world << "Organ: [organ]"
//	world << "<b>Damage: [damage]</b>"
//	world << "<b>Armor: [armor]</b>"

	if(!armt)
		switch(P.pul)
			if(PUL0)
				damage_apply(0, round(damage*0.5*luck_coef), 0, organ)
			if(PUL1)
				damage_apply(0, round(damage*luck_coef), 0, organ)
				if(P.isfraction)
					try_knock(damage, P.firer, 0)
			if(PUL2)
				damage_apply(0, round(damage*1.5*luck_coef), 0, organ)
				try_knock(damage, P.firer, 0)
			if(PUL3)
				damage_apply(0, round(damage*2*luck_coef), 0, organ)
				try_knock(damage, P.firer, 0)
		playsound(src, "SOFT_HIT", 50, 1, channel = "regular", time = 5)
	else if(armt == A_HARD)
		if(C)
			C.handle_durability(min(damage, armor))
		var/pdmg = ignore_armor ? damage : max(0, (damage - armor))
		if(P.armp)
			pdmg = ignore_armor ? damage : max(0, (damage - armor/2))
		if(P.expan)
			pdmg = ignore_armor ? damage : max(0, (damage - armor*2))
		if(pdmg == 0)
			return P.on_hit(src, (damage-armor), P.def_zone)
		switch(P.pul)
			if(PUL0)
				damage_apply(0, round(pdmg*0.5)*luck_coef, 0, organ)
			if(PUL1)
				damage_apply(0, round(pdmg*luck_coef), 0, organ)
				if(P.isfraction)
					try_knock(damage, P.firer, 0)
			if(PUL2)
				damage_apply(0, round(pdmg*1.5*luck_coef), 0, organ)
				try_knock(damage, P.firer, 0)
			if(PUL3)
				damage_apply(0, round(pdmg*2*luck_coef), 0, organ)
				try_knock(damage, P.firer, 0)
	else if(armt == A_SOFT || armt == A_SOFT_LIGHT)
		if(armt == A_SOFT && !lying)
			if(P.dir != dir && P.dir != turn(dir, 180))
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					armor = H.get_newarmor(organ, "bullet", H.wear_suit_hard)
		var/pdmg = ignore_armor ? damage : max(0, (damage-armor))
		var/addmg
		if(armt == A_SOFT)
			addmg = ignore_armor ? 0 : min(damage, armor)/10
		else
			addmg = ignore_armor ? 0 : min(damage, armor)/5
		if(P.armp)
			pdmg = ignore_armor ? damage : max(0, (damage - armor/2))
			if(armt == A_SOFT)
				addmg = ignore_armor ? 0 : min(damage, armor/2)/10
			else
				addmg = ignore_armor ? damage : min(damage, armor/2)/5
		if(P.expan)
			pdmg = ignore_armor ? damage : max(0, (damage - armor*2))
			if(armt == A_SOFT_LIGHT)
				addmg = ignore_armor ? 0 : min(damage, armor*2)/10
			else
				addmg = ignore_armor ? 0 : min(damage, armor*2)/5
		switch(P.pul)
			if(PUL0)
				damage_apply(0, round(pdmg*0.5*luck_coef), 0, organ)
				damage_apply(round(addmg*luck_coef), 0, 0, organ)
			if(PUL1)
				damage_apply(0, round(pdmg*luck_coef), 0, organ)
				damage_apply(round(addmg*luck_coef), 0, 0, organ)
				if(P.isfraction)
					try_knock(damage, P.firer, 0)
			if(PUL2)
				damage_apply(0, round(pdmg*1.5*luck_coef), 0, organ)
				damage_apply(round(addmg*luck_coef), 0, 0, organ)
				try_knock(damage, P.firer, 0)
			if(PUL3)
				damage_apply(0, round(pdmg*2*luck_coef), 0, organ)
				damage_apply(round(addmg*luck_coef), 0, 0, organ)
				try_knock(damage, P.firer, 0)
		playsound(src, "SOFT_HIT", 50, 1, channel = "regular", time = 5)
		if(pdmg == 0)
			return P.on_hit(src, (damage-armor), P.def_zone)

//	play_hitsound(P)

	return P.on_hit(src, (damage-armor), P.def_zone)

/mob/living/proc/play_hitsound()
	return

/mob/living/carbon/human/play_hitsound(obj/item/projectile/P)
	var/sound_cooldown = 30
	if(health > 0)
		if(!sound_in_cooldown)
			if(P.firer.faction_s != faction_s)
				switch(faction_s)
					if("Loners")
						playsound(src, "stalker_hit", 100, falloff = 1, channel = "regular", time = 50)
					if("Bandits")
						playsound(src, "bandit_hit", 100, falloff = 1, channel = "regular", time = 50)
					if("Duty")
						playsound(src, "dolg_hit", 100, falloff = 1, channel = "regular", time = 50)
					if("Army")
						playsound(src, "army_hit", 100, falloff = 1, channel = "regular", time = 50)
					if("Traders")
						playsound(src, "ecolog_hit", 100, falloff = 1, channel = "regular", time = 50)
					if("Mercenaries")
						playsound(src, "merc_hit", 100, falloff = 1, channel = "regular", time = 50)
				sound_buble()
			else if(P.firer != src)
				switch(faction_s)
					if("Loners")
						playsound(src, "stalker_friendlyhit", 100, falloff = 1, channel = "regular", time = 50)
					if("Bandits")
						playsound(src, "bandit_friendlyhit", 100, falloff = 1, channel = "regular", time = 50)
					if("Duty")
						playsound(src, "dolg_friendlyhit", 100, falloff = 1, channel = "regular", time = 50)
					if("Army")
						playsound(src, "army_friendlyhit", 100, falloff = 1, channel = "regular", time = 50)
					if("Traders")
						playsound(src, "ecolog_friendlyhit", 100, falloff = 1, channel = "regular", time = 50)
					if("Mercenaries")
						playsound(src, "merc_friendlyhit", 100, falloff = 1, channel = "regular", time = 50)
				sound_buble()
			sound_in_cooldown = 1
			spawn(sound_cooldown)
				sound_in_cooldown = 0

/mob/living/carbon/human/proc/sound_buble()
	var/list/listening = get_hearers_in_view(7, src)
	for(var/mob/M in GLOB.player_list)
		if(M.stat == DEAD && M.client && ((M.client.prefs.chat_toggles & CHAT_GHOSTEARS) || (get_dist(M, src) <= 7 && M.z == z)) && client) // client is so that ghosts don't have to listen to mice
			listening |= M

	//sound bubble
	var/list/sound_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client)
			sound_bubble_recipients.Add(M.client)
	var/image/I = image('icons/mob/talk.dmi', src, "sound", MOB_LAYER+1)
	spawn(0)
		flick_overlay(I, sound_bubble_recipients, 30)

/mob/living/proc/damage_apply(crush, cut, burn, obj/item/organ/limb/def_zone)
	if(ishuman(src))
		var/obj/item/organ/limb/organ = def_zone
		if(crush)
			apply_damage(crush, CRUSH, organ, 0)
		if(cut)
			apply_damage(cut, CUT, organ, 0)
		if(burn)
			apply_damage(burn, BURN, organ, 0)
	else
		if(crush)
			apply_damage(crush, BRUTE, null, 0)
		if(cut)
			apply_damage(cut, BRUTE, null, 0)
		if(burn)
			apply_damage(burn, BURN, null, 0)

	update_damage_overlays()

/mob/living/proc/reset_targeting(time = 15)
	if(!client)
		return
	var/obj/item/weapon/gun/G = get_active_held_item()
	if(G && istype(G, /obj/item/weapon/gun))
		client.mouse_pointer_icon = 'icons/stalker/target_cursors_cooldown.dmi'
		last_targeting_time = world.time
		targeting = 0
		spawn(time)
			if(!client)
				return
			if(world.time-time+1 > last_targeting_time)
				if(istype(get_active_held_item(), /obj/item/weapon/gun))
					targeting = 1
					client.mouse_pointer_icon = 'icons/stalker/target_cursors.dmi'
				else
					client.mouse_pointer_icon = 'icons/stalker/cursors.dmi'
	else
		client.mouse_pointer_icon = 'icons/stalker/cursors.dmi'

/mob/living/proc/try_knock(damage, mob/living/attacker, can_throw = 0)
//	world << "Try knock call, damage: [damage]"
	var/koef = round(damage/str)
//	world << "koef: [koef]"
	if(koef)
		var/tiles_knock = koef-1
		var/dice = dice6(3) + can_throw ? tiles_knock : 0
		if(rolld(dice, agi))
			if(tiles_knock && can_throw)
//				world << "tiles knock: [tiles_knock]"
				var/turf/target = get_turf(src)
				for(var/i = 1 to tiles_knock)
					target = get_step_away(target, attacker, get_dist(target, attacker)+tiles_knock-i)
				throw_at(target, tiles_knock, 1, spin=0)
			if(!resting)
				resting = 1