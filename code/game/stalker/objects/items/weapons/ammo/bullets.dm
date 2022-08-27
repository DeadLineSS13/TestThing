// range: 1 тайл = 4
/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	pul = PUL1
	armp = 0
	expan = 0
	spread = 0
	impact_effect_type = /obj/effect/overlay/temp/impact_effect
	flag = "bullet"
	hitsound_wall = "ricochet"
	layer = 11

/obj/item/projectile/bullet/bullet9x18
	name_ru = "Пуля"
	dice_num = 2
	damage_add = 0
	range = 80

/obj/item/projectile/bullet/bullet9x18P
	name_ru = "Пуля"
	dice_num = 2
	damage_add = 2
	range = 80

/obj/item/projectile/bullet/bullet9x21
	name_ru = "Пуля"
	dice_num = 3
	damage_add = 1
	armp = 1
	range = 80

/obj/item/projectile/bullet/bullet57
	name_ru = "Пуля"
	dice_num = 3
	damage_add = 1
	armp = 1
	range = 80

/obj/item/projectile/bullet/bullet545
	name_ru = "Пуля"
	dice_num = 4
	damage_add = 2
	range = 160

/obj/item/projectile/bullet/bullet545AP
	name_ru = "Пуля"
	dice_num = 4
	damage_add = 2
	armp = 1
	range = 160

/obj/item/projectile/bullet/bulletcola
	name_ru = "Кола"
	icon_state = "cola"
	dice_num = 4
	damage_add = 2
	range = 160

/obj/item/projectile/bullet/bullet12x70
	name_ru = "Дробь"
	icon_state = "buckshot"
	isfraction = 1
	dice_num = 10
	damage_add = 0
	range = 10

/obj/item/projectile/bullet/bullet12x70p
	name_ru = "Пуля"
	dice_num = 5
	damage_add = 0
	pul = PUL3
	range = 80

/obj/item/projectile/bullet/bullet12x70d
	name_ru = "Пуля"
	dice_num = 4
	damage_add = 0
	pul = PUL3
	armp = 1
	range = 80

/obj/item/projectile/bullet/bullet9x19
	name_ru = "Пуля"
	dice_num = 2
	damage_add = 2
	range = 80

/obj/item/projectile/bullet/bullet9x19P
	name_ru = "Пуля"
	dice_num = 2
	damage_add = 2
	armp = 1
	range = 80

/obj/item/projectile/bullet/bullet9x39
	name_ru = "Пуля"
	dice_num = 4
	damage_add = -2
	armp = 1
	range = 80

/obj/item/projectile/bullet/bulletacp45
	name_ru = "Пуля"
	dice_num = 2
	damage_add = 0
	pul = PUL2
	range = 80

/obj/item/projectile/bullet/bulletacp45P
	name_ru = "Пуля"
	dice_num = 2
	damage_add = 0
	expan = 1
	pul = PUL2
	range = 80

/obj/item/projectile/bullet/testgun
	name_ru = "Пуля"
	damage_add = 10
	range = 50
	speed = 0
	spread = 15

/obj/item/projectile/bullet/bullet556x45
	name_ru = "Пуля"
	dice_num = 5
	damage_add = 0
	range = 160

/obj/item/projectile/bullet/bullet556x45AP
	name_ru = "Пуля"
	dice_num = 5
	damage_add = 0
	armp = 1
	range = 160

/obj/item/projectile/bullet/bulletmag44
	name_ru = "Пуля"
	dice_num = 3
	damage_add = 2
	pul = PUL2
	range = 80

/obj/item/projectile/bullet/bullet127x55
	name_ru = "Пуля"
	dice_num = 6
	damage_add = 0
	pul = PUL2
	range = 80

/obj/item/projectile/bullet/bulletmag44FMJ
	name_ru = "Пуля"
	dice_num = 3
	damage_add = 2
	pul = PUL2
	armp = 1
	range = 80

/obj/item/projectile/bullet/bullet762x25
	name_ru = "Пуля"
	dice_num = 3
	damage_add = 1
	pul = PUL0
	range = 80

/obj/item/projectile/bullet/bullet762x16
	name_ru = "Пуля"
	dice_num = 3
	damage_add = 0
	armp = 1
	range = 80

/obj/item/projectile/bullet/bullet762x54
	name_ru = "Пуля"
	dice_num = 7
	damage_add = 1
	range = 240

/obj/item/projectile/bullet/bullet762x51
	name_ru = "Пуля"
	dice_num = 7
	damage_add = 0
	range = 240

/obj/item/projectile/bullet/bullet762x39
	name_ru = "Пуля"
	dice_num = 5
	damage_add = 1
	range = 160

/obj/item/projectile/bullet/rpg7
	name ="RPG-7 rocket"
	icon_state= "rpg"
	damage_add = 0

/obj/item/projectile/bullet/rpg7/on_hit(atom/target)
	..()
	explosion(target, 1, 0, 4)
	return 1