/obj/item/device/battle_royale
	name = "Locator"
	desc = "A strange device."
	icon = 'icons/stalker/royaledetector.dmi'
	icon_state = "radar_null"
	item_state = "kpk"
	w_class = 1
	slot_flags = SLOT_ID

/obj/item/device/battle_royale/Initialize()
	..()
	if(SSticker.mode.name == "Battle Royale")
		SSobj.processing.Add(src)

/obj/item/device/battle_royale/Destroy()
	..()
	if(SSticker.mode.name == "Battle Royale")
		SSobj.processing.Remove(src)

/obj/item/device/battle_royale/process()
	..()

	overlays.Cut()

	overlays += image(icon, src, "locator", layer+1, get_dir(src,locate(SSbr_zone.centre.x,SSbr_zone.centre.y,1)))

	if(SSbr_zone.airdrop)
		overlays += image(icon, src, "airdrop", layer+2, get_dir(src,SSbr_zone.airdrop))