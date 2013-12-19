static final int NUM_PARTICLES = 15;

class MPoint {
  public float x, y, dx = 0, dy = 0;
  
  public MPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

MPoint[] ps = new MPoint[NUM_PARTICLES];
float speed = 1f;

void setup() {
  size(500, 500);
  background(0);
  fill(0, 0, 0, 10f);
  strokeWeight(4);
  for (int i = 0; i < NUM_PARTICLES; ++i)
    ps[i] = new MPoint(width / 2f, height / 2f);
}

void draw() {
  noStroke();
  rect(0, 0, width, height);
  for (int i = 0; i < NUM_PARTICLES; ++i) {
    MPoint p = ps[i];
    stroke(getColorComp(i), getColorComp(i + 20), getColorComp(i + 40));
    float angle = TWO_PI * // Map noise's (0, 1) range to (0, TWO_PI)
      noise(
        0.01f * p.x + 100f * i, // This makes the angle dependent on x pos as well as which point we refer to
        0.01f * p.y + 100f * i, // This makes the angle dependent on y pos as well as which point we refer to
        0.001f * millis() // This makes is so that the angle will always be changing based on time
      );
    p.dx = speed * cos(angle);
    p.dy = speed * sin(angle);
    line(p.x, p.y, p.x + p.dx, p.y + p.dy);
    p.x += p.dx;
    p.y += p.dy;
    
    if(p.x < 0) p.x = width - 1;
    else if(p.x >= width) p.x = 0;
    if(p.y < 0) p.y = height - 1;
    else if(p.y >= height) p.y = 0;
  }
}

int getColorComp(float offset) {
  return (int) (255 * noise(millis() * 0.001f, offset));
}
