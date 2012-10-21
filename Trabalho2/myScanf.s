@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

  .text

  .align 4
  .global myscanf
  .type myscanf, %function

@ Arguments: r0 = pointer to string
@            r1-r3 = pointer to arguments
@            stack = pointer to arguments
myscanf:
  @ Stores arguments in stack
  stmfd sp!, {r1-r3}
  mov fp, sp

  @ Stores registers in stack
  stmfd sp!, {r4-r11, lr}

  mov r1, #0    @ Argument iterator
  ldrb r5, [r0]  @ Firs element of the string in r5
  cmp r5, #'\0'
  beq while_1
  do_1:
    cmp r5, #'%' @ Compares the r5 with the % character
    bne if_1
      stmfd sp!, {r1,r3}
      add r1, r1, #44   @ Get the number address
      ldr r1, [sp, r1]  @ The number is in r1
      bl scanfHandler
      ldmfd sp!, {r1,r3}
      add r1, r1, #4
      b end_if_1
    if_1:
      stmfd sp!, {r0-r3}
      ldr r0, =auxBuffer
      bl getChar
      ldmfd sp!, {r0-r3}
    end_if_1:
    
    @ Check the condition of the do-while statement
    ldrb r5, [r0, #1]!
    cmp r5, #0 @ if = "\0"
    bne do_1
  while_1:

  @ Return from function
  ldmfd sp!, {r4-r11, pc}

  ldmfd sp!, {r4-r11, pc}

@ Arguments: r0 = pointer to the end of the buffer
@            r1 = argument of scanf
scanfHandler:
  stmfd sp!, {r4-r11, lr}
  
  ldrb r4, [r0, #1]!
  
  cmp r4, #'h'
  beq case_h
  cmp r4, #'l'
  beq case_l
  cmp r4, #'L'
  beq case_L
  cmp r4, #'d'
  beq case_d
  cmp r4, #'o'
  beq case_o
  cmp r4, #'u'
  beq case_u
  cmp r4, #'x'
  beq case_x
  cmp r4, #'c'
  beq case_c
  cmp r4, #'s'
  beq case_s
  b return

  case_h:
  b return
  case_hh:
  b return
  case_l:
  b return
  case_L:
  b return
  case_d:
  b return
  case_o:
  b return
  case_u:
  b return
  case_x:
  b return
  case_c:
    stmfd sp!, {r0-r3}
    ldr r0, =auxBuffer
    bl getChar
    ldrb r4, [r0]
    ldmfd sp!, {r0-r3}
    strb r4, [r1]
  b return
  case_s:
    stmfd sp!, {r0-r3}
    mov r0, r1
    bl readString
    ldmfd sp!, {r0-r3}
  b return

  @ Return from function
  return:
  ldmfd sp!, {r4-r11, pc}

@ This function reads a string from stdin and stores in r0
@ Arguments: r0 = address for the string to be stored
@ Return:
readString:
  stmfd sp!, {r4-r11, lr}

  mov r4, r0
  mov r6, r0
  ldr r0, =auxBuffer
  while_readString:
    bl getChar
    ldrb r5, [r0]
    cmp r5, #'\n'
    beq return_readString
    cmp r5, #'\t'
    beq return_readString
    cmp r5, #' '
    beq return_readString

    strb r5, [r4], #1
    b while_readString
  
  mov r0, r6
  return_readString:
  ldmfd sp!, {r4-r11, pc}
  

@ Gets the char from stdin
@ Arguments: r0 = pointer to the end of the buffer
@ Return: r0 = char returned by stdin 
getChar:
  stmfd sp!, {r4-r11, lr}

  mov r1, r0    @ const void * buff
  mov r0, #0    @ int fd = stdin
  mov r2, #1    @ size_t count
  mov r7, #3    @ read is syscall #3
  svc #0        @ invoke syscall

  mov r0, r1
  @ Return from function
  ldmfd sp!, {r4-r11, pc}

  .data
  .align 4

  .equ MAX_BUFFER_SIZE, 128

auxBuffer:
  .fill MAX_BUFFER_SIZE, 1, 0
