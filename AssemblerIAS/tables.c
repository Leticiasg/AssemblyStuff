//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "error.h"
#include "tokenizer.h"
#include "tables.h"
#include "utils.h"

// Returns a new Table of labels
struct labelTable * newTable(void)
{
  struct labelTable * lt = malloc(sizeof(struct labelTable));
  lt->down = NULL;
  lt->row = NULL;

  return lt;
}

// Gets the address correponding to the label of
// name labelName in the label table lt. It puts the
// correponding struct found at pos
int getLabelNumAddr(char * labelName, struct labelTable * lt, struct labelTable **pos)
{
  while(lt != NULL && strcmp(labelName, lt->row->label)){
    lt = lt->down;
  }
  if(lt == NULL)
    ErrorDeal(TableRow, 0);
  if(pos != NULL)
    *pos = lt;  

  return lt->row->addr;
}

// Gets the string address correponding to the label of
// name labelName in the label table lt. It puts the
// correponding struct found at pos
char * getLabelStrAddr(char * labelName, struct labelTable * lt, struct labelTable **pos)
{
  int addr = getLabelNumAddr(labelName, lt, pos);

  return numToHex(addr);
}

// Adds the row to the next element of the string labelTable lt 
struct labelTable * addRowToTable(struct labelTable * lt, struct labelTableRow *ltr)
{
  if(lt->down != NULL)
    ErrorDeal(TableRow, 0);
  lt->down = newTable();
  lt = lt->down;
  lt->down = NULL;
  lt->row = ltr;

  return lt;
}

// Free label table
void freeLabelTable(struct labelTable * lt)
{
  struct labelTable * aux = lt->down;

  free(lt);
  while(aux != NULL){
    lt = aux;
    aux = aux->down;
    free(lt->row->label);
    free(lt->row);
    free(lt);
  }
  return;
} 

// Creates the IAS memory map
struct memoryMap * createMemoryMap(void)
{
  struct memoryMap * mm = malloc(sizeof(struct memoryMap)*MEMORY_MAP_SIZE);
  int i;

  for(i=0; i < MEMORY_MAP_SIZE; i++){
    mm[i].line = i;
    mm[i].command1 = NULL;
    mm[i].command2 = NULL;
    mm[i].isData = false;
  }

  return mm;
}

// Free the memory map
void freeMemoryMap(struct memoryMap * mm)
{
  int i;

  for(i=0; i < MEMORY_MAP_SIZE; i++){
    if(mm[i].command1 != NULL){
      free(mm[i].command1);
      i++;
      while( i < MEMORY_MAP_SIZE && mm[i].command1 == mm[i-1].command1)
        i++;
      i--;
    }
    if(mm[i].command2 != NULL)
      free(mm[i].command2);
  }
  free(mm);
}
