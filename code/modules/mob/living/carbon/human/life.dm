//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!


#define TINT_IMPAIR 2			//Threshold of tint level to apply weld mask overlay
#define TINT_BLIND 3			//Threshold of tint level to obscure vision fully

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 3 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 10 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

/mob/living/carbon/human
	var/tinttotal = 0				// Total level of visualy impairing items



/mob/living/carbon/human/Life()
	set invisibility = 0

	if (notransform)
		return

	if(zombiefied)
		if(client)
			src.timeofdeath = world.time
			ghostize(0)
		if(ckey)
			ckey = null
		a_intent = "harm"
		if(skin_tone != "zombie")
			skin_tone = "zombie"
			dna.update_ui_block(DNA_SKIN_TONE_BLOCK)
//			update_mutcolor()
		faction = list("stalker_mutants1")
		ZombieLife()

	tinttotal = tintcheck() //here as both hud updates and status updates call it

	if(..())
//		for(var/datum/mutation/human/HM in dna.mutations)
//			HM.on_life(src)

		//heart attack stuff
		handle_heart()

		//Stuff jammed in your limbs hurts
		handle_embedded_objects()

		//Изменение статов
		handle_stats_changing()

		//Прочность костюмов
		handle_suit_durability()

		//Выносливость
		handle_stamina()

		//Эффекты от токсичных аномалий
		handle_toxins()

		//Психическое здоровье
		handle_psy_health()

		if(stat != DEAD)
			if(sleeping)
				handle_sleep()

		//Обновляем цвета
		update_client_colour()

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	dna.species.spec_life(src) // for mutantraces

/mob/living/carbon/human/calculate_affecting_pressure(pressure)
	return pressure

/mob/living/carbon/human/proc/handle_stats_changing()
	var/sch = 0 //str change
	var/ach = 0 //agi change
	var/ich = 0 //int change
	var/hch = 0 //hlt change

	//HEALTH

	if(morphied)
		ach -= 1
		int -= 1
	else if(health > str_const*5)
	else if(health > str_const*4)
		sch -= 1
		ach -= 1
		ich -= 1
	else if(health > str_const*3)
		sch -= 2
		ach -= 2
		ich -= 2
	else if(health > str_const*2)
		sch -= 3
		ach -= 3
		ich -= 3
	else if(health > str_const)
		sch -= 4
		ach -= 4
		ich -= 4
	else if(health > 0)
		sch -= 5
		ach -= 5
		ich -= 5

	//WEIGHT

	switch(stamina_coef)
		if(2)
			ach -= 1
		if(3)
			ach -= 2
		if(4)
			ach -= 3
		if(5)
			ach -= 4

	//STAMINA

	if(getEnduranceLoss() < hlt*hlt*3)
		ach -= 2
	else if(getEnduranceLoss() < hlt*hlt*7.5)
		ach -= 1

	if(nutrition < NUTRITION_LEVEL_STARVING)
		sch -= 2
		ach -= 2
		ich -= 2
		hch -= 2


	//PIVO
	var/beer_is_favour = 0
	switch(favourite_beer)
		if("ohota")
			if(reagents.has_reagent("ohota"))
				beer_is_favour = 1
		if("obolon")
			if(reagents.has_reagent("obolon"))
				beer_is_favour = 1
		if("razin")
			if(reagents.has_reagent("razin"))
				beer_is_favour = 1
		if("gus")
			if(reagents.has_reagent("gus"))
				beer_is_favour = 1
	if(slurring > 15)
		ach -= 1
		ich -= 1
		if(beer_is_favour)
			sch += 1
	if(confused > 30)
		if(beer_is_favour)
			sch += 1
		else
			ach -= 1
			ich -= 1

	//ARTEFACTS
	if(artefacts_effects.len)
		if(artefacts_effects["str"])
			sch += artefacts_effects["str"]
		if(artefacts_effects["agi"])
			ach += artefacts_effects["agi"]
		if(artefacts_effects["int"])
			ich += artefacts_effects["int"]
		if(artefacts_effects["hlt"])
			hch += artefacts_effects["hlt"]

	if(blowout_effects["trainings"])
		sch += 1


	str = max(0, str_const + sch)
	max_weight = str*str/10

	agi = max(0, agi_const + ach)

	int = max(0, int_const + ich)

	hlt = max(0, hlt_const + hch)

	handle_statsicons_update()

