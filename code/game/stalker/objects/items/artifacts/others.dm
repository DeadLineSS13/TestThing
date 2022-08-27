
//	��������� ��������� �� ����� �������	//

/obj/item/artefact/others
	light_color = LIGHT_COLOR_PINK

/obj/item/artefact/others/emerald
	name = "Emerald"
	name_ru = "�������"
	icon_state = "emerald"
	lick_message = ""
	lick_message_ru = "�� ���� ��� ������ ������� �������."

	effects = list("agi" = 1, "int" = 1, "hlt_dice" = 1)
	var/hitted = 0

/obj/item/artefact/others/emerald/hit(mob/user, str_bonus = 0)
	..()
	if(hitted)
		return
	if(user.rolld(dice6(3), user.str - 4 + str_bonus))
		user << sanitize_russian(user.client.select_lang("<i><span class='notice'>� [name_ru] ��������� �������, �� ������� ������� ������ ���.</span></i>",
														"<i><span class='notice'>There is a crack in [name] from which green smoke oozes.</span></i>"))
		hitted = 1
		spawn(dice6(2) SECONDS)
			var/obj/effect/particle_effect/smoke/S = new(get_turf(src))
			qdel(src)
			S.color = "#306e23"
			S.amount = 5
			S.lifetime = 30
			S.anomaly_reagent = "rustpuddle"
			S.spread_smoke()



/obj/item/artefact/others/spike
	name = "spike"
	name_ru = "���"
	icon_state = "spike"

	lick_message = ""
	lick_message_ru = "��! ��������..."

	effects = list("hlt" = 2)

/obj/item/artefact/others/spike/lick()
	usr.direct_visible_message("<span class='notice'>DOER licked TARGET</span", message_ru = "<span class='notice'>DOER ������ TARGET</span>", span_class = "notice", doer = usr, target = src)
	usr << sanitize_russian(usr.client.select_lang("<i><span class='warning'>[lick_message_ru]</span></i>", "<i><span class='warning'>[lick_message]</span></i>"))
	for(var/mob/living/carbon/human/H in view(7, usr))
		H.give_exp(3, "[name]_lick", 1)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/organ/limb/head = H.get_organ("head")
		head.take_damage(0, 1, 0)

/obj/item/artefact/others/spike/compress()
	..()
	usr << sanitize_russian(usr.client.select_lang("<i><span class='warning'>[lick_message_ru]</span></i>", "<i><span class='warning'>[lick_message]</span></i>"))
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/organ/limb/arm = H.get_organ("[H.held_index_to_dir(H.active_hand_index)]_arm")
		arm.take_damage(0, 1, 0)


/obj/item/artefact/others/spike/hit(mob/user, str_bonus = 0)
	..()
	if(!str_bonus)
		usr << sanitize_russian(usr.client.select_lang("<i><span class='warning'>[lick_message_ru]</span></i>", "<i><span class='warning'>[lick_message]</span></i>"))
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			var/obj/item/organ/limb/arm = H.get_organ("[H.held_index_to_dir(H.active_hand_index)]_arm")
			arm.take_damage(0, 1, 0)


/obj/item/artefact/others/radio
	name = "Radio"
	name_ru = "�����"
	icon_state = "radio"

	lick_message = ""
	lick_message_ru = ""

	var/cutted = 0
	var/with_artefact = 1

	var/list/trash_messages = list("")
	var/list/trash_messages_ru = list("")
	var/list/good_messages = list("")
	var/list/good_messages_ru = list("")

/obj/item/artefact/others/radio/Initialize()
	..()
	SSartefacts.processing.Add(src)

/obj/item/artefact/others/radio/Destroy()
	SSartefacts.processing.Remove(src)
	..()

/obj/item/artefact/others/radio/process()
	var/dice = dice6(3)
	if(dice == 17 || dice == 18)
		say(pick(good_messages), pick(good_messages_ru))
	else
		say(pick(trash_messages), pick(trash_messages_ru))

/obj/item/artefact/others/radio/cut()
	..()
	flick("radio_use", src)
	icon_state = "radio_2"
	icon_hands = "radio_2"
	cutted = 1

/obj/item/artefact/others/radio/attack_hand(mob/user)
	if(cutted && with_artefact)
		var/obj/item/artefact/others/myachink/M = new()
		user.put_in_hands(M)
		icon_state = "radio_3"
		icon_hands = "radio_3"
		with_artefact = 0
	else
		return ..()



/obj/item/artefact/others/myachink
	name = "Ball"
	name_ru = "���"
	icon_state = "myachik"

	lick_message = ""
	lick_message_ru = "�� ���� ��� ������, ������� ���-�� �����."

	effects = list("mind_reading" = 1, "int" = 1, "agi" = -2)


/obj/item/artefact/others/hotstar
	name = "Hotstar"
	name_ru = "�������� ������"
	icon_state = "hotstar"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/trash
	name = "Trash"
	name_ru = "����"
	icon_state = "trash"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/garbage
	name = "Garbage"
	name_ru = "�����"
	icon_state = "garbage"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/case
	name = "Case"
	name_ru = "��������"
	icon_state = "case"
	effects = list("agi" = 1, "int" = 1)


/obj/item/artefact/others/pantsir
	name = "Pantsir"
	name_ru = "�������"
	icon_state = "pantsir"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/powercell
	name = "Powercell"
	name_ru = "���������"
	icon_state = "powercell"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/orb
	name = "Orb"
	name_ru = "���"
	icon_state = "orb"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/clonegun
	name = "Clonegun"
	name_ru = "Clonegun"
	icon_state = "clonegun"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/mandragora
	name = "Mandragora"
	name_ru = "����������"
	icon_state = "mandragora"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/brelok
	name = "Brelok"
	name_ru = "������"
	icon_state = "brelok"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/heart
	name = "Heart"
	name_ru = "������ ����"
	icon_state = "heart"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/wrench
	name = "Wrench"
	name_ru = "���������� ������� ����"
	icon_state = "anowrench"
	effects = list("agi" = 1, "int" = 1)


/obj/item/artefact/others/crowbar
	name = "Crowbar"
	name_ru = "���������� �����"
	icon_state = "anocrowbar"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/rakushka
	name = "Rakushka"
	name_ru = "�������"
	icon_state = "rakushka"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/stiralka
	name = "Stiralka"
	name_ru = "��������"
	icon_state = "stiralka"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/vodorosl
	name = "Vodorosl"
	name_ru = "���������"
	icon_state = "vodorosl"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/kletka
	name = "Kletka"
	name_ru = "������"
	icon_state = "kletka"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/zub
	name = "Tooth"
	name_ru = "���"
	icon_state = "zub"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/stoneknife
	name = "Stone Knife"
	name_ru = "�������� ���"
	icon_state = "stoneknife"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/latun
	name = "Latun"
	name_ru = "������"
	icon_state = "latun"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/virus
	name = "Virus"
	name_ru = "�����"
	icon_state = "virus"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/sterjen
	name = "Sterjen"
	name_ru = "��������"
	icon_state = "sterjen"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/shusha
	name = "shusha"
	name_ru = "����"
	icon_state = "shusha"
	effects = list("agi" = 1, "int" = 1)

/obj/item/artefact/others/berry
	name = "Berry"
	name_ru = "�����"
	icon_state = "berry"
	effects = list("agi" = 1, "int" = 1)