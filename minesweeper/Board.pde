class Board{
  Button button;
  Tile[] tiles;
  PFont digital;
  
  int horizontal;
  int vertical;
  int tileSize;
  
  int seconds = 0;
  int minutes = 0;
  int minsPassed = 0;
  int frameStart;

  int num = 0;
  boolean bomb;
  boolean gameOver  = false;
  boolean won = false;
  boolean lost = false;
  boolean firstClick = true;
  
  boolean leftClicked = false;
  boolean rightClicked = false;
  
  int remaining;
  int mineCount;
  int flagNum = 0;
  int offset;

  int[] mines;
  
  Board(int hori, int vert, float mineNum, int shift, int size, int frameBegin){
    PVector tempPos = new PVector((width/2)-(4*size)/6, (shift/2)-(4*size)/6);
    button = new Button((4*size)/3, (4*size)/3, tempPos); 
    digital = createFont("digital-7.ttf", shift/2);
    if(mineNum < 1){
      mineCount = round(mineNum*(vert*hori));
    } else {
      mineCount = round(mineNum);
    }
    offset = shift;
    horizontal = hori;
    vertical = vert;
    tileSize = size;
    frameStart = frameBegin;
    
    remaining = horizontal*vertical;
    
    tiles = new Tile[horizontal*vertical];
    mines = new int[mineCount*2];
    for(int i = 0; i<mines.length; i++){
      mines[i] = -1;  
    }
    for(int i = 0; i<mineCount; i++){
      randomMines();
    }
    
    for(int i = 0; i< vertical; i++){
      for(int j = 0; j< horizontal; j++){
        bomb = false;
        for(int k = 0; k< mines.length; k+=2){
          if(j*tileSize == mines[k] && i*tileSize+offset == mines[k+1]){
            bomb = true;
          } 
        }
        tiles[num] = new Tile(j*tileSize,i*tileSize+offset, bomb, tileSize);
        num++;
        
        
      }
    }
    value();

  }
  
  //======================================================
  void show(){
    for (int i = 0; i< tiles.length; i++){
      tiles[i].show();
      
    }
    textFont(digital);

    fill(255, 0, 0);
    textAlign(RIGHT);
    String temp = Integer.toString(mineCount-flagNum);
    String[] split = zeros(temp, 4);
    
    for(int i = 0; i<split.length; i++){
      text(split[i], (3*tileSize)/4 + textWidth("8888")-(textWidth("8")*(split.length-1-i)), offset/2 +offset/5);
    }
    temp = Integer.toString(seconds);
    split = zeros(temp, 2);
    for(int i = 0; i<split.length; i++){
      text(split[i], width-(3*tileSize)/4 -(textWidth("8")*(split.length-1-i)), offset/2 +offset/5);
    }
    text(":", width-(3*tileSize)/4 -(textWidth("88")), offset/2 +offset/5);
    
    temp = Integer.toString(minutes);
    split = zeros(temp, 2);
    for(int i = 0; i<split.length; i++){
      text(split[i], width-(3*tileSize)/4 -(textWidth(":88"))-(textWidth("8")*(split.length-1-i)), offset/2 +offset/5);
    }
    for(int i = 0; i< tiles.length; i++){
      if(mouseX > tiles[i].pos.x && mouseX < tiles[i].pos.x+tileSize && mouseY > tiles[i].pos.y && mouseY < tiles[i].pos.y+tileSize && !tiles[i].flagged && !gameOver && !tiles[i].visible){
        tiles[i].hovered = true;
      } else {
        tiles[i].hovered = false;
      }
    }
    
    
    
  }
  
  //======================================================
  void update(){
    
    show();
    remaining = 0;
    for(int i = 0; i< tiles.length; i++){
      if(tiles[i].visible == false){
        remaining++;
      }
    }
    button.update();
    
    if(!gameOver){
      seconds = (((frameCount-frameStart)/60) - minsPassed);
      if(seconds == 60){
        minsPassed += 60;
      }
      minutes = (frameCount-frameStart)/3600;
    }
    
    if(remaining == mineCount && !gameOver){
      won = true;
      button.won = true;
      println("CONGRATS ON WINNING!");
      gameOver = true;
    }
    if(gameOver){
      gameOver();
    }
  }
  
  //=======================================================
  void randomMines(){
    int x = round(random(horizontal-1))*tileSize;
    int y = round(random(vertical-1))*tileSize+offset;

    //println(x/tileSize +1, y/tileSize +1);
    for(int i = 0; i< mines.length; i +=2){
      if(x != mines[i] || y != mines[i+1]){
        if(mines[i] == -1 && mines[i+1] == -1){

          mines[i] = x;
          mines[i+1] = y;
          return;
        }
      } else {
        randomMines();
        return;
      }
    } 
  }
  
  //=====================================================
  void value(){
    int[] checking;
    for(int i = 0; i< tiles.length; i++){
      if(tiles[i].bomb){
        checking = checking(i);
        for(int j = 0; j< checking.length; j++){
          if(checking[j] >=0 && checking[j] < tiles.length){
            tiles[checking[j]].value++;  
          }
        } 
      }
    }
  }
  
  //======================================================
  void gameOver(){
    button.gameOver = true;
    button.idling = false;
    button.clicked = false;
    gameOver = true;

    for(int i = 0; i<tiles.length; i++){
      if(!tiles[i].flagged){
        tiles[i].visible = true; 
      } 
      if(tiles[i].flagged && !tiles[i].bomb){
        stroke(0);
        strokeWeight(1.8);
        line(tiles[i].pos.x+tileSize/5, tiles[i].pos.y+tileSize/5, tiles[i].pos.x+(4*tileSize)/5, tiles[i].pos.y+(4*tileSize)/5);
        line(tiles[i].pos.x+tileSize/5, tiles[i].pos.y+(4*tileSize)/5, tiles[i].pos.x+(4*tileSize)/5, tiles[i].pos.y+tileSize/5);
      }
      
    }
  }
  //=======================================================
  void visible(int place){
    int[] checking = checking(place);

    for(int i = 0; i< checking.length; i++){
      if(checking[i] >=0 && checking[i] < tiles.length && !tiles[checking[i]].visible && !tiles[checking[i]].bomb && !tiles[checking[i]].flagged){
        tiles[checking[i]].visible = true; 
        if(tiles[checking[i]].value == 0){
          visible(checking[i]);
        }
      }
    }
    
  }
  //======================================================
  void mousePressed(){
    
    if(mouseButton == RIGHT){
      rightClicked = true;
      leftClicked = false;
      
    } else if(mouseButton == LEFT && mouseY > offset){
      leftClicked = true;
      rightClicked = false;
      button.idling = false;
      button.clicked = true;
    }
    button.mousePressed();
    
  }
  
  //===============================================================================
  void mouseReleased(){
    for(int i = 0; i< tiles.length; i++){
      if(leftClicked && mouseX > tiles[i].pos.x && mouseX < tiles[i].pos.x+tileSize && mouseY > tiles[i].pos.y && mouseY < tiles[i].pos.y+tileSize && !tiles[i].flagged && !gameOver){
        tiles[i].visible = true;
        if(firstClick){
          int[] checking = checking(i);
          if(tiles[i].bomb){
            for(int j = 0; j<tiles.length; j++){
              if(!tiles[j].bomb){
                boolean viable = true;
                for(int z = 0; z< checking.length; z++){
                  if(j == checking[z] || j == i){
                    viable = false;
                  }
                }
                if(viable){
                  tiles[i].bomb = false;
                  tiles[j].chosen();
                  println("SAVED MY DUDE!");
                  for(int k = 0; k<tiles.length;k++){
                    tiles[k].value = 0;
                  }
                  value();
                  break;
                }
              }
            }
          } if((tiles[i].value != 0 || tiles[i].bomb )&& (horizontal*vertical - mineCount > 8)){
            for(int j = 0; j<checking.length; j++){
              if(checking[j] >= 0 && checking[j] < tiles.length && tiles[checking[j]].bomb){
                for(int k = 0; k<tiles.length; k++){
                  if(!tiles[k].bomb){
                    boolean viable = true;
                    for(int z = 0; z< checking.length; z++){
                      if(k == checking[z] || k == i){
                        viable = false;
                      }
                    }
                    if(viable){
                      println("moved ya cheeky bastard!");
                      tiles[checking[j]].bomb = false;
                      tiles[checking[j]].visible = true;
                      tiles[k].chosen();
                      break;
                    }
                  }
                }
              } else if(checking[j] >= 0 && checking[j] < tiles.length){
                tiles[checking[j]].visible = true;  
              }
            }
            for(int k = 0; k<tiles.length;k++){
              tiles[k].value = 0;
            }
            value();
            for(int k = 0; k<checking.length; k++){
              if(checking[k] >= 0 && checking[k] < tiles.length && tiles[checking[k]].value == 0){
                visible(checking[k]);
              }
            }
            firstClick = false;
            leftClicked = false;
            return;
          }
          else if(tiles[i].value == 0){
            visible(i);
          }
        } else if(tiles[i].bomb){
          tiles[i].dead = true;
          lost = true;
          button.lost = true;
          gameOver();
        }else if(tiles[i].value == 0){
          visible(i);
          
        }
        firstClick = false;
        
      } else if(rightClicked && mouseX > tiles[i].pos.x && mouseX < tiles[i].pos.x+tileSize && mouseY > tiles[i].pos.y && mouseY < tiles[i].pos.y+tileSize && !gameOver){
        if(tiles[i].flagged){
          tiles[i].flagged = false;  
          flagNum--;
        } else if(!tiles[i].flagged && flagNum != mineCount && !tiles[i].visible){
          flagNum++;
          tiles[i].flagged = true;
        }
        rightClicked = false;
        
      }
    }
    button.clicked = false;
    button.idling = true;
  }
  //===============================================================================
  String[] zeros(String temp, int len){
    String[] split = temp.split("");
    if(split.length < len){
      temp = "0" + temp;
      split = temp.split("");
      if(split.length < len){
        split = zeros(temp, len);
      } 
    }
    return split;
  }
  //===============================================================================
  int[] checking(int pos){
    int[] checking; 
    if(pos % horizontal == horizontal-1){
      int[] temp = {pos-1, pos-horizontal, pos-horizontal-1, pos+horizontal-1, pos+horizontal};
      checking = temp;
    } else if(pos % horizontal == 0){
      int[] temp = {pos-horizontal, pos-horizontal+1, pos+1, pos+horizontal, pos+horizontal+1};  
      checking = temp;
    } else{
      int[] temp = {pos-1, pos-horizontal+1, pos-horizontal, pos-horizontal-1, pos+1, pos+horizontal-1, pos+horizontal, pos+horizontal+1};  
      checking = temp;
    }  
    return checking;
  }
  //===============================================================================
  boolean reset(){
    if(button.output){
      println("test");
      return true;
    } else {
      return false;
    }
  }
}
