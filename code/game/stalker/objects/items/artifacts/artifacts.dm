#define	IRA226	1
#define IPU238 	2
#define	IPO208	4

/isotope
	var/name = "Unknown"
	var/halflife = 0
	var/alpha_decoy_energy = 0.0

/isotope/proc/GetKa(var/blowout_phase, var/charge)
	return abs(sin(((halflife / alpha_decoy_energy) * blowout_phase) + charge))

//328,50027306585198598946335374141
/isotope/ra226
	name = "Radium 226"
	halflife = 1600
	alpha_decoy_energy = 4.87062

//15,67975398698419509404276621612
/isotope/pu238
	name = "Plutonium 238"
	halflife = 87.7
	alpha_decoy_energy = 5.59320


//0,5471698113207547169811320754717
/isotope/po210
	name = "Polonium 210"
	halflife = 2.9
	alpha_decoy_energy = 5.3



/obj/item/weapon/artefact
	icon = 'icons/stalker/artefacts.dmi'
	var/isotope/isotope_base = null
	var/capacity = 0
	var/charge = 0
	var/list/art_armor = list()
	var/sinxalpha = 0
	var/in_storage = 0
	var/level_s = 1
	w_class = 2
	weight = 1.5
	light_color = COLOUR_LTEMP_FLURO_COOL
	flags = CONDUCT

	var/radiation = 0
	var/brute_regen = 0
	var/burn_regen = 0
	var/stamina_regen = 0
	var/obj/effect/fakeart/phantom = null
/*
/obj/item/weapon/artefact/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/device/art_analyzer))
		user << "<span class='info'><B>Results:</B></span>"
		user << "<span class='info'>Isotope: [isotope_base.name]</span>"
		user << "<span class='info'>Charge: [charge]</span>"
		user << "<span class='info'>Alpha: [sinxalpha]</span>"
*/

/obj/item/weapon/artefact/proc/GetKA()
	return isotope_base.GetKa(/*StalkerBlowout.blowoutphase*/1, charge)

/obj/item/weapon/artefact/proc/TryKA(var/ka)
	var/difference = ka - GetKA()
	difference = abs(difference)
	var/accuracy = 100 - difference
	return accuracy


/obj/item/weapon/artefact/proc/Think(user)
	if(!charge) return 0
//	charge--
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = user
		if(radiation != 0)
			M.adjustToxLoss(radiation)
		if(brute_regen != 0)
			M.adjustBruteLoss(-brute_regen)
		if(burn_regen != 0)
			M.adjustFireLoss(-burn_regen)
		if(stamina_regen != 0)
			M.adjustEnduranceLoss(stamina_regen)
	return 1


/obj/item/weapon/artefact/New()
	..()
	isotope_base = pick(/isotope/ra226,
						/isotope/pu238,
						/isotope/po210)
	isotope_base = new isotope_base()
	sinxalpha = rand(0.1, 2)
	capacity = rand(1000, 10000)
	charge = capacity
	update_brightness()

/obj/item/weapon/artefact/process()
	update_brightness()

/obj/item/weapon/artefact/proc/update_brightness()
	if(in_storage)
		light_range = 0
		set_light()
	else
		light_range = initial(light_range)
		set_light()

/obj/item/weapon/artefact/equipped()
	update_brightness()

/obj/item/weapon/artefact/dropped()
	update_brightness()

/obj/item/weapon/artefact/on_enter_storage()
	in_storage = 1
	update_brightness()

/obj/item/weapon/artefact/on_exit_storage()
	in_storage = 0
	update_brightness()

	/////////////////////////////////////////�������������� ���������/////////////////////////////////////////
/obj/item/weapon/artefact/meduza
	name = "Jellyfish"
	desc = "Is formed in the \"Springboard\". Forms a weak protective field whose side effect is a slight radiation. The artefact is widespread and notvery valuable."
	desc_ru = "���������&#255; � �������� \"��������\". ��������� ������ �������� ����, �������� �������� �������� &#255;��&#255;���&#255; ����� ���������. �������� ������ ������������ � �������."
	icon_state = "meduza"
	art_armor = list(bullet = 5)
	radiation = 0.5
	light_color = COLOUR_LTEMP_FLURO
	level_s = 1

