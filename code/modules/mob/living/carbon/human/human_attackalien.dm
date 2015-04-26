/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(check_shields(0, M.name))
		visible_message("\red <B>[M] attempted to touch [src]!</B>")
		return 0

	switch(M.a_intent)
		if ("help")
			visible_message(text("\blue [M] caresses [src] with its scythe like arm."))
		if ("grab")
			if(M == src || anchored)
				return
			if (w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)

			M.put_in_active_hand(G)

			grabbed_by += G
			G.synch()
			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(text("\red [] has grabbed [] passively!", M, src))

		if("hurt")
			if (w_uniform)
				w_uniform.add_fingerprint(M)
			var/damage = rand(M.damagemin, M.damagemax)
			if(!damage)
				playsound(loc, 'sound/weapons/slashmiss.ogg', 50, 1, -1)
				visible_message("\red <B>[M] has lunged at [src]!</B>")
				return 0
			var/datum/organ/external/affecting
			if(istype(M, /mob/living/carbon/alien/humanoid/ravager))
				affecting = get_organ(ran_zone("head", 95))
			else
				affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
			visible_message("\red <B>[M] has slashed at [src]!</B>")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
			score_slashes_made++

			apply_damage(damage, BRUTE, affecting, armor_block)


			updatehealth()

		if("disarm")
			if(weakened)
				if (prob(20))
					playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
					Weaken(rand(M.tacklemin,M.tacklemax))//Min and max tackle strenght. They are located in individual caste files.
					score_tackles_made++
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("\red <B>[] has tackled down []!</B>", M, src), 1)
				else
					playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1, -1)
					visible_message(text("\red <B>[] tried to tackle [], but they're already down!</B>", M, src))

			else
				if (prob(M.tackle_chance)) //Tackle_chance is now a special var for each caste.
					playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
					Weaken(rand(M.tacklemin,M.tacklemax))
					score_tackles_made++
					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("\red <B>[] has tackled down []!</B>", M, src), 1)
				else
					playsound(loc, 'sound/weapons/punchmiss.ogg', 50, 1, -1)
					visible_message(text("\red <B>[] tried to tackle []!</B>", M, src))
	return
