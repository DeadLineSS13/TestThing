/obj/structure/stalker
	icon = 'icons/stalker/structure/decor.dmi'
	desc = ""
	desc_ru = ""
	density = 0
	anchored = 1
	layer = 3.1

	var/can_storage = 0
	var/obj/item/weapon/storage/internal/storage = null
	var/mob/storage_owner = null
	var/max_w_class = 3
	var/max_slots = 2

/obj/structure/stalker/proc/make_storage()
	storage = new(src)
	storage.max_w_class = max_w_class
	storage.storage_slots = max_slots
	storage.max_combined_w_class = max_w_class * max_slots

/obj/structure/stalker/RightClick(mob/user)
	if(user.stat || !Adjacent(user))
		return
	if(!can_storage)
		return
	if(storage_owner && user == storage_owner)
		storage.show_to(user)
		playsound(loc, 'sound/stalker/objects/inv_open.ogg', 50, 1, -5, channel = "regular", time = 5)
		return
	if(user.flags & IN_PROGRESS)
		return
	user << user.client.select_lang("<span class='notice'>�� ������������ [name_ru] �� ������� ��������...</span>","<span class='notice'>You've started checking [src] for hidden things...</span>")
	user.flags += IN_PROGRESS
	if(!do_after(user, 50, 1, src))
		user.flags &= ~IN_PROGRESS
		return
	user.flags &= ~IN_PROGRESS
	if(!storage)
		user << user.client.select_lang("<span class='notice'>������ �� �������!</span>","<span class='notice'>Nothing inside!</span>")
		return
	storage.show_to(user)
	playsound(loc, 'sound/stalker/objects/inv_open.ogg', 50, 1, -5, channel = "regular", time = 5)

/obj/structure/stalker/RightCtrlClick(mob/user)
	if(user.stat || !Adjacent(user))
		return
	if(!can_storage)
		return

	if(storage)
		return

	make_storage()
	storage_owner = user
	user << user.client.select_lang("<span class='notice'>�� ������ ������ � [name_ru]!</span>","<span class='notice'>You made a stach inside [src]!</span>")



/obj/structure/sign
	icon = 'icons/stalker/structure/signs.dmi'
	density = 0
	layer = 4.1

/obj/structure/sign/lelev
	name = "Lelev"
	name_ru = "����"
	desc = "A pointer to Lelev"
	desc_ru = "��������� �� ����"
	icon_state = "lelev"

/obj/structure/sign/bar
	name = "bar"
	name_ru = "���"
	desc = "Here's the BAR"
	desc_ru = "� ��� ��������� ���"
	icon_state = "bar"

/obj/structure/sign/radiation
	name = "radiation sign"
	name_ru = "���� ��������"
	desc = "This sign is not here just for the view."
	desc_ru = "���� ���� ����� ���� �� ��� �������."
	icon_state = "radiation_sign"
	density = 1
	pass_flags = LETPASSTHROW

/obj/structure/sign/stop
	name = "sign"
	name_ru = "����"
	desc = "The signs says - \"Stop! Restricted area!No entry!\""
	desc_ru = "�� �������� �������� - \"����! ��������� ����! ������ ��������!\""
	icon_state = "stop_sign"

/obj/structure/sign/jaba
	name = "sign"
	name_ru = "���������"
	desc = "Jaba. It seems that the local merchant has settled in this basement."
	desc_ru = "����. �������, � ���� ������� ����������� ������� ��������."
	icon_state = "jaba"


/obj/structure/stalker/water
	anchored = 1
	var/busy = 0

/obj/structure/stalker/water/luzha
	name_ru = "����"
	name = "puddle"
	desc = "Ordinary puddle. The water, is not so clean."
	desc_ru = "������������ ����. ����, ����� ��, �� ����� ������."
	icon_state = "luzha"

/obj/structure/stalker/water/luzha/kap
	name_ru = "����"
	name = "puddle"
	desc = "Ordinary puddle. The water, is not so clean."
	desc_ru = "������������ ����. ����, ����� ��, �� ����� ������. ���-���."
	icon_state = "luzha_kap-kap"

/obj/structure/stalker/truba
	name_ru = "�����"
	name = "pipe"
	desc = "Old rusty pipe."
	desc_ru = "������ ������ �����."
	icon_state = "truba"

/obj/structure/stalker/truba/New()
	pixel_y = 4

/obj/structure/stalker/truba/vert
	icon_state = "truba_v"

