#define pout 23
float freq = 1000 + 157;
float period = (1.0/freq) * 1000000.0;
float on = 0.75 * period;
float off = period - on;
void setup() {
  pinMode(pout,OUTPUT);
}
void loop() {
  digitalWrite(pout,HIGH);
  delayMicroseconds(on);
  digitalWrite(pout,LOW);
  delayMicroseconds(off);
}