import smbus
import time

"""--------------------------------------------------------- [ I2C ]
 - Four Arduinos as slaves, Raspberry as master.                   I
 - Each Arduino linked to: * pin 11 and 12: (in) lock sensors      I
                           * pin A3: (in) door sensor              I
 Raspberry sends:          * pin 13: (out) LED (lock pulse)        I
   * Address byte.                                                 I
   * Bit 0/7 corresponding to "is locker occupied" info,           I
   * Bit 1/7 corresponding to "is locker expired" info,            I 
   * Bit 2/7 corresponding to "open door" action,                  I
   * Bits 3 to 6 not used at the moment.                           I
   * Bit 7/7 corresponding to "disable locker" action,             I
   * This is done towards all registered lockers...                I
     (in this case, from 1 to 4)                                   I
 Arduino receives data and:                                        I
   * Displays "Slave received message"                             I
   * Activates/deactivates LED depending on bit 0/7 and 1/7,       I
   * Opens door according to bit 2/7,                              I
   * Reports uplink to RPi by bit 6/7                              I
   * Goes idle and stops paying attention to RPi by bit 7/7        I
 Then, Arduino sends:                                              I
   * Bit 0/7 corresponding to lock 1 state (True = unlocked)       I
   * Bit 1/7 corresponding to lock 2 state (True = unlocked)       I
   * Bit 2/7 corresponding to latch signal (True = unlock)         I
   * Bit 3/7 corresponding to door state. (True = closed)          I
   * Bit 4/7 as an open door timer warning.                        I
   * Bit 5/7 as a door error timer warning.                        I
   * Bit 6 not used at the moment                                  I
   * Bit 7/7 as a disconnection report (True = linked to RPi)      I
   * This is done by all registered lockers...                     I
     (in this case, by 1 to 4)                                     I
   * Then prints "Slave to Master chain sent" on serial monitor.   I
-----------------------------------------------------------------"""

class I2C():

    def __init__(self):

        self.bus = smbus.SMBus(1)
        self.lrec = { 'Slk1': 0, 'Slk2': 1, 'Ltch': 2, 'Door': 3,
                      'Omax': 4, 'Bmax': 5, 'Vcn0': 6, 'Idle': 7 }
        self.lsnd = { 'Lred': 0, 'Lblu': 1, 'Open': 2, 'Idle': 3,
                      'Vcn1': 4, 'Vcn2': 5, 'Vcn3': 6, 'Vcn4': 7 }
        self.slaves = self.detect()
        
        self.datarec = [[0, 0, 0, 0, 0, 0, 0, 0]] * len(self.slaves)
        self.datasnd = [[0, 0, 0, 0, 0, 0, 0, 1]] * len(self.slaves)

        print('Units detected: %s' % self.slaves)

        self.list = [ ]

    def detect(self):

        slaves = [ ]
        for i in range(128):
            try:
                self.bus.write_byte(i, 0)
                slaves.append(i)
            except:
                pass
        self.slaves = slaves
        return self.slaves
    
    def adapt(self, arg, size, flip = 1):

        if (isinstance(arg, list)):
            vec = arg[: : flip]
            vec = ''.join([str(n) for n in vec])
            num = '0b00' + vec
            return eval(num)
        else:
            num = bin(int(arg))
            vec = list(num)[2 :]
            vec = [int(n) for n in vec]
            vec = [0]*(size - len(vec)) + vec
            vec = vec[len(vec) - size :]
            return vec[: : flip]

    def read(self, locker):
        
        slave = locker - 1
        add = self.slaves[slave]
        num = self.bus.read_byte(add)
        rec = self.adapt(num, 8, -1)
        disp = "".join([str(n) for n in rec])
        print("REC(" + str(add) + ") = " + str(disp) + " ; ", end = "")
        if (rec[7] == 0):
            self.datarec[slave] = rec
        return rec

    def readAll(self):

        for slave in range(len(self.slaves)):
            self.read(slave + 1)
        print()
        return self.datarec
        
    def write(self, locker):

        slave = locker - 1
        add = self.slaves[slave]
        vec = self.datasnd[slave]
        snd = self.adapt(vec, 8, -1)
        self.bus.write_byte(add, snd)
        disp = "".join([str(n) for n in vec])
        print("SND(" + str(add) + ") = " + str(disp) + " ; ", end = "")
        self.datasnd[slave] = [0, 0, 0, 0, 0, 0, 0, 1]
        
        return snd

    def writeAll(self):
        
        for slave in range(len(self.slaves)):
            self.write(slave + 1)
        print()
        return self.datasnd

    def update(self):
        
        if (__name__ == "__main__"):
            print('='*29)
        self.writeAll()
        self.readAll()

    def disable(self, locker, input_type = 'unit'):

        if (input_type == 'unit'):
            slave = locker - 1
            address = self.slaves[slave]
        elif (input_type == 'address'):
            address = locker
            slave = self.slaves.index(address)
        else:
            return
        
        print('...disabling %X' % address)
        vec = self.datasnd[slave]
        vec[self.lsnd['Idle']] = 1
        self.datasnd[slave] = vec
        self.update()

    def unlock(self, locker, input_type = 'address'):

        if (input_type == 'unit'):
            slave = locker - 1
            address = self.slaves[slave]
        elif (input_type == 'address'):
            address = locker
            slave = self.slaves.index(address)
        else:
            return
        
        print('...unlocking %X' % address)
        self.datasnd[slave] = [1, 0, 1, 0, 0, 0, 0, 1]
        self.update()
        self.readAll()
  
if (__name__ == "__main__"): I = I2C()
