import processing.serial.*;

// =========================
// SERIAL / ARDUINO
// =========================
int DistanceUltra;
int IncomingDistance;

Serial myPort;
String DataIn;

// =========================
// GAME STATES
// =========================
boolean gameStarted = false;
boolean gameOver = false;

// evita salvar score infinitamente
boolean scoreUpdated = false;

// =========================
// PLAYER
// =========================
String currentPlayer = "";

// =========================
// PIPES
// =========================
Pipe p1 = new Pipe();
Pipe p2 = new Pipe();
Pipe p3 = new Pipe();

// =========================
// BIRD
// =========================
float birdy = 250;
float birdx = 80;

float gravity = 5;

int speed;

// =========================
// SCORE
// =========================
int score = 0;
int highscore = 0;
int point = 1;

// =========================
// LEADERBOARD
// =========================
String[] topNames = new String[5];
int[] topScores = new int[5];

// =========================
// COLORS
// =========================
color birdColor = color(255, 210, 0);

// =========================
// SETUP
// =========================
void setup() {

  size(450, 650);

  smooth(8);

  p1.x = width + 50;
  p2.x = width + 250;
  p3.x = width + 450;

  printArray(Serial.list());

  myPort = new Serial(this, Serial.list()[1], 9600);

  myPort.bufferUntil('\n');
}

// =========================
// SERIAL
// =========================
void serialEvent(Serial myPort) {

  DataIn = myPort.readString();

  if (DataIn != null) {

    DataIn = trim(DataIn);

    IncomingDistance = int(DataIn);

    if (
      IncomingDistance > 1 &&
      IncomingDistance < 100
      ) {

      DistanceUltra = IncomingDistance;
    }
  }
}

// =========================
// DRAW
// =========================
void draw() {

  drawBackground();

  drawClouds();

  drawGround();

  // =========================
  // MENU
  // =========================
  if (!gameStarted) {

    drawMenu();

    return;
  }

  // =========================
  // GAME
  // =========================
  p1.pipe();
  p2.pipe();
  p3.pipe();

  drawBird();

  drawHUD();

  play();

  success(p1);
  success(p2);
  success(p3);

  // =========================
  // CONTROLE ORIGINAL
  // =========================
  if (!gameOver) {

    if (IncomingDistance > 10) {

      birdy -= gravity;

    } else {

      birdy += gravity;
    }
  }

  birdy = constrain(birdy, 0, height - 70);
}

// =========================
// MENU
// =========================
void drawMenu() {

  fill(0, 120);

  rect(
    40,
    40,
    width - 80,
    height - 80,
    20
    );

  fill(255, 220, 0);

  textAlign(CENTER);

  textSize(38);

  text(
    "FLAPPY SENSOR",
    width/2,
    120
    );

  fill(255);

  textSize(16);

  text(
    "Controle usando a mão no sensor",
    width/2,
    160
    );

  // =========================
  // INPUT NOME
  // =========================
  fill(255);

  textSize(22);

  text(
    "Digite seu nome",
    width/2,
    230
    );

  // caixa
  fill(255, 220, 0);

  rect(
    width/2 - 110,
    250,
    220,
    50,
    12
    );

  fill(0);

  textSize(24);

  text(
    currentPlayer,
    width/2,
    283
    );

  // botão jogar
  fill(255, 220, 0);

  rect(
    width/2 - 110,
    330,
    220,
    55,
    15
    );

  fill(0);

  textSize(26);

  text(
    "JOGAR",
    width/2,
    365
    );

  // =========================
  // RANKING
  // =========================
  fill(255);

  textSize(24);

  text(
    "TOP PLAYERS",
    width/2,
    430
    );

  textSize(18);

  for (int i = 0; i < topScores.length; i++) {

    String n = topNames[i];

    if (n == null) {

      n = "---";
    }

    text(
      (i + 1) + ". " +
      n + " - " +
      topScores[i],

      width/2,
      470 + i * 30
      );
  }
}

// =========================
// BACKGROUND
// =========================
void drawBackground() {

  for (int i = 0; i < height; i++) {

    stroke(
      30,
      120 + i/5,
      220
      );

    line(0, i, width, i);
  }
}

