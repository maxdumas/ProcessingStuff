public class Ball
{
  private Circle myShape;
  private Rect CollisionBox;
  public Vec2D Position, Velocity;
  
  public Ball(Vec2D position)
  {
    this.Position = position;
    myShape = new Circle(position, 10);
    CollisionBox = new Rect(position.x-5, position.y-5, 5, 5);
    Velocity = new Vec2D(-2, 0);
  }
  
  public void Update()
  {
    Velocity.x = constrain(Velocity.x, -10f, 10f);
    Velocity.y = constrain(Velocity.y, 0f, 10f);
    Position.x += Velocity.x;
    Position.y += Velocity.y; 
    myShape = new Circle(Position, 10);
    CollisionBox.setPosition(new Vec2D(Position.x-5, Position.y-5));
  }
  
  public Rect getCollisionBox()
  {
    return CollisionBox;
  }
  
  public void Display(ToxiclibsSupport gfx)
  {
    gfx.ellipse(myShape);
  }
}
