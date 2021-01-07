import java.awt.geom.Point2D;

class BinaryTree
{
  Player player;
  Point2D position;
  int trunkLength;
  int trunkWidth;
  int depth;
  float branchingAngle; // [0;90]
  
  int lengthVariation;
  float angleVariation; // [0;45]
  
  float bend; //? -> bend tree x degrees to the left (-) or right (+)
  int leafDensity; // how many leaves per branch => need to reduce this number for shorter branches
  
  
  
  public BinaryTree() {
    
  }
  
  public void generateTree() {
    pushMatrix();
    // code
    
    popMatrix();
  }
  
  public void drawFrame() {
    pushMatrix();
    // code
    
    popMatrix();
  }
  
  private void branch() { // ???
    
  }
  
}
