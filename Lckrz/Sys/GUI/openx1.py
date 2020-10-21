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

    GUI.image.delete("all")
    
    ### Image is deleted. Instead, door animation may take place
    
    # ----------------------------------- Texts:
    
    x = 'Your access to Locker %s has been' % unit + '\n'
    x = x + 'blocked due to pending debt!'
    GUI.modifytext(text = 'large', label = x, x = (0.25, 0.30))
    x = 'Please, update your payment status immediately' + '\n'
    x = x + 'Otherwise, we may automatically free its access' + '\n'
    x = x + 'to general public during the next 10 days'
    GUI.modifytext(text = 'small', label = x, x = (0.25, 0.50))
    x = 'It will remain unlocked for 20 seconds until opened.'
    GUI.modifytext(text = 'comnt', label = x, x = (0.50, 0.80))
    GUI.modifytext(text = 'textg', label = '', x = None)
    x = 'Expiration date:' + '\n%s/%s/%s' % (m, d, y)
    GUI.modifytext(text = 'textr', label = x, x = (0.25, 0.65))

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
