float[][] heightmap;

void setup()
{
  size(500, 500);
  heightmap = new float[width][height];
  initialize(5000);
}

private void initialize(int iterations)
{
  background(255);
  
  for(int x = 0; x < width; x++)
    for(int y = 0; y < height; y++)
    {
      heightmap[x][y] = 1f; //noise(x * 0.05f, y * 0.05f);
      set(x, y, color(255 * heightmap[x][y]));
    }
      
  stroke(0, 128, 255);

  PVector initialPoint = new PVector((int)random(500), (int)random(500));
  ArrayList<PVector> points = new ArrayList<PVector>();
  int t = iterations;

  set((int)initialPoint.x, (int)initialPoint.y, color(0, 128, 255));
  points.add(initialPoint);
  
  for (int k = 0; k < iterations; k++)
  {
    int index = 0;
    PVector randomPoint = new PVector((int)random(500), (int)random(500));
    PVector nearestPoint = points.get(0);

    for (PVector p : points)
      if (MDist(p, randomPoint) < MDist(nearestPoint, randomPoint))
        nearestPoint = p;

    float theta = atan2(randomPoint.y - nearestPoint.y, randomPoint.x - nearestPoint.x);
    
    PVector newPoint = new PVector(nearestPoint.x + 2.0f * cos(theta), nearestPoint.y + 2.0f * sin(theta));

    if(MDist(newPoint, nearestPoint) > 2.3f)
    {
      points.add(newPoint);
      strokeWeight((t * 2.0f)/(float)iterations);
      line((int)newPoint.x, (int)newPoint.y, (int)nearestPoint.x, (int)nearestPoint.y);
      if(t > 0) t--;
      heightmap[(int)newPoint.x][(int)newPoint.y] = 0.0f;
      //set((int)newPoint.x, (int)newPoint.y, color(0));
    }
  }
  
//  for(int i = 0; i < 2; i++)
//    for(int x = width-1; x >= 0; x--)
//      for(int y = height-1; y >= 0; y--)
//      {
//        float lowHeight = 1.0f;
//        int[] d = {-1, 0, 1};
//        if(x - 1 >= 0 && x + 1 < width && y - 1 >= 0 && y + 1 < height)
//          for(int u : d)
//            for(int v : d)
//              if(lowHeight > heightmap[x + u][x + v] + noise(x*0.1f, y*0.1f) * 0.5f)
//                lowHeight = heightmap[x + u][x + v];
//                
//        heightmap[x][y] = lowHeight + 0.005f + noise(x*0.1f, y*0.1f) * 0.05f;
//        set(x, y, color(255 * heightmap[x][y]));
//      }
}

private float MDist(PVector p1, PVector p2)
{
  return (abs(p1.x - p2.x) + abs(p1.y - p2.y));
}

void draw()
{
}

void keyPressed()
{
  initialize(5000);
}

