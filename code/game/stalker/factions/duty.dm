/*
Assistant
*/
/datum/job/duty
	title = "Duty"
	faction_s = "Duty"
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "Major"
	selection_color = "#601919"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	limit_per_player = 4
	outfit = /datum/outfit/job/assistant// /datum/outfit/job/duty

/datum/outfit/job/duty
	name = "Duty"
	faction_s = "Duty"

/datum/outfit/job/duty/pre_equip(mob/living/carbon/human/H)
	..()
	head = null
	uniform = UNIFORMPICK
	ears = null
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	suit_store = /obj/item/weapon/gun/projectile/automatic/aksu74
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1,
							/obj/item/device/flashlight/seclite = 1)
	r_pocket = /obj/item/weapon/stalker/bolts
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)

/datum/outfit/duty  // For select_equipment
	name = "Duty Soldier"

	head = null
	ears = null
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	back = /obj/item/weapon/storage/backpack/stalker/tourist
	suit_store = /obj/item/weapon/gun/projectile/automatic/aksu74
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 2,)
	r_pocket = /obj/item/weapon/stalker/bolts
	faction_s = "Duty"

/datum/outfit/duty/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = UNIFORMPICK
	back2 = /obj/item/weapon/gun/projectile/automatic/aksu74
	ears = null
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)
	r_pocket =/obj/item/weapon/stalker/bolts

/datum/job/barman2
	title = "Barman2"
	faction_s = "Loners"
	locked = 1
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#601919"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	outfit = /datum/outfit/job/barman2
	//faction_s = "Одиночки"

/datum/outfit/job/barman2
	name = "Barman"
	faction_s = "Traders"

/datum/outfit/job/barman2/pre_equip(mob/living/carbon/human/H)
	..()
	head = null
	uniform = /obj/item/clothing/under/color/switer/dark
	ears = null
	belt = null
	id = /obj/item/device/pager
	back = null

/datum/job/duty_lieutenant
	title = "Duty Lieutenant"
	faction_s = "Duty"
	faction = "Station"
	total_positions = 2
	locked = 1
	spawn_positions = 2
	supervisors = "Major"
	selection_color = "#601919"
	whitelist_only = 1
	limit_per_player = 2
	outfit = /datum/outfit/job/duty_lieutenant
	real_rank = "Lieutenant"

/datum/outfit/job/duty_lieutenant
	name = "Duty Lieutenant"
	faction_s = "Duty"

/datum/outfit/job/duty_lieutenant/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/steel
	uniform = UNIFORMPICK
	belt = /obj/item/weapon/kitchen/knife/tourist
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/device/pager
	suit_store = /obj/item/weapon/gun/projectile/shotgun/ithaca
	backpack_contents = list(/obj/item/device/flashlight/seclite = 1)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	r_pocket = /obj/item/weapon/stalker/bolts
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)