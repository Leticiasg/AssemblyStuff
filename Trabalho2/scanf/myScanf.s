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
      ldr r2, =0xFFFFFFFF
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
@            r2 = max size of the number to be read
@            r3 = second argument of scanf
scanfHandler:
  stmfd sp!, {r4-r11, lr}
  
  ldrb r4, [r0, #1]!
 
  @ Switch
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
    ldrb r4, [r0, #1]
    cmp r4, #'h'
    beq case_hh
    stmfd sp!, {r1-r3}
    cmp r4, #'d'
    beq decimal_h
    cmp r4, #'u'
    beq decimal_h
    
    ldr r2, =65536
    bl scanfHandler
    ldmfd sp!, {r1-r3}
    b return
    decimal_h:
      ldr r1, =auxWord
      bl scanfHandler
      ldmfd sp!, {r1-r3}
      ldr r4, =auxWord
      ldr r4, [r4]
      ldr r5, =0xFFFF
      and r4, r4, r5
      strb r4, [r1]
      b return
  case_hh:
    add r0, r0, #1
    stmfd sp!, {r1-r3}
    ldrb r4, [r0, #1]
    cmp r4, #'d'
    beq decimal_hh
    cmp r4, #'u'
    beq decimal_hh
    
    ldr r2, =256
    bl scanfHandler
    ldmfd sp!, {r1-r3}
    b return
    decimal_hh:
      ldr r1, =auxWord
      bl scanfHandler
      ldmfd sp!, {r1-r3}
      ldr r4, =auxWord
      ldr r4, [r4]
      and r4, r4, #0xFF
      strb r4, [r1]
      b return
  case_l:
    stmfd sp!, {r0-r3}
    ldr r2, =0xFFFFFFFF
    bl scanfHandler
    ldmfd sp!, {r0-r3}
    b return
  case_L:
    stmfd sp!, {r1-r3}
    bl longHandler
    ldmfd sp!, {r1-r3}
    b return
  case_d:
    stmfd sp!, {r0-r3}
    mov r0, r2
    mov r2, #10
    bl readNumber
    cmp r2, #1
    bne end_if_case_d     @ If number is negative
      mov r4, r0
      ldmfd sp!, {r0-r3}
      mov r6, r2
      mov r5, #2
      mul r5, r4, r5
      sub r2, r4, r5
      bl storeNumber
      mov r2, r6
      b return
    end_if_case_d:
    ldmfd sp!, {r0-r3}
  b return
  case_o:
    stmfd sp!, {r0-r3}
    mov r0, r2
    mov r2, #8
    bl readNumber
    ldmfd sp!, {r0-r3}
  b return
  case_u:
    stmfd sp!, {r0-r3}
    mov r0, r2
    mov r2, #10
    bl readNumber
    ldmfd sp!, {r0-r3}
  b return
  case_x:
    stmfd sp!, {r0-r3}
    mov r0, r2
    mov r2, #16
    bl readNumber
    ldmfd sp!, {r0-r3}
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

@ Arguments: r0 = pointer to the end of the buffer
@            r1 = argument of scanf
@            r2 = max size of the number to be read
@            r3 = second argument of scanf
longHandler:
  stmfd sp!, {r4-r11, lr}
  
  ldrb r4, [r0, #1]
  cmp r4, #'x'

  ldmfd sp!, {r4-r11, pc}

@ This function reads a string from stdin the represents a number 
@ and stores it 
@ Arguments:  r0 = base of the number
@             r1 = address to store number readed
@             r2 = second address to store number readed
readNumber64:
  stmfd sp!, {r4-r11, lr}
 
  @ Read the string from stdin and stores in auxBuffer
  stmfd sp!, {r0-r3}
  ldr r0, =auxBuffer    @ Loads auxiliar buffer
  bl readString
  mov r4, r0            @ Pointer to the beginning of the string readed is in r4
  mov r5, r1            @ Pointer to the end of the string readed is in r5
  ldmfd sp!, {r0-r3}

  cmp r4, r5
  beq return_readNumber64
  mov r6, #0   @ Highest part of the number
  mov r7, #0   @ Lowest part of the number
  mov r9, #0
  for_readNumber64:
    stmfd sp!, {r0-r3}
    @ Multiply the numbers
    mov r1, r6
    mov r2, r7
    bl mul64
    mov r10, r0
    mov r11, r1
    @ Loads the char of the string
    mov r0, r4
    bl charToNum
    mov r8, r0
    orr r9, r9, r1
    ldmfd sp!, {r0-r3}
    adds r7, r11, r7
    addcs r6, r6, #1
    add r6, r6, r10

    add r4, r4, #1
    cmp r4, r5
    bne for_readNumber64

  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@                          @@@@@@@
  @                                     @
  @                                     @
  @                                     @
  @                                     @
  @             FINISH HERE !!!!        @
  @                                     @
  @                                     @
  @                                     @
  @                                     @
  @@@@@@                           @@@@@@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  
  return_readNumber64:
  ldmfd sp!, {r4-r11, pc}

@ This function reads a string from stdin that represents a number
@ and returns it in r0
@ Arguments:  r0 = max number to be read
@             r1 = address to store number readed
@             r2 = base of the number
@ Return: r0 = Number readed
@         r1 = pointer to the beggining of the buffer
@         r2 = 1 if number is negative - 0 if it isn't
readNumber:
  stmfd sp!, {r4-r11, lr}
  
  stmfd sp!, {r0-r3}
  ldr r0, =auxBuffer    @ Loads auxiliar buffer
  bl readString
  mov r4, r0            @ Pointer to the beginning of the string readed is in r4
  mov r5, r1            @ Pointer to the end of the string readed is in r5
  ldmfd sp!, {r0-r3}

  mov r10, #0
  mov r9, #1            @ Base
  mov r7, #0            @ Final Number
  sub r6, r5, r4        @ Size of the string readed is in r6
  cmp r6, #0
  beq return_readNumber
  for_readNumber:
    sub r5, r5, #1
    cmp r5, r4
    blo return_readNumber
    stmfd sp!, {r0-r3}
    mov r0, r5
    bl charToNum
    mov r8, r0
    mov r10, r1
    ldmfd sp!, {r0-r3}
    mul r8, r9, r8
    add r7, r7, r8
    muls r9, r2, r9
    bvs return_readNumber
    cmp r9, r0
    bhs return_readNumber
    b for_readNumber

  @ Return from function
  return_readNumber:
  mov r2, r7
  bl storeNumber
  mov r0, r7
  mov r1, r5
  mov r2, r10
  ldmfd sp!, {r4-r11, pc}

@ Arguments:  r0 = max number to be read
@             r1 = address to store number readed
@             r2 = number to be stored
storeNumber:
  stmfd sp!, {r4-r11, lr}
  
  ldr r4, =256
  cmp r0, r4
  beq storeByte
  ldr r4, =65536
  cmp r0, r4
  beq storeHalf
  b store32Bit

  storeByte:
    strb r2, [r1]
    b return_storeNumber
  storeHalf:
    strh r2, [r1]
    b return_storeNumber
  store32Bit:
    str r2, [r1]

  return_storeNumber:
  ldmfd sp!, {r4-r11, pc}
  

@ This function reads a string from stdin and stores in r0
@ Arguments: r0 = address for the string to be stored
@ Return:    r0 = pointer to the beginning of the string stored
@            r1 = pointer to the end of the string stored
readString:
  stmfd sp!, {r4-r11, lr}

  mov r4, r0
  mov r6, r0
  ldr r0, =auxChar
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
  
  return_readString:
  mov r0, r6
  mov r1, r4
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

auxWord:
  .word 0
auxChar:
  .byte 0
auxBuffer:
  .fill MAX_BUFFER_SIZE, 1, 0

