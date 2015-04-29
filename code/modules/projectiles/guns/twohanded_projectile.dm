/obj/item/weapon/gun/twohanded/projectile
	//Two handed stuff
	var/wielded = 0
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null
	var/ammo_type = "/obj/item/ammo_casing/a357"
	var/list/loaded = list()
	var/max_shells = 7
	var/load_method = SPEEDLOADER //0 = Single shells or quick loader, 1 = box, 2 = magazine
	var/obj/item/ammo_magazine/empty_mag = null


	//flashlight stuff
	var/haslight = 0 //Is there a flashlight attached?
	var/islighton = 0


	//Bayonet
	var/hasBayonet = 0 //Is there a bayonet?
	var/bayonetDamage = 40 //Controls the bayonet Damage

/obj/item/weapon/twohanded/projectile/offhand
	w_class = 5.0
	icon_state = "offhand"
	name = "offhand"

	unwield()
		del(src)

	wield()
		del(src)


/obj/item/weapon/gun/twohanded/projectile/proc/unwield()
	wielded = 0
	force_unwielded = force
	name = "[initial(name)]"
	update_icon()

/obj/item/weapon/gun/twohanded/projectile/proc/wield()
	wielded = 1
	force_wielded = force
	name = "[initial(name)] (Wielded)"
	update_icon()

/obj/item/weapon/gun/twohanded/projectile/New()
	..()
	for(var/i = 1, i <= max_shells, i++)
		loaded += new ammo_type(src)
	update_icon()
	return

/obj/item/weapon/gun/twohanded/projectile/load_into_chamber()
	if(in_chamber)
		return 1 //{R}

	if(!loaded.len)
		return 0
	var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
	loaded -= AC //Remove casing from loaded list.
	if(isnull(AC) || !istype(AC))
		return 0
	if(ejectshell == 1)
		AC.loc = get_turf(src) //Eject casing onto ground.
	if(AC.BB)
		AC.desc += " This one is spent."	//descriptions are magic - only when there's a projectile in the casing
		AC.spent = 1
		in_chamber = AC.BB //Load projectile into chamber.
		AC.BB.loc = src //Set projectile loc to gun.
		return 1
	return 0


/obj/item/weapon/gun/twohanded/projectile/examine()
	..()
	usr << "Has [getAmmo()] round\s remaining."
//		if(in_chamber && !loaded.len)
//			usr << "However, it has a chambered round."
//		if(in_chamber && loaded.len)
//			usr << "It also has a chambered round." {R}
	return

/obj/item/weapon/gun/twohanded/projectile/proc/getAmmo()
	var/bullets = 0
	for(var/obj/item/ammo_casing/AC in loaded)
		if(istype(AC))
			bullets += 1
	return bullets

/obj/item/weapon/gun/twohanded/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	var/num_loaded = 0
	if(istype(A, /obj/item/ammo_magazine))
		if((load_method == MAGAZINE) && loaded.len)	return
		var/obj/item/ammo_magazine/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			if(loaded.len >= max_shells)
				break
			if(AC.caliber == caliber && loaded.len < max_shells)
				AC.loc = src
				AM.stored_ammo -= AC
				loaded += AC
				num_loaded++
		if(load_method == MAGAZINE)
			user.remove_from_mob(AM)
			empty_mag = AM
			empty_mag.loc = src
	if(istype(A, /obj/item/ammo_casing) && load_method == SPEEDLOADER)
		var/obj/item/ammo_casing/AC = A
		if(AC.caliber == caliber && loaded.len < max_shells)
			user.drop_item()
			AC.loc = src
			loaded += AC
			num_loaded++
	if(num_loaded)
		user << "\blue You load [num_loaded] shell\s into the gun!"
		playsound(loc, 'sound/weapons/unload.ogg', 60, 1, -1)
	A.update_icon()
	update_icon()

