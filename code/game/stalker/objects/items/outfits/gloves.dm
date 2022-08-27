/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	name_ru = "перчатки без пальцев"
	desc = "Простые черные перчатки с обрезанными пальцами."
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	item_state = "fingerless"
	icon_ground = "fingerless_ground"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	equip_delay = 30
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT

/obj/item/clothing/gloves/ozk
	name = "rubber gloves"
	name_ru = "резиновые перчатки"
	desc = "Прочные перчатки, защищающие от умеренно высоких температур и, наверное, слабых кислот."
	desc = "Tough rubber gloves, protecting you from high temperatures and, probably, weak acids."
	icon_state = "rubber"
	item_state = "rubber"
	icon_ground = "rubber_ground"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	body_parts_covered = HANDS
	armor_type = A_SOFT_LIGHT
	armor_new = list(crush = 2, cut = 2, imp = 2, bullet = 2, burn = 2, bio = 4, rad = 0, psy = 0)
	equip_delay = 30
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT