import sys, os
from tkinter import *
import GUI

def run(GUI, unit):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = None)
    GUI.modifyoption(option = 'B', label = None)
    GUI.modifyoption(option = 'Y', label = None)
    
    # ----------------------------------- Images:

    x = 'open.jpg'
    GUI.modifyimage(filename = x, x1 = (0.30, 0.20), x2 = (0.60, 0.60))

    # ----------------------------------- Texts:
    
    x = 'Locker %s is facing some issues' % unit + '\n'
    x = x + 'unlocking its latch mechanism'
    GUI.modifytext(text = 'large', label = x, x = (0.50, 0.10))    
    GUI.modifytext(text = 'small', label = '', x = None)
    GUI.modifytext(text = 'comnt', label = '', x = None)
    x = 'Please report this problem to your closest maintenance agent'
    GUI.modifytext(text = 'textr', label = x, x = (0.50, 0.70))
    GUI.modifytext(text = 'textg', label = '', x = None)

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
