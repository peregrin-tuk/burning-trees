
// Version 3.1
// Example implemenation which shows the usage of the new PharusClient

float cursor_size = 25;
PFont font;

int shrink = 1;
int WindowWidth = 3030/shrink; // for real Deep Space this should be 3030
int WindowHeight = 3712/shrink; // for real Deep Space this should be 3712
int WallHeight = 1914/shrink; // for real Deep Space this should be 1914 (Floor is 1798)

boolean ShowTrack = true;
boolean ShowPath = true;
boolean ShowFeet = true;

/*
void settings()
{
  size(WindowWidth, WindowHeight); 
}
*/

void setup()
{
  fullScreen(P2D, SPAN);
  frameRate(30);
  
  noStroke();
  fill(0);

  font = createFont("Arial", 18);
  textFont(font, 18);
  textAlign(CENTER, CENTER);

  initPlayerTracking();
}

void draw()
{
  // clear background with white
  background(255);

  // set upper half of window (=wall projection) bluish
  noStroke();
  fill(70, 100, 150);
  rect(0, 0, WindowWidth, WallHeight);
  fill(150);
  text((int)frameRate + " FPS", width / 2, 10);

  drawPlayerTracking();
}

void keyPressed()
{
  switch(key)
  {
  case 'p':
    ShowPath = !ShowPath; //<>//
    break;
  case 't':
    ShowTrack = !ShowTrack;
    break;
  case 'f':
    ShowFeet = !ShowFeet;
    break;
  }
}