# RAD180 — 180° Smart Radar and Intelligent Warning System

> An Arduino-based object detection and distance monitoring system using ultrasonic sensing, servo scanning, and real-time alerts.

![Arduino](https://img.shields.io/badge/Board-Arduino_Uno-00979D?logo=arduino&logoColor=white)
![Language](https://img.shields.io/badge/Language-C%2B%2B-00599C?logo=cplusplus&logoColor=white)
![Sensor](https://img.shields.io/badge/Sensor-HC--SR04-orange)
![Status](https://img.shields.io/badge/Status-In_Development-yellow)

---

## What Is This?

RAD180 is a sensor-based monitoring prototype designed to detect nearby objects across an area of approximately 180°. An HC-SR04 ultrasonic sensor mounted on an SG90 servo motor measures distances at different angles.

An Arduino Uno processes the measurements and controls an LCD, LEDs, and a buzzer to provide distance information and proximity warnings. A computer-based radar visualization is planned as an additional feature.

## Key Features

- **180° Scanning** — Rotates an ultrasonic sensor to observe a wider area.
- **Distance Measurement** — Measures the distance of nearby objects using ultrasonic waves.
- **Real-Time Alerts** — Uses a buzzer and LEDs to indicate proximity.
- **LCD Display** — Displays distance readings and warning status.
- **Radar Visualization** — Planned computer interface for displaying scan measurements.
- **Detection Logging** — Planned recording of angle, distance, and timestamp.

## Tech Stack

| Category | Technology |
|---|---|
| Microcontroller | Arduino Uno R3 |
| Programming | Arduino C/C++ |
| Distance Sensing | HC-SR04 Ultrasonic Sensor |
| Motor Control | SG90 Servo Motor |
| Display | 16×2 LCD with I2C |
| Circuit Design | Tinkercad Circuits |
| Version Control | Git and GitHub |

## Hardware Components

- Arduino Uno R3
- HC-SR04 ultrasonic sensor
- SG90 servo motor
- 16×2 LCD with I2C module
- Red and green LEDs
- Active buzzer
- Resistors, breadboard, and jumper wires
- USB cable and suitable power supply

## How It Works

1. The servo rotates the ultrasonic sensor across approximately 180°.
2. The sensor measures the distance to objects at different angles.
3. The Arduino processes the measurements and checks predefined distance thresholds.
4. The LCD displays the distance and corresponding status.
5. The LEDs and buzzer provide visual and audio warnings.
6. A computer can receive sensor readings through serial communication for radar visualization and detection logging.

## Project Structure

```text
RAD180/
│
├── README.md
├── arduino/
│   └── RAD180.ino
├── circuit/
│   └── circuit-diagram.png
└── docs/
    └── project-design.md
```

*This is the proposed structure. Add each file as it is created; the folders and files are not assumed to exist yet.*

## Getting Started

### Requirements

- Arduino IDE
- Arduino Uno R3
- Required hardware components
- USB cable
- Tinkercad account for circuit simulation, if needed

### Setup

1. Clone or download this repository.
2. Open `arduino/RAD180.ino` in the Arduino IDE once the code has been added.
3. Connect the components according to the circuit diagram.
4. Select **Arduino Uno** and the appropriate port in the Arduino IDE.
5. Upload the program and test the sensor, servo, LCD, LEDs, and buzzer.

**Note:** Setup and upload instructions will be finalized after the circuit and program have been implemented and tested.

## Project Status

**Current Stage:** Planning and Design

- [x] Project concept and objectives defined
- [x] Initial hardware and pin connections proposed
- [ ] Circuit simulation and verification
- [ ] Sensor and servo implementation
- [ ] LCD and alert integration
- [ ] Computer-based radar visualization
- [ ] Testing and documentation

## Limitations

- The system uses ultrasonic waves and is not a true radio-frequency radar.
- It measures distance but does not identify the type of object.
- Detection depends on the object's surface, orientation, and sensor conditions.
- A single ultrasonic sensor cannot reliably identify and track multiple moving objects.
- The standard Arduino Uno does not include built-in Wi-Fi.

## Contributors

- Pragun Lal Shrestha
- Unique Bhakta Shrestha
  
## License

No license has been selected yet. A license can be added once the project team decides how the code may be reused.

---

> **Disclaimer:** RAD180 is an educational prototype intended to demonstrate embedded systems, ultrasonic sensing, servo control, and proximity alerts. It is not a certified safety or security system.
