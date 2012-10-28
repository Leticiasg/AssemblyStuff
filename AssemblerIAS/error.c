//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#include <stdlib.h>
#include <stdio.h>

#include "error.h"

void ErrorDeal(enum error e, int line)
{
  #define CaseError(CODE) case CODE: printf("%s Error\n",#CODE); break;
  switch(e){
    CaseError(FileRead)
    CaseError(LinkedTokenError)
    CaseError(FillMemory)
    CaseError(ADDRError)
    CaseError(STRTONUM)
    CaseError(OPCODEError)
    CaseError(TableRow)
    CaseError(AlignError)
    case ParserError:
      printf("Parser Error in line %d\n", line);
      break;
    default:
      printf("Unknown error!\n");
  }
  exit(1);
}
