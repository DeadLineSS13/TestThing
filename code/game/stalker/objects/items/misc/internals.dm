/obj/item/clothing/mask
	var/rad_protect = 0

/obj/item/clothing/mask/gas/stalker
	name = "gas mask"
	desc = "A regular plastic and rubber gas mask, used for filtering air for radioactive particles and poisonous substances. Widely used by rookies and veterans of all factions due to its universal functionality. Does not provide any physical protection."
	desc_ru = "Стандартный противогаз, предназначенный для фильтрации из воздуха радиоактивной пыли и отравляющих веществ. Широко используется как новичками, так и ветеранами всех группировок ввиду своей функциональной незаменимости. Не оснащён защитой от пуль, осколков и механических воздействий."
	icon_state = "gasmasknew"
	item_state = "gasmasknew"
	weight = 2
	rad_protect = 1
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	armor = list(melee = 15, bullet = 0, laser = 10, burn = 10, bomb = 0, bio = 10, rad = 20, electro = 0)
	ishelmet = 1

/obj/item/clothing/mask/gas/stalker/mercenary
	name = "gas mask"
	desc = "A regular plastic and rubber gas mask, used for filtering air for radioactive particles and poisonous substances. Widely used by \"Merc\" factrion. Does not provide any physical protection."
	desc_ru = "Стандартный противогаз, предназначенный для фильтрации из воздуха радиоактивной пыли и отравляющих веществ. Широко используется членами группировки 'Наемники'. Не оснащён защитой от пуль, осколков и механических воздействий."
	icon_state = "mercenary_gasmask"
	item_state = "mercenary_gasmask"
	weight = 2
	rad_protect = 1
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	armor = list(melee = 15, bullet = 0, laser = 10, burn = 10, bomb = 0, bio = 10, rad = 20, electro = 0)
	ishelmet = 1

/obj/item/clothing/mask/gas/fake
	name = "internal mask"
	desc = ""
	desc_ru = ""
	icon_state = "internal"
	weight = 0
	rad_protect = 1
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS | NODROP
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/gas/stalker/mob_can_equip(mob/M, slot, disable_warning = 0)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/H = M

	if(slot != slot_wear_mask)
		return ..()

	if(H.glasses)
		return 0

	if(H.head_hard)
		var/obj/item/clothing/C = H.head_hard
		if(C && C.ishelmet)
			return 0

	return ..()


/obj/item/weapon/tank/internals/stalker
	name = "air tanks"
	desc = "Two small tanks of air."
	desc_ru = "Два небольших баллона с воздухом."
	icon = 'icons/stalker/items.dmi'
	icon_state = "air_tanks"
	volume = 4
	weight = 2

/obj/item/weapon/tank/internals/stalker/New()
	..()
	src.air_contents.oxygen = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	src.air_contents.nitrogen = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD
	return

/obj/item/weapon/tank/internals/self_breathing
	name = "CLBS"
	desc = "Mounted close-loop breathing system."
	desc_ru = "Встроенная система замкнутного цикла дыхания."
	icon = 'icons/stalker/items.dmi'
	icon_state = "CLBS"
	volume = 70
	flags = NODROP

/obj/item/weapon/tank/internals/self_breathing/seva
	icon_state = "CLBS_seva"

/obj/item/weapon/tank/internals/self_breathing/ecolog
	icon_state = "CLBS_ecolog"

/obj/item/weapon/tank/internals/self_breathing/ecologm
	icon_state = "CLBS_ecologm"

/obj/item/weapon/tank/internals/self_breathing/psz9md
	icon_state = "CLBS_psz9md"

/obj/item/weapon/tank/internals/self_breathing/New()
	..()
	recycle()

/obj/item/weapon/tank/internals/self_breathing/process()
	recycle()

/obj/item/weapon/tank/internals/self_breathing/proc/recycle()
	src.air_contents.oxygen = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	src.air_contents.nitrogen = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD
	return