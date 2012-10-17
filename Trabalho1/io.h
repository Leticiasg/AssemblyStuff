//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#ifndef IO_H
#define IO_H

#include "tables.h"

//Loads the Source and return the correspondent file
FILE * loadSource(int argc, char * argv[]);

// Prints the Memory map for the IAS
void printMemoryMap(struct memoryMap * mm, FILE * out);

// Prints the Susy answer
void printSusyAnsw(struct memoryMap * mm, FILE * out);
 
#endif
