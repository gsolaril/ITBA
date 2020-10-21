import sys, os
from tkinter import *
import GUI

def run(GUI, unit, t1, t2):
   
    # ----------------------------------- Buttons & Labels:
    
    GUI.modifyoption(option = 'R', label = None)
    GUI.modifyoption(option = 'G', label = None)
    GUI.modifyoption(option = 'B', label = None)
    GUI.modifyoption(option = 'Y', label = 'Back to Menu')
    
    # ----------------------------------- Images:

    x = 'pay.jpg'
    GUI.modifyimage(filename = x, x1 = (0.60, 0.10), x2 = (0.90, 0.70))
    
    # ----------------------------------- Texts:
    
    x = 'Please insert token in upper slot to finish the' + '\n'
    x = x + 'enrollment process. Abort and ask your closest' + '\n'
    x = x + 'supervisor if you don"t have one.'
    GUI.modifytext(text = 'large', label = x, x = (0.25, 0.30))
    GUI.modifytext(text = 'small', label = '', x = None)
    x = 'A coin given back may not be valid,' + '\n'
    x = x + 'but you can retry at any rate.'
    GUI.modifytext(text = 'comnt', label = x, x = (0.50, 0.80))
    x = 'Present date-time: '
    x = x + '%s/%s/%s' % (t1[1], t1[2], t1[0])
    x = x + '   %s:' % t1[3] + '0'*(2 - len(str(t1[4]))) + str(t1[4])
    GUI.modifytext(text = 'textr', label = x, x = (0.25, 0.65))
    x = 'Future expiration date: '
    x = x + '%s/%s/%s' % (t2[1], t2[2], t2[0])
    x = x + '   %s:' % t2[3] + '0'*(2 - len(str(t2[4]))) + str(t2[4])
    GUI.modifytext(text = 'textg', label = x, x = (0.25, 0.70))

if (__name__ == "__main__"):

    run(GUI())

    mainloop()
