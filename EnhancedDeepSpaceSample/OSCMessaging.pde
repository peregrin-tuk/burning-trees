import oscP5.*;
import netP5.*;

public class OSCMessaging {
  int portIn = 12000;
  int portOut = 12001;

  OscP5 oscp5 = new OscP5(this, portIn);
  NetAddress remote = new NetAddress("127.0.0.1", portOut);


  //// OUTGOING SIGNALS ////

  // pos ->

  public void sendNormalizedPlayerPosition(int playerId, float x, float y) {
    x = normalize(x, WindowWidth);
    y = normalize(y-WallHeight, WindowHeight-WallHeight);

    OscMessage msg = new OscMessage("/pos");
    msg.add(playerId);
    msg.add(x);
    msg.add(y);
    oscp5.send(msg, remote);
  }

  public void sendAllPlayerPositions(PharusClient pc) {
    for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
      Player p = playersEntry.getValue();
      sendNormalizedPlayerPosition(p.id, p.x, p.y);
    }
  }


  // avgypos ->

  public void sendAverageYPosition(PharusClient pc) {
    float avgY = 0;
    for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
      Player p = playersEntry.getValue();
      avgY += normalize(p.y-WallHeight, WindowHeight-WallHeight);
    }
    avgY /= pc.players.size();

    OscMessage msg = new OscMessage("/avgypos");
    msg.add(avgY);
    oscp5.send(msg, remote);
  }

  public void sendAverageYPosition(float normalAvgY) {
    OscMessage msg = new OscMessage("/avgypos");
    msg.add(normalAvgY);
    oscp5.send(msg, remote);
  }


  // active ->

  public void sendisActive(int playerId, boolean isActive) {

    OscMessage msg = new OscMessage("/active");
    msg.add(playerId);
    msg.add(isActive);
    oscp5.send(msg, remote);
  }


  // res ->

  public void sendTimeLeft(int timeLeft) {
    float res = normalize(timeLeft, maxPlayingTime);

    OscMessage msg = new OscMessage("/res");
    msg.add(res);
    oscp5.send(msg, remote);
  }


  //// INCOMING SIGNALS ////

  // <- amp

  void oscEvent(OscMessage msg) {    

    if (msg.checkAddrPattern("/amp")) {
      int playerId = msg.get(0).intValue();
      float value = msg.get(1).floatValue();

      for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {
        if (playersEntry.getValue().id == playerId) {
          playersEntry.getValue().amplitude = value;
        }
      }
    }
    if (msg.checkAddrPattern("/beats")) {
      int beat = msg.get(0).intValue();
      Metronome.beat = beat;
      if (endTriggered && timeFinaleStarted == -1 && beat == 1) {
        timeFinaleStarted = millis();
      }
    }
  }



  //// UTILS ////

  public float normalize(float val, float max) {
    return val / max;
  }
}
