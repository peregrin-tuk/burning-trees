 //<>//
// based on EnhancedDeepSpaceSample Version 3.1
import java.awt.Point;
import java.util.*;

PFont font;
PFont endFont;
PFont endFontSmall;
PFont endFontSmallBold;

// deep space display sizes
int WindowWidth = 3840;
int WindowHeight = 4320;
int WallHeight = 2160;

///// scaled display sizes
int shrink = 2;
int ScaledWindowWidth = WindowWidth/shrink; 
int ScaledWindowHeight = WindowHeight/shrink;
int ScaledWallHeight = WallHeight/shrink;

// debugging
boolean ShowTrack = false;
boolean ShowFeet = false;
boolean ShowTestOutput = false;
boolean ShowFPS = false;
boolean OnePlayerMode = false;
float cursor_size = 60;

///// SETTINGS
int framerate = 60;
int maxPlayers = 6;
int maxPlayingTime = 1000*60 * 3; // max time at avgY=1 in ms; 
int timeDistanceFactor = 24; // at avgY=0 max time will be maxPlayingTime/timeDistanceFactor
int timeLeft = maxPlayingTime;

color trunkColor = color(185, 150, 140);
color[][] playerColors = {
  {color( 70, 183, 105), color(199, 36, 177)}, 
  {color( 30, 130, 60), color(124, 4, 227)}, 
  {color(130, 190, 130), color(200, 0, 223)}, 
  {color(135, 200, 80), color(207, 30, 102)}, 
  {color(180, 200, 80), color(255, 83, 133)}, 
  {color(150, 200, 185), color( 20, 213, 235)}, 
};
color[] backgroundColor = 
  {color(40, 70, 80), color(57, 29, 42)};

// do not change
OSCMessaging osc;
ArrayList<BinaryTree> trees = new ArrayList<BinaryTree>();
int measuredMinFramerate = 120;
int measuredMaxFramerate = 0;
float avgDistance = 1;
int lastFrameTime = 0;


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
  endFont = createFont("Ubuntu-Light.ttf", 64);
  endFontSmall = createFont("Ubuntu-Light.ttf", 42);
  endFontSmallBold = createFont("Ubuntu-Medium.ttf", 48);
  textFont(font, 18);
  textAlign(CENTER, CENTER);

  initPlayerTracking(maxPlayers);
  osc = new OSCMessaging();

  // SETTINGS TREES
  Point2D[] positions = {
    new Point(WindowWidth/3, WallHeight+20), 
    new Point(WindowWidth/3*2, WallHeight+20), 
    new Point(-20, WallHeight/5), 
    new Point(WindowWidth+20, WallHeight/4), 
    new Point(WindowWidth/6, WallHeight+20), 
    new Point(WindowWidth-100, WallHeight+20)
  };

  float[] rotations = {
    random(-20, 20), 
    random(-20, 20), 
    random(80, 125), 
    random(-80, -125), 
    random(-10, 40), 
    random(-40, -10)
  };

  for (int id = 0; id < maxPlayers; id++) {
    Point2D p = positions[id];
    float r = rotations[id];
    int h = (int)random(300, 650);
    int w = (int)random(30, 60);
    BinaryTree tree = new BinaryTree(id, p, r, 7, h, w, 35, 0.4, 0.1, 0.7, 0.5, true);
    tree.generateTree();
    trees.add(tree);
  }
}


void draw()
{
  scale(1f/shrink);
  background(255); // base color = white
  calcDistancesAndColors();
  calcTimeLeft();
  osc.sendAllPlayerPositions(pc);
  
  if (timeLeft <= 0) {
    drawEnd();
  } else {
    drawBackground();  
    //drawFractalTree();
    for (BinaryTree t : trees) { t.drawAnimatedTree(); }
    drawFloor();
  }
  drawPlayerTracking();

  if (ShowFPS) showFPS();
  if (ShowTestOutput) drawTestVisualization();
}



//// DRAWING METHODS ////

void drawBackground() {
  noStroke();
  float realTimeLeft = timeLeft/(-(timeDistanceFactor-1) * avgDistance + timeDistanceFactor);
  
  if (realTimeLeft > 2400) {
    fill(lerpColor(backgroundColor[1], backgroundColor[0], avgDistance));
  } else {
    if (frameCount % 2 == 0) fill(lerpColor(color(255), backgroundColor[1], osc.normalize(realTimeLeft, 2400)));
    else fill(lerpColor(backgroundColor[1], backgroundColor[0], avgDistance));
  }
  rect(0, 0, WindowWidth, WallHeight);
}

void drawFloor() {
  fill(lerpColor(backgroundColor[1], backgroundColor[0], avgDistance));
  rect(0, WallHeight, WindowWidth, WindowHeight);
}

void showFPS() {
  int fps = (int)frameRate; 

  pushStyle();
  noStroke();
  fill(70, 100, 150);
  rect(WindowWidth/2-200, 0, 400, 140);
  fill(255);
  textFont(font, 40);
  text(fps + " FPS", WindowWidth / 2, 40);
  if (frameCount > 60) { 
    if (fps < measuredMinFramerate) measuredMinFramerate = fps;
    if (fps > measuredMaxFramerate) measuredMaxFramerate = fps;
    textFont(font, 38);
    text("min " + measuredMinFramerate + "  max " + measuredMaxFramerate, WindowWidth / 2, 90);
  }
  popStyle();
}


//// DISTANCE & TIME CALC ////

void calcDistancesAndColors() {
  if (pc.players.size() > 0) {
    Iterator<HashMap.Entry<Long, Player>> iter = pc.players.entrySet().iterator();

    int sum = 0;
    while (iter.hasNext()) 
    {
      Player p = iter.next().getValue();
      sum += p.y;
    }

    float avgY = sum / (float)pc.players.size();
    avgDistance = (avgY - WallHeight) / (WindowHeight-WallHeight);
    osc.sendAverageYPosition(avgDistance);

    iter = pc.players.entrySet().iterator();
    while (iter.hasNext()) 
    {
      Player p = iter.next().getValue();
      p.calcDistance(avgDistance);
      p.setColor();
    }
  }
}

void calcTimeLeft() {
  int deltaTime = millis() - lastFrameTime;
  float distanceFactor = -(timeDistanceFactor-1) * avgDistance + timeDistanceFactor;
  
  timeLeft -= deltaTime * distanceFactor;
  osc.sendTimeLeft(timeLeft);
  
  lastFrameTime = millis();
  
  //println("TIME LEFT: " + timeLeft/1000);
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
    ShowTrack = ShowTestOutput;
    ShowFPS = ShowTestOutput;
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
    if (pc.players.entrySet().isEmpty()) {
      pc.availableIDs.pop();
      pc.availableIDs.push(id);
    }
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
