 //<>//
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
boolean OnePlayerMode = false;

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

  initPlayerTracking(10);
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



//// DEBUG & TESTING ////

void keyPressed()
{
  switch(key)
  {
  case 'p':
    ShowPath = !ShowPath;
    break;
  case 't':
    ShowTrack = !ShowTrack;
    break;
  case 'f':
    ShowFeet = !ShowFeet;
    break;
  case 'o':
    toggleOnePlayerTestMode(!OnePlayerMode);
    break;
  case '0':
    if (OnePlayerMode) setPlayerId(0);
    break;
  case '1':
    if (OnePlayerMode) setPlayerId(1);
    break;
  case '2':
    if (OnePlayerMode) setPlayerId(2);
    break;
  case '3':
    if (OnePlayerMode) setPlayerId(3);
    break;
  case '4':
    if (OnePlayerMode) setPlayerId(4);
    break;
  case '5':
    if (OnePlayerMode) setPlayerId(5);
    break;
  case '6':
    if (OnePlayerMode) setPlayerId(6);
    break;
  case '7':
    if (OnePlayerMode) setPlayerId(7);
    break;
  case '8':
    if (OnePlayerMode) setPlayerId(8);
    break;
  case '9':
    if (OnePlayerMode) setPlayerId(9);
    break;
  }
}

void toggleOnePlayerTestMode(boolean activate)
{
  pc.dispose();
  if (activate) {
    initPlayerTracking(1);
    OnePlayerMode = true;
  } else {
    initPlayerTracking(10);
    OnePlayerMode = false;
  }
}

void setPlayerId(int id) {
  if (OnePlayerMode) {
    Iterator<HashMap.Entry<Long, Player>> iter = pc.players.entrySet().iterator();
    while (iter.hasNext()) 
    {
      Player p = iter.next().getValue();
      pc.firePlayerRemoveEvent(p);
      p.id = id;
      pc.firePlayerAddEvent(p);
      break;
    }
  } else {
    print("player id can only be set in one player test mode");
  }
}
