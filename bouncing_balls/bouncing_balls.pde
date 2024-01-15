int NUM_BALLS = 20;
float ACC = 9.8/20;
BouncingBall[] balls = new BouncingBall[NUM_BALLS];
float ELASTICITY_FACTOR = 1.05;

class BouncingBall
{
  public float posX;
  public float posY;
  public float velocity;
  public float velocityX = 5.0;
  public color colour;
  private float diameter;
  private float radius;
  
  BouncingBall(float x, float y, float v, color c, float r)
  {
    posX = x;
    posY = y;
    velocity = v;
    colour = c;
    radius = r;
    diameter = r*2;
  }
  
  void update_position(float ACC)
  {
    posY += velocity;
    velocity += ACC;
  }
  
  void draw_in_canvas()
  {
    //noStroke();
    fill(colour);
    circle(posX, posY, diameter);
  }
}

void setup() {
  fullScreen();
  //size(1920, 1080); //<>//
  for (int i = 0; i < NUM_BALLS; i++) {
    float posX = random(width);
    float posY = random(height);
    float velocity = random(-20, 20);
    float velocityX = random(-20, 20);
    color colour = color(random(255), random(255), random(255));
    float radius = random(20, 100);
    float correction = 0.0;
    if (posY + radius >= height) {
      correction = (posY+radius) - height + 10.0;
    }
    balls[i] = new BouncingBall(posX, posY-correction, velocity, colour, radius);
    balls[i].velocityX = velocityX;
  }
  background(0, 0, 0);
  colorMode(HSB, 360, 100, 100);
}


boolean hit_walls(BouncingBall currentBall) {
    boolean touching_ceiling = (currentBall.posY - currentBall.radius) <= 0;
    if (touching_ceiling) {
      currentBall.velocity = -currentBall.velocity * ELASTICITY_FACTOR;
      return true;
    }
    boolean touching_ground = (currentBall.posY + currentBall.radius) >= height;
    if (touching_ground) {
      currentBall.velocity = -currentBall.velocity * ELASTICITY_FACTOR;
      return true;
    }
    boolean touching_right_wall = (currentBall.posX + currentBall.radius) >= width;
    if (touching_right_wall) {
      currentBall.velocityX = -currentBall.velocityX * ELASTICITY_FACTOR;
      return true;
    }
    boolean touching_left_wall = (currentBall.posX - currentBall.radius) <= 0;
    if (touching_left_wall) {
      currentBall.velocityX = -currentBall.velocityX * ELASTICITY_FACTOR;
      return true;
    }
    return false;
}

void draw() {
  float r = ((1.0 + sin(millis() / 300.0)) / 2.0) * 100;
  float g = 100.0;
  float b = ((1.0 + cos(millis() / 300.0)) / 2.0) * 100;

  //background(r, g, b);
  BouncingBall currentBall;
  for (int i = 0; i < NUM_BALLS; i++) {
    currentBall = balls[i];
    boolean has_hit = hit_walls(currentBall);
    if (has_hit) {
      currentBall.colour += (currentBall.colour + 1) % 360;
    }
    currentBall.posX += currentBall.velocityX;
    currentBall.update_position(ACC);
    currentBall.draw_in_canvas();
  }
  
  fill(0, 0, 0, 5);
  rect(0, 0, width, height);
}