//Flashlight and Bayonet Code attachment code - Apophis 11APR2015
	if(istype(A, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = A
		if(F.attachable)
			src.contents += A
			user << "\red You attach [A] to [src]."
			haslight = 1
			del(A)
	if(istype(A, /obj/item/weapon/combat_knife))
		if(src.hasBayonet == 1)
			user <<"\blue You can't attach another bayonet!"
			return
		var/obj/item/weapon/combat_knife/K = A
		if(K.attachable)
			src.contents += A
			user <<"\red You affix your bayonet LIKE A BADASS"
			hasBayonet = 1
			src.force+=bayonetDamage
	return



/obj/item/weapon/gun/twohanded/projectile/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)//TODO: go over this
	//Exclude lasertag guns from the CLUMSY check.
	if(clumsy_check)
		if(istype(user, /mob/living))
			var/mob/living/M = user
			if ((CLUMSY in M.mutations) && prob(50))
				M << "<span class='danger'>[src] blows up in your face.</span>"
				M.take_organ_damage(0,20)
				M.drop_item()
				del(src)
				return

	if (!user.IsAdvancedToolUser())
		user << "\red You don't have the dexterity to do this!"
		return

	if(istype(user, /mob/living))
		var/mob/living/M = user
		if (HULK in M.mutations)
			M << "\red Your meaty finger is much too large for the trigger guard!"
			return
	if(ishuman(user))
		if(user.dna && user.dna.mutantrace == "adamantine")
			user << "\red Your metal fingers don't fit in the trigger guard!"
			return

	if(!wielded)
		user << "\red You can not fire this weapon with one hand!"
		return

	add_fingerprint(user)

	var/turf/curloc = get_turf(user)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return

	if(!special_check(user))
		return

	if (!ready_to_fire())
		if (world.time % 3) //to prevent spam
			user << "<span class='warning'>[src] is not ready to fire again!"
		return

	if(!load_into_chamber()) //CHECK
		return click_empty(user)

	if(!in_chamber)
		return

	in_chamber.firer = user
	in_chamber.def_zone = user.zone_sel.selecting
	if(targloc == curloc)
		user.bullet_act(in_chamber)
		del(in_chamber)
		update_icon()
		return

	if(recoil)
		spawn()
			shake_camera(user, recoil + 1, recoil)

	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		playsound(user, fire_sound, 50, 1)
		user.visible_message("<span class='warning'>[user] fires [src][reflex ? " by reflex":""]!</span>", \
		"<span class='warning'>You fire [src][reflex ? "by reflex":""]!</span>", \
		"You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

	in_chamber.original = target
	in_chamber.loc = get_turf(user)
	in_chamber.starting = get_turf(user)
	in_chamber.shot_from = src
	user.next_move = world.time + 4
	in_chamber.silenced = silenced
	in_chamber.current = curloc
	in_chamber.yo = targloc.y - curloc.y
	in_chamber.xo = targloc.x - curloc.x
	score_rounds_fired++

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			in_chamber.p_x = text2num(mouse_control["icon-x"])
		if(mouse_control["icon-y"])
			in_chamber.p_y = text2num(mouse_control["icon-y"])

	spawn()
		if(in_chamber)
			in_chamber.process()
	sleep(1)
	in_chamber = null

	update_icon()

	if(user.hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()


/obj/item/weapon/gun/twohanded/projectile/mob_can_equip(M as mob, slot)
	//Cannot equip wielded items.
	if(wielded)
		M << "<span class='warning'>Unwield the [initial(name)] first!</span>"
		return 0

	return ..()

/obj/item/weapon/gun/twohanded/projectile/dropped(mob/user as mob)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user && wielded)
		unwield()
		var/obj/item/weapon/twohanded/projectile/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()
	return

/obj/item/weapon/gun/twohanded/projectile/update_icon()
	return

/obj/item/weapon/gun/twohanded/projectile/pickup(mob/user)
	unwield()
	return

/obj/item/weapon/gun/twohanded/projectile/attack_self(mob/user as mob)
	if( istype(user,/mob/living/carbon/monkey) )
		user << "<span class='warning'>It's too heavy for you to wield fully.</span>"
		return

	..()
	if(wielded) //Trying to unwield it
		unwield()
		user << "<span class='notice'>You are now carrying the [name] with one hand.</span>"
		if (src.unwieldsound)
			playsound(src.loc, unwieldsound, 50, 1)

		var/obj/item/weapon/twohanded/projectile/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()
		return

	else //Trying to wield it
		if(user.get_inactive_hand())
			user << "<span class='warning'>You need your other hand to be empty</span>"
			return
		wield()
		user << "<span class='notice'>You grab the [initial(name)] with both hands.</span>"
		if (src.wieldsound)
			playsound(src.loc, wieldsound, 50, 1)

		var/obj/item/weapon/twohanded/projectile/offhand/O = new(user) ////Let's reserve his other hand~
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on the [initial(name)]"
		user.put_in_inactive_hand(O)
		return

//NEW RIOT SHOTGUN FLASHLIGHT CODE APOPHIS775 05FEB2015
/obj/item/weapon/gun/twohanded/projectile/shotgun/pump/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	if(istype(A, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = A
		if(F.attachable)
			src.contents += A
			user << "\red You attach [A] to [src]."
			haslight = 1
			del(A)
	return