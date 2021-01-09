
// Version 3.1
// This example uses PharusClient class to access pharus data
// Pharus data is encapsulated into Player objects
// PharusClient provides an event callback mechanism whenever a player is been updated

PharusClient pc;

void initPlayerTracking(int maxPlayers)
{
  pc = new PharusClient(this, WallHeight, maxPlayers);
  // age is measured in update cycles, with 25 fps this is 2 seconds
  pc.setMaxAge(20);
  // max distance allowed when jumping between last known position and potential landing position, unit is in pixels relative to window width
  pc.setjumpDistanceMaxTolerance(0.05f);
}

void drawPlayerTracking()
{
  // reference for hashmap: file:///C:/Program%20Files/processing-3.0/modes/java/reference/HashMap.html
  for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) 
  {
    Player p = playersEntry.getValue();

    // player representation
    stroke(p.currentColor);
    strokeWeight(4);
    noFill();
    //circle(p.x, p.y, 60+p.amplitude*60);

    rectMode(CENTER);
    float yNormal = osc.normalize(p.y-WallHeight, WindowHeight-WallHeight);
    rect(p.x, p.y, 60+p.amplitude*60, 60+p.amplitude*60, yNormal*60 - p.amplitude*5);
    rectMode(CORNER);

    // render tracks = player
    if (ShowTrack)
    {
      // show each track with the corresponding  id number
      noStroke();
      if (p.isJumping())
      {
        fill(192, 0, 0);
      } else
      {
        fill(192, 192, 192);
      }
      circle(p.x, p.y, cursor_size);
      fill(0);
      textFont(font, 30);
      text(p.id /*+ "/" + p.tuioId*/, p.x, p.y);
    }

    // render feet for each track
    if (ShowFeet)
    {
      // show the feet of each track
      stroke(70, 100, 150, 200);
      noFill();
      // paint all the feet that we can find for one character
      for (Foot f : p.feet)
      {
        circle(f.x, f.y, cursor_size / 3);
      }
    }
  }
}

void pharusPlayerAdded(Player player)
{
  println("Player " + player.id + " added");

  osc.sendisActive(player.id, true);

  for (BinaryTree t : trees) {
    if (t.playerID == player.id) {
      t.player = player;
      t.playerIsActive = true;
    }
  }
}

void pharusPlayerRemoved(Player player)
{
  println("Player " + player.id + " removed");

  osc.sendisActive(player.id, false);

  for (BinaryTree t : trees) {
    if (t.playerID == player.id) {
      t.player = null;
      t.playerIsActive = false;
    }
  }
}
