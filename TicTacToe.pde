import java.util.Arrays; //<>// //<>//

Cell[][] board;
int cols;
int rows;
int player; //0 = player1
int win;  // 1 = player1   2 = player2;
int full;
int tableSize = 500;
int x = 3;
int strategy = 1; //--0 = random, --1 = Rule Based Strategy, --2 = Heuristic Board Evaluation Function, 3 = Minimax
int[] origBoard = new int[x*x];
boolean IsAI = true;
boolean AIsturn = false;

void settings() {
  //fullScreen();
  size(floor((tableSize / x) * x) + 1, floor((tableSize / x) * x) + 1);
}

void setup() {
  smooth();
  background(0);
  if (x < 3 || x == 3) {
    x = 3;
  }
  //because its not working on other xs but im trying to figure out how to solve it
  if (x > 3) {
    IsAI = false;
  }
  cols = x;
  rows = x;
  full = cols * rows;
  player = 0;
  if (IsAI == false) {
    player = round(random(1.1));
  }
  win = 0;
  AIsturn = false;
  board = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      board[i][j] = new Cell(width/x*i, height/x*j, width/x, height/x);
    }
  }
}

void draw() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      board[i][j].display();
      checkGame();
    }
  }
  if (IsAI == true && player == 1) {
    AIsturn = true;
  }
  if (AIsturn == true && win == 0 && full != 0) {
    if (strategy == 0) {
      RandomStrategy();
    } else if (strategy == 1) {
      RuleBasedStrategy();
    } else if (strategy == 2) {
      HeuristicBoardEvaluationFunction();
    } else if (strategy == 3) {
    }
  }
}

//mouse & key functions
void mousePressed() {
  if (AIsturn == false && win == 0) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j].click(mouseX, mouseY);
      }
    }
  }
  if (((win == 0 && full == 0) || (win == 1 || win == 2 || win == 3)) && mouseButton == RIGHT) {
    setup();
  }
  changeBoardFormat();
}

void checkGame() {
  //check vertical & horizontal
  if (x >= 5) {
    for (int row = 0; row < rows - 4; row++) {
      for (int col = 0; col < cols; col++) {
        checkHorizVertic5(col, row, 1);
        checkHorizVertic5(col, row, 2);
        checkHorizVertic5(col, row, 3);
        checkDiagonals5(col, row, 1);
        checkDiagonals5(col, row, 2);
        checkDiagonals5(col, row, 3);
      }
    }
  } else {
    for (int row = 0; row < rows - 2; row++) {
      for (int col = 0; col < cols; col++) {
        checkHorizVertic3(col, row, 1);
        checkHorizVertic3(col, row, 2);
        checkHorizVertic3(col, row, 3);
        checkDiagonals3(col, row, 1);
        checkDiagonals3(col, row, 2);
        checkDiagonals3(col, row, 3);
      }
    }
  }
  endWriteText();
}

void endWriteText() {
  if (win == 1 || win == 2 || win == 3 || ( win == 0 && full == 0)) {
    fill(255);
    textSize(floor((height * width) / (height * 12)));
    if (win == 1) {
      text("Circle WINS!", width/2 - width/4, height/2+height/7);
    } else if (win == 2) {
      if (IsAI == true) {
        text("AI WINS!", width/2 - width/8 - width/32, height/2+height/7);
      } else {
        text("X WINS!", width/2 - width/8 - width/32, height/2+height/7);
      }
    } /*else if (win == 3) {
     text("Rectangle WINS!", width/2 - width/4, height/2+height/7);
     }*/
    else if (win == 0) {
      text("Tie!", width/2 - width/16, height/2+height/7);
    }
    fill(0, 255, 0);
    text("Right click to Start Again", width/80, height/2-height/7);
  }
}

///<summary>
///Checking horizontal and vertical for 3
///</summary>
void checkHorizVertic3(int col, int row, int whoWins) {
  if (board[col][row].checkState() == whoWins && board[col][row+1].checkState() == whoWins && board[col][row+2].checkState() == whoWins) {
    //println("vertical win!");
    win = whoWins;
  } else if (board[row][col].checkState() == whoWins && board[row+1][col].checkState() == whoWins && board[row+2][col].checkState() == whoWins) {
    //println("Horizontal win!");
    win = whoWins;
  }
}

