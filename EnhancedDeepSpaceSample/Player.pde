
// Version 3.1
// this class contains all the information for one player and gets updated by the PharusClient
// extend this class with your player code if needed, but do not change the functions and variables that are there already as PharusClient depends on it

class Player
{
  public Player(PharusClient pc, int id, long tuioId, float x, float y)
  {
    this.pc = pc;
    this.id = id;
    this.tuioId = tuioId;
    this.x = x;
    this.y = y;
  }

  // --- Pharus Client fields - do not modify these, PharusClient updates it ---
  PharusClient pc;
  int id;
  long tuioId;
  int age;
  float x;
  float y;
  ArrayList<Foot> feet = new ArrayList<Foot>();

  // --- additional fields ---
  float amplitude;
  

  // --- Some functions that have information about the player ---
  boolean isJumping()
  {
    // we assume that we jump if we have no feet and update
    return feet.size() == 0 && age > 1;
  }

  // handling of path information
  int getNumPathPoints()
  {
    TuioCursor tc = pc.tuioProcessing.getTuioCursor(tuioId);
    if (tc != null)
    {
      return tc.getPath().size();
    }
    return -1;
  }
  float getPathPointX(int pointID)
  {
    TuioCursor tc = pc.tuioProcessing.getTuioCursor(tuioId);
    if (tc != null)
    {
      ArrayList pointList = tc.getPath();
      if (pointList == null || pointList.size() <=  pointID)
      {
        return 0;
      }
      TuioPoint tp = (TuioPoint)pointList.get(pointID);
      return tp.getScreenX(width);
    }
    return 0;
  }
  float getPathPointY(int pointID)
  {
    TuioCursor tc = pc.tuioProcessing.getTuioCursor(tuioId);
    if (tc != null)
    {
      ArrayList pointList = tc.getPath();
      if (pointList == null || pointList.size() <=  pointID)
      {
        return 0;
      }
      TuioPoint tp = (TuioPoint)pointList.get(pointID);
      return tp.getScreenY(height - pc.wallHeight) + pc.wallHeight;
    }
    return 0;
  }  

  // TODO extend this with additional functions

}

// helper class for feet
public class Foot
{
  public Foot(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  float x;
  float y;
}
