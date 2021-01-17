

//// TEST VISUALIZATIONS ////

void drawTestVisualization() {

  // pushMatrix();
  // translate(0,-(WallHeight-450));
  // popMatrix();

  pushStyle();
  noStroke();
  fill(70, 100, 150);
  rect(0, WallHeight-450, WindowWidth, 450);

  // labels
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(36);   
  text("Player ID:", 100, WallHeight - 400);
  textSize(30);
  text("Amplitude:", 100, WallHeight - 180);
  text("Tracking Coords:", 100, WallHeight - 120);
  text("Normalized Coords:", 100, WallHeight - 80);

  textAlign(CENTER, CENTER);

  for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
    Player p = playersEntry.getValue();


    int xPos = OnePlayerMode ? 100 + (WindowWidth-100)/2 : 100 + (WindowWidth-100)/(pc.maxPlayers+1) * (p.id + 1);

    textSize(36);   
    text(p.id, xPos, WallHeight - 400);
    textSize(30);

    // amplitude
    circle(xPos, WallHeight - 290, (20 + 100*p.amplitude));
    text(String.format("%.3f", p.amplitude), xPos, WallHeight - 180);

    // coordinates
    text(String.format("%1$.0f | %2$.0f", p.x, p.y), xPos, WallHeight - 120);

    // normalized coordinates
    float xn = osc.normalize(p.x, WindowWidth);
    float yn = osc.normalize(p.y-WallHeight, WindowHeight-WallHeight);
    text(String.format("%1$.2f | %2$.2f", xn, yn), xPos, WallHeight - 80);
  }

  // time left
  float distanceFactor = -(timeDistanceFactor-1) * avgDistance + timeDistanceFactor;
  int currentTimeLeft = (int)(timeLeft / distanceFactor);
  int rMin = timeLeft /(1000 * 60);
  int rSec = timeLeft / 1000 % 60;
  int cMin = currentTimeLeft /(1000 * 60);
  int cSec = currentTimeLeft / 1000 % 60;
  textAlign(RIGHT, CENTER);
  textSize(36);
  text("TIME LEFT:", WindowWidth-100, WallHeight - 400);
  text("max: " + String.format("%02d:%02d", rMin, rSec), WindowWidth-100, WallHeight - 340);
  text("current: " + String.format("%02d:%02d", cMin, cSec), WindowWidth-100, WallHeight - 300);
  textSize(30);
  text("Time Factor: " + String.format("%2.1f", distanceFactor), WindowWidth-100, WallHeight - 200);
  text("Avg. Y: " + String.format("%1.2f", avgDistance), WindowWidth-100, WallHeight - 160);

  popStyle();
}
