/datum/job/monolith
	title = "Monolith"
	faction_s = "Monolith"
	faction = "Monolith"
	total_positions = 4
	spawn_positions = 4
	supervisors = "Major"
	selection_color = "#601919"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 0
	activated = 0
	//limit_per_player = 4
	outfit = /datum/outfit/job/monolith// /datum/outfit/job/duty

/datum/outfit/job/monolith
	name = "Monolith"
	faction_s = "Monolith"

/datum/outfit/job/monolith/pre_equip(mob/living/carbon/human/H)
	..()
	head = null
	uniform = UNIFORMPICK
	suit = /obj/item/clothing/suit/hooded/kombez/monolith
	ears = null
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	suit_store = null
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/berettam38 = 1,
							/obj/item/device/flashlight/seclite = 1)
	r_pocket = /obj/item/weapon/stalker/bolts
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)

/datum/outfit/monolith  // For select_equipment
	name = "Monolith Soldier"

	head = null
	suit = /obj/item/clothing/suit/hooded/kombez/monolith
	ears = null
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	back = /obj/item/weapon/storage/backpack/stalker
	suit_store = null
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/magazine/stalker/berettam38 = 1,
							/obj/item/device/flashlight/seclite = 1,)
	r_pocket = /obj/item/weapon/stalker/bolts
	faction_s = "Monolith"

/datum/outfit/monolith/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = UNIFORMPICK
	ears = null
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)
	r_pocket = /obj/item/weapon/stalker/bolts

/datum/job/monolith_hegumen
	title = "Monolith Hegumen"
	faction_s = "Monolith"
	faction = "Monolith"
	total_positions = 2
	locked = 1
	spawn_positions = 2
	supervisors = "Monolith"
	selection_color = "#601919"
	whitelist_only = 1
	limit_per_player = 2
	activated = 0
	outfit = /datum/outfit/job/monolith_hegumen
	real_rank = "Lieutenant"

/datum/outfit/job/monolith_hegumen
	name = "Monolith Hegumen"
	faction_s = "Monolith"

/datum/outfit/job/monolith_hegumen/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/steel
	uniform = UNIFORMPICK
	suit = /obj/item/clothing/suit/hooded/kombez/monolith
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	suit_store = /obj/item/weapon/gun/projectile/shotgun/ithaca
	backpack_contents = list(/obj/item/device/flashlight/seclite = 1)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	r_pocket = /obj/item/weapon/stalker/bolts
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)