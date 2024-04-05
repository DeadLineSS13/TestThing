/obj/item/clothing/suit/hooded/kozhanka/strazh/atelerd
	name = "letniy kombinezon"
	desc = "Производимый ремесленниками группировки «Свобода» усиленный комбинезон сталкера. Средний армейский бронежилет плюс накладные усиливающие циркониевые элементы дают неплохую защиту от автоматных пуль и осколков на различных дистанциях. Материал костюма состоит из двух слоёв: специально обработанной кожи и ткани с асбестовой нитью. Даёт некоторую защиту от различных аномальных воздействий и радиации."
	armor = list(melee = 30, bullet = 30, laser = 30,burn = 30, bomb = 15, bio = 30, rad = 30, electro = 30)
	hoodtype = /obj/item/clothing/head/winterhood/stalker/strazh/atelerd

/obj/item/clothing/head/winterhood/stalker/strazh/atelerd
	armor = list(melee = 30, bullet = 0, laser = 30,burn = 30, bomb = 0, bio = 10, rad = 30, electro = 30)

/obj/item/clothing/suit/hooded/kozhanka/white/monolith
	name = "strange jacket"
	desc = "Плотная кожаная куртка довольно интересной раскраски. Ткань усилена очень легкими кевларовыми пластинами, что обеспечивает слегка повышенную защиту, но не замедляет носителя. Неэффективна против аномальных и других воздействий."
	icon_state = "kozhanka_mono_wh"
	item_state = "labcoat"
	hoodtype = /obj/item/clothing/head/winterhood/stalker/kozhanka_wh/monolith
	armor = list(melee = 15, bullet = 15, laser = 15,burn = 15, bomb = 0, bio = 15, rad = 0, electro = 15)

/obj/item/clothing/head/winterhood/stalker/kozhanka_wh/monolith
	armor = list(melee = 15, bullet = 0, laser = 15,burn = 15, bomb = 0, bio = 15, rad = 0, electro = 15)
	icon_state = "winterhood_kozhanka_mono_wh"

/obj/item/clothing/under/color/switer/veteran
	name_ru = "советская униформа"
	name = "soviet uniform"
	desc = ""
	icon_state = "veteran"
	item_state = "veteran"

/obj/item/clothing/under/color/switer/samoderjes
	name_ru = "офицерская униформа"
	name = "old officer uniform"
	desc = ""
	icon_state = "samoderjes"
	item_state = "samoderjes"

/obj/item/clothing/suit/olympic
	name_ru = "олимпийка"
	name = "olympic jacket"
	desc_ru = "Твоя стиляжность в безопасности."
	desc = "Your style is safe now."
	icon_state = "jacket_feyerwerk"
	blood_overlay_type = "leatherjacket"
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 1, bio = 1, rad = 0, psy = 0)
	slot_flags = SLOT_OCLOTHING
	durability = 50
	weight = 1

/obj/item/clothing/suit/olympic/veter
	icon_state = "jacket_veter"

/obj/item/clothing/suit/olympic/yogurt
	icon_state = "jacket_yogurt"

/obj/item/clothing/suit/olympic/barbaris
	icon_state = "jacket_barbaris"

/obj/item/clothing/suit/olympic/holodok
	icon_state = "jacket_holodok"

/obj/item/clothing/suit/olympic/purga
	icon_state = "jacket_purga"

/obj/item/clothing/suit/olympic/kolbasa
	icon_state = "jacket_kolbasa"

/obj/item/clothing/suit/olympic/chernika
	icon_state = "jacket_chernika"

/obj/item/clothing/suit/olympic/pidorka
	icon_state = "jacket_pidorka"

/obj/item/clothing/suit/olympic/nebo
	icon_state = "jacket_nebo"

/obj/item/clothing/suit/olympic/krest
	icon_state = "jacket_krest"

/obj/item/clothing/suit/olympic/jara
	icon_state = "jacket_jara"

/obj/item/clothing/head/fez
	name_ru = "феска"
	name = "fez"
	desc_ru = "Феска из красной потрепанной ткани. Клево."
	desc = "Very good, very epic."
	icon_state = "fez"
	icon_ground = "fez_ground"
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 0, bio = 0, rad = 0, psy = 0)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_SOFT
	equip_delay = 10
	weight = 0.25

