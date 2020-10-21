from tkinter import *

class H(Tk):

    def __init__(self):

        Tk.__init__(self)
        geo = (400, 400)

        self.geometry(str(geo[0]) + 'x' + str(geo[1]) + '+0+0')

        self.cx = 0.5
        self.cy = 0.5
        self.cw = 0.8
        self.ch = 0.8

        self.C = Canvas(self, bg = 'White')
        self.C.place(relx = self.cx, rely = self.cy,
                        relwidth = self.cw,
                        relheight = self.ch,
                        anchor = CENTER)

        self.ax = 0.7*geo[0]
        self.ay = 0.5*geo[1]
        self.aw = 0.2*geo[0]
        self.ah = 0.1*geo[1]

        ah = self.ah

        self.y1 = self.C.create_oval(0, 0, 0, 0, arrowshape = (ah, ah, ah/2),
                                    fill = 'green', width = ah, arrow = LAST)
        self.y2 = self.C.create_line(0, 0, 0, 0, arrowshape = (ah, ah, ah/2),
                                    fill = 'green', width = ah, arrow = LAST)

        self.i = 0
        self.modify()

    def modify(self):
        
        self.i = self.i + 1 if (self.i < 4) else 1
        self.C.coords(self.y, self.ax, self.ay, self.ax-self.aw*self.i/2, self.ay)
                              

        self.after(250, self.modify)

if __name__ == "__main__":

    root = H()
