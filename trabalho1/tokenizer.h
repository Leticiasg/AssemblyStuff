//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#ifndef TOKENIZER_H
#define TOKENIZER_H

#include <stdbool.h>
#include <stdio.h>

#define MAX_OPERATION_SIZE 50
#define MAX_VALUE_SIZE 50

struct token
{
  enum{
    OP, Dir, ADDR
  }type;

  union{
    enum{
    LOADMQ, LOADMQMem, STOR, LOAD, LOADNeg, LOADMod, JUMP,
    JUMPplus, ADD, ADDMod, SUB, SUBMod, MUL, DIV, LSH, RSH,
    STORAddr
    } command;
    enum{
      LABEL, WORD, ORG, ALIGN, WFILL, SET
    }dir;
  } tk;

  union{
    bool needsAddress;
    char * string;
  } attributes;
};

struct linkedListToken{
  struct token * t;
  struct linkedListToken * next;
};

// Constructs the linked list of tokens that represent
// the file in
struct linkedListToken * getTokens(FILE * in, struct linkedListToken * begin);

// Starts the linked list of tokens
struct linkedListToken * startList(void);

// Free the tokens used
void freeTokens(struct linkedListToken * llt);

#endif