///<summary>
///Checking diagonals for 3
///</summary>
void checkDiagonals3(int col, int row, int whoWins) {
  if (col < cols - 2) {
    if (board[row][col].checkState() == whoWins && board[row+1][col+1].checkState() == whoWins && board[row+2][col+2].checkState() == whoWins) {
      //print(" diagonal 0 win! ");
      win = whoWins;
    } else if (board[row][col+2].checkState() == whoWins && board[row+1][col+1].checkState() == whoWins && board[row+2][col].checkState() == whoWins) {
      //println("diagonal 1 win!");
      win = whoWins;
    }
  }
}

///<summary>
///Checking horizontal and vertical for 5
///</summary>
void checkHorizVertic5(int col, int row, int whoWins) {
  if (board[col][row].checkState() == whoWins && board[col][row+1].checkState() == whoWins && board[col][row+2].checkState() == whoWins && board[col][row+3].checkState() == whoWins && board[col][row+4].checkState() == whoWins) {
    //println("vertical win!");
    win = whoWins;
  } else if (board[row][col].checkState() == whoWins && board[row+1][col].checkState() == whoWins && board[row+2][col].checkState() == whoWins && board[row+3][col].checkState() == whoWins && board[row+4][col].checkState() == whoWins) {
    //println("Horizontal win!");
    win = whoWins;
  }
}

///<summary>
///Checking diagonals for 5
///</summary>
void checkDiagonals5(int col, int row, int whoWins) {
  if (col < cols - 4) {
    if (board[row][col].checkState() == whoWins && board[row+1][col+1].checkState() == whoWins && board[row+2][col+2].checkState() == whoWins && board[row+3][col+3].checkState() == whoWins && board[row+4][col+4].checkState() == whoWins) {
      //print(" diagonal 0 win! ");
      win = whoWins;
    } else if (board[row][col+4].checkState() == whoWins && board[row+1][col+3].checkState() == whoWins && board[row+2][col+2].checkState() == whoWins && board[row+3][col+1].checkState() == whoWins && board[row+4][col].checkState() == whoWins ) {
      //println("diagonal 1 win!");
      win = whoWins;
    }
  }
}

void changeBoardFormat() {
  int x = 0;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      origBoard[x] = board[j][i].checkState();
      x++;
    }
  }
}

void RandomStrategy() {
  int choice;
  IntList tempor = new IntList();
  for (int i = 0; i < origBoard.length; i++) {
    if (origBoard[i] == 0) {
      tempor.append(i);
    }
  }
  choice = tempor.get(round(random(tempor.size() - 1)));
  AIPlace(choice);
}

void HeuristicBoardEvaluationFunction() {
  int choice;
  int[] newBoard = new int[origBoard.length];
  IntList temp = new IntList();
  for (int i = 0; i < origBoard.length; i++) {
    if (origBoard[i] == 0) {
      temp.append(i);
    }
  }
  int[] results = new int[temp.size()];
  for (int j = 0; j < temp.size(); j++) {
    newBoard = origBoard.clone();
    newBoard[temp.get(j)] = 2;
    results[j] = evaluateBoard(newBoard);
  }
  //println(Arrays.toString(results), findIndex(results, Arrays.stream(results).max().getAsInt()), temp.get(findIndex(results, Arrays.stream(results).max().getAsInt())));
  choice = temp.get(findIndex(results, Arrays.stream(results).max().getAsInt()));
  AIPlace(choice);
}

void RuleBasedStrategy() {
  int choice;
  IntList tempor = new IntList();
  for (int i = 0; i < origBoard.length; i++) {
    if (origBoard[i] == 0) {
      tempor.append(i);
    }
  }
  if (full == x*x-1 && origBoard[floor(origBoard.length / 2)] == 0) {
    choice = floor(origBoard.length / 2);
  } else if (checkVertHorDiag3(2, 1) != -1) {
    choice = checkVertHorDiag3(2, 1);
  } else if (checkVertHorDiag3(1, 2) != -1) {
    choice = checkVertHorDiag3(1, 2);
  } else if (checkFork(2) != -1) {
    choice = checkFork(2);
  } else if (checkFork(1) != -1) {
    choice = checkFork(1);
  } else {
    choice = tempor.get(round(random(tempor.size() - 1)));
  }
  AIPlace(choice);
}

void AIPlace(int choice) {
  int row = ceil(choice / cols);
  int col = choice - (ceil(choice / cols) * x);
  board[col][row].click(col * floor(width / x) + floor(width / x * 0.5), row * floor(height / x) + floor(height / x * 0.5));
  AIsturn = false;
}

