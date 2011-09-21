#include "TimerOne.h"

const int XMIN = 2;
const int XMAX = 4;

const int YMIN = 8;
const int YMAX = 10;

int screen[3][3] = 
{
  { 0, 0, 0 },
  { 0, 0, 0 },
  { 0, 0, 0 }
};

volatile int wait;
volatile int cur_demo = 0;

// ----- MATRIX MANAGEMENT --------------------

void refreshScreen()
{
  for(int i = 0; i <= 3; i++) { // For each row
  
    digitalWrite(i + XMIN, HIGH);

    for(int j = 0; j <= 3; j++) { // For each column
    
      if (screen[i][j] == 1) {
        digitalWrite(j + YMIN, LOW);
      } else {
        digitalWrite(j + YMIN, HIGH);
      }
      
      digitalWrite(j + YMIN, HIGH);
    }
    
    digitalWrite(i + XMIN, LOW);
  }

}

void setPixel(int i, int j, int value = 1) {
  screen[i][j] = value;
}

void clearMatrix() {
  for(int i = 0; i < 3; i++) {
    for(int j = 0; j < 3; j++) {
      setPixel(i, j, 0);
    }
  }
}

void showPattern(int pattern[3][3]) {
  for(int i = 0; i < 3; i++) {
    for(int j = 0; j < 3; j++) {
      setPixel(i, j, pattern[i][j]);
    }
  }
}

// ----- DEMO FUNCTIONS -----------------------

void walkMatrixH(int repeat = 1) {
  for(int k = 0; k < repeat; k++) {
    for(int i = 0; i < 3; i++) {
      for(int j = 0; j < 3; j++) {
        clearMatrix();
        setPixel(i, j);
        delay(wait);
      }
    }
  }
}

void walkMatrixV(int repeat = 1) {
  for(int k = 0; k < repeat; k++) {
    for(int i = 0; i < 3; i++) {
      for(int j = 0; j < 3; j++) {
        clearMatrix();
        setPixel(j, i);
        delay(wait);
      }
    }
  }
}

void animatePattern(int patterns[][3][3], int steps, int repeat = 1) {

  for(int k = 0; k < repeat; k++) {
    for(int i = 0; i < steps; i++) {
      showPattern(patterns[i]);
      delay(wait);
    }
  }
}

void blinkScreen() {

  for(int i = 0; i < 3; i++) {
    for(int j = 0; j < 3; j++) {
      setPixel(i, j, 1);
    }
  }

  delay(wait);
  clearMatrix();
  delay(wait);
}

void walkColumns() {
  
  int patterns[][3][3] = {
    {
      { 1, 0, 0 },
      { 1, 0, 0 },
      { 1, 0, 0 }
    },
    {
      { 0, 1, 0 },
      { 0, 1, 0 },
      { 0, 1, 0 }
    },
    {
      { 0, 0, 1 },
      { 0, 0, 1 },
      { 0, 0, 1 }
    },
    {
      { 0, 0, 0 },
      { 0, 0, 0 },
      { 0, 0, 0 }
    },
  };

  animatePattern(patterns, 4);
}

void walkRows() {
  
  int patterns[][3][3] = {
    {
      { 1, 1, 1 },
      { 0, 0, 0 },
      { 0, 0, 0 }
    },
    {
      { 0, 0, 0 },
      { 1, 1, 1 },
      { 0, 0, 0 }
    },
    {
      { 0, 0, 0 },
      { 0, 0, 0 },
      { 1, 1, 1 }
    },
    {
      { 0, 0, 0 },
      { 0, 0, 0 },
      { 0, 0, 0 }
    },
  };

  animatePattern(patterns, 4);
}

void walkDiagonal() {
  
  int patterns[][3][3] = {
    {
      { 1, 0, 0 },
      { 0, 0, 0 },
      { 0, 0, 0 }
    },
    {
      { 0, 1, 0 },
      { 1, 0, 0 },
      { 0, 0, 0 }
    },
    {
      { 0, 0, 1 },
      { 0, 1, 0 },
      { 1, 0, 0 }
    },
    {
      { 0, 0, 0 },
      { 0, 0, 1 },
      { 0, 1, 0 }
    },
    {
      { 0, 0, 0 },
      { 0, 0, 0 },
      { 0, 0, 1 }
    },
    {
      { 0, 0, 0 },
      { 0, 0, 0 },
      { 0, 0, 0 }
    },
  };

  animatePattern(patterns, 6);
}

void demo(int nr = 0) {

  switch(nr) {
    case 5: 
      walkDiagonal();
      break;
    case 4:
      walkRows();
      break;
    case 3:
      walkColumns();
      break;
    case 2:
      walkMatrixV();
      break;
    case 1:
      walkMatrixH();
      break;
    case 0:
    default:
      // Blink
      blinkScreen();
  } 
}

// --------------------------------------------

int last_state = 0;

void readSensors() {
  // Potentiometer
  wait = analogRead(A0) / 50;

  // Switch
  int reading = digitalRead(13);
  if (reading != last_state) {
    if (reading == 1) {
      cur_demo++;
      if (cur_demo > 5) { // TODO: Change here if you add more demos
        cur_demo = 0;
      }
    }
  }
  last_state = reading;
}

void backgroundTasks() {
  readSensors();
  refreshScreen();
}

// ----- MAIN PROGRAM -------------------------

void setup() {               
  
  Serial.begin(9600);

  for(int i = XMIN; i <= XMAX; i++) {
    pinMode(i, OUTPUT);
  }
  for(int i = YMIN; i <= YMAX; i++) {
    pinMode(i, OUTPUT);
  }
  pinMode(13, INPUT);

  clearMatrix();

  readSensors();
 
  Timer1.initialize(10);
  Timer1.attachInterrupt(backgroundTasks);
}

void loop() {
  demo(cur_demo);
}

