var/list/real_sidormat_items = list()

/datum/data/stalker_equipment
	var/name_en = "generic"
	var/name_ru = "generic"
	var/equipment_path = null
	var/cost = 0
	var/initial_cost = 0
	var/sale_price = 0
	var/can_be_bought = 1
	var/can_be_sold = 1
	var/assortment_level = 0
	var/estimated_supply = 0	//�������������� �����������
	var/estimated_demand = 0	//�������������� �����
	var/total_bought = 0		//������� ������� �����
	var/total_sold = 0			//������� ������� �����

/datum/data/stalker_equipment/New(nameen, nameru, path, cost_, saleprice = 0, assortmentlevel = 50, buyable = 1, sellable = 1)
	name_en = nameen
	name_ru = nameru
	equipment_path = path
	cost = cost_
	initial_cost = cost
	can_be_bought = buyable
	can_be_sold = sellable
	if(can_be_sold)
		assortment_level = assortmentlevel
	if(can_be_bought)
		if(saleprice)
			src.sale_price = saleprice
		else
			src.sale_price = cost/2

	estimated_demand = assortment_level
	estimated_supply = assortment_level
	real_sidormat_items += src

/client/proc/edit_sidormat_datums()
	set category = "Stalker"
	set name = "Edit Sidormat Datums"

	debug_variables(real_sidormat_items)

