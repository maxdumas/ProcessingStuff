/* FRUITS OF CIVILIZATION (BRANCH 1 WITH BUFFERED MAP RENDER AND ARRAYLISTS)
 * MAX DUMAS (04.2011)
 * GOAL OF PROJECT: To have a system in place where a full game world is generated, and the only user input is to 'seed'
 * a civilization, starting with one 'population' that is able to build cities, farms, etc that spawn more pops and fan out
 * to explore, settle other landmasses, etc. If you get really ambitious add so the player can spawn another civ(s) that will
 * compete/fight for resources.
 * 
 * ERIDANUS: Biggest issue with current code is city garbage, as in very dense areas seperate cities created by different settlers
 *           layered over one another can cause 100+ points to be rendered at the same point, extremely inefficient...
 *           The reason I did this was because before when I was using arrays it was otherwise impossible to delete a settler, but I quickly moved
 *           everything over to ArrayLists, meaning you could redesign the system so that there is a seperate array storing city pixels, and delete a settler
 *           from the civ ArrayList when he creates a city, and expand the city array with new city locations (see the city generation code in civ_ai.pde).
 *
 * Maybe a minimap too, that's just like width/10 by height/10 and exists to show what part of the map you are looking at?
 *
 * > Classes for terrain generation can be found in terrain_generation.pde.
 * > Classes for civilization AI can be found in civ_ai.pde (TO-DO)
 * 
 */


// CONSTANTS
public final int TERRAIN_SIZE = 2000;
public final float NOISE_SCALE = 0.01;

public boolean CIV_STARTED = false;

// Globally initialize the necessary terrain generators for easy access
heightmapGen hmapGen;
terrainGen tGen;
float[][] heightmap;
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
ArrayList<civilization> civ = new ArrayList<civilization> (0);

void setup() {
  size(1000,800,P2D);
  
  rectMode(CENTER);

  output = createWriter("output.txt");
  // Generate the map (including create and draw the map to the offscreen buffer)
  genMap();
  // Draw the buffer once so the screen isn't blank when the app starts
//  drawMap();
  
  // BEGIN LOG OUTPUT
  output.print("Generated with " + (int)random(10000,9999999) + " iterations in " + millis()/1000 + " seconds.");
  output.flush();
  output.close();
  // END LOG OUTPUT
  
  // Initialize the the font to be drawn on-screen
  font = createFont("LucidaConsole",18);
  textFont(font);
}

void draw() {
  if(keyPressed) {
    if(key == 'r' || key == 'R') genMap();
    // If the screen is not already at an edge, WASD moves the screen position
    else if((key == 'w' || key == 'W') && screenPosY-height/2 > 0) screenPosY-=50;
    else if((key == 's' || key == 'S') && screenPosY+height/2 < TERRAIN_SIZE) screenPosY+=50;
    else if((key == 'a' || key == 'A') && screenPosX-width/2 > 0) screenPosX-=50;
    else if((key == 'd' || key == 'D') && screenPosX+width/2 < TERRAIN_SIZE) screenPosX+=50;
    
    else if(key == 'q' || key == 'Q') displayPops = !displayPops;
    
    else if(key == 'p' || key == 'P') println("There are " + civ.size() + " pops currently");
    
    // When the screen is being moved, display everything at the full framerate so things don't seem laggy
    drawMap();
    //drawCivs();
  }
  if(mousePressed) {// && !CIV_STARTED) {
    civ.add(new population(new PVector(mouseX+screenPosX-width/2,mouseY+screenPosY-height/2), true));
    CIV_STARTED = true;
  }
  // If the screen ISN'T being moved, redraw the map and the civs every 5 frames so as to keep down on overhead (looks nicer too, IMO)
  if(frameCount % 5 == 0) {
    background(0);
    drawMap();
    drawCivs();
  }
  
  // BEGIN UI DISPLAY
  fill(terrainmap[mouseX+screenPosX-width/2][mouseY+screenPosY-height/2].typeColor);
  stroke(0);
  rect(60,height-20,100,30);
  fill(255);
  text("TYPE = " + terrainmap[mouseX+screenPosX-width/2][mouseY+screenPosY-height/2].type,15,height-13);
  // END UI DISPLAY
}

void genMap() {
  long seed = (long)random(999999);
  println("Seed is " + seed);
  noiseSeed(seed);
  
  // Create a new heightmap, passing in the size of the terrain and noise scale constants
  hmapGen = new heightmapGen(TERRAIN_SIZE, NOISE_SCALE);
  // Initialize the heightmap that the game will load the created heightmap into
  heightmap = new float[TERRAIN_SIZE][TERRAIN_SIZE];
  // Load the created heightmap into the container for the heightmap
  heightmap = hmapGen.getHeightmap();
  // Create a new terrain map, passing in the size of the terrain, the target heightmap to generate from, and the noise scale,
  // that noise scale being for the generation of forests (it is multiplied by 2)
  tGen = new terrainGen(TERRAIN_SIZE, heightmap, NOISE_SCALE);
  // Initialize the container for the generated terrainmap
  terrainmap = new terrain[TERRAIN_SIZE][TERRAIN_SIZE];
  // Load the created terrainmap into the container for the terrainmap
  terrainmap = tGen.getTerrainMap();
  drawBuff();
}

void drawBuff() {
  // Now that the terrain is generated and loaded, create a buffer to draw the map to for quick rendering
  buffer = createGraphics(TERRAIN_SIZE,TERRAIN_SIZE,P2D);
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
//  terrainDrawer mapDraw = new terrainDrawer(buffer);
//  // Now draw the map to the buffer
//  mapDraw.start();
//  buffer = mapDraw.buffer;
}

void drawMap() {
  // Draw the buffer on the main screen
  image(getBufferSlice(),0,0);
}

PImage getBufferSlice() {
  // Gets the portion of the buffer (which contains the entire map) which will be visible on the screen
  return buffer.get(screenPosX-width/2,screenPosY-height/2,width,height);
}

void drawCivs() {
  // Run through all pops, run their AI scripts, and then display what they have done.
  for(civilization c : civ) {
    // Run the AI script
    c.move();
    // If they are a city that has spawned less than 20 people, there is a 1/100 chance they will spawn another guy at their location
    if((int)random(100) == 1 && c instanceof city && c.count < 20) {
      createPop(new PVector(c.location.x, c.location.y));
      // Increase the count for the number of people spawned after spawning something
      c.count++;
    }
    // If they are within the screen...
    if(c.location.x > screenPosX-width/2 &&
       c.location.x < screenPosX+width/2 &&
       c.location.y > screenPosY-height/2 &&
       c.location.y < screenPosY+height/2) {
         // and if they are a population, and we are supposed to be displaying pops, display that pop
         if(c instanceof population && displayPops) c.display();
         // and if they are a city, display the city
         else if(c instanceof city) c.display();
       }
  }
}

