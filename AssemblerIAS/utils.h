//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#ifndef UTILS_H
#define UTILS_H

#include <stdbool.h>

#include "tables.h"

// Converts a string correponding to a signed string
// to a number.
long long int strToNum(char * str);

// Converts a signed string to Hexadecimal 
// notation without the "0x" in the beginning
// of the string. Convets string that starts with
// "0x" - hex, "0o" - octal, "0b" - binary and decimal
// to hexadecimal notation
char * strToHex(char * addr);

// Converts a signed number to hexadecimal
char * numToHex(long long int num);

// Converts the address of the token t to string
char * addrToStr(struct labelTable * begin, struct token * t, struct labelTable **pos);

// Converts the addres of the token t to number
int addrToNum(struct labelTable * begin, struct token * t);

// Converts a string to a UPPER string
char * toUpper(char * str);

#endif
