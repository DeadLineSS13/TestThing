/obj/structure/BIG_RED_BUTTON
	name = "BIG FUCKING RED BUTTON"
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "button_0"
	var/win_ticking = 0
	var/won = 0
	var/ticking_start = 0

/obj/structure/BIG_RED_BUTTON/Initialize()
	..()
	SSobj.processing.Add(src)

/obj/structure/BIG_RED_BUTTON/RU/process()
	if(win_ticking && !won)
		if(ticking_start+2150 < world.time)
			for(var/obj/structure/BIG_RED_BUTTON/B in world)
				B.won = 1
			world << "<b><font size = '10' color = 'red'>UKRAINIANS ARE VICTORIUS! VIVA LA ZELENSKY!</b></font>"
			icon_state = "button_0"
			spawn(600)
				world.Reboot()

/obj/structure/BIG_RED_BUTTON/UA/process()
	if(win_ticking && !won)
		if(ticking_start+2150 < world.time)
			for(var/obj/structure/BIG_RED_BUTTON/B in world)
				B.won = 1
			world << "<b><font size = '10' color = 'red'>RUSSIANS ARE VICTORIUS! VIVA LA PUTIN!</b></font>"
			icon_state = "button_0"
			spawn(600)
				world.Reboot()

/obj/structure/BIG_RED_BUTTON/RU

/obj/structure/BIG_RED_BUTTON/UA

/obj/structure/BIG_RED_BUTTON/RU/Click()
	if(!ishuman(usr))
		return

	if(flags & IN_PROGRESS)
		return

	if(won)
		return

	var/mob/living/carbon/human/H = usr

	if(H.faction_s == "UA")
		if(!win_ticking)
			flags += IN_PROGRESS
			if(!do_mob(H, src, 50, 1))
				flags &= ~IN_PROGRESS
				return
			flags &= ~IN_PROGRESS
			world << "<span class ='userdanger'>UKRAINIANS BEGAN CAPTURING RUSSIAN BASE!!!</span>"
			win_ticking = 1
			world << sound('sound/stalker/donbass_ukraine.ogg', channel = 999, repeat = 1)
			icon_state = "button_1"
			ticking_start = world.time
		else
			return

	else if(win_ticking)
		flags += IN_PROGRESS
		if(!do_mob(H, src, 50, 1))
			flags &= ~IN_PROGRESS
			return
		flags &= ~IN_PROGRESS
		world << "<span class ='userdanger'>RUSSIANS HAVE SUCCESSFULY REPELLED THE CAPTURE!</span>"
		win_ticking = 0
		world << sound(null, channel = 999)
		icon_state = "button_0"

/obj/structure/BIG_RED_BUTTON/UA/Click()
	if(!ishuman(usr))
		return

	if(flags & IN_PROGRESS)
		return

	if(won)
		return

	var/mob/living/carbon/human/H = usr

	if(H.faction_s == "RU")
		if(!win_ticking)
			flags += IN_PROGRESS
			if(!do_after(H, 50, 1, src))
				flags &= ~IN_PROGRESS
				return
			flags &= ~IN_PROGRESS
			world << "<span class ='userdanger'>RUSSIANS BEGAN CAPTURING THE UKRAINIAN BASE!!!</span>"
			win_ticking = 1
			world << sound('sound/stalker/donbass_russia.ogg', channel = 998, repeat = 1)
			icon_state = "button_1"
			ticking_start = world.time
		else
			return
	else if(win_ticking)
		flags += IN_PROGRESS
		if(!do_after(H, 50, 1, src))
			flags &= ~IN_PROGRESS
			return
		flags &= ~IN_PROGRESS
		world << "<span class ='userdanger'>UKRAINIANS HAVE SUCCESSFULY REPELLED THE CAPTURE!</span>"
		win_ticking = 0
		world << sound(null, channel = 998)
		icon_state = "button_0"



#define UNIFORMPICKDONBASS (pick(/obj/item/clothing/under/color/switer, /obj/item/clothing/under/color/switer/dark, /obj/item/clothing/under/color/switer/tracksuit,\
							/obj/item/clothing/under/color/switer/soldier, /obj/item/clothing/under/color/switer/soldier_vdv, /obj/item/clothing/under/color/switer/jeans_vdv,\
							/obj/item/clothing/under/color/switer/ozk))

