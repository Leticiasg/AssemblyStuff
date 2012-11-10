@---------------------------------@
@                                 @
@          Developed by           @
@       Tiago Lobato Gimenes      @
@                                 @
@---------------------------------@
@                                 @
@            SYSCALLS             @
@        IMPLEMENTATIONS          @
@                                 @
@---------------------------------@

  .align 4
  .global Sos_write

Sos_write:
  stmfd sp!, {r4-r11, lr}
  
  ldr r4, =UART1_USR1     @ is queue read
  ldr r5, =UART1_TRDY     @ maks
  ldr r6, =UART1_UTXD     @ queue
  add r9, r1, r2

__is_queue_ready:
  ldr r7, [r4]
  and r8, r5, r7
  cmp r8, r5
  bne __is_queue_ready

@ Push the queue
  ldrb r7, [r1], #1
  strb r7, [r6]
  cmp r1, r9
  bne __is_queue_ready

  ldmfd sp!, {r4-r11, lr}
  movs pc, lr

@------------------------------------------------@

  .align 4
  .global Sos_exit

Sos_exit:
  stmfd sp!, {r4-r11, lr}

@ Get current process running
  ldr r5, =process_status
  mov r4, #-1
__get_running:
  add r4, r4 ,#1
  cmp r4, #8
  beq __return_Sos_exit   @ If no active process found
  ldrb r6, [r5, r4]
  ldr r6, =RUNNING
  bne __get_running
  
@ Save r5 in tmp register
  mov r12, r5

@ Clean registers
  mov r7, #0
  mov r5, #0
  ldr r6, =usr_registers
  ldr r8, =svc_registers
  ldr r6, [r6, r4]        @ Address of the usr_register vector
  ldr r8, [r8, r4]        @ Address of the svc_register vector
__fill_usr_registers:
  str r7, [r6, r5]
  str r7, [r8, r5]
  add r5, r5, #4
  cmp r5, #64
  bne __fill_usr_registers

@ Reset sp
  mov r5, #52             @ change sp
  ldr r7, =_usr_sp        
  ldr r9, =_svc_sp
  ldr r7, [r7, r4]        @ Load usr_stack*
  ldr r9, [r7, r4]        @ Load svc_stack*
  str r7, [r6, r5]        @ Stor usr_stack
  str r9, [r8, r5]        @ Stor usr_stack

@ Free position of process
  ldr r6, =WAITING
  strb r6, [r12, r4]

__return_Sos_exit:
  ldmfd sp!, {r4-r11, lr}
  movs pc, lr

@---------------------------------@
@                                 @
@              DATA               @
@                                 @
@---------------------------------@

  .data

_usr_sp:
  .word USR_STACK1, USR_STACK2, USR_STACK3, USR_STACK4, USR_STACK5,USR_STACK6, USR_STACK7, USR_STACK8
_svc_sp:
  .word SVC_STACK1, SVC_STACK2, SVC_STACK3, SVC_STACK4, SVC_STACK5,  SVC_STACK6, SVC_STACK7, SVC_STACK8
