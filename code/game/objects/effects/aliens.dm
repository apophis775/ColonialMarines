/* Alien shit!
 * Contains:
 *		structure/alien
 *		Resin
 *		Weeds
 *		Egg
 *		effect/acid
 */

#define WEED_NORTH_EDGING "north"
#define WEED_SOUTH_EDGING "south"
#define WEED_EAST_EDGING "east"
#define WEED_WEST_EDGING "west"

/obj/effect/alien
	icon = 'icons/Xeno/Effects.dmi'

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of thick resin."
	icon_state = "resin"
	density = 1
	opacity = 1
	anchored = 1
	var/health = 160
	var/resintype = null
/obj/effect/alien/resin/New(location)
	relativewall_neighbours()

	..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	return

/obj/effect/alien/resin/Del()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	T.relativewall_neighbours()
	..()


/obj/effect/alien/resin/wall
	name = "resin wall"
	desc = "Thick resin solidified into a wall."
	icon_state = "wall0"	//same as resin, but consistency ho!
	resintype = "wall"

/obj/effect/alien/resin/wall/New()
	relativewall_neighbours()
	..()


/obj/effect/alien/resin/wall/shadowling //For chrysalis
	name = "chrysalis wall"
	desc = "Some sort of purple substance in an egglike shape. It pulses and throbs from within and seems impenetrable."
	health = INFINITY

/obj/effect/alien/resin/membrane
	name = "resin membrane"
	desc = "Resin just thin enough to let light pass through."
	icon_state = "membrane0"
	opacity = 0
	health = 80
	resintype = "membrane"

/obj/effect/alien/resin/membrane/New()
	relativewall_neighbours()
	..()

/obj/effect/alien/resin/proc/healthcheck()
	if(health <=0)
		del(src)


/obj/effect/alien/resin/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()


/obj/effect/alien/resin/ex_act(severity, target)
	switch(severity)
		if(1.0)
			health -= 150
		if(2.0)
			health -= 100
		if(3.0)
			health -= 50
	healthcheck()


/obj/effect/alien/resin/blob_act()
	health -= 50
	healthcheck()


/obj/effect/alien/resin/hitby(atom/movable/AM)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(!isobj(AM))
		tforce = 10
	else
		var/obj/O = AM
		tforce = O.throwforce
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health -= tforce
	healthcheck()


/obj/effect/alien/resin/attack_paw(mob/user)
	return attack_hand(user)


/obj/effect/alien/resin/attack_alien()
	if (islarva(usr))//Safety check for larva. /N
		return
	usr << "\green You claw at the [name]."
	for(var/mob/O in oviewers(src))
		O.show_message("\red [usr] claws at the resin!", 1)
	playsound(loc, 'sound/effects/attackblob.ogg', 30, 1, -4)
	health -= rand(40, 60)
	if(health <= 0)
		usr << "\green You slice the [name] to pieces."
		for(var/mob/O in oviewers(src))
			O.show_message("\red [usr] slices the [name] apart!", 1)
	healthcheck()
	return


/obj/effect/alien/resin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 30, 1, -4)
	healthcheck()
	..()
	return


