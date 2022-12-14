//ITEM INVENTORY SLOT BITMASKS
#define SLOT_OCLOTHING		1
#define SLOT_OCLOTHING_HARD	2
#define SLOT_ICLOTHING		4
#define SLOT_GLOVES			8
#define SLOT_EYES			16
#define SLOT_EARS			32
#define SLOT_MASK			64
#define SLOT_HEAD			128
#define SLOT_HEAD_HARD		256
#define SLOT_FEET			512
#define SLOT_ID				1024
#define SLOT_BELT			2048
#define SLOT_BACK			4096
#define SLOT_BACK2			8192
#define SLOT_POCKET			16382		//this is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET		32768		//this is to deny items with a w_class of 2 or 1 to fit in pockets.

//Bit flags for the flags_inv variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.
#define HIDEGLOVES		1
#define HIDESUITSTORAGE	2
#define HIDEJUMPSUIT	4	//these first four are only used in exterior suits
#define HIDESHOES		8
#define HIDEMASK		16	//these last six are only used in masks and headgear.
#define HIDEEARS		32	// (ears means headsets and such)
#define HIDEEYES		64	// Whether eyes and glasses are hidden
#define HIDEFACE		128	// Whether we appear as unknown.
#define HIDEHAIR		256
#define HIDEFACIALHAIR	512

//slots
#define slot_back			1
#define slot_wear_mask		2
#define slot_handcuffed		3
#define slot_hands			4
#define slot_belt			5
#define slot_wear_id		6
#define slot_ears			7
#define slot_glasses		8
#define slot_gloves			9
#define slot_head			10
#define slot_shoes			11
#define slot_wear_suit		12
#define slot_w_uniform		13
#define slot_l_store		14
#define slot_r_store		15
#define slot_s_store		16
#define slot_in_backpack	17
#define slot_legcuffed		18
#define slot_drone_storage	19
#define slot_back2			20
#define slot_wear_suit_hard	21
#define slot_head_hard		22
#define slots_amt			22 // Keep this up to date!

/proc/slotdefine2slotbit(slotdefine) //Keep this up to date with the value of SLOT BITMASKS and SLOTS (the two define sections above)
	. = 0
	switch(slotdefine)
		if(slot_back)
			. = SLOT_BACK
		if(slot_back2)
			. = SLOT_BACK2
		if(slot_wear_mask)
			. = SLOT_MASK
		if(slot_belt)
			. = SLOT_BELT
		if(slot_wear_id)
			. = SLOT_ID
		if(slot_ears)
			. = SLOT_EARS
		if(slot_glasses)
			. = SLOT_EYES
		if(slot_gloves)
			. = SLOT_GLOVES
		if(slot_head)
			. = SLOT_HEAD
		if(slot_shoes)
			. = SLOT_FEET
		if(slot_wear_suit)
			. = SLOT_OCLOTHING
		if(slot_wear_suit_hard)
			. = SLOT_OCLOTHING_HARD
		if(slot_w_uniform)
			. = SLOT_ICLOTHING
		if(slot_l_store, slot_r_store)
			. = SLOT_POCKET

//Cant seem to find a mob bitflags area other than the powers one

// bitflags for clothing parts - also used for limbs
//bitflags for clothing coverage - also used for limbs
#define HEAD		(1<<0)
#define CHEST		(1<<1)
#define GROIN		(1<<2)
#define LEG_LEFT	(1<<3)
#define LEG_RIGHT	(1<<4)
#define LEGS		(LEG_LEFT | LEG_RIGHT)
#define FOOT_LEFT	(1<<5)
#define FOOT_RIGHT	(1<<6)
#define FEET		(FOOT_LEFT | FOOT_RIGHT)
#define ARM_LEFT	(1<<7)
#define ARM_RIGHT	(1<<8)
#define ARMS		(ARM_LEFT | ARM_RIGHT)
#define HAND_LEFT	(1<<9)
#define HAND_RIGHT	(1<<10)
#define HANDS		(HAND_LEFT | HAND_RIGHT)
#define NECK		(1<<11)
#define FULL_BODY	(~0)
// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD			0.3
#define THERMAL_PROTECTION_CHEST		0.15
#define THERMAL_PROTECTION_GROIN		0.15
#define THERMAL_PROTECTION_LEG_LEFT		0.075
#define THERMAL_PROTECTION_LEG_RIGHT	0.075
#define THERMAL_PROTECTION_FOOT_LEFT	0.025
#define THERMAL_PROTECTION_FOOT_RIGHT	0.025
#define THERMAL_PROTECTION_ARM_LEFT		0.075
#define THERMAL_PROTECTION_ARM_RIGHT	0.075
#define THERMAL_PROTECTION_HAND_LEFT	0.025
#define THERMAL_PROTECTION_HAND_RIGHT	0.025

//flags for female outfits: How much the game can safely "take off" the uniform without it looking weird

//flags for female outfits: How much the game can safely "take off" the uniform without it looking weird

#define NO_FEMALE_UNIFORM			0
#define FEMALE_UNIFORM_FULL			1
#define FEMALE_UNIFORM_TOP			2

//flags for alternate styles: These are hard sprited so don't set this if you didn't put the effort it

#define NORMAL_STYLE		0
#define ALT_STYLE			1
#define DIGITIGRADE_STYLE 	2

//flags for outfits that have mutantrace variants (try not to use this): Currently only needed if you're trying to add tight fitting bootyshorts

#define NO_MUTANTRACE_VARIATION		0
#define MUTANTRACE_VARIATION		1

#define NOT_DIGITIGRADE				0
#define FULL_DIGITIGRADE			1
#define SQUISHED_DIGITIGRADE		2

//flags for covering body parts
#define GLASSESCOVERSEYES	1
#define MASKCOVERSEYES		2		// get rid of some of the other retardation in these flags
#define HEADCOVERSEYES		4		// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH		8		// on other items, these are just for mask/head
#define HEADCOVERSMOUTH		16