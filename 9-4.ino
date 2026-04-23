const int receivePin = 23; // สายสีเขียวที่ต่อมาจาก P3.4
volatile int pulseCount = 0;
int lastReportedCount = 0;
unsigned long lastPulseTime = 0;

// ฟังก์ชันนี้จะทำงานอัตโนมัติทุกครั้งที่สัญญาณมีการเปลี่ยนจาก 0 เป็น 1 (RISING)
void IRAM_ATTR countPulse() {
  pulseCount++;
  lastPulseTime = millis(); // บันทึกเวลาล่าสุดที่มีพัลส์เข้ามา
}

void setup() {
  Serial.begin(115200);
  pinMode(receivePin, INPUT_PULLUP);
  
  // เปิดใช้ Interrupt ที่ขา 23
  attachInterrupt(digitalPinToInterrupt(receivePin), countPulse, RISING);
  
  Serial.println("ESP32 Ready...");
  Serial.println("Waiting for pulses from MCS-51...");
}

void loop() {
  // ตรวจสอบว่ามีพัลส์เข้ามา และหยุดส่งมาเกิน 0.5 วินาทีแล้ว (แปลว่าส่งครบชุด)
  if (pulseCount > 0 && (millis() - lastPulseTime > 500)) {
    if (pulseCount != lastReportedCount) {
      Serial.println("=================================");
      Serial.print("Total Pulses Received: ");
      Serial.println(pulseCount);
      Serial.println("=================================\n");
      
      lastReportedCount = pulseCount; // อัปเดตค่าล่าสุดที่โชว์ไป
      pulseCount = 0; // รีเซ็ตตัวนับรอรับชุดใหม่
    }
  }
}