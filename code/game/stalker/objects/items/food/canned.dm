/obj/item/weapon/reagent_containers/food/snacks/stalker/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(snack)
		return

	if(user.flags & IN_PROGRESS)
		return

	if(istype(W, /obj/item/weapon/kitchen/knife))
		if(istype(W, /obj/item/weapon/kitchen/knife/vykid))
			var/obj/item/weapon/kitchen/knife/vykid/V = W
			if(!V.extended)
				return
		if(wrapped)
			playsound(loc, 'sound/stalker/objects/items/can_opening.ogg', 100, 1, -5, 1, channel = "regular", time = 80)
			user.flags += IN_PROGRESS
			if(!do_after(user, 76, 1, src))
				user.flags &= ~IN_PROGRESS
				return
			user.flags &= ~IN_PROGRESS
			user << user.client.select_lang("<span class='notice'>Вы вскрыли банку.</span>","<span class='notice'>You opened the can.</span>")
			icon_state = icon_state_opened
			icon_hands = icon_state
			if(icon_states(icon).Find("[icon_state]_ground"))
				icon_ground = "[icon_state]_ground"
			if(isturf(loc))
				icon_state = icon_ground
			desc = desc_opened
			desc_ru = desc_ru_opened
			wrapped = 0

/obj/item/weapon/reagent_containers/food/snacks/stalker/attack_self(mob/user)
	..()
	if(!wrapped)
		return

	if(snack)
		wrapped = 0
		user << user.client.select_lang("<span class='notice'>Вы вскрыли упаковку.</span>","<span class='notice'>You opened the package.</span>")
		icon_state = icon_state_opened
		icon_hands = icon_state
		if(icon_states(icon).Find("[icon_state]_ground"))
			icon_ground = "[icon_state]_ground"
		desc = desc_opened
		desc_ru = desc_ru_opened

	return

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva
	name = "tourist's delight"
	name_ru = "радость туриста"
	desc = "Canned food \"Tourist's Delight\" from a military stock plundered by stalkers. It seems these have not yet expired."
	desc_ru = "Консервы \"Радость туриста\" с растащенного сталкерами армейского продовольстенного склада. Срок годности вроде бы не истёк."
	icon = 'icons/stalker/food.dmi'
	icon_state = "konserva"
	w_class = 2
	wrapped = 1
	weight = 0.6
	trash = /obj/item/trash/konserva
	list_reagents = list("nutriment" = 15, "vitamin" = 3)
	icon_state_opened = "konserva_open"
	desc_opened = "Does not look so tasty, but smells good."
	desc_ru_opened = "Выглядит не очень аппетитно, но пахнет вроде бы нормально."

/obj/item/trash/konserva
	name = "empty can"
	name_ru = "мусор"
	desc = "Typical trash that can be found absolutely everywhere."
	desc_ru = "Обычный мусор."
	icon = 'icons/stalker/food.dmi'
	icon_state = "konserva_empty"
	w_class = 2
	weight = 0.1

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/fish
	name = "canned fish"
	name_ru = "рыбные консервы"
	desc = "Canned fish \"Pripyat\", seems made of fish from the local river."
	desc_ru = "Рыбные консервы \"Припять\", видимо из местной реки."
	icon_state = "sardines0"
	icon_state_opened = "sardines1"
	trash = /obj/item/trash/konserva/fish
	desc_opened = "Looks very, very tasty."
	desc_ru_opened = "Выглядит очень аппетитно."

/obj/item/trash/konserva/fish
	name = "empty can"
	name_ru = "мусор"
	icon_state = "sardines2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/shproti
	name = "canned sprats"
	name_ru = "шпроты"
	desc = "A can that contains sprats from Riga."
	desc_ru = "Рижские шпроты."
	icon_state = "shproti0"
	icon_state_opened = "shproti1"
	trash = /obj/item/trash/konserva/shproti
	desc_opened = "Open can which contains sprats. Looks tasty."
	desc_ru_opened = "Открытая банка со шпротами. Выглядит аппетитно."

