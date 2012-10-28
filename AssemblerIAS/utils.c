//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "tables.h"
#include "error.h"
#include "tokenizer.h"
#include "utils.h"

// Returns the result of the pow function
// of base ^ exp
long long int POW(int base, int exp)
{
  long long int num;
  short int i;
  num = 1;

  for(i=0; i < exp; i++){
    num *= base;
  }

  return num;
}

// Converts a signed number to hexadecimal
char * numToHex(long long int num)
{
  char * hex = malloc(sizeof(char) * 11);
  int cont = 9;
  int mask = 0xF;
  int digit = 0;

  while(cont >= 0){
    digit = num & mask;
    if(digit >= 0x0 && digit <= 0x9)
      hex[cont] = '0' + digit;
    else
      hex[cont] = 'A' + digit - 10;
    cont--;
    num = num >> 4;
  }
  hex[10] = '\0';

  return hex;
}

// Converts a signed string to Hexadecimal 
// notation without the "0x" in the beginning
// of the string. Convets string that starts with
// "0x" - hex, "0o" - octal, "0b" - binary and decimal
// to hexadecimal notation
char * strToHex(char * addr)
{
  long long int num = strToNum(addr);
  char * hex = malloc(sizeof(char) * 11);
  int cont = 9;
  int mask = 0xF;
  int digit = 0;

  while(cont >= 0){
    digit = num & mask;
    if(digit >= 0x0 && digit <= 0x9)
      hex[cont] = '0' + digit;
    else
      hex[cont] = 'A' + digit - 10;
    cont--;
    num = num >> 4;
  }
  hex[10] = '\0';

  return hex;
}

// Converts a string correponding to a signed string
// to a number.
long long int strToNum(char * str)
{
  int base = 10;
  int nchar = 0;
  bool sign = false;

  //if the string is negative
  if(str[0] == '-'){
    str += 1;
    sign = true;
  }

  //if string is in hex
  if(!strncmp(str, "0x", 2)){
    base = 16;
  }
  //if string is in octal
  else if(!strncmp(str, "0o", 2)){
    base = 8;
    nchar = 2;
  }
  //if string is in binary
  else if(!strncmp(str, "0b", 2)){
    base = 2;
    nchar = 2;
  }

  str += nchar;

  if(sign)
    return -strtoll(str, NULL, base);
  return strtoll(str, NULL, base);
}

// Converts the address of the token t to a string
char * addrToStr(struct labelTable * begin, struct token * t, struct labelTable **pos)
{
  if(t->type != ADDR)
    ErrorDeal(LinkedTokenError, 0);
  //If the string is an number
  else if(isdigit(t->attributes.string[0]) || t->attributes.string[0] == '-')
    return strToHex(t->attributes.string);
  //If the string is an label
  else
    return getLabelStrAddr(t->attributes.string, begin->down, pos);

  return " ";
}

// Converts the address of the token t to a number
int addrToNum(struct labelTable * begin, struct token * t)
{
  if(t->type != ADDR)
    ErrorDeal(LinkedTokenError, 0);
  //If the string is a number
  else if(isdigit(t->attributes.string[0]) || t->attributes.string[0] == '-')
    return strToNum(t->attributes.string);
  //If the string is a label
  else
    return getLabelNumAddr(t->attributes.string, begin->down, NULL);

  return -1;
}

// Converts a string to a UPPER string
char * toUpper(char * str)
{
  int i;

  for(i=0; str[i] != '\0'; i++)
    str[i] = toupper(str[i]);

  return str;
}
