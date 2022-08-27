/obj/item/weapon/storage/firstaid/stalker
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkar"
	weight = 0.1
	desc = "Simple medikit, including bandages, weak healing stim and some painkillers."
	desc_ru = "ѕроста€ современна€ аптечка, включающа€ перев€зочные материалы, слабый клеточный стимул€тор и обезболивающее."

/obj/item/weapon/storage/firstaid/stalker/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/low(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/morphite(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/morphite(src)
	return

/obj/item/weapon/storage/firstaid/army
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkab"
	desc = "Specialised medkit for treating physical damage and bleeding. It contains painkillers, advanced stimulator and synthskin patches."
	desc_ru = "—пециализированный медицинский набор. ¬ него вход€т обезболивающие, продвинутый стимул€тор и пластыри из синтекожи. —одержимое в нем сложено таким непостижимым образом, что после извлечени€ не все удаетс€ запихнуть обратно."

/obj/item/weapon/storage/firstaid/army/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/bruise_pack/synth_bint(src)
	new /obj/item/stack/medical/bruise_pack/synth_bint(src)
	new /obj/item/stack/medical/bruise_pack/synth_bint(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/medium(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/morphite(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/morphite(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator(src)
	return

/obj/item/weapon/storage/firstaid/science
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkay"
	desc = "Medkit, developed specially for the use in the Zone's conditions. It contains medications both for phycials trauma and for radionucleid dissapation. Prevents radiation sickness and decreases the accumulated radiation in oraganism."
	desc_ru = "ћедицинский набор, разработанный специально дл€ работы в услови€х «оны. —остав набора подобран как дл€ борьбы с ранени€ми, так и дл€ вывода радионуклидов из организма. ѕреп€тствует развитию лучевой болезни, а также снижает дозу накопленной радиации."

/obj/item/weapon/storage/firstaid/science/New()
	..()
	if(empty) return
	new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/charcoal(src)
	return

/obj/item/stack/medical/bruise_pack/bint
	name = "bandages"
	name_ru = "бинты"
	desc = "Basic sterile dressing that can stop bleeding."
	desc_ru = "ѕерев€зочный материал. ѕомогает остановить кровотечение."
	icon = 'icons/stalker/items.dmi'
	icon_state = "bint"
	icon_ground = "bint_ground"
	w_class = 1
	weight = 0.2
	stop_bleeding = 1
	heal_brute = 0
	heal_burn = 0
	self_delay = 100

/obj/item/stack/medical/bruise_pack/synth_bint
	name = "synthskin patch"
	desc = "Patch from the synthetic skin which greatly helps in stopping bleeding."
	desc_ru = "ѕластырь из синтетического кожезаменител€. «начительно облегчает остановку кровотечени€ и заживление раны."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bandaid"
	item_state = "bandaid"
	w_class = 1
	weight = 0.2
	stop_bleeding = 1
	heal_brute = 0
	heal_burn = 0
	med_bonus = 2
	self_delay = 100