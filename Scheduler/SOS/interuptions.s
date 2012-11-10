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
  sub   lr, lr, #4
  stmfd sp!, {r0-r12, lr} @ salva o contexto na pilha de irq
        
  ldr r0, =GPT_SR
  ldr r2, [r0]
  cmp r2, #100
  beq _call_scheduler
  mov r1, #1
  str r1, [r0]
  b   _return_IRQ
_call_scheduler:        
  eor r1, r1, r1
  str r1, [r0]
  mov r0, sp
  b  scheduler @ chama o escalonador
_return_IRQ:
  ldmfd sp!, {r0-r12, lr}
  movs  pc, lr
