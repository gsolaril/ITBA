import sys
import RPi.GPIO as GPIO
from tkinter import *
from time import *

class wallet():

    def __init__(self, Enable, Coin, Pull = None):

        self.Enable = Enable
        self.Coin = Coin
        self.Pull = Pull
        if (Pull is None): GPIO.setup(self.Coin, GPIO.IN)
        else: GPIO.setup(self.Coin, GPIO.IN, pull_up_down = self.Pull)
        GPIO.setup(self.Enable, GPIO.OUT)
        self.paid = 0

    def on(self):

        GPIO.output(self.Enable, 1)

    def off(self):

        GPIO.output(self.Enable, 0)

    def get(self):

        self.paid = not(GPIO.input(self.Coin))

        return self.paid

if (__name__ == "__main__"):

    import datetime

    try:
        GPIO.setmode(GPIO.BCM)
        W = wallet(Enable = 4, Coin = 17, Pull = None)
        W.on()

        t = datetime.datetime.now()
        s = (t.hour*60 + t.minute)*60 + t.second
        s0 = s
        seg = s - s0
        while (seg <= 5):
            x = W.get()
            print(x)
            t = datetime.datetime.now()
            s = (t.hour*60 + t.minute)*60 + t.second
            seg = s - s0
        W.off()

    except:
        W.off()
        GPIO.cleanup()
