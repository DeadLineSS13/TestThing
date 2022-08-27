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
	var/estimated_supply = 0	//Предполагаемое предложение
	var/estimated_demand = 0	//Предполагаемый спрос
	var/total_bought = 0		//Сколько куплено жабой
	var/total_sold = 0			//Сколько продано жабой

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
		///////////////////////////////  Оружие  /////////////////////////////////////////
	"Handguns" = list(
		///////////////////////////// **Пистолеты** /////////////////////////////////////
		new /datum/data/stalker_equipment("TT",				"ТТ",				/obj/item/weapon/gun/projectile/automatic/pistol/tt,				10000, 0, 10),
		new /datum/data/stalker_equipment("PM",				"ПМ",				/obj/item/weapon/gun/projectile/automatic/pistol/pm,				10000, 0, 10),
		new /datum/data/stalker_equipment("Fort-12",		"Форт-12",			/obj/item/weapon/gun/projectile/automatic/pistol/fort12,			10000, 0, 10),
		new /datum/data/stalker_equipment("PYa",			"ПЯ",				/obj/item/weapon/gun/projectile/automatic/pistol/yarigin,			30000, 0, 5),
		new /datum/data/stalker_equipment("Gyurza",			"Гюрза",			/obj/item/weapon/gun/projectile/automatic/pistol/gyurza,			30000, 0, 5),
		new /datum/data/stalker_equipment("Beretta",		"Беретта",			/obj/item/weapon/gun/projectile/automatic/pistol/m92,				30000, 0, 5),
		new /datum/data/stalker_equipment("Colt",			"Кольт",			/obj/item/weapon/gun/projectile/automatic/pistol/colt,				30000, 0, 5)
//		new /datum/data/stalker_equipment("FN 5-7",			"ФН 5-7",			/obj/item/weapon/gun/projectile/automatic/pistol/fn,				50000),
//		new /datum/data/stalker_equipment("Glock 17",		"Глок 17",			/obj/item/weapon/gun/projectile/automatic/pistol/glock,				50000),
//		new /datum/data/stalker_equipment("Colt .44",		"Кольт .44",		/obj/item/weapon/gun/projectile/revolver/anaconda,					50000),
//		new /datum/data/stalker_equipment("Desert Eagle",	"Пустынный Орел",	/obj/item/weapon/gun/projectile/automatic/pistol/m92,				75000),
		),

	"Small arms" = list(
		///////////////////////////// **Короткое оружие** ///////////////
		new /datum/data/stalker_equipment("Kiparis",		"Кипарис",			/obj/item/weapon/gun/projectile/automatic/kiparis,					20000, 0, 7),
		new /datum/data/stalker_equipment("Veresk",			"Вереск",			/obj/item/weapon/gun/projectile/automatic/veresk,					35000, 0, 4),
		new /datum/data/stalker_equipment("MP5",			"МП5",				/obj/item/weapon/gun/projectile/automatic/mp5,						75000, 0, 2),
		new /datum/data/stalker_equipment("Bizon",			"Бизон",			/obj/item/weapon/gun/projectile/automatic/bizon,					75000, 0, 2),
		new /datum/data/stalker_equipment("AK-74S",			"АК-74У",			/obj/item/weapon/gun/projectile/automatic/aksu74 ,					75000, 0, 2)
//		new /datum/data/stalker_equipment("P90",			"P90",				/obj/item/weapon/gun/projectile/automatic/mp5,						200000),
		),

	"Long arms" = list(
		///////////////////////////// **Длинное оружие** ////////////////
		new /datum/data/stalker_equipment("SKS",			"СКС",				/obj/item/weapon/gun/projectile/automatic/sks,						35000, 0, 4),
		new /datum/data/stalker_equipment("AK-74",			"АК-74",			/obj/item/weapon/gun/projectile/automatic/ak74,						75000, 0, 2),
		new /datum/data/stalker_equipment("AKM",			"АКМ",				/obj/item/weapon/gun/projectile/automatic/ak74/akm,					100000, 0, 1)
//		new /datum/data/stalker_equipment("Val",			"Вал",				/obj/item/weapon/gun/projectile/automatic/val,						100000),
//		new /datum/data/stalker_equipment("A-545",			"А-545",			/obj/item/weapon/gun/projectile/automatic/a545,						200000),
//		new /datum/data/stalker_equipment("M16",			"М16",				/obj/item/weapon/gun/projectile/automatic/m16,						200000),
//		new /datum/data/stalker_equipment("FN Fal",			"ФН Фал",			/obj/item/weapon/gun/projectile/automatic/fal,						300000),
		),

	"Shotguns" = list(
		/////////////////////////////// **Дробовики** /////////////////////////////////////
		new /datum/data/stalker_equipment("Sawn-off",		"Обрез горизонталки",/obj/item/weapon/gun/projectile/revolver/bm16/sawnoff,				20000, 0, 7),
		new /datum/data/stalker_equipment("Horizontal shotgun","Горизонталка",	/obj/item/weapon/gun/projectile/revolver/bm16,						20000, 0, 7),
		new /datum/data/stalker_equipment("Vertical shotgun","Вертикалка",	 	/obj/item/weapon/gun/projectile/revolver/bm16/toz34,				20000, 0, 7),
		new /datum/data/stalker_equipment("Old pump shotgun","Старый помповик",	/obj/item/weapon/gun/projectile/shotgun/chaser,						35000, 0, 4),
		new /datum/data/stalker_equipment("Saiga",			"Сайга",			/obj/item/weapon/gun/projectile/automatic/saiga,					75000, 0, 2)
//		new /datum/data/stalker_equipment("Striker",		"Страйкер",	 		/obj/item/weapon/gun/projectile/automatic/striker,					150000, 0, 1)
		),

	"Melee Weapons" = list(
		/////////////////////////////// **Другое** /////////////////////////////////////
		new /datum/data/stalker_equipment("Survival Knife",	"Нож для выживания",/obj/item/weapon/kitchen/knife/tourist,					5000, 0, 20),
		new /datum/data/stalker_equipment("Switchblade",	"Выкидной ножик"	,/obj/item/weapon/kitchen/knife/vykid,					5000, 0, 20)
		),

	"Ammo Boxes" = list(
		////////////////////////////////  Патроны  /////////////////////////////////////////
		new /datum/data/stalker_equipment("7.62x25mm Box",			"Коробка 7.62x25мм",						/obj/item/ammo_box/stalker/b762x25,						2000, 0, 40),
		new /datum/data/stalker_equipment("9x18mm Box",				"Коробка 9х18мм",							/obj/item/ammo_box/stalker/b9x18,						2000, 0, 40),
//		new /datum/data/stalker_equipment("9x18mm +P+ Box",			"Коробка 9x18мм +Р+",						/obj/item/ammo_box/stalker/b9x18P,						3000, 0, 30),
		new /datum/data/stalker_equipment("9x19mm Box",				"Коробка 9x19мм",							/obj/item/ammo_box/stalker/b9x19,						3000, 0, 30),
		new /datum/data/stalker_equipment("9x19mm AP Box",			"Коробка 9x19мм Бронебойные",				/obj/item/ammo_box/stalker/b9x19P,						6000, 0, 18),
		new /datum/data/stalker_equipment("9x21mm Box",				"Коробка 9x21мм",							/obj/item/ammo_box/stalker/b9x21,						6000, 0, 18),
		new /datum/data/stalker_equipment(".45 ACP Box",			"Коробка .45 ACP",							/obj/item/ammo_box/stalker/bacp45,						5000, 0, 20),
/*		new /datum/data/stalker_equipment(".45 ACP expansive Box",	"Коробка .45 ACP Экспансивные",				/obj/item/ammo_box/stalker/bacp45ap,					5000, 0, 20),
		new /datum/data/stalker_equipment(".44 Magnum Box",			"Коробка .44 Магнум",						/obj/item/ammo_box/stalker/bmag44,						10000, 0, 10),*/
		new /datum/data/stalker_equipment("12G Buckshot Box",		"Коробка дроби 12G",						/obj/item/ammo_box/stalker/b12x70,						5000, 0, 35),
		new /datum/data/stalker_equipment("12F Slug Box",			"Коробка пулевых патронов 12G",				/obj/item/ammo_box/stalker/b12x70P,						5000, 0, 15),
		new /datum/data/stalker_equipment("5.45x39mm Box",			"Коробка 5.45х39мм",						/obj/item/ammo_box/stalker/b545,						10000, 0, 10),
		new /datum/data/stalker_equipment("5.45x39mm AP Box",		"Коробка 5.45х39мм Бронебойные",			/obj/item/ammo_box/stalker/b545ap,						20000, 0, 5),
		new /datum/data/stalker_equipment("7.62x39mm Box",			"Коробка 7.62х39мм",						/obj/item/ammo_box/stalker/b762x39,						15000, 0, 3)
		),

	"Magazines and Clips" = list(
		new /datum/data/stalker_equipment("PM Magazine",							"Магазин к ПМ",					/obj/item/ammo_box/magazine/stalker/m9x18pm,			1000, 0, 60),
		new /datum/data/stalker_equipment("TT Magazine",							"Магазин к ТТ",					/obj/item/ammo_box/magazine/stalker/tt,					1000, 0, 60),
		new /datum/data/stalker_equipment("Fort-12 Magazine",						"Магазин к Форт-12",			/obj/item/ammo_box/magazine/stalker/m9x18fort,			1000, 0, 60),
		new /datum/data/stalker_equipment("Colt M1911 Magazine",					"Магазин к Кольту",				/obj/item/ammo_box/magazine/stalker/sc45,				1000, 0, 60),
		new /datum/data/stalker_equipment("Beretta 92 Magazine",					"Магазин к Беретте 92",			/obj/item/ammo_box/magazine/stalker/m9x19marta,			1000, 0, 60),
		new /datum/data/stalker_equipment("PYa Magazine",							"Магазин к ПЯ",					/obj/item/ammo_box/magazine/stalker/yarigin,			1000, 0, 60),
		new /datum/data/stalker_equipment("Gyurza Magazine",						"Магазин к Гюрзе",				/obj/item/ammo_box/magazine/stalker/gyurza,				1000, 0, 60),
		new /datum/data/stalker_equipment("Kiparis Magazine",						"Магазин к Кипарису",			/obj/item/ammo_box/magazine/stalker/kiparis,			2000, 0, 30),
		new /datum/data/stalker_equipment("Veresk Magazine",						"Магазин к Вереску",			/obj/item/ammo_box/magazine/stalker/veresk,				2000, 0, 30),
		new /datum/data/stalker_equipment("MP-5 Magazine",							"Магазин к МП-5",				/obj/item/ammo_box/magazine/stalker/m9x19mp5,			2000, 0, 30),
		new /datum/data/stalker_equipment("Bizon Magazine",							"Магазин к Бизону",				/obj/item/ammo_box/magazine/stalker/bizon,				3000, 0, 15),
		new /datum/data/stalker_equipment("AK Magazine",							"Магазин к АК",					/obj/item/ammo_box/magazine/stalker/m545,				3000, 0, 15),
		new /datum/data/stalker_equipment("AKM Magazine",							"Магазин к АКМ",				/obj/item/ammo_box/magazine/stalker/akm,				3000, 0, 15),
		new /datum/data/stalker_equipment("Saiga Magazine",							"Магазин к Сайге",				/obj/item/ammo_box/magazine/stalker/saiga,				2000, 0, 10),
		new /datum/data/stalker_equipment("SKS Clip",								"Обойма к СКС",					/obj/item/ammo_box/stalker/sks/cl762x39,				2000, 0, 30)
//		new /datum/data/stalker_equipment("SVD Magazine",							"Магазин к СВД",				/obj/item/ammo_box/magazine/stalker/svd,				2000, 0, 30)
		),

	"Armor vests" = list(
		///////////////////////////////  Броня  /////////////////////////////////////////
		new /datum/data/stalker_equipment("Old armor vest",				"Старый бронежилет",				/obj/item/clothing/suit/obolochka,							30000, 0, 7),
		new /datum/data/stalker_equipment("'Kazak' armor vest",			"Бронежилет 'Казак'",				/obj/item/clothing/suit/kazak,								75000, 0, 3)
//		new /datum/data/stalker_equipment("'Karatel' heavy armor vest",	"Тяжелый бронежилет 'Каратель'",	/obj/item/clothing/suit/karatel,							150000, 0, 1),
//		new /datum/data/stalker_equipment("'Hawk' armor vest",			"Бронежилет 'Ястреб'",				/obj/item/clothing/suit/hawk,								150000),
//		new /datum/data/stalker_equipment("'Heracles' heavy armor vest","Тяжелый бронежилет 'Геракл'",		/obj/item/clothing/suit/heracles,							500000),
		),

	"Coats and jackets" = list(
		///////////////////////////////  Броня  /////////////////////////////////////////
		new /datum/data/stalker_equipment("Leather jacket",				"Кожанка",							/obj/item/clothing/suit/leatherjacket,									5000, 0, 30),
		new /datum/data/stalker_equipment("Black trenchcoat",			"Черный плащ",						/obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack,				10000, 0, 20),
		new /datum/data/stalker_equipment("Brown trenchcoat",			"Коричневый плащ",					/obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack/coatbrown,	10000, 0, 20),
		new /datum/data/stalker_equipment("OZK",						"ОЗК",								/obj/item/clothing/suit/hooded/kozhanka/ozk,							30000, 0, 7)
		),

	"Masks and Helmets" = list(
		////////////////////////////	Маски, Шлемы	/////////////////////////////////////
		new /datum/data/stalker_equipment("Ukrainian beret",			"Украинский берет",				/obj/item/clothing/head/beret_ua,								2000, 0, 20),
		new /datum/data/stalker_equipment("Old gasmask",				"Старый противогаз",			/obj/item/clothing/mask/gas/stalker,							10000, 0, 15),
		new /datum/data/stalker_equipment("M40 gasmask",				"Противогаз М40",				/obj/item/clothing/mask/gas/stalker/mercenary,					30000, 0, 8),
		new /datum/data/stalker_equipment("Steel helmet",				"Каска-афганка",				/obj/item/clothing/head/steel,									10000, 0, 20),
		new /datum/data/stalker_equipment("\"Kazak\" helmet",			"Шлем \"Казак\"",				/obj/item/clothing/head/kazak,									30000, 0, 7)
//		new /datum/data/stalker_equipment("'Karatel' armored helmet",	"Бронешлем 'Каратель'",			/obj/item/clothing/head/karatel,								75000, 0, 2),
//		new /datum/data/stalker_equipment("'Hawk' helmet",				"Шлем 'Ястреб'",				/obj/item/clothing/head/hawk,									75000),
//		new /datum/data/stalker_equipment("'Heracles' armored helmet",	"Бронешлем 'Геракл'",			/obj/item/clothing/head/steel,									150000),
		),

	"Medicine" = list(
		///////////////////////////////	Медикаменты	/////////////////////////////////////////
		new /datum/data/stalker_equipment("Medicine kit",				"Медицинский набор",				/obj/item/weapon/medicine_kit,								10000, 0, 10),
		new /datum/data/stalker_equipment("Bandage",					"Бинт",								/obj/item/stack/medical/bruise_pack/bint,					2500, 0, 100),
		new /datum/data/stalker_equipment("Synthskin patch",			"Синтекожевый пластырь",			/obj/item/stack/medical/bruise_pack/synth_bint,				5000, 0, 30),
		new /datum/data/stalker_equipment("Cellular stimulator",		"Клеточный стимулятор",				/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/low,	5000, 0, 50),
		new /datum/data/stalker_equipment("Cellular stimulator MkII",	"Клеточный стимулятор MKII",		/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/medium,	20000, 0, 10),
		new /datum/data/stalker_equipment("Morphite",					"Морфит",							/obj/item/weapon/reagent_containers/hypospray/medipen/morphite,	2500, 0, 50),
		new /datum/data/stalker_equipment("Hyperstim",					"Гиперстимулятор",					/obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator,	2500, 0, 50),
		new /datum/data/stalker_equipment("Adrenaline injector",		"Адреналиновый инъектор",			/obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline,	5000, 0, 50)
		),

	"Food" = list(
		/////////////////////////////////	Еда	///////////////////////////////////////////
		new /datum/data/stalker_equipment("Canned stew",				"Тушенка",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva,				500, 0, 50),
		new /datum/data/stalker_equipment("Premium canned stew",		"Качественная тушенка",		/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/govyadina2,	1000, 0, 25),
		new /datum/data/stalker_equipment("Canned fish",				"Шпроты",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/shproti,		500, 0, 50),
		new /datum/data/stalker_equipment("Salami",						"Колбаса",					/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,				500, 0, 50),
		new /datum/data/stalker_equipment("Bread",						"Батон",					/obj/item/weapon/reagent_containers/food/snacks/stalker/baton,					500, 0, 50),
		new /datum/data/stalker_equipment("Canned soup",				"Консервированный Суп",		/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup,			1000, 0, 25),
		new /datum/data/stalker_equipment("Canned buckwheat",			"Гречневая каша",			/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/buckwheat,		1000, 0, 25),
		new /datum/data/stalker_equipment("Canned beans",				"Консервированные Бобы",	/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/bobi,			500, 0, 50),
		new /datum/data/stalker_equipment("Canned fish",				"Консервированная рыба",	/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/fish,		500, 0, 50),
		new /datum/data/stalker_equipment("Cream cheese",				"Плавленый сыр",			/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/sirok,	1000, 0, 25),
		new /datum/data/stalker_equipment("Chocolate bar",				"Плитка шоколада",			/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/chocolate,1000, 0, 25),
		new /datum/data/stalker_equipment("Biscuits",					"Галеты",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/galets,		500, 0, 50),
		new /datum/data/stalker_equipment("Cerreal",					"Каша",						/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/kasha,			500, 0, 50),
		new /datum/data/stalker_equipment("Snickers",					"Сникерс",					/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/snikers,	500, 0, 50),
		new /datum/data/stalker_equipment("Mars",						"Марс",						/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/mars,	500, 0, 50)
		),

	"Drinks" = list(
		new /datum/data/stalker_equipment("Vodka \"Kazaki\"",			"Водка \"Казаки\"",			/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/kazaki,			1000, 0, 25),
		new /datum/data/stalker_equipment("Energy drink \"NonStop\"",	"Энергетик \"NonStop\"",	/obj/item/weapon/reagent_containers/food/drinks/soda_cans/energetic,			500, 0, 50),
		new /datum/data/stalker_equipment("Beer 'Ohota Strong'",		"Пиво 'Охота Крепкая'",		/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/ohota,			1000, 0, 40),
		new /datum/data/stalker_equipment("Beer 'Obolon'",				"Пиво 'Оболонь'",			/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/obolon,			1000, 0, 40),
		new /datum/data/stalker_equipment("Beer 'Stepan Razin'",		"Пиво 'Степан Разин'",		/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/razin,			1000, 0, 40),
		new /datum/data/stalker_equipment("Beer 'Zhatetsky Gus'",		"Пиво 'Жатецкий Гусь'",		/obj/item/weapon/reagent_containers/food/drinks/soda_cans/pivo/gus,				1000, 0, 40)
		),

