/mob/living/carbon/human
	languages = HUMAN
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD,ANTAG_HUD)
	//Hair colour and style
	var/hair_color = "000"
	var/hair_style = "Bald"

	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hair_style = "Shaved"

	//Eye colour
	var/eye_color = "000"

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	var/age = 30		//Player's age (pure fluff)

	var/underwear = "Nude"	//Which underwear the player wants
	var/undershirt = "Nude" //Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backbag = 1		//Which backpack type the player has chosen. Backpack.or Satchel

	var/datum/reagents/vessel	//Container for blood and BLOOD ONLY. Do not transfer other chems here.
	var/pale = 0			//Should affect how mob sprite is drawn, but currently doesn't.


	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/wear_suit_hard = null
	var/obj/item/head_hard = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/ears = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/icon/base_icon_state = "caucasian1_m"

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/blood_max = 0 //how much are we bleeding
	var/bleedsuppress = 0 //for stopping bloodloss, eventually this will be limb-based like bleeding
	var/bleed_rate = 0
	var/blood_regen_wait = 40			//40 потому что раз в 1.5 секунды вызывается проц. 1.5*40 = 60 секунд
	var/blood_loss_wait = 0				//1 чтобы кровь пошла через 1.5 секунды после удара

	var/list/organs = list() //Gets filled up in the constructor (human.dm, New() proc.

	var/heart_attack = 0

	var/zombiefied = 0
	var/sound_in_cooldown = 0

	var/education = ""
	var/profession = ""
	var/lifestyle = ""
	var/trait = ""

	var/death_dices = 0 //Номер пройденного дайса на смерть
	var/softdead = 0	//Мёртв ли мозг или нет, влияет на возможность воскрешения адреналином
	var/usefov = 1
	var/tangled = 0		//Эффект от аномалии путаница, влияет на речь
	var/sticky_pit = 0
	var/steps = 0
	var/list/blowout_effects = list("guns" = 0, "trainings" = 0, "eyes" = 0)
	var/medkit_was_used = 0

	var/money = 0