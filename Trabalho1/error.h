//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#ifndef ERROR_H
#define ERROR_H

enum error{
  FileRead, LinkedTokenError, ParserError,
  TableRow, FillMemory, ADDRError, STRTONUM,
  OPCODEError, AlignError
};

// Deals with error codes
void ErrorDeal(enum error, int line);

#endif 
