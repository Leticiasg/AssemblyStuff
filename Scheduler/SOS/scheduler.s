@ this file contains the implementation for the 
@ scheduler using round robin

  .align 4
  .data

PID: 
  .byte 1,2,3,4,5,6,7,8
process_status: 
  .byte 0,0,0,0,0,0,0,0
_usr_registers:
  .word  _usr1_registers,_usr2_registers,_usr3_registers,_usr4_registers,_usr5_registers,_usr6_registers,_usr7_registers,_usr8_registers
_svc_registers: 
  .word _svc1_registers,_svc2_registers,_svc3_registers,_svc4_registers,_svc5_registers,_svc6_registers,_svc7_registers,_svc8_registers

_usr1_registers: 
  .fill 15, 4, 0 
_usr2_registers:
  .fill 15, 4, 0
_usr3_registers:
  .fill 15, 4, 0
_usr4_registers:
  .fill 15, 4, 0
_usr5_registers:  
  .fill 15, 4, 0
_usr6_registers:
  .fill 15, 4, 0
_usr7_registers:
  .fill 15, 4, 0
_usr8_registers:
  .fill 15, 4, 0

_svc1_registers: 
  .fill 15, 4, 0
_svc2_registers:
  .fill 15, 4, 0
_svc3_registers:
  .fill 15, 4, 0
_svc4_registers: 
  .fill 15, 4, 0
_svc5_registers:
  .fill 15, 4, 0
_svc6_registers:
  .fill 15, 4, 0
_svc7_registers:
  .fill 15, 4, 0
_svc8_registers:
  .fill 15, 4, 0
