#include <Wire.h>

boolean enable = HIGH;
boolean X_close = LOW;
boolean X_lock1 = LOW;
boolean X_lock2 = LOW;
boolean X_latch = LOW;
int N = 1;
int stat = 0;

const byte M[][5] = { { 9, 10,  8,  7, 1},
                      { 7,  8,  9, 10, 1},
                      {10,  9,  8,  7, 0},
                      { 7,  8, 10,  9, 0} };

const byte LEDs[] = {M[N-1][0], M[N-1][1], M[N-1][2], M[N-1][3]};
const byte BINs[] = {5, 3, 4, 2, 6};
const byte SENs[] = {A3, 11, 12};
const byte BTNs[] = {A0, A1, A2};
const byte lock = 13;
int i = 0;
int r[] = {0, 0, 0, 0, 0, 0, 0, 0};
int s[] = {0, 0, 0, 0, 0, 0, 0, 0};
int b[] = {1, 2, 4, 8, 16, 32, 64, 128};

unsigned long int t_opd = 0; long int t_opd_max = 300000;
unsigned long int t_bad = 0; long int t_bad_max = 30000;
unsigned long int t_unl = 0; long int t_unl_max = 60000;
unsigned long int t_upd = 0; long int t_upd_ref = 500;
unsigned long int t = 0;
boolean rel = HIGH;

void setup()
    
  { pinMode(lock, OUTPUT);
    digitalWrite(lock, HIGH);
    Serial.begin(9600);
    Serial.println("Ready to go!");
    Wire.begin(N);
    Wire.onReceive(rec);
    Wire.onRequest(snd);
    for (i = 0; i < sizeof(LEDs); i++)
      { pinMode(LEDs[i], OUTPUT);
        digitalWrite(LEDs[i], LOW); }
    for (i = 0; i < sizeof(BTNs); i++)
      { pinMode(BTNs[i], OUTPUT);
        digitalWrite(BTNs[i], LOW); }
    for (i = 0; i < sizeof(BINs); i++)
      { pinMode(BINs[i], OUTPUT);
        digitalWrite(BINs[i], LOW); }
    for (i = 0; i < sizeof(SENs); i++)
      { pinMode(SENs[i], INPUT); }
    display(N); }
    