/obj/item/weapon/artefact/stoneflower
	name = "Stone Flower"
	desc = "Born in the \"Springboard\" anomaly. This artefact is found in only a few areas of the Zone. The bits of metallic compounds create a beautiful light play."
	desc_ru = "��������&#255; � �������� \"��������\". ����� �������� ����� ����� � �������� �������� ����. ���������&#255; ������������� ���������� ���� �������� ���� �����."
	icon_state = "stoneflower"
	art_armor = list(bullet = 8)
	radiation = 0.5
	light_range = 2
	level_s = 2

/obj/item/weapon/artefact/nightstar
	name = "Night Star"
	desc = "This wonderful artefact is formed by the \"Springboard\" anomaly. The use of the artefact demands the neutralization of deadly radiation."
	desc_ru = "���� ������������� �������� ����������&#255; ��������� \"��������\". ������������� ��������� ������� ������������� ������������ �������������� ��������&#255;."
	icon_state = "nightstar"
	art_armor = list(bullet = 15)
	radiation = 0.5
	w_class = 3
	light_range = 3
	light_color = COLOUR_LTEMP_FLURO_WARM
	level_s = 3

/obj/item/weapon/artefact/golden_fish
	name = "Golden Fish"
	desc = "An artefact formed in the \"Vortex\" anomaly. Is activated by the heat of the body. Decide what's worse: radiation or knife wounds, and chose the lesser of the two evils. In any case you can sell the artefact for good profit."
	desc_ru = "����������&#255; ��������� \"�������\". �������������&#255; ������ ����. �����, ��� ���� - �������&#255; ��� ������� ������&#255;, � ������� �� ���� ��� �������. �� ��&#255;��� ������ �������� ����� ������ �������."
	icon_state = "golden_fish"
	art_armor = list(melee = 15)
	radiation = 0.5
	w_class = 3
	light_range = 2
	light_color = COLOUR_LTEMP_FLURO
	level_s = 4

/obj/item/weapon/artefact/soul
	name = "Soul"
	desc = "Very rarely found artefact, located near the \"Whirligig\" anomaly. Only a very few manage to find this artefact, and few have even seen it. It has a nice shape and an equally nice price."
	desc_ru = "����� ����� ���������&#255; �&#255;��� � ��������� \"��������\". ����� ����� �������� ������&#255; ���� ��������, � ���� ��� ��� ������ �����. �� ����� ���&#255;���� ����� � �� ����� ���&#255;���� ����."
	icon_state = "soul"
	art_armor = list(melee = -20, bullet = -20)
	brute_regen = 5
	burn_regen = 5
	w_class = 3
	light_range = 2
	light_color = COLOUR_LTEMP_FLURO
	level_s = 4

	/////////////////////////////////////////������� ���������/////////////////////////////////////////

/obj/item/weapon/artefact/sparkler
	name = "Sparkler"
	desc = "Found near the \"Electro\" type of anomaly. Quite widespread and inexpensive artefact. But still it is valued among the researchers in the Zone for its qualities."
	desc_ru = "��������&#255; ����� �������� ���� \"�������\". �������� ��������������� � ��������� ��������. ��� �� ����� ������&#255; ����� �������������� ���� �� ��� ��������."
	icon_state = "sparkler"
	art_armor = list(electro = -20)
	stamina_regen = 6
	light_color = COLOUR_LTEMP_SKY_CLEAR
	level_s = 1

/obj/item/weapon/artefact/flash
	name = "Flash"
	desc = "\"Electro\" sometimes births this artefact. Stalkers readily use it because of its good qualities. Not a bad price and a good external look make this artefact appealing to collectors."
	desc_ru = "\"�������\" ������� ��������� ���� ��������. �������� ���������� ��� � ������� ������ ��-�� ��� �������� �������. �������&#255; ���� � ���&#255;���� ������� ��� ������ ��� ���������� ��&#255; ��������������."
	icon_state = "flash"
	art_armor = list(electro = -20)
	stamina_regen = 12
	light_color = COLOUR_LTEMP_SKY_CLEAR
	level_s = 2

