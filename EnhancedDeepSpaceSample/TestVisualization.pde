

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
  popStyle();
}
