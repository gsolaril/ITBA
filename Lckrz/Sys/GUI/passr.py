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
    
    x = 'PW.gif'
    GUI.modifyimage(filename = x, x1 = (0.05, 0.05), x2 = (0.40, 0.50))
    
    # ----------------------------------- Texts:
    
    GUI.modifytext(text = 'large', label = '', x = (0.75, 0.35))
    x = 'We may now require that you register a 6-digit long' + 1*'\n'
    x = x + 'password, to use in case of any issue regarding the' + 1*'\n'
    x = x + 'fingerprint sensor...'
    GUI.modifytext(text = 'small', label = x, x = (0.75, 0.25))

    x = '-----------------------------------------------'
    x = x + 1*'\n'+ 'You can always access with it, '
    x = x + 'instead of using your fingerprint.'
    GUI.modifytext(text = 'comnt', label = x, x = (0.75, 0.40))
    GUI.modifytext(text = 'textr', label = '', x = None)
    GUI.modifytext(text = 'textg', label = '', x = None)

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
