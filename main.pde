/*How to play:
You are a character who is stuck in space. You need to escape the different levels by first navigating to a star to obtain a key to open the black hole, and then jump into that black hole. There are various items that are to assist you on yor journey.
Bomb: explode the blue obstacle away from your path, by pressing [q]
Teleport: teleport to a random place in the game. Who knows, you have a 0.25% chance of teleporting to the exit! [e]
Pause: This pauses time in the game, allowing you to pass through all obstacles. Beware that pausing time will make all of the items dissapear!
Exit: This is the exit. Reach it to survive
Star: This is a checkpoint. You must visit it before proceeding to the exit
T: This is a toll wall. You must pay one money in order for it to go away.
Money: You can use this to open toll walls.
Space: This is the void of space. You navigate this

You lose if you end up getting stuck and cannot reach the exit. Save up on those bombs and monies!
There is no winning, you just need to survive for as long as possible.



*/

int n = 20; //How many rows/col there are.
int[][] world = new int[n][n];
float gridSize;
int SPACE = 0;
int WATER = 1;
int WALL = 2;
int EXIT = 3;
int BOMB = 99;
int PAUSE = 4;
int TELEPORT = 5;
int MONEY = 6;
int TOLLWALL = 7;
int CHECKPOINT = 8;
int level = 1;
int bombs = 0;
int teleporters=0;
int checked = 0;
int cash = 0;

float difficulty = 0.01;
boolean hasTeleported = false;
boolean death = false;
int randr=0;
int randc=0;

int r = 0;
int c = 0;

boolean time = true;

String playerURL = "https://www.scopeagency.co.za/wp-content/uploads/2014/04/Waving-astro-guy.png";
String bombURL = "https://freepngimg.com/thumb/machine/46464-2-bomb-free-transparent-image-hd.png";
String pauseURL = "https://png.pngtree.com/png-clipart/20190516/original/pngtree-pause-vector-icon-png-image_3791321.jpg";
String teleportURL = "https://i.dlpng.com/static/png/1381082_preview_preview.png";
String moneyURL = "https://images.vexels.com/media/users/3/143188/isolated/preview/5f44f3160a09b51b4fa4634ecdff62dd-money-icon-by-vexels.png";
String tollURL = "https://pngimage.net/wp-content/uploads/2018/06/letter-t-png-1.png";
String checkURL = "https://www.freeiconspng.com/uploads/yellow-christmas-star-png-18.png";
PImage teleport = loadImage(teleportURL);
PImage player = loadImage(playerURL);
PImage bombpic = loadImage(bombURL);
PImage pausepic = loadImage(pauseURL);
PImage money = loadImage(moneyURL);
PImage toll = loadImage(tollURL);
PImage checkpoint = loadImage(checkURL);
int playerR = 0;
int playerC = 0;

void setup() {
    size(800, 800);
    gridSize = width / n;
    generateWorld();
}