/mob/living/carbon/human/proc/handle_suit_durability()
	if(health > 0)
		return
	if(!src.wear_suit)
		return

	var/obj/item/clothing/suit/S = src.wear_suit
	/*
	if(S.internal_slot && istype(S.internal_slot, /obj/item/weapon/storage/internal_slot/container))
		for(var/obj/item/artefact/A in S.internal_slot.contents)
			A.Think(src)
	*/
	if(S.durability == -1)
		return

	if(((S.durability/initial(S.durability))*100 - 50) > 0)
		S.durability = ((S.durability/initial(S.durability))*100 - 50) / 100 * initial(S.durability)

	if(S.durability <= 0)
		visible_message("<span class='danger'>[S] развалился прямо на [src]</span>", "<span class='warning'>[S] развалился прямо на вас!</span>")
		qdel(S)

	update_icons()

/mob/living/carbon/human/proc/handle_stamina()
	var/maxEndu = hlt*hlt*10
	var/regen = hlt*hlt*0.2
	if(artefacts_effects["stamina_coef"])
		regen *= 1 + artefacts_effects["stamina_coef"]/100
	var/lowendu = 0
	var/overload = 0

	if(getEnduranceLoss() < (maxEndu*0.3))
		src << sound('sound/stalker/mobs/stalker/breath_1.ogg', volume = 50, wait = 1, channel = SSchannels.get_reserved_channel(31))
		if(getEnduranceLoss() < (maxEndu*0.1))
			exhausted = 1
			lowendu = 1
		else
			lowendu = 0
			if(!overload)
				exhausted = 0

	var/current_weight = get_weight()
//	if(get_weight() > get_max_weight(3))
//		src.throw_alert("high_weight", /obj/screen/alert/high_weight, 1)
	if(current_weight > get_max_weight(5))
//			src.throw_alert("high_weight", /obj/screen/alert/high_weight, 2)
		overload = 1
		exhausted = 1
		if(!resting)
			src << "<span class='warning'>Ты не в состоянии двигаться при такой нагрузке!</span>"
			resting = 1
	else
		overload = 0
		if(!lowendu)
			exhausted = 0
//	else
//		src.clear_alert("high_weight")

	if(!overload && !lowendu)			//На свякий случай, помогает вроде как
		exhausted = 0

	if(current_weight < get_max_weight()/2)
		stamina_coef = -1
	else if(current_weight < get_max_weight())
		stamina_coef = 0
	else if(current_weight < get_max_weight(2))
		stamina_coef = 1
	else if(current_weight < get_max_weight(3))
		stamina_coef = 2
	else if(current_weight < get_max_weight(4))
		stamina_coef = 3
	else if(current_weight < get_max_weight(5))
		stamina_coef = 4
	else
		stamina_coef = 5

//	world << "Stamina coef: [stamina_coef]"

	if(!hold_breath)
		adjustEnduranceLoss(regen*(1+boosted))
	else if(enduranceloss > maxEndu*0.25)
		adjustEnduranceLoss(-75)
	else
		hold_breath = 0
		if(hud_used)
			hud_used.internals.icon_state = "oxygen"
//	update_stamina_hud(getEnduranceLoss(), maxEndu)

/mob/living/carbon/human/handle_hud_icons_stamina(shown_stamina_amount)
/*
	var/coef = hlt*100 / HEALTH_BAR_Y_SIZE
	var/num_pos = round(shown_stamina_amount/coef)
	if(shown_stamina_amount < hlt*100)
		if(shown_stamina_amount < old_shown_stamina_amount)
			for(old_spos, num_pos <= old_spos, old_spos--)
				var/obj/screen/O = hud_used.staminas[old_spos]
				animate(O, alpha = 0, time = 10)
		else if(shown_stamina_amount > old_shown_stamina_amount)
			for(old_spos, old_spos <= num_pos, old_spos++)
				var/obj/screen/O = hud_used.staminas[old_spos]
				animate(O, alpha = 255, time = 10)
		old_shown_stamina_amount = shown_stamina_amount
*/
	if(!client || !hud_used)
		return
	if(hud_used.stamina)

		if(stat != DEAD)
			. = 1
			if(!shown_stamina_amount)
				shown_stamina_amount = enduranceloss
			if(shown_stamina_amount >= hlt*hlt*7.5)
				hud_used.stamina.icon_state = "stamina_high"
			else if(shown_stamina_amount > hlt*hlt*3)
				hud_used.stamina.icon_state = "stamina_med"
			else if(shown_stamina_amount > 0)
				hud_used.stamina.icon_state = "stamina_low"