/obj/effect/alien/resin/CanPass(atom/movable/mover, turf/target, height=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density


/*
 * Weeds
 */

#define NODERANGE 3

/obj/effect/alien/weeds
	gender = PLURAL
	name = "resin floor"
	desc = "A thick resin surface covers the floor."
	icon_state = "weeds"
	anchored = 1
	density = 0
	layer = 2.02
	var/health = 25
	var/lifetick = 0
	var/obj/effect/alien/weeds/node/linked_node = null
	var/static/list/weedImageCache


/obj/effect/alien/weeds/New(pos, node)
	..()
	linked_node = node
	if(istype(loc, /turf/space))
		del(src)
		return
	if(icon_state == "weeds")
		icon_state = pick("weeds", "weeds1", "weeds2")

	fullUpdateWeedOverlays()
	spawn(rand(150, 200))
		if(src)
			Life()

/obj/effect/alien/weeds/Del()
	var/turf/T = loc
	loc = null
	for (var/obj/effect/alien/weeds/W in range(1,T))
		W.updateWeedOverlays()
	linked_node = null
	..()

/obj/effect/alien/weeds/proc/Life()
	var/turf/U = get_turf(src)

	if(istype(U, /turf/space))
		del(src)
		return

	direction_loop:
		for(var/dirn in cardinal)
			var/turf/T = get_step(src, dirn)

			if (!istype(T) || T.density || locate(/obj/effect/alien/weeds) in T || istype(T, /turf/space))
				continue

			if(!linked_node || get_dist(linked_node, src) > linked_node.node_range)
				return

			for(var/obj/O in T)
				if(O.density)
					continue direction_loop

			new /obj/effect/alien/weeds(T, linked_node)


/obj/effect/alien/weeds/ex_act(severity, target)
	del(src)


/obj/effect/alien/weeds/attackby(var/obj/item/weapon/W, var/mob/user)
	if(W.attack_verb.len)
		visible_message("\red <B>\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]")
	else
		visible_message("\red <B>\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	deathcheck()


/obj/effect/alien/weeds/proc/healthcheck()
	while(1)
		if(istype(src, /obj/effect/alien/weeds/node))
			return
		sleep(3)
		lifetick++
		if(lifetick >= 75)
			lifetick = 0
			health--
			deathcheck()

/obj/effect/alien/weeds/proc/deathcheck()
	if(health <= 0)
		del(src)

/obj/effect/alien/weeds/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()


/obj/effect/alien/weeds/proc/updateWeedOverlays()

	overlays.Cut()

	if(!weedImageCache || !weedImageCache.len)
		weedImageCache = list()
		weedImageCache.len = 4
		weedImageCache[WEED_NORTH_EDGING] = image('icons/Xeno/Effects.dmi', "weeds_side_n", layer=2.01, pixel_y = -32)
		weedImageCache[WEED_SOUTH_EDGING] = image('icons/Xeno/Effects.dmi', "weeds_side_s", layer=2.01, pixel_y = 32)
		weedImageCache[WEED_EAST_EDGING] = image('icons/Xeno/Effects.dmi', "weeds_side_e", layer=2.01, pixel_x = -32)
		weedImageCache[WEED_WEST_EDGING] = image('icons/Xeno/Effects.dmi', "weeds_side_w", layer=2.01, pixel_x = 32)

	var/turf/N = get_step(src, NORTH)
	var/turf/S = get_step(src, SOUTH)
	var/turf/E = get_step(src, EAST)
	var/turf/W = get_step(src, WEST)
	if(!locate(/obj/effect/alien) in N.contents)
		if(istype(N, /turf/simulated/floor))
			overlays += weedImageCache[WEED_SOUTH_EDGING]
	if(!locate(/obj/effect/alien) in S.contents)
		if(istype(S, /turf/simulated/floor))
			overlays += weedImageCache[WEED_NORTH_EDGING]
	if(!locate(/obj/effect/alien) in E.contents)
		if(istype(E, /turf/simulated/floor))
			overlays += weedImageCache[WEED_WEST_EDGING]
	if(!locate(/obj/effect/alien) in W.contents)
		if(istype(W, /turf/simulated/floor))
			overlays += weedImageCache[WEED_EAST_EDGING]


/obj/effect/alien/weeds/proc/fullUpdateWeedOverlays()
	for (var/obj/effect/alien/weeds/W in range(1,src))
		W.updateWeedOverlays()

//Weed nodes
/obj/effect/alien/weeds/node
	name = "glowing resin"
	desc = "Blue bioluminescence shines from beneath the surface."
	icon_state = "weednode"
	luminosity = 1
	var/node_range = NODERANGE


/obj/effect/alien/weeds/node/New()
	..(loc, src)

#undef NODERANGE


/*
 * Egg
 */

//for the status var
#define BURST 0
#define BURSTING 1
#define GROWING 2
#define GROWN 3
#define MIN_GROWTH_TIME 1800	//time it takes to grow a hugger
#define MAX_GROWTH_TIME 3000

/obj/effect/alien/egg
	name = "egg"
	desc = "A large mottled egg."
	icon_state = "egg_growing"
	density = 0
	anchored = 1
	var/health = 100
	var/status = GROWING	//can be GROWING, GROWN or BURST; all mutually exclusive


/obj/effect/alien/egg/New()
	new /obj/item/clothing/mask/facehugger(src)
	..()
	spawn(rand(MIN_GROWTH_TIME, MAX_GROWTH_TIME))
		Grow()

/obj/effect/alien/egg/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/egg/attack_paw(mob/user)
	if(isalien(user))
		switch(status)
			if(BURST)
				user << "<span class='notice'>You clear the hatched egg.</span>"
				playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
				del(src)
				return
			if(GROWING)
				user << "<span class='notice'>The child is not developed yet.</span>"
				return
			if(GROWN)
				user << "<span class='notice'>You retrieve the child.</span>"
				Burst(0)
				return
	else
		return attack_hand(user)


/obj/effect/alien/egg/attack_hand(mob/user)
	user << "<span class='notice'>It feels slimy.</span>"


/obj/effect/alien/egg/proc/GetFacehugger()
	return locate(/obj/item/clothing/mask/facehugger) in contents


/obj/effect/alien/egg/proc/Grow()
	icon_state = "egg"
	status = GROWN


/obj/effect/alien/egg/proc/Burst(var/kill = 1)	//drops and kills the hugger if any is remaining
	if(status == GROWN || status == GROWING)
		icon_state = "egg_hatched"
		flick("egg_opening", src)
		status = BURSTING
		spawn(15)
			status = BURST
			var/obj/item/clothing/mask/facehugger/child = GetFacehugger()
			if(child)
				child.loc = get_turf(src)
				if(kill && istype(child))
					child.Die()
				else
					for(var/mob/M in range(1,src))
						if(CanHug(M))
							child.Attach(M)
							break



/obj/effect/alien/egg/attackby(var/obj/item/weapon/W, var/mob/user)
	if(health <= 0)
		return
	if(W.attack_verb.len)
		src.visible_message("\red <B>\The [src] has been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]")
	else
		src.visible_message("\red <B>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]")
	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

	src.health -= damage
	src.healthcheck()


/obj/effect/alien/egg/proc/healthcheck()
	if(health <= 0)
		if(status != BURST && status != BURSTING)
			Burst()
		else if(status == BURST && prob(50))
			del(src)	//Remove the egg after it has been hit after bursting.


/obj/effect/alien/egg/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500)
		health -= 5
		healthcheck()


/obj/effect/alien/egg/HasProximity(atom/movable/AM)
	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.status_flags & XENO_HOST)
			return

		Burst(0)

