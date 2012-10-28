//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#ifndef INTERPRETER_H
#define INTERPRETER_H

struct position
{
  int addr;
  bool isRight;
};

// Fills the memory map with the right values
void fillMemoryMap(FILE * out, struct linkedListToken * llt, struct memoryMap * mm);

#endif
