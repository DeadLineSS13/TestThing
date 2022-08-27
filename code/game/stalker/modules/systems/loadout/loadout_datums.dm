/datum/loadout_equip
	var/name = "Test"
	var/name_ru = "Тест"
	var/item_path
	var/ammo_type
	var/cost = 0
	var/level_needed = 100
	var/unlimited = 1
	var/amount = 1

/datum/loadout_equip/weapon/tourist_knife
	name = "Tourist knife"
	name_ru = "Нож туриста"
	item_path = /obj/item/weapon/kitchen/knife/tourist
	cost = 1
	level_needed = 0

/datum/loadout_equip/weapon/vykid
	name = "Switchblade"
	name_ru = "Выкидной нож"
	item_path = /obj/item/weapon/kitchen/knife/vykid
	cost = 1
	level_needed = 0

/datum/loadout_equip/weapon/axe
	name = "Wood axe"
	name_ru = "Лесорубный топор"
	item_path = /obj/item/weapon/woodaxe
	cost = 2
	level_needed = 100



/datum/loadout_equip/weapon/pm
	name = "PM pistol"
	name_ru = "Пистолет Макарова"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/pm
	cost = 2
	level_needed = 0

/datum/loadout_equip/weapon/tt
	name = "TT pistol"
	name_ru = "Пистолет ТТ"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/tt
	cost = 2
	level_needed = 0

/datum/loadout_equip/weapon/fort
	name = "Fort-12 pistol"
	name_ru = "Пистолет Форт-12"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/fort12
	cost = 2
	level_needed = 0

/datum/loadout_equip/weapon/yarigin
	name = "Yarigin pistol"
	name_ru = "Пистолет Ярыгина"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/yarigin
	cost = 4
	level_needed = 5

/datum/loadout_equip/weapon/gyurza
	name = "Gyurza pistol"
	name_ru = "Пистолет Гюрза"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/gyurza
	cost = 4
	level_needed = 5

/datum/loadout_equip/weapon/beretta
	name = "Beretta M9 pistol"
	name_ru = "Пистолет Беретта М9"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/m92
	cost = 4
	level_needed = 5

/datum/loadout_equip/weapon/colt
	name = "Colt M1911 pistol"
	name_ru = "Пистолет Кольт М1911"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/colt
	cost = 4
	level_needed = 5

/datum/loadout_equip/weapon/fn
	name = "FN 5-7 pistol"
	name_ru = "Пистолет ФН 5-7"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/fn
	cost = 6
	level_needed = 10

/datum/loadout_equip/weapon/glock
	name = "Glock 17 pistol"
	name_ru = "Пистолет Глок 17"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/glock
	cost = 6
	level_needed = 10

/datum/loadout_equip/weapon/anaconda
	name = ".44 Colt Anaconda revolver"
	name_ru = "Револьвер Кольт Анаконда .44"
	item_path = /obj/item/weapon/gun/projectile/revolver/anaconda
	cost = 6
	level_needed = 10

/datum/loadout_equip/weapon/desert
	name = ".44 Desert Eagle pistol"
	name_ru = "Пистолет Desert Eagle .44"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/desert
	cost = 9
	level_needed = 10

/datum/loadout_equip/weapon/rsh
	name = "12.7mm RSh revolver"
	name_ru = "Револьвер РШ 12.7мм"
	item_path = /obj/item/weapon/gun/projectile/revolver/rsh
	cost = 12
	level_needed = 100

/datum/loadout_equip/weapon/vag
	name = "VAG-37 caseless pistol"
	name_ru = "Безгильзовый пистолет ВАГ-37"
	item_path = /obj/item/weapon/gun/projectile/automatic/pistol/vag
	cost = 12
	level_needed = 100




/datum/loadout_equip/weapon/kiparis
	name = "Kiparis SMG"
	name_ru = "Пистолет-пулемет Кипарис"
	item_path = /obj/item/weapon/gun/projectile/automatic/kiparis
	cost = 4
	level_needed = 0

/datum/loadout_equip/weapon/veresk
	name = "Veresk SMG"
	name_ru = "Пистолет-пулемет Вереск"
	item_path = /obj/item/weapon/gun/projectile/automatic/veresk
	cost = 7
	level_needed = 0

/datum/loadout_equip/weapon/mp5
	name = "MP5 SMG"
	name_ru = "Пистолет-пулемет МП5"
	item_path = /obj/item/weapon/gun/projectile/automatic/mp5
	cost = 12
	level_needed = 5

