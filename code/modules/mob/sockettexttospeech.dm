/proc/texttospeechstrip(var/t_in)
	var/t_out = ""

	for(var/i=1, i<=length(t_in), i++)
		var/ascii_char = text2ascii(t_in,i)
		switch(ascii_char)
			// A .. Z
			if(65 to 90)                        //Uppercase Letters
				if(lentext(t_out) <= 150)
					t_out += ascii2text(ascii_char)
			// a .. z
			if(97 to 122)                        //Lowercase Letters
				if(lentext(t_out) <= 150)
					t_out += ascii2text(ascii_char)

			// 0 .. 9
			if(48 to 57)                        //Numbers
				if(lentext(t_out) <= 150)
					t_out += ascii2text(ascii_char)


			// ` , - . ! ? : '
			if(39,44,45,46,33,63,58,96,60,62)                        //Common name punctuation
				if(lentext(t_out) <= 150)
					t_out += ascii2text(ascii_char)


			//Space
			if(32)
				if(lentext(t_out) <= 150)
					t_out += ascii2text(ascii_char)

	return t_out

/var/lastspeak = ""

/mob/proc/texttospeech(var/text, var/speed, var/pitch, var/accent, var/voice, var/echo, var/name)
	text = texttospeechstrip(text)
	lastspeak = text
	if (!name)
		if(!src.ckey || src.ckey == "")
			name = "\ref[src]"
		else
			name = src.ckey
	//ext_python("voice.py", "\"[accent]\" \"[voice]\" \"[pitch]\" \"[echo]\" \"[speed]\" \"[text]\" \"[name]\" \"[src.type]\"")
	var/voicelist[0]
	voicelist["text"] = text
	voicelist["a"] = accent
	voicelist["v"] = voice
	voicelist["p"] = pitch
	voicelist["e"] = echo
	voicelist["s"] = speed
	voicelist["k"] = name
	voicelist["t"] = src.type
	var/voiceparams = list2params(voicelist)
	global.socket_talk.send_raw(voiceparams)

/mob/proc/halltexttospeech(var/text, var/speed, var/pitch, var/accent, var/voice, var/echo)
	text = texttospeechstrip(text)
	lastspeak = text
	ext_python("voice.py", "\"[accent]\" \"[voice]\" \"[pitch]\" \"[echo]\" \"[speed]\" \"[text]\" \"hall[src.ckey]\"")
