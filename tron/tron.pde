class Player {  
  public int x, y, dx, dy, pcolor;
  
  public Player(int pcolor) {
    this.pcolor = pcolor;
  }
  
  public void update() {
    stroke(pcolor);
    line(x, y, x + dx, y + dy);
    x += dx;
    y += dy;
  }
}

final Player[] players = new Player[2];
final int bgColor = color(0);
boolean paused = false;

void setup() {
  size(512, 512);
  players[0] = new Player(color(255, 0, 0));
  players[1] = new Player(color(0, 255, 0));
  reset();
}

void draw() {
  for(int i = 0; i < 2; ++i) {
    Player p = players[i];
    if(p.dx != 0 ^ p.dy != 0 && (get(p.x + p.dx, p.y + p.dy) != bgColor || p.x < 0 || p.x > width || p.y < 0 || p.y > height)) {
      noFill();
      stroke(255);
      ellipse(p.x, p.y, 15, 15);
      pause();
    }
    p.update();
  }
}

void reset() {
  loop();
  paused = false;
  background(bgColor);
  players[0].x = 20;
  players[0].y = height / 2;
  players[1].x = width - 20;
  players[1].y = height / 2;
}

void pause() {
  for(Player p : players) {
    p.dx = 0;
    p.dy = 0;
  }
  noLoop();
  paused = true;
}

void keyPressed() {
  if(key == 'r') { reset(); return; }
  else if(paused) return;
  
  Player p1 = players[0], p2 = players[1];
  switch(key) {
    case 'w': 
      if(p1.dy == 0) {
        p1.dy = -1;
        p1.dx = 0;
      }
      break;
    case 's': 
      if(p1.dy == 0) {
        p1.dy = 1;
        p1.dx = 0;
      }
      break;
    case 'a':
      if(p1.dx == 0) {
        p1.dy = 0;
        p1.dx = -1;
      }
      break;
    case 'd':
      if(p1.dx == 0) {
        p1.dy = 0;
        p1.dx = 1;
      }
      break;
      
    case CODED:
      switch(keyCode) {
      case UP: 
        if(p2.dy == 0) {
          p2.dy = -1;
          p2.dx = 0;
        }
        break;
      case DOWN: 
        if(p2.dy == 0) {
          p2.dy = 1;
          p2.dx = 0;
        }
        break;
      case LEFT:
        if(p2.dx == 0) {
          p2.dy = 0;
          p2.dx = -1;
        }
        break;
      case RIGHT:
        if(p2.dx == 0) {
          p2.dy = 0;
          p2.dx = 1;
        }
        break;
      }
  }
}
