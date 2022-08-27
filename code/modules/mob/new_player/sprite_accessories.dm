/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/
/proc/init_sprite_accessory_subtypes(prototype, list/L, list/male, list/female)
	if(!istype(L))		L = list()
	if(!istype(male))	male = list()
	if(!istype(female))	female = list()

	for(var/path in typesof(prototype))
		if(path == prototype)	continue
		var/datum/sprite_accessory/D = new path()

		L[D.name] = D

		switch(D.gender)
			if(MALE)	male += D.name
			if(FEMALE)	female += D.name
			else
				male += D.name
				female += D.name
	return L

/datum/sprite_accessory
	var/icon			//the icon file the accessory is located in
	var/icon_state		//the icon_state of the accessory
	var/name			//the preview name of the accessory
	var/gender = NEUTER	//Determines if the accessory will be skipped or included in random hair generations
	var/gender_specific //Something that can be worn by either gender, but looks different on each
	var/color_src = MUTCOLORS	//Currently only used by mutantparts so don't worry about hair and stuff. This is the source that this accessory will get its color from. Default is MUTCOLOR, but can also be HAIR, FACEHAIR, EYECOLOR and 0 if none.
	var/hasinner		//Decides if this sprite has an "inner" part, such as the fleshy parts on ears.
	var/desc_ru		//������������ �����, ��� ������� �-�� "� ���� � Y � Z Y", ��� X ���� �����, Z ���� ������, Y �������� (������ �� �����, ������ �� ������)
	var/desc

//////////////////////
// Hair Definitions //
//////////////////////
/datum/sprite_accessory/hair
	icon = 'icons/mob/human_face.dmi'	  // default icon for all hairs

/datum/sprite_accessory/hair/short
	name = "Korotkie so strijkoy"	  // try to capatilize the names please~
	desc_ru = "�� �������� ������"
	desc = "short hair"
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

/datum/sprite_accessory/hair/cut
	name = "Korotkie bez strijki"
	desc_ru = "�� �������� ������"
	desc = "short hair"
	icon_state = "hair_c"

/datum/sprite_accessory/hair/longer
	name = "Dlinnie"
	desc_ru = "�� ������� ������"
	desc = "long hair"
	icon_state = "hair_vlong"

/datum/sprite_accessory/hair/chub
	name = "Chub"
	desc_ru = "�� ���"
	desc = "forelock"
	icon_state = "hair_chub"

/datum/sprite_accessory/hair/longfringe
	name = "Medovor"
	desc_ru = "�� ������� ������"
	desc = "long hair"
	icon_state = "hair_longfringe"

/datum/sprite_accessory/hair/longestalt
	name = "Medovor 2: Assnation"
	desc_ru = "�� ������� ������"
	desc = "long hair"
	icon_state = "hair_vlongfringe"

/datum/sprite_accessory/hair/gentle
	name = "Do plech"
	desc_ru = "�� ������� ������"
	desc = "long hair"
	icon_state = "hair_gentle"

/datum/sprite_accessory/hair/ponytail1
	name = "Hvostik"
	desc_ru = "�� ������ ���������"
	desc = "ponytail"
	icon_state = "hair_ponytail"

/datum/sprite_accessory/hair/ponytail2
	name = "Hvostik pyshniy "
	desc_ru = "�� ������ ���������"
	desc = "ponytail"
	icon_state = "hair_ponytail2"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadurchik"
	desc_ru = "�� ��������"
	desc = "pompadour"
	icon_state = "hair_pompadour"

/datum/sprite_accessory/hair/bedhead
	name = "Sprosonya"
	desc_ru = "�� ������������ ������"
	desc = "disheveled hair"
	icon_state = "hair_bedhead"

/datum/sprite_accessory/hair/bedhead2
	name = "Sprosonya tolko kruche"
	desc_ru = "�� ������������ ������"
	desc = "disheveled hair"
	icon_state = "hair_bedheadv2"

/datum/sprite_accessory/hair/bobcurl
	name = "Pyshnie"
	desc_ru = "�� ������ ��������"
	desc = "curly hair"
	icon_state = "hair_bobcurl"

/datum/sprite_accessory/hair/buzz
	name = "Natsik"
	desc_ru = "�� ������ �����"
	desc = "hair with shaved sideburns"
	icon_state = "hair_buzzcut"

/datum/sprite_accessory/hair/crew
	name = "Soldatik"
	desc_ru = "�� ��������� �������"
	desc = "army haircut"
	icon_state = "hair_crewcut"

/datum/sprite_accessory/hair/combover
	name = "Zachyos"
	desc_ru = "�� �����"
	desc = "combover"
	icon_state = "hair_combover"

/datum/sprite_accessory/hair/dreadlocks
	name = "Metla"
	desc_ru = "�� ������ '������'"
	desc = "dreads"
	icon_state = "hair_dreads"

/datum/sprite_accessory/hair/afro
	name = "Urbanist"
	desc_ru = "�� ������ ������"
	desc = "afro haircut"
	icon_state = "hair_afro"