/mob/living/carbon/human/proc/handle_sleep()
	return
/*
	if(istype(buckled, /obj/structure/bed/stalker/matras) || istype(buckled, /obj/structure/bed/stalker/metal/matras) || istype(buckled, /obj/structure/bed/chair/stalker/matras) || istype(buckled, /obj/structure/bed/stalker/metal/matras))
		adjustBruteLoss(-0.1, 0)
		adjustFireLoss(-0.1, 0)
		adjustToxLoss(-0.1, 0)
		adjustEnduranceLoss(10)
		nutrition -= 1.5
		if(prob(25))
			playsound(src, "snoring", 100, 0, -4, 1, channel = "regular", time = 50)
	else
		sleep(10)
		src << "<span class='warning'>You can't sleep on the ground! Find a better place!"
		SetSleeping(0, 1)
		for(var/obj/screen/human/sleep_int/S)
			S.icon_state = "sleep"
			S.name = "sleep"

/mob/living/carbon/human/handle_disabilities()
	..()
	//Eyes
	if(!(disabilities & BLIND))
		if(tinttotal >= TINT_BLIND)		//covering your eyes heals blurry eyes faster
			eye_blurry = max(eye_blurry-2, 0)

	//Ears
	if(!(disabilities & DEAF))
		if(istype(ears, /obj/item/clothing/ears/earmuffs)) // earmuffs rest your ears, healing ear_deaf faster and ear_damage, but keeping you deaf.
			setEarDamage(max(ear_damage-0.10, 0), max(ear_deaf - 1, 1))
*/

/mob/living/carbon/human/breathe()
	if(!dna.species.breathe(src))
		..()

/mob/living/carbon/human/check_breath(datum/gas_mixture/breath)
	dna.species.check_breath(breath, src)

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	dna.species.handle_environment(environment, src)

///FIRE CODE
/mob/living/carbon/human/handle_fire()
//	..()
	if(!on_fire)
		return
	var/obj/item/clothing/C = wear_suit
	var/obj/item/clothing/head/CH = head
	if(!C)
		C = wear_suit_hard
	if(!CH)
		CH = head_hard
	if(C && CH && istype(C, /obj/item/clothing/suit/hooded/sealed) && istype(CH, /obj/item/clothing/head/winterhood/stalker/sealed))
		ExtinguishMob()
		return
	for(var/obj/item/organ/limb/L in organs)
		var/damage = dice6(1)-5
		if(damage > 0)
			L.take_damage(0, 0, damage)
/*
	if(on_fire)
		var/thermal_protection = get_thermal_protection()

		if(thermal_protection >= FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT)
			return
		if(thermal_protection >= FIRE_SUIT_MAX_TEMP_PROTECT)
			bodytemperature += 11
		else
			bodytemperature += (BODYTEMP_HEATING_MAX + (fire_stacks * 12))

/mob/living/carbon/human/proc/get_thermal_protection()
	var/thermal_protection = 0 //Simple check to estimate how protected we are against multiple temperatures
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature >= FIRE_SUIT_MAX_TEMP_PROTECT)
			thermal_protection += (wear_suit.max_heat_protection_temperature*0.7)
	if(head)
		if(head.max_heat_protection_temperature >= FIRE_HELM_MAX_TEMP_PROTECT)
			thermal_protection += (head.max_heat_protection_temperature*THERMAL_PROTECTION_HEAD)
	thermal_protection = round(thermal_protection)
	return thermal_protection
*/
//END FIRE CODE


