import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class rrt extends PApplet {

public void setup()
{
  size(500, 500);
  initialize();
}

private void initialize()
{
  println("Doobin!");
  background(255);

  PVector initialPoint = new PVector((int)random(500), (int)random(500));
  ArrayList<PVector> points = new ArrayList<PVector>();
  int t = 500;

  set((int)initialPoint.x, (int)initialPoint.y, color(0));
  points.add(initialPoint);
  for (int k = 0; k < 5000; k++)
  {
    int index = 0;
    PVector randomPoint = new PVector((int)random(500), (int)random(500));
    PVector nearestPoint = points.get(0);

    for (int i = 1; i < points.size(); i++)
      if (MDist(points.get(i), randomPoint) < MDist(nearestPoint, randomPoint))
        nearestPoint = points.get(i);

    float theta = atan2(randomPoint.y - nearestPoint.y, randomPoint.x - nearestPoint.x);
    //if(theta > PI / 2.5f) throw new NumberFormatException();
    PVector newPoint = new PVector(nearestPoint.x + 2.0f * cos(theta), nearestPoint.y + 2.0f * sin(theta));

    if(MDist(newPoint, nearestPoint) > 2.3f)
    {
      points.add(newPoint);
      strokeWeight(t/100.0f);
      stroke(255 - (255 * (t/250.0f)));
      line((int)newPoint.x, (int)newPoint.y, (int)nearestPoint.x, (int)nearestPoint.y);
      if(t > 0) t--;
      //set((int)newPoint.x, (int)newPoint.y, color(0));
    }
  }
}

private float MDist(PVector p1, PVector p2)
{
  return (abs(p1.x - p2.x) + abs(p1.y - p2.y));
}

public void draw()
{
}

public void keyPressed()
{
  initialize();
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F5F5F5", "rrt" });
  }
}
