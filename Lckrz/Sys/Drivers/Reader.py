import codecs
import logging
import signal

import serial
import time

__author__ = 'Moon Kwon Kim <mkdmkk@gmail.com>'

logging.basicConfig(format="[%(name)s][%(asctime)s] %(message)s")
logger = logging.getLogger("reader")
logger.setLevel(logging.INFO)


class reader():

    COMMENDS = {
        'None': 0x00,               # Default value for enum (returns Error)
        'Open': 0x01,               # Open Initialization
        'Close': 0x02,              # Close Termination
        'UsbInternalCheck': 0x03,   # Check if connected USB device is valid
        'ChangeBaudrate': 0x04,     # Change UART baud rate
        'SetIAPMode': 0x05,         # IAP mode, for Firmware Upgrade
        'CmosLed': 0x12,            # Control CMOS LED
        'GetEnrollCount': 0x20,     # Get enrolled fingerprint count
        'CheckEnrolled': 0x21,      # Check if said ID is already enrolled
        'EnrollStart': 0x22,        # Start an enrollment
        'Enroll1': 0x23,            # Make 1st template
        'Enroll2': 0x24,            # Make 2nd template
        'Enroll3': 0x25,            # Make 3rd template, enroll into database
        'IsPressFinger': 0x26,      # Check if finger is placed on the sensor
        'DeleteID': 0x40,           # Delete the fingerprint with said ID
        'DeleteAll': 0x41,          # Delete all fingerprints from database
        'Verify': 0x50,             # Verify fingerprint image with said ID
        'Identify': 0x51,           # Identify fingerprint image in database
        'VerifyTemplate': 0x52,     # Verify fingerprint template with said ID
        'IdentifyTemplate': 0x53,   # Identify fingerprint image in database
        'CaptureFinger': 0x60,      # Capture fingerprint image (256p)
        'MakeTemplate': 0x61,       # Make template for transmission
        'GetImage': 0x62,           # Download captured fingerprint image (256p)
        'GetRawImage': 0x63,        # Capture & download raw image (320x240)
        'GetTemplate': 0x70,        # Download template of said ID
        'SetTemplate': 0x71,        # Upload template of said ID
        'GetDatabaseStart': 0x72,   # Start database download (obsolete)
        'GetDatabaseEnd': 0x73,     # End database download (obsolete)
        'UpgradeFirmware': 0x80,    # Upgrade Firmware (not supported)
        'UpgradeISOCDImage': 0x81,  # Upgrade ISO/CD image (not supported)
        'Ack': 0x30,                # Acknowledge.
        'Nack': 0x31 }              # Non-acknowledge
    

    PACKET_RES_0 = 0x55
    PACKET_RES_1 = 0xAA
    PACKET_DATA_0 = 0x5A
    PACKET_DATA_1 = 0xA5

    ACK = 0x30
    NACK = 0x31


    def __init__(self, port, baud=115200, timeout=1):
        self.port = port
        self.baud = baud
        self.timeout = timeout
        self.ser = None
        self.init()
        self.get_enrolled(log = True)

    def __del__(self):
        self.close_serial()

    def init(self):
        try:
            self.ser = serial.Serial(self.port, baudrate=self.baud, timeout=self.timeout)
            time.sleep(1)
            connected = self.open_serial()
            if not connected:
                self.ser.close()
                baud_prev = 9600 if self.baud == 115200 else 115200
                self.ser = serial.Serial(self.port, baudrate=baud_prev, timeout=self.timeout)
                if not self.open_serial():
                    raise Exception()
                if self.open():
                    self.change_baud(self.baud)
                    logger.info("The baud rate is changed to %s." % self.baud)
                self.ser.close()
                self.ser = serial.Serial(self.port, baudrate=self.baud, timeout=self.timeout)
                if not self.open_serial():
                    raise Exception()
            logger.info("Serial connected.")
            self.open()
            self._flush()
            self.close()
            return True
        except Exception as e:
            logger.error("Failed to connect to the serial.")
            logger.error(e)
        return False

    def open_serial(self):
        if not self.ser:
            return False
        if self.ser.isOpen():
            self.ser.close()
        self.ser.open()
        time.sleep(0.1)
        connected = self.open()
        if connected is None:
            return False
        if connected:
            self.close()
            return True
        else:
            return False

    def close_serial(self):
        if self.ser:
            self.ser.close()

    def is_connected(self):
        if self.ser and self.ser.isOpen():
            return True
        return False

    def _send_packet(self, cmd, param=0):
        cmd = reader.COMMENDS[cmd]
        param = [int(hex(param >> i & 0xFF), 16) for i in (0, 8, 16, 24)]

        packet = bytearray(12)
        packet[0] = 0x55
        packet[1] = 0xAA
        packet[2] = 0x01
        packet[3] = 0x00
        packet[4] = param[0]
        packet[5] = param[1]
        packet[6] = param[2]
        packet[7] = param[3]
        packet[8] = cmd & 0x00FF
        packet[9] = (cmd >> 8) & 0x00FF
        chksum = sum(bytes(packet[:10]))
        packet[10] = chksum & 0x00FF
        packet[11] = (chksum >> 8) & 0x00FF
        if self.ser and self.ser.writable():
            self.ser.write(packet)
            return True
        else:
            return False

    def _flush(self):
        while self.ser.readable() and self.ser.inWaiting() > 0:
            p = self.ser.read(self.ser.inWaiting())
            if p == b'':
                break

    def _read(self):
        if self.ser and self.ser.readable():
            try:
                p = self.ser.read()
                if p == b'':
                    return None
                return int(codecs.encode(p, 'hex_codec'), 16)
            except:
                return None
        else:
            return None

    def _read_header(self):
        if self.ser and self.ser.readable():
            firstbyte = self._read()
            secondbyte = self._read()
            return firstbyte, secondbyte
        return None, None

    def _read_packet(self, wait=True):
        """

        :param wait:
        :return: ack, param, res, data
        """
        # Read response packet
        packet = bytearray(12)
        while True:
            firstbyte, secondbyte = self._read_header()
            if not firstbyte or not secondbyte:
                if wait:
                    continue
                else:
                    return None, None, None, None
            elif firstbyte == reader.PACKET_RES_0 and secondbyte == reader.PACKET_RES_1:
                break
        packet[0] = firstbyte
        packet[1] = secondbyte
        p = self.ser.read(10)
        packet[2:12] = p[:]

        # Parse ACK
        ack = True if packet[8] == reader.ACK else False

        # Parse parameter
        param = bytearray(4)
        param[:] = packet[4:8]
        if param is not None:
            param = int(codecs.encode(param[::-1], 'hex_codec'), 16)

        # Parse response
        res = bytearray(2)
        res[:] = packet[8:10]
        if res is not None:
            res = int(codecs.encode(res[::-1], 'hex_codec'), 16)

        # Read data packet
        data = None
        if self.ser and self.ser.readable() and self.ser.inWaiting() > 0:
            firstbyte, secondbyte = self._read_header()
            if firstbyte and secondbyte:
                # Data exists.
                if firstbyte == reader.PACKET_DATA_0 and secondbyte == reader.PACKET_DATA_1:
                    data = bytearray()
                    data.append(firstbyte)
                    data.append(secondbyte)
        if data:
            while True:
                n = self.ser.inWaiting()
                p = self.ser.read(n)
                if len(p) == 0:
                    break
                data.append(p)
            data = int(codecs.encode(data[::-1], 'hex_codec'), 16)

        return ack, param, res, data

    def open(self):
        if self._send_packet("Open"):
            ack, _, _, _ = self._read_packet(wait=False)
            return ack
        return None

    def close(self):
        if self._send_packet("Close"):
            ack, _, _, _ = self._read_packet()
            return ack
        return None

    def set_led(self, on):
        if self._send_packet("CmosLed", 1 if on else 0):
            ack, _, _, _ = self._read_packet()
            return ack
        return None

    def count_enrolled(self):
        if self._send_packet("GetEnrollCount"):
            ack, param, _, _ = self._read_packet()
            return param if ack else -1
        return None

    def is_finger_pressed(self):
        if self._send_packet("IsPressFinger"):
            ack, param, _, _ = self._read_packet()
            if not ack:
                return None
            return True if param == 0 else False
        else:
            return None

    def change_baud(self, baud=115200):
        if self._send_packet("ChangeBaudrate", baud):
            ack, _, _, _ = self._read_packet()
            return True if ack else False
        return None

    def capture_finger(self, best=False):
        
        param = 0 if not best else 1
        if self._send_packet("CaptureFinger", param):
            ack, _, _, _ = self._read_packet()
            return ack
        return None       

    def enroll_check(self, idx = None):   # Goes in "main"

        # Check whether the finger already exists or not
        logger.info("Checking existence...")
        idx0 = self.identify()          # Check if fingerprint enrolled
        
        if (idx0 is None): return None  # Finger removed in process
        if (idx0 >= 0): return -1       # Fingerprint already enrolled
        
        if (idx is None):               # No ID specified
            idx = self.get_free()       # Use first one free
            if (idx is None):           # No ID free
                return -2               # No space in memory

        logger.info("Enroll with the ID: " + str(idx))
        return idx

    def enroll_start(self, idx):

        self.set_led(1)
        logger.info("Start enrolling in ID: %s..." % idx)
        while (True):
            if (self._send_packet("EnrollStart", idx)):
                ack, _, _, _ = self._read_packet()
                if (ack):
                    self.set_led(0)
                    return True
                if (cnt >= 5):
                    self.set_led(0)
                    return False
                cnt = cnt + 1
                time.sleep(0.1)
                
        return None

    def enroll_phase(self, phase):
        
        self.set_led(1)
        logger.info("Executing enrollment %s..." % phase)
        cnt = 0
        while (True):
            if (self.capture_finger()):
                break
            if (cnt >= 5): return False
            cnt = cnt + 1    
        cnt = 0
        while (True):
            if (self._send_packet("Enroll" + str(phase))):
                ack, _, _, _ = self._read_packet()
                if (ack):
                    time.sleep(0.1)
                    self.set_led(0)
                    return True
            if (cnt >= 5):
                    time.sleep(0.1)
                    self.set_led(0)
                    return False
            cnt = cnt + 1 
        return None

    def enroll(self, idx = None):

        idx = self.enroll_check(idx)
        if (idx is None) or (idx < 0):
            idx = self.get_free()
        if (idx < 0):
            return logger.info("Already enrolled")
        self.enroll_start(idx)
        self.enroll_phase(1)
        self.enroll_phase(2)
        self.enroll_phase(3)
        self.identify()
        
    def get_enrolled(self, idx = None, log = False):
        
        res = None
        vec = []
        if (idx is None):
            # Enlist which IDs are enrolled (takes time)
            for i in range(200):
                res = self._send_packet("CheckEnrolled", i)
                ack, _, _, _ = self._read_packet()
                if (ack): vec.append(i)
            if (log): logger.info('Enrolled IDs: %s' % vec)
            return vec
        else:
            # See if said ID is enrolled
            res = self._send_packet("CheckEnrolled", idx)
            ack, _, _, _ = self._read_packet()
            if res:    
                return ack
        return None

    def get_free(self):

        res = None
        # Search for first vacant ID (time depends on memory)
        for i in range(200):
            res = self._send_packet("CheckEnrolled", i)
            ack, _, _, _ = self._read_packet()
            if not (ack): return i
        return None
        
    def delete(self, idx = None):
        
        res = None
        if idx is None:
            # Delete all fingerprints
            print('Deleting all...')
            res = self._send_packet("DeleteAll")
        else:
            # Delete just said fingerprint
            print('Deleting %s...' % idx)
            res = self._send_packet("DeleteID", idx)
        if res:
            ack, _, _, _ = self._read_packet()
            return ack
        return None

    def identify(self):
        
        self.set_led(1)
        if not self.capture_finger():
            self.set_led(0)
            return None
        if self._send_packet("Identify"):
            ack, param, _, _ = self._read_packet()
            if ack:
                logger.info("Finger identified as ID: %s" % param)
                self.set_led(0)
                return param
            else:
                logger.info("Finger not identified")
                self.set_led(0)
                return -1
        return None

    def logprint(self, string):

        logger.info('%s' % string)
    
if (__name__ == '__main__'):

    f = reader('/dev/ttyS0')

    def signal_handler(signum, frame):
        f.close_serial()
        signal.signal(signal.SIGINT, signal_handler)
