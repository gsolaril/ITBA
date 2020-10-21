import sys, os
from tkinter import *
import GUI

def run(GUI, unit):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = 'Yes')
    GUI.modifyoption(option = 'B', label = None)
    GUI.modifyoption(option = 'Y', label = 'No')
    
    # ----------------------------------- Images:
    
    GUI.modifyimage(filename = None)

    # ----------------------------------- Texts:
    
    x = 'Locker %s will open for one last time, and your' % unit
    x = x + '\n' + 'fingerprint will be deleted from our databases'
    GUI.modifytext(text = 'large', label = x, x = (0.50, 0.20))    
    GUI.modifytext(text = 'small', label = '', x = None)
    GUI.modifytext(text = 'comnt', label = '', x = None)
    x = 'Are you sure you want to unsuscribe from your locker service?'
    GUI.modifytext(text = 'textr', label = x, x = (0.50, 0.60))
    GUI.modifytext(text = 'textg', label = '', x = None)

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
