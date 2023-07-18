// -!- C++ -!- //////////////////////////////////////////////////////////////
//
//  System        : 
//  Module        : 
//  Object Name   : $RCSfile$
//  Revision      : $Revision$
//  Date          : $Date$
//  Author        : $Author$
//  Created By    : Robert Heller
//  Created       : Tue Jul 18 13:53:21 2023
//  Last Modified : <230718.1427>
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

static const char rcsid[] = "@(#) : $Id$";

#include <ctype.h>
#include "os/os.h"
#include "nmranet_config.h"

#include "utils/logging.h"
#include "utils/GpioInitializer.hxx"
#include "freertos_drivers/common/DummyGPIO.hxx"
#include "freertos_drivers/common/LoggingGPIO.hxx"
#include "os/LinuxGpio.hxx"
#include "Hardware.hxx"

const Gpio *const kLEDs[] = {
    LED1_Pin::instance(), LED2_Pin::instance(), LED3_Pin::instance(), 
    LED4_Pin::instance(), LED5_Pin::instance(), LED6_Pin::instance(), 
    LED7_Pin::instance(), LED8_Pin::instance(), LED9_Pin::instance(), 
    LED10_Pin::instance(),LED11_Pin::instance(),LED12_Pin::instance(),
    LED13_Pin::instance(),LED14_Pin::instance(),LED15_Pin::instance(),
    LED16_Pin::instance(),LED17_Pin::instance(),LED18_Pin::instance(), 
    LED19_Pin::instance(),LED20_Pin::instance(),LED21_Pin::instance()
};

const Gpio *const kButtons[] = {
    S1_Pin::instance(),  S2_Pin::instance(),  S3_Pin::instance(), 
    S4_Pin::instance(),  S5_Pin::instance(),  S6_Pin::instance(), 
    S7_Pin::instance(),  S8_Pin::instance(),  S9_Pin::instance(),
    S10_Pin::instance(), S11_Pin::instance(), S12_Pin::instance(), 
    S13_Pin::instance(), S14_Pin::instance(), S15_Pin::instance(), 
    S16_Pin::instance(), S17_Pin::instance(), S18_Pin::instance(), 
    S19_Pin::instance(), S20_Pin::instance(), S21_Pin::instance()
};

/** Entry point to application.
 *  * @param argc number of command line arguments
 *  * @param argv array of command line arguments
 *  * @return 0, should never return
 *  */
int appl_main(int argc, char *argv[])
{
    uint8_t pressed[ARRAYSIZE(kButtons)];
    unsigned int iButton;
    
    // Initialize GPIO
    GpioInit::hw_init();
    
    // Flash each LED in sequence
    for (unsigned int iLed = 0; iLed < ARRAYSIZE(kLEDs); iLed++)
    {
        printf("Led %d\n",iLed);
        kLEDs[iLed]->set();
        usleep(500000);
        kLEDs[iLed]->clr();
        usleep(500000);
    }
    
    for (iButton = 0; iButton < ARRAYSIZE(kButtons); iButton++)
    {
        pressed[iButton] = 0;
    }
    while (true)
    {
        usleep(50000);
        for (iButton = 0; iButton < ARRAYSIZE(kButtons); iButton++)
        {
            if (kButtons[iButton]->is_clr()) pressed[iButton]++;
            else pressed[iButton] = 0;
            if (pressed[iButton] >= 3)
            {
                kLEDs[iButton]->set();
                printf("Button %d\n",iButton);
            }
            else
            {
                kLEDs[iButton]->clr();
            }
        }
    }
}

        
