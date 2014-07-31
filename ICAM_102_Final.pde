/*
This program is an interactive piece in which the user uses a webcam with an output of a distorted 
view. The purpose of this piece is to provide the user with the option of escape, allowing themselves
to not reveal entirely their image and allows them to take something so simple and turn it into a fun 
collaborating time. Not to mention that the red box serves as a distraction to the user who is viewing
this transformation and ease off the realization of distortion.  

How to use:
In order to begin this transformation, the user needs to hold down any key on the keyboard.
When ever the user lets go of the key, an image will be taken and placed in a folder.
Also, there is a red square distinguishing where the brightest light is located. 
The more you drag your mouse to the right, the more distorted the image will be. 
Move mouse to the left, the more clear the image becomes. */


import processing.video.*;
Capture myCapture;

int numPixels;
int[] previousFrame;

void setup() 
{
  size(1000, 800);
 // background (255);    // Set bg to white
  noStroke();          //remove the stroke
  frameRate(10000);       // Set framerate
  smooth();            // Antialiasing
  myCapture = new Capture(this, width, height, 30); 
}

void captureEvent(Capture myCapture) {
  myCapture.read();
}

void draw() {
  if (myCapture.available()) {
    myCapture.read(); 
    
        if(keyPressed){
     if (key == 'b'|| key == 'B') {
   
      int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = myCapture.pixels[i];
      color prevColor = previousFrame[i];
      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      // Add these differences to the running tally
      movementSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      pixels[i] = color(diffR, diffG, diffB);
      // The following line is much faster, but more confusing to read
      //pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
      // Save the current color into the 'previous' buffer
      previousFrame[i] = currColor;
    }
    // To prevent flicker from frames that are all black (no movement),
    // only update the screen if the image has changed.
    if (movementSum > 0) {
      updatePixels();
      println(movementSum); // Print the total amount of movement to the console
    }
  }
    
    image(myCapture, 0, 0, width, height); // Draw the webcam video onto the screen
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video
    myCapture.loadPixels();
    int index = 0;
    for (int i = 0; i < myCapture.height; i++) {
      for (int j = 0; j < myCapture.width; j++) {    
        // Get the color stored in the pixel
        int pixelValue = myCapture.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = i;
          brightestX = j;
        }
        index++;
      }
   float pointillize = map(mouseX, 0, width, 2, 20);
  int x = int(random(myCapture.width));
  int y = int(random(myCapture.height));
  color pix = myCapture.get(x, y);
  fill(pix, 255);
 rect(x, y, pointillize, pointillize);
 
    }
    // Draw a large, salmon rectangle at the brightest pixel
    fill(215, 4, 0, 128);
    rect(brightestX, brightestY, 150, 150);
  }
 
}    //fill(255, 204, 0, 128);

}

// SAVE IMAGE
float saveincr;
void mousePressed() 
{
 saveincr++;
save("image"+saveincr+".jpg");
}
