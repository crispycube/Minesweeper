import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean firstClick = true;

void setup ()
{
  size(500, 500);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }
}
public void setMines(int a, int b)
{
  //your code
  
  ArrayList<MSButton> safeButtons = new ArrayList<MSButton>();
  for(int i = -2; i <= 2; i++){
    for(int j = -2; j <= 2; j++){
      if(isValid(a+i, b+j)){
        safeButtons.add(buttons[a+i][b+j]);
      }
    }
  }
  
  while(mines.size() < 60){
    int r, c;
    r = (int)(Math.random()*NUM_ROWS);
    c = (int)(Math.random()*NUM_COLS);
    if(!safeButtons.contains(buttons[r][c]) && !mines.contains(buttons[r][c])){
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
  
}
public boolean isWon()
{
  boolean won = true;
  for(int i = 0; i < mines.size(); i++){
      if(!mines.get(i).isFlagged()){
        won = false;
    }
  }
  for(int i = 0; i < buttons.length; i++){
    for(int j = 0; j < buttons[i].length; j++){
      if(!buttons[i][j].getClickStatus()){
        won = false;
      }
    }
  }
  return won;
}
public void displayLosingMessage()
{
  System.out.println("You Lose");
}
public void displayWinningMessage()
{
  System.out.println("You Win");
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (isValid(row+i, col+j) && mines.contains(buttons[row+i][col+j])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}


public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 500/NUM_COLS;
    height = 500/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    //your code here
    if(firstClick){
      firstClick = false;
      setMines(myRow, myCol);
    }
    
      if (mouseButton == RIGHT) {
        if(!flagged && !clicked){
          flagged = true;
          clicked = true;
        } else if(flagged){
          flagged = false;
          clicked = false;
        }
      } else if (mines.contains(this)) {
        displayLosingMessage();
        for(int i = 0; i < buttons.length; i++){
          for(int j = 0; j < buttons[i].length; j++){
            buttons[i][j].setClick(true);
            buttons[i][j].setFlag(false);
          }
        }
      } else if (countMines(myRow, myCol) > 0 && !getClickStatus()) {
        myLabel = Integer.toString(countMines(myRow, myCol));
        clicked = true;
      } else {
        clicked = true;
        for(int i = -1; i <= 1; i++){
          for(int j = -1; j <= 1; j++){
            if(isValid(myRow+i, myCol+j) && !buttons[myRow+i][myCol+j].getClickStatus()){
              buttons[myRow+i][myCol+j].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 200, 255, 200 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean getClickStatus(){
    return clicked;
  }
  public void setFlag(boolean a){
    flagged = a;
  }
  public void setClick(boolean a){
    clicked = a;
  }
}
