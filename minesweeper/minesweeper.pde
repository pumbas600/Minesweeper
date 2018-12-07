Board board;
PFont digital;
int offset = 60;
int frameStart = 0;


//================================================================================================
boolean beginner = false;
boolean intermediate = false;
boolean expert = true;

//================================================================================================
//GAME SETTINGS
//Number of tiles:
int horizontal = 10;
int vertical = 10;

//The size of the tiles (in pixels)
int tileSize = 30;

//The number of bombs. If this number is less then 1, the number will be used as a percentage.
float bombCount = 10;
//================================================================================================

void settings(){
  presets();
  size(horizontal*tileSize, vertical*tileSize+offset);  
}

void setup(){
  frameRate(60);
  board = new Board(horizontal, vertical, bombCount, offset, tileSize, frameStart);
  board.show();
  digital = createFont("digital-7.ttf",offset/2);

}

void draw(){
  background(#7C7C7C);
  stroke(255);
  strokeWeight(2);
  fill(#E3E3E3);
  rect(0,0, width, offset);
  
  stroke(0);
  strokeWeight(1);
  fill(0);
  textFont(digital);
  rect((3*tileSize)/4, offset/4, textWidth("8888"), (offset)/2);
  
  rect(width-(3*tileSize)/4, offset/4, -textWidth("88:88"), (offset)/2);
  
  fill(#270000);
  textAlign(LEFT);
  text("8888", (3*tileSize)/4, offset/2 +offset/5);
  
  textAlign(RIGHT);
  text("88:88", width-(3*tileSize)/4, offset/2 +offset/5); 

  board.update();
  
  
  if(board.reset()){
    
    presets();
    frameStart = frameCount;

    board = new Board(horizontal, vertical, bombCount, offset, tileSize, frameStart);
    board.show();
    
  }
  
  
}
//==================================
void mousePressed(){
  board.mousePressed();
}

void mouseReleased(){
  board.mouseReleased();
}

void presets(){
  if(beginner){
    horizontal = 9;
    vertical = 9;
    bombCount = 10;
  } else if(intermediate){
    horizontal = 16;
    vertical = 16;
    bombCount = 40;
  } else if(expert){
    horizontal = 30;
    vertical = 16;
    bombCount = 99;
  }
}
