/sidoritem
	var/name = null
	var/itemtype = null
	var/cost = 0
	var/list/words = list()

//��������

/sidoritem/ak74
    name = "Akm74/2"
    itemtype = /obj/item/weapon/gun/projectile/automatic/ak74
    cost = 14000
    words = list("�����" = 5, "�����" = 5, "��74" = 5, "ak74" = 5, "�������" = 5, " �������" = 5, "�����������" = 5, "����������" = 5, "�����������" = 5, "�����������" = 10)

/sidoritem/aksu74
    name = "Akm74/2y"
    itemtype = /obj/item/weapon/gun/projectile/automatic/aksu74
    cost = 17000
    words = list("�����������" = 5, "�����������" = 5, "�����" = 5, "�����" = 5, "��74" = 5, "ak74" = 5, "�������" = 5, " �������" = 5, "�����������" = 5, "����������" = 5, "�����������" = 5, "�����������" = 10)

/sidoritem/mp5
    name = "Viper"
    itemtype = /obj/item/weapon/gun/projectile/automatic/mp5
    cost = 12000
    words = list("������" = 5, "��10" = 5, "mp10" = 5, "������" = 5, "�������" = 5, "����" = 5, "������" = 5, "������" = 10)

/sidoritem/groza
    name = "Grom C14"
    itemtype = /obj/item/weapon/gun/projectile/automatic/groza
    cost = 32000
    words = list("����" = 5, "�����" = 5, "�����" = 5, "����" = 5, "����" = 5, "�14" = 5, "C14" = 10)

//����������� ��������

/sidoritem/vintorez
    name = "Vintar VS"
    itemtype = /obj/item/weapon/gun/projectile/automatic/vintorez
    cost = 27000
    words = list("��������" = 5, "�������" = 5, "vintar" = 10)

/sidoritem/val
    name = "Specgun VLA"
    itemtype = /obj/item/weapon/gun/projectile/automatic/val
    cost = 23000
    words = list("���" = 5, "����������� ���" = 5, "���" = 5, "����������� ���" = 5, "specgun vla" = 5, "vla" = 5, "���" = 5, "���" = 10)

//���������

/sidoritem/bm16
    name = "Doublebarrel"
    itemtype = /obj/item/weapon/gun/projectile/revolver/bm16
    cost = 12000
    words = list("����������" = 5, "����������" = 5, "�����" = 5, "�����" = 10)

/sidoritem/toz34
    name = "Tost-34"
    itemtype = /obj/item/weapon/gun/projectile/revolver/bm16/toz34
    cost = 15000
    words = list("����" = 5, "����" = 5, "34" = 10)

/sidoritem/chaser
    name = "Chaser-13"
    itemtype = /obj/item/weapon/gun/projectile/shotgun/chaser
    cost = 20000
    words = list("������" = 5, "������" = 5, "13" = 10)

//�����������

/sidoritem/firstaid/stalker
	name = "Firstaid"
	itemtype = /obj/item/weapon/reagent_containers/pill/stalker/aptechka/civilian
	cost = 500
	words = list("�������" = 5, "�������" = 5, "�������" = 5, "�������" = 5)

/sidoritem/firstaid/army
	name = "Army firstaid"
	itemtype = /obj/item/weapon/reagent_containers/pill/stalker/aptechka/army
	cost = 1000
	words = list("�������" = 5, "�������" = 5, "���������" = 5, "���������" = 5, "�������" = 5, "�������" = 5, "������&#255;" = 5, "������&#255;" = 5, "�������" = 5, "�������" = 5)

/sidoritem/firstaid/science
	name = "Science firstaid"
	itemtype = /obj/item/weapon/reagent_containers/pill/stalker/aptechka/scientific
	cost = 2000
	words = list("�������" = 5, "�������" = 5, "�������" = 5, "�������" = 5, "������&#255;" = 5, "������&#255;" = 5, "�������" = 5, "�������" = 5)

/sidoritem/bint
	name = "Bint"
	itemtype = /obj/item/stack/medical/bruise_pack/bint
	cost = 100
	words = list("����" = 5, "����" = 5)

/sidoritem/antirad
	name = "Antirad"
	itemtype = /obj/item/weapon/reagent_containers/hypospray/medipen/stalker/antirad
	cost = 700
	words = list("�������" = 5, "�������" = 5)