void loop()

  { if (enable == HIGH) // ----------------------------------------- LOCKER ON
  
      { X_close = 1*(analogRead(SENs[0]) > 1000); // door sensor
        X_lock1 = 1*(digitalRead(SENs[1]));       // lock sensor 1
        X_lock2 = 1*(digitalRead(SENs[2]));       // lock sensor 2
        X_latch = 1*(!digitalRead(lock));         // latch coil

        if (digitalRead(BTNs[1]) == 1)
          { display(50 + stat); }
        else
          { display(N); }
                
        if (X_close == LOW)
          { if (X_latch == LOW)
              { if ((X_lock1 == LOW) && (X_lock2 == LOW))
                  { digitalWrite(LEDs[0], LOW); // door wouldn't open
                    digitalWrite(LEDs[1], LOW); // because door is locked
                    stat = 0;
                    s[4] = 0; t_opd = 0;   // door is closed
                    s[5] = 0; t_bad = 0; } // and stuff is secure
                if (X_lock1 != X_lock2)
                  { digitalWrite(LEDs[0], HIGH); // door wouldn't open
                    digitalWrite(LEDs[1], HIGH); // because door is partially locked
                    stat = 1;
                    s[4] = 0; t_opd = 0;   // door is closed
                    s[5] = 0; t_bad = 0; } // and stuff is secure
                if ((X_lock1 == HIGH) && (X_lock2 == HIGH))
                  { digitalWrite(LEDs[0], LOW); // door could easily open
                    digitalWrite(LEDs[1], HIGH); // because door is unlocked
                    stat = 2;
                    s[4] = 0; t_opd = 0;  // it's worse than an open door
                    if (t_bad == 0) { t_bad = millis(); } } } // --> TELL RASPBERRY
            else
              { if ((X_lock1 && X_lock2) == LOW) // latch can't unlock completely
                  { digitalWrite(LEDs[0], LOW); // door wouldn't open
                    digitalWrite(LEDs[1], HIGH); // because door is not unlocked
                    stat = 3;
                    s[4] = 0; t_opd = 0;   // door is still closed
                    s[5] = 0; t_bad = 0; } // and it's still secure
                else  // latch was unlocked properly
                  { digitalWrite(LEDs[0], HIGH); // door is able to open (SHOULD PWM)
                    digitalWrite(LEDs[1], LOW); // because door is unlocked
                    stat = 4;
                    s[4] = 0; t_opd = 0;       // door is still closed
                    s[5] = 0; t_bad = 0; } } } // though it's secure
        else
          { if (X_latch == LOW)
              { if ((X_lock1 == LOW) && (X_lock2 == LOW))
                  { digitalWrite(LEDs[0], HIGH); // door is already opened
                    digitalWrite(LEDs[1], LOW); // and latches are already locked
                    stat = 5;
                    s[5] = 0; t_bad = 0; // stuff is being used
                    if (t_opd == 0) { t_opd = millis(); } } // --> tell raspberry             
                if (X_lock1 != X_lock2)
                  { digitalWrite(LEDs[0], HIGH); // door is already opened
                    digitalWrite(LEDs[1], HIGH); // but latches are not totally locked
                    stat = 6;
                    s[5] = 0; t_bad = 0; // stuff is being used
                    if (t_opd == 0) { t_opd = millis(); } } // --> tell raspberry
                if ((X_lock1 == HIGH) && (X_lock2 == HIGH))
                  { digitalWrite(LEDs[0], LOW); // door won't properly close
                    digitalWrite(LEDs[1], HIGH); // because latches can't lock
                    stat = 7;
                    s[4] = 0; t_opd = 0; // so stuff won't be secure
                    if (t_bad == 0) { t_bad = millis(); } } } // --> TELL RASPBERRY
            else
              { if ((X_lock1 && X_lock2) == LOW) // latch can't unlock completely
                  { digitalWrite(LEDs[0], HIGH); // door can't really be open
                    digitalWrite(LEDs[1], HIGH); // because door wasn't properly unlocked
                    stat = 8;
                    s[4] = 0; t_opd = 0; // and it should be reported
                    if (t_bad == 0) { t_bad = millis(); } } // --> TELL RASPBERRY
                else  // latch was unlocked properly
                  { digitalWrite(LEDs[0], HIGH); // door is able to open (SHOULD PWM)
                    digitalWrite(LEDs[1], LOW); // because door was unlocked
                    stat = 9;
                    s[4] = 0; t_bad = 0; rel = HIGH; // then latches should release
                    if (t_opd == 0) { t_opd = millis(); } } } } // --> tell raspberry

        digitalWrite(LEDs[2], r[0]);
        digitalWrite(LEDs[3], r[1]);

        s[0] = X_lock2;
        s[1] = X_lock1;
        s[2] = X_latch;
        s[3] = X_close;
        s[4] = (t_opd > 0) && (millis() - t_opd > t_opd_max);
        s[5] = (t_bad > 0) && (millis() - t_bad > t_bad_max);
        s[6] = 0;
        s[7] = 0;

        if (X_latch)
          { t = millis() - t_unl;
            if ((t >= t_unl_max) || X_close)
              { Serial.print("LOCK RELEASE");
                digitalWrite(lock, HIGH);
                rel = LOW; t = 0;} }
        
        if (r[3] == 1)
          { enable = 0;
            for (i = 0; i >= 7; i++)
              { r[i] = 0; s[i] = 0; } }

        // Serial monitor update every 1/2 secs          
        if ((millis()/t_upd_ref != t_upd) && (enable == HIGH))
          { t_upd = millis()/t_upd_ref;
            Serial.println("====== Status report ======");
            Serial.print("Comb: ");
            Serial.print(X_close); Serial.print(X_latch);
            Serial.print(X_lock1); Serial.print(X_lock2);
            Serial.print(" (Case: " + String(stat) + ")\n");
            if (X_latch)
              { Serial.print("Unlock time: ");
                Serial.print(String(float(t/100)/10) + "\n"); } }

        delay(5); }

    else  // ------------------------------------------------------- LOCKER OFF

      { s[7] = 1;
        for (i = 0; i <= sizeof(LEDs); i++)
        { digitalWrite(LEDs[i], !digitalRead(LEDs[i])); display(0); }
        if (digitalRead(BTNs[0])) { enable = HIGH; } } }

void snd()

  { byte xs = 0;
    Serial.println("======== Comm. SND ========");
    Serial.print("Sending ");
    for (i = 0; i <= 7; i++)
      { xs = xs + b[i]*s[i];
        Serial.print(String(s[i]) + ","); }
    Wire.write(xs);
    Serial.print("=> " + String(xs) + "\n");
    Wire.begin(N); }

void rec(int xr)

  { noInterrupts();
    xr = byte(Wire.read());
    Serial.println("======== Comm. REC ========");
    Serial.print("Received ");
    if (bitRead(xr, 2) == 1)
      { digitalWrite(lock, LOW);
        t_unl = millis(); }
    if (bitRead(xr, 7) == 1)
      { for (i = 0; i <= 7; i++)
          { r[i] = bitRead(xr, i); 
            Serial.print(String(r[i]) + ","); } }
    Serial.print("\n");
    interrupts();}

void display(int select)

  { byte dig0 = (select % 10);
    digitalWrite(BINs[4], M[N-1][4]);
    for (i = 0; i <= 3; i++)
      { digitalWrite(BINs[i],bitRead(dig0, i)); }
    delay(1);
    byte dig1 = (select - dig0) / 10;
    digitalWrite(BINs[4], !M[N-1][4]);
    for (i = 0; i <= 3; i++)
      { digitalWrite(BINs[i],bitRead(dig1, i)); } }
