/obj/item/weapon/gun/projectile/revolver
	modifications = list("barrel_shotgun" = 0, "frame_shotgun" = 0, "grip_shotgun" = 0)

/obj/item/weapon/gun/projectile/revolver/bm16  // Горизонталка
	name_ru = "охотничье ружье-горизонталка"
	name = "hunting shotgun"
	desc = "Just good enough to do it's job."
	desc_ru = "В самый раз для охоты."
	icon_state = "bm16"
	icon_ground = "bm16_ground"
	item_state = "bm16"
	w_class = 6
	force = 15
	flags = CONDUCT | TWOHANDED
	slot_flags = SLOT_BACK|SLOT_BACK2
	mag_type = /obj/item/ammo_box/magazine/internal/shot/stalker/bm16
	gun_type = "longarm"
	str_need = 10
	accuracy = 3
	recoil = 1
	sawn_desc = "Значительно компактней и легче обычной двустволки."
	randomspread = 0
	spread = 2
	damagelose = 0.3
	distro = 6
	can_scope = 1
	weapon_weight = WEAPON_MEDIUM
	weight = 3.6
	fire_sound = 'sound/stalker/weapons/bm16_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/obrez_load.ogg'
	opensound = 'sound/stalker/weapons/unload/obrez_open.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'

/obj/item/weapon/gun/projectile/revolver/bm16/attackby(obj/item/A, mob/user, params)
	..()
	if(!user.is_holding(src))
		return

	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		//playsound(user, loadsound, 50, 1)
		chamber_round()
//	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/gun/energy/plasmacutter))
//		sawoff(user)


/obj/item/weapon/gun/projectile/revolver/bm16/toz34  //  Вертикалка
	name_ru = "охотничье ружье-вертикалка"
	name = "vertical hunting shotgun"
	desc = ""
	icon_state = "toz34"
	item_state = "bm16"

/obj/item/weapon/gun/projectile/shotgun
	modifications = list("barrel_shotgun" = 0, "frame_shotgun" = 0, "grip_shotgun" = 0)

/obj/item/weapon/gun/projectile/shotgun/ithaca  //  Ithaca M37
	name = "Ithaca M37"
	desc_ru = " Pump-action shotgun made in large numbers for the civilian, military, and police markets. It utilizes a novel combination ejection/loading port on the bottom of the gun which leaves the sides closed to the elements. Since shotshells load and eject from the bottom, operation of the gun is equally convenient for both right and left hand shooters. This makes the gun popular with left-handed shooters. The model 37 is considered one of the most durable and reliable shotguns ever produced."
	desc = "Магазинное ружьё (дробовик), разработанное Джоном М. Браунингом в 1913 году и запатентованное в 1915 году. Основными достоинствами ружья всегда считалась небольшая масса и возможность легкого использования как с правой, так и с левой руки — ведь стреляные гильзы отбрасываются вниз."
	icon_state = "ithacam37"
	item_state = "ithacam37"
	slot_flags = SLOT_BACK | SLOT_BACK2
	mag_type = /obj/item/ammo_box/magazine/internal/shot/stalker/ithaca
	recoil = 1
	w_class = 4
	randomspread = 0
	spread = 12
	force = 15
	damagelose = 0.3
	distro = 25
	can_scope = 0
	weapon_weight = WEAPON_MEDIUM
	weight = 3.8
	//fire_sound = 'sound/stalker/weapons/winchester1300_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/chaser_load.ogg'
	pumpsound = 'sound/stalker/weapons/pump/ithacam37_pump.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'

/obj/item/weapon/gun/projectile/shotgun/chaser  //  Winchester 1300
	name_ru = "помповый дробовик"
	name = "pump shotgun"
	desc_ru = "Взвести это тяжелое, внушительное ружье труднее, чем учат Голливудские фильмы."
	icon_state = "pumpshotgun"
	icon_ground = "pumpshotgun_ground"
	item_state = "pumpshotgun"
	slot_flags = SLOT_BACK|SLOT_BACK2
	mag_type = /obj/item/ammo_box/magazine/internal/shot/stalker/pumpshotgun
	gun_type = "longarm"
	str_need = 10
	accuracy = 3
	recoil = 0.8
	w_class = 5
	randomspread = 0
	spread = 3
	force = 10
	damagelose = 0.3
	distro = 8
	weapon_weight = WEAPON_MEDIUM
	weight = 3.4
	fire_sound = 'sound/stalker/weapons/winchester1300_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/chaser_load.ogg'
	pumpsound = 'sound/stalker/weapons/pump/chaser_pump.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'

/obj/item/weapon/gun/projectile/revolver/bm16/sawnoff
	name_ru = "обрез ружья"
	name = "sawed-off shotgun"
	desc_ru = "Не очень удобно. Стрелять с одной руки противопоказано - отсутствие приклада значительно ухудшает контроль над оружием."
	icon_state = "bm16-sawn"
	weapon_weight = WEAPON_LIGHT
	icon_ground = "sawnoff_ground"
	item_state = "sawnoff"
	slot_flags = SLOT_BELT
	flags = CONDUCT | TWOHANDED
	gun_type = "smallarm"
	str_need = 11
	accuracy = 2
	w_class = 3
	force = 15
	spread = 5
	recoil = 2.5
	damagelose = 0.45
	distro = 10
	weight = 2

/obj/item/weapon/gun/projectile/revolver/bm16/sawnoff/gold
	name_ru = "Золотой обрез"
	icon_state = "bm16-sawn_gold"

