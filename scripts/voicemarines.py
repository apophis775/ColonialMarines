#!/usr/bin/env python2

'''
WINDOWS ONLY!
You need espeak: http://sourceforge.net/projects/espeak/files/espeak/espeak-1.47/espeak-1.47.11-win.zip/download
SOund eXchange (sox): http://sourceforge.net/projects/sox/files/sox/14.4.1/sox-14.4.1a-win32.zip/download
and WinVorbis for OggEnc: http://winvorbis.stationplaylist.com/WinVorbisSetup.exe

'''
import sys, os, re, string, random, math
from subprocess import call
import HTMLParser
h = HTMLParser.HTMLParser()
import time
import urlparse
import threading

try:
    from subprocess import DEVNULL # py3k
except ImportError:
    import os
    DEVNULL = open(os.devnull, 'wb')

playervoicespath = "C:/Users/Administrator/Desktop/Sulaco/sound/playervoices/"
scriptspath = "C:/Users/Administrator/Desktop/Sulaco/scripts/"
deletequeue = []

class VoiceThread(threading.Thread):
	def __init__(self, voice):
		threading.Thread.__init__(self)
		self.voice = voice
		
	def run(self):
		accent = self.voice["a"][0]
		voice = self.voice["v"][0]
		pitch = self.voice["p"][0]
		echo = self.voice["e"][0]
		speed = self.voice["s"][0]
		text = self.voice["text"][0]
		ckey = self.voice["k"][0][:-1]
		type = self.voice["t"][0]
		
		if accent.find("mb") != -1:
			accent = "en-us"
		extra2 = ""
		extra = ""
		if type.find("/carbon/alien") != -1:
			voice = ""
			
			accent = "en-xn"
			
			extra2 = " flanger 0 5 10 100 1 sin 25 overdrive"



			
		text = string.replace(text, "39", "'")
		text = string.replace(text, "34", "")



		if type.find("/silicon/ai") != -1:
			#accent = "en-us"
			#voice = "+f4"
			#pitch = 50
			accent = self.voice["a"][0]
			voice = self.voice["v"][0]
			pitch = self.voice["p"][0]
			speed = 160
			extra = "-k20"
			extra2 = ""
			echo = "100"
			if accent.find("mb") != -1:
				accent = "en-us"
			said = text.split(" ")
			said2 = []
			sysrandom = random.SystemRandom()
			initrandomnum = int(math.floor(sysrandom.random() * 80))
			randomnum = initrandomnum
			changeback = False
			
			for word in said:
				if text.find("!") != -1:
					pitch = 90
				aiextra = ""
				if(random.randint(1, 10)) > 8:
					ratenum = random.randint(8, 13) / 10
					if ratenum == 1:
						ratenum = ratenum - 0.1
					aiextra = ' rate="{}"'.format(ratenum)

				if(random.randint(1, 10)) > 4:
					randomnum = (sysrandom.random() * 40000 % 40)
					randomnum = int(math.floor(randomnum))
					changeback = True
				word = '<prosody pitch="{}"{}>{}</prosody> '.format(randomnum, aiextra,word)
				if changeback == True and (random.randint(1, 10)) > 5:
					randomnum = initrandomnum + random.randint(-20, 20)
				said2.append(word)
			text = ''.join(said2)
			filepath = "{}{}file.txt".format(playervoicespath,ckey)
			f = open(filepath, "w+")
			f.write(text)
			f.close()
			command = "espeak -m -w {}{}u.wav -v{}{} -f {} -p {} -s {} -a 100 {}".format(playervoicespath, ckey, accent,voice,playervoicespath + "" + ckey+"file.txt",pitch,speed,extra)
		elif type.find("/carbon/human") != -1:
			said = text.split(" ")
			said2 = []
			for word in said:
				replacepunc = ["!", "?", "."]
				excludeemph = ["I", "A"]
				randomnum = 50
				changeback = False
				extra = ""
				for punc in replacepunc:
					if word.find(punc) != -1:
						word = word.replace(punc, '')
						word = word + punc
				
				if word.upper() == word:
					if (word in excludeemph):
						x = 1
					else:
						word = '<emphasis level="strong">{}</emphasis>'.format(word)
			
				randomnum = random.randint(80, 125)

			
				word = '<prosody pitch="'+str(randomnum)+'%"{}>{}</prosody> '.format(extra,word)
				said2.append(word)
			text = ' '.join(said2)
			filepath = "{}{}file.txt".format(playervoicespath,ckey)
			f = open(filepath, "w+")
			f.write(text)
			f.close()
			
			command = "espeak -m -w {}{}u.wav -v{}{} -f {} -p {} -s {} -a 100 {}".format(playervoicespath, ckey, accent,voice,playervoicespath + "" + ckey+"file.txt",pitch,speed,extra)
		else:
			command = "espeak -m -w {}{}u.wav -v{}{} \"{}\" -p {} -s {} -a 100 {}".format(playervoicespath, ckey, accent,voice,text,pitch,speed,extra)
		print(command)
		# First we make the voice file, sounds/playervoice/keyu.wav
		call(command, stdout=DEVNULL)
		command2 = "sox "+playervoicespath+""+ckey+"u.wav \""+playervoicespath+""+ckey+".wav\" echo 1 0.5 "+echo+" .5 {}".format(extra2)
		# Now we apply effects to it, like echo (there's lots of other effects too)
		call(command2, stdout=DEVNULL)
		deletequeue.append([time.time() + 0.5, "{}{}.wav".format(playervoicespath, ckey)])
		#remove the old keyu.wav
		#os.remove("\"{}{}u.wav\"".format(playervoicespath, ckey))
		command3 = "OggEnc {}{}.wav".format(playervoicespath, ckey)
		#Now we turn key.wav into key.ogg to reduce bandwidth
		call(command3, stdout=DEVNULL)
		deletequeue.append([time.time() + 0.5, "{}{}u.wav".format(playervoicespath, ckey)])
		deletequeue.append([time.time() + 5, "{}{}.ogg".format(playervoicespath, ckey)])
		deletequeue.append([time.time(), "{}{}file.txt".format(playervoicespath, ckey)])
f = open('{}voicequeue.txt'.format(scriptspath), "r+")
f.seek(0)
f.truncate()
f.close()
while True:
	time.sleep(0.35)
	if os.path.getsize('{}voicequeue.txt'.format(scriptspath)) > 0:
		f = open('{}voicequeue.txt'.format(scriptspath), "r+")
		for line in f:
			
			parsed = urlparse.parse_qs(line)
			thread = VoiceThread(parsed)
			thread.start()
		f.seek(0)
		f.truncate()
		f.close()
	curtime = time.time()
	for i in range(len(deletequeue)):
		if deletequeue[i] != None:
			if os.path.isfile(deletequeue[i][1]):
				deltime = deletequeue[i][0]
				path = deletequeue[i][1]
				if deltime <= curtime:
					print("DELETE " + deletequeue[i][1])
					deletequeue[i] = None
					try:
						os.remove(path)
					except WindowsError:
						print('Failure to delete. Requeuing')
						deletequeue.append([deltime, path])
			else:
				deletequeue[i] = None
				


'''

#delete the wav
#os.remove(playervoicespath+""+ckey+".wav")
sys.exit()
'''