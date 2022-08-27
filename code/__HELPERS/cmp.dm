/proc/cmp_numeric_dsc(a,b)
	return b - a

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_text_asc(a,b)
	return sorttext(b,a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a,b)

/proc/cmp_name_asc(atom/a, atom/b)
	if(a && b)
		return sorttext(b.name, a.name)

/proc/cmp_real_name_dsc(mob/a, mob/b)
	if(a && b)
		return sorttext(a.real_name, b.real_name)

/proc/cmp_real_name_asc(mob/a, mob/b)
	if(a && b)
		return sorttext(b.real_name, a.real_name)

/proc/cmp_name_dsc(atom/a, atom/b)
	if(a && b)
		return sorttext(a.name, b.name)

/proc/cmp_price_dsc(datum/data/stalker_equipment/a,datum/data/stalker_equipment/b)
	return b.cost - a.cost

/proc/cmp_price_asc(datum/data/stalker_equipment/a,datum/data/stalker_equipment/b)
	return a.cost - b.cost

var/cmp_field = "name"

/proc/cmp_soundtracks_asc(datum/data/turntable_soundtrack/a, datum/data/turntable_soundtrack/b)
	return sorttext(b.f_name + b.name, a.f_name + a.name)

/proc/cmp_soundtracks_dsc(datum/data/turntable_soundtrack/a, datum/data/turntable_soundtrack/b)
	return sorttext(a.f_name + a.name, b.f_name + b.name)

/proc/cmp_records_asc(datum/data/record/a, datum/data/record/b)
	return sorttext(b.fields[cmp_field], a.fields[cmp_field])

/proc/cmp_records_dsc(datum/data/record/a, datum/data/record/b)
	return sorttext(a.fields[cmp_field], b.fields[cmp_field])

/proc/cmp_records_numeric_dsc(datum/data/record/a, datum/data/record/b)
	return b.fields[cmp_field] - a.fields[cmp_field]

/proc/cmp_records_numeric_asc(datum/data/record/a, datum/data/record/b)
	return a.fields[cmp_field] - b.fields[cmp_field]

/proc/cmp_ckey_asc(client/a, client/b)
	return sorttext(b.ckey, a.ckey)

/proc/cmp_ckey_dsc(client/a, client/b)
	return sorttext(a.ckey, b.ckey)
/*
/proc/cmp_subsystem_display(datum/subsystem/a, datum/subsystem/b)
	if(a.display == b.display)
		return sorttext(b.name, a.name)
	return a.display - b.display
*/

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return initial(b.init_order) - initial(a.init_order)	//uses initial() so it can be used on types

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun

/proc/cmp_qdel_item_time(datum/qdel_item/A, datum/qdel_item/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.qdels - A.qdels

/proc/cmp_generic_stat_item_time(list/A, list/B)
	. = B[STAT_ENTRY_TIME] - A[STAT_ENTRY_TIME]
	if (!.)
		. = B[STAT_ENTRY_COUNT] - A[STAT_ENTRY_COUNT]

/proc/cmp_profile_avg_time_dsc(list/A, list/B)
	return (B[PROFILE_ITEM_TIME]/(B[PROFILE_ITEM_COUNT] || 1)) - (A[PROFILE_ITEM_TIME]/(A[PROFILE_ITEM_COUNT] || 1))

/proc/cmp_profile_time_dsc(list/A, list/B)
	return B[PROFILE_ITEM_TIME] - A[PROFILE_ITEM_TIME]

/proc/cmp_profile_count_dsc(list/A, list/B)
	return B[PROFILE_ITEM_COUNT] - A[PROFILE_ITEM_COUNT]

/proc/cmp_atom_layer_asc(atom/A,atom/B)
	if(A.plane != B.plane)
		return A.plane - B.plane
	else
		return A.layer - B.layer
