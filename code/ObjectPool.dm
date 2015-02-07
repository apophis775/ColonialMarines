//Thanks Ter13

var
	list/object_pools = list()

proc
	unpool(var/pool,var/type=null)
		var/list/l = object_pools[pool]
		if(!l)
			if(!type)
				return null
			l = createPool(pool,type)
		if(l.len==1)
			var/v = l[1]
			return new v()
		var/atom/movable/a = l[2]
		l.Remove(a)
		a.unpooled(pool)
		return a

	createPool(var/pool,var/type)
		if(!object_pools[pool])
			object_pools[pool] = list(type)
		return object_pools[pool]

	pool(var/pool,var/datum/object)
		if(!object_pools[pool])
			createPool(pool,object.type)
		object_pools[pool] += object
		object.pooled(pool)

datum
	proc
		pooled(var/poolname)
			var/datum/D = src
			if(!D)
				var/atom/movable/M = src
				if(M)
					M.loc = null
		unpooled(var/poolname)