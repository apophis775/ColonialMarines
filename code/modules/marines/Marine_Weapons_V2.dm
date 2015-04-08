///**************NEW LORE COLONIAL MARINES WEAPON EDIT 31JAN2015 - BY APOPHIS**************///


///***Bullets***///
/obj/item/projectile/bullet/m4a3 //Colt 45 Pistol
	damage = 25

/obj/item/projectile/bullet/m44m //44 Magnum Peacemaker
	damage = 45

/obj/item/projectile/bullet/m39 // M39 SMG
	damage = 20

/obj/item/projectile/bullet/m41 //M41 Assault Rifle
	damage = 30

/obj/item/projectile/bullet/m37 //M37 Pump Shotgun
	damage = 80

///***Ammo***///

/obj/item/ammo_casing/m4a3 //45 Pistol
	desc = "A .45 special bullet casing."
	caliber = "45s"
	projectile_type = "/obj/item/projectile/bullet/m4a3"

/obj/item/ammo_casing/m44m //44 Magnum Peacemaker
	desc = "A 44 Magnum bullet casing."
	caliber = "38s"
	projectile_type = "/obj/item/projectile/bullet/m44m"

/obj/item/ammo_casing/m39 // M39 SMG
	desc = "A .9mm special bullet casing."
	caliber = "9mms"
	projectile_type = "/obj/item/projectile/bullet/m39"

/obj/item/ammo_casing/m41 //M41Assault Rifle
	desc = "A 10mm special bullet casing."
	caliber = "10mms"
	projectile_type = "/obj/item/projectile/bullet/m41"

/obj/item/ammo_casing/m37 //M37 Pump Shotgun
	name = "Shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	caliber = "12gs"
	projectile_type = "/obj/item/projectile/bullet/m37"

///***Ammo Boxes***///

/obj/item/ammo_magazine/m4a3 //45 Pistol
	name = "M4A3 Magazine (.45)"
	desc = "A magazine with .45 ammo"
	icon_state = ".45a"
	ammo_type = "/obj/item/ammo_casing/m4a3"
	max_ammo = 12

/obj/item/ammo_magazine/m4a3e/empty //45 Pistol
	icon_state = ".45a0"
	max_ammo = 0

/obj/item/weapon/gun/projectile/pistol/m4a3/New() //45 Pistol
	..()
	empty_mag = new /obj/item/ammo_magazine/m4a3e/empty(src) //45 Pistol
	return

/obj/item/ammo_magazine/m44m // 44 Magnum Peacemaker
	name = "44 Magnum Speed Loader (.44)"
	desc = "A 44 Magnum speed loader"
	icon_state = "38"
	ammo_type = "/obj/item/ammo_casing/m44m"
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/m39 // M39 SMG
	name = "M39 SMG Mag (9mm)"
	desc = "A 9mm special magazine"
	icon_state = "9x19p-8"
	ammo_type = "/obj/item/ammo_casing/m39"
	max_ammo = 30

/obj/item/ammo_magazine/m39/empty // M39 SMG
	icon_state = "9x19p-0"
	max_ammo = 0

/obj/item/ammo_magazine/m41 //M41 Assault Rifle
	name = "M41A Magazine (10mm)"
	desc = "A 10mm special magazine"
	icon_state = "m309a"
	ammo_type = "/obj/item/ammo_casing/m41"
	max_ammo = 30

/obj/item/ammo_magazine/m41/empty //Assault Rifle
	max_ammo = 0
	icon_state = "m309a0"


/obj/item/weapon/storage/box/m37 //M37 Shotgun
	name = "M37 Shotgun shells (box)"
	desc = "A box of standard issue high-powered 12 gauge buckshot rounds. Manufactured by Armat Systems for military and civilian use."
	icon_state = "shells"
	w_class = 2 //Can fit in belts
	New()
		..()
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)
		new /obj/item/ammo_casing/m37(src)


///***Pistols***///

/obj/item/weapon/gun/projectile/pistol/m4a3 //45 Pistol
	name = "\improper M4A3 Service Pistol"
	desc = "M4A3 Service Pistol, the standard issue sidearm of the Colonial Marines. Uses .45 special rounds."
	icon_state = "colt"
	max_shells = 12
	caliber = "45s"
	fire_sound = 'sound/weapons/servicepistol.ogg'
	ammo_type = "/obj/item/ammo_casing/m4a3"
	recoil = 0

/obj/item/weapon/gun/projectile/pistol/m4a3/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!loaded.len && empty_mag)
		empty_mag.loc = get_turf(src.loc)
		empty_mag = null
	return

