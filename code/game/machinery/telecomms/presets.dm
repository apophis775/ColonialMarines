// ### Preset machines  ###

//Relay

/obj/machinery/telecomms/relay/preset
	network = "tcommsat"

/obj/machinery/telecomms/relay/preset/station
	id = "Station Relay"
	listening_level = 1
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/machinery/telecomms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = 0
	autolinkers = list("r_relay")

/obj/machinery/telecomms/relay/preset/centcom
	id = "Centcom Relay"
	hide = 1
	toggled = 1
	//anchored = 1
	//use_power = 0
	//idle_power_usage = 0
	heatgen = 0
	autolinkers = list("c_relay")

/obj/machinery/telecomms/relay/marine
	id = "Marine Relay"
	network = "sulaconet"
	listening_level = 1
	autolinkers = list("marine_relay")

/obj/machinery/telecomms/relay/marine/support
	id = "Support Relay"
	autolinkers = list("marine_support_relay")

//HUB

/obj/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "relay", "c_relay", "s_relay", "m_relay", "r_relay", "science", "medical",
	"supply", "common", "command", "engineering", "security",
	"receiverA", "receiverB", "broadcasterA", "broadcasterB")

/obj/machinery/telecomms/hub/marine
	id = "MHub"
	network = "sulaconet"
	autolinkers = list("Mhub", "marine_relay", "marine_support_relay", "msulaco", "mhazteam", "mcommand",
	"mbravo", "malpha", "mcharlie", "morange", "mwhite", "mmpolice", "mdelta", "mblack",
	"MreceiverA", "MreceiverB", "MbroadcasterA", "MbroadcasterB")

//Receivers

//--PRESET LEFT--//

/obj/machinery/telecomms/receiver/preset_left
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(1351, 1355, 1347) // science, medical, supply

/obj/machinery/telecomms/receiver/marine_left
	id = "MReceiver A"
	network = "sulaconet"
	autolinkers = list("MreceiverA") // link to relay
	freq_listening = list(1367, 1369, 1371, 1373, 1375, 1379, 1381, 1383) // bravo, alpha, charlie, orange, white, mpolice, delta, black
//--PRESET RIGHT--//

/obj/machinery/telecomms/receiver/preset_right
	id = "Receiver B"
	network = "tcommsat"
	autolinkers = list("receiverB") // link to relay
	freq_listening = list(1353, 1357, 1359) //command, engineering, security

	//Common and other radio frequencies for people to freely use
	New()
		for(var/i = 1441, i < 1489, i += 2)
			freq_listening |= i
		..()

/obj/machinery/telecomms/receiver/marine_right
	id = "MReceiver B"
	network = "sulaconet"
	autolinkers = list("MreceiverB") // link to relay
	freq_listening = list(1461, 1363, 1365) //sulaco, hazteam echo, marine command

//Buses

/obj/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(1351, 1355)
	autolinkers = list("processor1", "science", "medical")

/obj/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(1347)
	autolinkers = list("processor2", "supply")

/obj/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(1359, 1353)
	autolinkers = list("processor3", "security", "command")

/obj/machinery/telecomms/bus/preset_four
	id = "Bus 4"
	network = "tcommsat"
	freq_listening = list(1357)
	autolinkers = list("processor4", "engineering", "common")

/obj/machinery/telecomms/bus/preset_four/New()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/bus/marine_one
	id = "MBus 1"
	network = "sulaconet"
	freq_listening = list(1461, 1363, 1365)
	autolinkers = list("Mprocessor1", "msulaco", "mhazteam", "mcommand")

/obj/machinery/telecomms/bus/marine_two
	id = "MBus 2"
	network = "sulaconet"
	freq_listening = list(1367, 1369, 1371)
	autolinkers = list("Mprocessor2", "mbravo", "malpha", "mcharlie")

/obj/machinery/telecomms/bus/marine_three
	id = "MBus 3"
	network = "sulaconet"
	freq_listening = list(1373, 1375, 1379)
	autolinkers = list("Mprocessor3", "morange", "mwhite", "mmpolice")

