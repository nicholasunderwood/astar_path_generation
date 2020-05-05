class MazeGenerator{
  Node[][] grid;
  Set<Node> visited;
  ArrayList<Node> track;
  Node nextNode; Node start;
  MazeGenerator(Node[][] grid){
    this.grid = grid;
    this.track = new ArrayList<Node>();
    this.visited = new HashSet<Node>();
  }
  
  
  void step(Node start, Node current) {
    ArrayList<Node[]> paths = getPaths(current);
    if(!paths.isEmpty()){
      Node[] path = paths.get((int)(Math.random()*paths.size()));
      for(Node node : path){
        node.setState(NodeState.None);
      }
      this.visited.add(path[1]); this.track.add(path[1]);
      this.nextNode = path[1];
      step(start, path[1]);
      return;
    } else {
      current = this.track.remove(this.track.size()-1);
      if(current == start) return;
      this.nextNode = current;
      step(start, current);
    }
  }
  
  void generateMaze(Node start){
    this.visited.clear(); this.track.clear();
    for(Node[] row : this.grid){
      for(Node node : row){
        node.setState(NodeState.Wall);
      }
    }
    start.setState(NodeState.None);
    this.visited.add(start); this.track.add(start);
    this.start = start;
    this.nextNode = start;
    step(start, start);
  }
  
  void nextStep(){
    if(this.start != null && this.nextNode != null){
      step(this.start, this.nextNode);
    }
  }
  
  ArrayList<Node[]> getPaths(Node node){
    ArrayList<Node> dirs = getSuroundingNodes(node, false);
    ArrayList<Node[]> paths = new ArrayList<Node[]>();
    for(Node dir : dirs){
      if (dir.y <= 0 || dir.y >= this.grid[0].length-1 || dir.x <= 0 || dir.x >= this.grid.length -1) { continue; }
      Node[] path = new Node[2]; path[0] = dir;
      path[1] = this.grid[dir.x*2 - node.x*1][dir.y*2 - node.y*1];
      //path[1] = this.grid[dir.x*3 - node.x*2][dir.y*3 - node.y*2];
      if(!visited.contains(path[1])){
        paths.add(path);
      }
    }
    return paths;
  
  }
}
