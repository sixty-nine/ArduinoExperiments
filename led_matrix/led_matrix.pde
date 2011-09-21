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

int patterns1[][3][3] = {

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

int patterns2[][3][3] = {

  {
    { 0, 0, 0 },
    { 0, 1, 0 },
    { 0, 0, 0 }
  },
  {
    { 1, 1, 1 },
    { 1, 0, 1 },
    { 1, 1, 1 }
  },
  {
    { 0, 0, 0 },
    { 0, 1, 0 },
    { 0, 0, 0 }
  },
  {
    { 0, 0, 0 },
    { 0, 0, 0 },
    { 0, 0, 0 }
  },
};

int patterns3[][3][3] = {

  {
    { 0, 0, 0 },
    { 0, 0, 0 },
    { 0, 0, 0 }
  },
  {
    { 1, 1, 1 },
    { 1, 1, 1 },
    { 1, 1, 1 }
  },
};

int patterns4[][3][3] = {

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

void walkMatrixH(int wait, int repeat = 1) {
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

void walkMatrixV(int wait, int repeat = 1) {
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

void animatePattern(int wait, int patterns[][3][3], int steps, int repeat = 1) {

  for(int k = 0; k < repeat; k++) {
    for(int i = 0; i < steps; i++) {
      showPattern(patterns[i]);
      delay(wait);
    }
  }
}

// ----- MAIN PROGRAM -------------------------

void setup() {               
  
  for(int i = XMIN; i <= XMAX; i++) {
    pinMode(i, OUTPUT);
  }
  for(int i = YMIN; i <= YMAX; i++) {
    pinMode(i, OUTPUT);
  }
  clearMatrix();

  Timer1.initialize(10);
  Timer1.attachInterrupt(refreshScreen);
}

void loop() {
  
  // -------------------------------------------
  animatePattern(10, patterns3, 2, 3); // Flash

  walkMatrixH(10, 2);
  walkMatrixV(10, 2);
  
  // -------------------------------------------
  animatePattern(10, patterns3, 2, 3); // Flash
  animatePattern(10, patterns4, 4, 5);

  // -------------------------------------------
  animatePattern(10, patterns3, 2, 3); // Flash
  animatePattern(10, patterns1, 6, 5);

  // -------------------------------------------
  animatePattern(10, patterns3, 2, 3); // Flash
  animatePattern(10, patterns2, 4, 5);
}

