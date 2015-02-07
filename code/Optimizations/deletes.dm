var/global/list/deletes = list()

/datum/Del()
	deletes["[src.type]"]++
	..()

/client/proc/check_deletes()
	set category = "Debug"
	set name = "Check Deletes"
	if(!check_rights(R_DEBUG)) return
	for(var/d in deletes)
		usr << "[d] deletecd [deletes[d]] time(s)"