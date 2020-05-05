import java.util.*;

enum NodeState {None, Start, End, Closed, Open, Wall, Path}

int gridWidth = 50;
int gridHeight;
Node[][] grid;
float nodeWidth; 
ArrayList<Node> path;

Node start;
Node end;
Set<Node> closed = new HashSet<Node>();
Set<Node> open = new HashSet<Node>();

Node lastDraggedNode;
int timeAtLastUpdate = 0;
int timeSinceLastStep = 0;
int timeBetweenSteps = 250;

void settings(){ fullScreen(); }

void setup(){
  //surface.setSize(700,700); stroke(100);
  gridHeight = gridWidth * height / width;
  grid = new Node[gridWidth][gridHeight];
  nodeWidth = (float) width / gridWidth;
  
  for(int x = 0; x < gridWidth; x++){
    for(int y = 0; y < gridHeight; y++){
      grid[x][y] = new Node(x,y);
    }
  }
}

void draw(){
  int time = millis();
  timeSinceLastStep += time - timeAtLastUpdate;
  timeAtLastUpdate = time;
  background(200);
  
  if(timeSinceLastStep > timeBetweenSteps && path == null && start != null && end != null){
    step();
    timeSinceLastStep = 0;
  }
  
  for(Node[] row : grid){
    for(Node node : row){
      if(node == start || node == end || node.state == NodeState.Path) fill(0,0,255);
      else if(node.state == NodeState.Open) fill(0,255,0);
      else if(node.state == NodeState.Closed) fill(255,0,0);
      else if(node.state == NodeState.Wall) fill(0);
      else fill(255);
      node.draw(nodeWidth);
    }
  }
}

ArrayList<Node> getSuroundingNodes(Node node){
  ArrayList<Node> nodes = new ArrayList<Node>();
  Node neighbor;
  for(int x = Math.max(node.x-1,0); x <= Math.min(node.x+1,gridWidth-1); x++) {
    for(int y = Math.max(node.y-1,0); y <= Math.min(node.y+1,gridHeight-1); y++) {
      neighbor = grid[x][y];
      if((x - node.x) * (y - node.y) != 0) continue;
      if(neighbor == node || closed.contains(neighbor) || neighbor.state == NodeState.Wall) continue;
      nodes.add(neighbor);
    }
  }
  return nodes;
}

ArrayList<Node> getPath(Node end){
  ArrayList<Node> lst = new ArrayList<Node>();
  Node path = end;
  while(path.parent != null){
    path = path.getParent();
    if(path == start) break;
    path.setState(NodeState.Path);
    lst.add(path);
  }
  return lst;
}

void step(){
  Iterator<Node> it = open.iterator();
  if(!it.hasNext()) return;
  Node current = it.next();
  while(it.hasNext()){
    current = current.calcCheapestNode(it.next());
  }
  
  addNodeToClosed(current);
  if(current == end) {
    println("done");
    this.path = getPath(current);
  }
  ArrayList<Node> neighbors = getSuroundingNodes(current);
  for(Node node : neighbors){
    int tempG = current.calcDistance(node) + current.getG(); 
    if(!open.contains(node) || tempG < node.getG()) {
      node.setG(Math.min(current.calcDistance(node) + current.g, node.g));
      node.setH(node.calcDistance(end));
      addNodeToOpen(node);
      node.setParent(current);
    }
  }
}

boolean addNodeToOpen(Node node){
  boolean b = open.add(node);
  if(b) node.setState(NodeState.Open);
  return b;
}

boolean addNodeToClosed(Node node){
  boolean b = open.remove(node) && closed.add(node);
  if(!b) return false;
  node.setState(NodeState.Closed);
  return true;
}

void setStart(Node node){
  start = node;
  node.setState(NodeState.Start);
  node.setG(0);
}

void setEnd(Node node){
  end = node;
  node.setState(NodeState.End);
  start.setH(start.calcDistance(node));
}

void resetGrid(boolean keepWalls){
  end = null; start = null; path = null;
  open.clear(); closed.clear();
  for(Node[] row : grid){
    for(Node node : row){
      if(keepWalls && node.state == NodeState.Wall) continue;
      node.setState(NodeState.None);
    }
  }
}

void mousePressed(){
  int x = mouseX * gridWidth / width;
  int y = mouseY * gridHeight / height;
  Node node = grid[x][y];
  if(mouseButton == LEFT){
    if(start == null || end != null) {
      resetGrid(true);
      setStart(node);
    }
    else {
      end = node;
      node.setState(NodeState.End);
      open.add(start);
    }
  } else if(mouseButton == RIGHT){
    if(node.state == NodeState.Wall) node.setState(NodeState.None);
    else if(node.state == NodeState.None) node.setState(NodeState.Wall);
    else return;
    lastDraggedNode = node;
  }
}

void mouseDragged(){
  int x = mouseX * gridWidth / width;
  int y = mouseY * gridHeight / height;
  Node node = grid[x][y];
  if(mouseButton == RIGHT){
    if(lastDraggedNode == null || lastDraggedNode == node) return;
    node.setState(lastDraggedNode.state);
  }
}

void mouseReleased(){ lastDraggedNode = null; }

void mouseWheel(MouseEvent e){
  timeBetweenSteps *= Math.pow(0.95, e.getCount());
}

void keyPressed(){
  if(key == ' '){
    timeBetweenSteps = 0;
  } else if(key == 'f'){
    while(path == null){ step(); }
  } else if(key == 'c'){
    resetGrid(false);
    
  }
}