/obj/machinery/telecomms/bus/marine_four
	id = "MBus 4"
	network = "sulaconet"
	freq_listening = list(1381, 1383)
	autolinkers = list("Mprocessor4", "mdelta", "mblack")

//Processors

/obj/machinery/telecomms/processor/preset_one
	id = "Processor 1"
	network = "tcommsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

/obj/machinery/telecomms/processor/preset_two
	id = "Processor 2"
	network = "tcommsat"
	autolinkers = list("processor2")

/obj/machinery/telecomms/processor/preset_three
	id = "Processor 3"
	network = "tcommsat"
	autolinkers = list("processor3")

/obj/machinery/telecomms/processor/preset_four
	id = "Processor 4"
	network = "tcommsat"
	autolinkers = list("processor4")

/obj/machinery/telecomms/processor/marine_one
	id = "MProcessor 1"
	network = "sulaconet"
	autolinkers = list("Mprocessor1")

/obj/machinery/telecomms/processor/marine_two
	id = "MProcessor 2"
	network = "sulaconet"
	autolinkers = list("Mprocessor2")

/obj/machinery/telecomms/processor/marine_three
	id = "MProcessor 3"
	network = "sulaconet"
	autolinkers = list("Mprocessor3")

/obj/machinery/telecomms/processor/marine_four
	id = "MProcessor 4"
	network = "sulaconet"
	autolinkers = list("Mprocessor4")

//Servers

/obj/machinery/telecomms/server/presets

	network = "tcommsat"

/obj/machinery/telecomms/server/presets/science
	id = "Science Server"
	freq_listening = list(1351)
	autolinkers = list("science")

/obj/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(1355)
	autolinkers = list("medical")

/obj/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(1347)
	autolinkers = list("supply")

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list()
	autolinkers = list("common")

	//Common and other radio frequencies for people to freely use
	// 1441 to 1489
/obj/machinery/telecomms/server/presets/common/New()
	for(var/i = 1441, i < 1489, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(1353)
	autolinkers = list("command")

/obj/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(1357)
	autolinkers = list("engineering")

/obj/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(1359)
	autolinkers = list("security")

/obj/machinery/telecomms/server/marine
	network = "sulaconet"

/obj/machinery/telecomms/server/marine/sulaco
	id = "Sulaco Server"
	freq_listening = list(1461)
	autolinkers = list("msulaco")

/obj/machinery/telecomms/server/marine/hazteam
	id = "Hazteam Echo Server"
	freq_listening = list(1363)
	autolinkers = list("mhazteam")

/obj/machinery/telecomms/server/marine/command
	id = "Marine Command Server"
	freq_listening = list(1365)
	autolinkers = list("mcommand")

/obj/machinery/telecomms/server/marine/bravo
	id = "Bravo Squad Server"
	freq_listening = list(1367)
	autolinkers = list("mbravo")

/obj/machinery/telecomms/server/marine/alpha
	id = "Alpha Squad Server"
	freq_listening = list(1369)
	autolinkers = list("malpha")

/obj/machinery/telecomms/server/marine/charlie
	id = "Charlie Squad Server"
	freq_listening = list(1371)
	autolinkers = list("mcharlie")

/obj/machinery/telecomms/server/marine/mpolice
	id = "Military Police Server"
	freq_listening = list(1379)
	autolinkers = list("mmpolice")

/obj/machinery/telecomms/server/marine/delta
	id = "Delta Squad Server"
	freq_listening = list(1381)
	autolinkers = list("mdelta")

//Broadcasters

//--PRESET LEFT--//

/obj/machinery/telecomms/broadcaster/preset_left
	id = "Broadcaster A"
	network = "tcommsat"
	autolinkers = list("broadcasterA")

/obj/machinery/telecomms/broadcaster/marine_left
	id = "MBroadcaster A"
	network = "sulaconet"
	autolinkers = list("MbroadcasterA")

//--PRESET RIGHT--//

/obj/machinery/telecomms/broadcaster/preset_right
	id = "Broadcaster B"
	network = "tcommsat"
	autolinkers = list("broadcasterB")

/obj/machinery/telecomms/broadcaster/marine_right
	id = "MBroadcaster B"
	network = "sulaconet"
	autolinkers = list("MbroadcasterB")