//���

/sidoritem/dogtail
	name = "Dog tail"
	itemtype = /obj/item/weapon/stalker/loot/dog_tail
	cost = 1000

/sidoritem/flesheye
	name = "Flesh Eye"
	itemtype = /obj/item/weapon/stalker/loot/flesh_eye
	cost = 2000

/sidoritem/boarleg
	name = "Boar Leg"
	itemtype = /obj/item/weapon/stalker/loot/boar_leg
	cost = 4000

/sidoritem/konserva
	name = "Canned"
	itemtype = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva
	cost = 200
	words = list("�����" = 5, "�����" = 5, "�������" = 5, "�������" = 5, "��������" = 5, "��������" = 5, "�������" = 5, "�������" = 5, "�������" = 5, "�������" = 5, "�����" = 5, "�����" = 5)

/sidoritem/konserva/shproti
	itemtype = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/shproti
	words = list("�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "������" = 5, "������" = 5, "�������" = 5, "�������" = 5, "�������" = 5, "�������" = 5, "�����" = 5, "�����" = 5)

/sidoritem/konserva/soup
	name = "Canned Soup"
	itemtype = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup
	words = list("�����" = 5, "�����" = 5, "�����������������" = 5, "�����������������" = 5, "����" = 5, "����" = 5, "�����" = 5, "�����" = 5)

/sidoritem/konserva/bobi
	itemtype = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/bobi
	words = list("�����" = 5, "�����" = 5, "����������������" = 5, "����������������" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5)

/sidoritem/konserva/govyadina
	itemtype = /obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/govyadina2
	words = list("�����" = 5, "�����" = 5, "���������������" = 5, "����������������" = 5, "���&#255;����" = 5, "���&#255;����" = 5, "�����" = 5, "�����" = 5)

/sidoritem/kolbasa
	name = "Sausage"
	itemtype = /obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa
	cost = 100
	words = list("�����" = 5, "�����" = 5, "�������" = 5, "�������" = 5, "�������" = 5, "�������" = 10)

/sidoritem/hleb
	name = "Bread"
	itemtype = /obj/item/weapon/reagent_containers/food/snacks/stalker/baton
	cost = 100
	words = list("�����" = 5, "�����" = 5, "������" = 5, "������" = 5, "����" = 5, "����" = 5, "�����" = 5, "�����" = 5)

/sidoritem/vodka
	name = "Kazaki"
	itemtype = /obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/kazaki
	cost = 300
	words = list("�������" = 5, "�������" = 5, "�����" = 5, "�����" = 5, "���&#255;��" = 5, "���&#255;��" = 5 , "������" = 5, "������" = 5, "�����" = 5, "�����" = 10)

/sidoritem/energetic
	name = "NonStop"
	itemtype = /obj/item/weapon/reagent_containers/food/drinks/soda_cans/energetic
	cost = 200
	words = list("���������" = 5, "���������" = 5, "����������" = 5, "����������" = 5, "NonStop" = 5, "nonstop" = 5)

//������ �������� ��&#255;

/sidoritem/knife
	name = "Knife"
	itemtype = /obj/item/weapon/kitchen/knife/tourist
	cost = 600
	words = list("���" = 5, "�����" = 10)

//�������&#255;

/sidoritem/b545
	name = "b545"
	itemtype = /obj/item/ammo_box/stalker/b545
	cost = 2000
	words = list("�������" = 5, "�������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "������" = 5, "������" = 5, "�&#255;������" = 20, "�&#255;������" = 20, "�&#255;�����" = 20, "�&#255;�����" = 20, "5.45x39" = 5, "5.45�39" = 5)

/sidoritem/b545ap
	name = "b545ap"
	itemtype = /obj/item/ammo_box/stalker/b545ap
	cost = 3000
	words = list("�������" = 5, "�������" = 5, "������������" = 5, "������������" = 5, "�����������" = 5, "�����������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "������" = 5, "������" = 5, "�&#255;������" = 20, "�&#255;������" = 20, "�&#255;�����" = 20, "�&#255;�����" = 20, "5.45x39" = 5, "5.45�39" = 5)

/sidoritem/m545
	name = "m545"
	itemtype = /obj/item/ammo_box/magazine/stalker/m545
	cost = 800
	words = list("�������" = 5, "�������" = 5, "������" = 5, "������" = 5, "5.45x39" = 5, "5.45�39" = 5)

/sidoritem/b9x18
	name = "b9x18"
	itemtype = /obj/item/ammo_box/stalker/b9x18
	cost = 1000
	words = list("�������" = 5, "�������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "9x18" = 5, "9�18" = 5)

/sidoritem/b9x18P
	name = "b9x18P"
	itemtype = /obj/item/ammo_box/stalker/b9x18P
	cost = 1500
	words = list("�������" = 5, "�������" = 5, "������������" = 5, "������������" = 5, "�����������" = 5, "�����������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "9x18" = 5, "9�18" = 5)

/sidoritem/m9x18
	name = "m9x18"
	itemtype = /obj/item/ammo_box/magazine/stalker/m9x18pm
	cost = 200
	words = list("�������" = 5, "�������" = 5, "���" = 5, "���" = 5, "���" = 5, "���" = 5, "��1�" = 5, "��1�" = 5, "��1�" = 5, "9x18" = 5, "9�18" = 5)

/sidoritem/f9x18
	name = "f9x18"
	itemtype = /obj/item/ammo_box/magazine/stalker/m9x18fort
	cost = 300
	words = list("�������" = 5, "�������" = 5, "����" = 5, "����" =5, "����" = 5, "����" = 5, "����" = 5, "����" = 5, "9x18f" = 5, "9�18f" = 5)

/sidoritem/b12x70
	name = "b12x70"
	itemtype = /obj/item/ammo_box/stalker/b12x70
	cost = 400
	words = list("�������" = 5, "�������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "���������" = 5, "���������" = 5, "12x70" = 5, "12�70" = 5)

/sidoritem/b12x70P
	name = "b12x70P"
	itemtype = /obj/item/ammo_box/stalker/b12x70P
	cost = 500
	words = list("�������" = 5, "�������" = 5, "������������" = 5, "������������" = 5, "�����������" = 5, "�����������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "���������" = 5, "���������" = 5, "12x70" = 5, "12�70" = 5)

/sidoritem/b12x70D
	name = "b12x70D"
	itemtype = /obj/item/ammo_box/stalker/b12x70D
	cost = 800
	words = list("�������" = 5, "�������" = 5, "�����������" = 5, "�����������" = 5, "����������" = 5, "����������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "���������" = 5, "���������" = 5, "12x70" = 5, "12�70" = 5)

/sidoritem/b9x19
	name = "b9x19"
	itemtype = /obj/item/ammo_box/stalker/b9x19
	cost = 1200
	words = list("�������" = 5, "�������" = 5, "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "������" = 5, "������" = 5, "������" = 5, "������" = 5, "��5" = 5, "��5" = 5, "9x19" = 5, "9�19" = 5)

/sidoritem/b9x19P
	name = "b9x19P"
	itemtype = /obj/item/ammo_box/stalker/b9x19P
	cost = 1700
	words = list("�������" = 5, "�������" = 5, "������������" = 5, "������������" = 5, "�����������" = 5, "�����������", "���������" = 5, "���������" = 5, "������" = 5, "������" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "18x19" = 5, "18�19" = 5)

/sidoritem/p9x19
	name = "p9x19"
	itemtype = /obj/item/ammo_box/magazine/stalker/m9x19marta
	cost = 200
	words = list("�������" = 5, "�������" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "9x19" = 5, "9�19" = 5)

/sidoritem/m9x19g
	name = "m9x19g"
	itemtype = /obj/item/ammo_box/magazine/stalker/m9x19mp5
	cost = 500
	words = list("�������" = 5, "�������" = 5, "������" = 5, "������" = 5, "������" = 5, "������" = 5, "��5" = 5, "��5" = 5, "9x19" = 5, "9�19" = 5)

/sidoritem/sc45
	name = "sc45"
	itemtype = /obj/item/ammo_box/magazine/stalker/sc45
	cost = 300
	words = list("�������" = 5, "�������" = 5, "����" = 5, "����" = 5, "����" = 5, "����" = 5, "����" = 5, "����" = 5, "����" = 5, "����" = 5, "45" = 5)

/sidoritem/sp9x39vint
	name = "sp9x39vint"
	itemtype = /obj/item/ammo_box/magazine/stalker/sp9x39vint
	cost = 700
	words = list("�������" = 5, "�������" = 5, "���������" = 5, "���������" = 5, "���������" = 5, "���������" = 5, "9x39" = 5, "9�39" = 5)

/sidoritem/sp9x39val
	name = "sp9x39val"
	itemtype = /obj/item/ammo_box/magazine/stalker/sp9x39val
	cost = 1200
	words = list("�������" = 5, "�������" = 5, "����" = 5, "����" = 5, "����" = 5, "����" = 5, "���" = 5, "���" = 5, "9x39" = 5, "9�39" = 5)

/sidoritem/sp9x39groza
	name = "sp9x39groza"
	itemtype = /obj/item/ammo_box/magazine/stalker/sp9x39groza
	cost = 1200
	words = list("�������" = 5, "�������" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "�����" = 5, "9x39" = 5, "9�39" = 5)



//���������

/sidoritem/meduza
	name = "Meduza"
	itemtype = /obj/item/weapon/artefact/meduza
	cost = 2000

/sidoritem/stoneflower
	name = "Stoneflower"
	itemtype = /obj/item/weapon/artefact/stoneflower
	cost = 5000

/sidoritem/nighstar
	name = "Nightstar"
	itemtype = /obj/item/weapon/artefact/nightstar
	cost = 8000

/sidoritem/maminibusi
	name = "Mamini busi"
	itemtype = /obj/item/weapon/artefact/maminibusi
	cost = 30000

/sidoritem/flash
	name = "Flash"
	itemtype = /obj/item/weapon/artefact/flash
	cost = 3000

/sidoritem/moonlight
	name = "Moonlight"
	itemtype = /obj/item/weapon/artefact/moonlight
	cost = 5000

/sidoritem/pushtishka
	name = "Pushtishka"
	itemtype = /obj/item/weapon/artefact/pustishka
	cost = 30000

/sidoritem/battery
	name = "Battery"
	itemtype = /obj/item/weapon/artefact/battery
	cost = 30000

/sidoritem/droplet
	name = "Droplet"
	itemtype = /obj/item/weapon/artefact/droplet
	cost = 2500

/sidoritem/fireball
	name = "Fireball"
	itemtype = /obj/item/weapon/artefact/fireball
	cost = 6000

/sidoritem/crystal
	name = "Crystal"
	itemtype = /obj/item/weapon/artefact/crystal
	cost = 40000

//������

/sidoritem/guitar
	name = "Guitar"
	itemtype = /obj/item/device/instrument/guitar
	cost = 3000
	words = list("������" = 5, "������" = 5, "������" = 5, "������" = 5)

/sidoritem/geiger
	name = "Geiger Counter"
	itemtype = /obj/item/device/geiger_counter
	cost = 500
	words = list("�������" = 5, "�������" = 5, "�������" = 5, "�������" = 5)

/sidoritem/shovel
	name = "Shovel"
	itemtype = /obj/item/weapon/shovel
	cost = 1500
	words = list("������" = 5, "������" = 5, "������" = 5, "������" = 5)

/sidoritem/flashlight
	name = "flashlight"
	itemtype = /obj/item/device/flashlight/seclite
	cost = 500
	words = list("������" = 5, "������" = 5, "�������" = 5, "�������" = 5)

/sidoritem/artefactbelt
	name = "artbelt"
	itemtype = /obj/item/weapon/storage/belt/stalker
	cost = 500
	words = list("��&#255;�" = 5, "��&#255;�" = 5, "����������" = 5, "����������" = 5)

/sidoritem/radio
	name = "radio"
	itemtype = /obj/item/device/radio
	cost = 600
	words = list("�����" = 5, "�����" = 10)

/sidoritem/mathes
	name = "match"
	itemtype = /obj/item/weapon/storage/box/matches
	cost = 50
	words = list("������" = 5, "������" = 5, "������" = 5, "������" = 5)

/sidoritem/cigars
	name = "cigars"
	itemtype = /obj/item/weapon/storage/fancy/cigarettes/cigpack/maxim
	cost = 200
	words = list("��������" = 5, "��������" = 5, "�������" = 5, "�������" = 5)

/sidoritem/cigarsup
	name = "cigars"
	itemtype = /obj/item/weapon/storage/fancy/cigarettes/cigars
	cost = 5000
	words = list("������" = 5, "������" = 5, "�����" = 5, "�����" = 5)