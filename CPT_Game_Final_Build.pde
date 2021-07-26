/*
 - Written by: Daniel Cho, Nicholas Li
 - Submitted to: Mrs.Manoil
 - Date: June 14, 2021
 - Course Code: ICS3U1-02
 */

/* Comments are only added to the first part of repetitive structures and functions in the code*/

//--------------------------------------------------------------------- GLOBAL VARIBLES

//Initializes Image Variables
PImage MenuBG;
PImage Scissors;
PImage Bomb;
PImage lessonSelectionMenu;
PImage classroom;
PImage Floor;
PImage Oreo;
PImage Passed;
PImage Failed;
PImage Teacher;
PImage Feedback;
//Pictures of Code for Questions 4 and 5
PImage[] whileLoop = new PImage[2];
PImage[] doWhileLoop = new PImage[2];
PImage[] forLoop = new PImage[2];
PImage[] bonus = new PImage[2];
//Start Menu Animation
PImage[] startMenu = new PImage[135];

//Initializes Boolean Values
boolean startLock = true;              //For locking start button
boolean pass = false;                  //Will be set true if score > 80%
boolean resetGame = false;             //For resetting game
boolean show = false;                  //For showing code pictures
boolean questionDebug = false;         //For debugging
boolean clicked = false;               //PART 1 of 3 - Extension of mouseClicked() function, allows use anywhere in code
//Status of completion
boolean completedWhileLoops = false;
boolean completedDoWhileLoops = false;
boolean completedForLoops = false;
boolean completedBonus = false;
//For showing answers
boolean showingAnswer = true;
boolean displayCorrectAnswer = false;
boolean byPass = false;

//-------------------------------------------------------------------// CHANGES DEBUGGING MODE TO ON
/*-------------------------------------------------------------------*/boolean debuggingMode = false;

//Initializes Int Values
int riseUp = 650;
int finalScore = 0;
int count = 0;
int page; //For switching between pages
int Score = 0; //For keeping score overall
int questionValue = 1;
int switchPage = 0;
//For showing the oreo at the end
int highNumOreo = 400;
int lowNumOreo = 5;
int randNumX = (int)((highNumOreo - lowNumOreo + 1 ) * Math.random() + lowNumOreo);
int randNumY = (int)((highNumOreo - lowNumOreo + 1 ) * Math.random() + lowNumOreo);

//For keeping score per section
int whileLoopScore = 0;
int doWhileLoopScore = 0;
int forLoopScore = 0;
int bonusScore = 0;

// Timer Settings
int time, passedTime, randomNum;
int timeAllowed = 60;
int timeCD, passedTimeCD, timeAllowedCD;

//Initializes Answer Values For Questions
int[] correctAnswerWhileLoops = {1, 3, 1, 2, 1};
int[] correctAnswerdoWhileLoops = {4, 2, 1, 1, 3};
int[] correctAnswerForLoops = {2, 4, 1, 3, 3};
int[] correctAnswerBonus = {4, 2, 1, 2, 3};

//Initializes Name Values For Lessons
String whileButton = "While";
String doWhileButton = "Do While";
String forButton = "For Loops";
String bonusButton = "Bonus Questions";

//Audio Imports and Initialization
import ddf.minim.*; //Import Minim Audio Library
Minim minim;  
AudioPlayer clickSE, correctSE, incorrectSE, finishSE, msm; //Initialize Global Audio Variables
boolean muted = false; //Start with audio unmuted

//--------------------------------------------------------------------- SETUP FUNCTION

void setup() {
  size(600, 600); //Create a 600x600 Canvas
  textAlign(CENTER, CENTER); //Center text by default

  timeAllowedCD = 4;
  passedTimeCD = millis(); //Initialize 

  //Assigns The Classroom Image To The Variable Classroom
  classroom = loadImage("Classroom Asset.png");
  classroom.resize(600, 600);
  lessonSelectionMenu = loadImage("WhiteBrickBG.PNG");
  lessonSelectionMenu.resize(600, 600);

  //Loads The Start Menu Gifs
  gifLoader();
  smooth();
  //Loads all the other images
  whileLoop[0] = loadImage("While Loops 1.PNG");
  whileLoop[1] = loadImage("While Loops 2.PNG");
  doWhileLoop[0] = loadImage("Do While Loops 1.PNG");
  doWhileLoop[1] = loadImage("Do While Loops 2.PNG");
  forLoop[0] = loadImage("For Loops 1.PNG");
  forLoop[1] = loadImage("For Loops 2.PNG");
  bonus[0] = loadImage("Bonus 1.PNG");
  bonus[1] = loadImage("Bonus 2.PNG");
  Passed = loadImage("Diploma.png");
  Failed = loadImage("Certificate.png");
  Floor = loadImage("Floor.jpg");
  Teacher = loadImage("Teacher.png");
  Feedback = loadImage("SpeechBubble.png");
  Oreo = loadImage("Oreo.png");
  Scissors = loadImage("Scissors.png");
  Bomb = loadImage("Bomb.jpg");
  MenuBG = loadImage("Menu.png");

  //Resizing
  Passed.resize(600, 471);
  Failed.resize(600, 471);

  //Audio setup
  minim = new Minim(this);
  clickSE = minim.loadFile("Click.wav");
  correctSE = minim.loadFile("Correct.mp3");
  incorrectSE = minim.loadFile("Incorrect.mp3");
  finishSE = minim.loadFile("FinishLevel.mp3");
  msm = minim.loadFile("Monkeys-Spinning-Monkeys.mp3");
  /*  Attribution for Creative Commons Licence (Background Music):
   *
   *  Monkeys Spinning Monkeys Kevin MacLeod (incompetech.com)
   *  Licensed under Creative Commons: By Attribution 3.0 License
   *  http://creativecommons.org/licenses/by/3.0/
   *  Music promoted by https://www.chosic.com/
   */

  // Set up looping for msm
  msm.loop();
  msm.pause(); //Start muted by default
  // Set starting values
  msm.setGain(msm.getGain() - 10);
  clickSE.setGain(clickSE.getGain() - 10);
  correctSE.setGain(correctSE.getGain() - 15);
  incorrectSE.setGain(incorrectSE.getGain() - 15);
  finishSE.setGain(finishSE.getGain() - 15);


  //--------------------------------------------------------------------- CHANGE PAGE TO START GAME FOR DEBUGGING
  /*-------------------------------------------------------------------*/  int startingPage = 0;
  page = startingPage;
}
//--------------------------------------------------------------------- DRAW FUNCTION