//	"Bacpacks" = list(
//		new /datum/data/stalker_equipment("Cheap satchel",					"Дешевая сумка",		/obj/item/weapon/storage/backpack/satchel/stalker/civilian,					2500),
//		new /datum/data/stalker_equipment("Cheap backpack",					"Дешевый рюкзак",			/obj/item/weapon/storage/backpack/stalker/civilian,							2500),
//		new /datum/data/stalker_equipment("Tourist backpack",				"Рюкзак туриста",			/obj/item/weapon/storage/backpack/stalker/tourist,							6000),
//		new /datum/data/stalker_equipment("Professional backpack",			"Рюкзак профессионала",		/obj/item/weapon/storage/backpack/stalker/professional,						11000)
//		),

	"Misc" = list(
		/////////////////////////////////	Другое	/////////////////////////////////////////////
//		new /datum/data/stalker_equipment("Repair-kit for suits and helmets",	"Рем. комплект для бронекостюмов и шлемов",		/obj/item/device/repair_kit/clothing,						10000),
//		new /datum/data/stalker_equipment("Repair-kit for guns",				"Рем. комплект для огнестрельного оружия",	/obj/item/device/repair_kit/gun,							4000),
//		new /datum/data/stalker_equipment("Big artefact belt",					"Большой пояс для артефактов",				/obj/item/weapon/storage/belt/stalker/artefact_belt,		60000),
//		new /datum/data/stalker_equipment("Small artefact belt",				"Маленький пояс для артефактов",			/obj/item/weapon/storage/belt/stalker/artefact_belt/small,	25000),
//		new /datum/data/stalker_equipment("Geiger counter",						"Дозиметр",												/obj/item/device/geiger_counter,							3000),
		new /datum/data/stalker_equipment("Cauldron",							"Котелок",												/obj/item/weapon/reagent_containers/food/cauldron,			2000, 0, 20),
		new /datum/data/stalker_equipment("Flashlight",							"Фонарик",												/obj/item/device/flashlight/seclite,						1000, 0, 40),
		new /datum/data/stalker_equipment("Matches",							"Спички",												/obj/item/weapon/storage/box/matches,						1000, 0, 100),
		new /datum/data/stalker_equipment("Simple lighter",						"Пластиковая зажигалка",								/obj/item/weapon/lighter/greyscale,							5000, 0, 60),
		new /datum/data/stalker_equipment("Zippo lighter",						"Зажигалка \"Зиппо\"",									/obj/item/weapon/lighter,									5000, 0, 20),
		new /datum/data/stalker_equipment("Cigarettes \"Maxim\"",				"Сигареты \"Maxim\"",									/obj/item/weapon/storage/fancy/cigarettes/cigpack/maxim,	2500, 0, 100),
		new /datum/data/stalker_equipment("Cigars",								"Сигары",												/obj/item/weapon/storage/fancy/cigarettes/cigars,			10000, 0, 5)
		),

	"Other equipment" = list(
		new /datum/data/stalker_equipment("Balaclava",							"Балаклава",											/obj/item/clothing/mask/balaclava,							1000, 0, 100),
		new /datum/data/stalker_equipment("Rubber boots",						"Резиновые сапоги",										/obj/item/clothing/shoes/jackboots/ozk,						2500, 0, 10),
		new /datum/data/stalker_equipment("Rubber gloves",						"Резиновые перчатки",									/obj/item/clothing/gloves/ozk,								2500, 0, 10)
		),

