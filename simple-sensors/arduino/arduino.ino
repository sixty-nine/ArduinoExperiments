const int LED_PORT = 13; 

const int LIGHT_PORT = 0;
const int TEMP_PORT = 7;

const char LIGHT_TRIGGER = '1';
const char TEMP_TRIGGER = '2';

int light = 0;
int temp = 0;

void output(String value) {
  Serial.print(value);
  Serial.print('\n');
}

void led(int state, int pause) {
  digitalWrite(LED_PORT, state);
  delay(pause);
}

void setup() {
  Serial.begin(9600);
  pinMode(LED_PORT, OUTPUT); 
}

void serialEvent() {
  
    char state = Serial.read ();

    if(state == LIGHT_TRIGGER) {
      output(String(light));
    } else if (state == TEMP_TRIGGER) {
      output(String(temp));
    }

    Serial.flush();
}

void loop() {  

  light = analogRead(LIGHT_PORT);

  temp = analogRead(TEMP_PORT);

  led(HIGH, 1200 - light);
  led(LOW, 1200 - light);
}
