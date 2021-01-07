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

  float bend; // TODO ? -> bend tree x degrees to the left (-) or right (+)
  int leafDensity; // TODO how many leaves per branch => need to reduce this number for shorter branches

  // internal
  Player player;
  boolean playerIsActive = false;
  Node root;
  float shrinkFactor = 0.66;

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
  public BinaryTree(int playerID, Point2D position, float rotation, int maxDepth, int trunkLength, int trunkWidth, float branchingAngle, float lengthVariation, float widthVariation, float angleVariation, float depthVariation) {
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

    this.player = pc.getPlayerById(playerID);
    if (this.player != null) playerIsActive = true;
  }

  public void generateTree() {
    root = generateBranch(0, rotation, this.trunkLength, this.trunkWidth);
  }

  private Node generateBranch(int depth, float angle, int size, int startWidth) {
    Node node = new Node(angle, size, startWidth);

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

  public void drawTree() {
    pushMatrix();
    noStroke();
    fill(playerColors[this.playerID]);
    //stroke(0);
    translate((float)position.getX(), (float)position.getY()); 
    drawBranch(root);

    popMatrix();
  }

  private void drawBranch(Node node) { 
    if (node != null) {
      pushMatrix();
      rotate(node.angle); // Rotate by angle
      line(0, 0, 0, -node.size); // Draw line
      
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
      
      //if (node.left != null && node.right != null) {       
      //  quad(-node.startWidth/2, 0, 
      //    node.startWidth/2, 0, 
      //    node.right.startWidth/2, -node.size,
      //    -node.left.startWidth/2, -node.size);
      //} else if (node.left != null) {
      //  quad(-node.startWidth/2, 0, 
      //    node.startWidth/2, 0, 
      //    node.left.startWidth/2, -node.size,
      //    -node.left.startWidth/2, -node.size);
      //} else if (node.right != null) {
      //  quad(-node.startWidth/2, 0, 
      //    node.startWidth/2, 0, 
      //    node.right.startWidth/2, -node.size,
      //    -node.right.startWidth/2, -node.size);
      //} else {
      //  quad(-node.startWidth/2, 0, 
      //    node.startWidth/2, 0, 
      //    0, -node.size,
      //    0, -node.size);
      //}

      translate(0, -node.size); // Move to the end of the branch
      drawBranch(node.left);
      drawBranch(node.right); 
      popMatrix();
    }
  }

  private class Node {
    float angle;
    int size;
    int startWidth;
    Node left;
    Node right;

    Node(float angle, int size, int startWidth) {
      this.angle = angle;
      this.size = size;
      this.startWidth = startWidth;
      right = null;
      left = null;
    }
  }
}
