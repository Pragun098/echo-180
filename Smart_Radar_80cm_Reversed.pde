
import processing.serial.*;

// ======================================
// ADVANCED TACTICAL SMART RADAR
// Arduino UNO + HC-SR04 + SG90
// Maximum display range: 80 cm
// ======================================

Serial arduino;

// CONFIGURATION
final int MAX_DISTANCE = 80;
final int RADAR_RADIUS = 360;

final int DANGER_LIMIT = 10;
final int WARNING_LIMIT = 20;

// SERIAL DATA
int radarAngle = 90;
float radarDistance = -1;

int previousAngle = 90;
int sweepDirection = 1;

// RADAR DATA
float[] distances = new float[181];
int[] lastSeen = new int[181];

int totalDetections = 0;

// DISPLAY
int centerX = 470;
int centerY = 665;

PFont titleFont;
PFont mainFont;
PFont smallFont;

boolean connected = false;

// COLORS
color greenColor = color(0, 255, 130);
color redColor = color(255, 35, 35);
color orangeColor = color(255, 170, 20);

// ======================================
// SETUP
// ======================================

void setup() {

  size(1250, 850);
  smooth(8);

  titleFont = createFont("Arial Bold", 27);
  mainFont = createFont("Arial Bold", 19);
  smallFont = createFont("Arial", 13);

  for (int i = 0; i <= 180; i++) {
    distances[i] = -1;
    lastSeen[i] = -10000;
  }

  println("AVAILABLE SERIAL PORTS:");
  println(Serial.list());

  try {
    arduino = new Serial(this, "COM10", 9600);
    arduino.bufferUntil('\n');
    connected = true;
  }
  catch(Exception e) {
    println("Could not open COM10: " + e.getMessage());
    connected = false;
  }
}

// ======================================
// MAIN DRAW
// ======================================

void draw() {

  boolean danger = isDanger();

  if (danger) {
    // Alternate between dark red and bright red
    if ((millis() / 250) % 2 == 0) {
      background(75, 0, 0);
    } else {
      background(15, 0, 0);
    }
  } else {
    background(2, 10, 14);
  }

  drawHeader(danger);
  drawRadarBackground(danger);
  drawRangeRings(danger);
  drawAngleLines(danger);
  drawTargetHistory(danger);
  drawRadarSweep(danger);
  drawCurrentTarget(danger);
  drawRadarCenter(danger);
  drawInformationPanel(danger);
  drawAlarmBanner(danger);
  drawFooter(danger);

  if (danger) {
    drawDangerBorder();
  }
}

// ======================================
// THREAT DETECTION
// ======================================

boolean isDanger() {
  return radarDistance >= 2 &&
         radarDistance <= DANGER_LIMIT;
}

boolean isWarning() {
  return radarDistance > DANGER_LIMIT &&
         radarDistance <= WARNING_LIMIT;
}

// ======================================
// HEADER
// ======================================

void drawHeader(boolean danger) {

  fill(danger ? redColor : greenColor);
  textFont(titleFont);
  textAlign(CENTER);

  text("TACTICAL SMART RADAR SYSTEM", width/2, 39);

  fill(150, 210, 190);
  textFont(smallFont);

  text("REAL-TIME ULTRASONIC SURVEILLANCE",
       width/2, 65);

  stroke(danger ? redColor : color(0, 130, 75));
  strokeWeight(2);
  line(25, 85, 1225, 85);

  textAlign(LEFT);
  fill(danger ? redColor : greenColor);

  text("SYSTEM STATUS", 30, 116);

  fill(connected ? greenColor : redColor);

  text(connected ? "ONLINE" : "DISCONNECTED",
       145, 116);

  textAlign(RIGHT);
  fill(danger ? redColor : greenColor);

  text(danger ? "!! SECURITY ALERT !!" :
       "SCANNING ACTIVE", 1215, 116);
}

// ======================================
// RADAR BACKGROUND
// ======================================

void drawRadarBackground(boolean danger) {

  noStroke();

  fill(danger ? color(65, 0, 0) :
       color(0, 30, 20));

  arc(centerX, centerY,
      RADAR_RADIUS*2, RADAR_RADIUS*2,
      PI, TWO_PI);

  stroke(danger ? color(180, 20, 20) :
         color(0, 75, 45));

  noFill();

  arc(centerX, centerY,
      RADAR_RADIUS*2, RADAR_RADIUS*2,
      PI, TWO_PI);
}

// ======================================
// RANGE RINGS
// ======================================

