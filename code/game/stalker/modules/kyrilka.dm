/obj/effect/landmark/kyrilka
	name = "landmark"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	invisibility = 101
	anchored = 1
	unacidable = 1

/area/stalker/kyrilka
	name = "kyrilka"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	blowout_sleep = 0

/mob/living/carbon/human/dead
	alpha = 180

/mob/proc/send_to_kyrilka()
	if(istype(src, /mob/living/carbon/human/dead) || !stat)
		return
	var/obj/effect/landmark/kyrilka/K = locate() in world
	var/mob/living/carbon/human/dead/character = new(K.loc)

	client.prefs.copy_to(character)
	character.dna.update_dna_identity()
	if(mind)
		mind.active = 0
		mind.transfer_to(character)

	character.clients_names = clients_names.Copy()
	character.clients_names[character] = clients_names[src]
	character.timeofdeath = timeofdeath
	character.key = key
//	character.client.set_macros()
	var/obj/uniform = pick(GLOB.available_uniform)
	character.equip_to_slot_or_del(new uniform.type(character), slot_w_uniform, 0)
	character.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/warm(character), slot_shoes, 0)
	character.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(character), slot_gloves, 0)