//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, CHEST, GROIN, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.heat_protection
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_suit.heat_protection
	if(w_uniform)
		if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= w_uniform.heat_protection
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.heat_protection
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.heat_protection
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.heat_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
//		if(thermal_protection_flags & GROIN)
//			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


	return min(1,thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.cold_protection
	if(wear_suit)
		if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_suit.cold_protection
	if(w_uniform)
		if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= w_uniform.cold_protection
	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.cold_protection
	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.cold_protection
	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.cold_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_cold_protection(temperature)

	if(dna.check_mutation(COLDRES))
		return 1 //Fully protected from the cold.

	if(dna && COLDRES in dna.species.specflags)
		return 1

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
//		if(thermal_protection_flags & GROIN)
//			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1,thermal_protection)


/mob/living/carbon/human/handle_chemicals_in_body()
	if(reagents)
		reagents.metabolize(src, can_overdose=1)
	dna.species.handle_chemicals_in_body(src)

/mob/living/carbon/human/handle_vision()
//	clear_fullscreens()
	if(machine)
		if(!machine.check_eye(src))		reset_view(null)
//	else
//		if(!remote_view && !client.adminobs)			reset_view(null)

	dna.species.handle_vision(src)

/mob/living/carbon/human/handle_hud_icons()
	..()
	dna.species.handle_hud_icons(src)

/mob/living/carbon/human/handle_random_events()

/*
	if(nutrition < 100)
		var/nutr_timeout //In order not to spam the chat with those messages and don't overload players with staminaloss
		if(prob(50) && !nutr_timeout)
			src << "<span class='notice'>You are really hungry!</span>"
			nutr_timeout = 1
			spawn(10)
				nutr_timeout = 0
		if((nutrition < 50) && !nutr_timeout)
			if(prob(20))
				adjustStaminaLoss(15)
				Weaken(10)
				nutr_timeout = 1
				visible_message("<span class='danger'>[src] collapses!</span>", \
								"<span class='userdanger'>You feel very-very hungry!</span>")
				spawn(10)
					nutr_timeout = 0
			if(prob(30) && !nutr_timeout)
				nutr_timeout = 1
				adjustStaminaLoss(40)
				src << "<span class='danger'>You are very-very-very hungry!</span>"
				spawn(10)
					nutr_timeout = 0
			if(prob(10))
				adjustOxyLoss(5)
*/

	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 45 && nutrition > 20)
			lastpuke ++
			if(lastpuke >= 25) // about 25 second delay I guess
				Stun(5)

				visible_message("<span class='danger'>[src] throws up!</span>", \
						"<span class='userdanger'>[src] throws up!</span>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1, channel = "regular", time = 10)

				var/turf/location = loc
				if (istype(location, /turf/simulated))
					location.add_vomit_floor(src, 1)

				nutrition -= 20
				adjustToxLoss(-3)

				// make it so you can only puke so fast
				lastpuke = 0

/mob/living/carbon/human/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	if(glasses)
		if(glasses.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	if(head)
		if(head.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	if(NOBREATH in dna.species.specflags)
		. = 1
	return .
/mob/living/carbon/human/proc/handle_embedded_objects()
	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			if(prob(I.embedded_pain_chance))
				L.take_damage(I.w_class*I.embedded_pain_multiplier)
				src << "<span class='userdanger'>\the [I] embedded in your [L.getDisplayName()] hurts!</span>"

			if(prob(I.embedded_fall_chance))
				L.take_damage(I.w_class*I.embedded_fall_pain_multiplier)
				L.embedded_objects -= I
				I.loc = get_turf(src)
				visible_message("<span class='danger'>\the [I] falls out of [name]'s [L.getDisplayName()]!</span>","<span class='userdanger'>\the [I] falls out of your [L.getDisplayName()]!</span>")
				if(!has_embedded_objects())
					clear_alert("embeddedobject")

/mob/living/carbon/human/proc/handle_heart()
	if(!heart_attack)
		return
	else
		if(losebreath < 3)
			losebreath += 2
		adjustOxyLoss(5)
		adjustBruteLoss(1)

#undef HUMAN_MAX_OXYLOSS

/mob/living/carbon/human/proc/handle_psy_health()
	if(psyloss <= int)
		if(prob(10))
			shake_camera(src, 10, 1)
	if(psyloss <= 0)
		death(0, 0)
		return

	adjustPsyLoss(0.033)

/mob/living/carbon/human/proc/handle_toxins()
	var/list/armor = list()
	for(var/obj/item/organ/limb/L in organs)
		if(L.toxic_effects.len)
			for(var/e in L.toxic_effects)
				if(e == "rustpuddle")
					if(L.toxic_effects[e] + 300 <= world.time)
						L.toxic_effects[e] = world.time
						L.take_damage(0, 0, 1)
				if(e == "vedminstuden")
					if(L.toxic_effects[e] + 150 <= world.time)
						L.toxic_effects[e] = world.time
						L.take_damage(0, 0, 1)
						var/obj/item/clothing/C = get_armorpart(L)
						if(C && !armor.Find(C))
							armor += C
							var/n = 0
							for(var/i in C.armor_new)
								if(C.armor_new[i] > 1)
									C.armor_new[i] = max(C.armor_new[i] - 2, 0)
									if(!C.armor_new[i])
										n++
								else
									n++
							if(n == C.armor_new.len)
								qdel(C)


/*
/mob/living/carbon/human/handle_radiation()
	var/list/msgs_ru			//Сообщения о слабости, жаре, головной боли и прочих эффектах облучения
	var/list/msgs
	switch(radiation)
		if(0 to 0.25)				// 0 - 0.25 Гр, пока ещё не смертельно

		if(0.25 to 1)				// 0.25 - 1 Гр, начало лучевой болезни

		if(1 to 2)					// 1 - 2 Гр, лёгкая степень тяжести костномозговой острой лучевой болезни(далее КМ ОЛБ)
			msgs_ru = list("Что-то голова побаливает, аспиринчика бы...","Что же бошка то так ноет...")
		if(2 to 4)					// 2 - 4 Гр, среднетяжелая степень тяжести КМ ОЛБ
			msgs_ru = list("Голова болит, таблеток бы каких...","Да что там в голове так ныть может то?","Что-то меня в сон клонет...","Слабость какая-то, идти тяжко...","Как-то я нехорошо себя чувствую...")
		if(4 to 6)					// 4 - 6 Гр, тяжелая степень тяжести КМ ОЛБ
			msgs_ru = list("Голова гудит - сил нет, да что же это такое...","Господи, голову разбить хочется, лишь бы боли не было.","Как же тяжело держаться на ногах...","Ноги не слушаются, надо прилечь...","Я весь потный, неужели температура?","Кажется у меня жар...")
		if(6 to 10)					// 6 - 10 Гр, крайне тяжелая степень тяжести КМ ОЛБ, переходная форма, шансов выжить очень мало
			msgs_ru = list("Голова просто раскалывается, тяжело думать...","Я уже еле слышу свои мысли, господи, за что такая боль...","Как же здесь душно, умираю от жары.","Тяжело дышать, кажется я плавлюсь изнутри")
			if(!resting)
				src << client.select_lang("Ты упал обессилев.","You fell exhausted.")
				resting = 0
		if(10 to 20)				// 10 - 20 Гр, кишечная форма ОЛБ, шансы на выживание равны нулю, далее лишь мучительная смерть с постоянным кровавым поносом

		if(20 to 80)				// 20 - 80 Гр, сосудистая форма ОЛБ, полное разложение сосудистой системы в течение игровых суток, смерть же наступит быстрее

		if(80 to 120)				// 80 - 120 Гр, церебральная форма ОЛБ, разложение ЦНС, смерть в течение нескольких игровых часов

		if(120 to INFINITY)			// 120 и выше - смерть под лучом. Моментальная.

	if(raditaion > 0.001)
		radiation -= 0.0001			//Выводим радиацию игровыми условностями, по 0.0001 Гр раз в 2 секунды(примерно), т.е. облучение в ~0.25 Гр будет выведено за 60-90 минут
	if(prob(2))
		if(client)
			src << client.select_lang("<i>[pick(msgs_ru)]</i>","<i>[pick(msgs)]</i>")
*/

