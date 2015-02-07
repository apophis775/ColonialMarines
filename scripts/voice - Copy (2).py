#!/usr/bin/env python2
import sys
sys.exit()
import HTMLParser
h = HTMLParser.HTMLParser()
import urllib

accent = sys.argv[1]
voice = sys.argv[2]
pitch = sys.argv[3]
echo = sys.argv[4]
speed = sys.argv[5]
text = h.unescape(sys.argv[6])
ckey = sys.argv[7]
type = sys.argv[8]

command = {"text":text, "a":accent, "v":voice, "p":pitch, "e":echo, "s":speed, "k":ckey, "t":type}

text = urllib.urlencode(command) + "\n"

f = open("C:/Users/Administrator/Desktop/Sulaco/scripts/voicequeue.txt", "a")
f.write(text)
f.close()
sys.exit()