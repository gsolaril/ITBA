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
    GUI.modifyimage(filename = x, x1 = (0.60, 0.10), x2 = (0.90, 0.70))

    # ----------------------------------- Texts:
    
    x = 'Locker %s will open for one last time' % unit + '\n'
    x = x + 'and your fingerprint will be then deleted' + '\n'
    x = x + 'from our databases.'
    GUI.modifytext(text = 'large', label = x, x = (0.25, 0.30))
    GUI.modifytext(text = 'small', label = '', x = None)
    x = 'It will remain unlocked for 20 seconds until opened.'
    GUI.modifytext(text = 'comnt', label = x, x = (0.50, 0.80))
    GUI.modifytext(text = 'textg', label = '', x = None)
    x = 'Please, retrieve your stuff completely. Otherwise, you will have' + '\n'
    x = x + 'to hire the locker once again to recover any forgotten objects'
    GUI.modifytext(text = 'textr', label = x, x = (0.25, 0.65))

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
