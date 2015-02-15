/mob/living/carbon/alien/humanoid/corroder
	name = "alien corroder"
	caste = "Corroder"
	maxHealth = 100
	health = 100
	icon = 'icons/Xeno/2x2_Xenos.dmi'
	icon_state = "Corroder Walking"
	plasma_rate = 18
	heal_rate = 2
	storedPlasma = 80
	max_plasma = 150
	damagemin = 10
	damagemax = 15
	tacklemin = 3
	tacklemax = 6
	tackle_chance = 60 //Should not be above 100%
	var/SPITCOOLDOWN = 10
	var/usedspit = 0
	psychiccost = 32
/obj/item/projectile/energy/acid
	name = "acid"
	icon_state = "neurotoxin"
	damage = 0
	damage_type = TOX
	weaken = 0
	PROJECTILESPEED = 2
/obj/item/projectile/energy/acid/New()
	var/matrix/M = matrix()
	M.Scale(2,2)
	src.transform = M
	..()



/obj/item/projectile/energy/acid/on_hit(var/atom/target, var/blocked = 0)
	var/atom/L = target
	new /obj/effect/alien/superacid2(get_turf(L), L)

/obj/item/projectile/energy/acid/Bump(atom/A as mob|obj|turf|area)
	if(A == firer)
		loc = A.loc
		return 0 //cannot shoot yourself

	if(bumped)	return 0

	bumped = 1
	if(A)
		on_hit(A)
		density = 0
		invisibility = 101
		del(src)
	return 1


/obj/effect/alien/superacid2
	name = "super acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1

	var/atom/target
	var/mob/living/carbon/human/attached
	var/ticks = 0
	var/target_strength = 0
	var/onskin = 0
	layer = 4
	color = "#CCCCCC"
	alpha = 175

/obj/effect/alien/superacid2/New(loc, target)
	..(loc)

	src.target = target

	if(istype(target, /turf/unsimulated))
		del(src)
	if(istype(target, /turf/simulated/shuttle))
		del(src)
	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 2
	else
		target_strength = 2

	var/matrix/M = matrix()
	M.Scale(0.85,0.85)
	src.transform = M
	if(istype(target, /mob/living/carbon/human))
		attached = target
		attached.contents += src
		attached.overlays += src
		humantick()

	else
		if(istype(target, /mob/living/carbon/alien))
			var/mob/living/carbon/alien/al = target
			al.visible_message("[target] is hit by the acid, but shakes it off.")
			del(src)
			return
		var/obj/targ = target
		if(targ)
			if(targ.unacidable == 1)
				del(src)
				return
		tick()



/obj/effect/alien/superacid2/proc/tick()
	if(!target)
		del(src)
	if(istype(target, /obj/item/clothing))
		target_strength = 4
	ticks += 1

	if(!attached)
		var/matrix/M = matrix()
		M.Scale(1.2,1.2)
		src.transform = M

	if(ticks >= target_strength)

		for(var/mob/O in hearers(target.loc, null))
			O.show_message("\green <B>[src.target] dissolves into a puddle of goop and sizzles!</B>", 1)

		if(istype(target, /turf/simulated/wall)) // I hate turf code.
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
			del(src)
			return


		if(attached && target.loc == attached)
			attached.drop_from_inventory(target)
			del(target)
			src.target = attached
			ticks = 0
			spawn(0) humantick()
			return

		else
			if(target.loc == attached)
				attached.drop_from_inventory(target)
			del(target)
			del(src)
		return

	switch(target_strength - ticks)
		if(5)
			visible_message("\green <B>[src.target] is holding up against the acid!</B>")
		if(3)
			visible_message("\green <B>[src.target]\s structure is being melted by the acid!</B>")
		if(2)
			visible_message("\green <B>[src.target] is struggling to withstand the acid!</B>")
		if(0 to 1)
			visible_message("\green <B>[src.target] begins to dissolve from the acid!</B>")
	spawn(rand(50,75)) tick()

/obj/effect/alien/superacid2/proc/humantick()
	if(!target || attached.stat == DEAD)
		del(src)
	var/mob/living/carbon/human/H = attached
	if(!H)
		del(src)


	if(src.onskin == 1)
		if(prob(70))
			H.visible_message("\green <B>[H]'s flesh is being seared by the acid!</B>")

		if(prob(40))
			H.Stun(2)
			H.Weaken(2)
			H.emote("me", message="screams in agony!")
			if(prob(35))
				spawn(rand(10,25)) H.emote("scream")
		H.adjustFireLoss(rand(40,60))
		spawn(rand(30,50)) humantick()
		return

	if(H.wear_suit)
		attached = H
		target = H.wear_suit
		target.overlays += src
		H.visible_message("\red <B>[target] begins to melt from the acid.</B>")
		spawn(0) tick()
		return
	if(H.w_uniform)
		target = H.w_uniform
		target.overlays += src
		H.visible_message("\red <B>[target] begins to melt from the acid.</B>")
		spawn(0) tick()
		return
	else if(!H.wear_suit && !H.w_uniform)
		src.onskin = 1
		H.visible_message("\red <B>[H] begins to be dissolved from the acid.</B>")
		if(prob(80))
			H.emote("scream")

	spawn(rand(50,75)) humantick()




/mob/living/carbon/alien/humanoid/corroder/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	if(src.name == "alien corroder")
		src.name = text("alien corroder ([rand(1, 1000)])")
	src.real_name = src.name
	verbs -= /mob/living/carbon/alien/verb/ventcrawl
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/resin)
	pixel_y = -7
	pixel_x = -16
	verbs -= /atom/movable/verb/pull

	var/matrix/M = matrix()
	M.Scale(0.85,0.85)
	src.transform = M
	..()
/mob/living/carbon/alien/humanoid/corroder/verb/spit_acid(var/atom/T)

	set name = "Spit Acid (75)"
	set desc = "Spit highly corrosive acid."
	set category = "Alien"
	if(powerc(75))
		if(usedspit <= world.time)
			if(!T)
				var/list/victims = list()
				for(var/mob/living/carbon/human/C in oview(7))
					victims += C
				T = input(src, "Who should we spit acid at?") as null|anything in victims

			if(T)
				usedspit = world.time + SPITCOOLDOWN * 15

				src << "We spit at [T]"
				visible_message("\red <B>[src] spits at [T]!</B>")

				var/turf/curloc = src.loc
				var/atom/targloc
				if(!istype(T, /turf/))
					targloc = get_turf(T)
				else
					targloc = T
				if (!targloc || !istype(targloc, /turf) || !curloc)
					return
				if (targloc == curloc)
					return
				var/obj/item/projectile/energy/acid/A = new /obj/item/projectile/energy/acid(src.loc)
				A.current = curloc
				A.yo = targloc.y - curloc.y
				A.xo = targloc.x - curloc.x
				adjustToxLoss(-75)
				A.process()

			else
				src << "\blue You cannot spit at nothing!"
		else
			src << "\red You need to wait before spitting!"
	else
		src << "\red You need more plasma."





/mob/living/carbon/alien/humanoid/corroder/ClickOn(var/atom/A, params)

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		spit_acid(A)

		return
	..()
