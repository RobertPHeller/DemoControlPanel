// -!- c++ -!- //////////////////////////////////////////////////////////////
//
//  System        : 
//  Module        : 
//  Object Name   : $RCSfile$
//  Revision      : $Revision$
//  Date          : $Date$
//  Author        : $Author$
//  Created By    : Robert Heller
//  Created       : Wed Jun 7 13:57:51 2023
//  Last Modified : <230608.1015>
//
//  Description	
//
//  Notes
//
//  History
//	
/////////////////////////////////////////////////////////////////////////////
//
//    Copyright (C) 2023  Robert Heller D/B/A Deepwoods Software
//			51 Locke Hill Road
//			Wendell, MA 01379-9728
//
//    This program is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//
// 
//
//////////////////////////////////////////////////////////////////////////////

#ifndef __HARDWARE_HXX
#define __HARDWARE_HXX

#include <os/LinuxGpio.hxx>
#include "utils/GpioInitializer.hxx"

#define HARDWARE_IMPL "BBB Demo Control Panel"

// On chip GPIO:
//
// LEDs
#define LEDPin GpioOutputSafeLow
                              // 64 Cable
                              // P9.03 => 1 (+3.3V)
                              // P9.04 => 2 (+3.3V)
GPIO_PIN(LED1,  LEDPin, 30);  // P9.11 => 3
GPIO_PIN(LED2,  LEDPin, 60);  // P9.12 => 4
GPIO_PIN(LED3,  LEDPin, 31);  // P9.13 => 5
GPIO_PIN(LED4,  LEDPin, 50);  // P9.14 => 6
GPIO_PIN(LED5,  LEDPin, 48);  // P9.15 => 7
GPIO_PIN(LED6,  LEDPin, 51);  // P9.16 => 8
GPIO_PIN(LED7,  LEDPin, 49);  // P9.23 => 9
GPIO_PIN(LED8,  LEDPin, 117); // P9.25 => 10
GPIO_PIN(LED9,  LEDPin, 115); // P9.27 => 11
GPIO_PIN(LED10, LEDPin, 113); // P9.28 => 12
GPIO_PIN(LED11, LEDPin, 112); // P9.30 => 13
GPIO_PIN(LED12, LEDPin, 110); // P9.31 => 14
GPIO_PIN(LED13, LEDPin, 71);  // P8.46 => 15
GPIO_PIN(LED14, LEDPin, 70);  // P8.45 => 16
GPIO_PIN(LED15, LEDPin, 73);  // P8.44 => 17
GPIO_PIN(LED16, LEDPin, 72);  // P8.43 => 18
GPIO_PIN(LED17, LEDPin, 75);  // P8.42 => 19
GPIO_PIN(LED18, LEDPin, 74);  // P8.41 => 20
GPIO_PIN(LED19, LEDPin, 77);  // P8.40 => 21
GPIO_PIN(LED20, LEDPin, 76);  // P8.39 => 22
GPIO_PIN(LED21, LEDPin, 79);  // P8.38 => 23

#define NUMLEDS 21

//
// Buttons
#define ButtonPin GpioInputActiveLow
GPIO_PIN(S15, ButtonPin, 78); // P8.37 => 42
GPIO_PIN(S16, ButtonPin, 80); // P8.36 => 43
GPIO_PIN(S17, ButtonPin, 8);  // P8.35 => 44
GPIO_PIN(S18, ButtonPin, 81); // P8.34 => 45
GPIO_PIN(S19, ButtonPin, 9);  // P8.33 => 46
GPIO_PIN(S20, ButtonPin, 11); // P8.32 => 47
GPIO_PIN(S21, ButtonPin, 10); // P8.31 => 48
GPIO_PIN(S8,  ButtonPin, 89); // P8.30 => 49
GPIO_PIN(S9,  ButtonPin, 87); // P8.29 => 50
GPIO_PIN(S10, ButtonPin, 88); // P8.28 => 51
GPIO_PIN(S11, ButtonPin, 86); // P8.27 => 52
GPIO_PIN(S12, ButtonPin, 61); // P8.26 => 53
GPIO_PIN(S13, ButtonPin, 22); // P8.19 => 54
GPIO_PIN(S14, ButtonPin, 65); // P8.18 => 55
GPIO_PIN(S1,  ButtonPin, 27); // P8.17 => 56
GPIO_PIN(S2,  ButtonPin, 46); // P8.16 => 57
GPIO_PIN(S3,  ButtonPin, 47); // P8.15 => 58
GPIO_PIN(S4,  ButtonPin, 26); // P8.14 => 59
GPIO_PIN(S5,  ButtonPin, 23); // P8.13 => 60
GPIO_PIN(S6,  ButtonPin, 44); // P8.12 => 61
GPIO_PIN(S7,  ButtonPin, 45); // P8.11 => 62
                              // P8.02 => 63 (GND)
                              // P8.01 => 64 (GND)

#define NUMBUTTONS 21


typedef GpioInitializer<LED1_Pin, LED2_Pin, LED3_Pin, LED4_Pin,
LED5_Pin, LED6_Pin, LED7_Pin, LED8_Pin, LED9_Pin, LED10_Pin, LED11_Pin,
LED12_Pin, LED13_Pin, LED14_Pin, LED15_Pin, LED16_Pin, LED17_Pin,
LED18_Pin, LED19_Pin, LED20_Pin,LED21_Pin,
S1_Pin, S2_Pin, S3_Pin, S4_Pin, S5_Pin, S6_Pin, S7_Pin, S8_Pin, S9_Pin,
S10_Pin, S11_Pin, S12_Pin, S13_Pin, S14_Pin, S15_Pin, S16_Pin, S17_Pin,
S18_Pin, S19_Pin, S20_Pin, S21_Pin> GpioInit;

#define USE_SOCKET_CAN_PORT
#define DEFAULT_CAN_SOCKET "can1"

//#define START_GCTCP_HUB
//#define DEFAULT_GRIDCONNECT_HUB_PORT 12021

#define USE_GRIDCONNECT_HOST
#define DEFAULT_TCP_GRIDCONNECT_PORT 12021
#define DEFAULT_TCP_GRIDCONNECT_HOST "localhost"

#endif // __HARDWARE_HXX

