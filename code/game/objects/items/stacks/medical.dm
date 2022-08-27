/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 6
	max_amount = 6
	w_class = 1
	throw_speed = 3
	throw_range = 7
	burn_state = FLAMMABLE
	burntime = 5
	var/heal_brute = 0
	var/heal_burn = 0
	var/stop_bleeding = 0
	var/self_delay = 50
	var/med_bonus = 0

/obj/item/stack/medical/attack(mob/living/M, mob/user)
/*
	if(M.stat == 2)
		var/t_him = "it"
		if(M.gender == MALE)
			t_him = "him"
		else if(M.gender == FEMALE)
			t_him = "her"
		user << "<span class='danger'>\The [M] is dead, you cannot help [t_him]!</span>"
		return
*/
	if(!istype(M, /mob/living/carbon) && !istype(M, /mob/living/simple_animal))
		user << "<span class='danger'>You don't know how to apply \the [src] to [M]!</span>"
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(stop_bleeding)
			var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_selected))
			if(!affecting.bleeding)
				var/af_name = parse_zone(user.zone_selected)
				user << "<span class='warning'>[H] [af_name] isn't bleeding!</span>"
				return

	if(isliving(M))
		if(!M.can_inject(user, 1))
			return

	var/succss = 0
	if(user)
		if (M != user)
			if (istype(M, /mob/living/simple_animal))
				var/mob/living/simple_animal/critter = M
				if (!(critter.healable))
					user << "<span class='notice'> You cannot use [src] on [M]!</span>"
					return
				else if (critter.health == critter.maxHealth)
					user << "<span class='notice'> [M] is at full health.</span>"
					return
				else if(src.heal_brute < 1)
					user << "<span class='notice'> [src] won't help [M] at all.</span>"
					return
			user.direct_visible_message("<span class='notice'>DOER starts to apply [src] on TARGET...</span>",
										"<span class='notice'>You begin applying [src] on TARGET...</span>",
										"<span class='notice'>DOER ����� ����������� [name_ru] �� TARGET...</span>",
										"<span class='notice'>�� ����� ����������� [name_ru] �� TARGET...</span>",
										"notice", user, M)
			if(!do_mob(user, M, self_delay))	return
			if(user.rolld(dice6(3), user.int+user.skills["medic"]+med_bonus))
				succss = 1
			user.direct_visible_message("<span class='green'>DOER applies [src] on TARGET.</span>",
										"<span class='green'>You apply [src] on TARGET.</span>",
										"<span class='green'>DOER ������� [name_ru] �� TARGET.</span>",
										"<span class='green'>�� ������� [name_ru] �� TARGET.</span>",
										"green", user, M)
		else
			var/t_himself = "itself"
			if(user.gender == MALE)
				t_himself = "himself"
			else if(user.gender == FEMALE)
				t_himself = "herself"
			user.direct_visible_message("<span class='notice'>DOER starts to apply [src] on [t_himself]...</span>",
										"<span class='notice'>You begin applying [src] on yourself...</span>",
										"<span class='notice'>DOER ����� ����������� [name_ru] �� ����...</span>",
										"<span class='notice'>�� ����� ����������� [name_ru] �� ����...</span>",
										"notice", user)
			if(!do_mob(user, M, self_delay))	return
			if(user.rolld(dice6(3), user.int+user.skills["medic"]+med_bonus))
				succss = 1
			user.direct_visible_message("<span class='green'>DOER applies [src] on [t_himself].</span>",
										"<span class='green'>You apply [src] on yourself.</span>",
										"<span class='green'>DOER ������� [name_ru] �� ����.</span>",
										"<span class='green'>�� ������� [name_ru] �� ����.</span>",
										"green", user)


	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_selected))
		if(stop_bleeding)
			if(affecting.status == ORGAN_ORGANIC) //Limb must be organic to be healed - RR
				if(affecting.bleeding)
					H.bleed_rate -= affecting.bleeding
					affecting.bleeding = 0
					if(succss)
						affecting.heal_damage(1, 1, 1, 0)
					H.update_damage_overlays(0)

			else
				user << "<span class='notice'>Medicine won't work on a robotic limb!</span>"
			M.updatehealth()
	else
		M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
/*
	//�����
	if(M != user)
		StalkerKarma.SetKarma(user.ckey, GetKarma(user.ckey) + 5)
		M.hostiles[user.ckey] -= 5
		user.karma += 5
*/
	use(1)



/obj/item/stack/medical/bruise_pack
	name = "bruise pack"
	name_ru = "����"
	singular_name = "bruise pack"
	desc = "A theraputic gel pack and bandages designed to treat blunt-force trauma."
	icon_state = "brutepack"
	heal_brute = 40
	origin_tech = "biotech=1"

/obj/item/stack/medical/gauze
	name = "medical gauze"
	desc = "A roll of elastic cloth that is extremely effective at stopping bleeding, but does not heal wounds."
	gender = PLURAL
	singular_name = "medical gauze"
	icon_state = "gauze"
	stop_bleeding = 1800
	self_delay = 20

/obj/item/stack/medical/gauze/improvised
	name = "improvised gauze"
	singular_name = "improvised gauze"
	desc = "A roll of cloth roughly cut from something that can stop bleeding, but does not heal wounds."
	stop_bleeding = 900

/obj/item/stack/medical/gauze/cyborg/
	materials = list()
	is_cyborg = 1
	cost = 250

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burn wounds."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 40
	origin_tech = "biotech=1"
