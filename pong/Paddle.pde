public class Paddle
{
  private Rect myShape;
  public Vec2D Position;
  
  public Paddle(Vec2D position)
  {
    this.Position = position;
    myShape = new Rect(position.x, position.y, 20, 120);
  }
  
  public void Update(Ball ball)
  {
    if(myShape.intersectsRect(ball.getCollisionBox()))
      ball.Velocity.x *= -1 * myShape.getCentroid().distanceTo(ball.Position);
  }
  
  public void Display(ToxiclibsSupport gfx)
  {
    gfx.rect(myShape);
  }
}
