/mob/living/carbon/alien/humanoid/hivelord
	name = "alien hivelord"
	caste = "Hivelord"
	maxHealth = 320
	health = 320
	icon = 'icons/Xeno/2x2_Xenos.dmi'
	icon_state = "Hivelord Walking"
	plasma_rate = 50
	heal_rate = 6
	storedPlasma = 100
	max_plasma = 1000
	damagemin = 10
	damagemax = 15
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 70 //Should not be above 100%
	psychiccost = 32

/mob/living/carbon/alien/humanoid/hivelord/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	if(src.name == "alien hivelord")
		src.name = text("alien hivelord ([rand(1, 1000)])")
	src.real_name = src.name
	verbs -= /mob/living/carbon/alien/verb/ventcrawl

	verbs.Add(/mob/living/carbon/alien/humanoid/proc/resin,/mob/living/carbon/alien/humanoid/proc/corrosive_acid)
	/*var/matrix/M = matrix()
	M.Scale(0.9,0.9)
	src.transform = M
	*/
	pixel_x = -16
	..()

/*
/mob/living/carbon/alien/humanoid/hivelord/ClickOn(var/atom/A, params)

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		var/turf/select
		if(!istype(A, /turf))
			if(istype(A.loc, /turf))
				select = A.loc
			else
				..()
				return
		else
			select = A
		if(select)
			if(get_dist(src, select) <= 3)
				resin2(select)
				return
	..()*/

/mob/living/carbon/alien/humanoid/hivelord/proc/check_floor(var/turf/location)
	if(istype(location, /turf/simulated/wall) || istype(location, /turf/unsimulated/wall))
		return 0
	for(var/atom/object in range(1, location))
		if(istype(object, /turf/simulated) || istype(object, /obj/structure/lattice) || istype(object, /turf/unsimulated))
			return 1

	return 0
/*
/mob/living/carbon/alien/humanoid/hivelord/verb/resin2(var/turf/location = src.loc) // -- TLE
	set name = "Secrete Hardened Resin (75)"
	set desc = "Secrete tough malleable resin."
	set category = "Alien"
	if(!location)
		if(istype(src.loc, /turf))
			location = src.loc
		else
			return

	if(!canMoveTo(src.loc, location))
		src << "You don't have a line of sight with this location"
		return

	if(powerc(75))
		var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in list("resin door","resin wall","resin membrane","resin nest","resin floor") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
		if(!choice || !powerc(75))	return



		var/dist = get_dist(src, location)
		adjustToxLoss(-75)
		if(dist > 3)
			src << "\green Too far away."
			return
		else if(dist > 1 && dist <= 3)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red <B>[src] vomits up a thick purple substance and launches it.</B>"), 1)
		else if(dist <= 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(text("\red <B>[src] vomits up a thick purple substance and begins to shape it!</B>"), 1)
		src << "\green You shape a [choice]."
		switch(choice)
			if("resin door")
				new /obj/structure/mineral_door/resin/hardened(location)
			if("resin wall")
				new /obj/effect/alien/resin/wall/hardened(location)
			if("resin membrane")
				new /obj/effect/alien/resin/membrane/hardened(location)
			if("resin nest")
				new /obj/structure/stool/bed/nest(location)
			if("resin floor")
				if(check_floor(location))
					if(istype(location, /turf))
						location.ChangeTurf(/turf/simulated/floor/resin)
					else
						src << "\green Bad spot for a floor."
				else
					src << "\green Bad spot for a floor."
	return


*/

//hivelords use the same base as generic humanoids.
//hivelord verbs


/obj/structure/mineral_door/resin/hardened
	hardness = 2.5
	health = 200
	color = "#CCCCCC"

/obj/effect/alien/resin/wall/hardened
		name = "resin wall"
		desc = "Purple slime solidified into a wall."
		icon_state = "resinwall" //same as resin, but consistency ho!
		color = "#CCCCCC"
		health = 230

/obj/effect/alien/resin/membrane/hardened
		name = "resin membrane"
		desc = "Purple slime just thin enough to let light pass through."
		icon_state = "resinmembrane"
		opacity = 0
		health = 170
		color = "#CCCCCC"


/turf/simulated/floor/resin
	icon_state = "resinfloor"