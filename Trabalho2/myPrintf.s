@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

@ Myprintf function

  .text
  .align  4
  .global myprintf
  .type myprintf, %function

@ Arguments: r0 = pointer to string
@            r1-r3 and stack = arguments of the string
myprintf:
  @ Stores arguments in stack
  stmfd sp!, {r1-r3}

  @ Stores registers in stack
  stmfd sp!, {r4-r11, lr}
  mov fp, sp
  
  @ Call processStr
  ldr r5, =myPrintfHandler
  ldr r6, =buff
  stmfd sp!, {r5,r6}
  bl processStr
  add sp, sp, #8

  @ Arguments for syscall write
  ldr r1, =buff     @ const void * buff
  mov r0, #1        @ int fd = stdout 
  sub r2, r2, r1    @ size_t count
  mov r7, #4        @ write is syscall #4
  svc #0            @ invoke syscall

  @ Return from function
  ldmfd sp!, {r4-r11, pc}

  .align 4
  .global myPrintfHandler
  .type myPrintfHandler, %function


@ Arguments: r0 = pointer to the end of the string
@            r1 = argument
@            r2 = pointer to the end of the buffer
@ Return:    r2 = pointer to the end of the buffer modified
@            r1 = number of elements added to the buffer
myPrintfHandler:
  stmfd sp!, {r4-r11, lr}

  ldrb r4, [r0, #1]!  @ Loads the first char of the flag

  @ Switch is made here !!!
  ldr r5, =case_array
  ldr r7, [r5]
  ldr r6, =addr_array
  ldr r8, [r6]
  for_handler:    
    cmp r4, r7
    moveq pc, r8
    ldr r7, [r5, #4]!
    ldr r8, [r6, #4]!
    cmp r7, #115
    bne for_handler
  beq case_s
  b constant

  case_0:
  case_minus:
  case_plus: 
  case_h:
  case_l:
  case_d:
  case_i:
  case_u:
    stmfd sp!, {r0, r1}
    mov r0, r2
    bl numToDecStr
    mov r2, r0
    ldmfd sp!, {r0, r1}
    b return
  case_o:
    stmfd sp!, {r0,r3}
    mov r0, r2
    mov r2, #0x7          @ Mask 
    mov r3, #3            @ Shift
    bl numToOctHexStr
    mov r2, r0
    ldmfd sp!, {r0,r3}
    b return
  case_x:
    stmfd sp!, {r0,r3}
    mov r0, r2
    mov r2, #0xF          @ Mask 
    mov r3, #4            @ Shift
    bl numToOctHexStr
    mov r2, r0
    ldmfd sp!, {r0,r3}
    b return
  case_c:
    strb r1, [r2], #1
    mov r1, #1
    b return
  case_s:
    ldrb r5, [r1]
    cmp r5, #0
    beq return
    for_s:
      strb r5, [r2], #1
      ldrb r5, [r1, #1]!
      cmp r5, #0
      bne for_s
    b return
  constant:

  return:
  ldmfd sp!, {r4-r11, pc}

  .align 4
  .data

case_array:
    .word '0', '-', '+', 'h', 'l', 'd', 'i', 'u', 'o', 'x', 'c', 's' 
addr_array:
    .word case_0, case_minus, case_plus, case_h, case_l, case_d, case_i, case_u, case_o, case_x, case_c, case_s
  
  .equ MAX_BUFFER_SIZE, 128

  .align 4
  .global buff
buff:
  .fill MAX_BUFFER_SIZE, 1, 0