/obj/item/weapon/artefact/moonlight
	name = "Moonlight"
	desc = "Degenerate case of the activity of the \"Electro\" anomaly. It seems that such a wonderful round form is created when the anomaly is subjected to thermal influences. Expensive artefact."
	desc_ru = "����������� ������ ���������� �������� \"�������\". ������, ����� ������������� �������� ����� ����� ��������, ���� ����������� �������� ����������������. ������� ��������."
	icon_state = "moonlight"
	art_armor = list(electro = -20)
	stamina_regen = 18
	light_range = 3
	light_color = COLOUR_LTEMP_SKY_CLEAR
	level_s = 2

/obj/item/weapon/artefact/pustishka
	name = "Fire battery"
	desc = "When wearing this artefact the denaturalization of proteins happens slower. In other words, the flesh is able to endure higher temperatures and burns less. In itself it is an expensive and rare thing."
	desc_ru = "��� ������� ����� ��������� ����������&#255; ������ �������� ���������. ������� �������, ����� ���������� � ������� ������������ � ������ ��������. ���� �� ���� ��� ������&#255; � ���������&#255; ����."
	icon_state = "pustishka"
	art_armor = list(burn = 50)
	w_class = 3
	light_range = 1
	light_color = COLOUR_LTEMP_SKY_CLEAR
	level_s = 4

/obj/item/weapon/artefact/battery
	name = "Electro battery"
	desc = "The origin of this object is shrouded in scientific mystery. It's clear that it?s made in part by di-electric elements, but science does not know the physical conditions in which it is formed."
	desc_ru = "������������� ���� ���� ������� ������� ������� �����. ���&#255;���, ��� � ��� ������ ����&#255;� ��������������� ��������, �� ��� ����� ���������� ������&#255;� �� ����������&#255; - ����� �� ��������."
	icon_state = "battery"
	art_armor = list(electro = 50)
	w_class = 3
	light_range = 1
	light_color = COLOUR_LTEMP_SKY_CLEAR
	level_s = 4

	/////////////////////////////////////////�������� ���������/////////////////////////////////////////

/obj/item/weapon/artefact/droplet
	name = "Droplet"
	desc = "Is formed in the \"Burner\". Appears as a blackened droplet-like formation with glossy cracked surface. Removes radiation slightly."
	desc_ru = "����������&#255; ��������� \"�����\" ��� ������� ������������. ������ ����&#255;��� ��� ����������� ����������� ����������� � ��&#255;������ ������������, �������� ���������. ����� ������� ��������."
	icon_state = "droplet"
	art_armor = list(rad = 10)
	radiation = -1
	stamina_regen = -3
	level_s = 1

/obj/item/weapon/artefact/fireball
	name = "Fireball"
	desc = "Crystallizes in the anomaly \"Burner\". Fights well with radioactivity, though the heightened rate of energy exchange wears out the muscles of the moving apparatus. Won't be able to run for long. artefact emits heat."
	desc_ru = "����������������&#255; � �������� \"�����\". ������ ������&#255; � ����������������, ���&#255; ���������� ����������� ���������� ����� ������������� ��������. ����� ������ �� ��������&#255;. �������� �������� �����."
	icon_state = "fireball"
	art_armor = list(rad = 30)
	radiation = -2
	stamina_regen = -3
	light_range = 3
	light_color = COLOUR_LTEMP_CANDLE
	level_s = 2

/obj/item/weapon/artefact/crystal
	name = "Crystal"
	desc = "Is created when heavy metals fall into the \"Burner\". This artefact eliminates radiation wonderfully. It is highly valued by stalkers and hard to find."
	desc_ru = "���������&#255; ��� ��������� �&#255;������ ������� � �������� \"�����\". ���� �������� ������������ ������� ��������. ����� �������� ������ ������&#255; ����������, � ���� ��� ��� ����� ������."
	icon_state = "crystal"
	art_armor = list(rad = 50)
	radiation = -3
	stamina_regen = -3
	w_class = 3
	light_range = 1
	light_color = COLOUR_LTEMP_CANDLE
	level_s = 3

