/** //<>// //<>// //<>// //<>//
 This program is an audio visualiser that tracks the position length of track 
 to create a line that tells how much time has passed. The concept of the sketch was to 
 make a proffesional looking audio visualiser like the ones on vevo's Youtube Channel.
 
 
 note: due to processing's limitations, I couldn't implement any glowing 
 graphics from scratch without affecting the framerate; all of it was done with png's.
 */


import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       context;
AudioPlayer player;
FFT         fft;
AudioMetaData meta;//class for making processing to get the data of the mp3 that is being played.

// ---------------------------------------------------------------------------------------------
PImage sunset; //background
PImage bar;//png of glowing white light
PImage vevo;//logo
PImage shadow; //mirrors the bars.
PImage glow; //glowing cirlces below the bars
PImage krewella; //arist name 
PImage alive;// track name
PImage globe; // cog image to spin around for decorative effect.
PImage symbol; // 

//images to set an area in sketch that pause, or play the sample again.
PImage play;
PImage pause;

PFont font; //font for the position slider
int aplhaValue = 40; //creates the blur effect of bars. 

float speed = 0;// starting angle of cog.

int time = 0;
int timePassed = 0;

Snow[] flakes = new Snow[300]; 

// ---------------------------------------------------------------------------------------------
void setup() { 

  size(displayWidth, displayHeight, P3D);  

  // ---------------------------------------------------------------------------------------------
  sunset = loadImage("180798.jpg");
  bar = loadImage("bar.png");
  vevo = loadImage("Seven_Lions_logo_(white).png");
  shadow = loadImage("shadow.png");
  glow = loadImage("glow.png");
  krewella = loadImage("sl2.png");
  alive = loadImage("lionLogo.png");
  globe =  loadImage("globe.png");
  symbol =  loadImage("Symbol.png");
  play = loadImage("play-button.png");
  pause = loadImage("pause.png");
  
  
  for (int i = 0; i<flakes.length; i++) { 
    flakes[i] = new Snow(random(2, 7));
    flakes[i].spreadY(i);
  }
  
  // ---------------------------------------------------------------------------------------------  
  font = loadFont("TidyCurveTV-48.vlw"); 
  // ---------------------------------------------------------------------------------------------
  noStroke();

  context = new Minim(this);

  // specify that we want the audio buffers of the AudioPlayer
  // to be 1024 samples long because our FFT needs to have 
  // a power-of-two buffer size and this is a good size.
  player = context.loadFile("Seven Lions Myon  Shane 54 - Strangers (Radio Edit) [Lyric Video] ft. Tove Lo.mp3", 1024);

  // loop the file indefinitely
  player.loop();

  // create an FFT object that has a time-domain buffer 
  // the same size as player's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be half as large.
  fft = new FFT( player.bufferSize(), player.sampleRate() );

  //argument 1 is width of first band in Hz
  //argument 2 is how many bands per octave
  //results in averages of an octave each. 
  //The first band is 0-11 hz

  //create 30 log averages.
  fft.logAverages( 11, 4 );  

  // ---------------------------------------------------------------------------------------------
  //make the background slightly blurry so the HUD display is more focused on screen.
  sunset.filter(BLUR, 2);
  // ---------------------------------------------------------------------------------------------
}
// ---------------------------------------------------------------------------------------------
void draw() { 
  
  
  imageMode(CENTER);
  image(sunset, width/2, height/2, width , height );
  
  
  
  for (int i = 0; i < flakes.length; i++) {
    flakes[i] .display();
  }
  
  //fucntions for the HUD numbers on each side:
  textFont(font);
  textSize(40);
 
 timePassed = millis();
 time = millis() + timePassed;

if(time >= 168000 ){
    image(sunset, width/2, height/2, width + random(50) , height + random(50) );
  }

  // --------------------------------------------------------------------------------------------- 
  
  //rotating cog in the middle of screen.
  speed += 0.003;
  pushMatrix();
  translate(width/2 + 245, height/2+ 81);
  rotate(speed);
  //tint(255,20);
  image(globe, 0, 0, 80, 80);
  rotate(-speed*2);
  image(globe, 0, 0, 20, 20); 
  popMatrix();

  // ---------------------------------------------------------------------------------------------
  // perform a forward FFT on the samples in player's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( player.mix );
  
 
  
  //get the average of frequency spectrum.
  int colWidth = width/fft.avgSize();
  for (int i = 0; i < fft.avgSize(); i++)
  {


    // ---------------------------------------------------------------------------------------------   
    //FFT (rectangle bars:
    fill(255);
    // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
    rect( (i*20)+300, height/2 -50, colWidth/2, (-i%2/9)*50 - fft.getAvg(i)*2 );
    fill(255, 255, 255, 255);
    rect( (i*20)+300, -fft.getAvg(i)*2 + 370, colWidth/2, 0.5 );


    //image shadow mirrors the white bars to get averages of i in the opposite direction
    //this creates a reflection at the bottom of the screen.
    image(shadow, (i*20)+300, height/2 + 280, colWidth/2, (-i%2/9)*8- fft.getAvg(i)*2);

    //glowing circles that detect kick drum:
    float var = 2/fft.getAvg(i/20) -20;
    float nVar = fft.getAvg(i);
     image(bar, (i*20)+305, height/2 - 20, nVar ,  nVar ); 
    image(bar, (i*20)+305, height/2 + 240, nVar  ,  nVar ); 
    
    if (time >= 168000){
      var = 0;
    image(bar, (i*20)+305, height/2 - 20, var,  var); 
    image(bar, (i*20)+305, height/2 + 240, var, var); 
    image(bar, (i*20)+305, height/2 - 20, fft.getAvg(i/20) ,  fft.getAvg(i/20) ); 
    image(bar, (i*20)+305, height/2 + 240, fft.getAvg(i/20) ,  fft.getAvg(i/20)); 
    
    if (time >= 168000){
    image(bar, (i*20)+305, height/2 - 20, 2/fft.getAvg(i) -20 ,  2/fft.getAvg(i) -20  ); 
    image(bar, (i*20)+305, height/2 + 240, 2/fft.getAvg(i) -20 , 2/ fft.getAvg(i) -20 ); 
  }
  
   if (time >= 390000){
     var = 0;
   }
    }
 
  }
  // ---------------------------------------------------------------------------------------------
  //call functions to track the position length of thr track that is being played:
  time();
  meta();
}
// ---------------------------------------------------------------------------------------------
void time() {

  //xpos is used to set the starting and ending coordiantes of the first line; it is mapped to the second line 
  //which will serve as graphically representation of time using the player class when active.  
  float xPos = map(player.position(), 0, player.length(), 300, 902); 
  stroke(255);

  //each line needs its own push and pop matrix because each line is doing something that antagonises each other's movements
  pushMatrix();
  translate(width/2, height/2 + 160);
  fill(255);
  line(xPos - 720, 10, xPos -720, 20); //vertical line
  popMatrix();

  pushMatrix();
  translate(width/2, height/2 + 80);
  strokeWeight(7);
  fill(255);
  line(-418, 95, 460, 95); //horizontal line.

  popMatrix();

  pushMatrix();
  translate(width/2, height/2 - 50);
  fill(255);
  line(-418, 15, 460, 15); //horizontal line.
  popMatrix();

  // ---------------------------------------------------------------------------------------------  
  //notes to work out length of the song:

  //using these you can set position of lines to its exact second.

  int seconds = player.length()/1000%60;

  int minutes = player.length()/60000%60;

  //make the calculations made into position varaibles:

  int posSeconds = player.position()/1000%60;

  int posMinutes = player.position()/60000%60;

  //store both position variables and length variables into string and call it HUD
  String HUD = posMinutes + ":" + nf(posSeconds, 2); 
  String HUD2 =  + minutes + ":" + nf(seconds, 2);

  //we HUD string for the text function to display the length of track and the time left.
  text(HUD, width/2-432, height/2 +180, 100, 100);//position
  text(HUD2, width/2+432, height/2 +180, 100, 100);//length
}

