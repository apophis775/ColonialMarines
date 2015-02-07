#!/usr/bin/env python2

import sys, os, math,time,random,string
from subprocess import call


print("Restarting Server")


os.system("taskkill /F /im ddaemon.exe")
time.sleep(5)
call("pythonw \"C:/Users/Administrator/Desktop/Launch Marines.py\"", shell=True)

sys.exit()	