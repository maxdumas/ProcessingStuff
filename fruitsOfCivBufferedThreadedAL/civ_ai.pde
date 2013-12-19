// Sorry for lack of comments, ask later if you can't fiogure out

class civilization {
  PVector location;
  int count;
  
  void display() {}  
  void move(){}
}

class population extends civilization {
  boolean settler;
  int lastDir = 0;

  population(PVector location_, boolean settler_) {
    location = location_;
    settler = settler_;
  }

  void move() {
    int dir = (int)random(4);

    if(settler) dir = settlerMove(dir);
    else {
      if(terrainmap[(int)location.x+1][(int)location.y].type == 0 && dir == 0) dir = 2;
      else if(terrainmap[(int)location.x][(int)location.y+1].type == 0 && dir == 1) dir = 3;
      else if(terrainmap[(int)location.x-1][(int)location.y].type == 0 && dir == 2) dir = 0;
      else if(terrainmap[(int)location.x][(int)location.y-1].type == 0 && dir == 3) dir = 1;
      else if(terrainmap[(int)location.x][(int)location.y].type == 3 && (int)random(2) == 1) terrainmap[(int)location.x][(int)location.y].type = 2;
    }

    if((location.x <= 1 && dir == 2) || (location.y <= 1 && dir == 3)) dir-=2;
    else if((location.x >= TERRAIN_SIZE-2 && dir == 0) || (location.y >= TERRAIN_SIZE-2 && dir == 1)) dir+=2;
    lastDir = dir;

    if(dir == 0) location.x++;
    else if(dir == 1) location.y++;
    else if(dir == 2) location.x--;
    else if(dir == 3) location.y--;
  }

  int settlerMove(int dir) {
    // Make it so if they are a settler, they have the ability to move off-land and travel across the sea in a reasonably straight line, die if they don't reach land for a while
    
    if(terrainmap[(int)location.x][(int)location.y].type != 0) {
      if((int)random(1000) == 1) createCity(location);
      if(terrainmap[(int)location.x+1][(int)location.y].type == 0 && dir == 0 && (int)random(20) != 0) return 2;
      else if(terrainmap[(int)location.x][(int)location.y+1].type == 0 && dir == 1 && (int)random(20) != 0) return 3;
      else if(terrainmap[(int)location.x-1][(int)location.y].type == 0 && dir == 2 && (int)random(20) != 0) return 0;
      else if(terrainmap[(int)location.x][(int)location.y-1].type == 0 && dir == 3 && (int)random(20) != 0) return 1;
      else return dir;
    }
    else {
      if((int)random(5) == 1) {
        int randomDir = (int)random(4);
        if(randomDir == 0 && dir != 0) location.x++;
        else if(randomDir == 1 && dir != 1) location.y++;
        else if(randomDir == 2 && dir != 2) location.x--;
        else if(randomDir == 3 && dir != 3) location.y--;
      }
      return lastDir;
    }
  }
  
  void display() {
    stroke(255);
    point(location.x-(screenPosX-width/2),location.y-(screenPosY-height/2));
  }
}



class city extends civilization {
  PVector[] blocks = new PVector[10];
  
  city(PVector location_) {
    location = location_;
    blocks[0] = location;
    count = 0;
    for(int x=1;x<blocks.length;x++) {
      int nextToSeed = (int)random(4);
      if(nextToSeed == 0) blocks[x] = new PVector(blocks[x-1].x+1,blocks[x-1].y);
      else if(nextToSeed == 1) blocks[x] = new PVector(blocks[x-1].x,blocks[x-1].y-1);
      else if(nextToSeed == 2) blocks[x] = new PVector(blocks[x-1].x-1,blocks[x-1].y);
      else if(nextToSeed == 3) blocks[x] = new PVector(blocks[x-1].x,blocks[x-1].y+1);
    }
  }
  
  void display() {
    stroke(127);
    for(PVector x : blocks) {
      point(x.x-(screenPosX-width/2),x.y-(screenPosY-height/2));
    }
  }
}


void createCity(PVector location) {
  civ.add(new city(location));
}

void createPop(PVector location) {
  civ.add(new population(location, true));
}
