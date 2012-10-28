//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#include <stdio.h>
#include <stdlib.h>

#include "io.h"
#include "tokenizer.h"
#include "tables.h"
#include "interpreter.h"

int main(int argc, char * argv[])
{
  FILE * in = NULL;
  FILE * out = NULL;;
  struct linkedListToken * llt = NULL;;
  struct memoryMap * mm = NULL;;

  //Loads the source
  in = loadSource(argc, argv);
  
  //Opens the output file
  out = fopen(argv[2], "w");

  //Starts the linked list of tokens
  llt = startList();

  //Gets the tokens
  getTokens(in,llt);   

  //Take the first token away
  struct linkedListToken * trash = llt;
  llt = llt->next;
  free(trash);

  //Creates a new memory map
  mm = createMemoryMap();

  //Fill the memory map
  fillMemoryMap(out, llt, mm);

  //Print the Answer
  printSusyAnsw(mm, out);

  //Closes the files
  fclose(out);
  fclose(in);

  // Free the tokens used
  freeTokens(llt);

  // Free the memory map  
  freeMemoryMap(mm);

  return 0;
}