/obj/item/trash/konserva/shproti
	name = "empty can"
	name_ru = "мусор"
	icon_state = "shproti2"
	desc = "Empty tincan from sprats."
	desc_ru = "Пустая банка из под шпрот."

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/salmon
	name = "canned salmon"
	name_ru = "консервированный лосось"
	desc = "A can that contains salmon from Atlantic."
	desc_ru = "Сочный лосось прямиком из Атлантики."
	icon_state = "salmon0"
	icon_state_opened = "salmon1"
	trash = /obj/item/trash/konserva/salmon
	desc_opened = "Open can which contains salmon. Looks tasty."
	desc_ru_opened = "Открытая банка с лососем. Выглядит аппетитно."

/obj/item/trash/konserva/salmon
	name = "empty can"
	name_ru = "мусор"
	icon_state = "salmon2"
	desc = "Empty tincan from salmon."
	desc_ru = "Пустая банка из под лосос#255;."

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup
	name = "canned soup"
	name_ru = "консервированный суп"
	desc = "Ready and canned home-made soup"
	desc_ru = "Готовый законсервированный суп по-домашнему."
	weight = 0.7
	can_be_cooked = 1
	icon_state = "soup0"
	icon_state_opened = "soup1"
	list_reagents = list("nutriment" = 20, "vitamin" = 4)
	trash = /obj/item/trash/konserva/soup
	desc_opened = "Looks tasty!"
	desc_ru_opened = "Выглядит аппетитно."

/obj/item/trash/konserva/soup
	name = "empty can"
	name_ru = "мусор"
	icon_state = "soup2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/bobi
	name = "canned beans"
	name_ru = "консервированные бобы"
	desc = "Can of \"Bean Suprise\". Nice."
	desc_ru = "Консервы \"Бобовый Сюрприз\", сносно."
	can_be_cooked = 1
	icon_state = "bobi0"
	icon_state_opened = "bobi1"
	trash = /obj/item/trash/konserva/bobi
	desc_opened = "Looks tasty!"
	desc_ru_opened = "Выглядит аппетитно."

/obj/item/trash/konserva/bobi
	name = "empty can"
	name_ru = "мусор"
	icon_state = "bobi2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/govyadina2
	name = "canned beef"
	name_ru = "консервированная говядина"
	desc = "Canned beef."
	desc_ru = "Банка законсервированной говядины."
	weight = 0.7
	can_be_cooked = 1
	icon_state = "beef0"
	icon_state_opened = "beef1"
	list_reagents = list("nutriment" = 20, "vitamin" = 4)
	trash = /obj/item/trash/konserva/govyadina
	desc_opened = "Looks very, very tasty."
	desc_ru_opened = "Выглядит очень аппетитно."

/obj/item/trash/konserva/govyadina
	name = "empty can"
	name_ru = "мусор"
	icon_state = "beef2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/buckwheat
	name = "canned buckwheat"
	name_ru = "консервированная гречка"
	desc = "Canned cooked buckwheat porridge."
	desc_ru = "Банка законсервированной приготовленной греченовй каши."
	weight = 0.7
	can_be_cooked = 1
	icon_state = "buckwheat0"
	icon_state_opened = "buckwheat1"
	list_reagents = list("nutriment" = 20, "vitamin" = 4)
	trash = /obj/item/trash/konserva/buckwheat
	desc_opened = "Looks very, very tasty."
	desc_ru_opened = "Выглядит очень аппетитно."

/obj/item/trash/konserva/buckwheat
	name = "empty can"
	name_ru = "мусор"
	icon_state = "buckwheat2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/pineapple
	name = "canned pineapple"
	name_ru = "консервированные ананасы"
	desc = "Juicy canned pineapple. Very rare in the Zone."
	desc_ru = "Сочные законсервированные ананасы. Большая редкость в зоне."
	icon_state = "pineapples0"
	icon_state_opened = "pineapples1"
	list_reagents = list("nutriment" = 20, "vitamin" = 4)
	trash = /obj/item/trash/konserva/pineapple
	desc_opened = "Looks very, very tasty."
	desc_ru_opened = "Выглядит очень аппетитно."