/datum/loadout_equip/weapon/bizon
	name = "Bizon SMG"
	name_ru = "Пистолет-пулемет Бизон"
	item_path = /obj/item/weapon/gun/projectile/automatic/bizon
	cost = 12
	level_needed = 5

/datum/loadout_equip/weapon/aksu74
	name = "AKS-74U short-barrel assault rifle"
	name_ru = "Короткоствольный автомат АКС-74У"
	item_path = /obj/item/weapon/gun/projectile/automatic/aksu74
	cost = 12
	level_needed = 5

/datum/loadout_equip/weapon/p90
	name = "P90 SMG"
	name_ru = "Пистолет-пулемет П90"
	item_path = /obj/item/weapon/gun/projectile/automatic/p90
	cost = 16
	level_needed = 10

/datum/loadout_equip/weapon/ppsh
	name = "PPSh SMG"
	name_ru = "Пистолет-пулемет ППШ"
	item_path = /obj/item/weapon/gun/projectile/automatic/ppsh
	cost = 7
	level_needed = 100



/datum/loadout_equip/weapon/sawnoff
	name = "Sawn-off shotgun"
	name_ru = "Обрез дробовика"
	item_path = /obj/item/weapon/gun/projectile/revolver/bm16/sawnoff
	ammo_type = /obj/item/ammo_box/stalker/b12x70
	cost = 4
	level_needed = 0

/datum/loadout_equip/weapon/bm16
	name = "Horizontal hunting shotgun"
	name_ru = "Горизонталка-дробовик"
	item_path = /obj/item/weapon/gun/projectile/revolver/bm16
	ammo_type = /obj/item/ammo_box/stalker/b12x70
	cost = 4
	level_needed = 0

/datum/loadout_equip/weapon/toz34
	name = "Vertical hunting shotgun"
	name_ru = "Вертикалка-дробовик"
	item_path = /obj/item/weapon/gun/projectile/revolver/bm16/toz34
	ammo_type = /obj/item/ammo_box/stalker/b12x70
	cost = 4
	level_needed = 0

/datum/loadout_equip/weapon/pump
	name = "Pump-action shotgun"
	name_ru = "Помповый дробовик"
	item_path = /obj/item/weapon/gun/projectile/shotgun/chaser
	ammo_type = /obj/item/ammo_box/stalker/b12x70
	cost = 7
	level_needed = 0

/datum/loadout_equip/weapon/saiga
	name = "Saiga semiauto shotgun"
	name_ru = "Полуавтоматический дробовик 'Сайга'"
	item_path = /obj/item/weapon/gun/projectile/automatic/saiga
	ammo_type = /obj/item/ammo_box/stalker/b12x70
	cost = 12
	level_needed = 5

/datum/loadout_equip/weapon/striker
	name = "Striker drum-fed shotgun"
	name_ru = "Барабанный дробовик 'Страйкер'"
	item_path = /obj/item/weapon/gun/projectile/automatic/striker
	ammo_type = /obj/item/ammo_box/stalker/b12x70
	cost = 12
	level_needed = 5



/datum/loadout_equip/weapon/sks
	name = "SKS rifle"
	name_ru = "Карабин СКС"
	item_path = /obj/item/weapon/gun/projectile/automatic/sks
	ammo_type =	/obj/item/ammo_box/stalker/sks/cl762x39
	cost = 7
	level_needed = 0

/datum/loadout_equip/weapon/ak74
	name = "AK-74 assault rifle"
	name_ru = "Автомат АК-74"
	item_path = /obj/item/weapon/gun/projectile/automatic/ak74
	cost = 12
	level_needed = 5

/datum/loadout_equip/weapon/akm
	name = "AKM assault rifle"
	name_ru = "Автомат АКМ"
	item_path = /obj/item/weapon/gun/projectile/automatic/ak74/akm
	cost = 16
	level_needed = 5

/datum/loadout_equip/weapon/val
	name = "Val special automatic rifle"
	name_ru = "Специальный автомат 'Вал'"
	item_path = /obj/item/weapon/gun/projectile/automatic/val
	cost = 12
	level_needed = 10

/datum/loadout_equip/weapon/a545
	name = "A-545 assault rifle"
	name_ru = "Автомат А-545"
	item_path = /obj/item/weapon/gun/projectile/automatic/a545
	cost = 16
	level_needed = 10

/datum/loadout_equip/weapon/m16
	name = "M16A2 assault rifle"
	name_ru = "Автомат M16A2"
	item_path = /obj/item/weapon/gun/projectile/automatic/m16
	cost = 16
	level_needed = 10

