import sys, os
from tkinter import *
import GUI

def run(GUI):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = None)
    GUI.modifyoption(option = 'B', label = None)
    GUI.modifyoption(option = 'Y', label = None)

    # ----------------------------------- Images:

    x = 'FPx.jpg'
    GUI.modifyimage(filename = x, x1 = (0.05, 0.20), x2 = (0.60, 0.55))

    # ----------------------------------- Texts:
    
    GUI.modifytext(text = 'large', label = None, x = None)
    x = 'Scanned:'
    GUI.modifytext(text = 'small', label = x, x = (0.75, 0.25))
    x = 'Fingerprint already registered:\n'
    x = x + 'only one locker per user allowed!'
    GUI.modifytext(text = 'comnt', label = x, x = (0.75, 0.55))
    GUI.modifytext(text = 'textg', label = '', x = None)
    x = ': ( NO!'
    GUI.modifytext(text = 'textr', label = x, x = (0.75, 0.35))
    
if (__name__ == "__main__"):

    run(GUI())

    mainloop()
