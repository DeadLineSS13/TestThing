// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list
// note: if you add more HUDs, even for non-human atoms, make sure to use unique numbers for the defines!
// /datum/atom_hud expects these to be unique
// these need to be strings in order to make them associative lists
#define HEALTH_HUD		"1" // dead, alive, sick, health status
#define STATUS_HUD		"2" // a simple line rounding the mob's number health
#define ID_HUD			"3" // the job asigned to your ID
#define WANTED_HUD		"4" // wanted, released, parroled, security status
#define IMPLOYAL_HUD	"5" // loyality implant
#define IMPCHEM_HUD		"6" // chemical implant
#define IMPTRACK_HUD	"7" // tracking implant
#define DIAG_STAT_HUD	"8" // Silicon/Mech Status
#define DIAG_HUD		"9" // Silicon health bar
#define DIAG_BATT_HUD	"10"// Borg/Mech power meter
#define DIAG_MECH_HUD	"11"// Mech health bar
#define DIAG_BOT_HUD	"12"// Bot HUDs
//for antag huds. these are used at the /mob level
#define ANTAG_HUD		"12"

//data HUD (medhud, sechud) defines
//Don't forget to update human/New() if you change these!
#define DATA_HUD_SECURITY_BASIC		1
#define DATA_HUD_SECURITY_ADVANCED	2
#define DATA_HUD_MEDICAL_BASIC		3
#define DATA_HUD_MEDICAL_ADVANCED	4
#define DATA_HUD_DIAGNOSTIC			5
//antag HUD defines
#define ANTAG_HUD_CULT		6
#define ANTAG_HUD_REV		7
#define ANTAG_HUD_OPS		8
#define ANTAG_HUD_WIZ		9
#define ANTAG_HUD_SHADOW    10
#define ANTAG_HUD_HOG_BLUE 11
#define ANTAG_HUD_HOG_RED 12

#define FULLSCREEN_PLANE 17
#define FLASH_LAYER 17
#define FULLSCREEN_LAYER 17.1
#define UI_DAMAGE_LAYER 17.2
#define BLIND_LAYER 17.3
#define CRIT_LAYER 17.4

#define HUD_PLANE 19
#define HUD_LAYER 19

#define ABOVE_HUD_PLANE 20
#define ABOVE_HUD_LAYER 20