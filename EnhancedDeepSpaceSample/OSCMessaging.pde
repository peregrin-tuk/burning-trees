import oscP5.*;
import netP5.*;

public class OSCMessaging {
  int portIn = 12000;
  int portOut = 12001;
  
  OscP5 oscp5 = new OscP5(this, portIn);
  NetAddress remote = new NetAddress("127.0.0.1", portOut);
  
  public void sendNormalizedPlayerPosition(int playerId, float x, float y) {
    x = normalize(x, WindowWidth);
    y = normalize(y-WallHeight, WindowHeight-WallHeight);
    
    OscMessage msg = new OscMessage("/pos");
    msg.add(playerId);
    msg.add(x);
    msg.add(y);
    oscp5.send(msg,remote);
  }
  
  public void sendAllPlayerPositions(PharusClient pc) {
    for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet())  {
      Player p = playersEntry.getValue();
      sendNormalizedPlayerPosition(p.id, p.x, p.y);
    }
  }
  
  public float normalize(float val, float max) {
    return val / max;
  }
}
