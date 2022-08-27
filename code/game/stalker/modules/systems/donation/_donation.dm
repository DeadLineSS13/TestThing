var/list/donations = list()

proc/load_donations()
	donations = file2list("data/donations.txt")
	if(!donations.len)
		donations = null

/client
	var/list/list_of_donations = list()

/client/proc/get_donation(name)
	for(var/datum/donation/D in list_of_donations)
		if(D.name == name)
			return D

/client/proc/give_donation(name)
	switch(name)
		if("Custom Beer")
			list_of_donations.Add(new /datum/donation/custom_beer)
		if("Custom Item")
			list_of_donations.Add(new /datum/donation/custom_item(ckey))
		if("Trap")
			list_of_donations.Add(new /datum/donation/trap)
		if("Character Slot")
			list_of_donations.Add(new /datum/donation/char_slot)
		if("Gay Hair")
			list_of_donations.Add(new /datum/donation/gay_hair)

/client/proc/load_donations()
	if(!donations)
		return

	for(var/line in donations)
		var/list/D = text2list(line, " - ")
		if(D[1] == ckey)
			give_donation(D[2])




/datum/donation
	var/name = "Donation"
	var/list/items


/datum/donation/custom_beer
	name = "Custom Beer"

/datum/donation/custom_item
	name = "Custom Item"
	items = list()

/datum/donation/custom_item/New(ckey)
	switch(ckey)
		if("vallat")
			items = list(/datum/loadout_equip/donate/atelerd)
		if("ambrosiafumari")
			items = list(/datum/loadout_equip/donate/eyepatch, /datum/loadout_equip/donate/samoderjes, /datum/loadout_equip/donate/samoderjesuniform, /datum/loadout_equip/donate/sabrekazak, /datum/loadout_equip/donate/sheathkazak)
//		if("megaomega005")
//			items = list(/datum/loadout_equip/donate/fashist)
		if("icecactus")
			items = list(/datum/loadout_equip/donate/sunglasses, /datum/loadout_equip/donate/frostmorn)
		if("thebimmer231")
			items = list(/datum/loadout_equip/donate/sabre, /datum/loadout_equip/donate/sheath, /datum/loadout_equip/donate/fez)
		if("themanwhosoldthehorns")
			items = list(/datum/loadout_equip/donate/guitar)
		if("robuster1337")
			items = list(/datum/loadout_equip/donate/sunglasses, /datum/loadout_equip/donate/olympic/purga)
		if("course")
			items = list(/datum/loadout_equip/donate/sunglasses)
		if("bini71")
			items = list(/datum/loadout_equip/donate/olympic)
		if("firefox13")
			items = list(/datum/loadout_equip/donate/sunglasses, /datum/loadout_equip/donate/olympic/purga)



/datum/donation/trap
	name = "Trap"

/datum/donation/char_slot
	name = "Character Slot"

/datum/donation/gay_hair
	name = "Gay Hair"