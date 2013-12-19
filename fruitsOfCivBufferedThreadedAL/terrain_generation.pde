public final int OCEAN = 0;
public final int BEACH = 1;
public final int GRASS = 2;
public final int FOREST = 3;
public final int FOREST_MOUNTAIN = 4;
public final int MOUNTAIN = 5;

// This is a holder class for the type of data a single point on the terrain needs
class terrain {
  int type;
  color typeColor;

  terrain(int type_, color typeColor_) {
    type = type_;
    typeColor = typeColor_;
  }
}

class heightmapGen {
  // Stores all the height value of a pixel (0-1)
  private float heightmap[][];
  // The size that the heightmap is going to be (heightmap MUST be square)
  private int _size;
  // The scale of the Perlin Noise (0.1 - 0.05 is usually good, but experiment)
  private float noiseScale;

  public heightmapGen(int size_,float noiseScale_) {
    _size = size_;
    noiseScale = noiseScale_;
    heightmap = new float[_size][_size];
    // Up the level of detail in the Perlin Noise
    noiseDetail(6);
    
    // Using a perlin noise filter, assign a perlin noise value to every element in the heightmap
    for(int x=0;x<_size;x++) {
      for(int y=0;y<_size;y++) {
        heightmap[x][y] = noise(x*noiseScale,y*noiseScale);
      }
    }
  }

  public float[][] getHeightmap() {
    return heightmap;
  }

  public int getSize() {
    return _size;
  }
}

class terrainGen {
  terrain terrainmap[][];

  public terrainGen(int size_, float[][] heightmap, float noiseScale) {
    terrainmap = new terrain[size_][size_];
    for(int x=0;x<size_;x++) { // Run through the entire heightmap
      for(int y=0;y<size_;y++) {
        color c = color(#FF0000); // Make it blindingly obvious if this isn't working right
        int type = 99;
        // If the noise has a value less than...
        if(heightmap[x][y] < 0.55) { // 0.55, it's ocean
          type = OCEAN;
          // Set the color as a function of its height
          c = color(0,127*cos(TWO_PI*(heightmap[x][y]+0.35)),255*heightmap[x][y]+55);
        }
        else if(heightmap[x][y] < 0.56) { // 0.56, it's beach
          type = BEACH;
          c = color(#E5E5A7);
        }
        else if(heightmap[x][y] < 0.75) { // 0.75, it's land
          // Use another perlin noise to determine where forest should be, also it has to be over 0.65
          if(noise((x+size_)*noiseScale*2,(y+size_)*noiseScale*2) > 0.5 && heightmap[x][y] > 0.65) {
            type = FOREST;
            c = color(#007700);
          }
          else { // If it's not in that perlin noise or over 0.65, it's grass
            type = GRASS;
            c = color(255*sin(heightmap[x][y]-.35),255*heightmap[x][y],255*sin(heightmap[x][y]-.6));
          }
        }
        else if(heightmap[x][y] < 1) { // 1, it's mountain
          // Use the forest perlin to determine where the forested mountains should be
          if(noise((x+size_)*noiseScale*2,(y+size_)*noiseScale*2) > 0.5) {
            type = FOREST_MOUNTAIN;
            c = color(255*cos(TWO_PI*heightmap[x][y])-35,255*heightmap[x][y]-60,255*cos(TWO_PI*heightmap[x][y])-60);
          }
          else { // If it's not a forested mountain, it's just a mountain
            type = MOUNTAIN;
            //c = color(255*cos(heightmap[x][y]),255*heightmap[x][y],255*cos(TWO_PI*(heightmap[x][y])));
            c = color(255*heightmap[x][y]);
          }
        }
        // After we've cleared up what the type and color of a point should be, actually assign it to that point in the terrainmap
        terrainmap[x][y] = new terrain(type, c);
      }
    }
  }

  public terrain[][] getTerrainMap() {
    return terrainmap;
  }
}

// This terrainDrawer is MULTITHREADED, allowed for the map to be drawn SIMLUTANOEOUSLY with the animation loop 
// without the game halting, but currently the map is shown at the amount it has been drawn
// frame per frame, (Press T in-game to see), for this to be truly effective, it needs to only 
// update the buffer with the completed copy of the new map
class terrainDrawer extends Thread {
  PGraphics buffer;
  boolean running;

  terrainDrawer(PGraphics buffer_) {
    buffer = buffer_;
  }

  void start() {
    // Start the thread
    running = true;
    super.start();
  }

  void run() {
    // Running is set to false at the end of the first run of the loop, so it really only runs once per time it is called
    while(running) {
      // Initialize the buffer
      buffer.beginDraw();
      buffer.background(0);
      // Draw the entire map to the buffer
      for(int x=0;x<buffer.width;x++) {
        for(int y=0;y<buffer.height;y++) {
          // Set the color of the point draw equal to the color indicated in the corresponding element of the terrainmap
          buffer.stroke(terrainmap[x][y].typeColor);
          // Then draw the point
          buffer.point(x,y);
        }
      }
      // Close the buffer
      buffer.endDraw();
      // End the thread
      quit();
    }
  }

  void quit() {
    running = false;
  }
}