int evaluateBoard(int[] boardToSum) {
  int score = 0;
  // Evaluate score for each of the 8 lines (3 rows, 3 columns, 2 diagonals)
  score += evaluateLine(0, 1, 2, boardToSum);  // row 0
  score += evaluateLine(3, 4, 5, boardToSum);  // row 1
  score += evaluateLine(6, 7, 8, boardToSum); // row 2
  score += evaluateLine(0, 3, 6, boardToSum);  // col 0
  score += evaluateLine(1, 4, 7, boardToSum);  // col 1
  score += evaluateLine(2, 5, 8, boardToSum); // col 2
  score += evaluateLine(0, 4, 8, boardToSum); // diagonal
  score += evaluateLine(2, 4, 6, boardToSum); // alternate diagonal
  return score;
}
 //<>//
int evaluateLine(int cell1, int cell2, int cell3, int[] arrboard) {
  int score = 0;
  // First cell
  if (arrboard[cell1] == 2) {
    score = 1;
  } else if (arrboard[cell1] == 1) {
    score = -1;
  }

  // Second cell
  if (arrboard[cell2] == 2) {
    if (score == 1) {   // cell1 is 2
      score = 10;
    } else if (score == -1) {  // cell1 is 1
      return 0;
    } else {  // cell1 is empty
      score = 1;
    }
  } else if (arrboard[cell2] == 1) {
    if (score == -1) { // cell1 is 1
      score = -10;
    } else if (score == 1) { // cell1 is 2
      return 0;
    } else {  // cell1 is empty
      score = -1;
    }
  }

  // Third cell
  if (arrboard[cell3] == 2) {
    if (score > 0) {  // cell1 and/or cell2 is 2
      score *= 10;
    } else if (score < 0) {  // cell1 and/or cell2 is 1
      return 0;
    } else {  // cell1 and cell2 are empty
      score = 1;
    }
  } else if (arrboard[cell3] == 1) {
    if (score < 0) {  // cell1 and/or cell2 is 1
      score *= 10;
    } else if (score > 1) {  // cell1 and/or cell2 is 2
      return 0;
    } else {  // cell1 and cell2 are empty
      score = -1;
    }
  }
  return score;
}

int checkAlone() {
  //check if random comes, first place to an empty col or only with one x
  return -1;
}

//thats not all forks now
int checkFork(int orig) {
  if (origBoard[0] == orig && origBoard[x-1] == orig && origBoard[x*x-1] != orig) {
    return x*x-1;
  } else if (origBoard[0] == orig && origBoard[x-1] != orig && origBoard[x*x-1] == orig) {
    return x-1;
  } else if (origBoard[0] != orig && origBoard[x-1] == orig && origBoard[x*x-1] == orig) {
    return 0;
  }
  if (origBoard[(x-1)*x] == orig && origBoard[0] == orig && origBoard[x-1] != orig) {
    return x-1;
  } else if (origBoard[(x-1)*x] == orig && origBoard[0] != orig && origBoard[x*x-1] == orig) {
    return 0;
  } else if (origBoard[(x-1)*x] != orig && origBoard[0] == orig && origBoard[x*x-1] == orig) {
    return (x-1)*x;
  }
  if (origBoard[x*x-1] == orig && origBoard[(x-1)*x] == orig && origBoard[0] != orig) {
    return 0;
  } else if (origBoard[x*x-1] == orig && origBoard[(x-1)*x] != orig && origBoard[0] == orig) {
    return (x-1)*x;
  } else if (origBoard[x*x-1] != orig && origBoard[(x-1)*x] == orig && origBoard[0] == orig) {
    return x*x-1;
  }
  if (origBoard[x-1] == orig && origBoard[x*x-1] == orig && origBoard[(x-1)*x] != orig) {
    return (x-1)*x;
  } else if (origBoard[x-1] == orig && origBoard[x*x-1] != orig && origBoard[(x-1)*x] == orig) {
    return x*x-1;
  } else if (origBoard[x-1] != orig && origBoard[x*x-1] == orig && origBoard[(x-1)*x] == orig) {
    return x-1;
  }
  return -1;
}

