/*
/obj/item/clothing/head/New()
	..()
	sleep(5)
	if(nvg)
		if(nvg.colour_matrix == NIGHTVISION_MATRIX_I)
			modifications += "visor"
		else if(nvg.colour_matrix == NIGHTVISION_MATRIX_II)
			modifications += "visor"
*/

/obj/item/clothing/head/mob_can_equip(mob/M, slot, disable_warning = 0)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/C = M

	if(ishelmet)
		if(C.wear_mask || C.glasses)
			return 0

	if(slot != slot_head)
		return ..()

	if(!(flags_cover & HEADCOVERSMOUTH))
		return ..()

	if(!(C.wear_mask) || !(istype(C.wear_mask, /obj/item/clothing/mask/gas)))
		return ..()

	return 0

/obj/item/clothing
	equip_delay = 30
	var/ishelmet = 0
	var/face_protect = 0
	var/eyes_protect = 0

/obj/item/clothing/equipped(mob/user, slot)
	..()
	if(!ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user

	if(slot == slot_head_hard || slot == slot_wear_mask)
		if(ishelmet && H.screens["fov"])
			H.screens["fov"].icon_state = "helmet"
	else if(!H.head_hard && !H.wear_mask)
		if(ishelmet && H.screens["fov"])
			H.screens["fov"].icon_state = "combat"
		if(nvg)
			if(nvg.active)
				nvg.TurnOff(user)
	if(H.client)
		H.client.fovProcess()

/obj/item/clothing/head/item_action_slot_check(slot, mob/user)
	if(slot == slot_head || slot == slot_head_hard)
		return 1

/obj/item/clothing/mask/balaclava
	name_ru = "балаклава"
	name = "balaclava"
	desc_ru = ""
	desc = ""
	icon_state = "balaclava"
	item_state = "balaclava"
	flags_inv = HIDEFACIALHAIR | HIDEHAIR
	equip_delay = 10
	weight = 0.3
	ignore_maskadjust = 0

/obj/item/clothing/mask/balaclava/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/head/gopcap
	name = "Сap"
	desc = "Модная у чётких пацанов кепка."
	icon_state = "gopcap"
	item_state = "gopcap"
	flags_inv = HIDEHAIR|HIDEFACIALHAIR
	weight = 0.3

/obj/item/clothing/head/soft/jacknoircap
	name = "Сap"
	desc = "Потрепанная кепка машиниста. Чух-чух!"
	icon_state = "jacknoirsoft"
	item_color = "jacknoir"
	item_state = "greysoft"
	weight = 0.3

/obj/item/clothing/head/beret_ua
	name = "military beret"
	name_ru = "военный берет"
	desc = "Оффицерский берет с миниатюрной версией украинского флага."
	icon_state = "beret_ua"
	slot_flags = SLOT_HEAD_HARD
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	equip_delay = 10
	weight = 0.3

/obj/item/clothing/mask/gas/stalker
	name = "old gas mask"
	name_ru = "старый противогаз"
	desc_ru = "Древний, советский противогаз, предназначенный для фильтрации из воздуха радиоактивной пыли и отравляющих веществ. Вы сомневаетесь в его надежности."
	desc = "An old, soviet rubber gas mask, used for filtering air for radioactive particles and poisonous substances. You have some serious concerns about it's reliability."
	icon_state = "gp5"
	icon_ground = "gp5_ground"
	item_state = "gp5"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags_inv = HIDEFACIALHAIR | HIDEHAIR
	armor_type = A_SOFT
	armor_new = list(crush = 1, cut = 1, imp = 1, bullet = 1, burn = 5, bio = 5, rad = 5, psy = 0)
	burn_state = FIRE_PROOF
	unacidable = 1
	durability = 400
	weight = 2
	//МОДИФИКАЦИИ//
	modifications = list("padding_head" = 0, "material_head" = 0, "visor_head" = 0)

/obj/item/clothing/mask/gas/stalker/mercenary
	name = "western gas mask"
	name_ru = "западный противогаз"
	desc_ru = "Раньше такие использовались западным спецназом. Должен быть достаточно эффективным."
	desc = "US army used those in the past. Should be effective enough."
	icon_state = "mercenary_gasmask"
	icon_ground = "mercenary_gasmask_ground"
	item_state = "mercenary_gasmask"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags_inv = HIDEFACIALHAIR
	armor_type = A_SOFT
	armor_new = list(crush = 2, cut = 2, imp = 2, bullet = 2, burn = 10, bio = 10, rad = 10, psy = 0)
	burn_state = FIRE_PROOF
	unacidable = 1
	durability = 400
	weight = 2
	//МОДИФИКАЦИИ//
	modifications = list("padding_head" = 0, "material_head" = 0, "visor_head" = 0)


/obj/item/clothing/mask/gas/clownartifact
	name = "weird mask"
	name_ru = "необычная маска"
	desc = "You want to wear it."
	desc_ru = "Ты хочешь надеть ее."
	icon_state = "clown"
	item_state = "clown_hat"
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags = BLOCKFACIALHAIR
	armor_type = A_SOFT
	armor_new = list(crush = 3, cut = 3, imp = 3, bullet = 3, burn = 3, bio = 100, rad = 100, psy = 0)
	unacidable = 1
	equip_delay = 10
	durability = 10000
	weight = 0.5


/obj/item/clothing/head/steel
	name_ru = "каска-афганка"
	name = "old helmet"
	desc_ru = "Кто-то соскреб всю краску."
	desc = "Somebody removed all the paint from it."
	icon_state = "kaska"
	icon_ground = "kaska_ground"
	armor_new = list(crush = 6, cut = 6, imp = 6, bullet = 6, burn = 6, bio = 0, rad = 0, psy = 10)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_HARD
	flags_inv = HIDEHAIR
	flags_cover = 0
	unacidable = 1
	durability = 100
	equip_delay = 20
	weight = 2
	ismetal = 1
	modifications = list("material_head" = 0)

/obj/item/clothing/head/kazak
	name_ru = "баллистический шлем \"Казак\""
	name = "'Kazak' ballistic helmet"
	desc_ru = "Баллистический шлем Российского производства. Наверное, спасет от пистолетной пули."
	desc = "A russian ballistic helmet. Can protect from the pistol calibers, probably."
	icon_state = "kazak"
	icon_ground = "kazak_ground"
	armor_new = list(crush = 12, cut = 12, imp = 12, bullet = 12, burn = 12, bio = 0, rad = 0, psy = 5)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_HARD
	flags_inv = HIDEHAIR
	flags_cover = 0
	unacidable = 1
	durability = 100
	equip_delay = 20
	weight = 1.5
	ismetal = 1
	modifications = list("material_head" = 0)

/obj/item/clothing/head/kazak/pindos
	name_ru = "баллистический шлем \"Пиндос\""
	name = "'Pindos' ballistic helmet"
	desc_ru = "Баллистический шлем Американского производства. Наверное, спасет от пистолетной пули."
	desc = "An american ballistic helmet. Can protect from the pistol calibers, probably."
	icon_state = "pindos"

/obj/item/clothing/head/hawk
	name_ru = "баллистический шлем \"Ястреб\""
	name = "'Hawk' ballistic helmet"
	desc_ru = "Клюв и крылья в набор не входят."
	desc = "Beak and wings not included."
	icon_state = "hawk"
	icon_ground = "hawk_ground"
	armor_new = list(crush = 18, cut = 18, imp = 18, bullet = 18, burn = 18, bio = 10, rad = 10, psy = 5)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_HARD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	unacidable = 1
	durability = 100
	weight = 2.5
	ishelmet = 1
	ismetal = 1
	modifications = list("material_head" = 0)

/obj/item/clothing/head/karatel
	name_ru = "бронешлем \"Каратель\""
	name = "'Karatel' armored helmet"
	desc_ru = "Тачаночка..."
	desc = "Tachanka..."
	icon_state = "karatel"
	icon_ground = "karatel_ground"
	armor_new = list(crush = 23, cut = 23, imp = 23, bullet = 23, burn = 23, bio = 0, rad = 10, psy = 10)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_HARD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	unacidable = 1
	durability = 100
	weight = 3.5
	ishelmet = 1
	ismetal = 1
	modifications = list("material_head" = 0)

/obj/item/clothing/head/heracles
	name_ru = "бронешлем \"Геракл\""
	name = "'Heracles' armored helmet"
	desc_ru = "Шлем-то выдержит - но выдержит ли твоя шея?"
	desc = "It can stop bullets - but can it stop your neck from being broken?"
	icon_state = "heracles"
	icon_ground = "heracles_ground"
	armor_new = list(crush = 34, cut = 34, imp = 34, bullet = 34, burn = 34, bio = 10, rad = 10, psy = 10)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_HARD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	unacidable = 1
	durability = 100
	weight = 4
	ishelmet = 1
	ismetal = 1
	modifications = list("material_head" = 0)

/obj/item/clothing/head/welder
	name_ru = "сварочный головной убор"
	name = "welding headgear"
	desc_ru = ""
	icon_state = "welder"
	icon_ground = "welder_ground"
	item_state = "welder"
	armor_new = list(crush = 2, cut = 2, imp = 2, bullet = 2, burn = 5, bio = 5, rad = 0, psy = 10)
	slot_flags = SLOT_HEAD
	armor_type = A_SOFT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flash_protect = 2
	tint = 2
	unacidable = 1
	durability = 100
	weight = 2
	ishelmet = 1
	ismetal = 1
	modifications = list("material_head" = 0)

/obj/item/clothing/head/ukrop
	name_ru = "патриотичная бандана"
	name = "patriotic headband"
	desc = "ЩЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕ НЕ ВМЕЕЕЕЕЕЕРЛАААААА"
	icon_state = "ukrop"
	icon_ground = "ukrop_ground"
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 0, bio = 0, rad = 0, psy = 0)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_SOFT
	equip_delay = 10
	weight = 0.1

/obj/item/clothing/head/muslim
	name_ru = "тюрбан"
	name = "turban"
	desc_ru = "Аллаху Акбар."
	desc = "Allahu Akbar."
	icon_state = "muslim"
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 0, bio = 0, rad = 0, psy = 0)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_SOFT
	weight = 0.1