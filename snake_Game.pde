float gap_x, gap_y;
Node[][] grid;
int lastClickCol, lastClickRow;
boolean runSnake;
int dir;
Node head;
Node end;
boolean gameOver;
int startCol;
int startRow;
boolean onCooldown;
int score;
int highScore = 0;


//Settings
color snakeColor = color(0,255,0);
color backgroundColor = color(55);
color foodColor = color(255,0,0);
int numberOfFoods = 1;
boolean showLines = true;
int cols = 20;
int rows = 20;
float frameratePerSecond;//Defined in setup to avoid games after the first one from starting with increased speed
float speedIncreasePercentage = 0.00;


void setup(){
  score = 0;
  frameratePerSecond = 7.0;
  runSnake = false;
  size(800,800);
  background(0);
  dir = 4;
  gap_x = (float) width / cols;
  gap_y = (float) height / rows;
  grid = new Node[cols][rows];
  createGrid();
  set_rand_start_pos();
  for(int i = 0; i < numberOfFoods;i++){placeFood();}
}

void createGrid(){
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      grid[col][row] = new Node(gap_x*col, gap_y*row, col, row);
    }
  }
}

void placeFood(){
  int randCol = randInt(0,cols);
  int randRow = randInt(0,rows);
  while (!(grid[randCol][randRow].isEmpty())){
    randCol = randInt(0,cols);
    randRow = randInt(0,rows);
  }
  grid[randCol][randRow].setFood();
}

void set_rand_start_pos(){
  int tempCol = randInt(0,cols);
  int tempRow = randInt(0,rows);
  startCol = tempCol;
  startRow = tempRow;
  end = grid[tempCol][tempRow];
  head = grid[tempCol][tempRow];
  head.setSnake();
}

boolean isOutOfBounds(int col_neighbor, int row_neighbor) {
  return (col_neighbor < 0 || col_neighbor > cols-1 || row_neighbor < 0 || row_neighbor > rows-1);
}

void updatePos(){
  Node tempHead = head;
  boolean pickedFood = false;
  int col = head.col;
  int row = head.row;
  int nCol = nextCol(col);
  int nRow = nextRow(row);
  if (isOutOfBounds(nCol, nRow)) gameOver = true; 
  else{
  if (dir == 0) tempHead = grid[nCol][nRow];
  else if (dir == 1) tempHead = grid[nCol][nRow];
  else if (dir == 2) tempHead = grid[nCol][nRow];
  else tempHead = grid[nCol][nRow];
  }
  if (tempHead.state == 2) {pickedFood = true; placeFood();}
  else if (tempHead.state == 1) gameOver = true;
  if (!pickedFood && end!=head){
    Node tempend = end;
    end = tempend.front;
    end.setBackground();
  }
  else if (end==head && end.col == startCol && end.row == startRow) grid[startCol][startRow].setBackground();
  if (pickedFood) {
    frameratePerSecond *= 1 + speedIncreasePercentage;
    score += 1;
    if (score > highScore) highScore += 1;
  }
  tempHead.state = 1;
  head.front = tempHead;
  head = tempHead;
}

int nextCol(int col){
  if (dir == 2) return col - 1;
  if (dir == 3) return col + 1;
  return col;
}

int nextRow(int row){
  if (dir == 0) return row - 1;
  if (dir == 1) return row + 1;
  return row;
}


void draw(){
  String stringToDisplay = "Score: " + str(score) + " - Highscore: " + str(highScore);
  onCooldown = false;
  if (runSnake && !gameOver){
    delay((int)(1000.0/frameratePerSecond));
    updatePos();
    if (gameOver){
    runSnake = false;
    }   
  }
    
  if (!showLines)noStroke();
  
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      grid[col][row].display();
    }
  }
  fill(255);
  textSize(20);
  text(stringToDisplay, gap_x, gap_y*rows - gap_y);
}

void keyPressed(){
  runSnake = isValidKeyPress() ? true : runSnake;
  if (!onCooldown){
    if (gameOver && key == ENTER){setup(); onCooldown = false; gameOver = false;}
    if(keyCode == UP && dir != 1) {dir = 0; onCooldown = true;}
    if(keyCode == DOWN && dir != 0) {dir = 1; onCooldown = true;}
    if(keyCode == LEFT && dir != 3) {dir = 2; onCooldown = true;}
    if(keyCode == RIGHT && dir != 2) {dir = 3; onCooldown = true;}
  }
}

boolean isValidKeyPress(){
  return (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT);
}

class Node{
 float x;
 float y;
 int col;
 int row;
 color c;
 int state;
 Node front = null;
 
 Node(float tempX, float tempY, int tempCol, int tempRow){
   x = tempX;
   y = tempY;
   col = tempCol;
   row = tempRow;
   state = 0;
 }
 
 void setFront(Node tempFront){front = tempFront;}
 
 void setFood(){state=2;}
 
 void setBackground(){state = 0;}
 
 void setSnake(){state = 1;}
 
 boolean isEmpty(){return state == 0;}
 
 void display() {
   updateColor(state);
   fill(c);
   rect(x, y, gap_x, gap_y);
  }

 void updateColor(int state){
  if (state == 0){
    c =  backgroundColor;
  }
  else if (state == 1) {
    c = snakeColor;
  }
  else {
    c = foodColor;
  }
  }
}

int randInt(int min, int max){return (int) random(min, max);}
