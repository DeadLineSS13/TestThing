

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/consumable/orangejuice
	name = "Orange juice"
	id = "orangejuice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108" // rgb: 231, 129, 8

/datum/reagent/consumable/orangejuice/on_mob_life(mob/living/M)
	if(M.getOxyLoss() && prob(30))
		M.adjustOxyLoss(-1)
	..()
	return

/datum/reagent/consumable/tomatojuice
	name = "Tomato Juice"
	id = "tomatojuice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008" // rgb: 115, 16, 8

/datum/reagent/consumable/tomatojuice/on_mob_life(mob/living/M)
	if(M.getFireLoss() && prob(20))
		M.heal_organ_damage(0,1)
	..()
	return

/datum/reagent/consumable/limejuice
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48

/datum/reagent/consumable/limejuice/on_mob_life(mob/living/M)
	if(M.getToxLoss() && prob(20))
		M.adjustToxLoss(-1*REM)
	..()
	return

/datum/reagent/consumable/carrotjuice
	name = "Carrot juice"
	id = "carrotjuice"
	description = "It is just like a carrot but without crunching."
	color = "#973800" // rgb: 151, 56, 0

/datum/reagent/consumable/carrotjuice/on_mob_life(mob/living/M)
	M.eye_blurry = max(M.eye_blurry-1 , 0)
	M.eye_blind = max(M.eye_blind-1 , 0)
	switch(current_cycle)
		if(1 to 20)
			//nothing
		if(21 to INFINITY)
			if (prob(current_cycle-10))
				M.disabilities &= ~NEARSIGHT
	..()
	return

/datum/reagent/consumable/berryjuice
	name = "Berry Juice"
	id = "berryjuice"
	description = "A delicious blend of several different kinds of berries."
	color = "#863333" // rgb: 134, 51, 51

/datum/reagent/consumable/poisonberryjuice
	name = "Poison Berry Juice"
	id = "poisonberryjuice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353" // rgb: 134, 51, 83

/datum/reagent/consumable/poisonberryjuice/on_mob_life(mob/living/M)
	M.adjustToxLoss(1)
	..()
	return

/datum/reagent/consumable/watermelonjuice
	name = "Watermelon Juice"
	id = "watermelonjuice"
	description = "Delicious juice made from watermelon."
	color = "#863333" // rgb: 134, 51, 51

/datum/reagent/consumable/lemonjuice
	name = "Lemon Juice"
	id = "lemonjuice"
	description = "This juice is VERY sour."
	color = "#863333" // rgb: 175, 175, 0

/datum/reagent/consumable/banana
	name = "Banana Juice"
	id = "banana"
	description = "The raw essence of a banana. HONK"
	color = "#863333" // rgb: 175, 175, 0

/datum/reagent/consumable/banana/on_mob_life(mob/living/M)
	if( ( istype(M, /mob/living/carbon/human) && M.job in list("Clown") ) )
		M.heal_organ_damage(1,1)
	..()

/datum/reagent/consumable/nothing
	name = "Nothing"
	id = "nothing"
	description = "Absolutely nothing."

/datum/reagent/consumable/nothing/on_mob_life(mob/living/M)
	if(istype(M, /mob/living/carbon/human) && M.job in list("Mime"))
		M.heal_organ_damage(1,1)
	..()

/datum/reagent/consumable/potato_juice
	name = "Potato Juice"
	id = "potato"
	description = "Juice of the potato. Bleh."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/consumable/grapejuice
	name = "Grape juice"
	id = "grapejuice"
	description = "The juice of a bunch of grapes. Guaranteed non-alcoholic."
	color = "#290029" // dark purple

/datum/reagent/consumable/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223