/datum/loadout_equip/weapon/svd
	name = "SVD rifle"
	name_ru = "Винтовка СВД"
	item_path = /obj/item/weapon/gun/projectile/automatic/svd
	cost = 20
	level_needed = 10

/datum/loadout_equip/weapon/fal
	name = "FN FAL automatic rifle"
	name_ru = "Автоматическая винтовка ФН ФАЛ"
	item_path = /obj/item/weapon/gun/projectile/automatic/fal
	cost = 20
	level_needed = 10

/datum/loadout_equip/weapon/fal
	name = "ASh assault rifle"
	name_ru = "Штурмовая винтовка АШ"
	item_path = /obj/item/weapon/gun/projectile/automatic/ash
	cost = 20
	level_needed = 10

/datum/loadout_equip/weapon/pkm
	name = "PKM light machine gun"
	name_ru = "Пулемет ПКМ"
	item_path = /obj/item/weapon/gun/projectile/automatic/l6_saw/pkm
	cost = 20
	level_needed = 10

/datum/loadout_equip/weapon/vintorez
	name = "Vintorez special rifle"
	name_ru = "Специальная винтовка 'Винторез'"
	item_path = /obj/item/weapon/gun/projectile/automatic/vintorez
	cost = 16
	level_needed = 10

/datum/loadout_equip/weapon/groza
	name = "Groza special assault rifle"
	name_ru = "Специальный штурмовой комплекс 'Гроза'"
	item_path = /obj/item/weapon/gun/projectile/automatic/groza
	cost = 16
	level_needed = 10

/datum/loadout_equip/weapon/fnf2000
	name = "FN-F2000 special weapon complex"
	name_ru = "Специальный штурмовой комплекс 'ФН-Ф2000"
	item_path = /obj/item/weapon/gun/projectile/automatic/fnf2000
	cost = 20
	level_needed = 100


//////////////////////////////////////////////////////////////
/datum/loadout_equip/gear/base_kit
	name = "Basic Kit"
	name_ru = "Базовый набор"
	item_path = /obj/item/base_kit
	cost = 1
	level_needed = 0

/datum/loadout_equip/gear/leatherjacket
	name = "Leather jacket"
	name_ru = "Кожаная куртка"
	item_path = /obj/item/clothing/suit/leatherjacket
	cost = 1
	level_needed = 0

/datum/loadout_equip/gear/coatblack
	name = "Black leather coat"
	name_ru = "Черный кожаный плащ"
	item_path = /obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack
	cost = 2
	level_needed = 0

/datum/loadout_equip/gear/coatbrown
	name = "Brown leather coat"
	name_ru = "Коричневый кожаный плащ"
	item_path = /obj/item/clothing/suit/hooded/kozhanka/banditka/coatblack/coatbrown
	cost = 2
	level_needed = 0

/*
/datum/loadout_equip/gear/ozk
	name = "OZK"
	name_ru = "ОЗК"
	item_path = /obj/item/clothing/suit/hooded/kozhanka/ozk
	cost = 6
	level_needed = 0
*/
/datum/loadout_equip/gear/sovietmask
	name = "Old gasmask"
	name_ru = "Старый противогаз"
	item_path = /obj/item/clothing/mask/gas/stalker
	cost = 2
	level_needed = 0

/datum/loadout_equip/gear/oldarmor
	name = "Old armor vest"
	name_ru = "Старый бронежилет"
	item_path = /obj/item/clothing/suit/obolochka
	cost = 6
	level_needed = 0

/datum/loadout_equip/gear/oldhelmet
	name = "Old helmet"
	name_ru = "Старая каска"
	item_path = /obj/item/clothing/head/steel
	cost = 2
	level_needed = 0

/datum/loadout_equip/gear/m40mask
	name = "Western gasmask"
	name_ru = "Западный противогаз"
	item_path = /obj/item/clothing/mask/gas/stalker/mercenary
	cost = 4
	level_needed = 5

/datum/loadout_equip/gear/kazakarmor
	name = "'Kazak' armor vest"
	name_ru = "Бронежилет 'Казак'"
	item_path = /obj/item/clothing/suit/kazak
	cost = 12
	level_needed = 5

/datum/loadout_equip/gear/kazakhelmet
	name = "'Kazak' ballistic helmet"
	name_ru = "Баллистический шлем 'Казак'"
	item_path = /obj/item/clothing/head/kazak
	cost = 4
	level_needed = 5

