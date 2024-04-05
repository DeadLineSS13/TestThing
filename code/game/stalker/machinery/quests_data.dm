var/list/quest_list_available = list()
var/list/quest_list_all = list()

/world/New()
	..()
	for(var/path in subtypesof(/datum/data/stalker_quests) - /datum/data/stalker_quests/findartifact)
		quest_list_all += new path()
		if(quest_list_available.len > 4)
			spawn(rand(600, 9000))
				quest_list_available += new path()
		else
			quest_list_available += new path()

/datum/data/stalker_quests
	var/name_en = "Quest"
	var/name_ru = "Квест"
	var/desc_en = "Typical quest"
	var/desc_ru = "Типичный квест"
	var/reward = 0
	var/experience = 50
	var/obj/item/needed = null
	var/name_kill = null

	var/icon/icon = null
	var/icon_state = null


/datum/data/stalker_quests/findartifact
	name_en = "Bring a specific anomalous object"
	name_ru = "Добыть специфичный аномальный объект"
	reward = 100000
	desc_en = "Some pricks from the 'great land' are willing to pay a very good price for a specific rare object. They know how it should look, here's the photo of a similiar item, so if you find one by any chance - bring it here, you'll be paid well."
	desc_ru = "Моим поставщикам с 'большой земли' необходим определенный объект из тех, что растут лишь в местных аномальных полях. Они предоставили фото другого подобного аномального образования в качестве ориентира, так что если по пути попадется такой - приноси, щедро заплачу."
	needed = /obj/item/weapon/kitchen/knife/tourist
	icon = 'icons/stalker/artefacts.dmi'
	icon_state = "flash"

/datum/data/stalker_quests/findartifact/zapzap
	needed = /obj/item/artefact/electro/zapzap
	icon_state = "zapzap"

/datum/data/stalker_quests/findartifact/kirpich
	needed = /obj/item/artefact/electro/kirpich
	icon_state = "kirpich"

/datum/data/stalker_quests/findartifact/chertovrog
//	needed = list(/obj/item/artefact/fire/chertovrog, /obj/item/artefact/fire/korsar)
	needed = /obj/item/artefact/fire/chertovrog
	icon_state = "chertovrog"

/datum/data/stalker_quests/findartifact/krot
	needed = /obj/item/artefact/organic/krot
	icon_state = "krot"

/datum/data/stalker_quests/findartifact/emerald
	needed = /obj/item/artefact/others/emerald
	icon_state = "emerald"

/datum/data/stalker_quests/findartifact/spike
	needed = /obj/item/artefact/others/spike
	icon_state = "spike"