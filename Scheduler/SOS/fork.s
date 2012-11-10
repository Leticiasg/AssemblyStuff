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

@ Arguments: NONE
@ Return: child : r0 = 0 if sucess
@          parent: r0 = child's PID if sucess -1 if fail
Sos_fork:
  stmfd sp!, {r4-r11, lr}

@ Get current process running
@ index of the process is in r4
  mov r0, #0
  bl _get_running_process
  mov r1, r0

@ Get next index of available PID
  bl _get_next_available
  cmp r0, #-1
  beq __return_Sos_fork

@ If achieved this point, it is possible to create a new
@ child process

@ copy the exact context from parent to child process
  bl _copy_context

@ change the pc for child process
  ldr r5, =__child_return
  ldr r4, =usr_registers
  ldr r4, [r4, r0]
  str r5, [r4, #15]

__return_Sos_fork:
  add r0, r0, #1            @ PID is in r0
  ldmfd sp!, {r4-r11, lr}
  movs pc, lr

__child_return:
  mov r0, #0
  ldmfd sp!, {r4, r11, lr}
  movs pc, lr

@------------------------------------------------@

@ Arguments: r0 = index of child process
@            r1 = index of parent process
@ Return: NONE
_copy_context:
  stmfd sp!, {r4-r11, lr}

@ Get address of contexts of parent and child process
  ldr r4, =usr_registers
  ldr r6, [r4, r0]        @ Address of child  user context
  ldr r4, [r4, r1]        @ Address of parent user context
  ldr r5, =svc_registers
  ldr r7, [r5, r0]        @ Adress of child  svc context
  ldr r5, [r5, r1]        @ Adress of parent svc context

  mov r9, #0              @ Iterator
__loop_copy_context:
  ldr r8, [r4, r9]        @ Copy parent user
  str r8, [r6, r9]        @ to child user register
  ldr r8, [r5, r9]        @ Copy parent svc register
  str r8, [r7, r9]        @ to child svc register
  cmp r9, #68
  bne __loop_copy_context
  ldr r8, [r5, r9]        @ Copy parent spsr
  str r8, [r7, r9]        @ to child spsr

  ldmfd sp!, {r4-r11, pc}

@------------------------------------------------@

@ Arguments: NONE
@ Return: r0 = next available if sucess -1 if not available
_get_next_available:
  stmfd sp!, {r4-r11, lr}

  ldr r4, =WAITING
  ldr r5, =process_status
  mov r0, #-1
  mov r6, #-1
__get_available:
  add r6, r6, #1
  cmp r6, #8                          @ 8 is the max process number
  beq __return_get_next_available     @ if no available PID found
  ldrb r7, [r5, r6]
  cmp r7, r4
  bne __get_available

  mov r0, r6

__return_get_next_available:
  ldmfd sp!, {r4-r11, pc}

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
