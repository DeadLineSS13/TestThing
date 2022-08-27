	//////////////
var/NEARSIGHTBLOCK = 0
var/EPILEPSYBLOCK = 0
var/COUGHBLOCK = 0
var/TOURETTESBLOCK = 0
var/NERVOUSBLOCK = 0
var/BLINDBLOCK = 0
var/DEAFBLOCK = 0
var/HULKBLOCK = 0
var/TELEBLOCK = 0
var/FIREBLOCK = 0
var/XRAYBLOCK = 0
var/CLUMSYBLOCK = 0
var/STRANGEBLOCK = 0
var/RACEBLOCK = 0

var/list/bad_se_blocks
var/list/good_se_blocks
var/list/op_se_blocks

var/NULLED_SE
var/NULLED_UI

GLOBAL_LIST_EMPTY(global_mutations) // list of hidden mutation things

GLOBAL_LIST_EMPTY(bad_mutations)
GLOBAL_LIST_EMPTY(good_mutations)
GLOBAL_LIST_EMPTY(not_good_mutations)