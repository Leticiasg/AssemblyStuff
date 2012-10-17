//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#include <stdio.h>
#include <string.h>

#include "error.h"
#include "tables.h"

//Loads the Source and return the correspondent file
FILE * loadSource(int argc, char * argv[])
{
  FILE * in = NULL;
  int sourceSize = 0;

  //If the arguments were right
  if(argc != 3)
    ErrorDeal(FileRead, 0);
  
  //Load the Source
  in = fopen(argv[1], "r");
  if(in != NULL){
    fseek(in, 0, SEEK_END);
    sourceSize = ftell(in);
    sourceSize -= 1;
    if(sourceSize == 0)
      ErrorDeal(FileRead, 0);
  }
  else
    ErrorDeal(FileRead, 0);
  
  // Return to the begging of the file
  rewind(in);
  
  return in;
}

// Prints the the row of the memory Map if it 
// is data
void printData(char * str, FILE * out)
{
  int i;

  for(i=0; i < strlen(str)-1; i+=2){
    fprintf(out,"%c%c ",str[i],str[i+1]);
  } 
  fputc('\n', out);
  
  return;
}

// Prints the memory Map for the IAS 
void printMemoryMap(struct memoryMap * mm, FILE * out)
{
  int i;

  for(i=0; i < MEMORY_MAP_SIZE; i++){
    fprintf(out, "%03x ", i);
    if(mm[i].isData)
      printData(mm[i].command1, out);
    else if(mm[i].command1 == NULL)
      fprintf(out, "00 00 00 00 00\n");
    else{
      if(mm[i].command2 != NULL)
        fprintf(out, "%s %s\n", mm[i].command1, mm[i].command2);
      else
        fprintf(out, "%s 00000\n", mm[i].command1);
    }
  }
  return;
}

// Prints the Susy Answer
void printSusyAnsw(struct memoryMap * mm, FILE * out)
{
  int i;

  for(i=0; i < MEMORY_MAP_SIZE; i++){
    if(mm[i].command1 != NULL){
      fprintf(out, "%03X ", i);
      if(mm[i].isData)
        fprintf(out, "%s\n", mm[i].command1);
      else if(mm[i].command2 != NULL)
        fprintf(out, "%s%s\n",mm[i].command1, mm[i].command2);
      else
        fprintf(out, "%s00000\n", mm[i].command1);
    }
  }
  return;
}