/obj/item/weapon/artefact/maminibusi
	name = "Mama's Beads"
	desc = "Anomalic formation, resembling beads, quite rare and expensive. Gives protection against projectiles and bullets. Doesn't irradiate the user."
	desc_ru = "���������� �����������, �� ����� ������������ ����, �������� ������ � �������. ��� ������ �� ����. �� �������� �������&#255;."
	icon_state = "mamini_busi"
	art_armor = list(bullet = 30)
	w_class = 3
	light_range = 1
	light_color = COLOUR_LTEMP_CANDLE
	level_s = 4

	/////////////////////////////////////////������ ���������/////////////////////////////////////////

/obj/item/weapon/artefact/kolobok
	name = "Kolobok"
	desc = "When you hold this mystery of the Zone in your hands, you feel how your skin becomes tougher and less sensitive. You can still shoot through it with a bullet, but it's much more difficult to cut through."
	desc_ru = "����� ������� ��� ������� ���� � �����, ����������, ��� ���� ������� � ���������&#255; ����� ��������������. ������� ����� � �� ��� �����, � ��� �������� - ������� �������."
	icon_state = "kolobok"
	art_armor = list(melee = 30)
	w_class = 3
	level_s = 4

/obj/item/weapon/artefact/ezh
	name = "Ezh"
	desc = "The anomaly \"Burnt Fuzz\" very rarely gives rise to this artefact. Blood pressure rises, the body gets rid of a large amount of red blood cells. But along with them the stored radiation leaves the body as well."
	desc_ru = "�������&#255; \"������ ������\" ����� ����� ��������� ����� ��������. ���������&#255; ����&#255;��� ��������, �������� ������&#255;���&#255; �� �������� ���������� ������� ����&#255;��� �����. �� ������ � ���� �� ��������� ������� ����������� ���������."
	icon_state = "ezh"
	art_armor = list(rad = 30)
	radiation = -5
	brute_regen = -1
	w_class = 3
	level_s = 4

/obj/item/weapon/artefact/plenka
	name = "Plenka"
	desc = "This artefact is so rare that many researchers can't even imagine that such a substance can exist in a natural setting. Emits acidic chemical components."
	desc_ru = "���� �������� ��������� �����, ��� ������ ������������� ���� �� �����������&#255;, ��� ����&#255; ���������&#255; ����� ������������ � ������������ ������&#255;�. ��������� ����� ���������� ����������. "
	icon_state = "plenka"
	art_armor = list(bio = 50)
	w_class = 3
	level_s = 4

	//��&#255;�
/obj/item/weapon/storage/belt/stalker
	name = "artefact belt"
	desc = "Special belt designated to contain most artefacts."
	desc_ru = "����������� ��&#255;� ��&#255; ����������."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	max_w_class = 3
	weight = 2
	storage_slots = 3

/obj/item/weapon/storage/belt/stalker/artefact_belt
	var/thinkrate = 100
	can_hold = list(
													//�������������� ���������
		/obj/item/weapon/artefact/meduza,
		/obj/item/weapon/artefact/stoneflower,
		/obj/item/weapon/artefact/nightstar,
		/obj/item/weapon/artefact/golden_fish,
		/obj/item/weapon/artefact/soul,

													//������� ���������
		/obj/item/weapon/artefact/sparkler,
		/obj/item/weapon/artefact/flash,
		/obj/item/weapon/artefact/moonlight,
		/obj/item/weapon/artefact/battery,
		/obj/item/weapon/artefact/pustishka,

													//�������� ���������
		/obj/item/weapon/artefact/droplet,
		/obj/item/weapon/artefact/fireball,
		/obj/item/weapon/artefact/crystal,
		/obj/item/weapon/artefact/maminibusi,

													//������ ���������
		/obj/item/weapon/artefact/kolobok,
		/obj/item/weapon/artefact/ezh,
		/obj/item/weapon/artefact/plenka

		)

/obj/item/weapon/storage/belt/stalker/artefact_belt/proc/Think()
	for(var/obj/item/weapon/artefact/A in contents)
		A.Think(loc)
	sleep(thinkrate)
	Think()

