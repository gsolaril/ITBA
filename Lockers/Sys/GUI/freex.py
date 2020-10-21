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
    
    GUI.modifyimage(filename = None)

    # ----------------------------------- Texts:
    
    x = 'Locker %s cannot be freed due to pending debt ' % unit
    x = x + 'in your register.'
    GUI.modifytext(text = 'large', label = x, x = (0.50, 0.20))    
    GUI.modifytext(text = 'small', label = '', x = None)
    GUI.modifytext(text = 'comnt', label = '', x = None)
    x = 'Please get in terms with your payment status' + '\n'
    x = x + 'as soon as possible, and then try again'
    GUI.modifytext(text = 'textr', label = x, x = (0.50, 0.60))
    GUI.modifytext(text = 'textg', label = '', x = None)

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
