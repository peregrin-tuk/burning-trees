 //<>//
// based on EnhancedDeepSpaceSample Version 3.1

float cursor_size = 25;
PFont font;

// deep space display sizes
int WindowWidth = 3030;
int WindowHeight = 3712;
int WallHeight = 1914; // should be 1914 (Floor is 1798)

// scaled display sizes
int shrink = 2;
int ScaledWindowWidth = WindowWidth/shrink; 
int ScaledWindowHeight = WindowHeight/shrink;
int ScaledWallHeight = WallHeight/shrink;

// debugging
boolean ShowTrack = true;
boolean ShowFeet = false;
boolean ShowTestOutput = false;
boolean ShowFPS = true;
boolean OnePlayerMode = false;

// SETTINGS
int framerate = 60;
int maxPlayers = 6;
color[] playerColors = {
  color(70,183,105),
  color(30,130,60),
  color(130,190,130),
  color(135,200,80),
  color(180,200,80),
  color(150,200,185),
};

OSCMessaging osc;


void settings()
{
  size(ScaledWindowWidth, ScaledWindowHeight);
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

  initPlayerTracking(maxPlayers);
  osc = new OSCMessaging();
}

void draw()
{
  background(255); // white background
  
  drawPlayerTracking();
  osc.sendAllPlayerPositions(pc);
  
  scale(1f/shrink);
  drawWallBackground();  
  drawFractalTree();
  if(ShowFPS) showFPS();
  if(ShowTestOutput) drawTestVisualization();
}

void drawWallBackground() {
  noStroke();
  fill(70, 100, 150);
  rect(0, 0, WindowWidth, WallHeight);
}

void showFPS() {
  fill(255);
  textFont(font, 36);
  text((int)frameRate + " FPS", WindowWidth / 2, 30);
}



//// DEBUG & TESTING ////

void keyPressed()
{
  switch(key)
  {
  case 'p':
    ShowTrack = !ShowTrack;
    break;
  case 't':
    ShowTestOutput = !ShowTestOutput;
    break;
  case 'f':
    ShowFeet = !ShowFeet;
    break;
  case 's':
    ShowFPS = !ShowFPS;
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