/*
	"Attachments" = list(
		/////////////////////////////////	Аттачменты	///////////////////////////////////////////
		new /datum/data/stalker_equipment("Universl suppressor",	"Универсальный глушитель",					/obj/item/weapon/attachment/suppressor,				2000),
		new /datum/data/stalker_equipment("SUSAT",					"СУСАТ",									/obj/item/weapon/attachment/scope/SUSAT,			8000),
		new /datum/data/stalker_equipment("PSU-1",					"ПСУ-1",									/obj/item/weapon/attachment/scope/PS/U1,			6000),
		new /datum/data/stalker_equipment("PSO-1",					"ПСО-1",									/obj/item/weapon/attachment/scope/PS/O1,			10000),
		new /datum/data/stalker_equipment("Rifle/Shotgun scope",	"Прицел для винтовок/дробовиков",		/obj/item/weapon/attachment/scope/rifle,			8000)
		///////////////////////////////////////////////////////////////////////////////////////////
		),
*/
	"Unbuyable" = list(
		/////////////////////////////////	Лут с мутантов	///////////////////////////////////////////
		new /datum/data/stalker_equipment("Песий хвост",					"Песий хвост",			/obj/item/weapon/stalker/loot/dog_tail,			2500,	1250),
		new /datum/data/stalker_equipment("Плотий глаз",					"Плотий глаз",			/obj/item/weapon/stalker/loot/flesh_eye,		1800,	900),
		new /datum/data/stalker_equipment("Кабаний ног",					"Кабаний ног",			/obj/item/weapon/stalker/loot/boar_leg,			6000,	3000),
		new /datum/data/stalker_equipment("Cноркий рук",					"Снорукий рук",			/obj/item/weapon/stalker/loot/snork_leg,		7000,	3500),
		new /datum/data/stalker_equipment("Кровососий щупалец",				"Кровососий щупалец",	/obj/item/weapon/stalker/loot/bloodsucker,		16000,	8000),
		new /datum/data/stalker_equipment("Псевдопесий хвост",				"Псевдопесий хвост",	/obj/item/weapon/stalker/loot/pseudo_tail,		8000,	4000),
		new /datum/data/stalker_equipment("Контроллерий мозг",				"Контроллерий мозг",	/obj/item/weapon/stalker/loot/controller_brain,	40000,	20000),
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
