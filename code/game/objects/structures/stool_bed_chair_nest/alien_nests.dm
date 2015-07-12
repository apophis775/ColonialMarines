//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.

/obj/structure/stool/bed/nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/Xeno/Effects.dmi'
	icon_state = "nest"
	var/health = 100
	var/resisting = 0
	var/buckletime = 0
	var/buckletimemax = 0


/obj/structure/stool/bed/nest/proc/process_unbuckle()
	spawn while(1)
		if(!istype(buckled_mob))
			resisting = 0
			buckletime = 0
			buckletimemax = 0
		if(istype(buckled_mob) && resisting)
			if(buckletimemax == 0)
				buckletimemax = world.timeofday + 1200
			buckletime += 50
			if(buckletime >= buckletimemax)
				if(buckled_mob)
					buckled_mob.pixel_y = 0
					buckled_mob.nested = null
					buckled_mob.visible_message(\
						"<span class='warning'><b>[buckled_mob.name] manages to break free of the gelatinous resin!</b></span>",\
						"<span class='warning'>You manage to break free from the gelatinous resin!</span>",\
						"<span class='notice'>You hear squelching...</span>")
					unbuckle()

		sleep(50)
/obj/structure/stool/bed/nest/New()
	process_unbuckle()
	score_resin_made++

/obj/structure/stool/bed/nest/unbuckle()
	..()
	resisting = 0
	buckletime = 0
	buckletimemax = 0

/obj/structure/stool/bed/nest/manual_unbuckle(mob/user as mob)
/*	if(buckled_mob == user)
		user << "\red You can not wriggle free this way."
		return*/
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"<span class='notice'>[user.name] pulls [buckled_mob.name] free from the sticky nest!</span>",\
					"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
					"<span class='notice'>You hear squelching...</span>")
				buckled_mob.pixel_y = 0
				buckled_mob.nested = null
				unbuckle()
			else
				if(resisting == 1)
					buckled_mob.visible_message(\
					"<span class='notice'>[user.name] tries to break free, and becomes more entangled...</span>",\
					"<span class='notice'>You were already trying to escape, and the more you struggle, the more you get entangled...</span>",\
					"<span class='notice'>You hear squelching...</span>")
					buckletimemax+=300
					return
				buckled_mob.visible_message(\
					"<span class='warning'>[buckled_mob.name] struggles to break free of the gelatinous resin...</span>",\
					"<span class='warning'>You struggle to break free from the gelatinous resin...</span>",\
					"<span class='notice'>You hear squelching...</span>")
				buckletime = world.timeofday
				resisting = 1

			src.add_fingerprint(user)
	return

/obj/structure/stool/bed/nest/buckle_mob(mob/M as mob, mob/user as mob)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || usr.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	if(istype(M,/mob/living/carbon/alien))
		return
	if(!istype(user,/mob/living/carbon/alien/humanoid))
		return

	unbuckle()

	if(M == usr)
		return
	if(!M.weakened && !M.sleeping)
		usr<<"\red They must be incapacitated first!"
		return
	else
		M.visible_message(\
			"<span class='notice'>[user.name] secretes a thick vile goo, securing [M.name] into [src]!</span>",\
			"<span class='warning'>[user.name] drenches you in a foul-smelling resin, trapping you in the [src]!</span>",\
			"<span class='notice'>You hear squelching...</span>")
	M.buckled = src
	M.nested = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	M.pixel_y = 6
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/obj/structure/stool/bed/nest/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	for(var/mob/M in viewers(src, 7))
		M.show_message("<span class='warning'>[user] hits [src] with [W]!</span>", 1)
	healthcheck()

/obj/structure/stool/bed/nest/attack_paw(mob/user as mob)
	if(user.a_intent == "hurt")
		if (islarva(user))//Safety check for larva. /N
			return
		user << "\green You claw at the [name]."
		for(var/mob/O in oviewers(src))
			O.show_message("\red [user] claws at the resin!", 1)
		playsound(loc, 'sound/effects/attackblob.ogg', 30, 1, -4)
		health -= rand(40, 60)
		if(health <= 0)
			user << "\green You slice the [name] to pieces."
			for(var/mob/O in oviewers(src))
				O.show_message("\red [user] slices the [name] apart!", 1)

			//Add to logs
			if (ishuman(buckled_mob))
				var/mob/target = buckled_mob
				var/turf/end_T = get_turf(target)

				//Is the target braindead?
				var/braindead_descriptor = "braindead"
				if (target.client)
					braindead_descriptor = "online"

				//Is he conscious?
				var/stat_descriptor = "conscious"
				if (target.stat == UNCONSCIOUS)
					stat_descriptor = "unconscious"
				else if (target.stat == DEAD)
					stat_descriptor = "dead"

				if (end_T)
					var/end_T_descriptor = "<font color='#6b4400'>[end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"
					user.attack_log +=  text("\[[time_stamp()]\]<font color='purple'> Destroyed an alien nest which held <font color='blue'>[target.name] ([braindead_descriptor] and [stat_descriptor])</font> at [end_T_descriptor]</font>")
					target.attack_log += text("\[[time_stamp()]\]<font color='purple'> Has been released from an alien nest <font color='blue'>(while [braindead_descriptor] and [stat_descriptor])</font> by <font color='red'>[user.name]</font> at [end_T_descriptor]</font>")
					msg_admin_attack("[user.name] ([user.ckey]) released <font color='red'>[target.name] ([braindead_descriptor] and [stat_descriptor])</font> from an alien nest at [end_T_descriptor] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)")

		healthcheck()
		return
	else
		buckled_mob.visible_message(\
			"<span class='notice'>[user.name] pulls [buckled_mob.name] free from the sticky nest!</span>",\
			"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
			"<span class='notice'>You hear squelching...</span>")
		buckled_mob.pixel_y = 0
		buckled_mob.nested = null

		//Add to logs
		if (ishuman(buckled_mob))
			var/mob/target = buckled_mob
			var/turf/end_T = get_turf(target)

			//Is the target braindead?
			var/braindead_descriptor = "braindead"
			if (target.client)
				braindead_descriptor = "online"

			//Is he conscious?
			var/stat_descriptor = "conscious"
			if (target.stat == UNCONSCIOUS)
				stat_descriptor = "unconscious"
			else if (target.stat == DEAD)
				stat_descriptor = "dead"

			if (end_T)
				var/end_T_descriptor = "<font color='#6b4400'>[end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"
				user.attack_log +=  text("\[[time_stamp()]\]<font color='purple'> Released <font color='blue'>[target.name] ([braindead_descriptor] and [stat_descriptor])</font> from an alien nest at [end_T_descriptor]</font>")
				target.attack_log += text("\[[time_stamp()]\]<font color='purple'> Has been released from an alien nest <font color='blue'>(while [braindead_descriptor] and [stat_descriptor])</font> by <font color='red'>[user.name]</font> at [end_T_descriptor]</font>")
				msg_admin_attack("[user.name] ([user.ckey]) released <font color='red'>[target.name] ([braindead_descriptor] and [stat_descriptor])</font> from an alien nest at [end_T_descriptor] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)")

		unbuckle()



/obj/structure/stool/bed/nest/proc/healthcheck()
	if(health <=0)
		density = 0
		if (buckled_mob)
			buckled_mob.pixel_y = 0
			buckled_mob.nested = null
			unbuckle()
		del(src)
	return
