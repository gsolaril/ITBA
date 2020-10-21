import sys, os
from tkinter import *
import GUI

def run(GUI):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = None)
    GUI.modifyoption(option = 'B', label = 'Last page')
    GUI.modifyoption(option = 'Y', label = 'Next page')
    
    # ----------------------------------- Images:
    
    x = 'logo.gif'
    GUI.modifyimage(filename = x, x1 = (0.05, 0.05), x2 = (0.95, 0.25))

    # ----------------------------------- Texts:
    
    x = '[Here goes help page 2]'
    GUI.modifytext(text = 'large', label = x, x = (0.50, 0.30))
    x = '[text written here]'
    GUI.modifytext(text = 'small', label = x, x = (0.50, 0.35))

    GUI.modifytext(text = 'comnt', label = '', x = None)
    GUI.modifytext(text = 'textr', label = '', x = None)
    GUI.modifytext(text = 'textg', label = '', x = None)
    
if (__name__ == "__main__"):

    run(GUI())

    mainloop()
