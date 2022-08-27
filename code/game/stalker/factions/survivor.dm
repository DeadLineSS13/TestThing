/*
Assistant
*/
/datum/job/assistant
	title = "Stalker"
	faction_s = "Loners"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	outfit = /datum/outfit/job/assistant

/datum/job/oldstalker
	title = "Old Stalker"
	faction_s = "Loners"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	activated = 0
	outfit = /datum/outfit/job/oldstalker

/*/datum/job/assistant/get_access()
	if((config.jobs_have_maint_access & ASSISTANTS_HAVE_MAINT_ACCESS) || !config.jobs_have_minimal_access) //Config has assistant maint access set
		. = ..()
		. |= list(access_maint_tunnels)
	else
		return ..()*/

/datum/job/assistant/config_check()
	return 1

/datum/outfit/job/assistant
	name = "Stalker"
	faction_s = "Loners"

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = UNIFORMPICK
	id = /obj/item/device/pager
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots/warm
	back = /obj/item/weapon/storage/backpack/stalker
	backpack_contents = list()

/datum/outfit/stalker  // For select_equipment
	name = "Stalker"
	uniform = /obj/item/clothing/under/color/switer/stalker/dark
	id = /obj/item/device/pager
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list()
	back = /obj/item/weapon/storage/backpack/stalker
	faction_s = "Loners"

/datum/outfit/job/oldstalker
	name = "Old Stalker"

/datum/outfit/job/oldstalker/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = UNIFORMPICK
	suit = null
	ears = null
	id = /obj/item/device/pager
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1, /obj/item/ammo_box/magazine/stalker/m545 = 2, /obj/item/weapon/reagent_containers/pill/stalker/aptechka/civilian = 1, /obj/item/spacecash/c5000 = 1, /obj/item/device/flashlight/seclite = 1)
	back = /obj/item/weapon/storage/backpack/stalker
	l_pocket = /obj/item/weapon/stalker/bolt
	r_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva

/datum/outfit/stalkervolk  // For select_equipment
	name = "Old Stalker"
	uniform = /obj/item/clothing/under/color/switer
	suit = null
	ears = null
	id = /obj/item/device/pager
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1, /obj/item/ammo_box/magazine/stalker/m545 = 2, /obj/item/weapon/reagent_containers/pill/stalker/aptechka/civilian = 1, /obj/item/spacecash/c5000 = 1)
	suit_store = /obj/item/weapon/gun/projectile/automatic/ak74
	back = /obj/item/weapon/storage/backpack/stalker
	l_pocket = /obj/item/weapon/stalker/bolt
	r_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva
	faction_s = "Loners"


/datum/job/vodila
	title = "Driver"
	faction_s = "Army"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	activated = 0
	outfit = /datum/outfit/job/driver

/datum/outfit/job/driver
	name = "Old Stalker"

/datum/outfit/job/driver/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = /obj/item/clothing/under/color/switer/soldier_vdv
	suit = null
	ears = null
	id = /obj/item/device/pager
	mask = /obj/item/clothing/mask/gas/stalker
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/m545 = 4, /obj/item/device/flashlight/seclite = 1)
	back = /obj/item/weapon/storage/backpack/stalker
	back2 = /obj/item/weapon/gun/projectile/automatic/ak74
	l_pocket = /obj/item/army_car_keys
	r_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva

/datum/outfit/driver  // For select_equipment
	name = "Driver"
	uniform = /obj/item/clothing/under/color/switer/soldier_vdv
	suit = null
	ears = null
	id = /obj/item/device/pager
	mask = /obj/item/clothing/mask/gas/stalker
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/m545 = 4, /obj/item/device/flashlight/seclite = 1)
	back = /obj/item/weapon/storage/backpack/stalker
	back2 = /obj/item/weapon/gun/projectile/automatic/aksu74
	l_pocket = /obj/item/army_car_keys
	r_pocket = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva
	faction_s = "Army"
