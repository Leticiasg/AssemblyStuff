//--------------------------------//
//                                //
//  Author: Tiago Lobato Gimenes  //
//                                //
//  contact: tlgimenes@gmail.com  //
//                                //
//--------------------------------//

#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "error.h"
#include "tokenizer.h"
#include "tables.h"
#include "utils.h"
#include "interpreter.h"

// Returns the operation code for this implementation
// of the IAS
char * getOPCode(struct token * t)
{
  char * op = malloc(sizeof(char) * 3);
  switch(t->tk.command){
    case LOADMQ: strcpy(op, "0A"); break;
    case LOADMQMem: strcpy(op, "09"); break;
    case STOR: strcpy(op, "21"); break;
    case LOAD: strcpy(op, "01"); break;
    case LOADNeg: strcpy(op, "02"); break;
    case LOADMod: strcpy(op, "03"); break;
    case JUMP: ErrorDeal(FillMemory, 0);
    case JUMPplus: ErrorDeal(FillMemory, 0);
    case ADD: strcpy(op, "05"); break;
    case ADDMod: strcpy(op, "07"); break;
    case SUB: strcpy(op, "06"); break;
    case SUBMod: strcpy(op, "08"); break;
    case MUL: strcpy(op, "0B"); break;
    case DIV: strcpy(op, "0C"); break;
    case LSH: strcpy(op, "14"); break;
    case RSH: strcpy(op, "15"); break;
    case STORAddr: ErrorDeal(FillMemory, 0);
    default:
      ErrorDeal(FillMemory,0);
  }
  return op;
}

// Gets the left op code for this implementation
// of the IAS
char * getLeftOPCode(struct token * t)
{
  char * op = malloc(sizeof(char) * 3);
  
  switch(t->tk.command){
    case JUMP: strcpy(op, "0D"); break;
    case JUMPplus: strcpy(op, "0F"); break;
    case STORAddr: strcpy(op, "12"); break;
    default:
      ErrorDeal(OPCODEError, 0);
  }
  return op;
}

// Gets the right op code for this implementation
// of the IAS
char * getRightOPCode(struct token * t)
{
  char * op = malloc(sizeof(char) * 3);
  
  switch(t->tk.command){
    case JUMP: strcpy(op, "0E"); break;
    case JUMPplus: strcpy(op, "10"); break;
    case STORAddr: strcpy(op, "13"); break;
    default:
      ErrorDeal(OPCODEError, 0);
  }
  return op;
}

// Fills the label table with its correpondent address
struct labelTable * fillLabelTable(struct linkedListToken * llt)
{
  struct position pos;
  struct labelTableRow * labeltablerow = NULL;
  struct labelTable * begin;
  struct labelTable * end;

  // Creates new label Table
  end = begin = newTable();

  // Starts pos counter
  pos.addr = 0;
  pos.isRight = false;

  while(llt != NULL){
    switch(llt->t->type){
      case OP:
        // In case it has an address token
        if(llt->t->tk.command != LSH && llt->t->tk.command != RSH && llt->t->tk.command != LOADMQ){
          llt = llt->next;
        }
        if(pos.isRight){
          pos.addr++;
          pos.isRight = false;
        }
        else
          pos.isRight = true;
        break;
      case Dir:
        switch(llt->t->tk.dir){
          case LABEL:
            labeltablerow = malloc(sizeof(struct labelTableRow));
            labeltablerow->addr = pos.addr;
            labeltablerow->label = llt->t->attributes.string;
            labeltablerow->isRight = pos.isRight;
            end = addRowToTable(end, labeltablerow);
            break;
          case WORD:
            llt = llt->next;
            if(pos.isRight)
              ErrorDeal(AlignError, pos.addr);
            pos.addr++;
            pos.isRight = false;
            break;
          case ORG:
            llt = llt->next;
            pos.addr = addrToNum(begin, llt->t);
            pos.isRight = false;
            break;
          case ALIGN:
            llt = llt->next;
            if(pos.isRight)
              pos.addr++;
            int num = addrToNum(begin, llt->t);
            while(pos.addr % num)
              pos.addr++;
            pos.isRight = false;
            break;
         case WFILL:
            llt = llt->next;
            if(pos.isRight)
              ErrorDeal(AlignError, pos.addr);
            pos.addr += addrToNum(begin, llt->t);
            llt = llt->next;
            if(llt->t->type != ADDR)
              ErrorDeal(LinkedTokenError, 0);
            break;
          case SET:
            llt = llt->next;
            labeltablerow = malloc(sizeof(struct labelTableRow));
            labeltablerow->label = llt->t->attributes.string;
            llt = llt->next;
            labeltablerow->addr = addrToNum(begin, llt->t);
            labeltablerow->isRight = false;
            end = addRowToTable(end, labeltablerow);
            break;
          default:
            ErrorDeal(FillMemory,0);
        } break;
      default:
            ErrorDeal(FillMemory, 0);
    }
    llt = llt->next;
  }
  return begin;
}

