
// Version 3.1
// Example implemenation which shows the usage of the new PharusClient

float cursor_size = 25;
PFont font;

int shrink = 5;
int WindowWidth = 3030/shrink; // for real Deep Space this should be 3030
int WindowHeight = 3712/shrink; // for real Deep Space this should be 3712
int WallHeight = 1914/shrink; // for real Deep Space this should be 1914 (Floor is 1798)

boolean ShowTrack = true;
boolean ShowPath = true;
boolean ShowFeet = false;

int framerate = 60;

OSCMessaging osc;


void settings()
{
  size(WindowWidth, WindowHeight); 
}



void setup()
{
  // fullScreen(P2D, SPAN);
  frameRate(framerate);
  
  noStroke();
  fill(0);

  font = createFont("Arial", 18);
  textFont(font, 18);
  textAlign(CENTER, CENTER);

  initPlayerTracking();
  osc = new OSCMessaging(); // TODO move to separate initOSC method (like with playerTracking and pc)?
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
  textFont(font, 18);
  text((int)frameRate + " FPS", width / 2, 10);

  drawPlayerTracking();
  osc.sendAllPlayerPositions(pc);
  drawTestVisualization();
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
