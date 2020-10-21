import sys, os
from tkinter import *
import GUI

def run(GUI, unit, y, m, d):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = None)
    GUI.modifyoption(option = 'B', label = None)
    GUI.modifyoption(option = 'Y', label = None)
    
    # ----------------------------------- Images:

    x = 'open.jpg'
    GUI.modifyimage(filename = x, x1 = (0.60, 0.10), x2 = (0.90, 0.70))
    
    # ----------------------------------- Texts:
    
    x = 'Locker %s has been unlocked' % unit + '\n'
    x = x + 'and is ready for you to open!'
    GUI.modifytext(text = 'large', label = x, x = (0.25, 0.30))
    x = 'Remember to shut your door properly' + '\n'
    x = x + 'after use. Keep your stuff secure!'
    GUI.modifytext(text = 'small', label = x, x = (0.25, 0.50))
    x = 'It will remain unlocked for 20 seconds until opened.'
    GUI.modifytext(text = 'comnt', label = x, x = (0.50, 0.80))
    GUI.modifytext(text = 'textr', label = '', x = None)
    x = 'Expiration date:' + '\n%s/%s/%s' % (m, d, y)
    GUI.modifytext(text = 'textg', label = x, x = (0.25, 0.65))

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
