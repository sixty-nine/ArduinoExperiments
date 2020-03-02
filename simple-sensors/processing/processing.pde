import processing.serial.*;

final char STOP_CHAR = '\n';
final char LIGHT_TRIGGER = '1';
final char TEMP_TRIGGER = '2';

Serial myPort;  // The serial port
Button lightButton;
Button tempButton;

void setup() {
  String firstSerial = Serial.list()[0];
  myPort = new Serial(this, firstSerial, 9600);
  myPort.bufferUntil (STOP_CHAR);

  size(640, 360);
  lightButton = new Button("Light", 20, 20, 100, 50);
  tempButton = new Button("Temp", 20, 100, 100, 50);
}

void stop() {
  myPort.stop();
}

void serialEvent(Serial myPort) {
  String inByte = myPort.readStringUntil(STOP_CHAR);
  print(inByte);
}

void mouseClicked() {
}

void mousePressed()
{
  if (lightButton.MouseIsOver()) {
    print("Light: ");
    myPort.write(LIGHT_TRIGGER);
  } else if (tempButton.MouseIsOver()) {
    print("Temp: ");
    myPort.write(TEMP_TRIGGER);
  }
}

void draw() {
  lightButton.Draw();
  tempButton.Draw();
}

// ----

// From: https://blog.startingelectronics.com/a-simple-button-for-processing-language-code/
class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button

  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }

  void Draw() {
    fill(218);
    stroke(141);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }

  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
