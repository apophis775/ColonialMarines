
var/list/deleteq = list()
/proc/deleteQueue()
	spawn while(1)
		if(deleteq.len > 0)
			var/atom/object = deleteq[1]
			deleteq.Remove(object)
			del object
		sleep(5)

/proc/addDeleteQueue(var/atom/object)
	deleteq += object
	object.loc = null