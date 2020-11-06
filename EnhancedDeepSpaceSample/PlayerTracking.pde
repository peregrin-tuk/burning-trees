
// Version 3.1
// This example uses PharusClient class to access pharus data
// Pharus data is encapsulated into Player objects
// PharusClient provides an event callback mechanism whenever a player is been updated

PharusClient pc;

void initPlayerTracking()
{
  pc = new PharusClient(this, WallHeight);
  // age is measured in update cycles, with 25 fps this is 2 seconds
  pc.setMaxAge(50);
  // max distance allowed when jumping between last known position and potential landing position, unit is in pixels relative to window width
  pc.setjumpDistanceMaxTolerance(0.05f);  
}

void drawPlayerTracking()
{
  // reference for hashmap: file:///C:/Program%20Files/processing-3.0/modes/java/reference/HashMap.html
  for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) 
  {
    Player p = playersEntry.getValue();

    // render path of each track
    if (ShowPath)
    {
      if (p.getNumPathPoints() > 1)
      {
        stroke(70, 100, 150, 25.0f );        
        int numPoints = p.getNumPathPoints();
        int maxDrawnPoints = 300;
        // show the motion path of each track on the floor    
        float startX = p.getPathPointX(numPoints - 1);
        float startY = p.getPathPointY(numPoints - 1);
        for (int pointID = numPoints - 2; pointID > max(0, numPoints - maxDrawnPoints); pointID--) 
        {
          float endX = p.getPathPointX(pointID);
          float endY = p.getPathPointY(pointID);
          line(startX, startY, endX, endY);
          startX = endX;
          startY = endY;
        }
      }
    }

    // render tracks = player
    if (ShowTrack)
    {
      // show each track with the corresponding  id number
      noStroke();
      if (p.isJumping())
      {
        fill(192, 0, 0);
      }
      else
      {
        fill(192, 192, 192);
      }
      ellipse(p.x, p.y, cursor_size, cursor_size);
      fill(0);
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
        ellipse(f.x, f.y, cursor_size / 3, cursor_size / 3);
      }
    }
  }
}

void pharusPlayerAdded(Player player)
{
  println("Player " + player.id + " added");
  
  // TODO do something here if needed
}

void pharusPlayerRemoved(Player player)
{
  println("Player " + player.id + " removed");
  
  // TODO do something here if needed  
}
