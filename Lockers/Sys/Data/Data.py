import sys
import RPi.GPIO as GPIO
from time import *
import datetime
import csv
 
class base():

    def __init__(self, filename, exptime, expunit):

        self.l = { 'Memo': 0, 'Code': 1, 'Door': 2,
                   'Expd': 3, 'Eyrs': 4, 'Emon': 5,
                   'Eday': 6, 'Ehrs': 7, 'Emin': 8 }

        self.doc = '/home/pi/Documents/LCKRZ/Core/Data/' + filename

        self.data = [ ]

        self.exptime = exptime
        self.expunit = expunit

        read = csv.reader(open(self.doc))
        for row in read:
            self.data.append(row)

        print('Initial locker database:')
        {print(i) for i in self.data}
        self.update()

    def rLine(self, locker):

        return list(map(int, self.data[locker - 1]))

    def wLine(self, locker, cont):

        self.data[locker - 1] = cont

    def rDate(self, locker):

        return list(map(int, self.data[locker - 1][self.l['Eyrs']:]))

    def wDate(self, locker, cont):

        cont = [str(x) for x in cont]
        self.data[locker - 1][self.l['Eyrs']:] = cont

    def rExpd(self, locker):

        return int(self.data[locker - 1][self.l['Expd']])

    def wExpd(self, locker, cont):

        self.data[locker - 1][self.l['Expd']] = str(cont)

    def rDoor(self, locker):

        return int(self.data[locker - 1][self.l['Door']])

    def wDoor(self, locker, cont):

        self.data[locker - 1][self.l['Door']] = str(cont)

    def rFP(self, locker):

        return int(self.data[locker - 1][self.l['Memo']])-1

    def wFP(self, locker, address):

        self.data[locker - 1][self.l['Memo']] = str(address)

    def verifyFP(self, address):

        for unit in range(len(self.data)):
            if (self.rFP(unit + 1) + 1 == address):
                return int(unit + 1)

    def rPW(self, locker):

        if (locker != 0) and (locker <= len(self.data)):
            return self.data[locker - 1][self.l['Code']]
        else: return None

    def wPW(self, locker, password):
        
        self.data[locker - 1][self.l['Code']] = str(password)

    def verifyPW(self, locker, password):

        return (str(self.rPW(locker)) == str(password))

    def verifyUN(self, locker):

        if (not (1 <= locker <= len(self.data))): return None
        else:
            if (self.rExpd(locker) == 0): return True
            else: return False
        return None

    def update(self):

        for unit in range(len(self.data)):
            l = len(self.l)
            expdate = self.rDate(unit + 1)
            if (expdate == [0, 0, 0, 0, 0]):
                self.wLine(unit + 1, ['0']*l)
            else:
                expleft = left(expdate, self.expunit)
                if (expleft >= 0):
                    self.wExpd(unit + 1, 1)
                if (expleft < 0):
                    self.wExpd(unit + 1, 2)
                if (expleft < -self.exptime * 1/3):
                    self.wExpd(unit + 1, 3)
                if (expleft < -self.exptime * 2/3):
                    self.wExpd(unit + 1, 0)
                    self.wLine(unit + 1, [0]*l)
        
        with open(self.doc, "w") as csvfile:
            write = csv.writer(csvfile, delimiter = ',')
            for row in self.data:
                write.writerow(row)

def today():
    t = datetime.datetime.now()
    v = [int(t.year), int(t.month), int(t.day), int(t.hour), int(t.minute)]
    return v

def tic():
    t = datetime.datetime.now()
    ms = ((t.hour*60 + t.minute)*60 + t.second)*1e6 + t.microsecond
    return ms
   
def addDate(date, time, unit):

    t1 = datetime.datetime(date[0], date[1], date[2], date[3], date[4])

    if (unit == 'days'):
        dt = datetime.timedelta(days = time)
    elif (unit == 'hours'):
        dt = datetime.timedelta(hours = time)
    elif (unit == 'minutes'):
        dt = datetime.timedelta(minutes = time)
    else:
        return

    t2 = t1 + dt
    v = [int(t2.year), int(t2.month), int(t2.day), int(t2.hour), int(t2.minute)]
    return v

def then(time, unit):

    return addDate(today(), time, unit)

def difDate(day1, day2, unit):

    t1 = datetime.datetime(day1[0], day1[1], day1[2], day1[3], day1[4])
    t2 = datetime.datetime(day2[0], day2[1], day2[2], day2[3], day2[4])

    if (t2 >= t1):
        dt = t2 - t1
        sign = 1
    else:
        dt = t1 - t2
        sign = -1

    if (unit == 'days'):
        dt = sign*(int(dt.days))
        return dt
    elif (unit == 'hours'):
        dt = sign*(int(dt.days*24) + int(dt.seconds/3600))
        return dt
    elif (unit == 'minutes'):
        dt = sign*(int(dt.days*1440) + int(dt.seconds/60))
        return dt

def left(date, unit):

    return difDate(today(), date, unit)

if (__name__ == "__main__"):
    file = 'Data.csv'
    D = base(file, 31, 'days')