/obj/item/weapon/gun/projectile/m44m //mm44 Magnum Peacemaker
	name = "\improper 44 Magnum"
	desc = "A bulky 44 Magnum revolver, occasionally carried by assault troops and officers in the Colonial Marines. Uses 44 Magnum rounds"
	icon_state = "mateba"
	caliber = "38s"
	ammo_type = "/obj/item/ammo_casing/m44m"


///***SMGS***///

/obj/item/weapon/gun/projectile/automatic/Assault/m39 // M39 SMG
	name = "\improper M39 SMG"
	desc = " Armat Battlefield Systems M39 SMG. Occasionally carried by light-infantry, scouts or non-combat personnel. Uses 9mm rounds."
	icon_state = "smg"
	item_state = "c20r"
	max_shells = 30
	caliber = "9mms"
	ammo_type = "/obj/item/ammo_casing/m39"
	fire_sound = 'sound/weapons/Gunshot_m39.ogg'
	fire_delay = 0
	force = 8.0
	ejectshell = 0 //Caseless
	load_method = 2
	recoil = 1

	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
		return

	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/m39/empty(src)
		update_icon()
		return

	isHandgun()
		return 0


///***RIFLES***///

/obj/item/weapon/gun/twohanded/projectile/Assault/m41 //M41 Assault Rifle
	name = "\improper M41A Rifle"
	desc = "M41A Pulse Rifle. The standard issue rifle of the Colonial Marines. Commonly carried by most combat personnel. Uses 10mm special ammunition."
	icon_state = "m41a0"
	item_state = "m41a"
	w_class = 3.0
	max_shells = 30
	caliber = "10mms"
	ammo_type = "/obj/item/ammo_casing/m41"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	load_method = 2
	force = 10.0
	ejectshell = 0 //Caseless
	fire_delay = 4
	slot_flags = SLOT_BACK
	var/customized=0               //
	var/attachment=""

	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/m41/empty(src)
		update_icon()
		return

	attackby(var/obj/item/A as obj, mob/user as mob)
		if(istype(A,/obj/item/weapon/attachable))
			if(customized == 0)
				customized += 1
				user<<"<font color=teal><I>You attach a [A.name] to your rifle."
				if(istype(A, /obj/item/weapon/attachable/Bayonet ))   //if checks for certain attachments
					force += A.force
					attachment="bayonet"
					src.contents+=list(new/obj/item/weapon/attachable/Bayonet)
					update_icon()
				del(A)
			else
				user<<"There's already an attachable..."
		else
			return
	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
			update_icon()
		return

	update_icon()
		..()
		if(empty_mag)
			icon_state = "m41a"
			if(attachment == "bayonet")                  //
				icon_state = "m41ac1"

		else
			icon_state = "m41a0"
			if(attachment == "bayonet")                //
				icon_state = "m41a0c1"
		return


	verb/toggle(mob/user)
		set category = "Object"
		set name = "Eject current magazine"
		set src in usr
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		user << "\blue You eject the magazine from \the [src]!"
		empty_mag.desc = "There are [getAmmo()] shells left"

		if(usr.canmove && !usr.stat && !usr.restrained())
			var/obj/item/ammo_magazine/AM = empty_mag
			for (var/obj/item/ammo_casing/AC in loaded)
				AM.stored_ammo += AC
				loaded -= AC
				AM.loc = get_turf(src)
				empty_mag = null
				update_icon()

	verb/Remove_Customizable()
		set category ="Object"
		set src in usr
		var/obj/item/weapon/attachable/A = locate() in src.contents
		if(A)
			usr<<"<font color=teal>You remove [A.name] from your rifle."
			customized -= 1
			if(customized <= 0)
				customized = 0
			if(istype(A, /obj/item/weapon/attachable/Bayonet ))     //if checks for certain attachments
				new/obj/item/weapon/attachable/Bayonet(usr.loc)
				force -= A.force
				attachment=""
				update_icon()
			del(A)
		else
			usr<<"You don't have an customizable attachment to your rifle."
			return

/*
	verb/toggle(mob/user)
		set category = "Object"
		set name = "Fake reload"
		set src in usr
		user << "\blue You quickly eject and reload your current magazine from \the [src] to fake a reload!"
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
*/

///***SHOTGUNS***///

/obj/item/weapon/gun/twohanded/projectile/shotgun/pump/m37 //M37 Pump Shotgun
	name = "\improper M37 Pump Shotgun"
	desc = "Colonial Marine M37 Pump Shotgun"
	icon_state = "cshotgun"
	max_shells = 8
	caliber = "12gs"
	ammo_type = "/obj/item/ammo_casing/m37"
	recoil = 1
	force = 10.0

