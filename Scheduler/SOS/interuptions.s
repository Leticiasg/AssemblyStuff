@ This file contains the implementation for the interuptions

@------------------------------------------------@
  
  .align 4
  .global _start

_start:
.org 0x0
  b RESET
.org 0x8
  b SOFTWARE_INTERUPT
.org 0x18
  b IRQ

@------------------------------------------------@
  
  .align 4
  
RESET:
  msr CPSR_c, #0x1F     @ system mode, IRQ/FIQ enabled
  bl Start_GPT
  bl Start_TZIC
  bl Start_Stack
  bl Start_UART

  @ Enable interruptions, set ARM mode to USR, and jump to 0x8000
  msr CPSR_c, #0x10
  b 0x8000
 @ b main

@------------------------------------------------@

  .align 4

SOFTWARE_INTERUPT:
  stmfd sp!, {r4-r11, lr}
  
  cmp r7, #1
  bleq Sos_exit
  cmp r7, #2
  bleq Sos_fork
  cmp r7, #4
  bleq Sos_write
  cmp r7, #20
  bleq Sos_getpid

  ldmfd sp!, {r4-r11, lr}
  movs pc, lr

@------------------------------------------------@

  .align 4

IRQ:
  @ GPT_SR <-- 1
  ldr r0, =GPT_SR
  mov r1, #1
  str r1, [r0]
 
  sub lr, lr, #4
  movs pc, lr