/datum/loadout_equip/gear/hawkarmor
	name = "'Hawk' armor vest"
	name_ru = "Бронежилет 'Ястреб'"
	item_path = /obj/item/clothing/suit/hawk
	cost = 16
	level_needed = 10

/datum/loadout_equip/gear/hawkhelmet
	name = "'Hawk' assault helmet"
	name_ru = "Штурмовой шлем 'Ястреб'"
	item_path = /obj/item/clothing/head/hawk
	cost = 6
	level_needed = 10

/datum/loadout_equip/gear/karatelarmor
	name = "'Karatel' heavy armor vest"
	name_ru = "Тяжелый бронежилет 'Каратель'"
	item_path = /obj/item/clothing/suit/karatel
	cost = 20
	level_needed = 10

/datum/loadout_equip/gear/karatelhelmet
	name = "'Karatel' heavy helmet"
	name_ru = "Тяжелый шлем 'Каратель'"
	item_path = /obj/item/clothing/head/karatel
	cost = 8
	level_needed = 10

/datum/loadout_equip/gear/heraclesarmor
	name = "'Heracles' heavy armor vest"
	name_ru = "Тяжелый бронежилет 'Геракл'"
	item_path = /obj/item/clothing/suit/heracles
	cost = 20
	level_needed = 100

/datum/loadout_equip/gear/heracleshelmet
	name = "'Heracles' heavy helmet"
	name_ru = "Тяжелый шлем 'Геракл'"
	item_path = /obj/item/clothing/head/heracles
	cost = 8
	level_needed = 100

/datum/loadout_equip/gear/coatgar
	name = "Ballistic coat"
	name_ru = "Баллистический плащ"
	item_path = /obj/item/clothing/suit/coatgar
	cost = 20
	level_needed = 100

/datum/loadout_equip/gear/mech
	name = "Механизированный скафандр"
	name_ru = "Механизированный скафандр"
	item_path = /obj/item/clothing/suit/hooded/sealed/mechanised
	cost = 40
	level_needed = 100

/datum/loadout_equip/gear/beret
	name = "Ukrainian beret"
	name_ru = "Украинский берет"
	item_path = /obj/item/clothing/head/beret_ua
	cost = 0
	level_needed = 100

/datum/loadout_equip/gear/bandana
	name = "Ukrainian bandana"
	name_ru = "Украинская бандана"
	item_path = /obj/item/clothing/head/ukrop
	cost = 0
	level_needed = 100

/datum/loadout_equip/gear/welder
	name = "Welding headgear"
	name_ru = "Головной убор сварщика"
	item_path = /obj/item/clothing/head/welder
	cost = 1
	level_needed = 100

/datum/loadout_equip/gear/clownartifact
	name = "Weird mask"
	name_ru = "Стремная маска"
	item_path = /obj/item/clothing/mask/gas/clownartifact
	cost = 1
	level_needed = 100

//////////////////////////////////////////////////////////////

/datum/loadout_equip/ammo/b9x18
	name = "Box of 9х18мм PM \[x3\]"
	name_ru = "Коробка, 9х18мм ПМ\[x3\]"
	item_path = /obj/item/ammo_box/stalker/b9x18
	cost = 1
	level_needed = 0
	amount = 3

/datum/loadout_equip/ammo/b762x25
	name = "Box of 7.62x25мм TT \[x3\]"
	name_ru = "Коробка, 7.62х25мм TT \[x3\]"
	item_path = /obj/item/ammo_box/stalker/b762x25
	cost = 1
	level_needed = 0
	amount = 3

/datum/loadout_equip/ammo/b9x18P
	name = "Box of 9х18мм PM, +P+ \[x2\]"
	name_ru = "Коробка, 9х18мм ПМ, +P+ \[x2\]"
	item_path = /obj/item/ammo_box/stalker/b9x18P
	cost = 1
	level_needed = 3
	amount = 2

/datum/loadout_equip/ammo/b9x19
	name = "Box of 9x19мм Parabellum \[x2\]"
	name_ru = "Коробка, 9х19мм Парабеллум \[x2\]"
	item_path = /obj/item/ammo_box/stalker/b9x19
	cost = 1
	level_needed = 0
	amount = 2

/datum/loadout_equip/ammo/b9x19P
	name = "Box of 9x19мм Parabellum, Armor Piercing"
	name_ru = "Коробка, 9х19мм Парабеллум Бронебойные"
	item_path = /obj/item/ammo_box/stalker/b9x19P
	cost = 1
	level_needed = 3

