class Snow {
  float x; 
  float y;
  float alpha;
  float diameter;
  float speed = random(.1, .9);
  float descentX;
  PImage snow;

  Snow (float tempD) {
    x = random(width);
    y = random(height - height/2 -50);
    diameter = tempD;
   snow = loadImage("bar2.png");
  } 


  void spreadY(int i) {
    x = x + i*1;
    y = y + i*3;
  }
  
  void display() {
     alpha = map(-100, 0, width, 100, -50);
    noStroke();
    fill(255, alpha -99);
    image(snow,x, y, diameter, diameter);
    x = x + speed/2;
    
    //checking the boundary
    if (x > width-5) {
      x = -diameter;
    }
    
    //if (y < 0-50) {
      //y = height+diameter;} 
      //else if (x > height+50){
      //y = 0-diameter;
    //}
    
    }
 // void bounce(){
  //  x = x - speed; 
//}
}
