//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#ifndef TABLES_H
#define TABLES_H

#define MEMORY_MAP_SIZE 1024

#include <stdbool.h>

#include "tokenizer.h"

struct labelTableRow
{
  char * label;
  int addr;
  bool isRight;
};

struct labelTable
{
  struct labelTableRow * row;
  struct labelTable * down;
};

struct memoryMap
{
  int line;
  char * command1;
  char * command2;
  bool isData;
};

// Gets the address correponding to the label of
// name labelName in the label table lt. It puts the
// correponding struct found at pos
int getLabelNumAddr(char * labelName, struct labelTable * lt, struct labelTable **pos);

// Gets the string address correponding to the label of
// name labelName in the label table lt. It puts the
// correponding struct found at pos
char * getLabelStrAddr(char * labelName, struct labelTable * lt, struct labelTable **pos);

// Creates the IAS memory map
struct memoryMap * createMemoryMap(void);

// Adds the row to the next element of the string labelTable lt 
struct labelTable * addRowToTable(struct labelTable * lt, struct labelTableRow *ltr);

// Returns a new table of labels
struct labelTable * newTable(void);

// Free label table
void freeLabelTable(struct labelTable * lt);

// Free the memory map
void freeMemoryMap(struct memoryMap * mm);

#endif
