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

#include "tokenizer.h"
#include "error.h"

// Starts the linked list of tokens 
struct linkedListToken * startList()
{
  struct linkedListToken * lt = malloc(sizeof(struct linkedListToken));
  lt->next = NULL;
  lt->t = NULL;

  return lt;
}

// Adds the token t to the next element of the 
// linked list lt. Line is the line of the token in
// the text file, it is used to send the line of
// the error in case of LinkedTokenError
struct linkedListToken * addToken(struct linkedListToken * lt, struct token * t, int line)
{
  struct linkedListToken * llt = malloc(sizeof(struct linkedListToken));

  //If the linked list was not initiated yet
  if(lt == NULL){
    lt = llt;
    lt->next = NULL;
    lt->t = t;
  }
  //Else if you are on the right place of the linked list
  else if(lt->next == NULL){
    llt->next = NULL;
    llt->t = t;
    lt->next = llt;
  }
  else {
    ErrorDeal(LinkedTokenError, line);
  }

  return llt;
}

//Creates the token of the element x of M(x)
struct linkedListToken * getAddr(FILE * in, struct linkedListToken * end, int line)
{
  struct token * t = malloc(sizeof(struct token));
  char * word = malloc(sizeof(char)*MAX_OPERATION_SIZE);
  int i;

  fscanf(in, " %s", word);
  if(!strncmp(word, "M(", 2)){
    for(i=0; i < (strlen(word)-1); i++)
      word[i] = word[i+2];
    if(word[i-2] != ')')
      ErrorDeal(ParserError, line);
    word[i-2] = '\0';
  }
  else
    ErrorDeal(ParserError, line);
  
  t->attributes.string = word;
  t->type = ADDR;
  end = addToken(end, t, line);
  
  return end;
}

//Gets the directives aguments
struct linkedListToken * getDirArguments(FILE * in, struct linkedListToken * end, int line)
{
  struct token * t = malloc(sizeof(struct token));
  char * value = malloc(sizeof(char)*MAX_VALUE_SIZE);
  
  fscanf(in, " %s", value);
   
  if(value[strlen(value)-1] == ',')
    value[strlen(value)-1] = '\0';

  t->type = ADDR;
  t->attributes.string = value;
  end = addToken(end, t, line);

  return end;
}

// Constructs the linked list of tokens that represent
// the file in
struct linkedListToken * getTokens(FILE * in, struct linkedListToken * begin)
{
  char * word = malloc(sizeof(char)*MAX_OPERATION_SIZE);
  struct token * t = NULL;
  struct linkedListToken * end = begin;
  int line = 0;

  while(fscanf(in," %s",word) != EOF){
    //Atualizate the line numbers
    line++;
    //If commentary discad line
    if(!strncmp(word, "@", 1)){
      while(fgetc(in) != '\n');
    }
    else{
      t = malloc(sizeof(struct token));
      //IAS Commands
      if(!strcmp(word, "LOADMQ")){
        t->type = OP;
        t->attributes.needsAddress = false;
        t->tk.command = LOADMQ;
        end = addToken(end, t, line);
      }
      else if(!strcmp(word, "LOADMQMem")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = LOADMQMem;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "STOR")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = STOR;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "LOAD")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = LOAD;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "LOADNeg")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = LOADNeg;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "LOADMod")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = LOADMod;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "JUMP")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = JUMP;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "JUMPPos")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = JUMPplus;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "ADD")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = ADD;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "ADDMod")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = ADDMod;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "SUB")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = SUB;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "SUBMod")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = SUBMod;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "MUL")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = MUL;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "DIV")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = DIV;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      else if(!strcmp(word, "LSH")){
        t->type = OP;
        t->attributes.needsAddress = false;
        t->tk.command = LSH;
        end = addToken(end, t, line);
      }
      else if(!strcmp(word, "RSH")){
        t->type = OP;
        t->attributes.needsAddress = false;
        t->tk.command = RSH;
        end = addToken(end, t, line);
      }
      else if(!strcmp(word, "STORAddr")){
        t->type = OP;
        t->attributes.needsAddress = true;
        t->tk.command = STORAddr;
        end = addToken(end, t, line);
        end = getAddr(in, end, line);
      }
      //Directives
      else if(!strcmp(word, ".org")){
        t->type = Dir;
        t->attributes.string = ".org";
        t->tk.dir = ORG;
        end = addToken(end, t, line);
        end = getDirArguments(in, end, line);
      }
      else if(!strcmp(word, ".align")){
        t->type = Dir;
        t->attributes.string = ".align";
        t->tk.dir = ALIGN;
        end = addToken(end, t, line);
        end = getDirArguments(in, end, line);
      }
      else if(!strcmp(word, ".wfill")){
        t->type = Dir;
        t->attributes.string = ".wfill";
        t->tk.dir = WFILL;
        end = addToken(end, t, line);
        end = getDirArguments(in, end, line);
        end = getDirArguments(in, end, line);
      }
      else if(!strcmp(word, ".word")){
        t->type = Dir;
        t->attributes.string = ".word";
        t->tk.dir = WORD;
        end = addToken(end, t, line);
        end = getDirArguments(in, end, line);
      }
      else if(!strcmp(word, ".set")){
        t->type = Dir;
        t->attributes.string = ".set";
        t->tk.dir = SET;
        end = addToken(end, t, line);
        end = getDirArguments(in, end, line);
        end = getDirArguments(in, end, line);
      }
      else if(word[strlen(word)-1] == ':'){
        word[strlen(word)-1] = '\0';
        t->type = Dir;
        t->attributes.string = word;
        t->tk.dir = LABEL;
        end = addToken(end, t, line);
        end = getTokens(in, end);
        word = malloc(sizeof(char)*MAX_OPERATION_SIZE);
      }
      else
        ErrorDeal(ParserError, line);
    }
  }
  free(word);
  
  return end;
}

// Free the tokens used
void freeTokens(struct linkedListToken * llt)
{
  struct linkedListToken * aux = llt;

  while(aux != NULL){
    llt = aux;
    aux = aux->next;
    if(llt->t->type == OP || llt->t->type == Dir){
        free(llt->t);
        free(llt);
    }
    else{
        free(llt->t->attributes.string);
        free(llt->t);
        free(llt);
    }
  }
  return;
}