/obj/item/clothing/head/veteran
	name_ru = "старая фуражка"
	name = "old army hat"
	desc_ru = "Ни хера ж себе. Советская фуражечка..."
	desc = "Whoa. Is that... a soviet army major hat?"
	icon_state = "veteran"
	icon_ground = "veteran_ground"
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 0, bio = 0, rad = 0, psy = 0)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_SOFT
	equip_delay = 10
	weight = 0.25

/obj/item/clothing/head/samoderjes
	name_ru = "старая фуражка"
	name = "old officer hat"
	desc_ru = "Ни хера ж себе. Фуражечка..."
	desc = "Whoa. Is that... an old officer hat?"
	icon_state = "samoderjes"
	icon_ground = "samoderjes_ground"
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 0, bio = 0, rad = 0, psy = 0)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_SOFT
	equip_delay = 10
	weight = 0.25

/obj/item/clothing/head/fashist
	name_ru = "старая фуражка"
	name = "old nazi hat"
	desc_ru = "Ни хера ж себе. Фашистская фуражечка..."
	desc = "Whoa. Is that... a nazi army officer hat?"
	icon_state = "fashist"
	icon_ground = "fashist"
	armor_new = list(crush = 0, cut = 0, imp = 0, bullet = 0, burn = 0, bio = 0, rad = 0, psy = 0)
	slot_flags = SLOT_HEAD_HARD
	armor_type = A_SOFT
	equip_delay = 10
	weight = 0.25



/obj/item/weapon/sabre
	name_ru = "сабелька"
	name = "sabre"
	desc_ru = "Руби, казак, врагов своих!"
	desc = "Slash, kazak, at your enemies!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sabre"
	icon_ground = "sabre_ground"
	item_state = "sabre"
	flags = CONDUCT | TWOHANDED
	dmgvalue = "amplitude"
	damtype = "cut"
//	str_need = 10
	add_dmg = 0
	force = 25
	throwforce = 15
	w_class = 3
	hitsound = 'sound/weapons/chop.ogg'
	attack_verb_ru = list("рубанул", "порезал")
	attack_verb = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP_ACCURATE
	weight = 1.5

/obj/item/weapon/sheath
	name = "sheath"
	name_ru = "ножны"
	icon = 'icons/obj/storage.dmi'
	icon_state = "sheath"
	w_class = 4
	weight = 0.5
	slot_flags = SLOT_BACK | SLOT_BACK2
	var/obj/item/weapon/sabre/sabre = null

