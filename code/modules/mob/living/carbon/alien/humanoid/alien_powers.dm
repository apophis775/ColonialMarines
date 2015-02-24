/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/


/mob/living/carbon/alien/proc/powerc(X, Y)//Y is optional, checks for weed planting. X can be null.
	if(stat)
		src << "\green You must be conscious to do this."
		return 0
	else if(X && getPlasma() < X)
		src << "\green Not enough plasma stored."
		return 0
	else if(Y && (!isturf(src.loc) || istype(src.loc, /turf/space)))
		src << "\green Bad place for a garden!"
		return 0
	else	return 1

/mob/living/carbon/alien/humanoid/verb/plant()
	set name = "Plant Weeds (75)"
	set desc = "Plants some alien weeds"
	set category = "Alien"

	if(powerc(75,1))
		adjustToxLoss(-75)
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] has planted some alien weeds!</B>"), 1)
		new /obj/effect/alien/weeds/node(loc)
	return

/*
/mob/living/carbon/alien/humanoid/verb/ActivateHuggers()
	set name = "Activate facehuggers (5)"
	set desc = "Makes all nearby facehuggers activate"
	set category = "Alien"

	if(powerc(5))
		adjustToxLoss(-5)
		for(var/obj/item/clothing/mask/facehugger/F in range(8,src))
			F.GoActive()
		emote("roar")
	return
*/
/mob/living/carbon/alien/humanoid/verb/whisp(mob/M as mob in oview())
	set name = "Whisper (10)"
	set desc = "Whisper to someone"
	set category = "Alien"

	if(powerc(10))
		adjustToxLoss(-10)
		var/msg = sanitize(input("Message:", "Alien Whisper") as text|null)
		if(msg)
			log_say("AlienWhisper: [key_name(src)]->[M.key] : [msg]")
			M << "\green You hear a strange, alien voice in your head... \italic [msg]"
			src << {"\green You said: "[msg]" to [M]"}
	return

/mob/living/carbon/alien/humanoid/verb/transfer_plasma(mob/living/carbon/alien/M as mob in oview())
	set name = "Transfer Plasma"
	set desc = "Transfer Plasma to another alien"
	set category = "Alien"

	if(isalien(M))
		var/amount = input("Amount:", "Transfer Plasma to [M]") as num
		if (amount)
			amount = abs(round(amount))
			if(powerc(amount))
				if (get_dist(src,M) <= 1)
					M.adjustToxLoss(amount)
					adjustToxLoss(-amount)
					M << "\green [src] has transfered [amount] plasma to you."
					src << {"\green You have trasferred [amount] plasma to [M]"}
				else
					src << "\green You need to be closer."
	return


/mob/living/carbon/alien/humanoid/proc/weak_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Weak Acid (100)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Alien"

	if(powerc(100))
		if(O in oview(1))
			// OBJ CHECK
			if(isobj(O))
				var/obj/I = O
				if(I.unacidable)	//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
					src << "\green You cannot dissolve this object."
					return
			// TURF CHECK
			else if(istype(O, /turf/simulated))
				var/turf/T = O
				// R WALL
				if(istype(T, /turf/simulated/wall/r_wall))
					src << "\green You cannot dissolve this object."
					return
				//SHUTTLE TURFS
				if(istype(T, /turf/simulated/shuttle))
					src << "\green You cannot dissolve this object."
					return
				// R FLOOR
				if(istype(T, /turf/simulated/floor))
					src << "\green You cannot dissolve this object."
					return
			else// Not a type we can acid.
				return

			adjustToxLoss(-100)
			new /obj/effect/alien/weak_acid(get_turf(O), O)
			visible_message("\green <B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B>")
		else
			src << "\green Target is too far away."
	return






/mob/living/carbon/alien/humanoid/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrossive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Alien"

	if(powerc(200))
		if(O in oview(1))
			// OBJ CHECK
			if(isobj(O))
				var/obj/I = O
				if(I.unacidable)	//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
					src << "\green You cannot dissolve this object."
					return
			// TURF CHECK
			else if(istype(O, /turf/simulated))
				var/turf/T = O
				// R WALL
				if(istype(T, /turf/simulated/wall/r_wall))
					src << "\green You cannot dissolve this object."
					return
				//SHUTTLE TURFS
				if(istype(T, /turf/simulated/shuttle))
					src << "\green You cannot dissolve this object."
					return
				// R FLOOR
				if(istype(T, /turf/simulated/floor))
					src << "\green You cannot dissolve this object."
					return
			else// Not a type we can acid.
				return

			adjustToxLoss(-200)
			new /obj/effect/alien/acid(get_turf(O), O)
			visible_message("\green <B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B>")
		else
			src << "\green Target is too far away."
	return