#define LOWERSUITPICK (pickweight(list(/obj/nothing = 40, /obj/item/clothing/suit/obolochka = 30, /obj/item/clothing/suit/kazak = 20, /obj/item/clothing/suit/karatel = 10)))
#define UPPERSUITPICK (pickweight(list(/obj/nothing = 70, /obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack = 15, /obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack/coatbrown = 15)))
#define LOWERHELMETpPICK (pickweight(list(/obj/nothing = 25, /obj/item/clothing/head/steel = 50, /obj/item/clothing/head/kazak = 25)))
#define MEDICINEPICK (pickweight(list(/obj/nothing = 40, /obj/item/stack/medical/bruise_pack/bint = 30, /obj/item/weapon/storage/firstaid/stalker = 20, /obj/item/weapon/storage/firstaid/army = 10)))

/datum/job/ua
	title = "UA Storm Trooper"
	faction_s = "UA"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "UA"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ua

/datum/outfit/job/ua
	name = "UA Storm Trooper"
	faction_s = "UA"

/datum/outfit/job/ua/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "UA"
	uniform = /obj/item/clothing/under/color/switer/specops
	suit = /obj/item/clothing/suit/olympic/purga
	suit_hard = /obj/item/clothing/suit/obolochka
	head_hard = /obj/item/clothing/head/ukrop
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	belt = /obj/item/weapon/gun/projectile/automatic/veresk
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/veresk = 5, /obj/item/ammo_box/magazine/stalker/tt = 2, /obj/item/weapon/reagent_containers/hypospray/medipen/morphite = 2,\
	/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline = 2, /obj/item/stack/medical/bruise_pack/bint = 1, /obj/item/weapon/kitchen/knife/tourist = 1)

/datum/job/ua_hunter
	title = "UA Hunter"
	faction_s = "UA"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "UA"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ua_hunter

/datum/outfit/job/ua_hunter
	name = "UA Hunter"
	faction_s = "UA"

/datum/outfit/job/ua_hunter/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "UA"
	uniform = /obj/item/clothing/under/color/switer/specops
	suit = /obj/item/clothing/suit/olympic/purga
	suit_hard = /obj/item/clothing/suit/obolochka
	head_hard = /obj/item/clothing/head/ukrop
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	back2 = /obj/item/weapon/gun/projectile/automatic/saiga
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/saiga = 4, /obj/item/ammo_box/magazine/stalker/tt = 2, /obj/item/weapon/reagent_containers/hypospray/medipen/morphite = 2,\
	/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline = 2, /obj/item/stack/medical/bruise_pack/bint = 1)
	belt = /obj/item/weapon/kitchen/knife/tourist

/datum/job/ua_trooper
	title = "UA Trooper"
	faction_s = "UA"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "UA"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ua_trooper

/datum/outfit/job/ua_trooper
	name = "UA Trooper"
	faction_s = "UA"

/datum/outfit/job/ua_trooper/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "UA"
	uniform = /obj/item/clothing/under/color/switer/specops
	suit = null
	suit_hard = /obj/item/clothing/suit/kazak
	head_hard = /obj/item/clothing/head/kazak
	ears = null
	id = null
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	back2 = /obj/item/weapon/gun/projectile/automatic/ak74
	belt = /obj/item/weapon/kitchen/knife/tourist
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/m545 = 4, /obj/item/ammo_box/magazine/stalker/tt = 2, /obj/item/weapon/reagent_containers/hypospray/medipen/morphite = 2,\
	/obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator = 2, /obj/item/stack/medical/bruise_pack/bint = 1)

/datum/job/ua_bandit
	title = "UA Bandit"
	faction_s = "UA"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "UA"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ua_bandit

/datum/outfit/job/ua_bandit
	name = "UA Bandit"
	faction_s = "UA"

/datum/outfit/job/ua_bandit/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "UA"
	uniform = /obj/item/clothing/under/color/switer/tracksuit
	suit = /obj/item/clothing/suit/leatherjacket
	head_hard = /obj/item/clothing/head/ukrop
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/tt = 5, /obj/item/stack/medical/bruise_pack/bint = 1)
	belt = /obj/item/weapon/kitchen/knife/tourist


/datum/job/ru
	title = "RU Storm Trooper"
	faction_s = "RU"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "RU"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ru

/datum/outfit/job/ru
	name = "RU Storm Trooper"
	faction_s = "RU"

