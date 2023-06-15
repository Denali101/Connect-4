/*
Completed June 15, 2023 by Denali Tran-Le

This program is a visual game of Connect 4. Processing is used to display graphics and text onto a canvas.
2 player game; each player alternates dropping red and yellow discs onto a 6x7 grid until one makes a line of four of their own discs.
First to make a line of four discs is the winner. There is an option to replay or end the game.

*/
// Arrays
String[] file; // Text
String[] instructions; // Rules (Seperate file)
ArrayList<PVector> red_circles; // Coordinates of red discs
ArrayList<PVector> yellow_circles; // Coordinates of yellow discs
int[][] track = new int[6][7]; // Location of all discs as ints

// Dimensions and Coordinates
int circle_x = 150; // First circle x.pos
int circle_y = 140; // First circle y.pos
int circle_size = 50; // Circle size
int rect_x = 285; // Button x.pos
int rect_y = 290; // Button y.pos
int rect_w = 126; // Button width
int rect_h = 75; // Button height
int tri_y1y3 = 530; // Triangle (feet) bottom y.pos
int tri_y2 = 480; // Triangle (feet) tip y.pos
int row = 0; // Value for row of track array
int column = 0; // Value for column of track array
int x_cor = 0; // Store x-coordinate to place disc
int y_cor = 0; // Store y-coordinate to place disc

// Variables to determine which screen to draw
boolean start = true; // Start screen
boolean ruleset = false; // Rules screen
boolean play = false; // Game screen
boolean end = false; // End screen
boolean stop = false; // Terminates the game

// Checks which player has won
boolean red_win = false;
boolean yellow_win = false;

// Checks if cursor hovers over buttons
boolean over_start = false; // Start game button
boolean over_rules = false; // Rules button
boolean over_back = false; // Back to start screen button
boolean over_restart = false; // Play again button

boolean red_turn = true; // Swap between red and yellow turns

void setup() {
    size(700, 600);
    red_circles = new ArrayList<PVector>();
    yellow_circles = new ArrayList<PVector>();
    file = loadStrings("text.txt");
    instructions = loadStrings("rules.txt");
}

void draw() {
    if (start) {
        menu();
    } else if (ruleset) {
        rules();
    } else if (play) {
        background(200, 100);
        draw_board();
        fill_circle();
        if (check() == true) { // If a line of 4 discs is made
            play = false;
            end = true;
        }
    } else if (end) {
        credits();
    }
}

void button_check(int xpos, int ypos, int width, int height) { // Check if mouse is over the start button
    if (mouseX >= xpos && mouseX <= xpos + width && mouseY >= ypos
        && mouseY <= ypos + height) {
        if (start) {
            if (mouseY < 365 && mouseY > 290) {
                over_start = true;
            } else if (mouseY > 500 && mouseY < 575) {
                over_rules = true;
            }

        } else if (ruleset) {
            over_back = true;
        } else if (end) {
            if (mouseY < 340 && mouseY > 260) {
                over_restart = true;
            } else if (mouseY > 400 && mouseY < 475) {
                stop = true;
            }
        }
    } else {
        if (start) {
            if (mouseY > 500 && mouseY < 575) {
                over_start = false;
            } else if (mouseY < 365 && mouseY > 290) {
                over_rules = false;
            }
        } else if (ruleset) {
            over_back = false;
        } else if (end) {
            if (mouseY > 400 && mouseY < 475) {
                over_restart = false;
            } else if (mouseY < 340 && mouseY > 260) {
                stop = false;
            }
        }
    }
}

void menu() { // Start screen
    background(255);

    textSize(50); // "Connect 4"
    fill(0, 0, 255);
    text(file[0], 245, 200);

    textSize(35); // "2 Player Game"
    fill(0);
    text(file[1], 245, 260);

    fill(0, 255, 50, 50); // Start game button
    rect_y = 290;
    rect(rect_x, rect_y, rect_w, rect_h);
    button_check(rect_x, rect_y, rect_w, rect_h);
    textSize(30);
    fill(0);
    text(file[2], rect_x + 35, rect_y + 49); // "Play"

    fill(100, 80);
    rect(30, 500, rect_w, rect_h);
    textSize(30);
    fill(0);
    text(file[3], 30 + 27, 500 + 49); // "Rules"
    button_check(30, 500, rect_w, rect_h);
}

