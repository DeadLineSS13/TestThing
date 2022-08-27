
/obj/item/weapon/reagent_containers/hypospray/medipen
	name = "injector"
	icon_ground = "injector_ground"
	name_ru = "��������"

/obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator
	name = "injector"
	name_ru = "��������"
	desc = "It's labeled 'hyperstim'."
	desc_ru = "�� ������ �������� '���������������'."
	icon = 'icons/stalker/items.dmi'
	icon_state = "hyper"
	icon_ground = "hyper_ground"
	item_state = "antirad"
	amount_per_transfer_from_this = 25
	volume = 25
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("hyperstim" = 25)

/obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator/attack(mob/living/carbon/human/M, mob/user)
	..()

	M.SetParalysis(0)

/obj/item/weapon/reagent_containers/hypospray/medipen/morphite
	name = "injector"
	name_ru = "��������"
	desc = "It's labeled 'morphite'."
	desc_ru = "�� ������ �������� '������'."
	icon = 'icons/stalker/items.dmi'
	icon_state = "morphit"
	icon_ground = "morphit_ground"
	item_state = "antirad"
	amount_per_transfer_from_this = 25
	volume = 25
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("morphite" = 25)

/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline
	name = "injector"
	name_ru = "��������"
	desc = "It's labeled 'adrenaline'."
	desc_ru = "�� ������ �������� '���������'."
	icon = 'icons/stalker/items.dmi'
	icon_state = "injector"
	item_state = "antirad"
	amount_per_transfer_from_this = 1
	volume = 1
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("adrenaline" = 1)

/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline/attack(mob/living/carbon/human/M, mob/user)
	..()

	if(M.softdead)
		if(user.rolld(dice6(3),(10 + user.skills["medic"])))
			M.softdead = 0
			M.stat = CONSCIOUS
			M.death_dices = M.death_dices - 1
			M.remove_client_colour(/datum/client_colour/full_black)
			if(M.client)
				M << M.client.select_lang("<span class='notice'>�� ������������ ����� � ���������� ����������� ����, ����������� � �����!", "<span class='notice'>You come back to life, suddenly!")
			user << user.client.select_lang("<span class='notice'>�� ������� ������������ [M]!", "<span class='notice'>You've successfully reanimated [M]!")
		else
			user << user.client.select_lang("<span class='notice'>[M] �������� ������������.", "<span class='warning'>[M] remains lifeless.</span>")
			//�� ������ ����� ���� �������
			M.softdead = 0


/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/low
	name = "injector"
	name_ru = "��������"
	desc = "It's labeled 'medstim'."
	desc_ru = "�� ������ �������� '�������'."
	icon = 'icons/stalker/items.dmi'
	icon_state = "healeri"
	icon_ground = "healeri_ground"
	item_state = "antirad"
	amount_per_transfer_from_this = 5
	volume = 5
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("hl_stim_low" = 5)

/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/medium
	name = "injector"
	name_ru = "��������"
	desc = "It's labeled 'mark II medstim'."
	desc_ru = "�� ������ �������� '�������, ��� II'."
	icon = 'icons/stalker/items.dmi'
	icon_state = "healerii"
	icon_ground = "healerii_ground"
	item_state = "antirad"
	amount_per_transfer_from_this = 5
	volume = 5
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("hl_stim_medium" = 5)

/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/hard
	name = "injector"
	name_ru = "��������"
	desc = "It's labeled 'anomalous stimulator'."
	desc_ru = "�� ������ �������� '���������� ����������'."
	icon = 'icons/stalker/items.dmi'
	icon_state = "injector"
	item_state = "antirad"
	amount_per_transfer_from_this = 5
	volume = 5
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("hl_stim_hard" = 5)

/obj/item/weapon/medicine_kit
	name = "Medicine kit"
	name_ru = "����������� �����"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/items.dmi'
	icon_state = "surgery"
	icon_ground = "surgery_ground"
	weight = 2.5
	w_class = 3
	var/uses = 5
	var/use = "restore"

