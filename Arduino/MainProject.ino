#include <OSCMessage.h>

/*
Make an OSC message and send it over serial
 */

#ifdef BOARD_HAS_USB_SERIAL
#include <SLIPEncodedUSBSerial.h>
SLIPEncodedUSBSerial SLIPSerial( thisBoardsSerialUSB );
#else
#include <SLIPEncodedSerial.h>
SLIPEncodedSerial SLIPSerial(Serial);
#endif



int potPin = 2;    // select the input pin for the potentiometer
int ledPin = 2;   // select the pin for the LED
int val = 0;       // variable to store the value coming from the sensor
int buttonPin = 3;
int buttonState = 0; 
int val2 = 0;


void setup() {

//begin SLIPSerial just like Serial
  SLIPSerial.begin(9600);   // set this as high as you can reliably run on your platform
#if ARDUINO >= 100
  while(!Serial)
    ; //Leonardo "feature"
#endif
  
  pinMode(ledPin, OUTPUT);  // declare the ledPin as an OUTPUT
  pinMode(buttonPin, INPUT);
}

void loop() {
  
 buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {
    // turn LED on:
    val2 = 1;
  } else {
    // turn LED off:
    val2 = 0;
  }

  
  val = analogRead(potPin);    // read the value from the sensor
  digitalWrite(ledPin, HIGH);  // turn the ledPin on
  delay(val);                  // stop the program for some time
  digitalWrite(ledPin, LOW);   // turn the ledPin off
  delay(val);                  // stop the program for some time

  

   OSCMessage msg("/analog/0");
  msg.add((float)val);

  OSCMessage msg2("/analog/1");
  msg2.add((float)val2);

   SLIPSerial.beginPacket();  
    msg.send(SLIPSerial); // send the bytes to the SLIP stream
    msg2.send(SLIPSerial); // send the bytes to the SLIP stream
  SLIPSerial.endPacket(); // mark the end of the OSC Packet
  msg.empty(); // free space occupied by message
  msg2.empty(); // send the bytes to the SLIP stream



}
 
