import oscP5.*;
import netP5.*;
//OSC receive
OscP5 oscP5;
// This value is set by the OSC event handler
float amplitude = 0;
// Declare a scaling factor
float scale=6;
// Declare a smooth factor
float smooth_factor=0.1;
// Used for smoothing
float sum;

NetAddress remote;

void setup() {
    //fullScreen();
    size(600,600);
    
    // Initialize an instance listening to port 12000
    oscP5 = new OscP5(this,12000);
    remote = new NetAddress("127.0.0.1", 2009);
}
void draw() {
    background(0);
    // smooth the amplitude data by the smoothing factor
    sum += (amplitude - sum) * smooth_factor;
    // scaled to height/2 and then multiplied by a scale factor
    float amp_scaled=sum*(height/2)*scale;
    float mappedColor = map(amplitude * scale, 0, 1, 0, 255);
    //draw a dynamically-sized/colored circle
    fill(0, mappedColor, 255);
    ellipse(width/2, height/2, amp_scaled / 2, amp_scaled / 2);
}
void oscEvent(OscMessage theOscMessage) {
    float value = theOscMessage.get(0).floatValue();
    
    OscMessage msg = new OscMessage("/Xpos");
    msg.add(1.0);
    oscP5.send(msg,remote);
    
    if (theOscMessage.checkAddrPattern("/amp")) {
        if (value > 0.4) {
            amplitude = value;
        } else {
            amplitude = 0.0;
        }
    }
}