/mob/living/carbon/alien/humanoid/proc/corrosive_acid_super(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Strong Corrosive Acid (300)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Alien"

	if(powerc(300))
		if(O in oview(1))
			// OBJ CHECK
			if(isobj(O))
				var/obj/I = O
				if(I.unacidable)	//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
					src << "\green You cannot dissolve this object."
					return
			// TURF CHECK
			else if(istype(O, /turf/simulated))
				var/turf/T = O
				//SHUTTLE TURFS
				if(istype(T, /turf/simulated/shuttle))
					src << "\green You cannot dissolve this object."
					return
				// R FLOOR
				if(istype(T, /turf/simulated/floor))
					src << "\green You cannot dissolve this object."
					return
			else// Not a type we can acid.
				return

			adjustToxLoss(-300)
			new /obj/effect/alien/superacid(get_turf(O), O)
			visible_message("\green <B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B>")
		else
			src << "\green Target is too far away."
	return

/mob/living/carbon/alien/humanoid/proc/quickspit()
	set name = "Toggle Quick Spit"
	set desc = "Switch to a faster neurotoxin spit mode, allowing you to spit at the nearest mob instead of choosing your target."
	set category = "Alien"
	if(quickspit)
		quickspit = 0
		src << "\red Quick spit disabled."
	else
		quickspit = 1
		src << "\red Quick spit enabled."


/mob/living/carbon/alien/humanoid/proc/neurotoxin()
	set name = "Spit Neurotoxin (100)"
	set desc = "Spits neurotoxin at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Alien"
	var/mob/target = null

	if(usedneurotox >= 1)
		src << "\red Our spit is not ready.."
		return

	if(powerc(100))
		var/list/moblist = new/list()
		var/mob/living/L
		var/mob/living/carbon/alien/M
		for(L in range())
			moblist += L
		for(M in moblist)
			moblist -= M

		if(quickspit)
			target = pick(moblist)
		else
			moblist += "Cancel"
			target = input("Spits neurotoxin at someone, paralyzing them for a short time.", "Spit Neurotoxin (100)") in moblist


		if(target && target != "Cancel")
			src << "\green You spit neurotoxin at [target]."

			for(var/mob/O in oviewers())
				if (O.client && !O.blinded)
					O << "\red [src] spits neurotoxin at [target]!"

			var/turf/T = loc
			var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

			if(!U || !T)
				return
			while(U && !istype(U,/turf))
				U = U.loc
			if(!istype(T, /turf))
				return
			if (U == T)
				usr.bullet_act(new /obj/item/projectile/energy/neurotoxin(usr.loc), get_organ_target())
				return
			if(!istype(U, /turf))
				return

			var/obj/item/projectile/energy/neurotoxin/A = new /obj/item/projectile/energy/neurotoxin(usr.loc)
			A.current = U
			A.yo = U.y - T.y
			A.xo = U.x - T.x
			A.process()
			adjustToxLoss(-100)
			usedneurotox = 6
		else
			src << "\red We see no prey."
			return
	return

/mob/living/carbon/alien/humanoid/proc/weak_neurotoxin()
	set name = "Spit Weak Neurotoxin (75)"
	set desc = "Spits a weak neurotoxin at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Alien"
	var/mob/target = null

	if(usedneurotox >= 1)
		src << "\red Our spit is not ready.."
		return

	if(powerc(75))
		var/list/moblist = new/list()
		var/mob/living/L
		var/mob/living/carbon/alien/M
		for(L in range())
			moblist += L
		for(M in moblist)
			moblist -= M

		if(quickspit)
			target = pick(moblist)
		else
			moblist += "Cancel"
			target = input("Spits neurotoxin at someone, paralyzing them for a short time.", "Spit Neurotoxin (100)") in moblist

		if(target && target != "Cancel")
			src << "\green You spit neurotoxin at [target]."

			for(var/mob/O in oviewers())
				if (O.client && !O.blinded)
					O << "\red [src] spits neurotoxin at [target]!"

			var/turf/T = loc
			var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

			if(!U || !T)
				return
			while(U && !istype(U,/turf))
				U = U.loc
			if(!istype(T, /turf))
				return
			if (U == T)
				usr.bullet_act(new /obj/item/projectile/energy/weak_neurotoxin(usr.loc), get_organ_target())
				return
			if(!istype(U, /turf))
				return

			var/obj/item/projectile/energy/weak_neurotoxin/A = new /obj/item/projectile/energy/weak_neurotoxin(usr.loc)
			A.current = U
			A.yo = U.y - T.y
			A.xo = U.x - T.x
			A.process()
			adjustToxLoss(-100)
			usedneurotox = 3
		else
			src << "\red We see no prey."
			return
	return

/mob/living/carbon/alien/humanoid/proc/super_neurotoxin()
	set name = "Spit Super Neurotoxin (150)"
	set desc = "Spits a strong neurotoxin at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Alien"
	var/mob/target = null

	if(usedneurotox >= 1)
		src << "\red Our spit is not ready.."
		return

	if(powerc(150))
		var/list/moblist = new/list()
		var/mob/living/L
		var/mob/living/carbon/alien/M
		for(L in range())
			moblist += L
		for(M in moblist)
			moblist -= M

		if(quickspit)
			target = pick(moblist)
		else
			moblist += "Cancel"
			target = input("Spits neurotoxin at someone, paralyzing them for a short time.", "Spit Neurotoxin (100)") in moblist

		if(target && target != "Cancel")
			src << "\green You spit neurotoxin at [target]."

			for(var/mob/O in oviewers())
				if (O.client && !O.blinded)
					O << "\red [src] spits neurotoxin at [target]!"

			var/turf/T = loc
			var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

			if(!U || !T)
				return
			while(U && !istype(U,/turf))
				U = U.loc
			if(!istype(T, /turf))
				return
			if (U == T)
				usr.bullet_act(new /obj/item/projectile/energy/super_neurotoxin(usr.loc), get_organ_target())
				return
			if(!istype(U, /turf))
				return

			var/obj/item/projectile/energy/super_neurotoxin/A = new /obj/item/projectile/energy/super_neurotoxin(usr.loc)
			A.current = U
			A.yo = U.y - T.y
			A.xo = U.x - T.x
			A.process()
			adjustToxLoss(-150)
			usedneurotox = 10
		else
			src << "\red We see no prey."
			return
	return

/mob/living/carbon/alien/humanoid/proc/resin() // -- TLE
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough malleable resin."
	set category = "Alien"

	if(powerc(75))
		if((locate(/obj/effect/alien/egg) in get_turf(src)) || (locate(/obj/structure/mineral_door/resin) in get_turf(src)) || (locate(/obj/effect/alien/resin/wall) in get_turf(src)) || (locate(/obj/effect/alien/resin/membrane) in get_turf(src)) || (locate(/obj/structure/stool/bed/nest) in get_turf(src)))
			src << "There is already a structure or egg here."
			return

		var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in list("resin door","resin wall","resin membrane","resin nest") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
		if(!choice || !powerc(75))	return
		adjustToxLoss(-75)
		src << "\green You shape a [choice]."
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\red <B>[src] vomits up a thick purple substance and begins to shape it!</B>"), 1)
		switch(choice)
			if("resin door")
				new /obj/structure/mineral_door/resin(loc)
			if("resin wall")
				new /obj/effect/alien/resin/wall(loc)
			if("resin membrane")
				new /obj/effect/alien/resin/membrane(loc)
			if("resin nest")
				new /obj/structure/stool/bed/nest(loc)
	return

/mob/living/carbon/alien/humanoid/verb/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Alien"

	if(powerc())
		if(stomach_contents.len)
			for(var/mob/M in src)
				if(M in stomach_contents)
					stomach_contents.Remove(M)
					M.loc = loc
					//Paralyse(10)
			src.visible_message("\green <B>[src] hurls out the contents of their stomach!</B>")
	return
