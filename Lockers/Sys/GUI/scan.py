import sys, os
from tkinter import *
import GUI

def run(GUI):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = None)
    GUI.modifyoption(option = 'B', label = None)
    GUI.modifyoption(option = 'Y', label = 'Back to Menu')

    # ----------------------------------- Images:

    x = 'FP10.jpg'
    GUI.modifyimage(filename = x, x1 = (0.05, 0.20), x2 = (0.60, 0.55))

    # ----------------------------------- Texts:
    
    GUI.modifytext(text = 'large', label = None, x = None)
    x = 'Time to scan your fingerprint!\n'
    x = x + 'Please, lean your thumb on the reader.'
    GUI.modifytext(text = 'small', label = x, x = (0.75, 0.25))
    x = 'Do not remove the finger\n'
    x = x + 'until we tell you'
    GUI.modifytext(text = 'comnt', label = x, x = (0.75, 0.35))
    GUI.modifytext(text = 'textr', label = '', x = None)
    GUI.modifytext(text = 'textg', label = '', x = None)
    
if (__name__ == "__main__"):

    run(GUI())

    mainloop()
