
/*
	run_armor_check(a,b)
	args
	a:def_zone - What part is getting hit, if null will check entire body
	b:attack_flag - What type of attack, bullet, laser, energy, melee

	Returns
	0 - no block
	1 - halfblock
	2 - fullblock
*/
/mob/living/proc/run_armor_check(var/def_zone = null, var/attack_flag = "melee", var/absorb_text = null, var/soften_text = null)
	var/armor = getarmor(def_zone, attack_flag)
	var/absorb = 0
	if(prob(armor))
		absorb += 1
	if(prob(armor))
		absorb += 1
	if(absorb >= 2)
		if(absorb_text)
			show_message("[absorb_text]")
		else
			show_message("\red Your armor absorbs the blow!")
		return 2
	if(absorb == 1)
		if(absorb_text)
			show_message("[soften_text]",4)
		else
			show_message("\red Your armor softens the blow!")
		return 1
	return 0


/mob/living/proc/getarmor(var/def_zone, var/type)
	return 0


/mob/living/bullet_act(var/obj/item/projectile/P, var/def_zone)
	var/obj/item/weapon/cloaking_device/C = locate((/obj/item/weapon/cloaking_device) in src)
	if(C && C.active)
		C.attack_self(src)//Should shut it off
		update_icons()
		src << "\blue Your [C.name] was disrupted!"
		Stun(2)

	flash_weak_pain()

	if(istype(equipped(),/obj/item/device/assembly/signaler))
		var/obj/item/device/assembly/signaler/signaler = equipped()
		if(signaler.deadman && prob(80))
			src.visible_message("\red [src] triggers their deadman's switch!")
			signaler.signal()

	var/absorb = run_armor_check(def_zone, P.flag)
	if(absorb >= 2)
		P.on_hit(src,2)
		return 2
	if(!P.nodamage)
		apply_damage((P.damage/(absorb+1)), P.damage_type, def_zone, absorb, 0, P)
	P.on_hit(src, absorb)
	return absorb

/mob/living/hitby(atom/movable/AM as mob|obj,var/speed = 5)//Standardization and logging -Sieve
	var/mob/living/chargetarget = src
	var/mob/living/AM2 = AM
	if(AM2 && AM2.charging > 0 && chargetarget)
		visible_message("\red <B>[AM2] smashes into [chargetarget]!</B>")
		if(!istype(AM2, /mob/living/carbon/alien/humanoid/ravager))
			if(istype(AM2, /mob/living/carbon/human))
				AM2.stunned = AM2.charging / 3 + 1
			if(istype(src, /mob/living/carbon/human))
				src.stunned = AM2.charging / 1.5 + 1
			AM2.take_organ_damage(AM2.charging * 8)
			src.take_organ_damage(AM2.charging * 15)

		if(istype(chargetarget, /mob/living/))
			var/atom/T
			var/throwdir = get_dir(AM2, chargetarget)
			var/atom/object = get_step(chargetarget, throwdir)
			object = get_step(object, throwdir)
			object = get_step(object, throwdir)
			object = get_step(object, throwdir)
			object = get_step(object, throwdir)
			object = get_step(object, throwdir)
			T = get_step(object, throwdir)
			chargetarget.throw_at(T, charging, 1 + (charging / 2))
			chargetarget.charging = charging - 1
			chargetarget.take_organ_damage(charging * 2)
			spawn( 20 - (15 / charging) )
				if(istype(chargetarget, /mob/living/carbon/human))
					chargetarget.stunned = 1
				chargetarget.charging = 0
				chargetarget.take_organ_damage(charging * 3)

			charging = 0
		return

	if(istype(AM,/obj/))
		var/obj/O = AM
		var/zone = ran_zone("chest",75)//Hits a random part of the body, geared towards the chest
		var/dtype = BRUTE
		if(istype(O,/obj/item/weapon))
			var/obj/item/weapon/W = O
			dtype = W.damtype
		src.visible_message("\red [src] has been hit by [O].")
		var/armor = run_armor_check(zone, "melee", "Your armor has protected your [zone].", "Your armor has softened hit to your [zone].")
		if(armor < 2)
			apply_damage(O.throwforce*(speed/5), dtype, zone, armor, O.sharp, O)

		if(!O.fingerprintslast)
			return

		var/client/assailant = directory[ckey(O.fingerprintslast)]
		if(assailant && assailant.mob && istype(assailant.mob,/mob))
			var/mob/M = assailant.mob

			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a thrown [O], last touched by [M.name] ([assailant.ckey])</font>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with a thrown [O]</font>")
			msg_admin_attack("[src.name] ([src.ckey]) was hit by a thrown [O], last touched by [M.name] ([assailant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

			// Begin BS12 momentum-transfer code.

			if(speed >= 20)
				var/obj/item/weapon/W = O
				var/momentum = speed/2
				var/dir = get_dir(M,src)

				visible_message("\red [src] staggers under the impact!","\red You stagger under the impact!")
				src.throw_at(get_edge_target_turf(src,dir),1,momentum)

				if(istype(W.loc,/mob/living) && W.sharp) //Projectile is embedded and suitable for pinning.

					if(!istype(src,/mob/living/carbon/human)) //Handles embedding for non-humans and simple_animals.
						O.loc = src
						src.embedded += O

					var/turf/T = near_wall(dir,2)

					if(T)
						src.loc = T
						visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
						src.anchored = 1
						src.pinned += O


/mob/living/proc/near_wall(var/direction,var/distance=1)
	var/turf/T = get_step(get_turf(src),direction)
	var/turf/last_turf = src.loc
	var/i = 1

	while(i>0 && i<=distance)
		if(T.density) //Turf is a wall!
			return last_turf
		i++
		last_turf = T
		T = get_step(T,direction)

	return 0
//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/AM as mob|obj,var/speed = 5)//Standardization and logging -Sieve
	if(istype(AM,/obj/))
		var/obj/O = AM
		var/dtype = BRUTE
		if(istype(O,/obj/item/weapon))
			var/obj/item/weapon/W = O
			dtype = W.damtype
		var/throw_damage = O.throwforce*(speed/5)

		var/miss_chance = 15
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			miss_chance = min(15*(distance-2), 0)

		if (prob(miss_chance))
			visible_message("\blue \The [O] misses [src] narrowly!")
			return

		src.visible_message("\red [src] has been hit by [O].")
		var/armor = run_armor_check(null, "melee")

		if(armor < 2)
			apply_damage(throw_damage, dtype, null, armor, O)

		O.throwing = 0		//it hit, so stop moving

		if(ismob(O.thrower))
			var/mob/M = O.thrower
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>")
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with a thrown [O]</font>")
				if(!istype(src,/mob/living/simple_animal/mouse))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

		// Begin BS12 momentum-transfer code.
		if(O.throw_source && speed >= 15)
			var/obj/item/weapon/W = O
			var/momentum = speed/2
			var/dir = get_dir(O.throw_source, src)

			visible_message("\red [src] staggers under the impact!","\red You stagger under the impact!")
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!W || !src) return

			if(W.sharp) //Projectile is suitable for pinning.
				//Handles embedding for non-humans and simple_animals.
				O.loc = src
				src.embedded += O


// End BS12 momentum-transfer code.