/obj/item/weapon/medicine_kit/examine(mob/user)
	..()
	user << user.client.select_lang("<span class='notice'>�������� [uses] �������������.</span>", "<span class='notice'>[uses] uses remains.</span>")

/obj/item/weapon/medicine_kit/attack_self(mob/user)
	if(use == "restore")
		use = "heal"
		user << user.client.select_lang("<span class='notice'>������ �� ������ ������ ����.</span>","<span class='notice'>Now you will heal wounds.</span>")
	else
		use = "restore"
		user << user.client.select_lang("<span class='notice'>������ �� ������ ��������������� ����������.</span>","<span class='notice'>Now you will restore limbs.</span>")

/obj/item/weapon/medicine_kit/attack(mob/living/carbon/human/H, mob/user)
	if(!H)
		return

	var/H_name = user.clients_names[H]
	if(!H_name)
		H_name = user.client.select_lang(H.get_uniq_name("RU"), H.get_uniq_name("EN"))

	var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_selected))
	if((!affecting.crippled && use == "restore") || (!affecting.crush_dam && !affecting.cut_dam && !affecting.burn_dam && use == "heal"))
		if(H == user)
			user << user.client.select_lang("<span class='notice'>���� [parse_zone_ru2(affecting.name)] � �������!</span>","<span class='notice'>Your [parse_zone(affecting.name)] is OK!</span>")
		else
			user << user.client.select_lang("<span class='notice'>[parse_zone_ru2(affecting.name)] [H_name] � �������!</span>","<span class='notice'>[parse_zone(affecting.name)] [H_name] is OK!</span>")
		return

	if(user.flags & IN_PROGRESS)
		return

	if(use == "restore")
		if(H == user)
			user << user.client.select_lang("<span class='notice'>�� ����� ��������������� ���� [parse_zone_ru(affecting.name)]!</span>","<span class='notice'>You start to restore your [parse_zone(affecting.name)]!</span>")
		else
			user << user.client.select_lang("<span class='notice'>�� ����� ��������������� [parse_zone_ru(affecting.name)] [H_name]!</span>","<span class='notice'>You start to restore [H_name] [parse_zone(affecting.name)]!</span>")
	else
		if(H == user)
			if(H.medkit_was_used > 2)
				user << user.client.select_lang("<span class='notice'>��� �������� �� ������� - ������ �� ���� ������ ������. ������ �� ��������������� ���������, � �� ����� �������� ������� ������������� �����.</span>","<span class='notice'>Medikit can't be applied again until you rest for some time.</span>")
				return
			user << user.client.select_lang("<span class='notice'>�� ����� ������ ���� [parse_zone_ru(affecting.name)]!</span>","<span class='notice'>You start to heal your [parse_zone(affecting.name)]!</span>")
		else
			if(H.medkit_was_used > 2)
				user << user.client.select_lang("<span class='notice'>�������� [H_name] �� ������� - ������ �� ���� ������ ������. ������ �� ��������������� ���������, ������� �� ������ �������� ������� ������������� �����.</span>","<span class='notice'>Medikit can't be applied again until [H_name] rest for some time.</span>")
				return
			user << user.client.select_lang("<span class='notice'>�� ����� ������ [parse_zone_ru(affecting.name)] [H_name]!</span>","<span class='notice'>You start to heal [H_name] [parse_zone(affecting.name)]!</span>")

	user.flags += IN_PROGRESS
	if(!do_after(user, 300, 1, H))
		if(user)
			user.flags &= ~IN_PROGRESS
			return
	user.flags &= ~IN_PROGRESS

	var/dice = dice6(3)
	var/healing = user.int+user.skills["medic"]
	if(user.rolld(dice, healing, 0))
		if(use == "restore")
			affecting.crippled = 0
			if(istype(affecting, /obj/item/organ/limb/l_leg) || istype(affecting, /obj/item/organ/limb/r_leg))
				H.crippled_leg -= 1
			else
				for(var/obj/screen/inventory/hand/S in H.hud_used.static_inventory)
					S.update_icon()
			if(affecting.crush_dam)
				affecting.heal_damage(1, 0, 0)
			else if(affecting.cut_dam)
				affecting.heal_damage(0, 1, 0)
			else
				affecting.heal_damage(0, 0, 1)
			if(H == user)
				user << user.client.select_lang("<span class='notice'>�� ����������� [parse_zone_ru(affecting.name)]!</span>","<span class='notice'>Now your [parse_zone(affecting.name)] is OK!</span>")
			else
				user << user.client.select_lang("<span class='notice'>�� ����������� [parse_zone_ru(affecting.name)] [H_name]!</span>","<span class='notice'>Now [parse_zone(affecting.name)] [H_name] is OK!</span>")
		else
			H.medkit_was_used++
			if(affecting.bleeding)
				affecting.bleeding = 0
			if(affecting.crush_dam)
				affecting.heal_damage(round(healing/2), 0, 0)
			else if(affecting.cut_dam)
				affecting.heal_damage(0, round(healing/2), 0)
			else
				affecting.heal_damage(0, 0, round(healing/2))
			if(H == user)
				switch(H.medkit_was_used)
					if(1)
						user << user.client.select_lang("<span class='notice'>� ��������� � ������� [parse_zone_ru(affecting.name)], ��������� ����. ���� �� ����� ������, ��� ���� ����� \"��������\" � �������.</span>","<span class='notice'>Healed [parse_zone(affecting.name)]! Medikit can be applied two more times until you won't be able to benefit from surgical help.</span>")
					if(2)
						user << user.client.select_lang("<span class='notice'>������� ��� [parse_zone_ru(affecting.name)] ���� ��������. ����� ���������� ������������ ������������� ��� ����������� ������� �����, ������ ��� � ����� �������� ����������� ���������.</span>","<span class='notice'>Healed [parse_zone(affecting.name)]! ! Medikit can be applied one more time until you won't be able to benefit from surgical help.</span>")
					else
						user << user.client.select_lang("<span class='notice'>��� ������� ��������� [parse_zone_ru(affecting.name)], �� ��� �������� �� ������� - ������ �� ���� ������ ������. ������ �� ��������������� ���������, � �� ����� �������� ������� ������������� �����.</span>","<span class='notice'>Healed [parse_zone(affecting.name)]! Medikit can't be applied again until you rest for some time.</span>")

			else
				switch(H.medkit_was_used)
					if(1)
						user << user.client.select_lang("<span class='notice'>� ��������� � ������� [parse_zone_ru(affecting.name)] [H_name], ��������� ����. ���� �� ����� ������, ��� ���� ����� \"��������\" ������� ��������.</span>","<span class='notice'>Healed [parse_zone(affecting.name)]! Medikit can be applied two more times until [H_name] won't be able to benefit from surgical help.</span>")
					if(2)
						user << user.client.select_lang("<span class='notice'>������� [parse_zone_ru(affecting.name)] [H_name] ���� ��������. ����� ���������� ������������ ������������� �������� ����������� ������� �����, ������ ��� �� ������ �������� ����������� ���������.</span>","<span class='notice'>Healed [parse_zone(affecting.name)]! Medikit can be applied one more time until [H_name] won't be able to benefit from surgical help.</span>")
					else
						user << user.client.select_lang("<span class='notice'>��� ������� ��������� [parse_zone_ru(affecting.name)] [H_name], �� ��� �������� �� ������� - ������ �� ���� ������ ������. ������ �� ��������������� ���������, ������� �� ������ �������� ������� ������������� �����.</span>","<span class='notice'>Healed [parse_zone(affecting.name)]! Medikit can't be applied again until [H_name] rest for some time.</span>")
	else
		user << user.client.select_lang("<span class='warning'>�� �� ���� ������������ [parse_zone(affecting.name)]!</span>","<span class='notice'>You weren't able to restore the [parse_zone(affecting.name)]!</span>")

	uses = max(0, uses - 1)
	if(!uses)
		qdel(src)