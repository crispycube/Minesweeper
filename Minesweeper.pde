import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean firstClick = true;

void setup ()
{
  size(400, 400);
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
  setMines();
}
public void setMines()
{
  //your code
  if (mines.size() >= 16) {
    return;
  }

  int r, c;
  r = (int)(Math.random()*NUM_ROWS);
  c = (int)(Math.random()*NUM_COLS);

  if (mines.contains(buttons[r][c])) {
    setMines();
  }

  mines.add(buttons[r][c]);
  setMines();
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
  
}
public void displayWinningMessage()
{
  
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
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
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
        System.out.println("You Lose!");
        clicked = true;
      } else if (countMines(myRow, myCol) > 0) {
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
}
