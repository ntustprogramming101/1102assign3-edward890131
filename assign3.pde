final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;


float piece = 80.0;
int frames = 15;
int floorSpeed = 0;
float downMove = 0;
int down = 0;
int right = 0;
int left = 0;

int groundhogState;
int groundhogCount = 0;
float groundhogX = piece*4;
float groundhogY = piece;
int nbrSoil = 6;
final int GROUNDHOG_IDLE = 0, GROUNDHOG_DOWN = 1, GROUNDHOG_LEFT = 2, GROUNDHOG_RIGHT = 3;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24, life, cabbage, soldier;
PImage [] soils;
PImage stone1, stone2;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;

// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

int soilYInitail = 160;
float stoneX1, stoneY1, stoneX2, stoneY2, stoneX3, stoneY3;
int playerHealthDefault = 2, playerHealthMax = 6, lifeX = 10, lifeY = 10, lifeWidth = 50, lifeSpacing = 20;
float cabbageX = floor(random(4))*piece;
float initCabbageY = piece*2 + floor(random(4))*piece;
float cabbageY;
float soldierX;
float initSoldierY = piece*2 + floor(random(4))*piece;
float soldierY;
boolean downPressed = false, leftPressed = false, rightPressed = false;

void setup() {
	size(640, 480, P2D);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  life = loadImage("img/life.png");
  cabbage = loadImage("img/cabbage.png");
  soldier = loadImage("img/soldier.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
	soil8x24 = loadImage("img/soil8x24.png");

  soils = new PImage[nbrSoil];
  for(int i=0; i<nbrSoil;i++){
    soils[i] = loadImage("img/soil"+i+".png");
  }
  
  playerHealth = int(playerHealthDefault);
  constrain(playerHealth,0 ,playerHealthMax);
  
  frameRate(60); 
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}
		}else{
			image(startNormal, START_BUTTON_X, START_BUTTON_Y);
		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	  stroke(255,255,0);
	  strokeWeight(5);
	  fill(253,184,19);
	  ellipse(590,50,120,120);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT +downMove, width, GRASS_HEIGHT);

    // Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
    //image(soil8x24, 0, 160);
    //soil
    for(int i=0; i<8; i++){
      for(int j=0; j<24; j++){
        if(j==0){
          image(soils[0], i*piece, soilYInitail +downMove);
        }
        else{
          image(soils[(floor(j/4))], i*piece, soilYInitail+j*piece +downMove);
        }
      }
    }
    
    //stone
    //stone1 1-8
    stoneY1 = 160;
    for(int i=0; i<8; i++){
      stoneX1 = i*piece;
      image(stone1, stoneX1, stoneY1 +downMove);
      stoneY1+=piece;
    }
    
    //stone1 9-16
    stoneY2 = 160+piece*8;
    for(int i=0; i<8; i++){
      if (i%4==1||i%4==2){
        for(int j=0; j<8; j++){
          if (j%4==0||j%4==3){
            stoneX2 = i*piece;
            image(stone1, stoneX2, stoneY2+j*piece +downMove);
          }
        }
      }
      if (i%4==3||i%4==0){
        for(int j=0;j<8;j++){
          if (j%4==1||j%4==2){
            stoneX2 = i*piece;
            image(stone1, stoneX2, stoneY2+j*piece +downMove);
          }
        }
      }
    }
    //stone2 17-24
    stoneY3 = 160+piece*16;
    for(int j=0; j<8; j++){
      if(j%3==0){
        for(int i=0;i<8;i++){
          if(i%3!=0){
            stoneX3 = i*piece;
            image(stone1,stoneX3,stoneY3+j*piece +downMove);
            if(i%3==2){
              image(stone2,stoneX3,stoneY3+j*piece +downMove);
            }
          }
        }
      }
      if(j%3==1){
        for(int i=0;i<8;i++){
          if(i%3!=2){
            stoneX3 = i*piece;
            image(stone1,stoneX3,stoneY3+j*piece +downMove);
            if(i%3==1){
              image(stone2,stoneX3,stoneY3+j*piece +downMove);
            }
          }
        }
      }
      if(j%3==2){
        for(int i=0;i<8;i++){
          if(i%3!=1){
            stoneX3 = i*piece;
            image(stone1,stoneX3,stoneY3+j*piece +downMove);
            if(i%3==0){
              image(stone2,stoneX3,stoneY3+j*piece +downMove);
            }
          }
        }
      }
    }
    
    // Player
    //groundhog move
    //down
    if (down > 0 && downMove > -1600) {
      floorSpeed -=1;
      if (down == 1) {
        downMove = round(piece/frames*floorSpeed);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        downMove = piece/frames*floorSpeed;
        image(groundhogDown, groundhogX, groundhogY);
      }
      down -=1;
    }

    if (down > 0 && downMove == -1600) {
      if (down == 1) {
        groundhogY = round(groundhogY + piece/frames);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogY = groundhogY + piece/frames;
        image(groundhogDown, groundhogX, groundhogY);
      }
      down -=1;
    }

    //left
    if (left > 0) {
      if (left == 1) {
        groundhogX = round(groundhogX - piece/frames);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX - piece/frames;
        image(groundhogLeft, groundhogX, groundhogY);
      }
      left -=1;
    }

    //right
    if (right > 0) {
      if (right == 1) {
        groundhogX = round(groundhogX + piece/frames);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX + piece/frames;
        image(groundhogRight, groundhogX, groundhogY);
      }
      right -=1;
    }

    //no move
    if (down == 0 && left == 0 && right == 0 ) {
      image(groundhogIdle, groundhogX, groundhogY);
    }
      
    //boundary detection of the groundhog
    if(groundhogX < 0){ groundhogX = 0; }
    if(groundhogX > width - piece){ groundhogX = width - piece; }
    if(groundhogY < piece){ groundhogY = piece; }
      
      
    //soldier
    soldierY = initSoldierY + downMove; 
    soldierX += 2;
    if(soldierX > width){
      soldierX =- piece; 
    }
    image(soldier, soldierX, soldierY); 
    
    if (groundhogX < soldierX+piece && groundhogX+piece > soldierX 
    && groundhogY < soldierY+piece && groundhogY+piece > soldierY){
      playerHealth--;
      groundhogX = piece*4;
      groundhogY = piece;
      down = 0;
      left = 0;
      right = 0;
      downMove = 0;
      floorSpeed = 0;
    }
      

    //cabbage
    cabbageY = initCabbageY + downMove; 
    image(cabbage, cabbageX, cabbageY);
    if (groundhogX < cabbageX+piece && groundhogX+piece > cabbageX 
    && groundhogY < cabbageY+piece && groundhogY+piece > cabbageY){
      playerHealth++;
      cabbageX = width + piece;
      cabbageY = height + piece;
    }
    

		// Health UI
    for(int i=0; i<playerHealth; i++){
      image(life, lifeX+(lifeWidth+lifeSpacing)*i, lifeY);
    }
    if(playerHealth <= 0){
      gameState = GAME_OVER;
     }
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
        down = 0;
        left = 0;
        right = 0;
        floorSpeed = 0;
        downMove = 0;
        playerHealth = int(playerHealthDefault);
        cabbageX = floor(random(4))*piece;
        initCabbageY = piece*2 + floor(random(4))*piece;
        initCabbageY  = piece*2 + floor(random(4))*piece;
        groundhogX = piece*4;
        groundhogY = piece;
        image(groundhogIdle, groundhogX, groundhogY);
			}
		}else{
			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed() {
  if (down>0 || left>0 || right>0) {
    return;
  }
  if (key == CODED) {
    switch(keyCode) {
    case DOWN:
      if (groundhogY < 400) {
        downPressed = true;
        down = 15;
      }
      break;
    case LEFT:
      if (groundhogX > 0) {
        leftPressed = true;
        left = 15;
      }
      break;
    case RIGHT:
      if (groundhogX < 560) {
        rightPressed = true;
        right = 15;
      }
      break;
    }
  }

	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;
      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;
      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;
      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}