/obj/structure/stalker/bochka
	name_ru = "�����"
	name = "barrel"
	desc = "Metal barrel."
	desc_ru = "�������� ���������������� �����."
	icon_state = "bochka1"
	density = 1

/obj/structure/stalker/bochka/New()
	var/state = pickweight(list("normal" = 50, "rust" = 20, "rusty" = 10, "green" = 20))
	switch(state)
		if("normal")
			icon_state = "bochka1"
		if("rust")
			icon_state = "bochka2"
		if("rusty")
			icon_state = "bochka3"
		if("green")
			var/state_green = pickweight(list("normal" = 60, "rust" = 25, "rusty" = 15))
			switch(state_green)
				if("normal")
					icon_state = "green_bochka1"
				if("rust")
					icon_state = "green_bochka2"
				if("rusty")
					icon_state = "green_bochka3"

/obj/structure/stalker/bochka/red
	icon_state = "red_bochka1"

/obj/structure/stalker/bochka/red/New()
	var/state = pickweight(list("normal" = 60, "rust" = 25, "rusty" = 15))
	switch(state)
		if("normal")
			icon_state = "red_bochka1"
		if("rust")
			icon_state = "red_bochka2"
		if("rusty")
			icon_state = "red_bochka3"

/obj/structure/stalker/water/bochka
	name_ru = "�����"
	name = "Barrel"
	desc = "Metal barrel, probably filled with rain water."
	desc_ru = "�������� �����, �����������, ������ �����, �������� �����."
	icon_state = "bochka_s_vodoy_1"
	density = 1
	can_storage = 1
	max_w_class = 7
	max_slots = 3

/obj/structure/stalker/water/bochka/New()
	icon_state = "bochka_s_vodoy_[rand(1, 3)]"

/obj/structure/stalker/water/bochka/kap
	name_ru = "�����"
	name = "Barrel"
	desc = "Metal barrel, probably filled with rain water."
	desc_ru = "�������� �����, �����������, ������ �����, �������� �����. ���-���."
	icon_state = "diryavaya_bochka_s_vodoy_1"

/obj/structure/stalker/water/bochka/kap/New()
	icon_state = "diryavaya_bochka_s_vodoy_[rand(1, 3)]"

/obj/structure/stalker/water/attack_hand(mob/living/user)
	if(!user || !istype(user))
		return
	if(!iscarbon(user))
		return
	if(!Adjacent(user))
		return

	if(busy)
		user << user.client.select_lang("<span class='warning'>���-�� ��� ���� ����� ����!</span>","<span class='warning'>Someone's already washing here!</span>")
		return
	var/selected_area = parse_zone(user.zone_selected)
	var/washing_face = 0
	if(selected_area in list("head", "mouth", "eyes"))
		washing_face = 1
	user.direct_visible_message("<span class='notice'>DOER start washing their [washing_face ? "face" : "hands"]...</span>",\
								"<span class='notice'>You start washing your [washing_face ? "face" : "hands"]...</span>",\
								"<span class='notice'>DOER ����� ���� [washing_face ? "����" : "����"]...</span>",\
								"<span class='notice'>�� ����� ���� [washing_face ? "����" : "����"]...</span>","notice",user)
	busy = 1

	if(!do_after(user, 40, target = src))
		busy = 0
		return

	busy = 0

	user.direct_visible_message("<span class='notice'>DOER washes their [washing_face ? "face" : "hands"] using [src].</span>",\
								"<span class='notice'>You wash your [washing_face ? "face" : "hands"] using [src].</span>",\
								"<span class='notice'>DOER ���� [washing_face ? "face" : "hands"] � [name_ru].</span>", \
								"<span class='notice'>�� ���� [washing_face ? "face" : "hands"] � [name_ru].</span>","notice",user)
	if(washing_face)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.lip_style = null //Washes off lipstick
			H.lip_color = initial(H.lip_color)
			H.regenerate_icons()
		user.drowsyness -= rand(2,3) //Washing your face wakes you up if you're falling asleep
		user.drowsyness = Clamp(user.drowsyness, 0, INFINITY)
	else
		user.clean_blood()

/obj/structure/stalker/bochkapiva
	name = "destroyed combat walker"
	name_ru = "������������ ���������������� �����"
	desc = "Millions of dollars, into the fire."
	desc_ru = "�������� �������� �� �����."
	pixel_x = -16
	icon = 'icons/stalker/structure/decorations_64x64.dmi'
	icon_state = "bochkapiva"

