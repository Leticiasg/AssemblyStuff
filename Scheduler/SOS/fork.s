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

  .text

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
  ldr r5, =process_status
  ldr r6, =READY
  strb r6, [r5, r0]

@ copy the exact context from parent to child process
  bl _copy_context

@ change the pc for child process
  ldr r5, =__child_return
  ldr r4, =usr_registers
  ldr r4, [r4, r0, lsl #2]
  str r5, [r4, #60]

__return_Sos_fork:
  add r0, r0, #1            @ PID is in r0
  ldmfd sp!, {r4-r11, pc}

__child_return:
  mov r0, #0
  ldmfd sp!, {r4-r11, pc}

@------------------------------------------------@

@ Arguments: r0 = index of child process
@            r1 = index of parent process
@ Return: NONE
_copy_context:
  stmfd sp!, {r0-r12, lr}

  mov r4, #4
  mul r0, r4, r0          @ child  index for 32bit address vector
  mul r1, r4, r1          @ parent index for 32bit address vector

@ Get address of contexts of parent and child process
  ldr r4, =usr_registers
  ldr r6, [r4, r0]        @ Address of child  user context
  ldr r5, =svc_registers
  ldr r7, [r5, r0]        @ Adress of child  svc context

  add r6, r6, #52         @ Address of child  user stack            
  mov r11, r6             @ Save r6 value
  ldr r6, [r6]            @ child user stack
  add r7, r7, #52         @ Address of child  svc  stack
  mov r10, r7             @ Save r7 value
  ldr r7, [r7]            @ child svc  stack

@ Copy svc stack
  add r4, sp, #56         @ Discard stack of _copy_context
  ldr r9, =svc_sp 
  ldr r9, [r9, r1]        @ Address of default parent usr stack pointer
  cmp r9, r4              @ if stack is empty
  beq __return_copy_context
  sub r8, r9, r4          @ number of elements in stack
  sub r7, r7, r8          @ "alloc" space for new elements
__loop_svc_copy_context:
  ldr r5, [r4], #4        @ Load element from parent stack
  str r5, [r7], #4        @ Store element in child stack
  cmp r9, r4
  bne __loop_svc_copy_context
  
  sub r7, r7, r8          @ Store new stack pointer in struct
  str r7, [r10]

  msr CPSR_c, #0xDF       @ Change to SYSTEM mode IRQ/FIQ disabled
  
@ Copy user stack
  mov r4, sp
  ldr r9, =usr_sp 
  ldr r9, [r9, r1]        @ Address of default parent usr stack pointer
  cmp r9, r4              @ if stack is empty
  beq __return_copy_context
  sub r8, r9, r4          @ number of elements in stack
  sub r6, r6, r8          @ "alloc" space for new elements
__loop_usr_copy_context:
  ldr r5, [r4], #4        @ Load element from parent stack
  str r5, [r6], #4        @ Store element in child stack
  cmp r9, r4
  bne __loop_usr_copy_context
 
  sub r6, r6, r8          @ Store new stack pointer in struct
  str r6, [r11]

__return_copy_context:
  msr CPSR_c, #0xD3       @ Go back to SVC mode IRQ/FIQ disabled
  ldmfd sp!, {r0-r12, pc}

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