/obj/item/weapon/gun/projectile/revolver/bm16/sawnoff/New()
	..()
	update_icon()

/obj/item/weapon/gun/projectile/shotgun/spsa
	name = "SPAS-12"
	name_ru = "SPAS-12"
	desc_ru = "Гладкоствольный автоматический дробовик. Увы, два выстрела сразу из него не сделать."
	icon_state = "spsa"	//Нужно добавить
	item_state = "spsa" //Нужно добавить
	slot_flags = SLOT_BACK | SLOT_BACK2
	mag_type = /obj/item/ammo_box/magazine/internal/shot/spsa
	gun_type = "longarm"
	str_need = 10
	accuracy = 3
	recoil = 0.8
	w_class = 4
	randomspread = 0
	spread = 8
	force = 15
	damagelose = 0.35
	distro = 8
	weapon_weight = WEAPON_MEDIUM
	weight = 5
	fire_sound = 'sound/stalker/weapons/spsa_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/spsa_load.ogg'
	pumpsound = 'sound/stalker/weapons/pump/spsa_pump.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'

///////////////////////////// Полуавтоматические дробовики //////////////////////////////////////////

/obj/item/weapon/gun/projectile/automatic/saiga  // Сайга
	name_ru = "Сайга"
	name = "Saiga"
	desc_ru = "Русское полуавтоматическое гладкоствольное ружье. Несмотря на проблемы с надежностью, обладает хорошими показателями вкупе с возможностью быстро перезаряжаться."
	desc = "A russian semiautomatic shotgun. Despite having reliability problems, is quite effective due to the ability to reload quickly."
	icon_state = "saiga"
	icon_ground = "saiga_ground"
	item_state = "saiga"
	fire_sound = 'sound/stalker/weapons/winchester1300_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/stalker/saiga
	gun_type = "longarm"
	str_need = 10
	accuracy = 3
	can_suppress = 0
	can_unsuppress = 0
	slot_flags = SLOT_BACK|SLOT_BACK2
	burst_size = 0
	force = 15
	origin_tech = "combat=5;materials=1"
	reliability_add = -1
	w_class = 5
	spread = 6
	force = 10
	damagelose = 0
	can_scope = 0
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 10
	weight = 3.5
	flags =  TWOHANDED
	distro = 8
	loadsound = 'sound/stalker/weapons/load/val_load.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'
	opensound = 'sound/stalker/weapons/unload/val_open.ogg'

/obj/item/weapon/gun/projectile/automatic/striker  // Армсел Страйкер
	name_ru = "Страйкер"
	name = "Striker"
	desc_ru = "Африканский чудо-юдо-дробовик. Вмещает дюжину патронов и довольно эффективен, но весит много и долго перезаряжается."
	desc = "A south-african wonder-shotgun. Holds more than a dozen shots in it's drum, but weighs a lot and reloading is slow."
	icon_state = "striker"
	icon_ground = "striker_ground"
	item_state = "striker"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/stalker/striker
	gun_type = "longarm"
	str_need = 10
	accuracy = 3
	can_suppress = 0
	can_unsuppress = 0
	slot_flags = SLOT_BACK | SLOT_BACK2
	burst_size = 0
	origin_tech = "combat=5;materials=1"
	w_class = 4
	spread = 6
	force = 10
	damagelose = 0
	can_scope = 0
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 10
	weight = 4.2
	flags =  TWOHANDED
	reliability_add = 10
	distro = 8
	fire_sound = 'sound/stalker/weapons/winchester1300_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/spsa_load.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'

/obj/item/weapon/gun/projectile/automatic/striker/New()
	if (!magazine)
		magazine = new mag_type(src)
	chamber_round()
	..()

/obj/item/weapon/gun/projectile/automatic/striker/attackby(obj/item/A, mob/user, params)
	if(!user.is_holding(src))
		return
	var/num_loaded = magazine.attackby(A, user, params, 1, 0, 0)
	if(num_loaded)
		if(jam)
			jam = 0
		playsound(user, loadsound, 50, 1, channel = "regular", time = 10)
		var/word = "патронов"
		switch(num_loaded)
			if(1)
				word = "патрон"
			if(2 to 4)
				word = "патрона"
		user << user.client.select_lang("<span class='notice'>Ты заряжаешь [num_loaded] [word] в [name_ru].</span>","<span class='notice'>You load [num_loaded] ammo casings in the [src].</span>")
		A.update_icon()
		update_icon()
		chamber_round()
		user.changeNext_move(CLICK_CD_MELEE)


/obj/item/weapon/gun/projectile/automatic/striker/MouseDrop(atom/over_object)
	return

///////////////////////////// Винтовки //////////////////////////////////////////

/obj/item/weapon/gun/projectile/shotgun/boltaction/enfield
	name = "Lee Enfield"
	desc_ru = ""
	desc = ""
	icon_state = "enfield"
	item_state = "enfield"
	slot_flags = SLOT_BACK | SLOT_BACK2
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enfield
	recoil = 1
	w_class = 4
	randomspread = 0
	spread = 3
	force = 15
	damagelose = 0.1
	weapon_weight = WEAPON_MEDIUM
	weight = 3.9
	fire_sound = 'sound/stalker/weapons/enfield_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/bolt_load.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'
	can_scope = 1

/obj/item/weapon/gun/projectile/shotgun/boltaction/enfield/mosin
	icon_state = "sawnmosin_donbashero"
	name_ru = "Мосинка героя донбасса"