var/list/global_sidormat_list = list(
		///////////////////////////////  ������  /////////////////////////////////////////
	"Handguns" = list(
		///////////////////////////// **���������** /////////////////////////////////////
		new /datum/data/stalker_equipment("TT",				"��",				/obj/item/weapon/gun/projectile/automatic/pistol/tt,				10000, 0, 10),
		new /datum/data/stalker_equipment("PM",				"��",				/obj/item/weapon/gun/projectile/automatic/pistol/pm,				10000, 0, 10),
		new /datum/data/stalker_equipment("Fort-12",		"����-12",			/obj/item/weapon/gun/projectile/automatic/pistol/fort12,			10000, 0, 10),
		new /datum/data/stalker_equipment("PYa",			"��",				/obj/item/weapon/gun/projectile/automatic/pistol/yarigin,			30000, 0, 5),
		new /datum/data/stalker_equipment("Gyurza",			"�����",			/obj/item/weapon/gun/projectile/automatic/pistol/gyurza,			30000, 0, 5),
		new /datum/data/stalker_equipment("Beretta",		"�������",			/obj/item/weapon/gun/projectile/automatic/pistol/m92,				30000, 0, 5),
		new /datum/data/stalker_equipment("Colt",			"�����",			/obj/item/weapon/gun/projectile/automatic/pistol/colt,				30000, 0, 5)
//		new /datum/data/stalker_equipment("FN 5-7",			"�� 5-7",			/obj/item/weapon/gun/projectile/automatic/pistol/fn,				50000),
//		new /datum/data/stalker_equipment("Glock 17",		"���� 17",			/obj/item/weapon/gun/projectile/automatic/pistol/glock,				50000),
//		new /datum/data/stalker_equipment("Colt .44",		"����� .44",		/obj/item/weapon/gun/projectile/revolver/anaconda,					50000),
//		new /datum/data/stalker_equipment("Desert Eagle",	"��������� ����",	/obj/item/weapon/gun/projectile/automatic/pistol/m92,				75000),
		),

	"Small arms" = list(
		///////////////////////////// **�������� ������** ///////////////
		new /datum/data/stalker_equipment("Kiparis",		"�������",			/obj/item/weapon/gun/projectile/automatic/kiparis,					20000, 0, 7),
		new /datum/data/stalker_equipment("Veresk",			"������",			/obj/item/weapon/gun/projectile/automatic/veresk,					35000, 0, 4),
		new /datum/data/stalker_equipment("MP5",			"��5",				/obj/item/weapon/gun/projectile/automatic/mp5,						75000, 0, 2),
		new /datum/data/stalker_equipment("Bizon",			"�����",			/obj/item/weapon/gun/projectile/automatic/bizon,					75000, 0, 2),
		new /datum/data/stalker_equipment("AK-74S",			"��-74�",			/obj/item/weapon/gun/projectile/automatic/aksu74 ,					75000, 0, 2)
//		new /datum/data/stalker_equipment("P90",			"P90",				/obj/item/weapon/gun/projectile/automatic/mp5,						200000),
		),

	"Long arms" = list(
		///////////////////////////// **������� ������** ////////////////
		new /datum/data/stalker_equipment("SKS",			"���",				/obj/item/weapon/gun/projectile/automatic/sks,						35000, 0, 4),
		new /datum/data/stalker_equipment("AK-74",			"��-74",			/obj/item/weapon/gun/projectile/automatic/ak74,						75000, 0, 2),
		new /datum/data/stalker_equipment("AKM",			"���",				/obj/item/weapon/gun/projectile/automatic/ak74/akm,					100000, 0, 1)
//		new /datum/data/stalker_equipment("Val",			"���",				/obj/item/weapon/gun/projectile/automatic/val,						100000),
//		new /datum/data/stalker_equipment("A-545",			"�-545",			/obj/item/weapon/gun/projectile/automatic/a545,						200000),
//		new /datum/data/stalker_equipment("M16",			"�16",				/obj/item/weapon/gun/projectile/automatic/m16,						200000),
//		new /datum/data/stalker_equipment("FN Fal",			"�� ���",			/obj/item/weapon/gun/projectile/automatic/fal,						300000),
		),

	"Shotguns" = list(
		/////////////////////////////// **���������** /////////////////////////////////////
		new /datum/data/stalker_equipment("Sawn-off",		"����� ������������",/obj/item/weapon/gun/projectile/revolver/bm16/sawnoff,				20000, 0, 7),
		new /datum/data/stalker_equipment("Horizontal shotgun","������������",	/obj/item/weapon/gun/projectile/revolver/bm16,						20000, 0, 7),
		new /datum/data/stalker_equipment("Vertical shotgun","����������",	 	/obj/item/weapon/gun/projectile/revolver/bm16/toz34,				20000, 0, 7),
		new /datum/data/stalker_equipment("Old pump shotgun","������ ��������",	/obj/item/weapon/gun/projectile/shotgun/chaser,						35000, 0, 4),
		new /datum/data/stalker_equipment("Saiga",			"�����",			/obj/item/weapon/gun/projectile/automatic/saiga,					75000, 0, 2)
//		new /datum/data/stalker_equipment("Striker",		"��������",	 		/obj/item/weapon/gun/projectile/automatic/striker,					150000, 0, 1)
		),

	"Melee Weapons" = list(
		/////////////////////////////// **������** /////////////////////////////////////
		new /datum/data/stalker_equipment("Survival Knife",	"��� ��� ���������",/obj/item/weapon/kitchen/knife/tourist,					5000, 0, 20),
		new /datum/data/stalker_equipment("Switchblade",	"�������� �����"	,/obj/item/weapon/kitchen/knife/vykid,					5000, 0, 20)
		),

	"Ammo Boxes" = list(
		////////////////////////////////  �������  /////////////////////////////////////////
		new /datum/data/stalker_equipment("7.62x25mm Box",			"������� 7.62x25��",						/obj/item/ammo_box/stalker/b762x25,						2000, 0, 40),
		new /datum/data/stalker_equipment("9x18mm Box",				"������� 9�18��",							/obj/item/ammo_box/stalker/b9x18,						2000, 0, 40),
//		new /datum/data/stalker_equipment("9x18mm +P+ Box",			"������� 9x18�� +�+",						/obj/item/ammo_box/stalker/b9x18P,						3000, 0, 30),
		new /datum/data/stalker_equipment("9x19mm Box",				"������� 9x19��",							/obj/item/ammo_box/stalker/b9x19,						3000, 0, 30),
		new /datum/data/stalker_equipment("9x19mm AP Box",			"������� 9x19�� �����������",				/obj/item/ammo_box/stalker/b9x19P,						6000, 0, 18),
		new /datum/data/stalker_equipment("9x21mm Box",				"������� 9x21��",							/obj/item/ammo_box/stalker/b9x21,						6000, 0, 18),
		new /datum/data/stalker_equipment(".45 ACP Box",			"������� .45 ACP",							/obj/item/ammo_box/stalker/bacp45,						5000, 0, 20),
/*		new /datum/data/stalker_equipment(".45 ACP expansive Box",	"������� .45 ACP ������������",				/obj/item/ammo_box/stalker/bacp45ap,					5000, 0, 20),
		new /datum/data/stalker_equipment(".44 Magnum Box",			"������� .44 ������",						/obj/item/ammo_box/stalker/bmag44,						10000, 0, 10),*/
		new /datum/data/stalker_equipment("12G Buckshot Box",		"������� ����� 12G",						/obj/item/ammo_box/stalker/b12x70,						5000, 0, 35),
		new /datum/data/stalker_equipment("12F Slug Box",			"������� ������� �������� 12G",				/obj/item/ammo_box/stalker/b12x70P,						5000, 0, 15),
		new /datum/data/stalker_equipment("5.45x39mm Box",			"������� 5.45�39��",						/obj/item/ammo_box/stalker/b545,						10000, 0, 10),
		new /datum/data/stalker_equipment("5.45x39mm AP Box",		"������� 5.45�39�� �����������",			/obj/item/ammo_box/stalker/b545ap,						20000, 0, 5),
		new /datum/data/stalker_equipment("7.62x39mm Box",			"������� 7.62�39��",						/obj/item/ammo_box/stalker/b762x39,						15000, 0, 3)
		),

	"Magazines and Clips" = list(
		new /datum/data/stalker_equipment("PM Magazine",							"������� � ��",					/obj/item/ammo_box/magazine/stalker/m9x18pm,			1000, 0, 60),
		new /datum/data/stalker_equipment("TT Magazine",							"������� � ��",					/obj/item/ammo_box/magazine/stalker/tt,					1000, 0, 60),
		new /datum/data/stalker_equipment("Fort-12 Magazine",						"������� � ����-12",			/obj/item/ammo_box/magazine/stalker/m9x18fort,			1000, 0, 60),
		new /datum/data/stalker_equipment("Colt M1911 Magazine",					"������� � ������",				/obj/item/ammo_box/magazine/stalker/sc45,				1000, 0, 60),
		new /datum/data/stalker_equipment("Beretta 92 Magazine",					"������� � ������� 92",			/obj/item/ammo_box/magazine/stalker/m9x19marta,			1000, 0, 60),
		new /datum/data/stalker_equipment("PYa Magazine",							"������� � ��",					/obj/item/ammo_box/magazine/stalker/yarigin,			1000, 0, 60),
		new /datum/data/stalker_equipment("Gyurza Magazine",						"������� � �����",				/obj/item/ammo_box/magazine/stalker/gyurza,				1000, 0, 60),
		new /datum/data/stalker_equipment("Kiparis Magazine",						"������� � ��������",			/obj/item/ammo_box/magazine/stalker/kiparis,			2000, 0, 30),
		new /datum/data/stalker_equipment("Veresk Magazine",						"������� � �������",			/obj/item/ammo_box/magazine/stalker/veresk,				2000, 0, 30),
		new /datum/data/stalker_equipment("MP-5 Magazine",							"������� � ��-5",				/obj/item/ammo_box/magazine/stalker/m9x19mp5,			2000, 0, 30),
		new /datum/data/stalker_equipment("Bizon Magazine",							"������� � ������",				/obj/item/ammo_box/magazine/stalker/bizon,				3000, 0, 15),
		new /datum/data/stalker_equipment("AK Magazine",							"������� � ��",					/obj/item/ammo_box/magazine/stalker/m545,				3000, 0, 15),
		new /datum/data/stalker_equipment("AKM Magazine",							"������� � ���",				/obj/item/ammo_box/magazine/stalker/akm,				3000, 0, 15),
		new /datum/data/stalker_equipment("Saiga Magazine",							"������� � �����",				/obj/item/ammo_box/magazine/stalker/saiga,				2000, 0, 10),
		new /datum/data/stalker_equipment("SKS Clip",								"������ � ���",					/obj/item/ammo_box/stalker/sks/cl762x39,				2000, 0, 30)
//		new /datum/data/stalker_equipment("SVD Magazine",							"������� � ���",				/obj/item/ammo_box/magazine/stalker/svd,				2000, 0, 30)
		),

	"Armor vests" = list(
		///////////////////////////////  �����  /////////////////////////////////////////
		new /datum/data/stalker_equipment("Old armor vest",				"������ ����������",				/obj/item/clothing/suit/obolochka,							30000, 0, 7),
		new /datum/data/stalker_equipment("'Kazak' armor vest",			"���������� '�����'",				/obj/item/clothing/suit/kazak,								75000, 0, 3)
//		new /datum/data/stalker_equipment("'Karatel' heavy armor vest",	"������� ���������� '��������'",	/obj/item/clothing/suit/karatel,							150000, 0, 1),
//		new /datum/data/stalker_equipment("'Hawk' armor vest",			"���������� '������'",				/obj/item/clothing/suit/hawk,								150000),
//		new /datum/data/stalker_equipment("'Heracles' heavy armor vest","������� ���������� '������'",		/obj/item/clothing/suit/heracles,							500000),
		),

	"Coats and jackets" = list(
		///////////////////////////////  �����  /////////////////////////////////////////
		new /datum/data/stalker_equipment("Leather jacket",				"�������",							/obj/item/clothing/suit/leatherjacket,									5000, 0, 30),
		new /datum/data/stalker_equipment("Black trenchcoat",			"������ ����",						/obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack,				10000, 0, 20),
		new /datum/data/stalker_equipment("Brown trenchcoat",			"���������� ����",					/obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack/coatbrown,	10000, 0, 20),
		new /datum/data/stalker_equipment("OZK",						"���",								/obj/item/clothing/suit/hooded/kozhanka/ozk,							30000, 0, 7)
		),

	"Masks and Helmets" = list(
		////////////////////////////	�����, �����	/////////////////////////////////////
		new /datum/data/stalker_equipment("Ukrainian beret",			"���������� �����",				/obj/item/clothing/head/beret_ua,								2000, 0, 20),
		new /datum/data/stalker_equipment("Old gasmask",				"������ ����������",			/obj/item/clothing/mask/gas/stalker,							10000, 0, 15),
		new /datum/data/stalker_equipment("M40 gasmask",				"���������� �40",				/obj/item/clothing/mask/gas/stalker/mercenary,					30000, 0, 8),
		new /datum/data/stalker_equipment("Steel helmet",				"�����-�������",				/obj/item/clothing/head/steel,									10000, 0, 20),
		new /datum/data/stalker_equipment("\"Kazak\" helmet",			"���� \"�����\"",				/obj/item/clothing/head/kazak,									30000, 0, 7)
//		new /datum/data/stalker_equipment("'Karatel' armored helmet",	"��������� '��������'",			/obj/item/clothing/head/karatel,								75000, 0, 2),
//		new /datum/data/stalker_equipment("'Hawk' helmet",				"���� '������'",				/obj/item/clothing/head/hawk,									75000),
//		new /datum/data/stalker_equipment("'Heracles' armored helmet",	"��������� '������'",			/obj/item/clothing/head/steel,									150000),
		),

	"Medicine" = list(
		///////////////////////////////	�����������	/////////////////////////////////////////
		new /datum/data/stalker_equipment("Medicine kit",				"����������� �����",				/obj/item/weapon/medicine_kit,								10000, 0, 10),
		new /datum/data/stalker_equipment("Bandage",					"����",								/obj/item/stack/medical/bruise_pack/bint,					2500, 0, 100),
		new /datum/data/stalker_equipment("Synthskin patch",			"������������ ��������",			/obj/item/stack/medical/bruise_pack/synth_bint,				5000, 0, 30),
		new /datum/data/stalker_equipment("Cellular stimulator",		"��������� ����������",				/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/low,	5000, 0, 50),
		new /datum/data/stalker_equipment("Cellular stimulator MkII",	"��������� ���������� MKII",		/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/medium,	20000, 0, 10),
		new /datum/data/stalker_equipment("Morphite",					"������",							/obj/item/weapon/reagent_containers/hypospray/medipen/morphite,	2500, 0, 50),
		new /datum/data/stalker_equipment("Hyperstim",					"���������������",					/obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator,	2500, 0, 50),
		new /datum/data/stalker_equipment("Adrenaline injector",		"������������� ��������",			/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline,	5000, 0, 50)
		),

	"Food" = list(
		/////////////////////////////////	���	///////////////////////////////////////////
		new /datum/data/stalker_equipment("Canned stew",				"�������",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva,				500, 0, 50),
		new /datum/data/stalker_equipment("Premium canned stew",		"������������ �������",		/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/govyadina2,	1000, 0, 25),
		new /datum/data/stalker_equipment("Canned fish",				"������",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/shproti,		500, 0, 50),
		new /datum/data/stalker_equipment("Salami",						"�������",					/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,				500, 0, 50),
		new /datum/data/stalker_equipment("Bread",						"�����",					/obj/item/weapon/reagent_containers/food/snacks/stalker/baton,					500, 0, 50),
		new /datum/data/stalker_equipment("Canned soup",				"���������������� ���",		/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup,			1000, 0, 25),
		new /datum/data/stalker_equipment("Canned buckwheat",			"��������� ����",			/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/buckwheat,		1000, 0, 25),
		new /datum/data/stalker_equipment("Canned beans",				"���������������� ����",	/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/bobi,			500, 0, 50),
		new /datum/data/stalker_equipment("Canned fish",				"���������������� ����",	/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/fish,		500, 0, 50),
		new /datum/data/stalker_equipment("Cream cheese",				"��������� ���",			/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/sirok,	1000, 0, 25),
		new /datum/data/stalker_equipment("Chocolate bar",				"������ ��������",			/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/chocolate,1000, 0, 25),
		new /datum/data/stalker_equipment("Biscuits",					"������",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/galets,		500, 0, 50),
		new /datum/data/stalker_equipment("Cerreal",					"����",						/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/kasha,			500, 0, 50),
		new /datum/data/stalker_equipment("Snickers",					"�������",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/snikers,	500, 0, 50),
		new /datum/data/stalker_equipment("Mars",						"����",						/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/mars,	500, 0, 50)
		),

	"Drinks" = list(
		new /datum/data/stalker_equipment("Vodka \"Kazaki\"",			"����� \"������\"",			/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/kazaki,			1000, 0, 25),
		new /datum/data/stalker_equipment("Energy drink \"NonStop\"",	"��������� \"NonStop\"",	/obj/item/weapon/reagent_containers/food/drinks/soda_cans/energetic,			500, 0, 50),
		new /datum/data/stalker_equipment("Beer 'Ohota Strong'",		"���� '����� �������'",		/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/ohota,			1000, 0, 40),
		new /datum/data/stalker_equipment("Beer 'Obolon'",				"���� '�������'",			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/obolon,			1000, 0, 40),
		new /datum/data/stalker_equipment("Beer 'Stepan Razin'",		"���� '������ �����'",		/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/razin,			1000, 0, 40),
		new /datum/data/stalker_equipment("Beer 'Zhatetsky Gus'",		"���� '�������� ����'",		/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/gus,				1000, 0, 40)
		),

//	"Bacpacks" = list(
//		new /datum/data/stalker_equipment("Cheap satchel",					"������� �����",		/obj/item/weapon/storage/backpack/satchel/stalker/civilian,					2500),
//		new /datum/data/stalker_equipment("Cheap backpack",					"������� ������",			/obj/item/weapon/storage/backpack/stalker/civilian,							2500),
//		new /datum/data/stalker_equipment("Tourist backpack",				"������ �������",			/obj/item/weapon/storage/backpack/stalker/tourist,							6000),
//		new /datum/data/stalker_equipment("Professional backpack",			"������ �������������",		/obj/item/weapon/storage/backpack/stalker/professional,						11000)
//		),

	"Misc" = list(
		/////////////////////////////////	������	/////////////////////////////////////////////
//		new /datum/data/stalker_equipment("Repair-kit for suits and helmets",	"���. �������� ��� ������������� � ������",		/obj/item/device/repair_kit/clothing,						10000),
//		new /datum/data/stalker_equipment("Repair-kit for guns",				"���. �������� ��� �������������� ������",	/obj/item/device/repair_kit/gun,							4000),
//		new /datum/data/stalker_equipment("Big artefact belt",					"������� ���� ��� ����������",				/obj/item/weapon/storage/belt/stalker/artefact_belt,		60000),
//		new /datum/data/stalker_equipment("Small artefact belt",				"��������� ���� ��� ����������",			/obj/item/weapon/storage/belt/stalker/artefact_belt/small,	25000),
//		new /datum/data/stalker_equipment("Geiger counter",						"��������",												/obj/item/device/geiger_counter,							3000),
		new /datum/data/stalker_equipment("Cauldron",							"�������",												/obj/item/weapon/reagent_containers/food/cauldron,			2000, 0, 20),
		new /datum/data/stalker_equipment("Flashlight",							"�������",												/obj/item/device/flashlight/seclite,						1000, 0, 40),
		new /datum/data/stalker_equipment("Matches",							"������",												/obj/item/weapon/storage/box/matches,						1000, 0, 100),
		new /datum/data/stalker_equipment("Simple lighter",						"����������� ���������",								/obj/item/weapon/lighter/greyscale,							5000, 0, 60),
		new /datum/data/stalker_equipment("Zippo lighter",						"��������� \"�����\"",									/obj/item/weapon/lighter,									5000, 0, 20),
		new /datum/data/stalker_equipment("Cigarettes \"Maxim\"",				"�������� \"Maxim\"",									/obj/item/weapon/storage/fancy/cigarettes/cigpack/maxim,	2500, 0, 100),
		new /datum/data/stalker_equipment("Cigars",								"������",												/obj/item/weapon/storage/fancy/cigarettes/cigars,			10000, 0, 5)
		),

	"Other equipment" = list(
		new /datum/data/stalker_equipment("Balaclava",							"���������",											/obj/item/clothing/mask/balaclava,							1000, 0, 100),
		new /datum/data/stalker_equipment("Rubber boots",						"��������� ������",										/obj/item/clothing/shoes/jackboots/ozk,						2500, 0, 10),
		new /datum/data/stalker_equipment("Rubber gloves",						"��������� ��������",									/obj/item/clothing/gloves/ozk,								2500, 0, 10)
		),

/*
	"Attachments" = list(
		/////////////////////////////////	����������	///////////////////////////////////////////
		new /datum/data/stalker_equipment("Universl suppressor",	"������������� ���������",					/obj/item/weapon/attachment/suppressor,				2000),
		new /datum/data/stalker_equipment("SUSAT",					"�����",									/obj/item/weapon/attachment/scope/SUSAT,			8000),
		new /datum/data/stalker_equipment("PSU-1",					"���-1",									/obj/item/weapon/attachment/scope/PS/U1,			6000),
		new /datum/data/stalker_equipment("PSO-1",					"���-1",									/obj/item/weapon/attachment/scope/PS/O1,			10000),
		new /datum/data/stalker_equipment("Rifle/Shotgun scope",	"������ ��� ��������/����������",		/obj/item/weapon/attachment/scope/rifle,			8000)
		///////////////////////////////////////////////////////////////////////////////////////////
		),
*/
	"Unbuyable" = list(
		/////////////////////////////////	��� � ��������	///////////////////////////////////////////
		new /datum/data/stalker_equipment("����� �����",					"����� �����",			/obj/item/weapon/stalker/loot/dog_tail,			2500,	1250),
		new /datum/data/stalker_equipment("������ ����",					"������ ����",			/obj/item/weapon/stalker/loot/flesh_eye,		1800,	900),
		new /datum/data/stalker_equipment("������� ���",					"������� ���",			/obj/item/weapon/stalker/loot/boar_leg,			6000,	3000),
		new /datum/data/stalker_equipment("C������ ���",					"�������� ���",			/obj/item/weapon/stalker/loot/snork_leg,		7000,	3500),
		new /datum/data/stalker_equipment("���������� �������",				"���������� �������",	/obj/item/weapon/stalker/loot/bloodsucker,		16000,	8000),
		new /datum/data/stalker_equipment("����������� �����",				"����������� �����",	/obj/item/weapon/stalker/loot/pseudo_tail,		8000,	4000),
		new /datum/data/stalker_equipment("������������ ����",				"������������ ����",	/obj/item/weapon/stalker/loot/controller_brain,	40000,	20000),
		///////////////////////////////////////////////////////////////////////////////////////////
		new /datum/data/stalker_equipment("Artefact",				"Artefact",						/obj/item/artefact,								50000,	50000,	0,	1,	0),
		///////////////////////////////////////////////////////////////////////////////////////////
		new /datum/data/stalker_equipment("50 RU",				"50 RU",							/obj/item/spacecash/c50,						50,		50,		0,	1,	0),
		new /datum/data/stalker_equipment("100 RU",				"100 RU",							/obj/item/spacecash/c100,						100,	100,	0,	1,	0),
		new /datum/data/stalker_equipment("200 RU",				"200 RU",							/obj/item/spacecash/c200,						200,	200,	0,	1,	0),
		new /datum/data/stalker_equipment("500 RU",				"500 RU",							/obj/item/spacecash/c500,						500,	500,	0,	1,	0),
		new /datum/data/stalker_equipment("1000 RU",			"1000 RU",							/obj/item/spacecash/c1000,						1000,	1000,	0,	1,	0),
		new /datum/data/stalker_equipment("2000 RU",			"2000 RU",							/obj/item/spacecash/c2000,						2000,	2000,	0,	1,	0),
		new /datum/data/stalker_equipment("5000 RU",			"5000 RU",							/obj/item/spacecash/c5000,						5000,	5000,	0,	1,	0)
		)
	)


/proc/save_economic()
	var/text = "ECONOMIC \n"
	for(var/datum/data/stalker_equipment/D in real_sidormat_items)
		text += "[D.name_en] = [D.estimated_demand] = [D.estimated_supply] \n"
	text2file(text, "data/economic.txt")

/proc/load_economic()
	if(!fexists("data/economic.txt"))
		return
	var/list/datums = file2list("data/economic.txt")
	for(var/line in datums)
		var/list/D = text2list(line, " = ")
		for(var/datum/data/stalker_equipment/SE in real_sidormat_items)
			if(SE.name_en == D[1])
				SE.estimated_demand = text2num(D[2])
//				SE.assortment_level = text2num(D[2]) * GLOB.clients
				SE.estimated_supply = text2num(D[3])
	fdel("data/economic.txt")
