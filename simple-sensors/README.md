# Simple sensors

## Sketch

Use a termistor and a photocell to detect the temperature and light amount.
Additionally make a LED blink. The more light, the faster.

## Arduino code

Read the sensors value. 

Make the LED blink depending on the light amount.

On receiving '1' on the serial line send out the light sensor value.

On receiving '2' on the serial line send out the temperature sensor value.

## Processing code

Show a "Light" and a "Temp" button.

When a button is pressed, request the corresponding value to the Arduino
and display it on the console.