///***Attachables***///
obj/item/weapon/attachable
	Bayonet
		name="Bayonet"
		icon = 'icons/obj/weapons.dmi'
		icon_state="bayonet"
		item_state="knife"
		desc="Used a millenium ago when mankind were still bound to planet surface."
		flags = FPRINT | TABLEPASS | CONDUCT
		sharp = 1
		force = 10
		w_class = 1.0
		throwforce = 10
		throw_speed = 3
		throw_range = 4
		hitsound = 'sound/weapons/slash.ogg'
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		slot_flags = SLOT_BELT

///***MELEE/THROWABLES***///

/obj/item/weapon/combat_knife
	name = "\improper Marine Combat Knife"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "combat_knife"
	item_state = "knife"
	desc = "When shits gets serious! You can slide this knife into your boots."
	flags = FPRINT | TABLEPASS | CONDUCT
	sharp = 1
	force = 35
	w_class = 1.0
	throwforce = 20
	throw_speed = 3
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	slot_flags = SLOT_MASK | SLOT_BELT

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>")
		return (BRUTELOSS)

/obj/item/weapon/throwing_knife
	name ="Throwing Knife"
	icon='icons/obj/weapons.dmi'
	item_state="knife"
	desc="A military knife designed to be thrown at the enemy. Much quieter than a firearm, but requires a steady hand to be used effectively."
	flags = FPRINT | TABLEPASS | CONDUCT
	sharp = 1
	force = 10
	w_class = 1.0
	throwforce = 35
	throw_speed = 4
	throw_range = 7
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	slot_flags = SLOT_POCKET
		// Slayerplayer99: Different type of throwing knives if more wanted
	Carbon_Steel
		name="Throwing Knife"
		throw_speed=5
		throw_range=8
		throwforce=40
		icon_state="temp"

///***GRENADES***///
/obj/item/weapon/grenade/explosive
	desc = "A Colonial Marines fragmentation grenade. It explodes 3 seconds after the pin has been pulled."
	name = "Frag grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade_ex"
	det_time = 30
	item_state = "grenade_ex"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	dangerous = 1

	prime()
		spawn(0)
			explosion(src.loc,-1,-1,3)
			del(src)
		return


///***MINES***///
/obj/item/device/mine
	name = "Proximity Mine"
	desc = "An anti-personnel mine. Useful for setting traps or for area denial. "
	icon = 'icons/obj/grenade.dmi'
	icon_state = "mine"
	force = 5.0
	w_class = 2.0
	layer = 3
	throwforce = 5.0
	throw_range = 6
	throw_speed = 3
	unacidable = 1
	flags = FPRINT | TABLEPASS

	var/triggered = 0
	var/triggertype = "explosive" //Calls that proc
	/*
		"explosive"
		//"incendiary" //New bay//
	*/


//Arming
/obj/item/device/mine/attack_self(mob/living/user as mob)
	if(locate(/obj/item/device/mine) in get_turf(src))
		src << "There's already a mine at this position!"
		return
	if(!anchored)
		user.visible_message("\blue \The [user] is deploying \the [src]")
		if(!do_after(user,40))
			user.visible_message("\blue \The [user] decides not to deploy \the [src].")
			return
		user.visible_message("\blue \The [user] deployed \the [src].")
		anchored = 1
		icon_state = "mine_armed"
		user.drop_item()
		return

//Disarming
/obj/item/device/mine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/multitool))
		if(anchored)
			user.visible_message("\blue \The [user] starts to disarm \the [src].")
			if(!do_after(user,80))
				user.visible_message("\blue \The [user] decides not to disarm \the [src].")
				return
			user.visible_message("\blue \The [user] finishes disarming \the [src]!")
			anchored = 0
			icon_state = "mine"
			return

//Triggering
/obj/item/device/mine/HasEntered(AM as mob|obj)
	Bumped(AM)

/obj/item/device/mine/Bumped(mob/M as mob|obj)
	if(!anchored) return //If armed
	if(triggered) return

	if(istype(M, /mob/living/carbon/alien) && !istype(M, /mob/living/carbon/alien/larva)) //Only humanoid aliens can trigger it.
		for(var/mob/O in viewers(world.view, src.loc))
			O << "<font color='red'>[M] triggered the \icon[src] [src]!</font>"
		triggered = 1
		call(src,triggertype)(M)

//TYPES//
//Explosive
/obj/item/device/mine/proc/explosive(obj)
	explosion(src.loc,-1,-1,2)
	spawn(0)
		del(src)
//Incendiary
//**//TODO
