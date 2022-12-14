/*
Assistant
*/
/datum/job/army
	title = "Army"
	faction_s = "Army"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "Army Commander"
	selection_color = "#2E8B57"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	outfit = /datum/outfit/job/army

/datum/job/army_eliteagro
	title = "EliteAgro"
	outfit = /datum/outfit/job/army/eliteagro

/datum/outfit/job/army_eliteagro
	name = "EliteAgro"
	faction_s = "Army"

/datum/outfit/job/army/eliteagro/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/beret_ua
	suit = null
	gloves = /obj/item/clothing/gloves/fingerless
	back2 = pick(/obj/item/weapon/gun/projectile/automatic/ak74)
	backpack_contents = list(/obj/item/ammo_box/stalker/b545ap = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 2,
							/obj/item/weapon/reagent_containers/pill/stalker/aptechka/army = 1,
							/obj/item/clothing/glasses/eyepatch = 1)
	var/datum/martial_art/plasma_fist/plasma_fist = new(null)
	plasma_fist.teach(H)

/datum/outfit/job/army
	name = "Army"

/datum/outfit/job/army/pre_equip(mob/living/carbon/human/H)
	..()
	head = null
	uniform = /obj/item/clothing/under/color/switer/lolg
	suit = null
	ears = null
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	back = /obj/item/weapon/storage/backpack/stalker
	suit_store = /obj/item/weapon/gun/projectile/automatic/aksu74
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 2,
							/obj/item/weapon/reagent_containers/pill/stalker/aptechka/army = 1,
							/obj/item/weapon/stalker/bolts = 1)
	r_pocket = /obj/item/device/radio
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)
	faction_s = "Army"


/datum/job/petrovich
	title = "Petrovich"
	faction_s = "Army"
	outfit = /datum/outfit/job/petrovich
	faction = "???????"
	total_positions = -1
	locked = 1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#2E8B57"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	real_rank = "Lieutenant"

/datum/outfit/job/petrovich
	name = "Petrovich"
	faction_s = "Army"

/datum/outfit/job/petrovich/pre_equip(mob/living/carbon/human/H)
	head = null
	uniform = /obj/item/clothing/under/color/switer/lolg
	suit = null
	ears = null
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	back = /obj/item/weapon/storage/backpack/stalker/tourist
	suit_store = /obj/item/weapon/gun/projectile/automatic/aksu74
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545ap = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 2,
							/obj/item/weapon/reagent_containers/pill/stalker/aptechka/army = 1,
							/obj/item/weapon/stalker/bolts = 1)
	r_pocket = /obj/item/device/radio
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)

/datum/outfit/army  // For select_equipment
	name = "Army Soldier"

	head = /obj/item/clothing/head/kazak
	ears = null
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	back = /obj/item/weapon/storage/backpack/stalker/tourist
	back2 = /obj/item/weapon/gun/projectile/automatic/ak74
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 1,
							/obj/item/weapon/reagent_containers/pill/stalker/aptechka/army = 1)
	l_pocket = /obj/item/ammo_box/magazine/stalker/m545
	r_pocket = /obj/item/device/radio
	faction_s = "Army"

/datum/outfit/army/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(/obj/item/clothing/under/color/switer/soldier,/obj/item/clothing/under/color/switer/soldier_vdv)
	suit = /obj/item/clothing/suit/kazak
	l_pocket = null
	r_pocket = null

/datum/outfit/armycommander // For select_equipment
	name = "Army Commander"

	head = /obj/item/clothing/head/beret_ua
	uniform = /obj/item/clothing/under/color/switer/dark
	suit = null
	ears = null
	belt = /obj/item/weapon/gun/projectile/automatic/pistol/fort12
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	back = /obj/item/weapon/storage/backpack/stalker/tourist
	back2 = /obj/item/weapon/gun/projectile/automatic/ak74
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545ap = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 2,
							/obj/item/weapon/reagent_containers/pill/stalker/aptechka/army = 1,
							/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/kazaki = 1,
							/obj/item/weapon/stalker/bolts = 1)
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/ammo_box/magazine/stalker/m9x18fort
	faction_s = "Army"