const int receivePin = 23; 
volatile int pulseCount = 0;
int lastReportedCount = 0;
unsigned long lastPulseTime = 0;

void IRAM_ATTR countPulse() {
  pulseCount++;
  lastPulseTime = millis(); 
}
void setup() {
  Serial.begin(115200);
  pinMode(receivePin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(receivePin), countPulse, RISING);
  Serial.println("ESP32 Ready...");
  Serial.println("Waiting for pulses from MCS-51...");
}
void loop() {
  if (pulseCount != lastReportedCount) {
    Serial.println(pulseCount);
  }if (pulseCount > 0 && (millis() - lastPulseTime > 2000)) {
    lastReportedCount = pulseCount;  
    pulseCount = 0;                 
  }
}