void draw() {
    displayWorld();
    displayPlayer();
    pickupBomb();
    pickupCash();
    pickupTeleport();
    freezeTime();
    fill(0, 0, 0);
    textSize(50);
    text("Bombs:" + bombs, 575, 35);
    text("Teleporters:"+ teleporters, 225, 35);
    text("Money:"+cash, 0, 35);
    if(death){
        text("Oops! You teleported into a wall.", 250, 0);
    }
    hasTeleported = false;
}
void displayPlayer() {
    float x = playerC * gridSize;
    float y = playerR * gridSize;
    image(player, x, y, gridSize, gridSize);

}
void generateWorld() {
    //Takes the world array and assigns tiles values randomly.
    time = true;
    for (int r = 0; r < world.length; r++) {
        for (int c = 0; c < world[r].length; c++) {
            float rng = random(0, 1);
            if (rng < difficulty) {
                world[r][c] = WATER;
            checked = 0;
            } else {
                world[r][c] = SPACE;
            }
            float bombdet = random(0, 1);
            if (bombdet < 0.01) {
                world[r][c] = BOMB;
            }
            float pausedet = random(0, 1);
            if (pausedet < 0.005) {
                world[r][c] = PAUSE;
            }
            float telepdet = random(0, 1);
            if (telepdet < 0.005) {
                world[r][c] = TELEPORT;
            }
            float moneydet = random(0,1);
            if ( moneydet < 0.005) {
                world[r][c] = MONEY;
            }
            float tollwalldet = random(0,1);
            if ( tollwalldet < 0.05){
                world[r][c] = TOLLWALL;
            }
            
            // } else {
            //     world[r][c] = SPACE;
            // }
            float walldet = random(0, 1);
            // float determinant=1/10;
            // if(walldet<0.1){
            //     world[r][c] = WALL;
            // }
        }
    }
    world[0][0] = SPACE;
    world[(int) random(world.length)][(int) random(world.length)] = EXIT;
    world[(int) random(world.length)][(int) random(world.length)] = CHECKPOINT;
}
void displayWorld() {
    if (time) {
        for (int r = 0; r < world.length; r++) {
            for (int c = 0; c < world[r].length; c++) {
                float x = c * gridSize;
                float y = r * gridSize;
                if (world[r][c] == SPACE) {
                    fill(0, 20, 0);
                }
                if (world[r][c] == WATER) {
                    fill(0, 100, 200);

                }
                if (world[r][c] == WALL) {
                    fill(100);
                }
                if (world[r][c] == EXIT) {
                    fill(0);
                }
                

                rect(x, y, gridSize, gridSize);
                if (world[r][c] == BOMB) {
                    image(bombpic, x, y, gridSize, gridSize);
                }
                if (world[r][c] == PAUSE) {
                    image(pausepic, x, y, gridSize, gridSize);
                }
                if (world[r][c] == TELEPORT) {
                    image(teleport, x, y, gridSize, gridSize);
                }
                if (world[r][c] == TOLLWALL) {
                    image(toll, x, y, gridSize, gridSize);
                }
                if (world[r][c] == MONEY) {
                    image(money, x, y, gridSize, gridSize);
                }
                if (world[r][c] == CHECKPOINT) {
                    image(checkpoint, x, y, gridSize, gridSize);
                }
            }
        }
    }
    else {
        for (int r = 0; r < world.length; r++) {
            for (int c = 0; c < world[r].length; c++) {
                float x = c * gridSize;
                float y = r * gridSize;
                if (world[r][c] == SPACE) {
                    fill(255);
                }
                if (world[r][c] == WATER) {
                    fill(200);

                }
                if (world[r][c] == WALL) {
                    fill(100);
                }
                if (world[r][c] == EXIT) {
                    fill(0);
                }

                rect(x, y, gridSize, gridSize);
                if (world[r][c] == BOMB) {
                    world[r][c] = SPACE;
                }
                if (world[r][c] == PAUSE) {
                    world[r][c] = SPACE;
                }
            }
        }
    }
}
void explode() {
    if (bombs > 0) {
        try {
            world[playerR][playerC] = SPACE;
        } catch(ArrayIndexOutOfBoundsException thisvardoesntmatter) {

}
        try {
            world[playerR - 1][playerC] = SPACE;
        } catch(ArrayIndexOutOfBoundsException thisvardoesntmatter) {

}
        try {
            world[playerR][playerC - 1] = SPACE;
        } catch(ArrayIndexOutOfBoundsException thisvardoesntmatter) {

}
        try {
            world[playerR + 1][playerC] = SPACE;
        } catch(ArrayIndexOutOfBoundsException thisvardoesntmatter) {

}
        try {
            world[playerR][playerC + 1] = SPACE;
        } catch(ArrayIndexOutOfBoundsException thisvardoesntmatter) {

}

        bombs -= 1;
    }
}

void keyPressed() {
    int oldR = playerR;
    int oldC = playerC;

    if (keyCode == UP) {
        playerR--;
    }
    if (keyCode == LEFT) {
        playerC--;
    }
    if (keyCode == DOWN) {
        playerR++;
    }
    if (keyCode == RIGHT) {
        playerC++;
    }
    if (key == 'q') {
        explode();
    }
    if (key == 'e'){
        teleport();
    }
    if (illegalMove()) {
        playerR = oldR;
        playerC = oldC;
    }
    if (nextLevel()) {
        difficulty += 0.05;
        generateWorld();
        playerR = 0;
        playerC = 0;
    }
}

boolean illegalMove() {
    //returns true if the player is in an illegal space, false otherwise
    if (playerR < 0 || playerR > n - 1 || playerC < 0 || playerC > n - 1) {
        return true;
    }
    if (time) {
        if (world[playerR][playerC] == WATER) {
            println("steeped in water");
            return true;
        }

        
    }
    if (world[playerR][playerC] == TOLLWALL){
        println("cash"+cash);
        if(cash==0){
            return true;
        }else{
            cash= cash-1;
            world[playerR][playerC] = SPACE;
            return false;
        }
    }
    return false;
    
}
void pickupBomb() {
    if (world[playerR][playerC] == BOMB) {
        world[playerR][playerC] = SPACE;
        bombs += 1;
    }
}
void freezeTime() {
    if (world[playerR][playerC] == PAUSE) {
        world[playerR][playerC] = SPACE;
        println("frozen time");
        time = false;
    }
}
void pickupCash() {
    if (world[playerR][playerC] == MONEY){
        world[playerR][playerC] = SPACE;
        cash+=1;
        println("awarded 1 money");
    }
}

void pickupTeleport() {
    if (world[playerR][playerC] == TELEPORT) {
        world[playerR][playerC] = SPACE;
        println("picked up teleporter");
        teleporters += 1;
        hasTeleported=false;
        
    }
}

void teleport(){
    
    if( random(0,1)<0.5){
        death=true;
        teleporters-=1;
    }
        while(!hasTeleported){
            randr=(int)random(1,20);
            randc=(int)random(1,20);
            if(world[randr][randc] != SPACE){
                teleport();
                println("teleport failed");
            }else{
                playerR=randr;
                playerC=randc;
                hasTeleported=true;
                teleporters-=1;
            }
        
    }
}

boolean nextLevel() {
    if (world[playerR][playerC] == CHECKPOINT) {
        checked = 1;

    }
    if(world[playerR][playerC] == EXIT){
        if(checked == 1){
        return true;
    }
    return false;
    }
    return false;
}
