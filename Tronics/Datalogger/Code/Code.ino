#include <SPI.h>
#include <SD.h>
#include <DHT.h>
#include <Wire.h>

const int CS = 10;
String logName = "DL";
String logCode = "";
String fileName = "";
int fileNumber = 1;
int fileExtent = 0;
uint8_t Rsec = 6, Rmin = 10,
Nver = 0, Nsec = 0, Nmin = 0, Nhrs = 0,
Nwkd = 0, Nday = 0, Nmon = 0, Nyrs = 0; 
String Date = "";
String Time = "";
String Line = "";
float T = 0.0;
float H = 0.0;
int pin = 2;
int mod = 22;
boolean card = true;
boolean start = true;
boolean Fsec = true;
boolean Fmin = true;
boolean RTC = true;
File dirFile, logFile;

DHT dht(pin, mod);

void setup()
  { Serial.begin(9600);
    while (!Serial) {}
    if (!SD.begin(CS))
      { card = false;
        Serial.println("xxx Card failed xxx");
        return; }
    else
      { Serial.println("--> Card OK");
        dirFile = SD.open("Dir.txt", FILE_WRITE);
        fileNumber = dirFile.position();
        fileExtent = int(log10(fileNumber));
        if (fileExtent > 5)
          { Serial.println("xxx Log creation failed xxx"); }
        else
          { card = true;
            if (dirFile)
              { dirFile.print(String(0));
                dirFile.close(); }
                for (int i = 1; i <= 4 - fileExtent; i++)
                  { logCode = logCode + '0'; }
                logCode = logCode + String(fileNumber);
                logName = logName + logCode;
                Serial.println("--> Preparing FILE " + logName + ":"); } }
    if (RTC)
      { Wire.begin();
        Serial.println("--> RTC OK"); }
    else
      { Serial.println("--> NO RTC"); } }

void loop()
  { if (watch(RTC))
      { if (start)
          { start = false;
            if ((fileExtent < 5) && card)
              { fileName = logName + ".csv";
                logFile = SD.open(fileName, FILE_WRITE);
                Serial.println("--------------------");
                Serial.println("Date;Time;T[*C];H[%]");
                Serial.println("--------------------");
                if (logFile)
                  { logFile.println("Date;Time;T[*C];H[%]"); }
                else
                  { Serial.println("xxx WRITE ERROR (1)"); } }
            else
              { Serial.println("xxx WRITE ERROR (2)"); } }
        if ((Nsec % Rsec == 0) && Fsec)
          { Fsec = false;
            T = dht.readTemperature();
            H = dht.readHumidity();
            Date = String(Nday) + "/" + String(Nmon) + "/" + String(Nyrs);
            Time = String(Nhrs) + ":" + String(Nmin) + ":" + String(Nsec);
            Line = Date + ";" + Time + ";" + String(T) + ";" + String(H);
            Serial.println(Line); }
        if ((Nmin % Rmin == 0) && Fmin)
          { Fmin = false;
            if ((fileExtent < 5) && card)
              { logFile = SD.open(fileName, FILE_WRITE);
                if (logFile)
                  { logFile.println(Line);
                    Serial.println("--> Last data logged"); }
                else
                  { Serial.println("xxx WRITE ERROR (3)"); } }
            else
              { Serial.println("xxx WRITE ERROR (4)"); } }
        logFile.close();
        if (Nsec % Rsec != 0)
          { Fsec = true; }
        if (Nmin % Rmin != 0)
          { Fmin = true; } }
  else
    { Serial.println("xxx COMM ERROR"); }
  delay(500); }

bool watch(bool X)
  { if (X)
      { Wire.beginTransmission(0x68);
        Wire.write(0x00);
        if (Wire.endTransmission() != 0)
          { return false; }
        Wire.requestFrom(0x68, 8);
        Nsec = convert(Wire.read());
        Nmin = convert(Wire.read());
        Nhrs = convert(Wire.read());
        Nwkd = convert(Wire.read());
        Nday = convert(Wire.read());
        Nmon = convert(Wire.read());
        Nyrs = convert(Wire.read());
        Nver = convert(Wire.read());
        return true; }
    else
      { unsigned long int s = millis()/1000;
        Nsec = (s) % 60;
        Nmin = (s / (60)) % 60;
        Nhrs = (s / (60*60)) % 24;
        Nwkd = 0;
        Nday = (s / (60*60*24)) % 30 + 1;
        Nmon = (s / (60*60*24*30)) % 12 + 1;
        Nyrs = 18;
        Nver = 0;
        return true; } }

uint8_t convert(uint8_t x)
  { return ((x/16*10) + (x % 16)); }