/obj/structure/stalker/walkerdecor
	name = "Big guy"
	name_ru = "������� ������"
	desc = "Looks gay."
	desc_ru = "�� ��� �����."
	pixel_x = -8
	icon = 'icons/stalker/structure/decorations_48x48.dmi'
	icon_state = "combatwalker"

/obj/structure/stalker/water/attackby(obj/item/O, mob/user, params)
	if(busy)
		user << user.client.select_lang("<span class='warning'>���-�� ��� ���� ����� ����!</span>","<span class='warning'>Someone's already washing here!</span>")
		return

	if(istype(O, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/RG = O
		if(RG.flags & OPENCONTAINER)
			RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
			user << "<span class='notice'>You fill [RG] from [src].</span>"
			return

	var/obj/item/I = O
	if(!I || !istype(I))
		return
	if(I.flags & ABSTRACT) //Abstract items like grabs won't wash. No-drop items will though because it's still technically an item in your hand.
		return

	user << "<span class='notice'>You start washing [I]...</span>"
	busy = 1
	if(!do_after(user, 40, target = src))
		busy = 0
		return
	busy = 0
	O.clean_blood()
	user.direct_visible_message("<span class='notice'>DOER washes [I] using [src].</span>",\
						"<span class='notice'>You wash [I] using [src].</span>",\
						"<span class='notice'>DOER ����� [I.name_ru] � [name_ru].</span>",\
						"<span class='notice'>�� ����� [I.name_ru] � [name_ru].</span>","notice",user)

/obj/structure/stalker/rozetka
	name_ru = "�������"
	name = "socket"
	desc = "Old soviet socket."
	desc_ru = ""
	icon_state = "rozetka"

/obj/structure/stalker/krest
	name_ru = "�����"
	name = "cross"
	desc = "Wooden cross."
	desc_ru = "���������� �����."
	icon_state = "cross1"
	density = 0

/obj/structure/stalker/krest/Initialize()
	..()
	icon_state = "cross[rand(1,3)]"

/obj/structure/stalker/komod
	name_ru = "�����"
	name = "komod"
	desc = "Ordinary wooden drawer."
	desc_ru = "������������ ���������� �����."
	icon_state = "komod"
	density = 1
	pass_flags = LETPASSTHROW
	can_storage = 1
	max_w_class = 4
	max_slots = 3

/obj/structure/stalker/doski
	name_ru = "�����"
	name = "planks"
	desc = "Broken planks. You can't use them anyway."
	desc_ru = "��������� �����. ������������ ���-���� �� ��� �� ���������."
	icon_state = "doski_oblomki"
	layer = 2.2
	pass_flags = LETPASSTHROW

/obj/structure/stalker/bricks
	name_ru = "�������"
	name = "bricks"
	desc = "Old and dusted, put together in the odd way."
	desc_ru = "������ � �������, ������� � ����������� �����."
	icon_state = "bricks"
	pass_flags = LETPASSTHROW
	density = 1

/obj/structure/stalker/doski/doski2
	icon_state = "doski_oblomki2"

/obj/structure/stalker/doski/doski3
	icon_state = "doski_oblomki3"

/obj/structure/stalker/doski/doski4
	icon_state = "doski_oblomki4"

/obj/structure/stalker/battery
	name_ru = "�������"
	name = "battery"
	desc = "Rusty heating battery. Sometime heated up houses, now - just another piece of metal."
	desc_ru = "������ ������������ �������. �����-�� ��������� ����, ������ - ������ ��������� �������."
	icon_state = "gazovaya_truba"
	can_storage = 1
	max_slots = 1

/obj/structure/stalker/battery/New()
	switch(src.dir)
		if(4)
			pixel_x = -3
		if(8)
			pixel_x = 3

/obj/structure/stalker/vanna
	name = "bath"
	name_ru = "�����"
	desc = "An old cast-iron bath. Nothing special."
	desc_ru = "������ �������� �����. ������ ����������."
	icon = 'icons/stalker/structure/vanna.dmi'
	icon_state = "vanna"
	density = 1
	can_storage = 1
	max_w_class = 6
	max_slots = 5

/obj/structure/stalker/list
	name_ru = "����������� ����"
	name = "stain-roof sheet"
	desc = "Cant be used anymore."
	desc_ru = "������������ ��� ��� ����� �� ���������."
	icon_state = "list_zhesti"

/obj/structure/stalker/propane
	name = "propane"
	name_ru = "������"
	desc = "Propane tank. Flammable."
	desc_ru = "������ � ��������. ����������."
	icon = 'icons/stalker/structure/decorations_32x64.dmi'
	icon_state = "propane"

/obj/structure/stalker/stolb
	name_ru = "�����"
	name = "pillar"
	icon = 'icons/stalker/structure/decorations_32x64.dmi'
	icon_state = "stolb1"
	layer = 4.9
	cast_shadow = TRUE
	icon_height = 64

/obj/structure/stalker/stolb/Initialize()
	..()
	if(icon_state == "stolb1")
		icon_state = "stolb[rand(1, 2)]"
	var/icon/I = new(icon)
	I.Crop(1, 32, 32, 96)
	I.Shift(NORTH, 32)
	overlays += image(I, src, icon_state, layer = 6.9)

/obj/structure/stalker/propane/dual
	icon_state = "propane_dual"

/obj/structure/stalker/pen
	name_ru = "����"
	name = "stump"
	desc = "Regular stump. No more, no less."
	desc_ru = "������� ����. �� ������, �� ������."
	icon_state = "pen"
	layer = 2.24

/obj/structure/stalker/cover
	icon = 'icons/stalker/structure/decorations_64x32.dmi'
	icon_state = "cover"
	can_storage = 1
	max_w_class = 3
	max_slots = 1

/obj/structure/stalker/porog
	name_ru = "�����"
	name = "step"
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "porog1"
	layer = 3.1

/obj/structure/stalker/porog/porog2
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "porog2"

/obj/structure/stalker/televizor
	name_ru = "���������"
	name =  "soviet TV"
	desc = ""
	desc_ru = ""
	icon_state = "TV"
	density = 1
	can_storage = 1
	max_w_class = 3
	max_slots = 2

/obj/structure/stalker/clocks
	name_ru = "������"
	name =  "clocks"
	desc = "Stopped."
	desc_ru = "������������."
	icon = 'icons/stalker/prishtina/decorations_32x32.dmi'
	icon_state = "clocks"

/obj/structure/stalker/painting
	name_ru = "�������"
	icon = 'icons/stalker/prishtina/decorations_32x32.dmi'

/obj/structure/stalker/painting/gorbachev
	name = "painting"
	desc = "Portrait of the last secretary of the CPSU Central Committee."
	desc_ru = "������� ���������� ��������� �� ����."
	icon_state = "gorbachev"

/obj/structure/stalker/painting/stalin
	name = "painting"
	desc = "Portrait of the second secretary of the CPSU Central Committee."
	desc_ru = "������� ������� ��������� �� ����."
	icon_state = "stalin"

/obj/structure/stalker/painting/lenin
	name = "painting"
	desc = "Portrait of the First Secretary of the CPSU Central Committee."
	desc_ru = "������� ������� ��������� �� ����."
	icon_state = "lenin"

/obj/structure/stalker/televizor/broken
	name_ru = "��������� ���������"
	icon_state = "TV_b"
	name =  "broken TV"
	desc = ""
	desc_ru = ""

/obj/structure/stalker/broke_table
	name = "table"
	name_ru = "����"
	desc = "Flipped over table."
	desc_ru = "������������ ����."
	icon_state = "broke_table1"
	density = 1

/obj/structure/stalker/broke_table/right
	icon_state = "broke_table2"

/obj/structure/stalker/lift
	name_ru = "����"
	name = "elevator"
	desc = "Old soviet lift. Probably it will never work again."
	desc_ru = "������ ��������� ����. ��������� ����� �� ��� ������� �� ����������."
	icon_state = "lift"

/obj/structure/stalker/trubas
	name_ru = "�����"
	name = "pipe"
	desc = "Big rusty pipes."
	desc_ru = "������� ������ �����."
	icon = 'icons/stalker/structure/trubas.dmi'
	icon_state = "trubas"

/obj/structure/stalker/sign/bar100rentgen
	name = "sign"
	desc = "A small tablet with a beautiful inscription \"Bar 100 X-ray \""
	desc_ru = "��������� �������� � �������� �������� \"��� 100 �������\""
	icon_state = "100_rentgen"

/obj/structure/stalker/bar_plitka
	name = "tile"
	layer = 2.17
	icon = 'icons/stalker/turfs/floor.dmi'
	icon_state = "bar_plate1"

/obj/structure/stalker/bar_plitka/New()
	..()
	pixel_x = rand(-2, 2)
	pixel_y = rand(-2, 2)

/obj/structure/stalker/katushka
	name_ru = "�������"
	name = "bobbin"
	icon_state = "katushka"
	desc = "A large reel of copper cable."
	desc_ru = "������� ������ ������� ������."
	density = 1

/obj/structure/stalker/corpse
	name_ru = "�������"
	name = "corpse"
	desc = "Oddly enough, dead body looks fresh and doesn't even smell."
	desc_ru = "��� �������. ���� �������� ������ � �� ������."
	icon_state = "dead1"

/obj/structure/stalker/corpse/scientist
	icon_state = "dead2"

/obj/structure/stalker/shkaf
	name = "wardrobe"
	name_ru = "����"
	icon = 'icons/stalker/structure/skhaf.dmi'
	icon_state = "skaf_closed"
	desc = "Big wooden wardrobe. Fancy, but it's so old it has worn out in some places."
	desc_ru = "������� ���������� ����. ��������, �� � ��������� ������ ������ � �����."
	can_storage = 1
	max_w_class = 7
	max_slots = 7


/obj/structure/stalker/papers_pile
	name = "papers pile"
	name_ru = "����� �����"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/papers.dmi'
	icon_state = "papers_pile"
	layer = 2.19

/obj/structure/stalker/papers_pile/New()
	..()
	icon_state = "[icon_state]_ingame"
	for(var/i = 1, i <= 18, i++)
		var/dirr = pick(1, 2, 4, 5, 6, 8, 9, 10)
		var/image/I = image(icon, src, "paper[i]", 2.19, dirr)
		I.pixel_x = rand(-16, 16)
		I.pixel_y = rand(-16, 16)
		add_overlay(I)

/obj/structure/stalker/leaves_pile
	name = "leaves"
	name_ru = "������"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/leaves.dmi'
	icon_state = "leaves_pile"

/obj/structure/stalker/leaves_pile/New()
	..()
	icon_state = "[icon_state]_ingame"
	for(var/n = 1, n <= 48, n++)
//		for(var/i = 1, i <= 16, i++)
		var/dirr = pick(1, 2, 4, 8)
		var/im = rand(1, 16)
		var/image/I = image(icon, src, "leaf[im]", 2.18, dirr)
		I.pixel_x = rand(-20, 20)
		I.pixel_y = rand(-20, 20)
		add_overlay(I)


/obj/structure/stalker/sink
	name = "sink"
	name_ru = "��������"
	desc = "Old broken sink."
	desc_ru = "������ �������� ��������."
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "rakovina"
	can_storage = 1
	max_w_class = 3
	max_slots = 1

/obj/structure/stalker/sink/broken
	icon_state = "rakovina_broken"
	can_storage = 0

/obj/structure/stalker/metallolom
	name = "metal"
	name_ru = "����������"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "metallolom1"

/obj/structure/stalker/metallolom/Initialize()
	. = ..()
	icon_state = "metallolom[rand(1,3)]"

/obj/structure/stalker/vagonetka
	name = "cart"
	name_ru = "���������"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "vagonetka"

/obj/structure/stalker/vagonetka/broken
	icon_state = "vagonetka_broken"

/obj/structure/stalker/metal_thing
	name = "scrap"
	name_ru = "����������"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "metal_thing"
	density = 1
	can_storage = 1
	max_w_class = 6
	max_slots = 4


/obj/structure/stalker/factory_machine
	name = "machine"
	name_ru = "������"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "machine1"
	density = 1
	can_storage = 1
	max_w_class = 6
	max_slots = 2

/obj/structure/stalker/factory_table
	name = "table"
	name_ru = "����"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "table1"
	density = 1
	can_storage = 1
	max_w_class = 3
	max_slots = 4

/obj/structure/stalker/brevna
	name = "logs"
	name_ru = "������"
	desc = ""
	desc_ru = ""
	icon = 'icons/stalker/structure/decor3.dmi'
	icon_state = "brevna1"
	density = 1
	can_storage = 1
	max_w_class = 3
	max_slots = 2

/obj/structure/stalker/hryak
	name = "��������"
	name_ru = "��������"
	desc = "���������� ��������� ��������."
	desc_ru = "���������� ��������� ��������."
	icon = 'icons/stalker/structure/nigger.dmi'
	icon_state = "hryak"

/obj/structure/stalker/trollge
	name = "trollge"
	name_ru = "trollge"
	desc = "step 1) upload ashen sky "
	desc_ru = "step 1) upload ashen sky "
	icon = 'icons/stalker/structure/decor.dmi'
	icon_state = "trollge"

/obj/structure/stalker/amogus
	name = "������"
	name_ru = "������"
	desc = "���������� ���� ������? ������ ����!"
	desc_ru = "���������� ���� ������? ������ ����!"
	icon = 'icons/stalker/structure/nigger.dmi'
	icon_state = "amogus"