/datum/outfit/job/ru/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "RU"
	uniform = /obj/item/clothing/under/color/switer/soldier_vdv
	suit = /obj/item/clothing/suit/olympic/barbaris
	suit_hard = /obj/item/clothing/suit/obolochka
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	belt = /obj/item/weapon/gun/projectile/automatic/p90
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/p90 = 5, /obj/item/ammo_box/magazine/stalker/tt = 2, /obj/item/weapon/reagent_containers/hypospray/medipen/morphite = 2,\
	/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline = 2, /obj/item/stack/medical/bruise_pack/bint = 1, /obj/item/weapon/kitchen/knife/tourist = 1)

/datum/job/ru_hunter
	title = "RU Hunter"
	faction_s = "RU"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "RU"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ru_hunter

/datum/outfit/job/ru_hunter
	name = "RU Hunter"
	faction_s = "RU"

/datum/outfit/job/ru_hunter/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "RU"
	uniform = /obj/item/clothing/under/color/switer/soldier_vdv
	suit = /obj/item/clothing/suit/olympic/barbaris
	suit_hard = /obj/item/clothing/suit/obolochka
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	back2 = /obj/item/weapon/gun/projectile/automatic/saiga
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/saiga = 4, /obj/item/ammo_box/magazine/stalker/tt = 2, /obj/item/weapon/reagent_containers/hypospray/medipen/morphite = 2,\
	/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline = 2, /obj/item/stack/medical/bruise_pack/bint = 1)
	belt = /obj/item/weapon/kitchen/knife/tourist

/datum/job/ru_trooper
	title = "RU Trooper"
	faction_s = "RU"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "RU"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ru_trooper

/datum/outfit/job/ru_trooper
	name = "RU Trooper"
	faction_s = "RU"

/datum/outfit/job/ru_trooper/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "RU"
	uniform = /obj/item/clothing/under/color/switer/soldier_vdv
	suit = null
	suit_hard = /obj/item/clothing/suit/kazak
	suit = /obj/item/clothing/suit/olympic/barbaris
	head_hard = /obj/item/clothing/head/kazak
	ears = null
	id = null
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	back2 = /obj/item/weapon/gun/projectile/automatic/ak74
	belt = /obj/item/weapon/kitchen/knife/tourist
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/m545 = 4, /obj/item/ammo_box/magazine/stalker/tt = 2, /obj/item/weapon/reagent_containers/hypospray/medipen/morphite = 2,\
	/obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator = 2, /obj/item/stack/medical/bruise_pack/bint = 1)

/datum/job/ru_bandit
	title = "RU Bandit"
	faction_s = "RU"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "RU"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/ru_bandit

/datum/outfit/job/ru_bandit
	name = "RU Bandit"
	faction_s = "RU"

/datum/outfit/job/ru_bandit/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "RU"
	uniform = /obj/item/clothing/under/color/switer/tracksuit
	suit = /obj/item/clothing/suit/leatherjacket
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = null
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/tt = 5, /obj/item/stack/medical/bruise_pack/bint = 1)
	belt = /obj/item/weapon/kitchen/knife/tourist


/datum/job/ru_supersoldier
	title = "RU Supersoldier"
	faction_s = "RU"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "RU"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	outfit = /datum/outfit/job/ru_supersoldier

/datum/outfit/job/ru_supersoldier
	name = "RU Supersoldier"
	faction_s = "RU"

/datum/outfit/job/ru_supersoldier/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "RU"
	uniform = UNIFORMPICKDONBASS
	suit = /obj/item/clothing/suit/olympic/barbaris
	suit_hard = /obj/item/clothing/suit/obolochka
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/shit
	r_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/shit
	back2 = null
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/snacks/stalker/shit = 10)
	belt = /obj/item/weapon/kitchen/knife/tourist

/datum/job/ua_supersoldier
	title = "UA Supersoldier"
	faction_s = "UA"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "UA"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	outfit = /datum/outfit/job/ua_supersoldier

/datum/outfit/job/ua_supersoldier
	name = "UA Supersoldier"
	faction_s = "UA"

/datum/outfit/job/ua_supersoldier/pre_equip(mob/living/carbon/human/H)
	..()
	faction_s = "UA"
	uniform = UNIFORMPICKDONBASS
	suit = /obj/item/clothing/suit/olympic/purga
	suit_hard = /obj/item/clothing/suit/obolochka
	head_hard = /obj/item/clothing/head/ukrop
	ears = null
	id = /obj/item/device/pager
	gloves = pick(/obj/item/clothing/gloves/fingerless)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	l_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/shit
	r_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/shit
	back2 = null
	backpack_contents = list(/obj/item/weapon/reagent_containers/food/snacks/stalker/shit = 10)
	belt = /obj/item/weapon/kitchen/knife/tourist