// =========================
// CLOUDS
// =========================
void drawClouds() {

  noStroke();

  fill(255, 80);

  ellipse(100, 120, 80, 50);
  ellipse(140, 120, 70, 40);
  ellipse(70, 120, 60, 35);

  ellipse(320, 180, 90, 50);
  ellipse(360, 180, 70, 40);
  ellipse(290, 180, 60, 35);
}

// =========================
// GROUND
// =========================
void drawGround() {

  noStroke();

  fill(180, 120, 40);

  rect(0, height - 40, width, 40);

  fill(80, 200, 80);

  rect(0, height - 50, width, 12);
}

// =========================
// DRAW BIRD
// =========================
void drawBird() {

  pushMatrix();

  translate(birdx, birdy);

  // sombra
  fill(0, 40);

  ellipse(5, 5, 55, 55);

  // brilho
  fill(255, 240, 120, 60);

  ellipse(0, 0, 70, 70);

  // corpo
  fill(birdColor);

  ellipse(0, 0, 55, 55);

  // asa
  fill(255, 180, 0);

  ellipse(-10, 8, 22, 18);

  // olho
  fill(255);

  ellipse(10, -10, 14, 14);

  fill(0);

  ellipse(12, -10, 5, 5);

  // bico
  fill(255, 120, 0);

  triangle(
    20, 0,
    35, -5,
    35, 5
    );

  popMatrix();
}

// =========================
// HUD
// =========================
void drawHUD() {

  fill(255);

  textAlign(CENTER);

  textSize(42);

  text(score, width/2, 60);

  textSize(16);

  text(
    currentPlayer,
    width/2,
    95
    );
}

// =========================
// GAME LOGIC
// =========================
void play() {

  if (!gameOver) {

    speed = 3;

    p1.x -= speed;
    p2.x -= speed;
    p3.x -= speed;

  } else {

    speed = 0;

    // salva score UMA vez
    if (!scoreUpdated) {

      updatePlayerScore(
        currentPlayer,
        score
        );

      scoreUpdated = true;
    }

    fill(0, 180);

    rect(0, 0, width, height);

    fill(255);

    textAlign(CENTER);

    textSize(42);

    text(
      "GAME OVER",
      width/2,
      height/2 - 100
      );

    textSize(24);

    text(
      "Score: " + score,
      width/2,
      height/2 - 40
      );

    // =========================
    // BOTÃO REINICIAR
    // =========================
    fill(255, 220, 0);

    rect(
      width/2 - 110,
      height/2 + 30,
      220,
      55,
      15
      );

    fill(0);

    textSize(24);

    text(
      "REINICIAR",
      width/2,
      height/2 + 65
      );

    // =========================
    // BOTÃO MENU
    // =========================
    fill(255);

    rect(
      width/2 - 110,
      height/2 + 105,
      220,
      55,
      15
      );

    fill(0);

    text(
      "MENU",
      width/2,
      height/2 + 140
      );
  }
}

// =========================
// UPDATE SCORE
// =========================
void updatePlayerScore(
  String player,
  int newScore
  ) {

  // jogador já existe
  for (int i = 0; i < topNames.length; i++) {

    if (
      topNames[i] != null &&
      topNames[i].equals(player)
      ) {

      // atualiza apenas se for maior
      if (newScore > topScores[i]) {

        topScores[i] = newScore;
      }

      sortLeaderboard();

      return;
    }
  }

  // novo jogador
  for (int i = 0; i < topScores.length; i++) {

    if (newScore > topScores[i]) {

      for (
        int j = topScores.length - 1;
        j > i;
        j--
        ) {

        topScores[j] = topScores[j - 1];

        topNames[j] = topNames[j - 1];
      }

      topScores[i] = newScore;

      topNames[i] = player;

      break;
    }
  }
}

// =========================
// SORT
// =========================
void sortLeaderboard() {

  for (int i = 0; i < topScores.length; i++) {

    for (
      int j = i + 1;
      j < topScores.length;
      j++
      ) {

      if (topScores[j] > topScores[i]) {

        int tempScore = topScores[i];
        topScores[i] = topScores[j];
        topScores[j] = tempScore;

        String tempName = topNames[i];
        topNames[i] = topNames[j];
        topNames[j] = tempName;
      }
    }
  }
}