/datum/reagent/consumable/milk/on_mob_life(mob/living/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_organ_damage(1,0)
	if(holder.has_reagent("capsaicin"))
		holder.remove_reagent("capsaicin", 2)
	..()
	return

/datum/reagent/consumable/soymilk
	name = "Soy Milk"
	id = "soymilk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7" // rgb: 223, 223, 199

/datum/reagent/consumable/soymilk/on_mob_life(mob/living/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/cream
	name = "Cream"
	id = "cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF" // rgb: 223, 215, 175

/datum/reagent/consumable/cream/on_mob_life(mob/living/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000" // rgb: 72, 32, 0
	nutriment_factor = 0
	overdose_threshold = 80

/datum/reagent/consumable/coffee/overdose_process(mob/living/M)
	M.Jitter(5)
	..()

/datum/reagent/consumable/coffee/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.sleeping = max(0,M.sleeping - 2)
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (25 * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(holder.has_reagent("frostoil"))
		holder.remove_reagent("frostoil", 5)
	..()

/datum/reagent/consumable/tea
	name = "Tea"
	id = "tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000" // rgb: 16, 16, 0
	nutriment_factor = 0

/datum/reagent/consumable/tea/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-2)
	M.drowsyness = max(0,M.drowsyness-1)
	M.jitteriness = max(0,M.jitteriness-3)
	M.sleeping = max(0,M.sleeping-1)
	if(M.getToxLoss() && prob(20))
		M.adjustToxLoss(-1)
	if (M.bodytemperature < 310)  //310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (20 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/consumable/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#102838" // rgb: 16, 40, 56
	nutriment_factor = 0

/datum/reagent/consumable/icecoffee/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.sleeping = max(0,M.sleeping-2)
	if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.Jitter(5)
	..()
	return

/datum/reagent/consumable/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "No relation to a certain rap artist/ actor."
	color = "#104038" // rgb: 16, 64, 56
	nutriment_factor = 0

/datum/reagent/consumable/icetea/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-2)
	M.drowsyness = max(0,M.drowsyness-1)
	M.sleeping = max(0,M.sleeping-2)
	if(M.getToxLoss() && prob(20))
		M.adjustToxLoss(-1)
	if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/consumable/space_cola
	name = "Cola"
	id = "cola"
	description = "A refreshing beverage."
	color = "#100800" // rgb: 16, 8, 0

/datum/reagent/consumable/space_cola/on_mob_life(mob/living/M)
	M.drowsyness = max(0,M.drowsyness-5)
	if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/consumable/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	description = "Cola, cola never changes."
	color = "#100800" // rgb: 16, 8, 0

/datum/reagent/consumable/nuka_cola/on_mob_life(mob/living/M)
	M.Jitter(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness +=5
	M.drowsyness = 0
	M.sleeping = max(0,M.sleeping-2)
	M.status_flags |= GOTTAGOFAST
	if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/consumable/spacemountainwind
	name = "SM Wind"
	id = "spacemountainwind"
	description = "Blows right through you like a space wind."
	color = "#102000" // rgb: 16, 32, 0

/datum/reagent/consumable/spacemountainwind/on_mob_life(mob/living/M)
	M.drowsyness = max(0,M.drowsyness-7)
	M.sleeping = max(0,M.sleeping-1)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.Jitter(5)
	..()
	return

/datum/reagent/consumable/dr_gibb
	name = "Dr. Gibb"
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavours"
	color = "#102000" // rgb: 16, 32, 0

/datum/reagent/consumable/dr_gibb/on_mob_life(mob/living/M)
	M.drowsyness = max(0,M.drowsyness-6)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/consumable/space_up
	name = "Space-Up"
	id = "space_up"
	description = "Tastes like a hull breach in your mouth."
	color = "#00FF00" // rgb: 0, 255, 0

/datum/reagent/consumable/space_up/on_mob_life(mob/living/M)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (8 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/consumable/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	id = "lemon_lime"
	color = "#8CFF00" // rgb: 135, 255, 0

/datum/reagent/consumable/lemon_lime/on_mob_life(mob/living/M)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (8 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/consumable/sodawater
	name = "Soda Water"
	id = "sodawater"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494" // rgb: 97, 148, 148

/datum/reagent/consumable/sodawater/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/consumable/tonic
	name = "Tonic Water"
	id = "tonic"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#0064C8" // rgb: 0, 100, 200

/datum/reagent/consumable/tonic/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.sleeping = max(0,M.sleeping-2)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/consumable/ice
	name = "Ice"
	id = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148

/datum/reagent/consumable/ice/on_mob_life(mob/living/M)
	M.bodytemperature -= 5 * TEMPERATURE_DAMAGE_COEFFICIENT
	..()
	return

/datum/reagent/consumable/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	color = "#664300" // rgb: 102, 67, 0

/datum/reagent/consumable/soy_latte/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.sleeping = 0
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.Jitter(5)
	if(M.getBruteLoss() && prob(20))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	description = "A nice, strong and tasty beverage while you are reading."
	color = "#664300" // rgb: 102, 67, 0

/datum/reagent/consumable/cafe_latte/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.sleeping = 0
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.Jitter(5)
	if(M.getBruteLoss() && prob(20))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the Medibot away! A mixture of juices that heals most damage types fairly quickly at the cost of hunger."
	color = "#FF8CFF" // rgb: 255, 140, 255

/datum/reagent/consumable/doctor_delight/on_mob_life(mob/living/M)
	M.adjustBruteLoss(-0.5)
	M.adjustFireLoss(-0.5)
	M.adjustToxLoss(-0.5)
	M.adjustOxyLoss(-0.5)
	if(M.nutrition && (M.nutrition - 2 > 0))
		if(!(M.mind && M.mind.assigned_role == "Medical Doctor")) //Drains the nutrition of the holder. Not medical doctors though, since it's the Doctor's Delight!
			M.nutrition -= 2
	..()

/datum/reagent/consumable/chocolatepudding
	name = "Chocolate Pudding"
	id = "chocolatepudding"
	description = "A great dessert for chocolate lovers."
	color = "#800000"
	nutriment_factor = 4 * REAGENTS_METABOLISM

/datum/reagent/consumable/vanillapudding
	name = "Vanilla Pudding"
	id = "vanillapudding"
	description = "A great dessert for vanilla lovers."
	color = "#FAFAD2"
	nutriment_factor = 4 * REAGENTS_METABOLISM

/datum/reagent/consumable/cherryshake
	name = "Cherry Shake"
	id = "cherryshake"
	description = "A cherry flavored milkshake."
	color = "#FFB6C1"
	nutriment_factor = 4 * REAGENTS_METABOLISM

/datum/reagent/consumable/bluecherryshake
	name = "Blue Cherry Shake"
	id = "bluecherryshake"
	description = "An exotic milkshake."
	color = "#00F1FF"
	nutriment_factor = 4 * REAGENTS_METABOLISM

/datum/reagent/consumable/pumpkin_latte
	name = "Pumpkin Latte"
	id = "pumpkin_latte"
	description = "A mix of pumpkin juice and coffee."
	color = "#F4A460"
	nutriment_factor = 3 * REAGENTS_METABOLISM

/datum/reagent/consumable/gibbfloats
	name = "Gibb Floats"
	id = "gibbfloats"
	description = "Icecream on top of a Dr. Gibb glass."
	color = "#B22222"
	nutriment_factor = 3 * REAGENTS_METABOLISM

/datum/reagent/consumable/pumpkinjuice
	name = "Pumpkin Juice"
	id = "pumpkinjuice"
	description = "Juiced from real pumpkin."
	color = "#FFA500"

/datum/reagent/consumable/blumpkinjuice
	name = "Blumpkin Juice"
	id = "blumpkinjuice"
	description = "Juiced from real blumpkin."
	color = "#00BFFF"

/datum/reagent/consumable/triple_citrus
	name = "Triple Citrus"
	id = "triple_citrus"
	description = "A solution."
	color = "#C8A5DC"

/datum/reagent/consumable/grape_soda
	name = "Grape soda"
	id = "grapesoda"
	description = "Beloved of children and teetotalers."
	color = "#E6CDFF"

//////////////////////////////////////////////The ten friggen million reagents that get you drunk//////////////////////////////////////////////

/datum/reagent/consumable/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	description = "Nuclear proliferation never tasted so good."
	color = "#666300" // rgb: 102, 99, 0

/datum/reagent/consumable/atomicbomb/on_mob_life(mob/living/M)
	M.druggy = max(M.druggy, 50)
	M.confused = max(M.confused+2,0)
	M.Dizzy(10)
	if (!M.slurring)
		M.slurring = 1
	M.slurring += 3
	switch(current_cycle)
		if(51 to 200)
			M.sleeping += 1
		if(201 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss(2)
	..()
	return

/datum/reagent/consumable/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Whoah, this stuff looks volatile!"
	color = "#664300" // rgb: 102, 67, 0

/datum/reagent/consumable/gargle_blaster/on_mob_life(mob/living/M)
	M.dizziness +=6
	switch(current_cycle)
		if(15 to 45)
			if(!M.slurring)
				M.slurring = 1
			M.slurring += 3
		if(45 to 55)
			if(prob(50))
				M.confused = max(M.confused+3,0)
		if(55 to 200)
			M.druggy = max(M.druggy, 55)
		if(200 to INFINITY)
			M.adjustToxLoss(2)
	..()
	return

/datum/reagent/consumable/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	color = "#2E2E61" // rgb: 46, 46, 97

/datum/reagent/consumable/neurotoxin/on_mob_life(mob/living/carbon/M)
	M.weakened = max(M.weakened, 3)
	M.dizziness +=6
	switch(current_cycle)
		if(15 to 45)
			if(!M.slurring)
				M.slurring = 1
			M.slurring += 3
		if(45 to 55)
			if(prob(50))
				M.confused = max(M.confused+3,0)
		if(55 to 200)
			M.druggy = max(M.druggy, 55)
		if(200 to INFINITY)
			M.adjustToxLoss(2)
	..()
	return

/datum/reagent/consumable/hippies_delight
	name = "Hippie's Delight"
	id = "hippiesdelight"
	description = "You just don't get it maaaan."
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 0
	metabolization_rate = 0.2 * REAGENTS_METABOLISM

/datum/reagent/consumable/hippies_delight/on_mob_life(mob/living/M)
	M.druggy = max(M.druggy, 50)
	switch(current_cycle)
		if(1 to 5)
			if (!M.slurring) M.slurring = 1
			M.Dizzy(10)
			if(prob(10)) M.emote(pick("twitch","giggle"))
		if(5 to 10)
			if (!M.slurring) M.slurring = 1
			M.Jitter(20)
			M.Dizzy(20)
			M.druggy = max(M.druggy, 45)
			if(prob(20)) M.emote(pick("twitch","giggle"))
		if (10 to 200)
			if (!M.slurring) M.slurring = 1
			M.Jitter(40)
			M.Dizzy(40)
			M.druggy = max(M.druggy, 60)
			if(prob(30)) M.emote(pick("twitch","giggle"))
		if(200 to INFINITY)
			if (!M.slurring) M.slurring = 1
			M.Jitter(60)
			M.Dizzy(60)
			M.druggy = max(M.druggy, 75)
			if(prob(40)) M.emote(pick("twitch","giggle"))
			if(prob(30)) M.adjustToxLoss(2)
	..()
	return
