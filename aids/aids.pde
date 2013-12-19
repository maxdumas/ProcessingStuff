public static final int SCREEN_WIDTH = 400;
public static final int SCREEN_HEIGHT = 400;

Type[][] map = new Type[SCREEN_WIDTH][SCREEN_HEIGHT];
  
void setup() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT, P2D);
  noiseDetail(8);
  initialize();
}

void initialize()
{
  noiseSeed((long)random(9999999));
  background(0);
  loadPixels();
  for (int x = 0; x < SCREEN_WIDTH; x++)
    for (int y = 0; y < SCREEN_HEIGHT; y++)
      if (noise(x * 0.005, y * 0.005) > 0.5) set(x, y, Type.OCEAN);
      else set(x, y, Type.UNINFECTED);
  updatePixels();
  seedInfection(true);
}

void seedInfection(boolean init)
{
  while (true)
  {
    int x = (int)random(SCREEN_WIDTH), y = (int)random(SCREEN_HEIGHT);
    if (map[x][y] == Type.UNINFECTED) { 
      if(init || (int)random(500) == 0) set(x, y, Type.UNDIAGNOSED); 
      else if((int)random(1000) == 0 && millis() > 10000) set(x, y, Type.VACCINATED);
      break;
    }
  }
}

void keyPressed()
{
  if (key == ' ') initialize();
}
void draw() {
  seedInfection(false);
  
  loadPixels();
  for (int x = 0; x < SCREEN_WIDTH; x++)
    for (int y = 0; y < SCREEN_HEIGHT; y++)
      switch(map[x][y])
      {
        case Type.UNDIAGNOSED:
          if ((int)random(100) == 0)
          {
            if (millis() > 10000) pixels[x + SCREEN_WIDTH * y] = red;
            else if ((int)random(5) == 0) pixels[x + SCREEN_WIDTH * y] = grey;
          }
          chooseNeighbor(x, y);
          break;
        case Type.DIAGNOSED: if((int)random(500) == 0) set(x, y, Type.DEAD); break;
        case Type.INFECTED_OCEAN: 
        case Type.VACCINATED_OCEAN: 
        case Type.VACCINATED:
          chooseNeighbor(x, y);
      }
  updatePixels();
}

void chooseNeighbor(int x, int y) {
  int[] i = {-1, 0, 1};
  int[] j = {-1, 0, 1};
  for (int k : i)
    for (int h : j)
      if ((int)random(100) == 0 && x+k < SCREEN_WIDTH && y+h < SCREEN_HEIGHT && x+k >= 0 && y+h >= 0) {
          if(map[x+k][y+h] == Type.OCEAN) set(x+k, y+h, (map[x][y] == Type.INFECTED_WATER || map[x][y] == Type.UNDIAGNOSED) ? Type.INFECTED_WATER : Type.VACCINATED_WATER);
          else if(map[x+h][y+h] == Type.UNINFECTED) set(x+k, y+h, (map[x][y] == Type.INFECTED_WATER || map[x][y] == Type.UNDIAGNOSED) ? Type.UNDIAGNOSED : Type.VACCINATED);
      }
}

void set(int x, int y, Type type)
{
  map[x][y] = type;
  pixels[x + SCREEN_WIDTH * y] == type.getValue();
}

