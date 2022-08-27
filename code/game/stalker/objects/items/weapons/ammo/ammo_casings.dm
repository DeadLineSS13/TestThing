/obj/item/ammo_casing
	weight = 0.01

/obj/item/ammo_casing/c9x18
	desc_ru = "Калибр 9х18мм ПМ."
	desc = "A 9x18mm bullet casing."
	weight = 0.01
	projectile_type = /obj/item/projectile/bullet/bullet9x18

/obj/item/ammo_casing/c9x18/P
	desc_ru = "Калибр 9х18мм ПМ, повышенной мощности."
	desc = "A 9x18mm +P+ bullet casing."
	projectile_type = /obj/item/projectile/bullet/bullet9x18P

/obj/item/ammo_casing/c545
	desc_ru = "Калибр 5.45х39мм."
	desc = "A 5.45x39mm bullet casing."
	icon_state = "sS-casing"
	weight = 0.01
	projectile_type = /obj/item/projectile/bullet/bullet545

/obj/item/ammo_casing/cola
	desc_ru = "Капля колы."
	desc = "A Cola droplet."
	icon_state = "sS-casing"
	weight = 0.01
	projectile_type = /obj/item/projectile/bullet/bulletcola

/obj/item/ammo_casing/c545/AP
	desc_ru = "Калибр 5.45х39мм, бронебойный."
	desc = "A 5.45x39mm AP bullet casing."
	projectile_type = /obj/item/projectile/bullet/bullet545AP

/obj/item/ammo_casing/shotgun
	stackable = 6
	var/powder_need = 1
	var/craft_step = 0

/obj/item/ammo_casing/shotgun/c12x70
	desc_ru = "Калибр 12G."
	desc = "A 12G buckshot casing."
	icon_state = "gshell"
	weight = 0.05
	projectile_type = /obj/item/projectile/bullet/bullet12x70
	powder_need = 2

/obj/item/ammo_casing/shotgun/c12x70P
	desc_ru = "Калибр 12G, пулевой."
	desc = "A 12G slug casing."
	icon_state = "stunshell"
	pellets = 1
	weight = 0.06
	projectile_type = /obj/item/projectile/bullet/bullet12x70p

/obj/item/ammo_casing/shotgun/c12x70D
	desc_ru = "Калибр 12G, дротик."
	desc = "A 12G dart bullet casing."
	icon_state = "blshell"
	pellets = 1
	weight = 0.06
	projectile_type = /obj/item/projectile/bullet/bullet12x70d

/obj/item/ammo_casing/c9x19
	desc_ru = "Калибр 9х19мм Парабеллум."
	desc = "A 9x19mm bullet casing."
	weight = 0.012
	projectile_type = /obj/item/projectile/bullet/bullet9x19

/obj/item/ammo_casing/c9x19/P
	desc_ru = "Калибр 9х19мм Парабеллум, бронебойный."
	desc = "A 9x19mm armor piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/bullet9x19P

/obj/item/ammo_casing/c9x21
	desc_ru = "Калибр 9х21мм."
	desc = "A 9x21mm bullet casing."
	weight = 0.011
	projectile_type = /obj/item/projectile/bullet/bullet9x21

/obj/item/ammo_casing/c57x28
	desc_ru = "Калибр 5.7х28мм."
	desc = "A 5.7x28mm bullet casing."
	icon_state = "sS-casing"
	weight = 0.006
	projectile_type = /obj/item/projectile/bullet/bullet57

/obj/item/ammo_casing/sp9x39
	desc_ru = "Калибр 9х39мм."
	desc = "A 9x39mm bullet casing."
	icon_state = "sS-casing"
	weight = 0.023
	projectile_type = /obj/item/projectile/bullet/bullet9x39

/obj/item/ammo_casing/acp45
	desc_ru = "Калибр .45 ACP."
	desc = "A .45 ACP bullet casing"
	weight = 0.021
	projectile_type = /obj/item/projectile/bullet/bulletacp45

/obj/item/ammo_casing/acp45/P
	desc_ru = "Калибр .45 ACP, экспансивный."
	desc = "A .45 ACP Hydroshock bullet casing"
	projectile_type = /obj/item/projectile/bullet/bulletacp45P

/obj/item/ammo_casing/testgun
	desc = "testgun casing"
	caliber = "testgun"
	projectile_type = /obj/item/projectile/bullet/testgun

/obj/item/ammo_casing/c556x45
	desc_ru = "Калибр 5.56х45мм НАТО."
	desc = "A 5.55x45mm bullet."
	icon_state = "sS-casing"
	weight = 0.012
	projectile_type = /obj/item/projectile/bullet/bullet556x45

/obj/item/ammo_casing/c556x45/AP
	desc_ru = "Калибр 5.56х45мм НАТО, бронебойный."
	desc = "A 5.55x45mm AP bullet."
	projectile_type = /obj/item/projectile/bullet/bullet556x45AP

/obj/item/ammo_casing/mag44
	desc_ru = "Калибр .44 Магнум."
	desc = "A .44 Magnum bullet casing."
	weight = 0.025
	projectile_type = /obj/item/projectile/bullet/bulletmag44

/obj/item/ammo_casing/mag44/FMJ
	desc_ru = "Калибр .44 Магнум, цельнооболоченный бронебойный."
	desc = "A .44 Magnum FMJ bullet casing."
	projectile_type = /obj/item/projectile/bullet/bulletmag44FMJ

/obj/item/ammo_casing/rsh127
	desc_ru = "Калибр 12.7x55мм."
	desc = "A 12.7x55mm bullet casing."
	weight = 0.075
	projectile_type = /obj/item/projectile/bullet/bullet127x55

/obj/item/ammo_casing/c762x25
	desc_ru = "Калибр 7.62х25мм Токарев."
	desc = "A 7.62x25 bullet casing."
	weight = 0.011
	projectile_type = /obj/item/projectile/bullet/bullet762x25

/obj/item/ammo_casing/caseless/c762x16
	desc_ru = "Безгильзовый 7.62х16мм."
	desc = "A 7.62x16 caseless."
	weight = 0.005
	projectile_type = /obj/item/projectile/bullet/bullet762x16

/obj/item/ammo_casing/c762x54
	desc_ru = "Калибр 7.62х54мм."
	desc = "A 7.62x54 bullet casing."
	icon_state = "sS-casing"
	weight = 0.023
	projectile_type = /obj/item/projectile/bullet/bullet762x54

/obj/item/ammo_casing/c762x51
	desc_ru = "Калибр 7.62х51мм НАТО."
	desc = "A 7.62x51 bullet casing."
	icon_state = "sS-casing"
	weight = 0.025
	projectile_type = /obj/item/projectile/bullet/bullet762x51

/obj/item/ammo_casing/c762x39
	desc_ru = "Калибр 7.62х39мм."
	desc = "A 7.62x39 bullet casing."
	icon_state = "sS-casing"
	weight = 0.016
	projectile_type = /obj/item/projectile/bullet/bullet762x39
	caliber = "a762"

/obj/item/ammo_casing/caseless/rpg7
	name = "RPG-7 rocket"
	name_ru = "ракета РПГ-7"
	desc_ru = "Ого, ракета."
	desc = "Wow, a rocket."
	icon_state = "rpg"
	stackable = 1
	weight = 2.25
	projectile_type = /obj/item/projectile/bullet/rpg7
