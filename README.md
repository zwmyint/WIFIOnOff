# WIFIOnOff

[![Build Status](https://travis-ci.org/peastone/WIFIOnOff.svg?branch=master)](https://travis-ci.org/peastone/WIFIOnOff)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Motivation
This repository was inspired by the article ["Bastelfreundlich"](https://www.heise.de/ct/ausgabe/2018-2-Steckdose-mit-eingebautem-ESP8266-mit-eigener-Firmware-betreiben-3929796.html) by the German computer magazine "c't".
The article there is pretty much introductory. If you speak German and you have difficulties to get started, you can have a look there.

## Caution: Dragons ahead
The relay in the Sonoff S20 EU can only handle 10 A. Do NOT plug in devices with draw more current.
The maximum amount of current is also noted on the backside of the Sonoff S20 EU. It may differ in other variants sold, so have a look.

Never program the Sonoff S20, if it is connected to the mains. In Germany, that's 230 volts and you don't want to get an electric shock, which might even kill you.

That put ahead, go forward and be cautious!

## Flash it
1. Install Arduino IDE [(instructions)](https://www.arduino.cc/en/Guide/HomePage).
2. Install Arduino core for ESP8266 [(instructions)](https://github.com/esp8266/Arduino#installing-with-boards-manager).
3. Install the library [(instructions)](https://www.arduino.cc/en/Guide/Libraries#toc2) for [MQTT from Joël Gähwiler](https://github.com/256dpi/arduino-mqtt/).
4. Get yourself a FTDI-232-USB-TTL converter and some jumper wires.
5. Connect the FTDI to the Sonoff S20 (Pins from top to button: GND, TX, RX, 3.3V; Top is located right underneath the socket. Pin connection may vary for other variants or over time. You flash at your own risk.).
6. Build the software and flash it.

The whole procedure may also be done with [PlatformIO](https://platformio.org/). It should be easy to find out the analogous steps for yourself. A platformio.ini is provided but must be adapted.

![Image of Sonoff S20 and Sonoff Basic without housing](/img/sonoff_pinout.png)
["Sonoff Pinout"](https://github.com/ct-Open-Source/info-graphics/blob/master/sonoff_pinbelegung.png) by [ct-Open-Source](https://github.com/ct-Open-Source) licensed under [CC Attribution Share Alike 4.0 International](https://github.com/ct-Open-Source/info-graphics/blob/master/LICENSE.md).

## Use it
1. Close the Sonoff S20. BE cautious! The device MUST be absolutely closed. You are working at your own risk here. If the device is open, you risk getting an electric shock or worse. If in doubt, ask an expert!
2. Plug the Sonoff S20 into the mains.
3. The LED will light green. An access point with the name "WIFIOnOff" will be started. Connect your mobile device and follow the captive portal. There you can enter your WiFi credentials or use WPS.
4. Find the device with an mDNS mobile phone app.
5. Open the web interface by entering the mDNS name into your browser.
6. Configure MQTT, if wanted.
7. Enjoy the web interface, MQTT and the physical button. Toggle the relay.

## Documentation
Please read the manual([HTML](https://peastone.github.io/WIFIOnOff/), [PDF](https://peastone.github.io/WIFIOnOff/refman.pdf)). It is pretty detailed and should answer most of your questions. Only the latest version is provided. All versions can be generated with [Doxygen](https://www.stack.nl/~dimitri/doxygen/).

