import java.awt.geom.Point2D;

class BinaryTree
{
  int playerID;
  Point2D position;
  float rotation; // [-180;180] deg converted to rad
  int maxDepth; // no. of branches
  int trunkLength; // px
  int trunkWidth; // px
  float branchingAngle; // [0;90] deg in rad

  // variation in percent
  float lengthVariation; // [0;1]
  float widthVariation; // [0;1]
  float angleVariation; // [0;1]
  float depthVariation; // [0;1]

  boolean drawLeaves;

  // float bend; // TODO ? -> bend tree x degrees to the left (-) or right (+)
  // int leafDensity; // TODO how many leaves per branch => need to reduce this number for shorter branches

  // internal
  Player player;
  boolean playerIsActive = false;
  Node root;
  float shrinkFactor = 0.66;
  int leafSize = 18;
  float leafDensity = 0.05; // 0.05 = 5 leaves on 100px branch



  //////// CONSTRUCTORS ////////

  // symmetric tree constructor
  public BinaryTree(int playerID, Point2D position, float rotation, int maxDepth, int trunkLength, int trunkWidth, float branchingAngle) {
    this.playerID = playerID;
    this.position = position;
    this.rotation = radians(rotation);
    this.maxDepth = maxDepth;
    this.trunkLength = trunkLength;
    this.trunkWidth = trunkWidth;
    this.branchingAngle = radians(branchingAngle);

    this.player = pc.getPlayerById(playerID);
    if (this.player != null) playerIsActive = true;
  }

  // randomized tree constructor
  public BinaryTree(int playerID, Point2D position, float rotation, int maxDepth, int trunkLength, int trunkWidth, float branchingAngle, float lengthVariation, float widthVariation, float angleVariation, float depthVariation, boolean drawLeaves) {
    this.playerID = playerID;
    this.position = position;
    this.rotation = radians(rotation);
    this.maxDepth = maxDepth;
    this.trunkLength = trunkLength;
    this.trunkWidth = trunkWidth;
    this.branchingAngle = radians(branchingAngle);

    this.lengthVariation = lengthVariation;
    this.widthVariation = widthVariation;
    this.angleVariation = angleVariation;
    this.depthVariation = depthVariation;

    this.drawLeaves = drawLeaves;

    this.player = pc.getPlayerById(playerID);
    if (this.player != null) playerIsActive = true;
  }



  //////// GENERATION ////////

  public void generateTree() {
    root = generateBranch(0, rotation, this.trunkLength, this.trunkWidth);
  }

  private Node generateBranch(int depth, float angle, int size, int startWidth) {

    Point2D[] leaves = depth > 2 ? generateLeaves(size, startWidth) : new Point2D[]{};
    Node node = new Node(angle, size, startWidth, depth, leaves);

    if (depth < maxDepth && size > 4) {
      depth++;

      // left
      float a = this.branchingAngle + random(-angleVariation, angleVariation) * this.branchingAngle;
      int s = (int)(size * shrinkFactor + random(-lengthVariation, lengthVariation) * size * shrinkFactor);
      int w = (int)(startWidth * shrinkFactor + random(-widthVariation, widthVariation) * this.trunkWidth * shrinkFactor); 
      if (w < 3) w = 3;
      node.left = generateBranch(depth, -a, s, w);

      // right
      a = this.branchingAngle + random(-angleVariation, angleVariation) * this.branchingAngle;
      s = (int)(size * shrinkFactor + random(-lengthVariation, lengthVariation) * size * shrinkFactor);
      w = (int)(startWidth * shrinkFactor + random(-widthVariation, widthVariation) * this.trunkWidth * shrinkFactor);    
      if (w < 3) w = 3;
      node.right = generateBranch(depth, a, s, w);

      depth--;
    }

    return node;
  }

  private Point2D[] generateLeaves(int size, int startWidth) {
    int number = (int)(leafDensity * size + (1-5*leafDensity));
    float dist = startWidth/2 + leafSize;
    Point2D[] leaves = new Point2D[number];

    for (int i = 0; i < number; i++) {
      int x = (int) random(-dist, +dist);
      int y = (int) random(-(size+leafSize), 0-leafSize);
      leaves[i] = new Point(x, y);
    }

    return leaves;
  }



  //////// STATIC DRAWING ////////

  public void drawTree() {
    pushMatrix();
    noStroke();
    fill(playerColors[this.playerID][0]);
    //stroke(0);
    translate((float)position.getX(), (float)position.getY()); 
    drawBranch(root);

    popMatrix();
  }

  private void drawBranch(Node node) { 
    if (node != null) {
      pushMatrix();
      rotate(node.angle); // Rotate by angle
      //line(0, 0, 0, -node.size); // Draw line

      beginShape();
      vertex(-node.startWidth/2, 0);
      vertex(node.startWidth/2, 0);

      if (node.left != null && node.right != null) {   
        vertex( node.right.startWidth/2, -node.size);
        vertex(-node.left.startWidth/2, -node.size);
      } else if (node.left != null) {
        vertex( node.left.startWidth/2, -node.size);
        vertex(-node.left.startWidth/2, -node.size);
      } else if (node.right != null) {
        vertex( node.right.startWidth/2, -node.size);
        vertex(-node.right.startWidth/2, -node.size);
      } else {
        vertex(0, -node.size);
      }
      endShape();

      translate(0, -node.size); // Move to the end of the branch
      drawBranch(node.left);
      drawBranch(node.right); 
      popMatrix();
    }
  }



