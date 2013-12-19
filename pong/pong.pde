  import toxi.processing.*;
import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.geom.mesh2d.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.util.*;

Ball ball;
Paddle p1, p2;
ToxiclibsSupport gfx;

void setup()
{
  size(800, 600);
  noStroke();
  smooth();
  gfx = new ToxiclibsSupport(this);
  ball = new Ball(new Vec2D(400, 300));
  p1 = new Paddle(new Vec2D(0, 240));
  p2 = new Paddle(new Vec2D(780, 240));
}

void keyPressed()
{
  switch(key)
  {
    case 'a': p1.Position.y-=2; break;
    case 'z': p1.Position.y+=2; break;
    case 'l': p2.Position.y-=2; break;
    case '.': p2.Position.y+=2; break;
  }
}

void draw()
{
  ball.Update();
  p1.Update(ball);
  p2.Update(ball);
  
  background(0);
  ball.Display(gfx);
  p1.Display(gfx);
  p2.Display(gfx);
}
