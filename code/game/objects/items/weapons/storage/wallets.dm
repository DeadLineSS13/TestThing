/obj/item/weapon/storage/wallet
	name = "wallet"
	name_ru = "кошелёк"
	desc = "It can hold a few small and personal things."
	storage_slots = 7
	icon_state = "wallet"
	w_class = 2
	burn_state = FLAMMABLE
	can_hold = list(
		/obj/item/spacecash,
		/obj/item/clothing/mask/cigarette,
		/obj/item/weapon/dice,
		/obj/item/weapon/lighter,
		/obj/item/weapon/match,
		/obj/item/weapon/photo
		)
	slot_flags = SLOT_ID

	var/list/combined_access = list()

/obj/item/weapon/storage/wallet/remove_from_storage(obj/item/W, atom/new_location)
	. = ..(W, new_location)

/obj/item/weapon/storage/wallet/handle_item_insertion(obj/item/W, prevent_warning = 0)
	. = ..(W, prevent_warning)

/obj/item/weapon/storage/wallet/update_icon()
	icon_state = "wallet"

/obj/item/weapon/storage/wallet/random/New()
	..()
	var/item1_type = pick( /obj/item/spacecash/c100,/obj/item/spacecash/c1000,/obj/item/spacecash/c200,/obj/item/spacecash/c50, /obj/item/spacecash/c500)
	var/item2_type
	if(prob(50))
		item2_type = pick( /obj/item/spacecash/c100,/obj/item/spacecash/c1000,/obj/item/spacecash/c200,/obj/item/spacecash/c50, /obj/item/spacecash/c500)
	spawn(2)
		if(item1_type)
			new item1_type(src)
		if(item2_type)
			new item2_type(src)