/datum/sprite_accessory/hair/fag
	name = "Chelka"
	desc_ru = "�� �����"
	desc = "fringe"
	icon_state = "hair_f"

/datum/sprite_accessory/hair/feather
	name = "Rastrepanniy"
	desc_ru = "�� ������������ ������"
	desc = "disheveled hair"
	icon_state = "hair_feather"

/datum/sprite_accessory/hair/jensen
	name = "Korotkie baki"
	desc_ru = "�� �������� � �������� ������"
	desc = "hair with long sideburns"
	icon_state = "hair_jensen"

/datum/sprite_accessory/hair/gelled
	name = "Zalizanniy nazad"
	desc_ru = "�� ���������� ������"
	desc = "gelled back hair"
	icon_state = "hair_gelled"

/datum/sprite_accessory/hair/spiky
	name = "Torchok"
	desc_ru = "�� �������� ������"
	desc = "spiky hair"
	icon_state = "hair_spikey"

/datum/sprite_accessory/hair/lowbraid
	name = "Hipster"
	desc_ru = "�� �������� ������"
	desc = "hipster haircut"
	icon_state = "hair_hbraid"

/datum/sprite_accessory/hair/skinhead
	name = "Korotkiy ejik"
	desc_ru = "��, ����� �������� ������"
	desc = "almost shaved hair"
	icon_state = "hair_skinhead"

/datum/sprite_accessory/hair/longbangs
	name = "Neuhojenny"
	desc_ru = "�� ����������� ������"
	desc = "unkempt hair"
	icon_state = "hair_lbangs"

/datum/sprite_accessory/hair/balding
	name = "Lyseyushiy"
	desc_ru = "�� �������� ������"
	desc = "balding hair"
	icon_state = "hair_e"

/datum/sprite_accessory/hair/bald
	name = "Lysiy"
	desc_ru = "����� ������"
	desc = "bald head"
	icon_state = "bald"

/datum/sprite_accessory/hair/parted
	name = "Probor"
	desc_ru = "�� �������� � ��������"
	desc = "parted hair"
	icon_state = "hair_part"

/datum/sprite_accessory/hair/swept
	name = "Silniy zachyos"
	desc_ru = "��, ������ ���������� ��������"
	desc = "swept hair"
	icon_state = "hair_swept"

/datum/sprite_accessory/hair/business
	name = "Agent"
	desc_ru = "�� ������ � '�����������' ��������"
	desc = "business hair"
	icon_state = "hair_business"

/datum/sprite_accessory/hair/business3
	name = "Zamestitel"
	desc_ru = "�� ������ � '�����������' ��������"
	desc = "business hair"
	icon_state = "hair_business3"

/datum/sprite_accessory/hair/business4
	name = "Zamestitel rangom pomenshe"
	desc_ru = "�� ������ � '�����������' ��������"
	desc = "business hair"
	icon_state = "hair_business4"

/////////////////////////////
// Facial Hair Definitions //
/////////////////////////////
/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix w/ beards :P)

/datum/sprite_accessory/facial_hair/shaved
	name = "Britiy"
	desc_ru = "������ ������ ����"
	desc = "shaved face"
	icon_state = "bald"
	gender = NEUTER

/datum/sprite_accessory/facial_hair/hogan
	name = "Kozatskie usi"
	desc_ru = "�� ������� ���"
	desc = "long moustache"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/vandyke
	name = "Usiki s kozlinoy borodkoy"
	desc_ru = "�� ����� � ��������"
	desc = "moustache with a goatee"
	icon_state = "facial_vandyke"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Mamin Hitler"
	desc_ru = "�� ��������� �����"
	desc = "small moustache"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hair/selleck
	name = "Batini usi"
	desc_ru = "�� ���"
	desc = "moustache"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Boroda bez usov"
	desc_ru = "�� �������"
	desc = "neckbeard"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Boroda obyknovennaya"
	desc_ru = "�� ������"
	desc = "beard"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Boroda gustaya"
	desc_ru = "�� ������ ������"
	desc = "long beard"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/vlongbeard
	name = "Boroda otshelnika"
	desc_ru = "�� �������� ������"
	desc = "unkempt beard"
	icon_state = "facial_wise"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Porosl pod podborodkom"
	desc_ru = "�� ������� ��� �����������"
	desc = "chinstrap"
	icon_state = "facial_chin"

/datum/sprite_accessory/facial_hair/hip
	name = "Borodka i baki"
	desc_ru = "�� ������� � ������"
	desc = "goatee with the sideburns"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/gt
	name = "Boroda korotkaya"
	desc_ru = "�� ��������� ������"
	desc = "small beard"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/jensen
	name = "Shetina staraya"
	desc_ru = "�� ������� ������"
	desc = "unshaved face"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/fiveoclock
	name = "Shetina legkaya"
	desc_ru = "�� �������� ������"
	desc = "unshaved face"
	icon_state = "facial_fiveoclock"

/datum/sprite_accessory/facial_hair/fu
	name = "Kozatskie usi shirokie"
	desc_ru = "�� ������� �����"
	desc = "long moustache"
	icon_state = "facial_fumanchu"