void drawRangeRings(boolean danger) {

  for (int d = 20; d <= MAX_DISTANCE; d += 20) {

    float r = map(d, 0, MAX_DISTANCE,
                  0, RADAR_RADIUS);

    stroke(danger ? color(180, 35, 35) :
           color(0, 115, 65));

    strokeWeight(1);
    noFill();

    arc(centerX, centerY,
        r*2, r*2, PI, TWO_PI);

    fill(danger ? redColor : greenColor);
    noStroke();

    textFont(smallFont);
    textAlign(CENTER);

    text(d + " CM", centerX, centerY-r-6);
  }
}

// ======================================
// ANGLE GRID
// ======================================

void drawAngleLines(boolean danger) {

  for (int a = 0; a <= 180; a += 15) {

    float x = centerX -
              RADAR_RADIUS*cos(radians(a));

    float y = centerY -
              RADAR_RADIUS*sin(radians(a));

    stroke(danger ? color(130, 20, 20) :
           color(0, 75, 45));

    line(centerX, centerY, x, y);

    fill(danger ? redColor : greenColor);
    noStroke();

    float tx = centerX -
               (RADAR_RADIUS+25)*cos(radians(a));

    float ty = centerY -
               (RADAR_RADIUS+25)*sin(radians(a));

    textAlign(CENTER);
    textFont(smallFont);

    text(a + "°", tx, ty);
  }

  stroke(danger ? redColor : greenColor);

  line(centerX-RADAR_RADIUS, centerY,
       centerX+RADAR_RADIUS, centerY);
}

// ======================================
// TARGET HISTORY
// ======================================

void drawTargetHistory(boolean danger) {

  for (int a = 0; a <= 180; a++) {

    float d = distances[a];

    int age = millis() - lastSeen[a];

    if (d >= 2 && d <= MAX_DISTANCE &&
        age < 15000) {

      float r = map(d, 0, MAX_DISTANCE,
                    0, RADAR_RADIUS);

      float x = centerX-r*cos(radians(a));
      float y = centerY-r*sin(radians(a));

      float opacity = map(age, 0, 15000, 255, 20);

      noStroke();

      fill(255, 30, 30, opacity);
      circle(x, y, 18);

      fill(255, 120, 70, opacity);
      circle(x, y, 7);

      fill(255, 180, 130, opacity);

      textAlign(LEFT);
      textFont(smallFont);

      text(nf(d, 0, 0) + "cm",
           x+12, y-9);
    }
  }
}

// ======================================
// RADAR SWEEP
// ======================================

void drawRadarSweep(boolean danger) {

  // Animated beam trail
  for (int i = 7; i >= 0; i--) {

    float a = radarAngle - sweepDirection*i*2;

    if (a >= 0 && a <= 180) {

      float x = centerX -
                RADAR_RADIUS*cos(radians(a));

      float y = centerY -
                RADAR_RADIUS*sin(radians(a));

      stroke(danger ? color(255, 50, 30, 120-i*12) :
             color(0, 255, 120, 120-i*12));

      strokeWeight(9-i);

      line(centerX, centerY, x, y);
    }
  }

  float x = centerX -
            RADAR_RADIUS*cos(radians(radarAngle));

  float y = centerY -
            RADAR_RADIUS*sin(radians(radarAngle));

  stroke(danger ? redColor : greenColor);
  strokeWeight(3);

  line(centerX, centerY, x, y);
}

// ======================================
// CURRENT OBJECT
// ======================================

void drawCurrentTarget(boolean danger) {

  if (radarDistance >= 2 &&
      radarDistance <= MAX_DISTANCE) {

    float r = map(radarDistance, 0,
                  MAX_DISTANCE, 0, RADAR_RADIUS);

    float x = centerX -
              r*cos(radians(radarAngle));

    float y = centerY -
              r*sin(radians(radarAngle));

    noFill();

    stroke(danger ? redColor : orangeColor);
    strokeWeight(3);

    circle(x, y, 32);

    noStroke();

    fill(danger ? redColor : orangeColor);
    circle(x, y, 12);

    fill(255);
    textAlign(CENTER);
    textFont(smallFont);

    text(nf(radarDistance, 0, 1) + " cm",
         x, y-25);
  }
}

// ======================================
// RADAR CENTER
// ======================================

void drawRadarCenter(boolean danger) {

  noStroke();

  fill(danger ? redColor : greenColor);
  circle(centerX, centerY, 23);

  fill(255);
  circle(centerX, centerY, 8);
}

// ======================================
// INFORMATION PANEL
// ======================================

