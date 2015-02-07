import sys
from html.parser import HTMLParser
h = HTMLParser()
import urllib.parse

accent = sys.argv[1]
voice = sys.argv[2]
pitch = sys.argv[3]
echo = sys.argv[4]
speed = sys.argv[5]
text = h.unescape(sys.argv[6])
ckey = sys.argv[7]
type = sys.argv[8]

command = {"text":text, "a":accent, "v":voice, "p":pitch, "e":echo, "s":speed, "k":ckey, "t":type}

text = urllib.parse.urlencode(command) + "\n"

f = open("C:/Users/Administrator/Desktop/Sulaco/scripts/voicequeue.txt", "a")
f.write(text)
f.close()
