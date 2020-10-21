from tkinter import *
import PIL
from PIL import ImageTk

class bue(Tk):

    def __init__(self, **kwargs):

        Tk.__init__(self,**kwargs)
        self.geometry('400x400+100+100')
        self.canvas = Canvas(self, bg = 'White', width = 300, height = 300)
        self.canvas.place(relx = 0.5, rely = 0.5, anchor = CENTER,
                          relwidth = 0.75, relheight = 0.75)

        self.img = PIL.Image.open("/home/pi/Documents/LCKRZ/Core/GUI/Images/logo1.gif")
        self.img = self.img.resize((300, 300), PIL.Image.ANTIALIAS)
        self.phimg = ImageTk.PhotoImage(self.img)
        self.phimg = self.canvas.create_image(0,0, anchor=NW, image = self.phimg)

root = bue()

root.mainloop()
