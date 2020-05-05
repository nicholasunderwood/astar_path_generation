class Node {
  int x,y,h,g;
  float centreX, centreY;
  NodeState state = NodeState.None;
  Node parent;
  
  Node(int x, int y){
    this.x = x;
    this.y = y;
    this.h = 1000;
    this.g = 1000;
    this.centreX = width * (this.x + 0.5);
    this.centreY = width * (this.x + 0.5);
  }
  
  int getH(){ return this.h; }
  int getG() { return this.g; }
  int getF() { return this.h + this.g; }
  Node getParent() { return this.parent; }
  void setH(int h) { this.h = h; }
  void setG(int g) { this.g = g; }
  void setState(NodeState state) { this.state = state; }
  void setParent(Node parent) { this.parent = parent; }
  Node calcCheapestNode(Node other){
    if(other.getF() > this.getF()) { return this; }
    if(other.getF() < this.getF()) { return other; }
    return other.g > this.g ? this : other;
  }
  
  int calcDistance(Node other){
    int deltaX = Math.abs(other.x - this.x);
    int deltaY = Math.abs(other.y - this.y);
    return Math.min(deltaX, deltaY) * 14 + Math.abs(deltaX - deltaY) * 10;
  }
  
  void draw(float width) {
    square(width * this.x, width * this.y, width);
  }
  
  @Override String toString() { return this.x + " " + this.y; }
}
