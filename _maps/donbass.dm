#if !defined(MAP_FILE)

        #include "map_files\Stalker\donba$$.dmm"

        #define MAP_FILE "donba$$.dmm"
        #define MAP_NAME "Donbass"
		#define MAP_TRANSITION_CONFIG list(MAIN_STATION = CROSSLINKED, CENTCOMM = SELFLOOPING)
#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring donba$$.dmm.

#endif