/obj/item/trash/konserva/pineapple
	name = "empty can"
	name_ru = "мусор"
	icon_state = "pineapples2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/olives
	name = "canned olives"
	name_ru = "консервированные маслины"
	desc = "Canned olives, favorite delicacy for bandits."
	desc_ru = "Маслины консервированные, любимое лакомство бандитов."
	icon_state = "olives0"
	icon_state_opened = "olives1"
	trash = /obj/item/trash/konserva/olives
	desc_opened = "Looks very, very tasty."
	desc_ru_opened = "Выглядит очень аппетитно."

/obj/item/trash/konserva/olives
	name = "empty can"
	name_ru = "мусор"
	icon_state = "olives2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/cmilk
	name = "condensed milk"
	name_ru = "сгущенка"
	desc = "Delicious and very nutritious condensed milk, well appreciated by any stalker."
	desc_ru = "Вкусное и очень питательное сгущенное молоко, хорошо ценится любым сталкером."
	can_be_cooked = 1
	icon_state = "cmilk0"
	icon_state_opened = "cmilk1"
	list_reagents = list("nutriment" = 24, "sugar" = 10, "vitamin" = 2)
	trash = /obj/item/trash/konserva/cmilk
	desc_opened = "Looks very, very tasty."
	desc_ru_opened = "Выглядит очень аппетитно."

/obj/item/trash/konserva/cmilk
	name = "empty can"
	name_ru = "мусор"
	icon_state = "cmilk2"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/MREkonserva1
	name = "konserva"
	name_ru = "консерва"
	desc = "Judging by the label this is canned meat, but you can't get what meat is in the can."
	desc_ru = "Судя по этикетке, банка законсервированного мяса, но какого - неизвестно."
	desc_opened = "This doesn't look good, but you can guess this is canned beef by it's smell"
	desc_ru_opened = "Выглядит не очень, но по запаху очень похоже на тушенку."
	weight = 0.5
	icon_state = "TushenkaRed1"
	icon_state_opened = "TushenkaRed2"
	trash = /obj/item/trash/konserva/MREkonserva1
	snack = 1

/obj/item/trash/konserva/MREkonserva1
	name = "trash"
	name_ru = "мусор"
	icon_state = "TushenkaRed3"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/MREkonserva2
	name = "konserva"
	name_ru = "консерва"
	desc = "Judging by the label this is canned meat with vegetables, but you can't get what meat and vegetables are in the can."
	desc_ru = "Судя по этикетке, банка законсервированного мяса c овощами, но какое мясо и какие овощи - неизвестно."
	desc_opened = "This doesn't look good, but you can guess this is canned beef with something else by it's smell"
	desc_ru_opened = "Выглядит не очень, но по запаху очень похоже на тушенку с чем-то еще."
	weight = 0.5
	icon_state = "TushenkaGreen1"
	icon_state_opened = "TushenkaGreen2"
	trash = /obj/item/trash/konserva/MREkonserva2
	snack = 1

/obj/item/trash/konserva/MREkonserva2
	name = "trash"
	name_ru = "мусор"
	icon_state = "TushenkaGreen3"

/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/MREkonserva3
	name = "konserva"
	name_ru = "консерва"
	desc = "Judging by the label, this is canned meat with green vegetables, but you can't get what meat and vegetables are in the can."
	desc_ru = "Судя по этикетке, банка законсервированного мяса c зеленью, но какое мясо и какая зелень - неизвестно."
	desc_opened = "This doesn't look good, but you can smell canned beef with green onion and garlic."
	desc_ru_opened = "Выглядит не очень, но по запаху сильно отдает тушенкой, приправленной луком и чесноком"
	weight = 0.5
	icon_state = "TushenkaBlue1"
	icon_state_opened = "TushenkaBlue2"
	trash = /obj/item/trash/konserva/MREkonserva3
	snack = 1

/obj/item/trash/konserva/MREkonserva3
	name = "trash"
	name_ru = "мусор"
	icon_state = "TushenkaBlue3"