/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/kazaki
	name = "Vodka Kazaki"
	name_ru = "водка \"Казаки\""
	desc = "Distilled by the GSC company, the Cossacks-brand vodka is a clear distilled liquor composed of water and ethyl alcohol. Vodka is made from a fermented substance of either grain, rye, wheat, potatoes, or sugar beet molasses. Vodka’s alcoholic concentration usually ranges between 35 to 70 per cent by volume."
	desc_ru = "Водка производства компании GSC. Хорошо пьётся, заметно снижает воздействие радиации, однако злоупотреблять ей не стоит."
	weight = 0.8
	icon = 'icons/stalker/food.dmi'
	icon_state = "gsc_vodka"
	icon_ground = "gsc_vodka_ground"
	list_reagents = list("vodka" = 70)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo
	name = "beer"
	name_ru = "пивко"


/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/ohota
	name = "'Ohota strong' beer"
	name_ru = "пивко 'Охота крепкое'"
	desc = "Ah, this must be the slav beer. You hope this one is tasty."
	desc_ru = "Оно не раз выручало тебя в школьные годы, когда хотелось улететь с соски пива дёшево и сердито. Если ничего с тех времен не изменилось, ты знаешь, что выбрать."
	weight = 2
	volume = 200
	icon = 'icons/stalker/food.dmi'
	icon_state = "ohota"
	list_reagents = list("ohota" = 200)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/obolon
	name = "'Obolon' beer"
	name_ru = "пивко 'Оболонь'"
	desc = "Ah, this must be the slav beer. You hope this one is tasty."
	desc_ru = "Лiтрове, але могутнє барильце пива. Той, що п'є його вiдчуває волю козацького життя и сповнюєтся гордостi за батькивщiну."
	weight = 1
	volume = 100
	icon = 'icons/stalker/food.dmi'
	icon_state = "obolon"
	list_reagents = list("obolon" = 100)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/razin
	name = "'Stepan Razin' beer"
	name_ru = "пивко 'Степан Разин'"
	desc = "Ah, this must be the slav beer. You hope this one is tasty."
	desc_ru = "Пиво 'Степан Разин: Петровское'. С этикетки на тебя взирает, судя по всему, сам царь Степан или кем он там был? Для патриотов, уважающих историю своей страны."
	weight = 1.5
	volume = 150
	icon = 'icons/stalker/food.dmi'
	icon_state = "stepan_razin"
	list_reagents = list("razin" = 150)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/gus
	name = "'Zhatetsky Goose' beer"
	name_ru = "пивко 'Жатецкий Гусь'"
	desc = "Ah, this must be the slav beer. You hope this one is tasty."
	desc_ru = "Когда ты пиздюком ездил к бабуле в деревню, в сельпо этот пивас благоговейно называли 'Житейский гусь'. Настоящий европейский изыск для ценителей."
	weight = 1.5
	volume = 150
	icon = 'icons/stalker/food.dmi'
	icon_state = "zhatetsky_gus"
	list_reagents = list("gus" = 150)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/energetic
	name = "energetic Non-Stop"
	name_ru = "энергетик Нон-Стоп"
	desc = "A great energy drink \"Non Stop\". Contains coffeine, taurin and strong vitamin complex to reduce exaustion and add strength. Can't make a single step? Then that's what you need."
	desc_ru = "Отличный энергетический напиток \"Non Stop\". Содержит кофеин, таурин, и мощный витаминный комплекс снимающие усталость и прибавляющие силы. Не в состоянии даже сделать шаг? Тогда это именно то, что нужно."
	weight = 0.6
	icon = 'icons/stalker/food.dmi'
	icon_state = "nonstop"
	list_reagents = list("energetic" = 10, "water" = 20)

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/voda
	name = "bottle"
	name_ru = "вода"
	desc = "Tunic water \"Cone Forest\""
	desc_ru = "Тонизирующая вода \"Шишкин Лес\""
	weight = 0.5
	icon = 'icons/stalker/food.dmi'
	icon_state = "voda"
	icon_ground = "voda_ground"
	list_reagents = list("energetic" = 5, "water" = 40)

/obj/item/weapon/reagent_containers/food/drinks/cup
	name = "cup"
	name_ru = "кружка"
	icon = 'icons/stalker/items.dmi'
	icon_state = "mug"
	icon_ground = "mug_ground"
	desc = "Just a regular mug."
	desc_ru = "Обыкновенная кружка."
	weight = 0.1
	volume = 20

/obj/item/weapon/reagent_containers/food/drinks/cup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "mug_full"
		icon_ground = "mug_full_ground"
		weight = initial(weight)+reagents.total_volume*0.01
	else
		icon_state = "mug"
		icon_ground = "mug_ground"
		weight = initial(weight)

/obj/item/weapon/reagent_containers/food/drinks/cup/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup))
		for(var/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup/S)
			S.reagents.trans_to(src, volume)
			S.On_Consume()

	..()