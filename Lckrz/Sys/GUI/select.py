import sys, os
from tkinter import *
import GUI
import math

def run(GUI):

    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = None)
    GUI.modifyoption(option = 'B', label = None)
    GUI.modifyoption(option = 'Y', label = 'Back to Menu')
    
    # ----------------------------------- Images:
    
    x = 'select.jpg'
    GUI.modifyimage(filename = x, x1 = (0.05, 0.05), x2 = (0.50, 0.50))
    
    # ----------------------------------- Texts:
    
    GUI.modifytext(text = 'large', label = '', x = (0.75, 0.35))
    x = 'Select a free locker:'
    GUI.modifytext(text = 'small', label = x, x = (0.75, 0.25))
    x = '--------------------' + '\n'
    x = 'Green ones are free,' + '\n'
    x = x + 'Red ones are occupied'
    GUI.modifytext(text = 'comnt', label = x, x = (0.75, 0.40))
    GUI.modifytext(text = 'textr', label = '', x = None)
    GUI.modifytext(text = 'textg', label = '', x = None)

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
