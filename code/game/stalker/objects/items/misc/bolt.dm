/obj/item/weapon/stalker/bolt
	name = "bolt"
	name_ru = "болт"
	desc = "Common rusty bolt."
	desc_ru = "Обычный ржавый болт."
	icon = 'icons/stalker/bolt.dmi'
	icon_state = "bolt"
	force = 0
	throwforce = 0
	w_class = 1
	weight = 0.01
	ismetal = 1
	stackable = 10
	var/hot = 0

/obj/item/weapon/stalker/bolt/attack_hand(mob/user)
	if(hot && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.gloves || !H.gloves.heat_protection)
			H << H.client.select_lang("<span class='warning'>Ай! Горячо!</span>", "<span class='warning'>Ouch! That's hot!</span>")
			return

	..()

/obj/item/weapon/stalker/bolt/update_icon()
	icon_state = "[initial(icon_state)]_[current_stack]"
	icon_hands = icon_state
	icon_ground = "[icon_state]_ground"

/obj/item/weapon/storage/small_bag
	name = "Bag"
	name_ru = "Мешочек"
	desc = "Small bag"
	desc_ru = "Небольшой мешочек"
	icon = 'icons/stalker/items.dmi'
	icon_state = "boltbag"
	icon_ground = "boltbag_ground"
	storage_slots = 3
	w_class = 2
	max_w_class = 2
	max_combined_w_class = 6
	max_weight = 3
	weight = 0.1
	back_open = 1

/obj/item/weapon/storage/small_bag/bolts/Initialize()
	..()
	var/obj/item/weapon/stalker/bolt/B1 = new(src)
	B1.current_stack = B1.stackable
	B1.update_icon()
	var/obj/item/weapon/stalker/bolt/B2 = new(src)
	B2.current_stack = B1.stackable
	B2.update_icon()


/obj/item/base_kit
	name = "base_kit"
	w_class = 3

/obj/item/base_kit/Initialize()
	..()
	spawn(1)
		new /obj/item/weapon/storage/small_bag/bolts(loc)
		new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva(loc)
		new /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva(loc)
		new /obj/item/weapon/reagent_containers/food/drinks/soda_cans/voda(loc)
		new /obj/item/weapon/storage/box/matches(loc)
		new /obj/item/device/flashlight/seclite(loc)
		qdel(src)