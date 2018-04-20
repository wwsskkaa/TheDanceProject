import gab.opencv.*;
import de.looksgood.ani.*;

import processing.video.*;

Movie video;
OpenCV opencv;
int h=0;

final int WAIT_TIME = (int) (600*1000);
//(int) (21 * 1000); // 3.5 seconds
int startTime;


int numPixels;
int[] previousFrame;
int threshold = 50;
int state1=1;
int currentclip=0;
CurrentState state;
Ani animation;
float transition=0;
Clip[] clips;
void setup() {
  Ani.init(this);
  state=CurrentState.MAIN;
  colorMode(HSB,255);
  fullScreen(P2D);
  //size(720, 414);
  background(0);
  clips=new Clip[6];
  clips[0]=new Clip("Ballet","bigballet.mov");
  clips[1]=new Clip("Salsa","bigsalsa.mov");
  clips[2]=new Clip("Popping","popping.mov");
  clips[3]=new Clip("Contemporary","contempbig_2.mov");
  clips[4]=new Clip("Breaking","mb.mov");
  clips[5]=new Clip("Quickstep","quickstepdiff.mov");
  currentclip=0;
  video = new Movie(this, clips[currentclip].getFile());
  //println(width);
  //opencv = new OpenCV(this, 1280,720);
  opencv = new OpenCV(this, 1280,774);
  
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  
  //video.loop();
  video.loop();
  //video.volume(0);
  //video.speed(0.5);
  
  
  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();
  
}

/*boolean sketchFullScreen(){
return true;
}*/

void draw() {
  switch(state){
  case MAIN:
    outline();
    break;
  case TRANS:
  other();
    break;
  }
  //outline();
  textSize(26);
  if(currentclip>=6){
    exit();
  }
  else{
  text(clips[currentclip].getDanceName(),0,-20);
  if(state1==4){
  if(millis() - startTime > WAIT_TIME){
    if(state==CurrentState.MAIN){
    state=CurrentState.TRANS;
  }
  else{
    state=CurrentState.MAIN;
  }
  startTime=millis();
  }
  }
  }
  
  
}

void transition(){
  background(0);
  
}

void other(){
    if (video.available()) {
 //image(video, 0, 0);

    video.loadPixels(); // Make its pixels[] array available
    int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = video.pixels[i];
      color prevColor = previousFrame[i];
      int cR = (currColor >> 16) & 0xFF;
      int cG = (currColor >> 8) & 0xFF;
      int cB = currColor & 0xFF;
      int pR = (prevColor >> 16) & 0xFF;
      int pG = (prevColor >> 8) & 0xFF;
      int pB = prevColor & 0xFF;
      int dR = abs(cR - pR);
      int dG = abs(cG - pG);
      int dB = abs(cB - pB);
      movementSum +=(dR + dG + dB);
      pixels[i] = 0xff000000 | (dR << 16) | (dG << 8) | dB;
      previousFrame[i] = currColor;
    }
    if (movementSum > 0) {
      updatePixels();
  
  fill(255, 0, 255);
  strokeWeight(2.0);
  stroke(0);
  translate(abs(width-video.width)/2,abs(height-video.height)/2);


  float t=video.time()/video.duration();
  if(t>0.99){
     if(video==null){
       return;
     }
     video.stop();
     currentclip+=1;
     if(currentclip>=6){
       exit();
       return;
     }
     else{
       //fill(0);
       //rect(0,0,width,height);
       //delay(1000);
       state=CurrentState.MAIN;
      startTime=millis();
       video = new Movie(this, clips[currentclip].getFile());
       state1=1;
       video.loop();
        //video.volume(0);
        //video.speed(0.5);
       //video.speed(0);
       transition=1;
       Ani.to(this,2, "transition",0);
       opencv.loadImage(video);
  
       opencv.updateBackground();
     }
  }
    }
    
  }
}
void outline(){
  tint(255,50);
  //image(video, 0, 0);  
  //background(0);
  
  opencv.loadImage(video);
  
  opencv.updateBackground();
  float t=video.time()/video.duration();
  if(t>0.99){
     if(video==null){
       return;
     }
     video.stop();
     currentclip+=1;
     if(currentclip>=6){
       exit();
       return;
     }
     else{
       //fill(0);
       //rect(0,0,width,height);
       //delay(1000);
       state=CurrentState.MAIN;
      startTime=millis();
       video = new Movie(this, clips[currentclip].getFile());
       state1=1;
       video.loop();
        //video.volume(0);
        //video.speed(0.5);
       //video.speed(0);
       transition=1;
       Ani.to(this,3, "transition",0);
       opencv.loadImage(video);
  
       opencv.updateBackground();
     }
  }
  opencv.dilate();
  opencv.erode();

  noFill();
  //stroke(255,20);
  stroke(h,150,255,20);
    h=h+1;
    if(h>255){
      background(0);
    h=0;}
  //stroke(255, 0, 0,5);
  strokeWeight(0.8);
  translate(abs(width-video.width)/2,abs(height-video.height)/2);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
  if(transition!=0){
    background(0);
  }
  if(state1==1||state1==2){
    image(video, 0,0);
  }
}
void movieEvent(Movie m) {
  m.read();
}

void mouseClicked(){
  if(state==CurrentState.MAIN){
    state=CurrentState.TRANS;
  }
  else{
    state=CurrentState.MAIN;
  }
    startTime=millis();

  
}

void keyPressed(){
  if (key == '1') { state1=1;}
else if (key == '2') { state1=2;video.volume(0);video.speed(0.8);}
  else if (key == '3') { state1=3;background(0);}
else if (key == '4') { state1=4;}

}