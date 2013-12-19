static final int NUM_PARTICLES = 10;

float[] xs = new float[NUM_PARTICLES];
float[] ys = new float[NUM_PARTICLES];
float[] dxs = new float[NUM_PARTICLES];
float[] dys = new float[NUM_PARTICLES];
float speed = 1f;

void setup() {
  size(500, 500);
  background(0);
  stroke(255);
  strokeWeight(4);
  for (int i = 0; i < NUM_PARTICLES; ++i) {
    xs[i] = width / 2f;
    ys[i] = height / 2f;
  }
}

void draw() {
  for (int i = 0; i < NUM_PARTICLES; ++i) {
    stroke(getColorComp(i), getColorComp(i + 20), getColorComp(i + 40));
    float angle = TWO_PI * // Map noise's (0, 1) range to (0, TWO_PI)
      noise(
        0.01f * p.x + 100f * i, // This makes the angle dependent on x pos as well as which point we refer to
        0.01f * p.y + 100f * i, // This makes the angle dependent on y pos as well as which point we refer to
        0.001f * millis() // This makes is so that the angle will always be changing based on time
      );
    dxs[i] = speed * cos(angle);
    dys[i] = speed * sin(angle);
    line(xs[i], ys[i], xs[i] + dxs[i], ys[i] + dys[i]);
    xs[i] += dxs[i];
    ys[i] += dys[i];
    
    if(xs[i] < 0) xs[i] = width - 1;
    else if(xs[i] >= width) xs[i] = 0;
    if(ys[i] < 0) ys[i] = height - 1;
    else if(ys[i] >= height) ys[i] = 0;
  }
}

int getColorComp(float offset) {
  return (int) (255 * noise(millis() * 0.001f, offset));
}