/datum/loadout_equip/ammo/b9x21
	name = "Box of 9x21мм Gyurza \[x2\]"
	name_ru = "Коробка, 9х21мм Гюрза \[x2\]"
	item_path = /obj/item/ammo_box/stalker/b9x21
	cost = 1
	level_needed = 0
	amount = 2

/datum/loadout_equip/ammo/b57x28
	name = "Box of 5.7x28мм FN \[x2\]"
	name_ru = "Коробка, 5.7x28мм ФН \[x2\]"
	item_path = /obj/item/ammo_box/stalker/b57x28
	cost = 1
	level_needed = 0
	amount = 2

/datum/loadout_equip/ammo/bacp45
	name = "Box of .45 ACP"
	name_ru = "Коробка, .45 ACP"
	item_path = /obj/item/ammo_box/stalker/bacp45
	cost = 1
	level_needed = 0

/datum/loadout_equip/ammo/bacp45ap
	name = "Box of .45 ACP, Hollow Point"
	name_ru = "Коробка, .45 ACP Экспансивные"
	item_path = /obj/item/ammo_box/stalker/bacp45ap
	cost = 1
	level_needed = 3

/datum/loadout_equip/ammo/bmag44
	name = "Box of .44 Magnum"
	name_ru = "Коробка, .44 Magnum"
	item_path = /obj/item/ammo_box/stalker/bmag44
	cost = 2
	level_needed = 3

/datum/loadout_equip/ammo/b12x70
	name = "Box of 12g buckshot"
	name_ru = "Коробка, 12g дробь"
	item_path = /obj/item/ammo_box/stalker/b12x70
	cost = 1
	level_needed = 0

/datum/loadout_equip/ammo/b12x70P
	name = "Box of 12g slugs"
	name_ru = "Коробка, 12g пулевые"
	item_path = /obj/item/ammo_box/stalker/b12x70P
	cost = 1
	level_needed = 0

/datum/loadout_equip/ammo/b545
	name = "Box of 5.45x39mm"
	name_ru = "Коробка, 5.45x39mm"
	item_path = /obj/item/ammo_box/stalker/b545
	cost = 2
	level_needed = 0

/datum/loadout_equip/ammo/b545ap
	name = "Box of 5.45x39mm, Armor Piercing"
	name_ru = "Коробка, 5.45x39mm Бронебойные"
	item_path = /obj/item/ammo_box/stalker/b545ap
	cost = 4
	level_needed = 5

/datum/loadout_equip/ammo/b556
	name = "Box of 5.56x45mm"
	name_ru = "Коробка, 5.56x45mm"
	item_path = /obj/item/ammo_box/stalker/b55645
	cost = 2
	level_needed = 0

/datum/loadout_equip/ammo/b556ap
	name = "Box of 5.56x45mm, Armor Piercing"
	name_ru = "Коробка, 5.56x45mm Бронебойные"
	item_path = /obj/item/ammo_box/stalker/b55645ap
	cost = 4
	level_needed = 5

/datum/loadout_equip/ammo/b762x39
	name = "Box of 7.62x39mm"
	name_ru = "Коробка, 7.62x39mm"
	item_path = /obj/item/ammo_box/stalker/b762x39
	cost = 3
	level_needed = 0

/datum/loadout_equip/ammo/b762x51
	name = "Box of 7.62x51mm NATO"
	name_ru = "Коробка, 7.62x51mm NATO"
	item_path = /obj/item/ammo_box/stalker/b762x51
	cost = 2
	level_needed = 0

//////////////////////////////////////////////////////////////

/datum/loadout_equip/meds/bint
	name = "Bandage \[x2\]"
	name_ru = "Бинт \[x2\]"
	item_path = /obj/item/stack/medical/bruise_pack/bint
	cost = 1
	level_needed = 0
	amount = 2

/datum/loadout_equip/meds/synthskin
	name = "Synthskin patch"
	name_ru = "Синтетический пластырь"
	item_path = /obj/item/stack/medical/bruise_pack/synth_bint
	cost = 1
	level_needed = 0

/datum/loadout_equip/meds/morphite
	name = "Morphite injector \[x2\]"
	name_ru = "Инъектор морфита \[x2\]"
	item_path = /obj/item/weapon/reagent_containers/hypospray/medipen/morphite
	cost = 1
	level_needed = 0
	amount = 2

/datum/loadout_equip/meds/stim
	name = "Hyperstim injector \[x2\]"
	name_ru = "Инъектор гиперстимулятора \[x2\]"
	item_path = /obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator
	cost = 1
	level_needed = 0
	amount = 2

