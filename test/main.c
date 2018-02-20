/*
* @Author: noah
* @Date:   2018-02-19 12:50:25
* @Last Modified by:   Noah Huetter
* @Last Modified time: 2018-02-20 19:14:22
*/

#include <avr32/io.h>

int main(void) {
    AVR32_GPIO.port[3].gpers = 1 << 27;
    AVR32_GPIO.port[3].oders = 1 << 27;
    AVR32_GPIO.port[3].ovrs = 1 << 27;

    for (;;) {}

    return 0;
}