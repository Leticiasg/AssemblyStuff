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
  .global Sos_fork

Sos_fork:
  stmfd sp!, {r4-r11, lr}

@ Get current process running
@ index of the process is in r4
  ldr r7, =RUNNING
  ldr r5, =process_status
  mov r4, #-1
__get_running_pid:
  add r4, r4 ,#1
  cmp r4, #8                @ 8 is the max process number
  beq __return_Sos_getpid   @ If no active process found
  ldrb r6, [r5, r4]
  cmp r6, r7                @ Compares r6 with RUNNING value
  bne __get_running_pid
 


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
