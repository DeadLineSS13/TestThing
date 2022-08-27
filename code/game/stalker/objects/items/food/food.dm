/obj/item/weapon/reagent_containers/food/snacks/stalker
	icon = 'icons/stalker/food.dmi'
	var/can_be_cooked = 0
	var/snack = 0

/obj/item/weapon/storage/box/MRE
	name = "MRE"
	name_ru = "ИРП"
	desc = "Army MRE, calculated for one day."
	desc_ru = "Армейский ИРП, рассчитанный на сутки."
	weight = 0.5
	var/desc_opened = "Opened army MRE, calculated for one day."
	var/desc_ru_opened = "Открытый Армейский ИРП, рассчитанный на сутки."
	icon = 'icons/stalker/food.dmi'
	icon_state = "box1"
	var/icon_state_opened = "box3"
	storage_slots = 10
	var/wrapped = 1
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva, /obj/item/trash/konserva, /obj/item/weapon/reagent_containers/food/drinks)

/obj/item/weapon/storage/box/MRE/New()
	..()
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/galets(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/galets(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/galets(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/galets(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/kasha(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/MREkonserva1(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/MREkonserva2(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/MREkonserva3(src)
	new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/chocolate(src)
	new /obj/item/weapon/reagent_containers/food/drinks/soda_cans/voda(src)

/obj/item/weapon/storage/box/MRE/attack_self(mob/user)
	if(wrapped)
		Unwrap(user)

/obj/item/weapon/storage/box/MRE/attack_paw(mob/user)
	if(!wrapped)
		return attack_hand(user)

/obj/item/weapon/storage/box/MRE/attack_hand(mob/user)
	if(loc == user)
		if(wrapped)
			return

	..()

/obj/item/weapon/storage/box/MRE/MouseDrop(atom/over_object)
	if(wrapped)
		return

	..()

/obj/item/weapon/storage/box/MRE/MouseDrop_T(atom/over_object)
	if(wrapped)
		return

	..()

/obj/item/weapon/storage/box/MRE/proc/Unwrap(mob/user)
		icon_state = icon_state_opened
		desc = desc_opened
		desc_ru = desc_ru_opened
		user << user.client.select_lang("<span class='notice'>Вы вскрываете упаковку.</span>", "<span class='notice'>You unwrapped the box</span>")
		wrapped = 0

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/kasha
	name = "kasha"
	name_ru = "каша"
	desc = "Cooked oatmeal in vacuum pack."
	desc_ru = "Готовая овсяная каша в вакуумной упаковке."
	desc_opened = "Looks blank, but smells tasty."
	desc_ru_opened = "Выглядит так себе, но на запах вроде ничего."
	weight = 0.3
	icon_state = "Kasha1"
	icon_state_opened = "Kasha2"
	list_reagents = list("nutriment" = 15)
	trash = /obj/item/trash/konserva/kasha
	snack = 1

/obj/item/trash/konserva/kasha
	name = "trash"
	name_ru = "мусор"
	icon_state = "Kasha3"

/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa
	name = "diet sausage"
	name_ru = "колбаса"
	desc = "This sausage is a frequent breakfast, lunch and supper of a stalker made of a mix of chicked meat and soy."
	desc_ru = "Часто за неимением лучшего эта колбаса - смесь курятины и соевого заменителя - завтрак, обед и ужин сталкера."
	weight = 0.4
	icon_state = "kolbasa"
	w_class = 2
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasaslice
	slices_num = 6
	list_reagents = list("nutriment" = 15, "vitamin" = 1)

/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasaslice
	name = "diet sausage slice"
	name_ru = "кусочек колбасы"
	desc = "A piece of a sausage. Ideal snack, if you don't think of what you're eating."
	desc_ru = "Кусочек колбасы. Идеальная закуска, если не разглядывать содержимое."
	weight = 0.066
	icon_state = "kolbasaslice"
	w_class = 1

/obj/item/weapon/reagent_containers/food/snacks/stalker/baton
	name = "baton"
	name_ru = "батон"
	desc = "It's unknown, who manage to bake loafes in the Zone, but this bread isn't irradiated and eatable. At least noone has complained."
	desc_ru = "Неизвестно, кто умудряется печь батоны на территории Зоны, однако этот хлеб не заражен и вполне съедобен. Во всяком случае, никто из сталкеров пока не жаловался."
	weight = 0.2
	icon_state = "baton_stalker"
	w_class = 2
	list_reagents = list("nutriment" = 15)

/obj/item/weapon/reagent_containers/food/snacks/stalker/lard
	name = "lard"
	name_ru = "сало"
	desc = ""
	desc_ru = "Большой шмат сала. У сталкеров-украинцев — предмет культа. Неплохо утоляет голод и хорошо идёт под водочку."
	weight = 0.5
	icon_state = "salo"
	w_class = 2
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/stalker/lardslice
	slices_num = 10
	list_reagents = list("nutriment" = 20, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/stalker/lardslice
	name = "lard slice"
	name_ru = "кусочек сала"
	desc = "Gently cut a slice of lard."
	desc_ru = "Аккуратно отрезанный ломтик сала."
	weight = 0.05
	icon_state = "salo_slice"
	w_class = 1

/obj/item/weapon/reagent_containers/food/snacks/stalker/shit //Тот, кто добавил это - нехороший человек и извращенец
	name = "shit"
	name_ru = "говно"
	desc = "Mhm. so tasty..."
	desc_ru = "Ммм, как вкусно..."
	weight = 0.5
	icon = 'icons/stalker/items.dmi'
	icon_state = "shit"
	w_class = 1
	list_reagents = list("nutriment" = 1, "toxin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/stalker/shit/Crossed(AM as mob|obj)
	if(istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if(M.ckey == "maksich99" || prob(15))
			M.slip(2, 2, src)

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/radioactive
	name = "meat"
	name_ru = "мясо"
	desc = "A slab of mutant's meat. You are not sure, is it still radioactive or not."
	desc_ru = "Кусок мяса мутанта. Стоило бы убедиться, радиоактивен он или нет."
	icon_state = "meat"
//	dried_type = /obj/item/weapon/reagent_containers/food/snacks/sosjerky
	bitesize = 3
	list_reagents = list("nutriment" = 3, "toxin" = 2)
//	cooked_type = /obj/item/weapon/reagent_containers/food/snacks/meat/steak/plain
//	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet/plain
	slices_num = 3
	filling_color = "#6B8E23"