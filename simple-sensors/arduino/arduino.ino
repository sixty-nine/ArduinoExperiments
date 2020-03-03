const int LED_PORT = 13;
const int LIGHT_PORT = 0;
const int TEMP_PORT = 7;

const int LIGHT_MODE = 0;
const int TEMP_MODE = 1;

const char LIGHT_TRIGGER = '1';
const char TEMP_TRIGGER = '2';
const char LED_TRIGGER = '3';



int light = 0;
int temp = 0;

bool led_on = false;

int cur_mode = TEMP_MODE;

int ledState = LOW;
unsigned long ledPreviousMillis = 0;
unsigned long updatePreviousMillis = 0;
int long led_interval = 1000;
int long update_interval = 500;

void output(String value) {
  Serial.print(value);
  Serial.print('\n');
}

void led(int state, int pause) {
  digitalWrite(LED_PORT, state);
  delay(pause);
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PORT, OUTPUT);
}

void serialEvent() {

  char state = Serial.read ();

  if (state == LIGHT_TRIGGER) {
    output(String(light));
    cur_mode = LIGHT_MODE;
  } else if (state == TEMP_TRIGGER) {
    output(String(temp));
    cur_mode = TEMP_MODE;
  } else if (state == LED_TRIGGER) {
    led_on = !led_on;
    if (!led_on) digitalWrite(LED_PORT, LOW);
  }

  Serial.flush();
}

void loop() {

  light = analogRead(LIGHT_PORT);
  temp = analogRead(TEMP_PORT);


  led_interval = 1200 - light;

  //led(HIGH, 1200 - light);
  //led(LOW, 1200 - light);
  unsigned long currentMillis = millis();


  if (currentMillis - updatePreviousMillis >= update_interval) {
    updatePreviousMillis = currentMillis;
    if (cur_mode == LIGHT_MODE) {
      Serial.print(light);
    } else {
      Serial.print(temp);
    }
    Serial.print("\n");
  }

  if (led_on) {
    if (currentMillis - ledPreviousMillis >= led_interval) {
      ledPreviousMillis = currentMillis;

      // if the LED is off turn it on and vice-versa:
      if (ledState == LOW) {
        ledState = HIGH;
      } else {
        ledState = LOW;
      }
      digitalWrite(LED_PORT, ledState);
    }
  }


}