void rules() { // Rules and instructions
    background(255);
    textSize(20);
    fill(0, 0, 255);
    for (int i = 0; i < instructions.length; i++) {
        text(instructions[i], 30, 50 + (50 * i));
    }
    fill(100, 80);
    rect(540, 30, rect_w, rect_h);

    textSize(30);
    fill(0);
    text(file[4], 540 + 31, 30 + 49); // "Back"
    button_check(540, 30, rect_w, rect_h);
}

void draw_board() { // Draws all elements of the board
    stroke(0);
    fill(0, 0, 255, 170);
    rect(100, 100, 500, 400);
    for (int y = 0; y < 6; y++) { // row number
        for (int i = 0; i < 7; i++) { // column number
            fill(255, 255, 255);
            circle(circle_x + (67 * i), circle_y + (64 * y),
                circle_size); // draw circles
        }
    }
    fill(0, 0, 255);
    triangle(65, tri_y1y3, 100, tri_y2, 140, tri_y1y3);
    triangle(565, tri_y1y3, 600, tri_y2, 640, tri_y1y3);
    for (PVector disc : red_circles) { // Display red discs
        place_circle(disc, color(255, 0, 0));
    }
    for (PVector circle : yellow_circles) { // Display yellow discs
        place_circle(circle, color(255, 255, 0));
    }
}

void fill_circle() { // Highlights the top row of circles when mouse hovers over
    if (mouseY > 115 && mouseY < 170) { // If mouse is in the first row
        for (int i = 0; i < 7; i++) { // Loop through seven circles
            if (mouseX > 125 + (67 * i)
                && mouseX < 175 + (67 * i)) { // If mouse hovers over any circle
                if (red_turn) {
                    fill(255, 0, 0, 100);
                    circle(circle_x + (67 * i), circle_y,
                        circle_size); // draw coloured circles
                } else {
                    fill(255, 255, 0, 100);
                    circle(circle_x + (67 * i), circle_y,
                        circle_size); // draw coloured circles
                }
            }
        }
    }
}

void mousePressed() {
    if (start) {
        if (over_start) {
            play = true;
            start = false;
            ruleset = false;
            end = false;
        } else if (over_rules) {
            ruleset = true;
            start = false;
            play = false;
            end = false;
        }
    } else if (ruleset) {
        if (over_back) {
            start = true;
            play = false;
            ruleset = false;
            end = false;
        }
    } else if (play) {
        if (mouseY > 115 && mouseY < 170) { // If mouse is in the first row
            column = 0;
            x_cor = 0;
            for (int i = 0; i < 7; i++) { // Loop through seven circles
                if (mouseX > 125 + (67 * i)
                    && mouseX
                        < 175 + (67 * i)) { // If mouse hovers over any circle
                    column = i; // store which column was clicked on
                    x_cor = 67 * i; // x-coordinate for the disc
                    drop_disc(column, x_cor);
                    break;
                }
            }
        }
    } else if (end) {
        if (over_restart) {
            for (int i = 0; i < track.length; i++) {
                for (int j = 0; j < track[i].length; j++) {
                    track[i][j] = 0; // Reset track array (remove all 1s and 2s)
                }
            }
            red_circles.clear(); // Remove all red discs
            yellow_circles.clear(); // Remove all yellow discs
            red_win = false; // Reset
            yellow_win = false; // Reset
            start = true; // Go back to start screen
            ruleset = false; // Reset
            play = false; // Reset
            end = false; // Reset
            red_turn = true; // Red always goes first
        } else if (stop) {
            exit(); // Terminate the program
        }
    }
}

