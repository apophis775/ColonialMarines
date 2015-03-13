//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//TODO: Make these simple_animals

var/const/MIN_IMPREGNATION_TIME = 300 //time it takes to impregnate someone
var/const/MAX_IMPREGNATION_TIME = 500

var/const/MIN_ACTIVE_TIME = 150 //time between being dropped and going idle
var/const/MAX_ACTIVE_TIME = 250

/obj/item/clothing/mask/facehugger
	name = "alien"
	desc = "It has some sort of a tube at the end of its tail."
	icon = 'icons/mob/alien.dmi'
	icon_state = "facehugger"
	item_state = "facehugger"
	w_class = 1 //note: can be picked up by aliens unlike most other items of w_class below 4
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKCOVERSEYES | MASKINTERNALS
	throw_range = 1
	health = 5
	layer = 4
	var/stat = CONSCIOUS //UNCONSCIOUS is the idle state in this case
	var/sterile = 0
	var/strength = 5
	var/attached = 0
	var/TARGETTIME = 0.5 // seconds
	var/WALKSPEED = 2 // tenths of seconds
	var/nextwalk = 0
	var/mob/living/carbon/human/target = null

/obj/item/clothing/mask/facehugger/Del()
	processing_objects.Remove(src)
	..()

/obj/item/clothing/mask/facehugger/process()
	healthcheck()


// HUGGER MOVEMENT AI
/obj/item/clothing/mask/facehugger/proc/targetting()
	spawn while(1)
		if(stat == DEAD || stat == UNCONSCIOUS)
			walk(src,0)
			return
		if(attached == 0 && stat != DEAD && stat != UNCONSCIOUS)
			if(target == null || target.stat == DEAD || target.stat == UNCONSCIOUS)
				findtarget()
			else
				followtarget()

		sleep(TARGETTIME * 10)


/obj/item/clothing/mask/facehugger/proc/findtarget()
	for(var/mob/living/carbon/human/T in hearers(src,4))
		if(!CanHug(T))
			continue
		if(T && (T.stat != DEAD && T.stat != UNCONSCIOUS) )

			if(get_dist(src.loc, T.loc) <= 4)
				target = T
/obj/item/clothing/mask/facehugger/proc/followtarget()
	if(attached == 0 && stat != DEAD && stat != UNCONSCIOUS && stat == 0 && nextwalk <= world.time)
		nextwalk = world.time + WALKSPEED
		var/dist = get_dist(src.loc, target.loc)
		var/obj/item/clothing/head/head = target.head
		if(head && istype(head, /obj/item/clothing/mask/facehugger))
			findtarget()
			return
		if(target == null || target.stat == DEAD || target.stat == UNCONSCIOUS || dist > 4 || target.status_flags & XENO_HOST)
			findtarget()
			return
		else
			step_towards(src, target, 0)
			if(dist <= 1)
				if(CanHug(target))
					Attach(target)
					return
				else
					target = null
					walk(src,0)
					findtarget()
					return

//END HUGGER MOVEMENT AI


/obj/item/clothing/mask/facehugger/attack_paw(user as mob) //can be picked up by aliens
	if(isalien(user))
		attack_hand(user)
		return
	else
		..()
		return

/obj/item/clothing/mask/facehugger/attack_hand(user as mob)
	if((stat == CONSCIOUS && !sterile) && !isalien(user))
		Attach(user)
		return
	else
		var/mob/living/carbon/alien/humanoid/carrier/carr = user

		if(carr && istype(carr, /mob/living/carbon/alien/humanoid/carrier))
			if(carr.facehuggers >= 6)
				carr << "You can't hold anymore facehuggers. You pick it up"
				..()
				return
			if(stat != DEAD)
				carr << "You pick up a facehugger"
				carr.facehuggers += 1
				del(src)

			else
				user << "This facehugger is dead."
				..()
		else
			..()
		return

/obj/item/clothing/mask/facehugger/proc/healthcheck()
	if(health <= 0)
		icon_state = "[initial(icon_state)]_dead"
		Die()

/obj/item/clothing/mask/facehugger/attack(mob/living/M as mob, mob/user as mob)
	..()
	user.drop_from_inventory(src)
	Attach(M)

/obj/item/clothing/mask/facehugger/New()
	if(aliens_allowed)
		..()
		processing_objects.Add(src)
//		targetting()
	else
		del(src)

/obj/item/clothing/mask/facehugger/examine()
	..()
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			usr << "\red \b [src] is not moving."
		if(CONSCIOUS)
			usr << "\red \b [src] seems to be active."
	if (sterile)
		usr << "\red \b It looks like the proboscis has been removed."
	return

/obj/item/clothing/mask/facehugger/attackby()
	Die()
	return

/obj/item/clothing/mask/facehugger/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	return

/obj/item/clothing/mask/facehugger/ex_act(severity)
	Die()
	return

/obj/item/clothing/mask/facehugger/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		Die()
	return

/obj/item/clothing/mask/facehugger/equipped(mob/M)
	Attach(M)

/obj/item/clothing/mask/facehugger/HasEntered(atom/target)
	HasProximity(target)
	return

/obj/item/clothing/mask/facehugger/on_found(mob/finder as mob)
	if(stat == CONSCIOUS)
		HasProximity(finder)
		return 1
	return