int checkVertHorDiag3(int orig, int other) {
  for (int i = 0; i < origBoard.length / x; i++) {
    if (origBoard[i] == orig && origBoard[i + x] == orig && origBoard[i + 2*x] != other) {
      return i + x*2;
    } else if (origBoard[i] == orig && origBoard[i + x] != other && origBoard[i + 2*x] == orig) {
      return i + x;
    } else if (origBoard[i] != other && origBoard[i + x] == orig && origBoard[i + 2*x] == orig) {
      return i;
    }
  }
  for (int i = 0; i < origBoard.length; i += x) {
    if (origBoard[i] == orig && origBoard[i + 1] == orig && origBoard[i + 2] != other) {
      return i + 2;
    } else if (origBoard[i] == orig && origBoard[i + 1] != other && origBoard[i + 2] == orig) {
      return i + 1;
    } else if (origBoard[i] != other && origBoard[i + 1] == orig && origBoard[i + 2] == orig) {
      return i;
    }
  }
  for (int i = 0; i < origBoard.length / x - 2; i++) {
    if (origBoard[i] == orig && origBoard[i+x+1] == orig && origBoard[i+2*x+2] != other) {
      return i+2*x+2;
    } else if (origBoard[i] == orig && origBoard[i+x+1] != other && origBoard[i+2*x+2] == orig) {
      return i+x+1;
    } else if (origBoard[i] != other && origBoard[i+x+1] == orig && origBoard[i+2*x+2] == orig) {
      return i;
    }
  }
  for (int i = 0; i < origBoard.length / x - 2; i++) {
    if (origBoard[i+x-1] == orig && origBoard[i+2*x-(x-1)] == orig && origBoard[i+2*x] != other) {
      return i+2*x;
    } else if (origBoard[i+x-1] == orig && origBoard[i+2*x-(x-1)] != other && origBoard[i+2*x] == orig) {
      return i+2*x-(x-1);
    } else if (origBoard[i+x-1] != other && origBoard[i+2*x-(x-1)] == orig && origBoard[i+2*x] == orig) {
      return i+x-1;
    }
  }
  return -1;
}

// Linear-search function to find the index of an element 
public static int findIndex(int arr[], int t) 
{ 

  // if array is Null 
  if (arr == null) { 
    return -1;
  } 

  // find length of array 
  int len = arr.length; 
  int i = 0; 

  // traverse in the array 
  while (i < len) { 

    // if the i-th element is t 
    // then return the index 
    if (arr[i] == t) { 
      return i;
    } else { 
      i = i + 1;
    }
  } 
  return -1;
}

//CELL CLASS

class Cell {
  int x;
  int y ;
  int w;
  int h;
  int state = 0;

  Cell(int tx, int ty, int tw, int th) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
  }  

  void click(int tx, int ty) {
    int mx = tx;
    int my = ty;
    if (mx > x && mx < x+w && my > y && my < y+h) {

      if (player == 0 && state == 0) {
        state = 1;
        full -= 1;
        player = 1;
      } else if (player == 1 && state == 0) {
        state = 2;
        full -= 1;
        player = 0;
      } /*else if (player == 2 && state == 0) {
       state = 3;
       full -= 1;
       player = 0;
       }*/
    }
  }

  int checkState() {
    return state;
  }

  int checkX() {
    return x;
  }

  int checkY() {
    return y;
  }

  int checkW() {
    return w;
  }

  int checkH() {
    return h;
  }

  public void checkingLine(Cell a, Cell b) {
    line(a.checkX() + 0.5 * a.checkW(), a.checkY() + 0.5 * a.checkH(), b.checkX() + 0.5 * b.checkW(), b.checkY() + 0.5 * b.checkH());
  }

  void display() {
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(x, y, w, h);
    if (state == 1) {
      ellipseMode(CORNER);
      stroke(0, 0, 255);
      ellipse(x + w * 0.25, y + h * 0.25, w * 0.5, h * 0.5);
    } else if (state == 2) {
      stroke(255, 0, 0);
      line(x + w * 0.25, y + h * 0.25, x + w * 0.75, y + h * 0.75); 
      line(x + w * 0.75, y + h * 0.25, x + w * 0.25, y + h * 0.75);
    } /*else if (state == 3) {
     stroke(0, 255, 0);
     rect(x + w * 0.25, y + h * 0.25, x + w * 0.75, y + h * 0.75, x + w * 0.75, y + h * 0.25, x + w * 0.25, y + h * 0.75);
     }*/
  }
}