/obj/item/weapon/sheath/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/sabre))
		user.unEquip(W)
		sabre = W
		W.loc = src
		icon_state = "sheath-s"
		update_icon()
		playsound(user, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
		return

	..()

/obj/item/weapon/sheath/attack_hand(mob/living/carbon/human/user)
	if((!istype(user.back, src) && !istype(user.back2, src)) && !user.is_holding(src))
		return MouseDrop(user)

	if(!Adjacent(user) || user.stat >= UNCONSCIOUS || !sabre)
		return

	if(!user.get_active_held_item())
		user.put_in_active_hand(sabre)
		sabre = null
		icon_state = "sheath"
		playsound(user, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
	else if(!user.get_inactive_held_item())
		user.put_in_inactive_hand(sabre)
		sabre = null
		icon_state = "sheath"
		playsound(user, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
	else
		src << "<span class='warning'>Your hands are full!</span>"

/obj/item/weapon/sheath/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return

	if(over_object == M)
		var/mob/living/carbon/human/H = M
		if(src != H.wear_id)
			if(M.unEquip(src))
				M.put_in_hands(src)

	else if(istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		if(!remove_item_from_storage(M))
			if(!M.unEquip(src))
				return
		M.put_in_hand(src, H.held_index)



/obj/item/weapon/sabrekazak
	name_ru = "сабелька"
	name = "sabre"
	desc_ru = "Руби, казак, врагов своих!"
	desc = "Slash, kazak, at your enemies!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "kazak"
	icon_ground = "kazak_ground"
	item_state = "kazak"
	flags = CONDUCT | TWOHANDED
	dmgvalue = "amplitude"
	damtype = "cut"
//	str_need = 10
	add_dmg = 0
	force = 25
	throwforce = 15
	w_class = 3
	hitsound = 'sound/weapons/chop.ogg'
	attack_verb_ru = list("рубанул", "порезал")
	attack_verb = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP_ACCURATE
	weight = 1.5

/obj/item/weapon/sheathkazak
	name = "sheath"
	name_ru = "ножны"
	icon = 'icons/obj/storage.dmi'
	icon_state = "sheathk"
	w_class = 4
	weight = 0.5
	slot_flags = SLOT_BACK | SLOT_BACK2
	var/obj/item/weapon/sabrekazak/sabrekazak = null

/obj/item/weapon/sheathkazak/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/sabrekazak))
		user.unEquip(W)
		sabrekazak = W
		W.loc = src
		icon_state = "sheathk-s"
		update_icon()
		playsound(user, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
		return

	..()

/obj/item/weapon/sheathkazak/attack_hand(mob/living/carbon/human/user)
	if((!istype(user.back, src) && !istype(user.back2, src)) && !user.is_holding(src))
		return MouseDrop(user)

	if(!Adjacent(user) || user.stat >= UNCONSCIOUS || !sabrekazak)
		return

	if(!user.get_active_held_item())
		user.put_in_active_hand(sabrekazak)
		sabrekazak = null
		icon_state = "sheathk"
		playsound(user, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
	else if(!user.get_inactive_held_item())
		user.put_in_inactive_hand(sabrekazak)
		sabrekazak = null
		icon_state = "sheathk"
		playsound(user, 'sound/stalker/weapons/knifeout.ogg', 40, 1, channel = "regular", time = 5)
	else
		src << "<span class='warning'>Your hands are full!</span>"

/obj/item/weapon/sheathkazak/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return

	if(over_object == M)
		var/mob/living/carbon/human/H = M
		if(src != H.wear_id)
			if(M.unEquip(src))
				M.put_in_hands(src)

	else if(istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		if(!remove_item_from_storage(M))
			if(!M.unEquip(src))
				return
		M.put_in_hand(src, H.held_index)


/obj/item/weapon/kitchen/knife/frostmorn
	name_ru = "тяжелый нож"
	name = "heavy knife"
	desc_ru = "Увесистый нож с рукоятью из красного стеклотекстолита, грубо сработанный каким-то энтузиастом на устаревшем оборудовании одного из заводов нашей необъятной родины. Несмотря на царапины, грязь и легкую ржавчину, на плоскости клинка реально различить на века вытравленную руническим шрифтом надпись 'Я ЕБЛАН'."
	desc = "That's one hell of a melee weapon. Can do some nasty slashing damage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "frostmorn"
	icon_ground = "frostmorn_ground"
	item_state = "frostmorn"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	dmgvalue = "amplitude"
	damtype = "cut"
//	str_need = 10
	add_dmg = -1
	w_class = 2
	hitsound = 'sound/weapons/chop.ogg'
	attack_verb_ru = list("ткнул", "кольнул")
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP_ACCURATE
	weight = 0.75

/obj/item/weapon/kitchen/knife/frostmorn/ledorub
	name_ru = "Ледоруб"
	desc_ru = null
	icon_state = "ledorub"
	icon_ground = "ledorub_ground"
	item_state = "ledorub"

/obj/item/weapon/kitchen/knife/frostmorn/omegasword
	name_ru = "Меч омежки"
	desc_ru = null
	icon_state = "omegasword"
	icon_ground = "omegasword_ground"
	item_state = "omegasword"

/obj/item/device/artcontainer
	icon = 'icons/stalker/items.dmi'
	icon_state = "container_toxic"
	name_ru = "Контейнер для артефактов"
	desc_ru = null
	name = null
	desc = null

/obj/item/device/artcontainer/better
	icon_state = "artcontainer_shock"
	name_ru = "Контейнер для артефактов +"
