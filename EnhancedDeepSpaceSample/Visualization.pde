

//// TEST VISUALIZATIONS ////

void drawTestVisualization() {
  int ampScale = 2;
  
  for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
    
    Player p = playersEntry.getValue();
    
    fill(255, 255, 255);
    textSize(64/shrink);   
    text(p.id, WindowWidth/11 * (p.id + 1), WallHeight - 700/shrink);
    circle(WindowWidth/11 * (p.id + 1), WallHeight - 500/shrink, (20 + 100*p.amplitude*ampScale) / shrink);
    
    textSize(48/shrink);
    
    // coordinates
    text(String.format("(%1$.0f | %2$.0f)", p.x, p.y), WindowWidth/11 * (p.id + 1), WallHeight - 300/shrink);
    
    // normalized coordinates
    float xn = osc.normalize(p.x, WindowWidth);
    float yn = osc.normalize(p.y-WallHeight, WindowHeight-WallHeight);
    text(String.format("(%1$.2f | %2$.2f)", xn, yn), WindowWidth/11 * (p.id + 1), WallHeight - 200/shrink);
    
    // amplitude
    text(String.format("%.3f", p.amplitude), WindowWidth/11 * (p.id + 1), WallHeight - 100/shrink);
  }
}
