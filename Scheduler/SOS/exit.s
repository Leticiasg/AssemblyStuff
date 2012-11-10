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
  .global Sos_exit

@ Arguments: r0 = status
@ Return: NONE
Sos_exit:
  stmfd sp!, {r4-r11, lr}

  stmfd sp!, {r0}
  bl _get_running_process

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
  cmp r5, #68
  bne __fill_usr_registers
  str r7, [r8, r5]

@ Reset sp
  mov r5, #52             @ change sp
  ldr r7, =usr_sp        
  ldr r9, =svc_sp
  ldr r7, [r7, r4]        @ Load usr_stack*
  ldr r9, [r7, r4]        @ Load svc_stack*
  str r7, [r6, r5]        @ Stor usr_stack
  str r9, [r8, r5]        @ Stor usr_stack

@ Free position of process
  ldr r5, =process_status
  ldr r6, =WAITING
  strb r6, [r5, r4]

__return_Sos_exit:
  ldmfd sp!, {r4-r11, lr}
  movs pc, lr

@------------------------------------------------@

@ Arguments: NONE
@ Return: r0 = index of the running process
_get_running_process:
  stmfd sp!, {r4-r11, lr}

@ Get current process running
@ index of the process is in r4
  ldr r7, =RUNNING
  ldr r5, =process_status
  mov r0, #-1
__get_running:
  add r0, r0 ,#1
  cmp r0, #8                @ 8 is the max process number
  beq __return_running      @ If no active process found
  ldrb r6, [r5, r0]
  cmp r6, r7                @ Compares r6 with RUNNING value
  bne __get_running

__return_running:
  ldmfd sp!, {r4-r11, pc}
