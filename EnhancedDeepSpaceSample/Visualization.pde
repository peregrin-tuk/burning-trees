

//// TEST VISUALIZATIONS ////

void drawTestVisualization() {
  int ampScale = 40;
  
  for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
    
    Player p = playersEntry.getValue();
    
    fill(255, 255, 255);
    circle(WindowWidth/11 * (p.id + 1), WallHeight - 300/shrink, (20 + 100*p.amplitude*ampScale) / shrink);
    textSize(64/shrink);
    text(p.id, WindowWidth/11 * (p.id + 1), WallHeight - 500/shrink);
    text(String.format("%.3f", p.amplitude), WindowWidth/11 * (p.id + 1), WallHeight - 100/shrink);
  }
}