// =========================
// KEYBOARD
// =========================
void keyPressed() {

  // digitação apenas no menu
  if (!gameStarted) {

    // BACKSPACE
    if (
      key == BACKSPACE &&
      currentPlayer.length() > 0
      ) {

      currentPlayer =
        currentPlayer.substring(
          0,
          currentPlayer.length() - 1
          );
    }

    // letras
    else if (
      key != CODED &&
      key != ENTER &&
      key != RETURN &&
      currentPlayer.length() < 10
      ) {

      currentPlayer += key;
    }
  }
}

// =========================
// MOUSE
// =========================
void mousePressed() {

  // =========================
  // INICIAR JOGO
  // =========================
  if (!gameStarted) {

    if (
      mouseX > width/2 - 110 &&
      mouseX < width/2 + 110 &&
      mouseY > 330 &&
      mouseY < 385 &&
      currentPlayer.length() > 0
      ) {

      gameStarted = true;
    }
  }

  // =========================
  // GAME OVER
  // =========================
  else if (gameOver) {

    // reiniciar
    if (
      mouseX > width/2 - 110 &&
      mouseX < width/2 + 110 &&
      mouseY > height/2 + 30 &&
      mouseY < height/2 + 85
      ) {

      resetGame();
    }

    // menu
    if (
      mouseX > width/2 - 110 &&
      mouseX < width/2 + 110 &&
      mouseY > height/2 + 105 &&
      mouseY < height/2 + 160
      ) {

      backToMenu();
    }
  }
}

// =========================
// RESET
// =========================
void resetGame() {

  score = 0;

  gameOver = false;

  scoreUpdated = false;

  birdy = 250;

  p1.x = width + 50;
  p2.x = width + 250;
  p3.x = width + 450;
}

// =========================
// MENU
// =========================
void backToMenu() {

  gameStarted = false;

  gameOver = false;

  scoreUpdated = false;

  score = 0;

  birdy = 250;

  currentPlayer = "";

  p1.x = width + 50;
  p2.x = width + 250;
  p3.x = width + 450;
}

// =========================
// COLLISION
// =========================
void success(Pipe test) {

  if (
    birdx + 25 > test.x &&
    birdx - 25 < test.x + test.w
    ) {

    if (
      birdy - 25 < test.top ||
      birdy + 25 > height - test.bottom
      ) {

      gameOver = true;
    }
  }
}

// =========================
// PIPE CLASS
// =========================
class Pipe {

  float top;
  float bottom;

  float x = width + 150;

  float w = 80;

  // espaço entre pipes
  float gap;

  void generatePipe() {

    // =========================
    // DIFICULDADE DINÂMICA
    // =========================

    // primeiros pontos mais fáceis
    if (score < 5) {

      gap = 230;

    } else if (score < 10) {

      gap = 200;

    } else {

      gap = 170;
    }

    // =========================
    // LIMITES VISUAIS
    // =========================

    // evita pipe muito alto
    top = random(80, 280);

    // calcula bottom respeitando gap
    bottom =
      height - top - gap - 50;

    // evita pipe invadir chão
    bottom = constrain(
      bottom,
      80,
      260
      );
  }

  void pipe() {

    // gera pipe inicialmente
    if (top == 0 || bottom == 0) {

      generatePipe();
    }

    // sombra
    fill(0, 60);

    rect(x + 6, 6, w, top, 12);

    rect(
      x + 6,
      height-bottom + 6,
      w,
      bottom,
      12
      );

    // gradiente
    for (int i = 0; i < w; i++) {

      stroke(
        0,
        180 + i,
        90
        );

      line(x + i, 0, x + i, top);

      line(
        x + i,
        height-bottom,
        x + i,
        height
        );
    }

    noStroke();

    fill(0, 255, 140);

    // borda superior
    rect(
      x - 5,
      top - 18,
      w + 10,
      20,
      8
      );

    // borda inferior
    rect(
      x - 5,
      height-bottom,
      w + 10,
      20,
      8
      );

    // reciclar pipe
    if (x < -w) {

      score += point;

      x = width;

      generatePipe();
    }
  }
}
