/* FRUITS OF CIVILIZATION
 * ERIDANUS COLLAZO (05.2011)
 *
 * GOAL OF PROJECT: To have a system in place where a full game world is generated, and the only user input is to 'seed'
 * a civilization, starting with one 'population' that is able to build cities, farms, etc that spawn more pops and fan out
 * to explore, settle other landmasses, etc. If you get really ambitious add so the player can spawn another civ(s) that will
 * compete/fight for resources.
 *
 * > Classes for terrain generation can be found in terrain_generation.pde.
 * > Classes for civilization AI can be found in civ_ai.pde
 */
 
import java.awt.Point;

// CONSTANTS
public final int TERRAIN_SIZE = 2000;
public final float NOISE_SCALE = 0.01;

public boolean CIV_STARTED = false;

// Globally initialize the necessary terrain generators for easy access
terrain[][] terrainmap;

// Set the CENTER of the screen to be at the exact center of the map
int screenPosX = TERRAIN_SIZE/2;
int screenPosY = TERRAIN_SIZE/2;

boolean displayPops = true;

// Initialize graphical and file I/O objects
PrintWriter output;
PFont font;
PGraphics buffer;

// Initialize a new population with zero elements
ArrayList<population> civ = new ArrayList<population> (0);
ArrayList<city> cit = new ArrayList<city> (0);
public int team = 7;

void setup() {
  size(900, 600);
  rectMode(CENTER);

  // Generate the map (including create and draw the map to the offscreen buffer)
  genMap();
  // Draw the buffer once so the screen isn't blank when the app starts
//  drawMap();
  
  font = createFont("LucidaConsole", 18);
  textFont(font);
}

void draw() {
  if (keyPressed) {
    switch(key) {
    case 'r':
    case 'R': 
      genMap();
      break;
    case 'q':
    case 'Q': 
      displayPops = !displayPops;
      break;
    case 'w':
    case 'W': 
      if (screenPosY-height/2 > 0) screenPosY-=50;
      break;
    case 's':
    case 'S': 
      if (screenPosY+height/2 < TERRAIN_SIZE) screenPosY+=50;
      break;
    case 'a':
    case 'A': 
      if (screenPosX-width/2 > 0) screenPosX-=50;
      break;
    case 'd':
    case 'D': 
      if (screenPosX+width/2 < TERRAIN_SIZE) screenPosX+=50;
      break;
    case 49:
    case 50:
    case 51:
    case 52:
    case 53:
    case 54:
    case 55: 
      team = key - 48;
    }
    drawMap();
  }
  if (mousePressed) {
    switch(mouseButton) {
    case LEFT:
      civ.add(new population(new Point(mouseX+screenPosX-width/2, mouseY+screenPosY-height/2), team, true, false));
      CIV_STARTED = true;
      break;
    case RIGHT:
      civ.add(new population(new Point(mouseX+screenPosX-width/2, mouseY+screenPosY-height/2), team, false, true));
      break;
    }
  }

  // If the screen ISN'T being moved, redraw the map and the civs every 5 frames so as to keep down on overhead
  if (frameCount % 5 == 0 && !keyPressed) {
    background(0);
    drawMap();
    drawCivs();
    drawCities();
  }

  drawUI();
}

void genMap() {
  long seed = (long)random(999999);
  println("Seed is " + seed);
  noiseSeed(seed);

  terrainmap = new terrainGen(TERRAIN_SIZE, new heightmapGen(TERRAIN_SIZE, NOISE_SCALE).getHeightmap(), NOISE_SCALE).getTerrainMap();

  drawBuff();
}

void drawBuff() {
  // Now that the terrain is generated and loaded, create a buffer to draw the map to for quick rendering
  buffer = createGraphics(TERRAIN_SIZE, TERRAIN_SIZE);
  buffer.beginDraw();
  buffer.background(0);
  // Draw the entire map to the buffer
  for (int x=0;x<buffer.width;x++) {
    for (int y=0;y<buffer.height;y++) {
      // Set the color of the point draw equal to the color indicated in the corresponding element of the terrainmap
      buffer.stroke(terrainmap[x][y].typeColor);
      // Then draw the point
      buffer.point(x, y);
    }
  }
  // Close the buffer
  buffer.endDraw();
//  terrainDrawer mapDraw = new terrainDrawer(buffer);
//  // Now draw the map to the buffer
//  mapDraw.start();
//  buffer = mapDraw.buffer;
}

void drawMap() {
  // Draw the buffer on the main screen
  image(getBufferSlice(), 0, 0);
}

PImage getBufferSlice() {
  // Gets the portion of the buffer (which contains the entire map) which will be visible on the screen
  return buffer.get(screenPosX-width/2, screenPosY-height/2, width, height);
}

void drawCivs() {
  // Run through all pops, run their AI scripts, and then display what they have done.
  for (int x=0;x<civ.size();x++) {
    population c = civ.get(x);
    if (displayPops) {
      if (c.location.x > screenPosX-width/2 &&
        c.location.x < screenPosX+width/2 &&
        c.location.y > screenPosY-height/2 &&
        c.location.y < screenPosY+height/2) {
        // display that pop
        civ.get(x).display();
      }
    }
    //Run the AI scripts
    c.move(x);
  }
}

void drawCities() {
  for (int x=0; x<cit.size(); x++) {
    city c = cit.get(x);
    if (c.location.x > screenPosX-width/2 &&
      c.location.x < screenPosX+width/2 &&
      c.location.y > screenPosY-height/2 &&
      c.location.y < screenPosY+height/2) {
      c.display();
      if ((int)random(250) == 1) createPop(new Point(c.location.x, c.location.y), x);
    }
  }
}
