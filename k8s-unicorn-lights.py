import sys
import unicornhat as unicorn
import subprocess

def clear(x, y):
    unicorn.set_pixel(x, y, 0, 0, 0) #x, y, r, g, b

def running(x, y):
    unicorn.set_pixel(x, y, 0, 255, 0) #x, y, r, g, b

def pending(x, y):
    unicorn.set_pixel(x, y, 0, 0, 255) #x, y, r, g, b

def updateLights(info):
    x = 0
    y = 0

    switcher = {
        0: clear,
        1: running,
        2: pending
    }

    unicorn.set_layout(unicorn.AUTO)
    unicorn.rotation(90)
    unicorn.brightness(0.5)
    for c in info.strip():
        func = switcher.get(int(c), "clear")
        func(x, y)
        x += 1
        if x % 8 == 0:
            x = 0
            y += 1

    unicorn.show()


while True:
    output = subprocess.Popen(['./k8s-unicorn-lights.sh', sys.argv[1]], 
                stdout=subprocess.PIPE, 
                stderr=subprocess.STDOUT)

    stdout,stderr = output.communicate()
    updateLights(stdout)