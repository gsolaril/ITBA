from tkinter import *
from PIL import Image as Img
from PIL import ImageTk as ImgTk
import sys, os, csv

addons = [ 'menu',
           'scan',
           'scanning',
           'scanok',
           'scanx1',
           'scanx2',
           'scanx3',
           'scanx4',
           'select',
           'passr',
           'passw',
           'payreg',
           'pay',
           'menu2',
           'openok',
           'openoke',
           'openx1',
           'openx2',
           'free',
           'freeok',
           'freex',
           'hpage1',
           'hpage2',
           'hpage3',
           'about' ]

command = 'from GUI import '

for addon in addons:
    command = command + addon + ', '

exec(command[: -2])


class GUI(Tk):

    def __init__(self, **kwargs):

        Tk.__init__(self, **kwargs)

        # ------------------------------- Parameters:

        self.bcolor = 'cyan'
        self.fcolor = 'black'
        self.lfont = ('Arial', '24')
        self.sfont = ('Arial', '20')
        self.cfont = ('Arial', '12')
        self.resol = {'h': self.winfo_screenheight(),
                      'w': self.winfo_screenwidth() }

        print('Screen resolution = '
              + str(self.resol['w'])
              + 'x' + str(self.resol['h']))
                    
        # ------------------------------- Basics:
            
        self.title('StoBro v1.1')
        self.configure(background = self.bcolor)
        self.attributes("-fullscreen",True)
        self.geometry(str(self.resol['h']) + 'x' +
                      str(self.resol['w']) + '+0+0')

        # ------------------------------- Buttons:

        self.buttons = { 'R': (0.05, 0.75, 1),
                         'G': (0.05, 0.85, 1),
                         'B': (0.88, 0.75, -1),
                         'Y': (0.88, 0.85, -1) }

        self.options = { 'R': Button(self, bg = 'red'),
                         'G': Button(self, bg = 'green'),
                         'B': Button(self, bg = 'blue'),
                         'Y': Button(self, bg = 'yellow') }

        # ------------------------------- Button labels:

        self.names = { 'R': Label(self, font = self.sfont,
                                  bg = self.bcolor, fg = self.fcolor),
                       'G': Label(self, font = self.sfont,
                                  bg = self.bcolor, fg = self.fcolor),
                       'B': Label(self, font = self.sfont,
                                  bg = self.bcolor, fg = self.fcolor),
                       'Y': Label(self, font = self.sfont,
                                  bg = self.bcolor, fg = self.fcolor) }
        
        # ------------------------------- Texts:

        self.texts = { 'large': Label(self, font = self.lfont,
                                      bg = self.bcolor, fg = self.fcolor),
                       'small': Label(self, font = self.sfont,
                                      bg = self.bcolor, fg = self.fcolor),
                       'comnt': Label(self, font = self.cfont,
                                      bg = self.bcolor, fg = self.fcolor),
                       'textr': Label(self, font = self.sfont,
                                      bg = self.bcolor, fg = 'Red'),
                       'textg': Label(self, font = self.sfont,
                                      bg = self.bcolor, fg = 'Green') }
        
        # ------------------------------- Canvas:

        self.image = Canvas(self, bg = self.bcolor, highlightthickness = 0)

        # ------------------------------- Create phase index:

        self.index = self.create_index()

    def modifyoption(self, option, label = None):
        
        if (label == None):
            self.options[option].place_forget()
            self.names[option].place_forget()
            self.names[option].config(text = None)
        else:
            x = 0.7 + self.buttons[option][2]
            self.names[option].config(text = label)
            self.names[option].place(relx = self.buttons[option][0] + 0.050*x,
                                     rely = self.buttons[option][1] + 0.050)
            self.options[option].place(relx = self.buttons[option][0],
                                       rely = self.buttons[option][1],
                                       relwidth = 0.07, relheight = 0.1)
            if (option == 'R') or (option == 'G'):
                self.names[option].place(anchor = W)
            if (option == 'B') or (option == 'Y'):
                self.names[option].place(anchor = E)

    def modifytext(self, text, label = None, x = None):

        if (x == None) or (len(x) != 2):
            self.texts[text].config(text = None)
            self.texts[text].place_forget()
        else:
            self.texts[text].config(text = label)
            self.texts[text].place(relx = x[0], rely = x[1], anchor = CENTER)
        return

    def modifyimage(self, filename = None, x1 = None, x2 = None):
        
        if (filename == None) or (x1 == None) or (x2 == None):
            self.image.place_forget()
        else:
            self.image.delete("all")
            address = '/home/pi/Documents/LCKRZ/Core/GUI/Images/' + filename
            pw = int((x2[0] - x1[0]) * self.resol['w'])
            ph = int((x2[1] - x1[1]) * self.resol['h'])
            # Resize PIL image to "(pw ; ph)"
            self.temp = Img.open(address)
            self.temp = self.temp.resize((pw, ph), Img.ANTIALIAS)
            self.temp = ImgTk.PhotoImage(self.temp)
            self.image.image = self.image.create_image(0, 0,
                                       image = self.temp, anchor = NW)
            self.image.place(relx = x1[0], rely = x1[1], anchor = NW,
                                        relwidth = x2[0] - x1[0],
                                       relheight = x2[1] - x1[1])           
    def create_index(self):

        index = { }
        read = csv.reader(open('GUI/Index.csv'))
        for row in read:
            index[row[1]] = int(row[0])

        return index

    def fmenu(self):

        return menu.run(self)

    def fscan(self):

        return scan.run(self)

    def fscanning(self):

        return scanning.run(self)

    def fscanok(self):

        return scanok.run(self)

    def fscanx1(self):

        return scanx1.run(self)

    def fscanx2(self):

        return scanx2.run(self)

    def fscanx3(self):

        return scanx3.run(self)

    def fscanx4(self):

        return scanx4.run(self)

    def fselect(self):

        return select.run(self)

    def fpayreg(self, unit, t1, t2):

        return payreg.run(self, unit, t1, t2)

    def fpay(self, unit, t1, t2):

        return pay.run(self, unit, t1, t2)

    def fpass(self):

        return passr.run(self)

    def fpassw(self):

        return passw.run(self)

    def fopenok(self, unit, y, m, d):

        return openok.run(self, unit, y, m, d)

    def fopenoke(self, unit, y, m, d):

        return openoke.run(self, unit, y, m, d)

    def fopenx1(self, unit, y, m, d):

        return openx1.run(self, unit, y, m, d)

    def fopenx2(self, unit):

        return openx2.run(self, unit)

    def ffree(self, unit):

        return free.run(self, unit)

    def ffreeok(self, unit):

        return freeok.run(self, unit)
    
    def ffreex(self, unit):

        return freex.run(self, unit)

    def fmenu2(self):

        return menu2.run(self)

    def fhpage1(self):

        return hpage1.run(self)
    
    def fhpage2(self):

        return hpage2.run(self)
    
    def fhpage3(self):

        return hpage3.run(self)

    def fabout(self):

        return about.run(self)   