  //////// ANIMATED DRAWING ////////

  public void drawAnimatedTree() {
    pushMatrix();
    noStroke();
    fill(lerpColor(trunkColor, playerColors[this.playerID][0], 0.15));
    //fill(trunkColor);
    translate((float)position.getX(), (float)position.getY()); 
    rotate(root.angle); // Rotate by angle

    beginShape();
    vertex(-root.startWidth/2, 0);
    vertex(root.startWidth/2, 0);

    if (root.left != null && root.right != null) {   
      vertex( root.right.startWidth/2, -root.size);
      vertex(-root.left.startWidth/2, -root.size);
    } else if (root.left != null) {
      vertex( root.left.startWidth/2, -root.size);
      vertex(-root.left.startWidth/2, -root.size);
    } else if (root.right != null) {
      vertex( root.right.startWidth/2, -root.size);
      vertex(-root.right.startWidth/2, -root.size);
    } else {
      vertex(0, -root.size);
    }
    endShape();
    float endWidth = root.right.startWidth/2+root.left.startWidth/2;
    circle(root.right.startWidth/2-endWidth/2, -root.size, endWidth);

    translate(0, -root.size); // Move to the end of the branch

    float angleOsc = this.playerIsActive ? sin(millis()/300f + Metronome.startBeatOffset/300f) : sin(millis()/2000f + this.playerID);
    float sizeOsc = cos(millis()/1400f);

    drawAnimatedBranch(root.left, 1, angleOsc, sizeOsc);
    drawAnimatedBranch(root.right, 1, angleOsc, sizeOsc); 

    popMatrix();
  }

  private void drawAnimatedBranch(Node node, int dir, float angleOsc, float sizeOsc) { 
    if (node != null) {
      pushMatrix();
      float animatedAngle = 2, animatedSize = 100;

      if (this.playerIsActive) {
        float y = Math.max(0, this.player.distance*-1+0.9);
        float signum = (int)((Metronome.beat % 2 - 0.5)*2);
        animatedAngle = node.angle + angleOsc * 0.03 * dir + signum * Math.max(0, y-0.4)*3 * dir + signum * this.player.amplitude * dir *Math.max(0,(y-0.1)*2);
        animatedSize = node.size + (y+0.3)*this.player.amplitude*100*(dir+0.5);
      } else {
        animatedAngle = node.angle + angleOsc * 0.1 * dir;
        animatedSize = node.size + sizeOsc * 3;
      }
      rotate(animatedAngle); // Rotate by angle

      if (node.depth > 4) {
        if (this.playerIsActive) fill(this.player.currentColor);
        else fill(playerColors[this.playerID][0]);
      } else {
        fill(lerpColor(trunkColor, playerColors[this.playerID][0], 0.15));
        //fill(trunkColor);
      };

      beginShape();
      vertex(-node.startWidth/2, 0);
      vertex(node.startWidth/2, 0);

      if (node.left != null && node.right != null) {   
        vertex( node.right.startWidth/2, -animatedSize);
        vertex(-node.left.startWidth/2, -animatedSize);
        endShape();

        float endWidth = node.right.startWidth/2+node.left.startWidth/2;
        circle(node.right.startWidth/2-endWidth/2, -animatedSize, endWidth);
      } else if (node.left != null) {
        vertex( node.left.startWidth/2, -animatedSize);
        vertex(-node.left.startWidth/2, -animatedSize);
        endShape();

        circle(0, -animatedSize, (float)node.left.startWidth);
      } else if (node.right != null) {
        vertex( node.right.startWidth/2, -animatedSize);
        vertex(-node.right.startWidth/2, -animatedSize);
        endShape();

        circle(0, -animatedSize, (float)node.right.startWidth);
      } else {
        vertex(0, -animatedSize);
        endShape();
      }

      if (this.drawLeaves) drawLeaves(node);


      translate(0, -animatedSize); // Move to the end of the branch
      drawAnimatedBranch(node.left, -dir, angleOsc, sizeOsc);
      drawAnimatedBranch(node.right, dir, angleOsc, sizeOsc); 
      popMatrix();
    }
  }

  private void drawLeaves(Node node) {
    if (this.playerIsActive) fill(this.player.currentColor);
    else fill(playerColors[this.playerID][0]);

    for (Point2D l : node.leaves) {
      float x = (float)l.getX(); // + random(-1, 1); // performance
      float y = (float)l.getY(); // + random(-1, 1);
      ellipse(x, y, this.leafSize, this.leafSize-2);
    }
  }

  //////// NODE CLASS ////////

  private class Node {
    float angle;
    int size;
    int startWidth;
    int depth;
    Point2D[] leaves;
    Node left;
    Node right;

    Node(float angle, int size, int startWidth, int depth, Point2D[] leaves) {
      this.angle = angle;
      this.size = size;
      this.startWidth = startWidth;
      this.depth = depth;
      this.leaves = leaves;
      right = null;
      left = null;
    }
  }
}