///////////////////////////
// Underwear Definitions //
///////////////////////////
/datum/sprite_accessory/underwear
	icon = 'icons/mob/underwear.dmi'

/datum/sprite_accessory/underwear/nude
	name = "Nude"
	icon_state = "nude"
	gender = NEUTER

/datum/sprite_accessory/underwear/male_grey
	name = "Mens Grey"
	icon_state = "male_grey"
	gender = MALE

/datum/sprite_accessory/underwear/male_black
	name = "Mens Black"
	icon_state = "male_black"
	gender = MALE

/*/datum/sprite_accessory/underwear/male_hearts
	name = "Mens Hearts Boxer"
	icon_state = "male_hearts"
	gender = MALE

/datum/sprite_accessory/underwear/male_blackalt
	name = "Mens Black Boxer"
	icon_state = "male_blackalt"
	gender = MALE

/datum/sprite_accessory/underwear/male_greyalt
	name = "Mens Grey Boxer"
	icon_state = "male_greyalt"
	gender = MALE

/datum/sprite_accessory/underwear/male_stripe
	name = "Mens Striped Boxer"
	icon_state = "male_stripe"
	gender = MALE

/datum/sprite_accessory/underwear/male_commie
	name = "Mens Striped Commie Boxer"
	icon_state = "male_commie"
	gender = MALE

/datum/sprite_accessory/underwear/male_uk
	name = "Mens Striped UK Boxer"
	icon_state = "male_uk"
	gender = MALE

/datum/sprite_accessory/underwear/male_usastripe
	name = "Mens Striped Freedom Boxer"
	icon_state = "male_assblastusa"
	gender = MALE

/datum/sprite_accessory/underwear/female_black
	name = "Ladies Black"
	icon_state = "female_black"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_blackalt
	name = "Ladies Black Sport"
	icon_state = "female_blackalt"
	gender = FEMALE*/

////////////////////////////
// Undershirt Definitions //
////////////////////////////
/datum/sprite_accessory/undershirt
	icon = 'icons/mob/underwear.dmi'

/datum/sprite_accessory/undershirt/nude
	name = "Nude"
	icon_state = "nude"
	gender = NEUTER

///////////////////////
// Socks Definitions //
///////////////////////
/datum/sprite_accessory/socks
	icon = 'icons/mob/underwear.dmi'

/datum/sprite_accessory/socks/nude
	name = "Nude"
	icon_state = "nude"


///////////////////////////////////////////////////
//����� �����/�����//
//////////////////////////////////////////////////

/proc/init_hair_color_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()

	for(var/path in typesof(prototype))
		if(path == prototype)
			continue
		var/datum/hair_color/D = new path()

		L[D.name] = D

	return L

/proc/init_hair_color_subtypes_normal(prototype, list/L)
	if(!istype(L))
		L = list()

	for(var/path in typesof(prototype))
		if(path == prototype)
			continue
		var/datum/hair_color/D = new path()

		if(!D.donate)
			L[D.name] = D
		else del D

	return L

/proc/init_hair_color_subtypes_donate(prototype, list/L)
	if(!istype(L))
		L = list()

	for(var/path in typesof(prototype))
		if(path == prototype)
			continue
		var/datum/hair_color/D = new path()

		if(D.donate)
			L[D.name] = D
		else del D

	return L

/datum/hair_color
	var/desc_ru = "����"
	var/desc = "black "
	var/name = "white"			//�������� �����
	var/color = "#ffffff"		//���� � HEX
	var/donate = 0

/datum/hair_color/black1
	name = "Black, type 1"
	desc_ru = "����"
	desc = "black "
	color = "#111111"

/datum/hair_color/black2
	name = "Black, type 2"
	desc_ru = "����"
	desc = "black "
	color = "#222222"

/datum/hair_color/blond1
	name = "Blond, type 1"
	desc_ru = "�����"
	desc = "blond "
	color = "#ffcc66"

/datum/hair_color/blond2
	name = "Blond, type 2"
	desc_ru = "�����"
	desc = "blond "
	color = "#ffcc99"

/datum/hair_color/brown1
	name = "Brown, type 1"
	desc_ru = "����"
	desc = "dark "
	color = "#996633"

/datum/hair_color/brown2
	name = "Brown, type 2"
	desc_ru = "����"
	desc = "dark "
	color = "#663300"

/datum/hair_color/grey1
	name = "Grey, type 1"
	desc_ru = "�������"
	desc = "grey "
	color = "#777777"

/datum/hair_color/grey2
	name = "Grey, type 2"
	desc_ru = "�������"
	desc = "grey "
	color = "#999999"

/datum/hair_color/redpetuh
	name = "Red cock"
	desc_ru = "��������-���������"
	desc = "toxic-red "
	color = "#aa0000"
	donate = 1

/datum/hair_color/bluefag
	name = "Blue nose"
	desc_ru = "��������-�������"
	desc = "toxic-blue "
	color = "#0000aa"
	donate = 1

/datum/hair_color/purplefrog
	name = "Purple frog"
	desc_ru = "��������-��������"
	desc = "toxic-purple "
	color = "#aa00aa"
	donate = 1