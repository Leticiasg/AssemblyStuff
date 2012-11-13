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
  stmfd sp!, {r0-r12, lr}
  mrs r4, SPSR
  stmfd sp!, {r4}

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

@ change the pc for child usr process
  ldr r4, =usr_registers
  ldr r4, [r4, r0, lsl #2]
  ldr r5, [r4, #56]         @ Get lr - address of fork return
  str r5, [r4, #60]         @ Save in pc
        
@ change the r0 for child usr process
  mov r5, #0
  str r5, [r4]

__return_Sos_fork:
  add r0, r0, #1            @ PID is in r0
  add sp, sp, #4
  ldmfd sp!, {r0-r12, pc}

@------------------------------------------------@

@ Arguments: r0 = index of child process
@            r1 = index of parent process
@ Return: NONE
_copy_context:
  stmfd sp!, {r4-r11, lr}

@ Get address of contexts of parent and child process
  ldr r4, =usr_registers
  ldr r6, [r4, r0, lsl #2]        @ Address of child  user context

  add r6, r6, #52          @ Address of child  user stack            
  mov r11, r6              @ Save r6 value
  ldr r6, [r6]             @ child user stack
  
@ Copy user stack
  msr CPSR_c, #0xDF        @ Change to SYSTEM mode IRQ/FIQ disabled
  add r4, sp, #4
  ldr r9, =usr_sp 
  ldr r9, [r9, r1, lsl #2] @ Address of default parent usr stack pointer
  cmp r9, r4               @ if stack is empty
  beq __return_copy_context
  sub r8, r9, r4           @ number of elements in stack
  sub r6, r6, r8           @ "alloc" space for new elements
__loop_usr_copy_context_stack:
  ldr r5, [r4], #4         @ Load element from parent stack
  str r5, [r6], #4         @ Store element in child stack
  cmp r9, r4
  bne __loop_usr_copy_context_stack
 
  sub r6, r6, r8           @ Store new stack pointer in struct
  str r6, [r11]

@ Copy user registers
  msr CPSR_c, #0xD3        @ Go back to SVC mode IRQ/FIQ disabled
  add r4, sp, #40          @ Go back to saved context in stack
  sub r6, r11, #52         @ Get the address of child context registers
  mov r7, #0
__loop_usr_copy_context_reg: @ Loop copies registers from r0-r12
  ldr r5, [r4], #4
  str r5, [r6], #4
  add r7, r7, #1
  cmp r7, #13
  bne __loop_usr_copy_context_reg
 
  msr CPSR_c, #0xDF        @ Change to SYSTEM mode IRQ/FIQ disabled

  str lr, [r6, #4]!       @ Store in usr_registers lr address
  ldr r5, [r4, #-56]      @ Load spsr from stack
  str r5, [r6, #4]            @ Store in usr_registers spsr address

  msr CPSR_c, #0xD3        @ Go back to SVC mode IRQ/FIQ disabled
__return_copy_context:
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
