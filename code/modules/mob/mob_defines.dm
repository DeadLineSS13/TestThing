/mob
	density = 1
	layer = 5
	animate_movement = 2
	flags = HEAR
	hud_possible = list(ANTAG_HUD)
	pressure_resistance = 8
	var/datum/mind/mind
	var/list/datum/action/actions = list()

	var/zone_selected = null

	var/stat = 0 //Whether a mob is alive or dead. TODO: Move this to living - Nodrak
	//var/karma = null
	var/obj/screen/flash = null
	var/obj/screen/blind = null
	var/obj/screen/internals = null
	var/obj/screen/damageoverlay = null
	var/obj/screen/whitenoise = null
	var/obj/screen/nightvision = null
	var/obj/screen/pulseimage = null

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/

	var/damageoverlaytemp = 0
	var/computer_id = null
	var/datum/lastattacker = null
	var/datum/lastattacked = null
	var/attack_log = list( )
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/disabilities = 0	//Carbon
	var/atom/movable/pulling = null
	var/next_move = null
	var/notransform = null	//Carbon
	var/hand = null
	var/eye_blind = 0		//Carbon
	var/eye_blurry = 0		//Carbon
	var/ear_deaf = 0		//Carbon
	var/ear_damage = 0		//Carbon
	var/stuttering = null	//Carbon
	var/slurring = 0		//Carbon
	var/real_name = null
	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon
	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/lying = 0
	var/lying_prev = 0
	var/canmove = 1
	var/exhausted = 0
	var/magniting = 0
	var/eye_stat = null//Living, potentially Carbon
	var/lastpuke = 0
	//var/deathtime = 0
	var/last_ckey = null
	var/list/hostiles = list()

	var/name_archive //For admin things like possession

	var/timeofdeath = 0//Living
	var/cpr_time = 1//Carbon

	var/active_hand_index = 1
	var/list/held_items = list(null, null) //len = number of hands, eg: 2 nulls is 2 empty hands, 1 item and 1 null is 1 full hand and 1 empty hand.

	var/bodytemperature = 310.055	//98.7 F
	var/drowsyness = 0//Carbon
	var/dizziness = 0//Carbon
	var/jitteriness = 0//Carbon
	var/nutrition = NUTRITION_LEVEL_FED + 50//Carbon
	var/satiety = 0//Carbon

	var/overeatduration = 0		// How long this guy is overeating //Carbon
	var/paralysis = 0
	var/stunned = 0
	var/weakened = 0
	var/losebreath = 0//Carbon
	var/a_intent = "help"//Living
	var/m_intent = "walk"//Living
	var/lastKnownIP = null
	var/atom/movable/buckled = null//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/storage/s_active = null//Carbon

	var/see_override = 0 //0 for no override, sets see_invisible = see_override in mob life process

	var/datum/hud/hud_used = null

	var/list/requests = list()

	var/list/mapobjs = list()

	var/in_throw_mode = 0

	var/music_lastplayed = "null"

	var/job = null//Living

	var/voice_name = "unidentifiable voice"

	var/list/faction = list("neutral") //A list of factions that this mob is currently in, for hostile mob targetting, amongst other things
	var/move_on_shuttle = 1 // Can move on the shuttle.

//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/mob/living/carbon/LAssailant = null


	var/list/mob_spell_list = list() //construct spells and mime spells. Spells that do not transfer from one mob to another and can not be lost in mindswap.

//Changlings, but can be used in other modes
//	var/obj/effect/proc_holder/changpower/list/power_list = list()

//List of active diseases

	var/list/viruses = list() // replaces var/datum/disease/virus
	var/list/resistances = list()

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER


	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/digitalcamo = 0 // Can they be tracked by the AI?
	var/digitalinvis = 0 //Are they ivisible to the AI?
	var/image/digitaldisguise = null  //what does the AI see instead of them?

	var/weakeyes = 0 //Are they vulnerable to flashes?

	var/has_unlimited_silicon_privilege = 0 // Can they interact with station electronics

	var/force_compose = 0 //If this is nonzero, the mob will always compose it's own hear message instead of using the one given in the arguments.

	var/obj/control_object //Used by admins to possess objects. All mobs should have this var
	var/atom/movable/remote_control //Calls relaymove() to whatever it is

	var/remote_view = 0 // Set to 1 to prevent view resets on Life


	var/list/permanent_huds = list()
	var/permanent_sight_flags = 0

	var/resize = 1 //Badminnery resize
	var/footstep = 1 //Used for steps sound
	var/footstep_sound = 0

	pixel_step_size = 0

	var/is_overweight = 0
	var/max_weight = 0

	var/turf/listed_turf = null  	//the current turf being examined in the stat panel
	var/list/shouldnt_see = list()	//list of objects that this mob shouldn't see in the stat panel. this silliness is needed because of AI alt+click and cult blood runes
	var/facing_dir = null   // Used for the ancient art of moonwalking.

	var/look_cooldown = 100
	var/look_incooldown = 0
	var/list/obj/anomaly/anomalies_in_look = list()
	var/list/obj/anomaly/anomalies_no_look = list()
	var/list/clients_names = list()