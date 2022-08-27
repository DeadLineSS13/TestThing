#if !defined(MAP_FILE)

		#include "map_files\Stalker\Zona\map.dmm"

		#define MAP_FILE "map.dmm"
		#define MAP_NAME "Zona"
		#define MAP_TRANSITION_CONFIG list(MAIN_STATION = CROSSLINKED, CENTCOMM = SELFLOOPING)
#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring map.dmm.

#endif