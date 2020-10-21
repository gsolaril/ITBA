#include <SPI.h>
#include <SD.h>

const int CS = 10;
String logName = "DL";
String logCode = "";
String fileName = "";
int fileNumber = 1;
int fileExtent = 0;
int Tsec = 0;
int Tmin = 0;
int Thrs = 0;
int Tday = 0;
String Time = "";
String Line = "";
float T = ;
float H = ;

void setup() {
  Serial.begin(9600);
  while (!Serial) {}
  if (!SD.begin(CS)) {
    Serial.println("xxx Card failed xxx");
    return; }
  Serial.println("--> Card OK");
  File dirFile = SD.open("Dir.txt", FILE_WRITE);
  fileNumber = dirFile.position();
  fileExtent = int(log10(fileNumber));
  if (fileExtent > 5) {
    Serial.println("xxx Log creation failed xxx"); }
  else {
    if (dirFile) {
      dirFile.print(String(0));
      dirFile.close(); }
    for (int i = 1; i <= 4 - fileExtent; i++) {
      logCode = logCode + '0'; }
    logCode = logCode + String(fileNumber);
    logName = logName + logCode;
    Serial.println("--> Preparing FILE " + logName + ":"); } }

void loop() {
  if (fileExtent < 5) {
    Tsec = Tsec + 5;
    Tmin = Tsec / 60;
    Thrs = Tmin / 60;
    Tday = Thrs / 24;
    Time = String(Tday) + ":" +
           String(Thrs) + ":" +
           String(Tmin) + ":" +
           String(Tsec);
    Line = Time + "," + String(T) + "," + String(H);
    fileName = logName + ".csv";
    File dirFile = SD.open(fileName, FILE_WRITE);
    if (dirFile) {
      dirFile.println(Line);
      dirFile.close(); } }
    else {
      Serial.println("xxx NO MORE SPACE IN FILES"); } 
    delay(5000); }