/datum/loadout_equip/meds/adrenaline
	name = "Adrenaline injector"
	name_ru = "Инъектор адреналина"
	item_path = /obj/item/weapon/reagent_containers/hypospray/medipen/adrenaline
	cost = 1
	level_needed = 0

/datum/loadout_equip/meds/heallow
	name = "Cellular stimulator injector"
	name_ru = "Инъектор клеточного стимулятора"
	item_path = /obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/low
	cost = 1
	level_needed = 0

/datum/loadout_equip/meds/healmedium
	name = "Cellular stimulator MkII injector"
	name_ru = "Инъектор клеточного стимулятора MkII"
	item_path = /obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/medium
	cost = 4
	level_needed = 0

/datum/loadout_equip/meds/medikit
	name = "Medicine kit"
	name_ru = "Медицинский набор"
	item_path = /obj/item/weapon/medicine_kit
	cost = 2
	level_needed = 0

//////////////////////////////////////////////////////////////

/datum/loadout_equip/donate
	cost = 0
	level_needed = 0
	unlimited = 0

/datum/loadout_equip/donate/atelerd
	name = "Atelerd"
	name_ru = "Ателерд"
	item_path = /obj/item/clothing/suit/hooded/kozhanka/strazh/atelerd

/datum/loadout_equip/donate/olympic
	name = "Olympic jacket 'Feyerverk'"
	name_ru = "Олимпийка 'Фейерверк'"
	item_path = /obj/item/clothing/suit/olympic

/datum/loadout_equip/donate/olympic/purga
	name = "Olympic jacket 'Purga'"
	name_ru = "Олимпийка 'Пурга'"
	item_path = /obj/item/clothing/suit/olympic/purga

/datum/loadout_equip/donate/olympic/veter
	name = "Olympic jacket 'Veter'"
	name_ru = "Олимпийка 'Ветер'"
	item_path = /obj/item/clothing/suit/olympic/veter

/datum/loadout_equip/donate/fez
	name = "Fez"
	name_ru = "Феска"
	item_path = /obj/item/clothing/head/fez

/*
/datum/loadout_equip/donate/veteran
	name = "Old soviet hat"
	name_ru = "Старая советская фуражка"
	item_path = /obj/item/clothing/head/veteran

/datum/loadout_equip/donate/veteranuniform
	name = "Old soviet uniform"
	name_ru = "Старая советская форма"
	item_path = /obj/item/clothing/under/color/switer/veteran
*/

/datum/loadout_equip/donate/samoderjes
	name = "Old officer hat"
	name_ru = "Старая офицерская фуражка"
	item_path = /obj/item/clothing/head/samoderjes

/datum/loadout_equip/donate/samoderjesuniform
	name = "Old officer uniform"
	name_ru = "Старая офицерская форма"
	item_path = /obj/item/clothing/under/color/switer/samoderjes

/datum/loadout_equip/donate/fashist
	name = "Old SS hat"
	name_ru = "Старая фуражка СС"
	item_path = /obj/item/clothing/head/fashist

/datum/loadout_equip/donate/sabre
	name = "Sabre"
	name_ru = "Сабля"
	item_path = /obj/item/weapon/sabre

/datum/loadout_equip/donate/sheath
	name = "Sabre sheath"
	name_ru = "Ножны сабли"
	item_path = /obj/item/weapon/sheath

/datum/loadout_equip/donate/sabrekazak
	name = "Sabre"
	name_ru = "Сабля"
	item_path = /obj/item/weapon/sabrekazak

/datum/loadout_equip/donate/sheathkazak
	name = "Sabre sheath"
	name_ru = "Ножны сабли"
	item_path = /obj/item/weapon/sheathkazak

/datum/loadout_equip/donate/frostmorn
	name = "Heavy knife"
	name_ru = "Тяжелый нож"
	item_path = /obj/item/weapon/kitchen/knife/frostmorn

/datum/loadout_equip/donate/eyepatch
	name = "Eyepatch"
	name_ru = "Глазная повязка"
	item_path = /obj/item/clothing/glasses/eyepatch

/datum/loadout_equip/donate/sunglasses
	name = "Sunglasses"
	name_ru = "Солнцезащитные очки"
	item_path = /obj/item/clothing/glasses/sunglasses

/datum/loadout_equip/donate/guitar
	name = "Guitar"
	name_ru = "Гитара"
	item_path = /obj/item/device/instrument/guitar