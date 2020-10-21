import sys, os
import RPi.GPIO as GPIO
import time
from tkinter import *
from Drivers import Setup, Keypad, Reader, Wallet
from Data import Data, I2C
from GUI import GUI
import random, math

# ------------------------------------------------------- State machine
  
class Cycle(GUI.GUI):

    def __init__(self, **kwargs):

        GUI.GUI.__init__(self, **kwargs)

        self.phase = 1
        self.option = 0
        self.fpid = None
        self.unit = 0
        self.code = None
        self.typo = ''
        self.says = ''
        self.cntr = 0
        
        self.then = time.time()
        self.tmax = float("inf")

        self.GP = Setup.setup()
        self.KP = Keypad.keypad(self.GP.Rows, self.GP.Cols,
                                self.GP.Keys, GPIO.PUD_DOWN)
        self.FP = Reader.reader(self.GP.FPin)
        self.WA = Wallet.wallet(self.GP.Enable, self.GP.Coin)

        self.I2C = I2C.I2C()
        direc = 'Data.csv'

        self.DB = Data.base(direc, 31, 'days')
        
        self.idle = False

        self.FP.set_led(0)

        self.comm()

        time.sleep(4)       ## Be able to read DB, FP and I2C initial data

        self.show(1)
        
        self.goto()

    def goto(self):

        timer = time.time() - self.then
        
        if (self.idle):
            while (timer < self.tmax):
                timer = time.time() - self.then

        self.KP.key = self.KP.get()

        self.after(100, self.goto)
        
        if (self.phase == 1): ######## Main menu
            
            if (self.KP.key == 'F1') and (0 in [self.DB.rExpd(i + 1) for i
                                            in range(len(self.DB.data))]):
                self.option = 1
                self.show(10)
                return

            if (self.KP.key == 'F2'):
                
                self.option = 2
                self.show(10)
                return

            if (self.KP.key == 'F3'):
                
                self.option = 3
                self.show(10)
                return
            
            if (self.KP.key == 'F4'):
                
                self.option = 0
                self.show(80)
                return

            if (int(timer % 4) == 3):

                List0 = [bool(2**self.I2C.lrec['Omax'] &
                               int(i[self.DB.l['Door']]))
                                for i in self.DB.data]

                if (True in List0):
                    tg = 'Opened: '
                    for i in range(len(List0)):
                        if (List0[i]): tg = tg + ('%s, ' % (i + 1))
                    self.modifytext(text = 'textg', label = tg[:-2], x = (0.25, 0.98))
                else: self.modifytext(text = 'textg', label = '', x = None)

                ListB = [bool(2**self.I2C.lrec['Bmax'] &
                               int(i[self.DB.l['Door']]))
                                for i in self.DB.data]

                if (True in ListB):
                    tr = 'Warning: '
                    for i in range(len(ListB)):
                        if (ListB[i]): tr = tr + ('%s, ' % (i + 1))
                    self.modifytext(text = 'textr', label = tr[:-2], x = (0.75, 0.98))
                else: self.modifytext(text = 'textr', label = '', x = None)
                    
        if (self.phase == 10): ######## Scan finger

            ht = int(4*timer) % 5
            X0 = self.image.coords(self.anim)
            new = (1 + ht) * 0.1 * X0[0]
            self.image.coords(self.anim, X0[0], X0[1], X0[0] - new, X0[3])
            self.fpid = None
            self.FP.set_led(1)

            start = self.FP.is_finger_pressed()

            if (start is None):

                self.FP.set_led(0)
                self.show(16)
                return

            if (start):
                
                self.FP.set_led(0)
                self.show(11)
                return

            if (self.KP.key == 'F2') and (self.option > 1):

                self.FP.set_led(0)
                self.show(45)
                return

            if (self.KP.key == 'F4') or (timer > self.tmax):

                self.FP.set_led(0)
                self.reset()
                return

            return

        if (self.phase == 11): ######## Scanning finger

            v_op = 3                    ## Reading frequency:
            lt = self.cntr/v_op         ## Each reading takes place every "v_op" counts
            self.cntr = self.cntr + 1   ## Increase counter...
            
            X0 = self.image.coords(self.anim)
            d = (1/7) * self.resol['h'] * float(self.image.place_info()['relheight'])
            self.image.coords(self.anim, X0[0], d*(1 + lt), X0[2], d*(1 + lt))

            if (self.option == 1) and (int(lt) == float(lt)):   ## ----> OP: HIRE LOCKER

                if (lt == 0):                   ## Start detection...
                    self.fpid = self.FP.enroll_check()  ## Next empty ID in FPR
                    print("New finger ID: " + str(self.fpid))
                    if (self.fpid is None):     ## Case: no finger leaning
                        self.show(15)           ## --> PH:  Finger was removed
                    elif (self.fpid < 0):       ## Case: FP identified in memory
                        self.show(13)           ## --> PH:  Finger already registered
                    elif (not self.FP.enroll_start(self.fpid)):     ## Case: can't go on
                        self.show(16)           ## --> PH:  Sensor malfunction
                elif (0 < lt < 4):              ## Take 3 readings...
                    if (not self.FP.enroll_phase(int(lt))):
                        self.show(15)           ## --> PH:  Finger was removed
                elif (4 <= lt):                 ## After reading...
                    self.cntr = 0               ## Return reading timer to 0
                    self.FP.get_enrolled(log = True)    ## Show FP memory update
                    self.show(12)               ## --> PH: Finger not registered [OK]
                
            elif (self.option > 1) and (int(lt) == float(lt)):   ## ----> OP: OPEN/FREE/PAY
                
                if (lt < 3):                    ## Take 3 readings...
                    self.fpid = self.FP.identify()      ## Corresponding ID in FPR
                    print("Identified as: " + str(self.fpid))
                    if (self.fpid is None):     ## Case: no finger leaning 
                        self.show(15)           ## --> PH: Finger was removed
                    elif (self.fpid < 0):       ## Case: FP identified in memory
                        self.show(14)           ## --> PH: Finger not yet registered
                elif (3 <= lt):                 ## After reading...
                    self.cntr = 0               ## Return reading timer to 0
                    self.FP.get_enrolled(log = True)    ## Show FP memory update
                    self.show(12)               ## --> PH: Finger not registered [OK]

            return

        if (self.phase == 12): ######## Scan finger OK

            if (timer > self.tmax):

                if (self.option == 1):                                  ## ----> OP: HIRE LOCKER
                    self.show(30)                                       ## --> PH: Select locker
                    return

                else:

                    exps = 0
                    
                    if (self.fpid is not None) and (self.fpid >= 0):    ## For registered FP,
                        self.unit = self.DB.verifyFP(self.fpid + 1)     ## search for its locker,
                        self.date = self.DB.rDate(self.unit)            ## date of expiration and
                        exps = int(self.DB.rExpd(self.unit))            ## account state...
                        print(exps)
                        if (exps == 0):					## Error: Locker shouldn't be free
                            self.reset()                    		## Back to main menu
                            print("Information loss in process: exps")  ## Error warning
                            return
                    else:						## Error: User should have valid FP
                        self.reset()					## Back to main menu
                        print("Information loss in process: FP")    	## Error warning
                        return
                        
                    if (self.option == 2):                              ## ----> OP: OPEN LOCKER

                        if (exps == 1):                                 ## Red light: occupied
                            self.I2C.unlock(self.unit)                  ## Unlock door
                            self.I2C.readAll()
                            ds = 2*self.I2C.datarec[self.unit - 1][1] + self.I2C.datarec[self.unit - 1][0]
                            print('Lock state: ' + str(ds))
                            if (ds == 3):                                ## Both locks pulled (NOTE: last 2 bits must be 11!)
                                self.show(90)                           ## --> PH: Unlock OK
                            else: self.show(93)                         ## --> PH: Error unlocking 
                            return
                        elif (exps == 2):                               ## Blue light: expired 1
                            self.I2C.unlock(self.unit)                  ## Open door
                            self.I2C.readAll()
                            ds = 2*self.I2C.datarec[self.unit - 1][1] + self.I2C.datarec[self.unit - 1][0]
                            print('Lock state: ' + str(ds))
                            if (ds == 3):                                ## Both locks pulled (NOTE: last 2 bits must be 11!)
                                self.show(91)                           ## --> PH: Unlock OK with exp. warning
                            else: self.show(93)                         ## --> PH: Error unlocking
                            return
                        elif (exps == 3):                               ## Purple light: expired 2
                            self.show(92)                               ## --> PH: Access denied (exp.)
                            return
                        
                    if (self.option == 3):                              ## ----> OP: FREE LOCKER

                        if (exps == 1):                                 ## Red light: occupied
                            self.show(94)                               ## --> PH: Confirm free?
                            return
                        elif (exps > 1):                                ## Blue/Purple light: expired
                            self.show(96)                               ## --> PH: Free denied
                            return
                    
                    if (self.option == 4):                              ## ----> OP: PAY LOCKER

                        self.WA.on()
                        self.show(52)
                        return
    
        if (self.phase == 13): ######## Scan finger NO, already registered

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 14): ######## Scan finger NO, not yet registered

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 15): ######## Scan finger NO, finger removed

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 16): ######## Scan finger NO, sensor malfunction

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 30): ######## Select locker

            x = self.typelk()

            if (self.KP.key == 'F4') or (timer > self.tmax):

                self.reset()
                return

            if (x == 1):
                self.show(31) # Number OK
                return
            elif (x == 0):
                self.show(32) # Locker occupied
                return
            elif (x == -1):
                self.show(33) # Locker disabled
                return

        if (self.phase == 31): ######## Select OK, free locker

            if (timer > self.tmax):
            
                self.idle = False
                self.show(40)
                return

        if (self.phase == 32): ######## Select NO, occupied locker

            if (timer > self.tmax):
                
                self.idle = False
                self.show(30)
                return

        if (self.phase == 33): ######## Select NO, unavailable locker

            if (timer > self.tmax):
            
                self.idle = False
                self.show(30)
                return

        if (self.phase == 40): ######## Type new password 1st time

            x = self.typepw()

            if (x is not None):
                
                if (bool(x)):
                    if (True):
                        self.code = x
                        self.show(43)
                        return
                    else: pass # Password too easy (comparison)
                if (not bool(x)):
                    self.show(42)
                    return

            if (self.KP.key == 'F4') or (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 41):  ######## Password too easy

            if (timer > self.tmax):

                if (self.option == 1):

                    self.idle = False
                    self.show(40)
                    return
                
        if (self.phase == 42): ######## Password too short

            if (timer > self.tmax):

                if (self.option == 1):

                    self.idle = False
                    self.show(40)
                    return

        if (self.phase == 43): ######## Type new password 2nd time

            x = self.typepw()

            if (x is not None):
                
                if (x == self.code):
                    self.show(46)
                    return
                elif (x != self.code):
                    self.show(47)
                    return

            if (self.KP.key == 'F4') or (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 45): ######## Log with password

            x = self.typepw()                       ## Compare password to get locker n°
            
            if (x == True):
                self.I2C.unlock(self.unit)
                self.show(46)
                return
            elif (x == False):
                self.show(47)
                return
  
            if (self.KP.key == 'F2'):

                self.show(10)          
                return

            if (self.KP.key == 'F4') or (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 46): ######## Password OK

            if (timer > self.tmax):

                if (self.option == 1):

                    self.idle = False
                    self.WA.on()                            ## Turn on coin acceptor...
                    self.show(50)                           ## (now comes first payment screen)
                    return

                else:
                    
                    exps = 0
                    self.idle = False
                    self.fpid = self.DB.rFP(self.unit)      ## Search for locker's FP address,
                    self.date = self.DB.rDate(self.unit)    ## date of expiration and
                    exps = int(self.DB.rExpd(self.unit))    ## account state...
                    print(exps)
                    if (exps == 0):					## Error: Locker shouldn't be free
                        self.reset()                    		## Back to main menu
                        print("Information loss in process: exps")	## Error warning
                        return
                    if (self.fpid is None) or (self.fpid < 0):  	## Error: User should have valid FP
                        self.reset()					## Back to main menu
                        print("Information loss in process: FP")    	## Error warning
                        return

                    if (self.option == 2):

                        if (exps == 1):                                     ## Red light: occupied
                            self.I2C.unlock(self.unit)                      ## Unlock door
                            self.I2C.readAll()
                            ds = 2*self.I2C.datarec[self.unit - 1][1] + self.I2C.datarec[self.unit - 1][0]
                            print('Lock state: ' + str(ds))
                            if (ds == 3):                                    ## Both locks pulled (NOTE: last 2 bits must be 11!)
                                self.show(90)                               ## --> PH: Unlock OK
                            else: self.show(93)                             ## --> PH: Error unlocking 
                            return
                        elif (exps == 2):                                   ## Blue light: expired 1
                            self.I2C.unlock(self.unit)                      ## Open door
                            self.I2C.readAll()
                            ds = 2*self.I2C.datarec[self.unit - 1][1] + self.I2C.datarec[self.unit - 1][0]
                            print('Lock state: ' + str(ds))
                            if (ds == 3):                                    ## Both locks pulled (NOTE: last 2 bits must be 11!)
                                self.show(91)                               ## --> PH: Unlock OK with exp. warning                  ## Relock door
                            else: self.show(93)                             ## --> PH: Error unlocking
                            return
                        elif (exps == 3):                                   ## Purple light: expired 2
                            self.show(92)                                   ## --> PH: Access denied (exp.)
                            return
                        return

                    if (self.option == 3):
                
                        if (exps == 1):                                   ## Red light: occupied
                            self.show(94)                                   ## --> PH: Confirm free?
                            return
                        else:                                               ## Blue/Purple light: expired
                            self.show(96)                                   ## --> PH: Free denied
                            return

                    if (self.option == 4):
                
                        self.WA.on()
                        self.show(52)
                        return
                
        if (self.phase == 47): ######## Password incorrect

            if (timer > self.tmax):

                if (self.option == 1):

                    self.idle = False
                    self.show(43)
                    return

                if (self.option > 1):
                
                    self.idle = False
                    self.show(45)
                    return

        if (self.phase == 50): ######## Payment screen

            ht = int(4*timer) % 5
            X0 = self.image.coords(self.anim)
            new = (1 + ht) * X0[0]/2
            self.image.coords(self.anim, X0[0], X0[1], X0[0] + new, X0[1])

            if (self.WA.get()):

                self.WA.off()       ## Shutdown coin acceptor
                self.show(51)
                return

            if (self.KP.key == 'F4') or (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 51): ######## Payment OK

            if (timer > self.tmax):

                self.idle = False

                if (self.option == 1):

                    self.I2C.unlock(self.unit)
                    self.I2C.readAll()
                    ds = 2*self.I2C.datarec[self.unit - 1][1] + self.I2C.datarec[self.unit - 1][0]
                    print('Lock state: ' + str(ds))
                    if (ds == 3):                                    ## Both locks pulled (NOTE: last 2 bits must be 11!)
                        self.show(90)                               ## --> PH: Unlock OK
                    else: self.show(93)                             ## --> PH: Error unlocking 
                    return

                if (self.option >= 1):

                    self.reset()
                    return

        if (self.phase == 52): ######## Payment screen

            ht = int(4*timer) % 5
            X0 = self.image.coords(self.anim)
            new = (1 + ht) * X0[0] * 0.75
            self.image.coords(self.anim, X0[0], X0[1], X0[0] + new, X0[3])

            if (self.WA.get()):
                
                self.show(51)
                return

            if (self.KP.key == 'F4') or (timer > self.tmax):
            
                self.reset()
                return

        if (self.phase == 80): ######## Help menu

            if (self.KP.key == 'F1'):

                self.show(81)
                return

            if (self.KP.key == 'F2'):

                self.show(84)
                return

            if (self.KP.key == 'F3'):
                
                self.option = 4
                self.show(10)
                return
            
            if (self.KP.key == 'F4'):
                
                self.reset()
                return

        if (self.phase == 81): ######## Help & FAQs page 1

            if (self.KP.key == 'F3'):

                self.show(80)
                return

            if (self.KP.key == 'F4'):

                self.show(82)
                return

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 82): ######## Help & FAQs page 2

            if (self.KP.key == 'F3'):

                self.show(81)
                return

            if (self.KP.key == 'F4'):

                self.show(83)
                return

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 83): ######## Help & FAQs page 3

            if (self.KP.key == 'F3'):

                self.show(82)
                return

            if (self.KP.key == 'F4'):

                self.show(80)
                return

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 84): ######## About...

            if (self.KP.key == 'F4'):

                self.show(80)
                return

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 90): ######## Open OK

            v_an = 2
            
            self.cntr = self.cntr + 1
            lt = self.cntr/v_an
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])

            if (0 < lt <= 4):
                d = szx*(1/237)
                l2 = self.image.coords(self.anim2)
                self.image.coords(self.anim2, l2[0] - d, l2[1], l2[2] - d, l2[3],
                                              l2[4] - d, l2[5], l2[6] - d, l2[7])
                return
            
            if (5 < lt <= 10):
                dx, dy = szx*(1/237), szy*(3/280)
                l1 = self.image.coords(self.anim1)
                self.image.coords(self.anim1, l1[0], l1[1], l1[2] + dx, l1[3] + dy,
                                              l1[4] + dx, l1[5] + dy, l1[6], l1[7])
                return
            
            if (10 < lt <= 15):
                dx, dy = szx*(1/237), szy*(1/280)
                l1 = self.image.coords(self.anim1)
                self.image.coords(self.anim1, l1[0], l1[1], l1[2] + dx, l1[3] + dy,
                                              l1[4] + dx, l1[5] + dy, l1[6], l1[7])
                return
            
            if (lt >= 30):
                self.reset()
                return

        if (self.phase == 91): ######## Open with expiration warning

            v_an = 2
            
            self.cntr = self.cntr + 1
            lt = self.cntr/v_an
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])

            if (0 < lt <= 4):
                d = szx*(1/237)
                l2 = self.image.coords(self.anim2)
                self.image.coords(self.anim2, l2[0] - d, l2[1], l2[2] - d, l2[3],
                                              l2[4] - d, l2[5], l2[6] - d, l2[7])
                return
            
            if (5 < lt <= 10):
                dx, dy = szx*(1/237), szy*(3/280)
                l1 = self.image.coords(self.anim1)
                self.image.coords(self.anim1, l1[0], l1[1], l1[2] + dx, l1[3] + dy,
                                              l1[4] + dx, l1[5] + dy, l1[6], l1[7])
                return
            
            if (10 < lt <= 15):
                dx, dy = szx*(1/237), szy*(1/280)
                l1 = self.image.coords(self.anim1)
                self.image.coords(self.anim1, l1[0], l1[1], l1[2] + dx, l1[3] + dy,
                                              l1[4] + dx, l1[5] + dy, l1[6], l1[7])
                return
            
            if (lt >= 30):
                self.reset()
                return

        if (self.phase == 92): ######## Open NO, expiration warning

            if (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 93): ######## Open NO, lock disabled

            t_an = 3

            self.cntr = self.cntr + 1
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])
            
            if (self.cntr in range(0, 30, 2*t_an)):
                d = szx
                l2 = self.image.coords(self.anim2)
                self.image.coords(self.anim2, l2[0] + d, l2[1], l2[2] + d, l2[3],
                                              l2[4] + d, l2[5], l2[6] + d, l2[7])
                return
            
            if (self.cntr in range(t_an, 30, 2*t_an)):
                d = szx
                l2 = self.image.coords(self.anim2)
                self.image.coords(self.anim2, l2[0] - d, l2[1], l2[2] - d, l2[3],
                                              l2[4] - d, l2[5], l2[6] - d, l2[7])
                return
            
            if (self.cntr >= 30):
                self.reset()
                return

            return

        if (self.phase == 94): ######## Free preview

            if (self.KP.key == 'F2'):

                self.I2C.unlock(self.unit)
                self.I2C.readAll()
                ds = 2*self.I2C.datarec[self.unit - 1][1] + self.I2C.datarec[self.unit - 1][0]
                print('Lock state: ' + str(ds))
                if (ds == 3):                                    ## Both locks pulled (NOTE: last 2 bits must be 11!)
                    self.show(95)                               ## --> PH: Unlock OK
                else: self.show(93)                             ## --> PH: Error unlocking 
                return

            if (self.KP.key == 'F4') or (timer > self.tmax):

                self.reset()
                return

        if (self.phase == 95): ######## Free OK

            v_an = 2
            
            self.cntr = self.cntr + 1
            lt = self.cntr/v_an
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])

            if (0 < lt <= 4):
                d = szx*(1/237)
                l2 = self.image.coords(self.anim2)
                self.image.coords(self.anim2, l2[0] - d, l2[1], l2[2] - d, l2[3],
                                              l2[4] - d, l2[5], l2[6] - d, l2[7])
                return
            
            if (5 < lt <= 10):
                dx, dy = szx*(1/237), szy*(3/280)
                l1 = self.image.coords(self.anim1)
                self.image.coords(self.anim1, l1[0], l1[1], l1[2] + dx, l1[3] + dy,
                                              l1[4] + dx, l1[5] + dy, l1[6], l1[7])
                return
            
            if (10 < lt <= 15):
                dx, dy = szx*(1/237), szy*(1/280)
                l1 = self.image.coords(self.anim1)
                self.image.coords(self.anim1, l1[0], l1[1], l1[2] + dx, l1[3] + dy,
                                              l1[4] + dx, l1[5] + dy, l1[6], l1[7])
                return
            
            if (lt >= 30):
                self.reset()
                return

        if (self.phase == 96): ######## Free NO, expiration warning

            if (timer > self.tmax):

                self.reset()
                return

    def show(self, phase):

        self.phase = phase
        print('Pressed %s' % self.KP.key + '...\n')
        print('PHASE %s' % self.phase + '...\n')

        if (self.phase == 1): ######## Main menu
            
            self.tmax = float("inf")
            print(' ITBA presents... LCKRZ!!')
            print(' Please, select your option' + 1*'\n')
            print('  - F1: Hire Locker')
            print('  - F2: Open Locker')
            print('  - F3: Free Locker')
            print('  - F4: Help & Payment' + 2*'\n')
            self.fmenu()
            if not (0 in [self.DB.rExpd(i + 1) for i
                      in range(len(self.DB.data))]):
                self.modifyoption('R', label = '(NO Vacancy!)')
        
        if (self.phase == 10): ######## Scan finger
            
            self.tmax = 40
            print(' Time to scan your fingerprint')
            print(' Please, lean your thumb on the reader...\n')
            if (self.option > 1):
                print('  - F2: Use password')
            print('  - F4: Back to main' + 2*'\n')
            self.fscan()
            if (self.option > 1):
                self.modifyoption(option = 'G', label = 'Use password')

            X0 = [ 0.66 * self.resol['w'] * float(self.image.place_info()['relwidth']),
                   0.40 * self.resol['h'] * float(self.image.place_info()['relheight']),
                   0.10 * self.resol['w'] * float(self.image.place_info()['relwidth']) ]
            
            self.anim = self.image.create_line(X0[0], X0[1], 0, X0[1],
                        arrowshape = (X0[2], X0[2], X0[2]/2), width = X0[2],
                        fill = "green", arrow = LAST)

        if (self.phase == 11): ######## Scanning finger

            self.tmax = float("inf")
            print(' We are now scanning your fingerprint.')
            print(' Please... keep it in place, at least')
            print(' until we say so.' + 2*'\n')
            self.fscanning()

            X0 = [ 0.6 * self.resol['w'] * float(self.image.place_info()['relwidth']),
                   0.10 * self.resol['h'] * float(self.image.place_info()['relheight']),
                   0.10 * self.resol['w'] * float(self.image.place_info()['relwidth']) ]

            self.anim = self.image.create_line(X0[0], X0[1], 0, X0[1],
                                              width = X0[2]/4, fill = "blue")
            
        if (self.phase == 12): ######## Scan finger OK

            self.tmax = 2
            print(' Fingerprint scanning OK!! :)')
            self.fscanok()
            if (self.fpid is not None):
                txt = '0'*(4 - len(str(self.fpid))) + str(self.fpid)
                print(' (FPID: #' + txt + ')' + 2*'\n')
                txt = self.texts['comnt'].cget("text") + '\n' + ' (FPID: #' + txt + ')'
                self.texts['comnt'].config(text = txt)
            
        if (self.phase == 13): ######## Scan finger NO, already registered

            self.tmax = 2
            print(' Your fingerprint is already registered')
            print(' in our database: there cannot be more')
            print(' than one locker per user...' + 2*'\n')
            self.fscanx1()
            
        if (self.phase == 14): ######## Scan finger NO, not yet registered

            self.tmax = 2
            print(' Our database does not hold your fingerprint...')
            print(' Please register first or contact maintenance,')
            print(' if you have previously done.' + 2*'\n')
            self.fscanx2()
            
        if (self.phase == 15): ######## Scan finger NO, finger removed

            self.tmax = 2
            print(' Please, make sure your finger remains in the')
            print(' scanner until we tell you. Otherwise, please')
            print(' tell a supervisor if you are doing right and')
            print(' this keeps happening.' + 2*'\n')
            self.fscanx3()

        if (self.phase == 16): ######## Scan finger NO, sensor malfunction

            self.tmax = 2
            print(' Fingerprint sensor malfunction: Please,')
            print(' contact your nearest supervisor as soon')
            print(' as possible.' + 2*'\n')
            self.fscanx4()

        if (self.phase == 30): ######## Select locker

            self.tmax = 30
            print('-----------------------')
            print('Select one free locker:')
            print('-----------------------')
            self.fselect()
            self.grid()

        if (self.phase == 31): ######## Select OK, free locker
            
            self.tmax = 1
            Ad = ":) Locker OK!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = Ad, x = (0.75, 0.5))
            self.modifytext(text = 'textr', label = None, x = None)
            self.idle = True

        if (self.phase == 32): ######## Select NO, occupied locker
            
            self.tmax = 1
            Ad = ":( Locker occupied!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = None, x = None)
            self.modifytext(text = 'textr', label = Ad, x = (0.75, 0.5))
            self.idle = True

        if (self.phase == 33): ######## Select NO, unavailable locker
            
            self.tmax = 1
            Ad = ":( Locker unavailable!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = None, x = None)
            self.modifytext(text = 'textr', label = Ad, x = (0.75, 0.5))
            self.idle = True

        if (self.phase == 40): ######## Type new password 1st time

            self.tmax = 45
            print(' We may now require that you register a 6-digit long')
            print(' password, to use in case of any issue regarding the')
            print(' fingerprint sensor. You can always access with it,')
            print(' instead of using your finger' + 1*'\n')
            print('  - F4: Back to main' + 2*'\n')
            self.fpass()
            
        if (self.phase == 41): ######## Password too easy

            self.tmax = 1
            Ad = ":( Password too easy!!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = '', x = None)
            self.modifytext(text = 'textr', label = Ad, x = (0.75, 0.5))
            self.idle = True
            
        if (self.phase == 42): ######## Password too short

            self.tmax = 1
            Ad = ":( Password too short!!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = '', x = None)
            self.modifytext(text = 'textr', label = Ad, x = (0.75, 0.5))
            self.idle = True
            
        if (self.phase == 43): ######## Type new password 2nd time

            self.tmax = 45
            x = 'Please, rewrite password to verify validity' 
            x = x + '\n' + 'and proceed to payment screen.'
            print(x)
            print('  - F4: Back to main' + 2*'\n')
            self.modifytext(text = 'small', label = x, x = (0.75, 0.25))
            
        if (self.phase == 45): ######## Log with password
            
            self.tmax = 45
            print(' Please enter your locker number, followed by your')
            print(' password, altogether; as if it was just a single')
            print(' number...' + 1*'\n')
            print('  - F2: Use fingerprint')
            print('  - F4: Back to main' + 2*'\n')
            self.FP.set_led(0)
            self.fpassw()

        if (self.phase == 46): ######## Password OK
            
            self.tmax = 1
            Ad = ":) Password OK!!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = Ad, x = (0.75, 0.5))
            self.modifytext(text = 'textr', label = '', x = None)
            self.idle = True

        if (self.phase == 47): ######## Password incorrect
            
            self.tmax = 1
            Ad = ":( Password incorrect!!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = '', x = None)
            self.modifytext(text = 'textr', label = Ad, x = (0.75, 0.5))
            self.idle = True
        
        if (self.phase == 50): ######## Payment screen (reg)

            print(' =============================== ')
            print(' LOCKER:   %s' % self.unit)
            print(' ADDRESS:  %s' % self.fpid)
            print(' PASSWORD: %s' % self.code)
            print(' =============================== ')

            self.tmax = 60
            print(' Please, insert token in slot to finish the')
            print(' enrollment process. Otherwise, ask to your')
            print(' nearest supervisor about where to purchase')
            print(' them, and restart the process.\n')
            t1 = Data.today()
            t2 = Data.then(self.DB.exptime, self.DB.expunit)
            print('  - Today:')
            print('    %s/%s/%s, %s:%s' % (t1[1], t1[2], t1[0], t1[3], t1[4]))
            print('  - Future expiration date:')
            print('    %s/%s/%s, %s:%s' % (t2[1], t2[2], t2[0], t2[3], t2[4]))
            print('  - F4: Back to main' + 2*'\n')
            self.fpayreg(self.unit, t1, t2)

            X0 = [ 0.15 * self.resol['w'] * float(self.image.place_info()['relwidth']),
                   0.25 * self.resol['h'] * float(self.image.place_info()['relheight']),
                   0.10 * self.resol['w'] * float(self.image.place_info()['relwidth']) ]

            self.anim = self.image.create_line(X0[0], X0[1], 3*X0[0], X0[1],
                        arrowshape = (X0[2], X0[2], X0[2]/2), width = X0[2],
                        fill = "red", arrow = LAST)

        if (self.phase == 51): ######## Payment OK

            self.tmax = 1
            Ad = ":) Payment OK!!"
            print(Ad + 2*"\n")
            self.modifytext(text = 'textg', label = Ad, x = (0.25, 0.5))
            self.modifytext(text = 'textr', label = '', x = None)
            if (self.option == 1):
                self.register()
                self.I2C.datasnd[self.unit - 1] = [1,0,0,0,0,0,0,1]
            if (self.option == 4):
                t0 = X.DB.rDate(self.unit)
                t = Data.addDate(t0, X.DB.exptime, X.DB.expunit)
                self.DB.wDate(self.unit, t)
                print('Updated locker database:')
                {print(i) for i in self.DB.data}
            self.idle = True

        if (self.phase == 52): ######## Payment screen (pay)

            self.tmax = 60
            print(' Please, insert token in slot to update your account')
            print(' status. Locker %s"s expirement date will then be' % self.unit)
            print(' postponed %s %s...\n' % (self.DB.exptime, self.DB.expunit))
            print('  - F4: Back to main' + 2*'\n')
            t1 = self.DB.rDate(self.unit)
            t2 = Data.addDate(t1, self.DB.exptime, self.DB.expunit)
            print('  - Present expiration date:')
            print('    %s/%s/%s, %s:%s' % (t1[1], t1[2], t1[0], t1[3], t1[4]))
            print('  - Future expiration date:')
            print('    %s/%s/%s, %s:%s' % (t2[1], t2[2], t2[0], t2[3], t2[4]))
            print('  - F4: Back to main' + 2*'\n')
            self.fpay(self.unit, t1, t2)

            X0 = [ 0.15 * self.resol['w'] * float(self.image.place_info()['relwidth']),
                   0.25 * self.resol['h'] * float(self.image.place_info()['relheight']),
                   0.10 * self.resol['w'] * float(self.image.place_info()['relwidth']) ]

            self.anim = self.image.create_line(X0[0], X0[1], 3*X0[0], X0[1],
                        arrowshape = (X0[2], X0[2], X0[2]/2), width = X0[2],
                        fill = "red", arrow = LAST)

        if (self.phase == 80): ######## Help menu
            
            self.tmax = float("inf")
            print(' You are now in the Help menu' + 1*'\n')
            print('  - F1: Help guide')
            print('  - F2: FAQs guide')
            print('  - F3: Payment')
            print('  - F4: Back to main' + 2*'\n')
            self.fmenu2()

        if (self.phase == 81): ######## Help & FAQs page 1

            self.tmax = 30
            print(' Here goes "help" page 1')
            self.fhpage1()
            
        if (self.phase == 82): ######## Help & FAQs page 2

            self.tmax = 30
            print(' Here goes "help" page 2')
            self.fhpage2()

        if (self.phase == 83): ######## Help & FAQs page 3

            self.tmax = 30
            print(' Here goes "FAQs" page')
            self.fhpage3()

        if (self.phase == 84): ######## About...

            self.tmax = 30
            print(' Here goes "about" page')
            self.fabout()

        if (self.phase == 90): ######## Open OK

            if (self.option == 1):
                t = Data.then(self.DB.exptime, self.DB.expunit)
            else: t = self.DB.rDate(self.unit)
            print(' Door n°%s is now unlocked and ready to open.' % self.unit)
            print(' It will remain unlocked for 10 seconds until')
            print(' opened. Please, close your locker properly')
            print(' after its use. Expiration date: %s/%s/%s' % (t[0], t[1], t[2]))
            print('\n')
            self.fopenok(self.unit, t[0], t[1], t[2])
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])
            l1 = [ [0.96*szx, 0.14*szy], [0.38*szx, 0.14*szy],
                   [0.38*szx, 0.49*szy], [0.96*szx, 0.49*szy] ]
            l2 = [ [0.34*szx, 0.29*szy], [0.28*szx, 0.29*szy],
                   [0.28*szx, 0.33*szy], [0.34*szx, 0.33*szy] ]

            self.anim1 = self.image.create_polygon(l1[0][0], l1[0][1], l1[1][0], l1[1][1],
                                                   l1[2][0], l1[2][1], l1[3][0], l1[3][1],
                                                   fill = 'red', width = 5, outline = 'black')
            self.anim2 = self.image.create_line(l2[0][0], l2[0][1], l2[1][0], l2[1][1],
                                                l2[2][0], l2[2][1], l2[3][0], l2[3][1],
                                                fill = 'white', width = 5)
                  
        if (self.phase == 91): ######## Open with expiration warning
            
            y = self.DB.rDate(self.unit)[0]
            m = self.DB.rDate(self.unit)[1]
            d = self.DB.rDate(self.unit)[2]
            print(' Door n°%s is now unlocked and ready to open.' % self.unit)
            print(' Remember to update your payment due status.')
            print(' Otherwise, we may block your access during')
            print(' the next 10 days. Expiration date: %s/%s/%s' % (m, d, y))
            print('\n')
            self.fopenoke(self.unit, y, m, d)
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])
            l1 = [ [0.96*szx, 0.14*szy], [0.38*szx, 0.14*szy],
                   [0.38*szx, 0.49*szy], [0.96*szx, 0.49*szy] ]
            l2 = [ [0.34*szx, 0.29*szy], [0.28*szx, 0.29*szy],
                   [0.28*szx, 0.33*szy], [0.34*szx, 0.33*szy] ]

            self.anim1 = self.image.create_polygon(l1[0][0], l1[0][1], l1[1][0], l1[1][1],
                                                   l1[2][0], l1[2][1], l1[3][0], l1[3][1],
                                                   fill = 'red', width = 5, outline = 'black')
            self.anim2 = self.image.create_line(l2[0][0], l2[0][1], l2[1][0], l2[1][1],
                                                l2[2][0], l2[2][1], l2[3][0], l2[3][1],
                                                fill = 'white', width = 5)

        if (self.phase == 92): ######## Open NO, expiration warning
            
            y = self.DB.rDate(self.unit)[0]
            m = self.DB.rDate(self.unit)[1]
            d = self.DB.rDate(self.unit)[2]
            print(' Door n°%s has been blocked until payment due' % self.unit)
            print(' status is updated. Otherwise, locker may be')
            print(' released for the general public after 20 days')
            print(' since the last expiration date: %s/%s/%s' % (m, d, y))
            print('\n')
            self.fopenx1(self.unit, y, m, d)

        if (self.phase == 93): ######## Open NO, lock disabled

            self.tmax = 4
            print(' Your locker is facing issues related to the')
            print(' electronic lock mechanism. Please, tell your')
            print(' nearest maintenance agent as soon as possible.')
            print('\n')
            self.fopenx2(self.unit)
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])
            l1 = [ [0.96*szx, 0.14*szy], [0.38*szx, 0.14*szy],
                   [0.38*szx, 0.49*szy], [0.96*szx, 0.49*szy] ]
            l2 = [ [0.38*szx, 0.25*szy], [0.24*szx, 0.25*szy],
                   [0.24*szx, 0.38*szy], [0.38*szx, 0.38*szy] ]
            
            self.anim1 = self.image.create_polygon(l1[0][0], l1[0][1], l1[1][0], l1[1][1],
                                                   l1[2][0], l1[2][1], l1[3][0], l1[3][1],
                                                   width = 5, outline = 'black', fill = 'red')
            self.anim2 = self.image.create_polygon(l2[0][0], l2[0][1], l2[1][0], l2[1][1],
                                                   l2[2][0], l2[2][1], l2[3][0], l2[3][1],
                                                   width = 2, outline = 'yellow', fill = '')

        if (self.phase == 94): ######## Free preview

            self.tmax = 20
            print(' Locker %s will open for one last time, and your' % self.unit)
            print(' fingerprint will be deleted from our databases.')
            print(' Are you sure you want to unsuscribe from your locker service?')
            print('\n')
            self.ffree(self.unit)

        if (self.phase == 95): ######## Free OK

            self.tmax = 4
            print(' Locker %s is now unlocked for one last time. You´ve now got 20' % self.unit)
            print(' seconds to retrieve your stuff. Please, do not forget anything')
            print(' inside after closing. If you do, you will have to hire it again.')
            self.ffreeok(self.unit)
            print(' (FPID to delete: %s)' % self.fpid)
            self.FP.delete(self.fpid)
            self.FP.get_enrolled(log = True)    ## Show FP memory update
            self.DB.wLine(self.unit, ['0']*len(self.DB.l))
            print('Updated locker database:')
            {print(i) for i in self.DB.data}
            szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
            szy = self.resol['h'] * float(self.image.place_info()['relheight'])
            l1 = [ [0.96*szx, 0.14*szy], [0.38*szx, 0.14*szy],
                   [0.38*szx, 0.49*szy], [0.96*szx, 0.49*szy] ]
            l2 = [ [0.34*szx, 0.29*szy], [0.28*szx, 0.29*szy],
                   [0.28*szx, 0.33*szy], [0.34*szx, 0.33*szy] ]

            self.anim1 = self.image.create_polygon(l1[0][0], l1[0][1], l1[1][0], l1[1][1],
                                                   l1[2][0], l1[2][1], l1[3][0], l1[3][1],
                                                   fill = 'red', width = 5, outline = 'black')
            self.anim2 = self.image.create_line(l2[0][0], l2[0][1], l2[1][0], l2[1][1],
                                                l2[2][0], l2[2][1], l2[3][0], l2[3][1],
                                                fill = 'white', width = 5)
                  
        if (self.phase == 96): ######## Free NO, expiration warning

            self.tmax = 2
            print(' Locker %s cannot be freed, due to pending debt in your register.' % self.unit)
            print(' Please, get in terms with your payment status as soon as possible,')
            print(' and then try again.')
            print('\n')
            self.ffreex(self.unit)

        self.then = time.time()

    def register(self):

        v = [ self.fpid + 1, self.code, 0, 1]
        v = v + Data.then(self.DB.exptime, self.DB.expunit)

        self.DB.wLine(self.unit, v)

    def typepw(self):

        if (self.option == 1):

            x = None
            if (self.KP.key == ''): return
            elif (self.KP.key.isdigit() == True) and (len(self.typo) < 6):
                self.then = time.time()
                self.typo = self.typo + self.KP.key
                self.texts['large'].config(text = len(self.typo)*' x')
                return
            elif (self.KP.key == '*'):
                self.then = time.time()
                self.typo = self.typo[:-1]
                self.texts['large'].config(text = len(self.typo)*' x')
                return
            elif (self.KP.key == '#'):
                if (len(self.typo) == 6):
                    self.then = time.time()
                    print('typed: ' + str(self.typo))
                    code = self.typo
                    self.typo = ''
                    self.texts['large'].config(text = len(self.typo)*' x')
                    return code
                elif (len(self.typo) <= 5):
                    return False
                
        else:
        
            x = None
            if (self.KP.key == ''): return
            elif (self.KP.key.isdigit() == True) and (len(self.typo) < 7):
                self.then = time.time()
                self.typo = self.typo + self.KP.key
                self.texts['large'].config(text = self.typo[:1] + len(self.typo[1:])*' x')
                return
            elif (self.KP.key == '*'):
                self.then = time.time()
                self.typo = self.typo[:-1]
                self.texts['large'].config(text = self.typo[:1] + len(self.typo[1:])*' x')
                return
            elif (self.KP.key == '#') and (len(self.typo) == 7):
                self.then = time.time()
                print('typed: ' + str(self.typo))
                unit, code = self.typo[0], self.typo[1:]
                if (self.DB.verifyPW(int(unit), code) == True):
                    self.unit, self.code = int(unit), code
                    self.typo = ''
                    return True
                else:
                    self.typo = ''
                    return False

    def typelk(self):

        x = None
        if (self.KP.key == ''): return
        elif (self.KP.key.isdigit() == True) and (len(self.typo) < 3):
            self.then = time.time()
            self.typo = self.typo + self.KP.key
            self.texts['large'].config(text = self.typo)
        elif (self.KP.key == '*'):
            self.then = time.time()
            self.typo = self.typo[:-1]
            self.texts['large'].config(text = self.typo)
            return
        elif (self.KP.key == '#'):
            self.then = time.time()
            print('typed unit: ' + str(self.typo))
            unit = int(self.typo)
            self.typo = ''
            if (self.DB.verifyUN(unit) == True):
                self.unit = unit
                return 1
            elif (self.DB.verifyUN(unit) == False):
                return 0
            elif (self.DB.verifyUN(unit) is None):
                return -1
            else:
                return None

    def grid(self):

        szx = self.resol['w'] * float(self.image.place_info()['relwidth'])
        szy = self.resol['h'] * float(self.image.place_info()['relheight'])

        N = len(self.DB.data)
        Npi = None
        rows = 4
        cmin = 2
        cols = (cmin - 1)*(N <= 4) + math.ceil(N/rows)

        M = list(range(1, N + 1))
        if (Npi is not None): M.insert(Npi - 1, 0)
        M = M + [0]*(rows*cols - len(M))

        X = []
        for col in range(cols):
            X.append(M[rows*col : rows*(col + 1)])

        grid1, grid2 = {}, {}
        xmin, xmax = 0.025*szx, 0.850*szx
        ymin, ymax = 0.125*szy, 0.875*szy
        dx = (xmax - xmin)/cols
        dy = (ymax - ymin)/rows
        lx, ly = dx*7/8, dy*7/8
        for col in range(cols):
            for row in range(rows):
                locker = X[col][row]
                if (locker == 0): c = 'gray'
                else:
                    if (self.DB.rExpd(locker) == 0): c = 'green'
                    else: c = 'red'
                x0, y0 = xmin + col*dx, ymin + row*dy
                p = [ x0, y0, x0, y0 + ly, x0 + lx, y0 + ly, x0 + lx, y0 ]
                grid1[col, row] = self.image.create_polygon(p[0], p[1], p[2], p[3],
                                                            p[4], p[5], p[6], p[7],
                                                             width = 2, fill = c)
                grid2[col, row] = self.image.create_text(x0 + lx/2, y0 + ly/2,
                                text = ('' if (locker == 0) else str(locker)),
                                           fill = 'white', font = 'Arial 20')

    def comm(self):

        exps = 0
        self.after(500, self.comm)

        
        for slave in range(len(self.I2C.slaves)):
            exps = self.DB.rExpd(slave + 1)
            expv = self.I2C.adapt(exps, 2, -1)
            vec = self.I2C.datasnd[slave]
            self.I2C.datasnd[slave] = expv + vec[2:]

        self.I2C.update()

        for unit in range(len(self.DB.data)):
            doorv = self.I2C.datarec[unit]
            doors = self.I2C.adapt(doorv, 8, -1)
            self.DB.wDoor(unit + 1, doors)

        self.DB.update()
                
    def reset(self):

        print('Database:')
        {print(x) for x in self.DB.data}
        if (self.option == 1) and (not self.phase in [51, 90, 93]):
            self.FP.delete(self.fpid)
            self.FP.get_enrolled(log = True)    ## Show FP memory update
        self.WA.off()                           ## Shutdown coin acceptor
        self.option = 0
        self.fpid = None
        self.unit = 0
        self.code = None
        self.typo = ''
        self.says = ''
        self.cntr = 0
        self.then = time.time()
        self.show(1)
        time.sleep(0.33)
        return

    def restart(self):

        self.DB.data = [['0']*len(self.DB.l)]*len(self.DB.data)
        self.DB.update()
        self.FP.delete()
        self.FP.get_enrolled(log = True)    ## Show FP memory update
        print('Restarting...')

    def kill(self):

        self.FP.set_led(0)
        self.WA.off()
        GPIO.cleanup()
        self.destroy()

if (__name__ == "__main__"):

    try:

        X = Cycle()

        def destroy(event = None):
            X.kill()

        X.bind('<Escape>', destroy)

        X.mainloop()

    finally: destroy()