void drawInformationPanel(boolean danger) {

  int px = 850;
  int py = 165;

  fill(danger ? color(35, 0, 0) :
       color(5, 25, 25));

  stroke(danger ? redColor : color(0, 150, 80));
  strokeWeight(2);

  rect(px, py, 350, 425, 10);

  fill(danger ? redColor : greenColor);

  textFont(mainFont);
  textAlign(LEFT);

  text("TARGET INTELLIGENCE", px+20, py+35);

  stroke(danger ? redColor : color(0, 100, 60));

  line(px+15, py+50, px+335, py+50);

  drawPanelValue("SERVO ANGLE",
                 radarAngle + " DEG",
                 px+20, py+95, danger);

  String distanceText =
    radarDistance >= 2 ?
    nf(radarDistance, 0, 1) + " CM" :
    "NO OBJECT";

  drawPanelValue("OBJECT DISTANCE",
                 distanceText,
                 px+20, py+170, danger);

  String threat;

  if (isDanger()) {
    threat = "DANGER";
  } else if (isWarning()) {
    threat = "WARNING";
  } else if (radarDistance > WARNING_LIMIT) {
    threat = "SAFE";
  } else {
    threat = "NO TARGET";
  }

  color threatColor = isDanger() ? redColor :
                      isWarning() ? orangeColor :
                      greenColor;

  fill(160, 210, 190);
  textFont(smallFont);

  text("THREAT CLASSIFICATION",
       px+20, py+230);

  fill(threatColor);
  textFont(mainFont);

  text(threat, px+20, py+265);

  stroke(danger ? redColor : color(0, 100, 60));

  line(px+15, py+285, px+335, py+285);

  fill(160, 210, 190);
  textFont(smallFont);

  text("DETECTION RECORDS",
       px+20, py+320);

  fill(danger ? redColor : greenColor);
  textFont(mainFont);

  text(totalDetections,
       px+20, py+355);

  fill(160, 210, 190);
  textFont(smallFont);

  text("MAXIMUM RANGE: 80 CM",
       px+20, py+390);
}

void drawPanelValue(String label,
                    String value,
                    int x, int y,
                    boolean danger) {

  fill(160, 210, 190);
  textFont(smallFont);

  text(label, x, y);

  fill(danger ? redColor : greenColor);
  textFont(mainFont);

  text(value, x, y+30);
}

// ======================================
// DANGER ALARM BANNER
// ======================================

void drawAlarmBanner(boolean danger) {

  if (danger) {

    fill(255, 0, 0, 210);
    noStroke();

    rect(850, 620, 350, 80, 8);

    fill(255);
    textAlign(CENTER);

    textFont(mainFont);

    text("!! DANGER DETECTED !!",
         1025, 650);

    textFont(smallFont);

    text("OBJECT WITHIN 10 CM",
         1025, 680);

  } else if (isWarning()) {

    fill(120, 65, 0);
    noStroke();

    rect(850, 620, 350, 80, 8);

    fill(255, 210, 80);
    textAlign(CENTER);

    textFont(mainFont);

    text("WARNING DETECTED",
         1025, 665);
  }
}

// ======================================
// RED DANGER BORDER
// ======================================

void drawDangerBorder() {

  if ((millis()/250)%2 == 0) {

    noFill();

    stroke(255, 0, 0);
    strokeWeight(9);

    rect(5, 5, width-10, height-10, 8);

    fill(255, 0, 0, 35);
    noStroke();

    rect(0, 0, width, height);
  }
}

// ======================================
// FOOTER
// ======================================

void drawFooter(boolean danger) {

  stroke(danger ? redColor : color(0, 130, 75));

  line(25, 805, 1225, 805);

  fill(danger ? redColor : greenColor);

  textFont(smallFont);
  textAlign(LEFT);

  text("ARDUINO UNO R3 | HC-SR04 | SG90 SERVO",
       30, 830);

  textAlign(RIGHT);

  text("RADAR RANGE: 80 CM",
       1215, 830);
}

// ======================================
// SERIAL COMMUNICATION
// ======================================

void serialEvent(Serial arduino) {

  String data = arduino.readStringUntil('\n');

  if (data == null) return;

  data = trim(data);

  String[] values = split(data, ',');

  if (values.length == 2) {

    try {

      int angle = int(values[0]);
      float distance = float(values[1]);

      // Reverse the displayed angle because the sensor is mounted upside down.
      angle = 180 - angle;

      if (angle >= 0 && angle <= 180) {

        previousAngle = radarAngle;
        radarAngle = angle;

        if (angle > previousAngle) {
          sweepDirection = 1;
        } else if (angle < previousAngle) {
          sweepDirection = -1;
        }

        radarDistance = distance;

        if (distance >= 2 &&
            distance <= MAX_DISTANCE) {

          distances[angle] = distance;
          lastSeen[angle] = millis();

          totalDetections++;
        }
      }
    }

    catch(Exception e) {
      println("Invalid serial data: " + data);
    }
  }
}