void draw() {
  frameRate(45);
  if (page == -2) exit(); //Closes The Game
  if (page == -4) howToPlay2(); //Instructions Page 2
  if (page == -1) howToPlay(); //Instructions Page
  if (page == 0) {
    Score = 0;
    mainMenu(); //Main Menu
  }
  if (page == -3) lessonSelectionMenu(); //Lesson Selection Menu
  if (page == 1) whileLoopLesson(Score); //While Loop Lesson
  if (page == 2) doWhileLoopLesson(Score); //Do While Loop Lesson
  if (page == 3) forLoopLesson(Score); //For Loop Lesson
  if (page == 4) bonus(Score); //Bonus Question

  //Feedback
  if (page == 10) feedbackWhileLoops(Score);
  if (page == 11) feedbackDoWhileLoops(Score);
  if (page == 12) feedbackForLoops(Score);
  if (page == 13) feedbackBonus(Score);

  boolean allPassed = false; //Status of completion for the entire game

  //For calling end-game functions
  if (allPassed) {
    finalScore = 20;
    completedWhileLoops = true;
    completedDoWhileLoops = true;
    completedForLoops = true;
    completedBonus = true;
  }

  if (completedWhileLoops == true && completedDoWhileLoops == true && completedForLoops == true && completedBonus == true) {
    if (finalScore >= 16) { //Pass if score >= 80%
      pass = true;
      clear();
      endGamePassed();
    } else { //Else fail
      pass = false;
      clear();
      endGameFailed();
    }
  }
}

//--------------------------------------------------------------------- INSTRUCTIONS MENU

