/obj/item/weapon/reagent_containers/hypospray/medipen/stalker/antirad
	name = "Antirad"
	desc = "Almost instantly purges radiation from the organism."
	desc_ru = "Моментально снижает воздействие радиации на организм."
	icon = 'icons/stalker/items.dmi'
	icon_state = "antirad"
	item_state = "antirad"
	amount_per_transfer_from_this = 15
	volume = 15
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("antirad" = 15)

/obj/item/weapon/reagent_containers/pill/antirad
	name = "Antirad pills"
	desc = "Reduces the effects of radiation on the body for a long time."
	desc_ru = "Снижает воздействие радиации на организм в течение длительного времени."
	icon = 'icons/stalker/items.dmi'
	icon_state = "antirad_pills"
	list_reagents = list("antirad_pill" = 36)
	roundstart = 1