import java.util.Random;

public static final int TERRAIN_SIZE = 2048;
public static final float NOISE_SCALE = 0.01;
public static final Random r = new Random();
public static final TerrainUnit[][] map = new TerrainUnit[TERRAIN_SIZE][TERRAIN_SIZE];
private PGraphics buffer;

int screenPosX = TERRAIN_SIZE/2;
int screenPosY = TERRAIN_SIZE/2;

void setup() {
  size(1024, 768);
  noiseSeed(r.nextInt());
  buffer = createGraphics(TERRAIN_SIZE, TERRAIN_SIZE);
  buffer.beginDraw();
  for(int x = 0; x < TERRAIN_SIZE; ++x)
    for(int y = 0; y < TERRAIN_SIZE; ++y) {
      map[x][y] = new TerrainUnit(noise(x * NOISE_SCALE, y * NOISE_SCALE));
      buffer.set(x, y, map[x][y].type.typeColor);
    }
  buffer.endDraw();
}

void draw() {
  background(0);
  
  image(buffer, 0, 0);
}