// ---------------------------------------------------------------------------------------------
//it was called meta because it was originally meant to get the filename of mp3 and display it.
//I couldn't get it to work because the mp3 had no meta data to display.
void meta() {

  meta = player.getMetaData();

  //scrapped code for getting meta data of file. it was scrapped because my mp3 has no meta data to display.
  //text("Author: " + meta.author(), width/2 - 88, height/2 + 75,100,100); 
  //text("Title: " + meta.title(), width/2 + 10, height/2 + 75,100,100);

  // ---------------------------------------------------------------------------------------------

  // the text is in a for loop, because i wanted the text the get the same averages as rect.
  //this creates a glitch computer effect with a string of 1's and 0's.

  for (int i = 0; i < fft.avgSize(); i++)
  {
    smooth();
  
   
   float var2 = random(7);
   float var3 = random(1);
  
   int alpha = 120;
   tint(255, alpha);
    image( vevo, width/2 + var3 , height/2 + 80 + var3, 950 , 267 ); 
   image( alive, width/2  , height/2 + 80 , 150 + var2, 150 + var2); 
   
   if(time >= 168000){
     image( alive, width/2  , height/2 + 80 , 150 + random(10), 150 + random(10)); 
     image( vevo, width/2 + var3 , height/2 + 80 + var3, 950 + fft.getAvg(i/108) , 267 + fft.getAvg(i/108)); 
   }
  
  
       
    //using the text fucntion to get average size of the frequecny spectrum:
    //this effect give us binary text that envelopes when the average get higher.    
    //calling font setting size for indivdual tags.
    textSize( 8 );
    text("01010101010101010101010101010101010101010101010 ", width/2 + 420, height/2 + 190, -fft.getAvg(i), fft.getAvg(i));
  }
  
}
