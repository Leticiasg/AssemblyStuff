@ this file contains the implementation for the 
@ scheduler using round robin

  .align 4
  .data

.equ INACTIVE, #0
.equ ACTIVE, #1
.equ CURRENT, #2

PID: 
  .byte 1,2,3,4,5,6,7,8
process_status: 
  .byte 0,0,0,0,0,0,0,0
usr_registers:
  .word  usr1_registers,usr2_registers,usr3_registers,usr4_registers,usr5_registers,usr6_registers,usr7_registers,usr8_registers
svc_registers: 
  .word svc1_registers,svc2_registers,svc3_registers,svc4_registers,svc5_registers,svc6_registers,svc7_registers,svc8_registers

usr1_registers: 
  .fill 15, 4, 0 
usr2_registers:
  .fill 15, 4, 0
usr3_registers:
  .fill 15, 4, 0
usr4_registers:
  .fill 15, 4, 0
usr5_registers:  
  .fill 15, 4, 0
usr6_registers:
  .fill 15, 4, 0
usr7_registers:
  .fill 15, 4, 0
usr8_registers:
  .fill 15, 4, 0

svc1_registers: 
  .fill 15, 4, 0
svc2_registers:
  .fill 15, 4, 0
svc3_registers:
  .fill 15, 4, 0
svc4_registers: 
  .fill 15, 4, 0
svc5_registers:
  .fill 15, 4, 0
svc6_registers:
  .fill 15, 4, 0
svc7_registers:
  .fill 15, 4, 0
svc8_registers:
  .fill 15, 4, 0

@----------------------------------@
@                                  @
@         Global Constants         @
@                                  @
@----------------------------------@

.global PID
.global process_status 
.global usr1_registers
.global usr2_registers
.global usr3_registers
.global usr4_registers
.global usr5_registers
.global usr6_registers
.global usr7_registers
.global usr8_registers
.global svc1_registers
.global svc2_registers
.global svc3_registers
.global svc4_registers
.global svc5_registers
.global svc6_registers
.global svc7_registers
.global svc8_registers

.global INACTIVE
.global ACTIVE
.global CURRENT
