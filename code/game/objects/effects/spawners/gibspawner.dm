/obj/effect/gibspawner

/obj/effect/gibspawner/generic
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(0,0,1)

/obj/effect/gibspawner/generic/New()
	playsound(src, 'sound/effects/blobattack.ogg', 40, 1, channel = "regular", time = 10)
	gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH),list(EAST, NORTHEAST, SOUTHEAST, SOUTH), list())
	..()

/obj/effect/gibspawner/human
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/up,/obj/effect/decal/cleanable/blood/gibs/down,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs/body,/obj/effect/decal/cleanable/blood/gibs/limb,/obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(0,0,1,0,1,0,1)

/obj/effect/gibspawner/human/New()
	playsound(src, 'sound/effects/blobattack.ogg', 50, 1, channel = "regular", time = 10)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	gibamounts[6] = pick(0,1,2)
	..()

/obj/effect/gibspawner/robot
	sparks = 1
	gibtypes = list(/obj/effect/decal/cleanable/robot_debris/up,/obj/effect/decal/cleanable/robot_debris/down,/obj/effect/decal/cleanable/robot_debris,/obj/effect/decal/cleanable/robot_debris,/obj/effect/decal/cleanable/robot_debris,/obj/effect/decal/cleanable/robot_debris/limb)
	gibamounts = list(1,1,1,1,1,1)

/obj/effect/gibspawner/robot/New()
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs)
	gibamounts[6] = pick(0,1,2)
	..()