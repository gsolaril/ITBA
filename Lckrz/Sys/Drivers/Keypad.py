import sys
import RPi.GPIO as GPIO
from tkinter import *
from time import *

# ------------------------------------------------------------------- Keypad object

class keypad():                                                     # Keypad class definition.

    def __init__(self, rowVector, colVector, keyMatrix, Pull):

        self.Rows = rowVector                                       # Import row pin vector.
        self.Cols = colVector                                       # Import column pin vector.
        self.Keys = keyMatrix                                       # Import key identity table.
        self.Pull = Pull                                            # Pull up/down resistors.
        GPIO.setup(self.Cols, GPIO.OUT)                             # Columns set by system (outputs).
        GPIO.setup(self.Rows, GPIO.IN, pull_up_down = self.Pull)    # Rows set by user (inputs, N/open).
        GPIO.output(self.Cols, 1)                                   # Columns start set for key alert.
        self.kbf = ''                                               # Define a "past key" element (string).
        self.key = ''                                               # Define a "present key" element (string).
        
    def get(self):                                                  # Get pushed key identity as callback.

        preskey = ''                                                # No key identified at process startup.
                
        GPIO.output(self.Cols, 0)                                   # First, turn every column off.
        for j in range(len(self.Cols)):                             # There are as much columns as column pins.
            GPIO.output(self.Cols[j], 1)                            # Set to 1, each column at a time.
            for i in range(len(self.Rows)):                         # Set to read each row at a time.
                if (GPIO.input(self.Rows[i])):                      # If at the moment, said row reads 1...
                    preskey = self.Keys[i][j]                       # ...locate said key in identity table.
                    break                                           # There's no need to continue searching.
            GPIO.output(self.Cols[j], 0)                            # Set last column to zero and resume loop.
        GPIO.output(self.Cols, 1)                                   # Set all columns to 1 for further detection.
        if (self.kbf == preskey):                                   # Now, if key was the same from last cycle...
            self.key = ''                                           # ...do as if no key was ever pressed.
        else:                                                       # If identified key is distinct...
            self.key = preskey                                      # ...register it in class.
            self.kbf = preskey                                      # Also record it as past key for next cycle,
        return self.key                                             # Finally, give registered key as result.
        sleep(0.33)

    # IMPORTANT: a key press implies two consecutive but different rising edges: one for detection and the second
    # for key recognition. Remember that when the system detects the first rising edge, all columns are reset and
    # then one is energized at a time. When the pushed key's column is switched on during this cycle, its row pin
    # receives the resulting pulse edge of this action and triggers a "second event".

    def set(self, key):

        self.key = key

class keyTest(Tk):

    def __init__(self, keypad):

        Tk.__init__(self)
        self.geometry('200x200+100+100')
        self.keypad = keypad
        self.title('Keypad test')
        self.label = Label(self, text = 'N/A', font = ('Arial', '48'))
        self.label.place(relx = 0.5, rely = 0.5, anchor = CENTER)

        self.update()

    def update(self):

        key = self.keypad.get()
        if (key == ''):
            self.label.config(text = 'N/A')
        else:
            self.label.config(text = key)
        self.after(100, self.update)
    
if (__name__ == "__main__"):

    GPIO.setmode(GPIO.BCM)

    Pad = keypad([27, 22,  9, 10],
                 [25, 24, 23, 18],
                 [ ['1','2','3','F1'],
                   ['4','5','6','F2'],
                   ['7','8','9','F3'],
                   ['*','0','#','F4'] ],
                 GPIO.PUD_DOWN)
    
    Test = keyTest(Pad)
    
    Test.mainloop()

    GPIO.cleanup()