/obj/item/clothing/mask/facehugger/HasProximity(atom/movable/AM as mob|obj)
	if(CanHug(AM))
		Attach(AM)

/obj/item/clothing/mask/facehugger/throw_at(atom/target, range, speed)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		spawn(15)
			if(icon_state == "[initial(icon_state)]_thrown")
				icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/facehugger/throw_impact(atom/hit_atom)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		Attach(hit_atom)

/obj/item/clothing/mask/facehugger/proc/Attach(mob/living/M as mob)
	var/preggers = rand(MIN_IMPREGNATION_TIME,MAX_IMPREGNATION_TIME)
	if( (!iscorgi(M) && !iscarbon(M)) || isalien(M))
		return
	if(iscarbon(M) && M.status_flags & XENO_HOST)
		visible_message("\red An alien tries to place a Facehugger on [M] but it refuses sloppy seconds!")
		return
	if(attached)
		return
	else
		attached++
		spawn(MAX_IMPREGNATION_TIME)
			attached = 0

	var/mob/living/L = M //just so I don't need to use :

	if(loc == L) return
	if(stat != CONSCIOUS)	return
	if(!sterile) L.take_organ_damage(strength,0) //done here so that even borgs and humans in helmets take damage

	L.visible_message("\red \b [src] leaps at [L]'s face!")

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/clothing/head/head = H.head
		if(head && head.flags & HEADCOVERSMOUTH)
			if(head.health <= 10)
				H.visible_message("\red \b [src] smashes against [H]'s [head], and rips it off in the process!")
				H.drop_from_inventory(head)
			else
				H.visible_message("\red \b [src] smashes against [H]'s [head], and fails to rip it off!")
			if(prob(75))
				Die()
			else
				H.visible_message("\red [src] bounces off of the [head]!")
				GoIdle(15)
			if(hascall(head, "take_damage"))
				head.take_damage(5)

			return

	if(iscarbon(M))
		var/mob/living/carbon/target = L

		if(target.wear_mask)
			if(prob(20))	return
			var/obj/item/clothing/mask/facehugger/F
			var/obj/item/clothing/W = target.wear_mask
			if(!W.canremove)	return
			if(!W == F)	return
			target.drop_from_inventory(W)

			target.visible_message("\red \b [src] tears [W] off of [target]'s face!")

		target.equip_to_slot(src, slot_wear_mask)

		if(!sterile) L.Sleeping((preggers/10)+10) //something like 25 ticks = 20 seconds with the default settings
	else if (iscorgi(M))
		var/mob/living/simple_animal/corgi/C = M
		src.loc = C
		C.facehugger = src
		C.wear_mask = src
		//C.regenerate_icons()

	GoIdle(150) //so it doesn't jump the people that tear it off

	spawn(preggers)
		Impregnate(L)

	return

/obj/item/clothing/mask/facehugger/proc/Impregnate(mob/living/target as mob)
	if(!target || target.wear_mask != src || target.stat == DEAD) //was taken off or something
		return

	if(!sterile)
		//target.contract_disease(new /datum/disease/alien_embryo(0)) //so infection chance is same as virus infection chance
		var/obj/item/alien_embryo/E = new (target)
		target.status_flags |= XENO_HOST
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/T = target
			var/datum/organ/external/chest/affected = T.get_organ("chest")
			affected.implants += E
		target.visible_message("\red \b [src] falls limp after violating [target]'s face!")

		Die()
		icon_state = "[initial(icon_state)]_impregnated"

		//if(iscorgi(target))
		//	var/mob/living/simple_animal/corgi/C = target
		//	src.loc = get_turf(C)
		//	C.facehugger = null
	else
		target.visible_message("\red \b [src] violates [target]'s face!")
	return

/obj/item/clothing/mask/facehugger/proc/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return

	stat = CONSCIOUS
	icon_state = "[initial(icon_state)]"

/*		for(var/mob/living/carbon/alien/alien in world)
		var/image/activeIndicator = image('icons/mob/alien.dmi', loc = src, icon_state = "facehugger_active")
		activeIndicator.override = 1
		if(alien && alien.client)
			alien.client.images += activeIndicator	*/

	return

/obj/item/clothing/mask/facehugger/proc/GoIdle(var/delay)
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

/*		RemoveActiveIndicators()	*/
	target = null
	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	spawn(delay)
		GoActive()
	return

/obj/item/clothing/mask/facehugger/proc/Die()
	if(stat == DEAD)
		return
	target = null
/*		RemoveActiveIndicators()	*/
	processing_objects.Remove(src)
	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	src.visible_message("\red \b[src] curls up into a ball!")

	return

/proc/CanHug(var/mob/M)

	if(iscorgi(M))
		return 1

	if(!iscarbon(M) || isalien(M))
		return 0
	var/mob/living/carbon/human/H = M
	if(H && (istype(H.wear_mask, /obj/item/clothing/mask/facehugger) || H.status_flags & XENO_HOST))
		return 0
	//var/mob/living/carbon/C = M
	//if(ishuman(C))
		//var/mob/living/carbon/human/H = C
		//if(H.head && H.head.flags & HEADCOVERSMOUTH)
			//return 0
	return 1
