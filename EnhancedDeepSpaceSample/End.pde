int timeEnded = -1; // ms
int deltaTime = 0; // ms

int xQuote = WindowWidth/2; //-350;
int xCredits = WindowWidth/2; //-200;


void drawEnd() {
  if (timeEnded == -1) timeEnded = millis(); 
  deltaTime = millis() - timeEnded;

  noStroke();
  
  textAlign(CENTER, CENTER);
  fill(backgroundColor[0], deltaTime/4 - 300);
  textFont(endFont);
  text("Everyone starts caring", xQuote, WallHeight/2-100);
  fill(backgroundColor[0], deltaTime/4 - 800);
  text("when it's too late.", xQuote, WallHeight/2);

  //textAlign(CENTER, CENTER);
  fill(backgroundColor[0], deltaTime/4 - 1500); 
  textFont(endFontSmallBold);
  text("Burning Trees", xCredits, WallHeight-400);
  textFont(endFontSmall);
  text("Julian Salhofer &", xCredits, WallHeight-300);
  text("Eric Thalhammer", xCredits, WallHeight-240);

  fill(color(backgroundColor[1], 10));
  rect(0, WallHeight, WindowWidth, WindowHeight);
}