#undef BURST
#undef BURSTING
#undef GROWING
#undef GROWN
#undef MIN_GROWTH_TIME
#undef MAX_GROWTH_TIME


/*
 * Acid
 */
/obj/effect/alien/acid
	gender = PLURAL
	name = "acid"
	desc = "Burbling corrossive stuff."
	icon = 'icons/Xeno/Effects.dmi'
	icon_state = "acid"
	density = 0
	opacity = 0
	anchored = 1
	unacidable = 1
	var/atom/target
	var/ticks = 0
	var/target_strength = 4

/obj/effect/alien/acid/weak
	target_strength = 8

/obj/effect/alien/acid/super
	target_strength = 16

/obj/effect/alien/acid/New(loc, targ)
	..(loc)
	target = targ

	//handle APCs and newscasters and stuff nicely
	pixel_x = target.pixel_x
	pixel_y = target.pixel_y

	if(isturf(target))	//Turfs take twice as long to take down.
		target_strength = target_strength*2
	tick()


/obj/effect/alien/acid/proc/tick()
	if(!target)
		del(src)

	ticks++

	if(ticks >= target_strength)
		target.visible_message("<span class='warning'>[target] collapses under its own weight into a puddle of goop and undigested debris!</span>")

		if(istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else
			del(target)

		del(src)
		return

	x = target.x
	y = target.y
	z = target.z
	if(target_strength == target_strength - ticks)
		visible_message("<span class='warning'>[target] is holding up against the acid!</span>")
	if((target_strength * 3) / 4  == target_strength - ticks)
		visible_message("<span class='warning'>[target] is being melted by the acid!</span>")
	if(target_strength / 2 == target_strength - ticks)
		visible_message("<span class='warning'>[target] is struggling to withstand the acid!</span>")
	if(target_strength / 4 == target_strength - ticks)
		visible_message("<span class='warning'>[target] begins to crumble under the acid!</span>")

	spawn(rand(125, 150))
		if(src)
			tick()

#undef WEED_NORTH_EDGING
#undef WEED_SOUTH_EDGING
#undef WEED_EAST_EDGING
#undef WEED_WEST_EDGING