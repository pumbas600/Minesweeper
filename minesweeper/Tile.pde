class Tile{
  public PVector pos;
  PFont sansSerif;
  PImage mine;
  PImage flag;
  

  
  public boolean visible = false;
  public boolean bomb = false;
  public boolean flagged  = false;
  public boolean dead = false;
  public boolean hovered = false;
  
  public int value = 0;
  public int[] colour = {0, #0300FF, #1DB200, #CB1302, #000348, #811201, #04BCB1, 0, #838282};
  int tileSize;
  
  Tile(int x, int y, boolean tempBomb, int size){

    pos = new PVector(x,y);
    tileSize = size;
    bomb = tempBomb;
    sansSerif = createFont("SansSerif", (3*tileSize)/4);

    if(bomb){
      mine = loadImage("mine.png");  
      
    }
    flag = loadImage("flag.png");
    
  }
  
  //===============================================
  void show(){
    if(!visible){
      if(!hovered){
        stroke(255);
        strokeWeight(2);
      } else {
        stroke(#838282);
        strokeWeight(2);
      }
      fill(#E3E3E3);
      rect(pos.x, pos.y, tileSize, tileSize);

      if(flagged){
        image(flag, pos.x+(tileSize)/7, pos.y+(tileSize)/7, (3*tileSize)/4,(3*tileSize)/4);
      }
    
    }else {
      textFont(sansSerif);
      stroke(#7C7C7C);
      strokeWeight(1.3);
      if(dead){
        fill(255, 0, 0);  
      } else {
        fill(#E3E3E3);  
      }

      rect(pos.x, pos.y, tileSize, tileSize);
      
      if(bomb){
        image(mine, pos.x+(tileSize)/7, pos.y+(tileSize)/7, (3*tileSize)/4,(3*tileSize)/4);
        
      }
      else if(value != 0){
        fill(colour[value]);
        textSize((3*tileSize)/4);
        textAlign(CENTER, CENTER);
        text(value, pos.x+(tileSize)/2, pos.y+(3*tileSize)/8);  
      }
       
    }
    
  }
  //================================================
  void chosen(){
    mine = loadImage("mine.png"); 
    bomb = true;
  }

}