// Fills the memory map with the righ operations and value
void fillMemoryMap(FILE * out, struct linkedListToken * llt, struct memoryMap * mm)
{
  struct position pos;
  struct labelTable * begin = fillLabelTable(llt);
  struct labelTable * current = NULL;
  struct linkedListToken * addr = llt;
  char * strAddr = NULL;
  char * aux = NULL;

  pos.addr = 0;
  pos.isRight = false;

  while(llt != NULL){
    switch(llt->t->type){
      case OP:
        if(llt->t->tk.command != JUMP && llt->t->tk.command != JUMPplus && llt->t->tk.command != STORAddr){
          if(pos.isRight){
            mm[pos.addr].command2 = getOPCode(llt->t);
            if(llt->t->tk.command != LOADMQ && llt->t->tk.command != LSH && llt->t->tk.command != RSH){
              llt = llt->next;
              aux = strAddr = addrToStr(begin, llt->t, NULL);
              strAddr += strlen(strAddr) - 3;
            }
            else
              strAddr =  "000";
            strcat(mm[pos.addr].command2, strAddr);
            pos.addr++;
            pos.isRight = false;
          }
          else{
            mm[pos.addr].command1 = getOPCode(llt->t);
            if(llt->t->tk.command != LOADMQ && llt->t->tk.command != LSH && llt->t->tk.command != RSH){
              llt = llt->next;
              aux = strAddr = addrToStr(begin, llt->t, NULL);
              strAddr += strlen(strAddr) - 3;
            }
            else
              strAddr = "000";
            strcat(mm[pos.addr].command1, strAddr);
            pos.isRight = true;
          }
          if(strcmp(strAddr, "000"))
            free(aux);
        }
        else if(llt->t->tk.command == JUMP || llt->t->tk.command == JUMPplus || llt->t->tk.command == STORAddr){
          addr = llt->next;
          aux = strAddr = addrToStr(begin, addr->t, &current);
          if(pos.isRight){
            if(current != NULL && current->row->isRight)
              mm[pos.addr].command2 = getRightOPCode(llt->t);
            else
              mm[pos.addr].command2 = getLeftOPCode(llt->t);
            strAddr += strlen(strAddr) - 3;
            strcat(mm[pos.addr].command2, strAddr);
            pos.addr++;
            pos.isRight = false;
          }
          else{
            if(current != NULL && current->row->isRight)
              mm[pos.addr].command1 = getRightOPCode(llt->t);
            else
              mm[pos.addr].command1 = getLeftOPCode(llt->t);
            strAddr += strlen(strAddr) - 3;
            strcat(mm[pos.addr].command1, strAddr);
            pos.isRight = true;
          }
          llt = llt->next;
          current = NULL;
          free(aux);
        }
        else
          ErrorDeal(FillMemory,0);
        break;
      case Dir:
        switch(llt->t->tk.dir){
          case LABEL: 
            break;
          case WORD:
            llt = llt->next;
            if(pos.isRight)
              ErrorDeal(AlignError, pos.addr);
            mm[pos.addr].isData = true;
            mm[pos.addr].command1 = addrToStr(begin, llt->t, NULL);
            pos.addr++;
            pos.isRight = false;
            break;
          case ORG:
            llt = llt->next;
            pos.addr = addrToNum(begin, llt->t);
            pos.isRight = false;
            break;
          case ALIGN:
            llt = llt->next;
            if(pos.isRight)
              pos.addr++;
            int num = addrToNum(begin, llt->t);
            while(pos.addr % num)
              pos.addr++;
            pos.isRight = false;
            break;
          case WFILL:
            addr = llt->next;
            llt = addr->next;
            if(pos.isRight)
              ErrorDeal(AlignError, pos.addr);
            int lenth = addrToNum(begin, addr->t), i;
            strAddr = addrToStr(begin, llt->t, NULL);
            for(i=0; i < lenth; i++){
              mm[pos.addr].command1 = strAddr;
              mm[pos.addr].isData = true;
              pos.addr++;
            }
            pos.isRight = false;
            break;
          case SET:
            llt = llt->next->next;
            break;
          default:
            ErrorDeal(FillMemory,0);
        }
        break;
      default:
            ErrorDeal(FillMemory, 0);
    }
    llt = llt->next;
  }
  // Free label table
  freeLabelTable(begin);
  return;
}