/obj/item/weapon/storage/belt/stalker/artefact_belt/handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
	if(..(W, prevent_warning, user) && istype(W, /obj/item/weapon/artefact))
		var/obj/item/weapon/artefact/Artefact = W
		var/mob/living/carbon/mob = loc
		for(var/i=1,i<=Artefact.art_armor.len,i++)
			var/armortype = Artefact.art_armor[i]
			if(!mob.global_armor.Find(armortype))
				mob.global_armor.Add(armortype)
			mob.global_armor[armortype] += Artefact.art_armor[armortype]
		return 1
	return 0

/obj/item/weapon/storage/belt/stalker/artefact_belt/remove_from_storage(obj/item/W, atom/new_location, burn = 0)
	if(..(W, new_location, burn) && istype(W, /obj/item/weapon/artefact))
		var/obj/item/weapon/artefact/Artefact = W
		var/mob/living/carbon/mob = loc
		for(var/i=1,i<=Artefact.art_armor.len,i++)
			var/armortype = Artefact.art_armor[i]
			if(!mob.global_armor.Find(armortype))
				mob.global_armor.Add(armortype)
			mob.global_armor[armortype] -= Artefact.art_armor[armortype]
		return 1
	return 0

/obj/item/weapon/storage/belt/stalker/artefact_belt/small_artefact_belt
	name = "small artefact belt"
	desc = "Special belt designated to contain most artefacts."
	desc_ru = "����������� ��&#255;� ��&#255; ����������."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "fannypack_black"
	item_state = "artefacts"
	storage_slots = 2


/obj/item/weapon/artefact/firefly
	name = "firefly"
	desc_ru = "������&#255;� �������� � ������������ ����� ���&#255;��, �����&#255;&#255; ����������� ������ � ������� ����� �������, � ����� ���������&#255; �������������� ��������. �������� ��������� �� ������ ��������� �� ���� �&#255;������������. � ���������, �������� ����������&#255; ������ �����. ������������.."
	desc = "Firefly interacts with fields unknown to science, considerably speeding up regeneration of tissue and organs in living beings, as well as normalizing metabolic processes. This artefact can literally get a badly wounded stalker back on his feet in seconds. Unfortunately, Firefly is extremely rare. Emits radiation."
	icon_state = "firefly"
	art_armor = list()
	radiation = 5
	level_s = 4

/obj/item/weapon/artefact/bubble
	name = "bubble"
	desc_ru = "�������� ���������&#255;�� ����� ��������� ����� ����������� ������������ �������, ���������� ����� �����. �����&#255;�� ������������ ��������, ��������� �������������� ������������� ������� � ��������� ��������; ������-���� ������������ ����������&#255; ������� �������� �� ��&#255;�����. ����� ������� ������������� ���������&#255; �������� �������."
	desc = "A compound of several hollow organic formations, this artefact emits a gaseous substance that can neutralize radioactive particles inside the body without harming it. Because of its effectiveness, this artefact is in great demand."
	icon_state = "bubble"
	art_armor = list()
	radiation = -3
	level_s = 2

/obj/item/weapon/artefact/mica
	name = "mica"
	desc_ru = "�������&#255; ��������� �������� �������� ����� �������� ��� ���������, ������������� ������ ���������� �������. � ���������� ���������&#255; �������������� ������ ������. �������� ������� � ����������. ������� ��������� �� ��&#255;�� ����������� ��������� ��������� �� �������� ������� ������� � ������� ���� � ���������� ��������, ������ ��� ���������� ������� �������� � ���� ��� ����&#255; �������� ���������&#255; ���������� ������� ��-�� ���������� ������������. ���� ������&#255;. ������� � ��������� ���&#255;��&#255;�� ������� �����������."
	desc = "Anomaly \"Fruit Punch\" is able to create such an artefact at the rarest, most extreme collection of physical conditions. The result is a semi-transparent, hard object. A rare and expensive artefact."
	icon_state = "mica"
	art_armor = list(laser = 10, bio = 10)
	radiation = 3
	level_s = 3