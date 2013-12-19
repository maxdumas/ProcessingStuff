abstract class civilization {
  Point location;
  int team;
  boolean settler;
  boolean warrior;
  color teamColor;
}

class population extends civilization {
  int lastDir = 0;
  int oxygen = (int)random(80, 120);

  population(Point location_, int team_, boolean settler_, boolean warrior_) {
    location = location_;
    team = team_;
    settler = settler_;
    warrior = warrior_;
    assignColors();
  }

  void move(int arrayElement) {
    int dir = (int)random(4);

    if (terrainmap[location.x][location.y].type != 0) oxygen = (int)random(80, 120);

    if (settler || warrior) dir = settlerMove(dir, arrayElement);
    else {
      if (terrainmap[location.x+1][location.y].type == 0 && dir == 0) dir = 2;
      else if (terrainmap[location.x][location.y+1].type == 0 && dir == 1) dir = 3;
      else if (terrainmap[location.x-1][location.y].type == 0 && dir == 2) dir = 0;
      else if (terrainmap[location.x][location.y-1].type == 0 && dir == 3) dir = 1;
      else if (terrainmap[location.x][location.y].type == 3 && (int)random(2) == 1) 
        terrainmap[location.x][location.y].type = 2;
    }

    if ((location.x <= 1 && dir == 2) || (location.y <= 1 && dir == 3)) dir-=2;
    else if ((location.x >= TERRAIN_SIZE-2 && dir == 0) || (location.y >= TERRAIN_SIZE-2 && dir == 1)) dir+=2;
    lastDir = dir;

    if (dir == 0) location.x++;
    else if (dir == 1) location.y++;
    else if (dir == 2) location.x--;
    else if (dir == 3) location.y--;
  }

  int settlerMove(int dir, int arrayElement) {
    
    switch(terrainmap[location.x][location.y].type) {
      case OCEAN: // If on ocean do this
        oxygen--;
        if (oxygen == 0) killPop(arrayElement);
        if ((int)random(5) == 1) {
          int randomDir = (int)random(4);
          if (randomDir == 0 && dir != 0) location.x++;
          else if (randomDir == 1 && dir != 1) location.y++;
          else if (randomDir == 2 && dir != 2) location.x--;
          else if (randomDir == 3 && dir != 3) location.y--;
        }
        return lastDir;
      default: // If on anything else
        if (settler && (int)random(2000) == 1) createCity(location, arrayElement);
        else if(warrior) attack(arrayElement);
        if (terrainmap[location.x+1][location.y].type == 0 && dir == 0 && (int)random(20) != 0) return 2;
        else if (terrainmap[location.x][location.y+1].type == 0 && dir == 1 && (int)random(20) != 0) return 3;
        else if (terrainmap[location.x-1][location.y].type == 0 && dir == 2 && (int)random(20) != 0) return 0;
        else if (terrainmap[location.x][location.y-1].type == 0 && dir == 3 && (int)random(20) != 0) return 1;
        else return dir;
    }
  }

  void attack(int arrayElement) {
    int target = getTarget(arrayElement);
    if (warrior && target != -1 && (int)random(16) == 1) killPop(target);
  }

  int getTarget(int arrayElement) {
    int target = -1;
    for (int x=0;x<civ.size();x++) {
      civilization c = civ.get(arrayElement);
      if ((((c.location.x == civ.get(x).location.x) && (c.location.y == civ.get(x).location.y))
        || (((c.location.x == civ.get(x).location.x+1) || (c.location.x == civ.get(x).location.x-1))
        && ((c.location.y == civ.get(x).location.y-1) || (c.location.y == civ.get(x).location.y+1))))
        && (c.team != civ.get(x).team)) target = x;
    }
    return target;
  }
  
  void assignColors() {
    if (settler) {
      switch(this.team) {
        case 1:teamColor = color(#FF0000);break;
        case 2:teamColor = color(#00FF00);break;
        case 3:teamColor = color(#0000FF);break;
        case 4:teamColor = color(#F5A607);break;
        case 5:teamColor = color(#FFFF00);break;
        case 6:teamColor = color(#CE30CE);break;
        case 7:teamColor = color(#FFFFFF);break;
      }
    }
    else if (warrior) {
      switch(this.team) {
        case 1:teamColor = color(#7C0909);break;
        case 2:teamColor = color(#0A7E09);break;
        case 3:teamColor = color(#04056C);break;
        case 4:teamColor = color(#A06F0D);break;
        case 5:teamColor = color(#C6C418);break;
        case 6:teamColor = color(#A21FA2);break;
        case 7:teamColor = color(#000000);break;
      }
    }
  }

  void display() {
    stroke(teamColor);
    point(location.x-(screenPosX-width/2), location.y-(screenPosY-height/2));
  }
}

class city extends civilization {
  Point[] blocks = new Point[10];

  city(Point location_, int team_) {
    location = location_;
    blocks[0] = location;
    team = team_;
    assignColors();

    for (int x=1;x<blocks.length;x++) {
      int nextToSeed = (int)random(4);
      switch(nextToSeed) {
        case 0:blocks[x] = new Point(blocks[x-1].x+1, blocks[x-1].y);break;
        case 1:blocks[x] = new Point(blocks[x-1].x, blocks[x-1].y-1);break;
        case 2:blocks[x] = new Point(blocks[x-1].x-1, blocks[x-1].y);break;
        case 3:blocks[x] = new Point(blocks[x-1].x, blocks[x-1].y+1);break;
      }
    }
  }
  
  void assignColors() {
    switch(this.team) {
      case 1:teamColor = color(#F29595);break;
      case 2:teamColor = color(#8FF28E);break;
      case 3:teamColor = color(#4A4BC6);break;
      case 4:teamColor = color(#E0C181);break;
      case 5:teamColor = color(#F5F38A);break;
      case 6:teamColor = color(#C443BC);break;
      case 7:teamColor = color(127);break;
    }
  }
  
  void display() {
    stroke(teamColor);
    for (Point x : blocks) {
      point(x.x-(screenPosX-width/2), x.y-(screenPosY-height/2));
    }
  }
}

void createCity(Point location, int arrayElement) {
  cit.add(new city(location, civ.get(arrayElement).team));
  killPop(arrayElement);
}

void createPop(Point location, int arrayElement) {
  if ((int)random(2) == 1) civ.add(new population(location, cit.get(arrayElement).team, true, false));
  else civ.add(new population(location, cit.get(arrayElement).team, false, true));
}

void killPop(int arrayElement) {
  civ.remove(arrayElement);
}
