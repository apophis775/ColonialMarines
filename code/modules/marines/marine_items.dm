/**********************Marine Gear**************************/

//MARINE ENCRYPTION KEYS

/obj/item/device/encryptionkey/mcom
	name = "Marine Command Radio Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "cap_cypherkey"
	channels = list("Marine Command" = 1, "Military Police" = 1, "Alpha Squad" = 0, "Bravo Squad" = 0, "Charlie Squad" = 0, "Delta Squad" = 0)

/obj/item/device/encryptionkey/mhaz
	name = "Hazteam Echo Radio Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "hop_cypherkey"
	channels = list("Hazteam Echo" = 1)

/obj/item/device/encryptionkey/malphal
	name = "Alpha Leader Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "hop_cypherkey"
	channels = list("Marine Command" = 1, "Alpha Squad" = 1)

/obj/item/device/encryptionkey/mbravol
	name = "Bravo Leader Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "hop_cypherkey"
	channels = list("Marine Command" = 1, "Bravo Squad" = 1)

/obj/item/device/encryptionkey/mcharliel
	name = "Charlie Leader Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "hop_cypherkey"
	channels = list("Marine Command" = 1, "Charlie Squad" = 1)

/obj/item/device/encryptionkey/mdeltal
	name = "Delta Leader Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "hop_cypherkey"
	channels = list("Marine Command" = 1, "Delta Squad" = 1)

/obj/item/device/encryptionkey/malp
	name = "Alpha Squad Radio Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "eng_cypherkey"
	channels = list("Alpha Squad" = 1)

/obj/item/device/encryptionkey/mbra
	name = "Bravo Squad Radio Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "cypherkey"
	channels = list("Bravo Squad" = 1)

/obj/item/device/encryptionkey/mcha
	name = "Charlie Squad Radio Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "sci_cypherkey"
	channels = list("Charlie Squad" = 1)

/obj/item/device/encryptionkey/mdel
	name = "Delta Squad Radio Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "hos_cypherkey"
	channels = list("Delta Squad" = 1)

/obj/item/device/encryptionkey/mmpo
	name = "Military Police Radio Encryption Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	icon_state = "rob_cypherkey"
	channels = list("Military Police" = 1)

//MARINE HEADSETS

/obj/item/device/radio/headset/mcom
	name = "marine command radio headset"
	desc = "This is used by the marine command. Channels are as follows: :v - marine command, :p - military police, :q - alpha squad, :y - bravo squad, :f - charlie squad, :d - delta squad."
	icon_state = "med_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mcom
	frequency = 1461

/obj/item/device/radio/headset/malphal
	name = "marine alpha leader radio headset"
	desc = "This is used by the marine alpha squad leader. Channels are as follows: :v - marine command, :q - alpha squad."
	icon_state = "cargo_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/malphal
	frequency = 1461

/obj/item/device/radio/headset/malpha
	name = "marine alpha radio headset"
	desc = "This is used by  alpha squad members. Channels are as follows: :q - alpha squad."
	icon_state = "sec_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/malp
	frequency = 1461

/obj/item/device/radio/headset/mbravol
	name = "marine bravo leader radio headset"
	desc = "This is used by the marine bravo squad leader. Channels are as follows: :v - marine command, :y - bravo squad."
	icon_state = "cargo_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mbravol
	frequency = 1461

/obj/item/device/radio/headset/mbravo
	name = "marine bravo radio headset"
	desc = "This is used by bravo squad members. Channels are as follows: :y - bravo squad."
	icon_state = "eng_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mbra
	frequency = 1461

/obj/item/device/radio/headset/msulaco
	name = "marine radio headset"
	desc = "A standard Sulaco radio headset"
	icon_state = "cargo_headset"
	item_state = "headset"
	frequency = 1461

/obj/item/device/radio/headset/mcharliel
	name = "marine charlie leader radio headset"
	desc = "This is used by the marine charlie squad leader. Channels are as follows: :v - marine command, :f - charlie squad."
	icon_state = "cargo_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mcharliel
	frequency = 1461

/obj/item/device/radio/headset/mcharlie
	name = "marine charlie radio headset"
	desc = "This is used by charlie squad members. Channels are as follows: :f - charlie squad."
	icon_state = "rob_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mcha
	frequency = 1461

/obj/item/device/radio/headset/mdeltal
	name = "marine delta leader radio headset"
	desc = "This is used by the marine delta squad leader. Channels are as follows: :v - marine command, :d - delta squad."
	icon_state = "cargo_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mdeltal
	frequency = 1461

obj/item/device/radio/headset/mdelta
	name = "marine delta radio headset"
	desc = "This is used by delta squad members. Channels are as follows: :d - delta squad."
	icon_state = "com_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mdel
	frequency = 1461

/obj/item/device/radio/headset/mmpo
	name = "marine military police radio headset"
	desc = "This is used by marine military police members. Channels are as follows: :p - military police."
	icon_state = "cargo_headset"
	item_state = "headset"
	keyslot2 = new /obj/item/device/encryptionkey/mmpo
	frequency = 1461

//MARINE RADIO

/obj/item/device/radio/marine
	frequency = 1461

//MARINE CONTAINERS

/obj/item/weapon/storage/box/beanbags
	name = "box of beanbag shells"
	desc = "It has a picture of a shotgun and several warning symbols on the front."
	icon_state = "shells"
	w_class=2
	New()
		..()
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)
		new /obj/item/ammo_casing/shotgun/beanbag(src)


/obj/item/weapon/storage/box/shotguns
	name = "box of shotgun shells"
	desc = "It has a picture of a combat shotgun and several warning symbols on the front."
	icon_state = "shells"
	w_class=2
	New()
		..()
		new /obj/item/ammo_casing/shotgun(src)
		new /obj/item/ammo_casing/shotgun(src)
		new /obj/item/ammo_casing/shotgun(src)
		new /obj/item/ammo_casing/shotgun(src)
		new /obj/item/ammo_casing/shotgun(src)
		new /obj/item/ammo_casing/shotgun(src)
		new /obj/item/ammo_casing/shotgun(src)