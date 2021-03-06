import sys, os
from tkinter import *
import GUI

def run(GUI):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = 'Hire locker')
    GUI.modifyoption(option = 'G', label = 'Open locker')
    GUI.modifyoption(option = 'B', label = 'Free locker')
    GUI.modifyoption(option = 'Y', label = 'Payment & Info')
    
    # ----------------------------------- Images:
    
    x = 'logo.gif'
    GUI.modifyimage(filename = x, x1 = (0.05, 0.05), x2 = (0.95, 0.25))

    # ----------------------------------- Texts:
    
    x = 'Welcome!!'
    GUI.modifytext(text = 'large', label = x, x = (0.50, 0.50))
    x = 'Please, select your option'
    GUI.modifytext(text = 'small', label = x, x = (0.50, 0.60))

    GUI.modifytext(text = 'comnt', label = '', x = None)
    GUI.modifytext(text = 'textr', label = '', x = None)
    GUI.modifytext(text = 'textg', label = '', x = None)

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
