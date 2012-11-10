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
  .global Sos_getpid

Sos_getpid:
  stmfd sp!, {r4-r11, lr}

  mov r0, #0      @ Starts the return value, if returns 0 == fail !

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
  
  add r0, r4, #1            @ PID value in return register

__return_Sos_getpid:
  ldmfd sp!, {r4-r11, pc}
