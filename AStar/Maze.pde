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
    Node dir = current; Node next = current;
    ArrayList<Node> dirs = getSuroundingNodes(current, false);
    for(int i = (int) (Math.random() * dirs.size()); dirs.size() > 0; i = (int) (Math.random() * dirs.size())){
      dir = dirs.get(i);
      if (dir.y <= 0 || dir.y >= this.grid[0].length-1 || dir.x <= 0 || dir.x >= this.grid.length -1) { dirs.remove(dir); continue; }
      next = this.grid[dir.x*2 - current.x*1][dir.y*2 - current.y*1];
      if(visited.contains(next)){
        dirs.remove(dir);
      } else {
        break;
      }
    }
    if(!dirs.isEmpty()){
      dir.setState(NodeState.None);
      next.setState(NodeState.None);
      this.visited.add(next); this.track.add(next);
      this.nextNode = next;
      step(start, next);
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