void howToPlay() {
  //Background
  background(255);
  image(MenuBG, 0, 0);
  fill(255);

  //Page Content
  textSize(30);
  text("Introduction:", 300, 65);
  textSize(18);
  textAlign(LEFT, CENTER);
  text("You are a grade 11 student in the highschool Coding High.", 50, 100);
  text("It is nearly the end of the semester, and\nthere is one last test on looping you need to take.", 50, 145);
  text("In order to gain admission to the university of your choice\n(and your parents respect) you must pass this class \nwith an overall average of at least 80%.", 50, 215);
  text("You will also get an oreo for scoring 90% or higher!", 50, 270);
  text("It’s time for your final test, Good Luck!", 50, 300);
  
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Feedback on Answer:", 300, 330);
  textSize(18);
  textAlign(LEFT, CENTER);
  text("The correct answer will be coloured green\nThe incorrect answers will remain the default colour", 50, 375);
  textAlign(CENTER, CENTER);

  fill(0);

  //Next and Back buttons
  button("Back", 30, 20, 520, 140, 60, 0);
  button("Next", 30, 440, 520, 140, 60, -4);

  startLock = false; //Unlock start button

  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

void howToPlay2() {
  //Background
  background(255);
  image(MenuBG, 0, 0);
  fill(255);

  //Page Content
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Keybinds:", 300, 65);
  textSize(18);
  textAlign(LEFT, TOP);
  text("\"P\" = Toggle play/pause of background music\n" + 
    "\"M\" = Toggle mute of all game sounds\n" + 
    "\"Up\" arrow key = Volume Up\n" + 
    "\"Down\" arrow key = Volume Down\n" +
    "\n**Music is paused by default\n" + 
    "**Game sounds are on by default\n" 
    , 50, 100);
  textAlign(CENTER, CENTER);

  textSize(30);
  text("Rules And Tips:", 300, 330);
  textSize(18);
  textAlign(LEFT, CENTER);
  text("Please be sure of your answer before selecting it\nas the answer will be immediately processed by the game.", 50, 375);
  text("Try to answer all the questions to the best of your ability.", 50, 415);
  text("Pay attention to the questions and feedback\n(it may come in useful!)", 50, 455);
  text("No cheating!", 50, 495);
  textAlign(CENTER, CENTER);


  fill(0);

  //Back button
  button("Back", 30, 20, 520, 140, 60, -1);

  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

//--------------------------------------------------------------------- MAIN MENU

void mainMenu() {
  textAlign(CENTER, CENTER); //Center text by default
  background(255);
  textSize(70);

  //Run start menu background animation
  if (count == 134) count = 0;
  image(startMenu[count+=1], 0, 0);

  //Determine state of start button
  if (startLock == false) { //Start button is unlocked
    button("Start", 40, 150, 250, 300, 80, -3);
    textSize(15);
    fill(200, 200, 0);
    arc(175, 290, 17.5, 20, -PI, 0, OPEN); // Lock shackle
    fill(200);
    arc(175, 290, 10, 12.5, -PI, 0, OPEN); // Make it "see-through"
    fill(200, 200, 0);
    rect(177, 290, 20, 15); // Lock body
  } else if (startLock == true) { //Start button is locked
    button("Read Instructions First!", 15, 150, 250, 300, 80, 0); //Dud button (leads to current page and does nothing)
    textSize(15);
    fill(200, 200, 0);
    arc(183, 290, 17.5, 20, -PI, 0, OPEN);
    fill(200);
    arc(183, 290, 10, 12.5, -PI, 0, OPEN);
    fill(200, 200, 0);
    rect(173, 290, 20, 15);
  }

  //Other menu buttons
  button("Instructions", 40, 150, 350, 300, 80, -1); //Goes to level selection
  button("Quit", 40, 150, 450, 300, 80, -2); //Closes game
  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

//--------------------------------------------------------------------- LESSON SELECTION MENU

void lessonSelectionMenu() {
  //Update booleans
  showingAnswer = true;
  displayCorrectAnswer = false;

  //Level selection background
  textAlign(CENTER, CENTER); //Center text by default
  background(255);
  image(MenuBG, 0, 0);
  fill(255);
  textSize(70);
  text("Pass The Class", 300, 60);

  button("Go Back", 30, 175, 540, 250, 40, 0); //Goes to home page

  //Only allow level to be played once
  if (completedWhileLoops == false) {
    button(whileButton, 40, 100, 175, 400, 80, 1);
  }
  if (completedDoWhileLoops == false) {
    button(doWhileButton, 40, 100, 265, 400, 80, 2);
  }
  if (completedForLoops == false) {
    button(forButton, 40, 100, 355, 400, 80, 3);
  }
  if (completedBonus == false) {
    button(bonusButton, 40, 100, 445, 400, 80, 4);
  }
  //Remove play button and print "Completed" along with score
  if (completedWhileLoops) {
    //While Loops Button Completed
    fill(100);
    rect(100, 175, 400, 80);
    //Colours and sizes the text for button
    fill(0);
    textSize(40);
    text("Completed: "+whileLoopScore+"/5", 300, 215); //Centers the text
  }
  if (completedDoWhileLoops) {
    //While Loops Button Completed
    fill(100);
    rect(100, 265, 400, 80);
    //Colours and sizes the text for button
    fill(0);
    textSize(40);
    text("Completed: "+doWhileLoopScore+"/5", 300, 305); //Centers the text
  }
  if (completedForLoops) {
    //While Loops Button Completed
    fill(100);
    rect(100, 355, 400, 80);
    //Colours and sizes the text for button
    fill(0);
    textSize(40);
    text("Completed: "+forLoopScore+"/5", 300, 395); //Centers the text
  }
  if (completedBonus) {
    //While Loops Button Completed
    fill(100);
    rect(100, 445, 400, 80);
    //Colours and sizes the text for button
    fill(0);
    textSize(40);
    text("Completed: " +bonusScore+ "/5", 300, 485); //Centers the text
  }
  fill(255);
  text("Current Score: " +finalScore+ "/20", 300, 130); //Current Score
  textSize(18);
  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

//--------------------------------------------------------------------- WHILE LOOP LESSON

public int whileLoopLesson(int Score) {
  //Arrays Storing The Questions And Possible Answers
  String[] Question = {
    "What is a “while” loop?", "When using a loop for counting, what three things \nneed to be coordinated for the loop control variable?", 
    "What are the most common uses for while loops? \nA sentinel controlled loop repeats until something happens", 
    "What is the output of this code?", 
    "What is the output of this code?", 
    ""};
  String[] answerOptionOne = {
    "A loop that tests the condition first, then repeatedly runs while that condition is true", 
    "Variable name(s), Initial value, and Change in variable(s)", "Input validation and Sentinel controlled loops", 
    "Prints “Coding is cool!” 99 times", 
    "Infinite loop printing “Coding is cool!”", 
    ""
  };
  String[] answerOptionTwo = {
    "A loop that runs infinitely no matter what the loop’s condition evaluates to", 
    "Condition in the while loop, Change in variable(s), and Variable name(s)", 
    "Running something once", "Prints “Coding is cool!” 100 times", 
    "It will result in an error", 
    ""
  };
  String[] answerOptionThree = {
    "A loop that can’t be used for counting", "Initial value, Condition in the while loop, and Change in variable(s)", 
    "Sentinel controlled loops and for printing one line of text", 
    "Prints the numbers between 100 and 1 in descending order", 
    "It will run with no output", ""
  };
  String[] answerOptionFour = {
    "A loop that tests the condition first, then repeatedly runs while that condition is false", 
    "Change in variable(s), Variable name(s), and Condition in the while loop", 
    "To flood someone’s email with a million messages and input validation", 
    "It won’t run", "It won’t run", ""
  };

  //Completion of level
  if (questionValue == 6) {
    if (questionDebug) System.out.println("Final Score For While Loops: "+Score);
    whileLoopScore = Score; //Record score
    finalScore+=Score; //Add score to final tally
    page = 10; //Change page to corresponding feedback page
    questionValue = 1; //Reset question value for next levels
    //Level complete sound effect
    finishSE.play();
    finishSE.rewind();
  }

  //Shows questions and answers
  if (!show) {
    //Draws The Classroom And Whiteboard
    background(255);
    image(classroom, 0, 0);
    textAlign(CENTER, CENTER); //Center text by default

    //The Text Displaying Information To User
    fill(0);
    textSize(35);
    text("The \"While\" Loop", 300, 40); //Title Of Lesson
    textSize(25);
    text("Question " +questionValue+ ":", 300, 80); //Question
    textSize(25);
    text("Score: " +Score+ "/5", 300, 410); //Current Score
    textSize(18);
    textAlign(CENTER, TOP); //Center text by default

    text(Question[questionValue-1], 300, 110);

    timer();

    //Allow user to answer
    if (showingAnswer == true) {
      answerButton(answerOptionOne[questionValue-1], 13, 25, 175, 550, 40, 1);
      answerButton(answerOptionTwo[questionValue-1], 13, 25, 225, 550, 40, 2);
      answerButton(answerOptionThree[questionValue-1], 13, 25, 275, 550, 40, 3);
      answerButton(answerOptionFour[questionValue-1], 13, 25, 325, 550, 40, 4);
    }

    //Lock answers and show correct answer
    if (displayCorrectAnswer) {
      //Question Box 1
      fill(230);
      if (correctAnswerWhileLoops[questionValue-1] == 1) {
        fill(0, 255, 0);
      }
      rect(25, 175, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionOne[questionValue-1], 300, 195);
      fill(230);

      //Question Box 2
      if (correctAnswerWhileLoops[questionValue-1] == 2) {
        fill(0, 255, 0);
      }

      rect(25, 225, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionTwo[questionValue-1], 300, 245);
      fill(230);

      //Question Box 3
      if (correctAnswerWhileLoops[questionValue-1] == 3) {
        fill(0, 255, 0);
      }

      rect(25, 275, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionThree[questionValue-1], 300, 295);
      fill(230);

      //Question Box 4
      if (correctAnswerWhileLoops[questionValue-1] == 4) {
        fill(0, 255, 0);
      }

      rect(25, 325, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionFour[questionValue-1], 300, 345);
      fill(230);
      fill(0);

      countDown();
    }

    //Show the button for code picture on questions 4 and 5
    if (questionValue >= 4) {
      questionShowButton("Show Code", 18, 235, 137, 150, 30);
    }
  }

  //Show code picture
  if (show) {
    whileLoopsLessonShowQuestion();
  }

  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
  return Score;
} //End Of While Loops Lesson Function


void whileLoopsLessonShowQuestion() {
  //Array questions
  String[] Question = {
    "What is a “while” loop?", 
    "When using a loop for counting, what three things \nneed to be coordinated for the loop control variable?", 
    "What are the most common uses for while loops? \nA sentinel controlled loop repeats until something happens", 
    "What is the output of this code?", 
    "What is the output of this code?"
  };

  //Draws The Classroom And Whiteboard
  background(255);
  image(classroom, 0, 0);
  textAlign(CENTER, CENTER); //Center text by default

  //The Text Displaying Information To User
  fill(0);
  textSize(35);
  text("The \"While\" Loop", 300, 40); //Title Of Lesson
  textSize(25);
  text("Question " +questionValue+ ":", 300, 80); //Question
  textSize(25);
  textSize(18);
  textAlign(CENTER, TOP); //Center text by default

  text(Question[questionValue-1], 300, 110);

  //Show image of code for questions 4 and 5
  if (questionValue == 4) {
    image(whileLoop[0], 40, 150);
    whileLoop[0].resize(514, 199);
  }
  if (questionValue == 5) {
    image(whileLoop[1], 40, 150);
    whileLoop[1].resize(514, 199);
  }
  questionShowButton("Close Question", 18, 225, 395, 150, 30);
}

//--------------------------------------------------------------------- DO WHILE LESSON

public int doWhileLoopLesson(int Score) {
  //Array Storing The Questions And Possible Answers
  String[] Question = {
    "What is a “do while” loop?", 
    "What is the difference between:\n “while” loops and “do while” loops?", 
    "What are common causes for an infinite loop?", 
    "What is the output of this code?", 
    "What is the output of this code?", ""
  };
  String[] answerOptionOne = {
    "A loop that runs, tests the condition, then repeatedly runs while that condition is false", 
    "While loops will always execute", 
    "Syntax errors, Forgetting curly brackets, and Logic errors", 
    "Prints the numbers from 1-10, inclusive in ascending order", 
    "It will run with no output", ""
  };
  String[] answerOptionTwo = {
    "The exact same thing as a while loop", 
    "A “do while” loop always executes at least once", 
    "Forgetting curly brackets, Incorrect data types, and Syntax errors", 
    "Prints the numbers from 1-9, inclusive in ascending order", 
    "Prints the numbers between 10 and 1, inclusive in descending order", ""
  };
  String[] answerOptionThree = {
    "A loop that never tests the condition and runs anyway", 
    "A while loop executes repeatedly where as a “do while” loop does not", 
    "Logic errors, Syntax Errors, and Incorrect data types", 
    "Loops infinitely printing out numbers in ascending order", 
    "Prints 10 and ends", ""
  };
  String[] answerOptionFour = {
    "A loop that runs, tests the condition, then repeatedly runs while that condition is true", 
    "There is no difference", 
    "Incorrect data types, Logic errors, and Forgetting curly brackets", 
    "It won’t run", 
    "It won’t run", ""
  };

  if (questionValue == 6) {
    if (questionDebug) System.out.println("Final Score For Do While Loops: "+Score);
    doWhileLoopScore = Score;
    finalScore+=Score;
    page = 11;
    questionValue = 1;
    finishSE.play();
    finishSE.rewind();
  }

  if (!show) {
    //Draws The Classroom And Whiteboard
    background(255);
    image(classroom, 0, 0);
    textAlign(CENTER, CENTER); //Center text by default

    //The Text Displaying Information To User
    fill(0);
    textSize(35);
    text("The \"Do While\" Loop", 300, 40); //Title Of Lesson
    textSize(25);
    text("Question " +questionValue+ ":", 300, 80); //Question
    textSize(25);
    text("Score: " +Score+ "/5", 300, 410); //Current Score
    textSize(18);
    textAlign(CENTER, TOP); //Center text by default

    text(Question[questionValue-1], 300, 110);

    timer();

    if (showingAnswer == true) {
      answerButton(answerOptionOne[questionValue-1], 13, 25, 175, 550, 40, 1);
      answerButton(answerOptionTwo[questionValue-1], 13, 25, 225, 550, 40, 2);
      answerButton(answerOptionThree[questionValue-1], 13, 25, 275, 550, 40, 3);
      answerButton(answerOptionFour[questionValue-1], 13, 25, 325, 550, 40, 4);
    }

    if (displayCorrectAnswer) {
      //Question Box 1
      fill(230);
      if (correctAnswerdoWhileLoops[questionValue-1] == 1) {
        fill(0, 255, 0);
      }
      rect(25, 175, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionOne[questionValue-1], 300, 195);
      fill(230);

      //Question Box 2
      if (correctAnswerdoWhileLoops[questionValue-1] == 2) {
        fill(0, 255, 0);
      }

      rect(25, 225, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionTwo[questionValue-1], 300, 245);
      fill(230);

      //Question Box 3
      if (correctAnswerdoWhileLoops[questionValue-1] == 3) {
        fill(0, 255, 0);
      }

      rect(25, 275, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionThree[questionValue-1], 300, 295);
      fill(230);

      //Question Box 4
      if (correctAnswerdoWhileLoops[questionValue-1] == 4) {
        fill(0, 255, 0);
      }

      rect(25, 325, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionFour[questionValue-1], 300, 345);
      fill(230);
      fill(0); 
      countDown();
    }

    if (questionValue >= 4) {
      questionShowButton("Show Code", 18, 235, 137, 150, 30);
    }
  }

  if (show) {
    doWhileLoopsLessonShowQuestion();
  }

  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
  return Score;
} //End Of Do While Loops Lesson Function

void doWhileLoopsLessonShowQuestion() {
  //Array of Questions
  String[] Question = {
    "What is a “while” loop?", 
    "When using a loop for counting, what three things \nneed to be coordinated for the loop control variable?", 
    "What are the most common uses for while loops? \nA sentinel controlled loop repeats until something happens", 
    "What is the output of this code?", 
    "What is the output of this code?", ""
  };

  //Draws The Classroom And Whiteboard
  background(255);
  image(classroom, 0, 0);
  textAlign(CENTER, CENTER); //Center text by default

  //The Text Displaying Information To User
  fill(0);
  textSize(35);
  text("The \"Do While\" Loop", 300, 40); //Title Of Lesson
  textSize(25);
  text("Question " +questionValue+ ":", 300, 80); //Question
  textSize(25);
  textSize(18);
  textAlign(CENTER, TOP); //Center text by default

  text(Question[questionValue-1], 300, 110);

  if (questionValue == 4) {
    image(doWhileLoop[0], 150, 150);
    doWhileLoop[0].resize(319, 199);
  }
  if (questionValue == 5) {
    image(doWhileLoop[1], 150, 150);
    doWhileLoop[1].resize(319, 199);
  }
  questionShowButton("Close Question", 18, 225, 395, 150, 30);
}

//--------------------------------------------------------------------- FOR LOOP LESSON

public int forLoopLesson(int Score) {
  //Arrays Storing The Questions And Possible Answers
  String[] Question = {
    "What is a \"for\" loop", 
    "What is the syntax for a \"for\" loop?", 
    "What does i++ and i-- do?", 
    "What is the output of this code?", 
    "What is the output of this code?", ""
  };
  String[] answerOptionOne = {
    "A loop that runs forever", 
    "for (<increment>; <condition>; <initialization>) { <statements> } ", 
    "They are the same as i = i + 1 and i = i - 1", 
    "Prints 10", 
    "Prints “Hello!” 4 times in one line (separated by spaces)", ""
  };
  String[] answerOptionTwo = {
    "A counted loop that has the Initial value, Condition, and Change all in one line", 
    "for (<initialization>; <increment>; <condition>) { <statements> } ", 
    "They double or half the value of the variable", 
    "Prints 14", 
    "Prints “Hello! Hello!” in one line", ""
  };
  String[] answerOptionThree = {
    "A much longer and more complex loop than a “while” and “do while” loop", 
    "for (<condition>; <initialization>; <increment>) { <statements> } ", 
    "They tell the program which line of code to read from the body", 
    "Prints 15", 
    "Prints “Hello!” 5 times in one line (separated by spaces)", ""
  };
  String[] answerOptionFour = {
    "A counted loop that only tests the condition once though all iterations", 
    "for (<initialization>; <condition>; <increment>) { <statements> }  ", 
    "They are the same as i = i + 2 and i = i - 2", 
    "It won’t run", 
    "It won’t run", ""
  };

  if (questionValue == 6) {
    if (questionDebug) System.out.println("Final Score For Do While Loops: "+Score);
    forLoopScore = Score;
    finalScore+=Score;
    page = 12;
    questionValue = 1;
    finishSE.play();
    finishSE.rewind();
  }

  if (!show) {
    //Draws The Classroom And Whiteboard
    background(255);
    image(classroom, 0, 0);
    textAlign(CENTER, CENTER); //Center text by default

    //The Text Displaying Information To User
    fill(0);
    textSize(35);
    text("The \"For\" Loop", 300, 40); //Title Of Lesson
    textSize(25);
    text("Question " +questionValue+ ":", 300, 80); //Question
    textSize(25);
    text("Score: " +Score+ "/5", 300, 410); //Current Score
    textSize(18);
    textAlign(CENTER, TOP); //Center text by default

    text(Question[questionValue-1], 300, 110);

    timer();

    if (showingAnswer == true) {
      answerButton(answerOptionOne[questionValue-1], 13, 25, 175, 550, 40, 1);
      answerButton(answerOptionTwo[questionValue-1], 13, 25, 225, 550, 40, 2);
      answerButton(answerOptionThree[questionValue-1], 13, 25, 275, 550, 40, 3);
      answerButton(answerOptionFour[questionValue-1], 13, 25, 325, 550, 40, 4);
    }

    if (displayCorrectAnswer) {
      //Question Box 1
      fill(230);
      if (correctAnswerForLoops[questionValue-1] == 1) {
        fill(0, 255, 0);
      }
      rect(25, 175, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionOne[questionValue-1], 300, 195);
      fill(230);

      //Question Box 2
      if (correctAnswerForLoops[questionValue-1] == 2) {
        fill(0, 255, 0);
      }

      rect(25, 225, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionTwo[questionValue-1], 300, 245);
      fill(230);

      //Question Box 3
      if (correctAnswerForLoops[questionValue-1] == 3) {
        fill(0, 255, 0);
      }

      rect(25, 275, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionThree[questionValue-1], 300, 295);
      fill(230);

      //Question Box 4
      if (correctAnswerForLoops[questionValue-1] == 4) {
        fill(0, 255, 0);
      }

      rect(25, 325, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionFour[questionValue-1], 300, 345);
      fill(230);
      fill(0); 
      countDown();
    }

    if (questionValue >= 4) {
      questionShowButton("Show Code", 18, 235, 137, 150, 30);
    }
  }

  if (show) {
    forLoopsLessonShowQuestion();
  }

  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
  return Score;
} //End Of For Loops Lesson Function


void forLoopsLessonShowQuestion() {
  //Array of questions
  String[] Question = {
    "What is a “while” loop?", 
    "When using a loop for counting, what three things \nneed to be coordinated for the loop control variable?", 
    "What are the most common uses for while loops? \nA sentinel controlled loop repeats until something happens", 
    "What is the output of this code?", 
    "What is the output of this code?", ""
  };

  //Draws The Classroom And Whiteboard
  background(255);
  image(classroom, 0, 0);
  textAlign(CENTER, CENTER); //Center text by default

  //The Text Displaying Information To User
  fill(0);
  textSize(35);
  text("The \"For\" Loop", 300, 40); //Title Of Lesson
  textSize(25);
  text("Question " +questionValue+ ":", 300, 80); //Question
  textSize(25);
  textSize(18);
  textAlign(CENTER, TOP); //Center text by default

  text(Question[questionValue-1], 300, 110);

  if (questionValue == 4) {
    image(forLoop[0], 85, 150);
    forLoop[0].resize(425, 199);
  }
  if (questionValue == 5) {
    image(forLoop[1], 85, 150);
    forLoop[1].resize(425, 199);
  }
  questionShowButton("Close Question", 18, 225, 395, 150, 30);
}

//--------------------------------------------------------------------- Bonus Questions

public int bonus(int Score) {
  //Arrays Storing The Questions And Possible Answers
  String[] Question = {
    "What keyword is used to; \n completely exit an entire loop structure?", 
    "What keyword is used to exit the current iteration of a loop\nand continue to the next iteration with the next value?", 
    "Each expression in the header of a “for” loop is optional, \nif missing it will not run(semicolons still required)", 
    "This code is supposed to count down by 5\nfrom the starting value but outputs nothing. Where is the bug?", 
    "This code is supposed to print numbers from the start to end\nvariable(inclusive) but outputs only “Start”. What is the error?", ""
  };
  String[] answerOptionOne = {
    "null", 
    "do", 
    "True", 
    "The initialization in the loop header (should be i = 35)", 
    "Improper operator for condition", ""
  };
  String[] answerOptionTwo = {
    "continue", 
    "continue", 
    "False", 
    "The condition in the loop header (should be i > 0)", 
    "Improper variable initialization", ""
  };
  String[] answerOptionThree = {
    "do", 
    "break", 
    " ", 
    "The increment in the loop header (should be i += 5)", 
    "Infinite loop", ""
  };
  String[] answerOptionFour = {
    "break", 
    "null", 
    " ", 
    "The body of the loop (should include a decrement)", 
    "Improper increment", ""
  };

  if (questionValue == 6) {
    if (questionDebug) System.out.println("Final Score For Bonus Questions: "+Score);
    bonusScore = Score;
    finalScore+=Score;
    page = 13;
    questionValue = 1;
    finishSE.play();
    finishSE.rewind();
  }

  if (!show) {
    //Draws The Classroom And Whiteboard
    background(255);
    image(classroom, 0, 0);
    textAlign(CENTER, CENTER); //Center text by default

    //The Text Displaying Information To User
    fill(0);
    textSize(35);
    text("Bonus Questions", 300, 40); //Title Of Lesson
    textSize(25);
    text("Question " +questionValue+ ":", 300, 80); //Question
    textSize(25);
    text("Score: " +Score+ "/5", 300, 415); //Current Score
    textSize(18);
    textAlign(CENTER, TOP); //Center text by default

    text(Question[questionValue-1], 300, 110);
    timer();

    if (showingAnswer == true && questionValue != 3) {
      answerButton(answerOptionOne[questionValue-1], 13, 25, 175, 550, 40, 1);
      answerButton(answerOptionTwo[questionValue-1], 13, 25, 225, 550, 40, 2);
      answerButton(answerOptionThree[questionValue-1], 13, 25, 275, 550, 40, 3);
      answerButton(answerOptionFour[questionValue-1], 13, 25, 325, 550, 40, 4);
    }

    if (displayCorrectAnswer) {
      //Question Box 1
      fill(230);
      if (correctAnswerBonus[questionValue-1] == 1) {
        fill(0, 255, 0);
      }
      rect(25, 175, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionOne[questionValue-1], 300, 195);
      fill(230);

      //Question Box 2
      if (correctAnswerBonus[questionValue-1] == 2) {
        fill(0, 255, 0);
      }

      rect(25, 225, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionTwo[questionValue-1], 300, 245);
      fill(230);

      //Question Box 3
      if (correctAnswerBonus[questionValue-1] == 3) {
        fill(0, 255, 0);
      }

      rect(25, 275, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionThree[questionValue-1], 300, 295);
      fill(230);

      //Question Box 4
      if (correctAnswerBonus[questionValue-1] == 4) {
        fill(0, 255, 0);
      }

      rect(25, 325, 550, 40);
      fill(0);
      textSize(13);
      text(answerOptionFour[questionValue-1], 300, 345);
      fill(230);
      fill(0); 
      countDown();
    }

    if (questionValue == 3) {
      bonusQuestionThree();
    }

    if (questionValue >= 4) {
      questionShowButton("Show Code", 18, 225, 371, 150, 30);
    }
  }

  if (show) {
    bonusQuestionsShowQuestion();
  }

  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
  return Score;
} //End Of Bonus Questions Function

//Custom bomb defuse question
void bonusQuestionThree() {
  String questionBomb = "Each expression in the header of a “for” loop is optional, \nif missing it will not run (semicolons still required)";
  Scissors.resize(300, 300);
  Bomb.resize(500, 400);
  background(255);
  image(Bomb, 65, -40);

  timer();

  //Red wire
  strokeWeight(5);
  stroke(255, 0, 0);
  line(40, 150, 110, 150);
  line(40, 150, 40, 350);
  line(40, 350, 190, 350);
  line(190, 350, 190, 650);

  //Blue wire
  strokeWeight(5);
  stroke(0, 0, 255);
  line(516, 150, 560, 150);
  line(560, 150, 560, 350);
  line(560, 350, 440, 350);
  line(440, 350, 440, 650);

  fill(0);
  textSize(16);
  text(questionBomb, 300, 295);

  //True Wire
  stroke(0);
  stroke(255, 0, 0);
  fill(230);
  rect(165, 400, 50, 150);
  fill(0);
  textSize(13);
  text("True", 190, 470); //Centers the texts
  stroke(0, 0, 255);

  if (clicked == true && mouseX > 165 && mouseX < 218 && mouseY > 400 && mouseY < 550) {
    Score += 1;
    correctSE.play();
    correctSE.rewind();
    passedTime = millis(); //Restarts timer
    passedTimeCD = millis(); //Restarts timer
    questionValue += 1;
  }

  //False Wire
  stroke(0);
  stroke(0, 0, 255);
  fill(230);
  rect(415, 400, 50, 150);
  fill(0);
  textSize(13);
  text("False", 440, 470); //Centers the texts
  stroke(0, 0, 255);

  if (clicked == true && mouseX > 410 && mouseX < 470 && mouseY > 400 && mouseY < 550) {
    incorrectSE.play();
    incorrectSE.rewind();
    passedTime = millis(); //Restarts timer
    passedTimeCD = millis(); //Restarts timer
    questionValue += 1;
  }
  stroke(0);
  strokeWeight(1);
  image(Scissors, mouseX-60, mouseY-70);
  clicked = false;
}


void bonusQuestionsShowQuestion() {
  //Array of Questions
  String[] Question = {
    "What is a “while” loop?", 
    "When using a loop for counting, what three things \nneed to be coordinated for the loop control variable?", 
    "What are the most common uses for while loops? \nA sentinel controlled loop repeats until something happens", 
    "What is the output of this code?", 
    "What is the output of this code?"
  };
  //Draws The Classroom And Whiteboard
  background(255);
  image(classroom, 0, 0);
  textAlign(CENTER, CENTER); //Center text by default

  //The Text Displaying Information To User
  fill(0);
  textSize(35);
  text("Bonus Questions", 300, 40); //Title Of Lesson
  textSize(25);
  text("Question " +questionValue+ ":", 300, 80); //Question
  textSize(25);
  textSize(18);
  textAlign(CENTER, TOP); //Center text by default

  text(Question[questionValue-1], 300, 110);

  if (questionValue == 4) {
    image(bonus[0], 110, 140);
    bonus[0].resize(375, 240);
  }
  if (questionValue == 5) {
    image(bonus[1], 110, 140);
    bonus[1].resize(375, 240);
  }
  questionShowButton("Close Question", 18, 225, 400, 150, 30);
}

//--------------------------------------------------------------------- WHILE LOOPS ANSWER CHECKER FUNCTION

void whileLoopsLessonAnswerChecker (int answer) {
  //Check answer
  if (answer == correctAnswerWhileLoops[questionValue-1]) { //If correct
    Score += 1;                    //Increment score
    correctSE.play();              //Play correct sound effect
    correctSE.rewind();
    displayCorrectAnswer = true;   //Show correct answers
    showingAnswer = false;         //Lock responses
  }
  if (answer != correctAnswerWhileLoops[questionValue-1]) { //If incorrect
    incorrectSE.play();            //Play incorrect answer sound effect
    incorrectSE.rewind();
    displayCorrectAnswer = true;
    showingAnswer = false;
  }
  if (questionDebug) System.out.println("Question "+questionValue+" || Entered Answer: "+answer+" || Correct Answer: "+correctAnswerWhileLoops[questionValue-1]); //Debugging
  if (questionValue < 5) {
  }
}

//--------------------------------------------------------------------- DO WHILE LOOPS ANSWER CHECKER FUNCTION

void doWhileLoopsLessonAnswerChecker (int answer) {
  if (answer == correctAnswerdoWhileLoops[questionValue-1]) {
    Score += 1;
    correctSE.play();
    correctSE.rewind();
    displayCorrectAnswer = true;
    showingAnswer = false;
  }
  if (answer != correctAnswerdoWhileLoops[questionValue-1]) {
    incorrectSE.play();
    incorrectSE.rewind();
    displayCorrectAnswer = true;
    showingAnswer = false;
  }
  if (questionDebug)System.out.println("Question "+questionValue+" || Entered Answer: "+answer+" || Correct Answer: "+correctAnswerdoWhileLoops[questionValue-1]);
  if (questionValue < 5) {
  }
}

//--------------------------------------------------------------------- FOR LOOPS ANSWER CHECKER FUNCTION

void forLoopsLessonAnswerChecker (int answer) {
  if (answer == correctAnswerForLoops[questionValue-1]) {
    Score += 1;
    correctSE.play();
    correctSE.rewind();
    displayCorrectAnswer = true;
    showingAnswer = false;
  }
  if (answer != correctAnswerForLoops[questionValue-1]) {
    incorrectSE.play();
    incorrectSE.rewind();
    displayCorrectAnswer = true;
    showingAnswer = false;
  }
  if (questionDebug)System.out.println("Question "+questionValue+" || Entered Answer: "+answer+" || Correct Answer: "+correctAnswerForLoops[questionValue-1]);
  if (questionValue < 5) {
  }
}

//--------------------------------------------------------------------- BONUS QUESTIONS ANSWER CHECKER FUNCTION

void bonusAnswerChecker (int answer) {
  if (answer == correctAnswerBonus[questionValue-1]) {
    Score += 1;
    correctSE.play();
    correctSE.rewind();

    displayCorrectAnswer = true;
    showingAnswer = false;
  }
  if (answer != correctAnswerBonus[questionValue-1]) {
    incorrectSE.play();
    incorrectSE.rewind();
    displayCorrectAnswer = true;
    showingAnswer = false;
  }
  if (questionDebug)System.out.println("Question "+questionValue+" || Entered Answer: "+answer+" || Correct Answer: "+correctAnswerBonus[questionValue-1]);
  if (questionValue < 5) {
  }
}

//--------------------------------------------------------------------- FEEDBACK FUNCTIONS

//FEEDBACK WHILE LOOPS
void feedbackWhileLoops(int Score) {
  //Draw Teacher
  background(200);
  Teacher.resize(140, 310);
  image(Teacher, 460, 280);

  //Draw speech bubble
  Feedback.resize(645, 300);
  image(Feedback, -65, 0);

  textAlign(LEFT, CENTER); //Center text by default
  textSize(18);

  //Text location variables
  int textY = 30;
  int textX = 10;

  //Put feedback on screen
  text("A common programming error when using while loops", textX, textY);
  text("in your code is an infinite loop (as shown in question 5).", textX, textY+20);
  text("You should always make sure that there is some code within", textX, textY+40);
  text("the body of the while loop to modify the loop’s expression.", textX, textY+60);
  text("You also want to make sure that the condition will eventually", textX, textY+80);
  text("become false.", textX, textY+100);

  textAlign(CENTER, CENTER); //Center text by default
  textSize(25);
  text("You Scored: " +Score+ "/5", 300, 180); //Current Score

  if (clicked == true && mouseX > 150 && mouseX < 150 + 250 && mouseY > 250 && mouseY < 250 + 80) {
    completedWhileLoops = true;
  }

  button("Continue", 40, 150, 250, 300, 80, -3); //Go back to level selection

  //Update boolean variables
  displayCorrectAnswer = false;
  showingAnswer = true;

  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
  Score = 0; //Reset score
}

//FEEDBACK DO WHILE LOOPS
void feedbackDoWhileLoops(int Score) {
  background(200);
  Teacher.resize(140, 310);
  image(Teacher, 460, 280);

  Feedback.resize(645, 300);
  image(Feedback, -65, 0);

  textAlign(LEFT, CENTER); //Center text by default
  textSize(18);

  int textY = 30;
  int textX = 10;

  text("-An example of a syntax error that results in an infinite loop", textX, textY);
  text(" is a semicolon between the condition of a while loop", textX, textY+20);
  text(" and the opening curly bracket as it will check the condition,", textX, textY+40);
  text(" do nothing, and repeat that cycle.", textX, textY+60);
  text("-There will also be an infinite loop if you omit the curly", textX, textY+80);
  text(" brackets all together, or if you make a logic error", textX, textY+100);
  text(" in the condition or loop body.", textX, textY+120);

  textAlign(CENTER, CENTER); //Center text by default
  textSize(25);
  text("You Scored: " +Score+ "/5", 300, 180); //Current Score

  if (clicked == true && mouseX > 150 && mouseX < 150 + 250 && mouseY > 250 && mouseY < 250 + 80) {
    completedDoWhileLoops = true;
  }

  button("Continue", 40, 150, 250, 300, 80, -3);
  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

//FEEDBACK FOR LOOPS

void feedbackForLoops(int Score) {
  background(200);
  Teacher.resize(140, 310);
  image(Teacher, 460, 280);

  Feedback.resize(645, 360);
  image(Feedback, -65, 0);

  textAlign(LEFT, CENTER); //Center text by default
  textSize(18);

  int textY = 30;
  int textX = 10;

  text("-The “for” loop is a more convenient and compact version of", textX, textY);
  text(" counted “while” and “do while” loops.", textX, textY+20);
  text("-It is similar to a while loop as it tests the condition first,", textX, textY+40);
  text(" then decides whether or not to execute the code.", textX, textY+60);
  text("-In this loop you initialize a control variable", textX, textY+80);
  text(" (this only happens when the for statement is executed),", textX, textY+100);
  text(" test a condition (this happens before every iteration),", textX, textY+120);
  text(" and modify the control variable", textX, textY+140);
  text(" (this is done after every iteration) in one line of code.", textX, textY+160);

  textAlign(CENTER, CENTER); //Center text by default
  textSize(25);
  text("You Scored: " +Score+ "/5", 300, 220); //Current Score

  if (clicked == true && mouseX > 150 && mouseX < 150 + 290 && mouseY > 290 && mouseY < 290 + 80) {
    completedForLoops = true;
  }

  button("Continue", 40, 150, 290, 300, 80, -3);
  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

//FEEDBACK FOR BONUS

void feedbackBonus(int Score) {
  background(200);
  Teacher.resize(140, 310);
  image(Teacher, 460, 280);

  Feedback.resize(645, 360);
  image(Feedback, -65, 0);

  textAlign(LEFT, CENTER); //Center text by default
  textSize(18);

  int textY = 30;
  int textX = 10;

  text("-“while” loops are a pre-test loop and are often used when", textX, textY);
  text(" you are not sure exactly how many times you need to loop.", textX, textY+20);
  text("-“do-while” loops are often used when you need a body of", textX, textY+40);
  text(" code to execute at least once, but possibly execute it", textX, textY+60);
  text(" multiple times.", textX, textY+80);
  text("-“for” loops are often used when you know exactly how", textX, textY+100);
  text(" many times you need to loop a body of code.", textX, textY+120);
  text(" -All of these loops depend on an expression and loop", textX, textY+140);
  text("  repeated only when it is true.", textX, textY+160);

  textAlign(CENTER, CENTER); //Center text by default
  textSize(25);
  text("You Scored: " +Score+ "/5", 300, 220); //Current Score

  if (clicked == true && mouseX > 150 && mouseX < 150 + 290 && mouseY > 290 && mouseY < 290 + 80) {
    completedBonus = true;
  }

  button("Continue", 40, 150, 290, 300, 80, -3);
  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

//--------------------------------------------------------------------- TIMER FUNCTIONS

void timer() {
  time = ((millis() - passedTime) / 1000); //Updates time variable

  //Prints time onto screen
  textAlign(CENTER, CENTER);
  textSize(15);
  text("Timer:", 50, 40);
  textSize(25);
  text(timeAllowed - time, 50, 60); //Makes the time count down instead

  //Check if time is more than allowed
  if (time > timeAllowed) { 
    //Custom code for bomb defuse bonus question
    if (page == 4 && questionValue == 3) {
      questionValue = 4;
      incorrectSE.play();
      incorrectSE.rewind();
      displayCorrectAnswer = false;
      showingAnswer = true;
    } else {
      byPass = true; //Choose random answer
    }
    passedTime = millis(); //Restarts timer
    passedTimeCD = millis(); //Restarts timer
  }
}

void countDown() {
  timeCD = (timeAllowedCD - ((millis() - passedTimeCD) / 1000)); //Updates time variable
  println(timeCD);

  //When countdown reaches 0
  if (timeCD == 0) {
    println(timeCD);
    showingAnswer = true;          //Reset showanswer boolean for next question
    displayCorrectAnswer = false;  //Stop showing ccorrect answers
    questionValue += 1;
    passedTime = millis(); //Restarts timer
    passedTimeCD = millis(); //Restarts countdown timer
    if (questionValue == 5) {
    }
  }
}

//--------------------------------------------------------------------- FUNCTION THAT CHECKS FOR MOUSE INPUT

void mouseReleased() {
  clicked = true; //PART 2 of 3 - Sets variable to true when mouse is clicked
}

//--------------------------------------------------------------------- FUNCTION THAT CHECKS FOR KEYBOARD INPUT

void keyPressed () {
  //Debugging mode keybinds
  if (keyCode == 116) {
    debuggingMode = true;
    System.out.println("Debugging Mode Active!");
  }

  if (keyCode == 115) {
    questionDebug = true;
    System.out.println("Question Debugging Mode Active!");
  }

  //End game keybinds
  //Reset Game
  if (key == 'r') {
    //Reset all game variables
    if (resetGame == true) {
      //Set all completion statuses to false
      System.out.println("Reset");
      finalScore = 0;
      completedWhileLoops = false;
      completedDoWhileLoops = false;
      completedForLoops = false;
      completedBonus = false;
      riseUp = 700;
      //Reset all scores
      whileLoopScore = 0;
      doWhileLoopScore = 0;
      forLoopScore = 0;
      bonusScore = 0;


      pass = false;
      resetGame = false;
      draw(); //Restart draw function
    }
  }

  //Exit game
  if (key == 'e') {
    if (resetGame == true) {
      page = -2; //Goes to page that quits game
    }
  }

  //Audio keybinds
  if (key == 'p') { //Pause and Play toggle for music
    if (!msm.isPlaying()) msm.play();
    else msm.pause();
  }

  if (key == 'm') { //Mute toggle
    if (!muted) { //Mute all game sounds
      msm.mute();
      clickSE.mute();
      correctSE.mute();
      incorrectSE.mute();
      finishSE.mute();
      muted = true;
    } else { //Unmute all game sounds
      clickSE.unmute();
      msm.unmute();
      correctSE.unmute();
      incorrectSE.unmute();
      finishSE.unmute();
      muted = false;
    }
  }

  if (keyCode == UP) { //Increase all volume by 5 dB
    msm.shiftGain(msm.getGain(), msm.getGain() + 5, 200);
    clickSE.shiftGain(clickSE.getGain(), clickSE.getGain() + 5, 200);
    correctSE.shiftGain(correctSE.getGain(), msm.getGain() + 5, 200);
    incorrectSE.shiftGain(incorrectSE.getGain(), msm.getGain() + 5, 200);
    finishSE.shiftGain(finishSE.getGain(), msm.getGain() + 5, 200);
  }

  if (keyCode == DOWN) { //Decrease all volume by 5 dB
    msm.shiftGain(msm.getGain(), msm.getGain() - 5, 200);
    clickSE.shiftGain(clickSE.getGain(), clickSE.getGain() - 5, 200);
    correctSE.shiftGain(correctSE.getGain(), msm.getGain() - 5, 200);
    incorrectSE.shiftGain(incorrectSE.getGain(), msm.getGain() - 5, 200);
    finishSE.shiftGain(finishSE.getGain(), msm.getGain() - 5, 200);
  }
}

//--------------------------------------------------------------------- GIF LOADER FUNCTION

void gifLoader() {
  for (int i = 1; i < 135; i++) { //Load all 135 images
    startMenu[i] = loadImage("Menu-"+i+".png" );
  }
}

//--------------------------------------------------------------------- ANSWER BUTTON FUNCTION

void answerButton(String txt, int txtSize, int x, int y, int w, int h, int answer) {
  //Draw button
  fill(230);
  rect(x, y, w, h);

  if (byPass) {
    //Randomly select an answer
    if (page == 1)whileLoopsLessonAnswerChecker((int) random(1, 5));
    if (page == 2)doWhileLoopsLessonAnswerChecker((int) random(1, 5));
    if (page == 3)forLoopsLessonAnswerChecker((int) random(1, 5));
    if (page == 4)bonusAnswerChecker((int) random(1, 5));

    passedTime = millis(); //Restarts timer
    passedTimeCD = millis(); //Restarts timer

    byPass = false; //Reset boolean variable
  }

  if ((mouseX > x && mouseX < x + w) && (mouseY > y && mouseY < y + h)) { //Sets area for mouse to click button
    fill(150); //Makes the button darker when mouse hovers over it
    rect(x - w * 0.01, y - h * 0.01, w + w * 0.02, h + h * 0.02); //Makes the button larger when the mouse hovers over it

    if (clicked) { //Switches to corresponding page when button clicked

      if (page == 1)whileLoopsLessonAnswerChecker(answer);
      if (page == 2)doWhileLoopsLessonAnswerChecker(answer);
      if (page == 3)forLoopsLessonAnswerChecker(answer);
      if (page == 4)bonusAnswerChecker(answer);

      passedTime = millis(); //Restarts timer
      passedTimeCD = millis(); //Restarts timer
    }
  }
  //Colours and sizes the text for button
  fill(0);
  textSize(txtSize);
  text(txt, x + w / 2, y + h / 2); //Centers the texts
}

//--------------------------------------------------------------------- QUESTION SHOW BUTTON FUNCTION

void questionShowButton(String txt, int txtSize, int x, int y, int w, int h) {
  textAlign(CENTER, CENTER); //Center text by default
  fill(230);
  rect(x, y, w, h);

  if ((mouseX > x && mouseX < x + w) && (mouseY > y && mouseY < y + h)) { //Sets area for mouse to click button
    fill(150); //Makes the button darker when mouse hovers over it
    rect(x - w * 0.01, y - h * 0.01, w + w * 0.02, h + h * 0.02); //Makes the button larger when the mouse hovers over it

    if (clicked) {
      clickSE.play();
      clickSE.rewind();
      if (!show) {
        show = true;
      } else {
        show = false;
      }
    }
  }

  //Colours and sizes the text for button
  fill(0);
  textSize(txtSize);
  text(txt, x + w / 2, y + h / 2); //Centers the text
}

//--------------------------------------------------------------------- MENU BUTTONS FUNCTION

void button(String txt, int txtSize, int x, int y, int w, int h, int switchPage) {
  String pageNames = "";

  fill(200);
  rect(x, y, w, h);
  if ((mouseX > x && mouseX < x + w) && (mouseY > y && mouseY < y + h)) { //Sets area for mouse to click button
    fill(150); //Makes the button darker when mouse hovers over it
    rect(x - w * 0.05, y - h * 0.05, w + w * 0.1, h + h * 0.1); //Makes the button larger when the mouse hovers over it
    if (clicked) { //Switches to corresponding page when button clicked
      Score = 0;
      clickSE.play();
      clickSE.rewind();
      passedTime = millis(); //Restarts timer
      passedTimeCD = millis(); //Restarts timer
      showingAnswer = true;
      displayCorrectAnswer = false;

      page = switchPage; //Change page to page specified in parameter
      if (page == -3) pageNames = "Lesson Selection";
      if (page == -1) pageNames = "Instructions Page";
      if (page == 0) pageNames = "Menu Page";
      if (page == 1) pageNames = "While Loop Lesson";
      if (page == 2) pageNames = "Do While Loop Lesson";
      if (page == 3) pageNames = "For Loop Lesson";
      if (page == 4) pageNames = "Bonus Questions";
      if (debuggingMode)System.out.println("Page "+page+" || "+pageNames);
    }
  }
  //Colours and sizes the text for button
  fill(0);
  textSize(txtSize);
  text(txt, x + w / 2, y + h / 2); //Centers the text
}

//Oreo Function
void Oreo() {
  image(Oreo, randNumX, randNumY);
}

//--------------------------------------------------------------------- END GAME FUNCTION

void endGamePassed() {
  String textAtBottom = "You Passed";
  //Animate Certificate
  if (riseUp > 0) {
    riseUp -=3;
    textSize(30);
    textAtBottom = "Press 'e' to exit the game\nPress 'r' to reset the game";
  } else {
    textSize(60);
  }
  image(Passed, 0, riseUp);

  //Draw Oreo
  if (finalScore >= 18) { //Check if score > 90%
    Oreo.resize(80, 80);
    Oreo();
  }

  image(Floor, 0, 475);          //Draw floor
  fill(255);                     //Make text white
  text(textAtBottom, 300, 530);  //Draw text at bottom
  resetGame = true;
  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}

void endGameFailed() {
  String textAtBottom = "You Did Not Pass";
  if (riseUp > 0) {
    riseUp -=3;
    textSize(30);
    textAtBottom = "Press 'e' to exit the game\nPress 'r' to reset the game";
  } else {
    textSize(60);
  }
  image(Failed, 0, riseUp);

  image(Floor, 0, 475);
  fill(255);
  text(textAtBottom, 300, 530);
  resetGame = true;
  clicked = false; //Part 3 of 3 - Resets variable to false at the end of every draw cycle
}
