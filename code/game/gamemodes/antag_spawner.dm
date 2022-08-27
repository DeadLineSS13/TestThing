/obj/item/weapon/antag_spawner
	throw_speed = 1
	throw_range = 5
	w_class = 1
	var/used = 0

/obj/item/weapon/antag_spawner/proc/spawn_antag(client/C, turf/T, type = "")
	return

/obj/item/weapon/antag_spawner/proc/equip_antag(mob/target)
	return


///////////WIZARD

/obj/item/weapon/antag_spawner/contract
	name = "contract"
	desc = "A magic contract previously signed by an apprentice. In exchange for instruction in the magical arts, they are bound to answer your call for aid."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"

/obj/item/weapon/antag_spawner/contract/attack_self(mob/user)
	user.set_machine(src)
	var/dat
	if(used)
		dat = "<B>You have already summoned your apprentice.</B><BR>"
	else
		dat = "<B>Contract of Apprenticeship:</B><BR>"
		dat += "<I>Using this contract, you may summon an apprentice to aid you on your mission.</I><BR>"
		dat += "<I>If you are unable to establish contact with your apprentice, you can feed the contract back to the spellbook to refund your points.</I><BR>"
		dat += "<B>Which school of magic is your apprentice studying?:</B><BR>"
		dat += "<A href='byond://?src=\ref[src];school=destruction'>Destruction</A><BR>"
		dat += "<I>Your apprentice is skilled in offensive magic. They know Magic Missile and Fireball.</I><BR>"
		dat += "<A href='byond://?src=\ref[src];school=bluespace'>Bluespace Manipulation</A><BR>"
		dat += "<I>Your apprentice is able to defy physics, melting through solid objects and travelling great distances in the blink of an eye. They know Teleport and Ethereal Jaunt.</I><BR>"
		dat += "<A href='byond://?src=\ref[src];school=healing'>Healing</A><BR>"
		dat += "<I>Your apprentice is training to cast spells that will aid your survival. They know Forcewall and Charge and come with a Staff of Healing.</I><BR>"
		dat += "<A href='byond://?src=\ref[src];school=robeless'>Robeless</A><BR>"
		dat += "<I>Your apprentice is training to cast spells without their robes. They know Knock and Mindswap.</I><BR>"
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/weapon/antag_spawner/contract/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return
	if(!istype(H, /mob/living/carbon/human))
		return 1

	if(loc == H || (in_range(src, H) && istype(loc, /turf)))
		H.set_machine(src)
		if(href_list["school"])
			if (used)
				H << "You already used this contract!"
				return
			var/list/candidates = get_candidates(ROLE_WIZARD)
			if(candidates.len)
				src.used = 1
				var/client/C = pick(candidates)
				spawn_antag(C, get_turf(H.loc), href_list["school"])
//				if(H.mind)
//					ticker.mode.update_wiz_icons_added(H.mind)
			else
				H << "Unable to reach your apprentice! You can either attack the spellbook with the contract to refund your points, or wait and try again later."

/obj/item/weapon/antag_spawner/contract/spawn_antag(client/C, turf/T, type = "")
	new /obj/effect/particle_effect/smoke(T)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.copy_to(M)
	M.key = C.key
	M << "<B>You are the [usr.real_name]'s apprentice! You are bound by magic contract to follow their orders and help them in accomplishing their goals."

	equip_antag(M)
//	var/mob/living/carbon/human/H = usr
	var/wizard_name_first = pick(GLOB.wizard_first)
	var/wizard_name_second = pick(GLOB.wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
//	ticker.mode.apprentices += M.mind
	M.mind.special_role = "apprentice"
//	ticker.mode.update_wiz_icons_added(M.mind)
//	M << sound('sound/effects/magic.ogg')
	var/newname = copytext(sanitize(input(M, "You are the wizard's apprentice. Would you like to change your name to something else?", "Name change", randomname) as null|text),1,MAX_NAME_LEN)
	if (!newname)
		newname = randomname
	M.mind.name = newname
	M.real_name = newname
	M.name = newname
	M.dna.update_dna_identity()

/obj/item/weapon/antag_spawner/contract/equip_antag(mob/target)
	target.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(target), slot_shoes)
	target.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(target), slot_back)
	target.equip_to_slot_or_del(new /obj/item/weapon/storage/box(target), slot_in_backpack)






///////////BORGS AND OPERATIVES


/obj/item/weapon/antag_spawner/nuke_ops
	name = "syndicate operative teleporter"
	desc = "A single-use teleporter designed to quickly reinforce operatives in the field."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/TC_cost = 0
	var/borg_to_spawn
	var/list/possible_types = list("Assault", "Medical")

/obj/item/weapon/antag_spawner/nuke_ops/proc/check_usability(mob/user)
	if(used)
		user << "<span class='warning'>[src] is out of power!</span>"
		return 0
//	if(!(user.mind in ticker.mode.syndicates))
//		user << "<span class='danger'>AUTHENTICATION FAILURE. ACCESS DENIED.</span>"
//		return 0
	if(user.z != ZLEVEL_CENTCOM)
		user << "<span class='warning'>[src] is out of range! It can only be used at your base!</span>"
		return 0
	return 1


/obj/item/weapon/antag_spawner/nuke_ops/attack_self(mob/user)
	if(!(check_usability(user)))
		return

	var/list/nuke_candidates = get_candidates(ROLE_OPERATIVE, 3000, "operative")
	if(nuke_candidates.len > 0)
		used = 1
		var/client/C = pick(nuke_candidates)
		spawn_antag(C, get_turf(src.loc), "syndieborg")
		var/datum/effect_system/spark_spread/S = new /datum/effect_system/spark_spread
		S.set_up(4, 1, src)
		S.start()
	else
		user << "<span class='warning'>Unable to connect to Syndicate command. Please wait and try again later or use the teleporter on your uplink to get your points refunded.</span>"

/obj/item/weapon/antag_spawner/nuke_ops/spawn_antag(client/C, turf/T)
//	var/new_op_code = "Ask your leader!"
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.copy_to(M)
	M.key = C.key
//	var/obj/machinery/nuclearbomb/nuke = locate("syndienuke") in nuke_list
//	if(nuke)
//		new_op_code = nuke.r_code
//	M.mind.make_Nuke(T, new_op_code, 0, FALSE)