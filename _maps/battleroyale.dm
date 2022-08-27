#if !defined(MAP_FILE)

        #include "map_files\Stalker\Zona\battleroyale.dmm"

        #define MAP_FILE "battleroyale.dmm"
        #define MAP_NAME "Donbass Hero"
		#define MAP_TRANSITION_CONFIG list(MAIN_STATION = CROSSLINKED, CENTCOMM = SELFLOOPING)
#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring battleroyale.dmm.

#endif