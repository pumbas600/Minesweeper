class Button{
  
  public boolean idling = true;
  public boolean clicked = false;
  public boolean lost = false;
  public boolean won = false;
  public boolean gameOver = false;
  
  PImage smiley;
  PImage sunglasses;
  PImage dead;
  PImage openMouth;
  
  float buttonHeight, buttonWidth;
  
  PVector leftCorner;

  boolean output = false;
  
  
  Button(float buttonH, float buttonW, PVector pos){


    buttonHeight = buttonH;
    buttonWidth = buttonW;
    
    leftCorner = pos;
    
    smiley = loadImage("smiley.png"); 
    sunglasses = loadImage("sunglasses.png");
    dead = loadImage("dead.png");
    openMouth = loadImage("openMouth.png");
    

      

  }
  
  //===============================================================
  void show(){
    stroke(255);
    strokeWeight(2);
    fill(#E3E3E3);
    rect(leftCorner.x, leftCorner.y, buttonWidth ,buttonHeight);
    
    if(idling && !gameOver){
      image(smiley, leftCorner.x+5, leftCorner.y+5, buttonWidth-10, buttonHeight-10);
    } else if(clicked && !gameOver){
      image(openMouth, leftCorner.x+5, leftCorner.y+5, buttonWidth-10, buttonHeight-10);
    } else if(lost){
      image(dead, leftCorner.x+5, leftCorner.y+5, buttonWidth-10, buttonHeight-10);
    } else if(won){
      image(sunglasses, leftCorner.x+5, leftCorner.y+5, buttonWidth-10, buttonHeight-10);
    }

  }
  
  //===============================================================
  
  void update(){
    show();
  }
  
  //==============================================================
  void mousePressed(){
    if(mouseButton == LEFT && mouseX > leftCorner.x && mouseY > leftCorner.y && mouseX < leftCorner.x+buttonWidth && mouseY < leftCorner.y+buttonHeight && !output){
      println("true!");
      output = true;
    } else if(mouseButton == LEFT && mouseX > leftCorner.x && mouseY > leftCorner.y && mouseX < leftCorner.x+buttonWidth && mouseY < leftCorner.y+buttonHeight && output){
      println("false");
      output = false;
    }  
    
  }
}
