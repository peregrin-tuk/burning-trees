

void drawFractalTree() {
  pushMatrix();
  stroke(255); 
  float offset = WindowWidth/2;
  //for (HashMap.Entry<Long, Player> playersEntry : pc.players.entrySet()) {    
    
    //Player p = playersEntry.getValue();
    // float a = p.amplitude * 90f;
    float a = avgDistance * 90f; // Pick an angle [0;90] deg
    float theta = radians(a);                 // Convert it to radians 
    translate(offset, WallHeight);            // Start the tree from the bottom of the screen  
    line(0, 0, 0, -500);                      // Draw a 120px line 
    translate(0, -500);                       // Move to the end of that line
    branch(500, theta, 1);                    // Start the recursive branching
    
  //}
  popMatrix();
}


void branch(float h, float theta, int dir) {

  h *= 0.66; // Each branch will be 2/3rds the size of the previous one

  if (h > 15) {

    //float hr = h + h*random(-0.2,0.2);
    float hr = h + cos(millis()/800f)*2;
    
    // right branch
    pushMatrix();      // Save the current state of transformation
    rotate(theta);     // Rotate by theta
    line(0, 0, 0, -hr); // Draw the branch
    translate(0, -hr);  // Move to the end of the branch
    //branch(h, theta + random(-0.2,0.2));  // call self to draw two new branches
    branch(h, theta + sin(millis()/1000f)/6 * dir, dir*-1); 
    popMatrix();       // "pop" in order to restore the previous matrix state

    // left branch
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -hr);
    translate(0, -hr);
    branch(h, theta - sin(millis()/1000f+1)/6 * dir, dir*-1);
    popMatrix();
  }
}
