
#include <DHT.h>

int pin = 2;
int mod = 22;
boolean x = 1;

DHT dht(pin, mod);
char valorserial;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  x = !x;
  int T = dht.readTemperature();
  int H = dht.readHumidity();
  Serial.print(x);
  Serial.print(") ");
  Serial.print("T: ");
  Serial.print(T);
  Serial.print("*C ; ");
  Serial.print("H: ");
  Serial.print(H);
  Serial.println("%");
  delay(5000);
}
