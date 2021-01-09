// Constants
int Y_AXIS = 1;
int X_AXIS = 2;

class RectGradient
{
  int startX;
  int startY;
  int endX;
  int endY;
  int axis; // 1=x, 2=y

  color start;
  color end;
  
  public RectGradient(int startX, int startY, int endX, int endY, color start, color end, int axis) {
    this.startX = startX;
    this.startY = startY;
    this.endX = endX;
    this.endY = endY;
    this.start = start;
    this.end = end;
    this.axis = axis;
  }

  public RectGradient(Point2D upperLeft, Point2D lowerRight, color start, color end, int axis) {
    this.startX = (int)upperLeft.getX();
    this.startY = (int)upperLeft.getY();
    this.endX = (int)lowerRight.getX();
    this.endY = (int)lowerRight.getY();
    this.start = start;
    this.end = end;
    this.axis = axis;
  }

  public void drawGradient() {

    pushStyle();
    noFill();

    if (axis == Y_AXIS) {  // Top to bottom gradient
      for (int i = startY; i <= endY; i++) {
        float inter = map(i, startY, endY, 0, 1);
        color c = lerpColor(start, end, inter);
        stroke(c);
        line(startX, i, endX, i);
      }
    } else if (axis == X_AXIS) {  // Left to right gradient
      for (int i = startX; i <= endX; i++) {
        float inter = map(i, startX, endX, 0, 1);
        color c = lerpColor(start, end, inter);
        stroke(c);
        line(i, startY, i, endY);
      }
    }
    popStyle();
  }
}