void drop_disc(int column, int x_cor) { // Places disc onto player grid and saves location into 6x7 array
    for (int p = track.length - 1; p >= 0; p--) {
        if (track[p][column] == 0) { // If slot is empty
            y_cor = circle_y + (64 * p); // y-coordinate for the disc
            row = p; // store which row disc will be placed
            PVector disc = new PVector(x_cor, y_cor); // Create a new disc with coordinates
            if (red_turn) {
                red_circles.add(disc); // adds red disc to be displayed
                track[row][column] = 1; // store red disc into 6x7 array
                red_turn = !red_turn; // switch between red and yellow turn
            } else {
                yellow_circles.add(disc); // adds yellow disc to be displayed
                track[row][column] = 2; // store yellow disc into array
                red_turn = !red_turn; // switch between red and yellow turn
            }
            break;
        } else if (track[p][column] == 1 && p == 0) { // If top row is full (red disc)
            break;
        } else if (track[p][column] == 2 && p == 0) { // If top row is full (yellow disc)
            break;
        }
    }
}

void place_circle(PVector pos, color c) { // Draws circles (sets it in place)
    fill(c);
    circle(circle_x + (pos.x), pos.y, circle_size);
}

void credits() {
    background(0);
    draw_board();
    textSize(40);
    if (red_win) {
        fill(255, 0, 0);
        text(file[5], 125, 70);
    } else if (yellow_win) {
        fill(255, 220, 0);
        text(file[6], 100, 70);
    }
    fill(255, 240); // White colour button
    rect_y = 260;
    rect(rect_x, rect_y, rect_w, rect_h); // Button rectangle
    fill(0); // Black text
    textSize(30);
    text(file[7], rect_x + 18, rect_y + 49); // Play again button
    button_check(rect_x, rect_y, rect_w, rect_h);

    fill(255, 20, 20, 240); // Red colour button
    rect(rect_x, 400, rect_w, rect_h); // Button rectangle
    fill(0); // BLack text
    textSize(30);
    text(file[8], rect_x + 33, 400 + 49); // End game button
    button_check(rect_x, 400, rect_w, rect_h);
}

boolean check() { // Check if line of four discs is made
    for (int col = 0; col < 7; col++) { // Vertical lines
        for (int row = 0; row < 3; row++) {
            if (track[row][col] == 1 && track[row + 1][col] == 1
                && track[row + 2][col] == 1 && track[row + 3][col] == 1) {
                red_win = true;
                return true;
            } else if (track[row][col] == 2 && track[row + 1][col] == 2
                && track[row + 2][col] == 2 && track[row + 3][col] == 2) {
                yellow_win = true;
                return true;
            }
        }
    }

    for (int row = 0; row < 6; row++) { // Horizontal lines
        for (int col = 0; col < 4; col++) {
            if (track[row][col] == 1 && track[row][col + 1] == 1
                && track[row][col + 2] == 1 && track[row][col + 3] == 1) {
                red_win = true;
                return true;
            } else if (track[row][col] == 2 && track[row][col + 1] == 2
                && track[row][col + 2] == 2 && track[row][col + 3] == 2) {
                yellow_win = true;
                return true;
            }
        }
    }

    for (int row = 0; row < 3;
         row++) { // Diagonal lines (top-left to bottom-right)
        for (int col = 0; col < 4; col++) {
            if (track[row][col] == 1 && track[row + 1][col + 1] == 1
                && track[row + 2][col + 2] == 1
                && track[row + 3][col + 3] == 1) {
                red_win = true;
                return true;
            } else if (track[row][col] == 2 && track[row + 1][col + 1] == 2
                && track[row + 2][col + 2] == 2
                && track[row + 3][col + 3] == 2) {
                yellow_win = true;
                return true;
            }
        }
    }

    for (int row = 3; row < 6;
         row++) { // Diagonal lines (bottom-left to top-right)
        for (int col = 0; col < 4; col++) {
            if (track[row][col] == 1 && track[row - 1][col + 1] == 1
                && track[row - 2][col + 2] == 1
                && track[row - 3][col + 3] == 1) {
                red_win = true;
                return true;
            } else if (track[row][col] == 2 && track[row - 1][col + 1] == 2
                && track[row - 2][col + 2] == 2
                && track[row - 3][col + 3] == 2) {
                yellow_win = true;
                return true;
            }
        }
    }
    return false;
}
