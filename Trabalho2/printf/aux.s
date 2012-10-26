@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

@ Auxiliary functions

    .text
    .align 4
    .global numToHexStr
    .type numToHexStr, %function

@ This function converts a number to a string
@ Arguments: r0 = pointer to the end of the buffer
@            r1 = number to convert
@            r2 = mask
@            r3 = shift
@            stack = int_size
@ Return: r0 = pointer to the end of the buffer
@         r1 = number of elements added to the buffer
numToHexStr:
  stmfd sp!, {r4-r11, lr}
  
  mov r8, #0            @ Number of elements added to the buffer
  ldr r6, =num_map      @ Pointer to table
  ldr r5, [sp,#36]      @ Shift
  for_num:
    and r4, r2, r1
    cmp r2, #0      @ if r2 == 0 break
    beq endif_num
    mov r2, r2, lsr r3
    sub r5, r5, r3
    cmp r8, #0            @ if r8 != 0 enters if
    bne endif_num
      cmp r4, #0          @ if r4 == 0 continue
      beq for_num
    endif_num:
    mov r4, r4, lsr r5
    ldrb r7, [r6, r4]    @ Char is in r7
    strb r7, [r0], #1
    add r8, r8, #1
    cmp r2, #0
    bne for_num

  mov r1, r8            @ number of elements added to the buffer
  @ Return from function
  return:
  ldmfd sp!, {r4-r11, lr}
  ldmfd sp!, {r3}
  mov pc, lr

    .align 4
    .global numToStr
    .type numToStr, %function

@ Subtracts two 64 bit numbers (r0,r1) - (r2,r3)
@ Arguments: r0 = low part of first number
@            r1 = high part of first number
@            r2 = low part of second number
@            r3 = high part of second number
@ Return : r0 = low part of result
@          r1 = high part of result
sub64:
    stmfd sp!, {r4-r11, lr}

    subs r0, r0, r2
    subcs r1, r1, #1
    sub r1, r1, r3

    ldmfd sp!, {r4-r11, pc}

@ Arguments : r0 = pointer to the end of the buffer
@             r1 = low part of the number to convert
@             r2 = high part of the number to convert
@             r3 = address to the division map
numToStr:
    stmfd sp!, {r4-r11, lr}
  
    ldr r7, =num_map
    for_numToStr:
      mov r6, #0            @ Digit Counter
      ldr r4, [r3], #1
      ldr r5, [r3], #1
      cmp r4, #2
      beq return_numToStr
      do_numToStr:
        @ 64bit Subtraction
        subs r1, r1, r5
        subcs r2, r2, #1
        sub r2, r2, r4
        add r6, r6, #1
        cmp r2, #0
        bgt do_numToStr
      @ Stores number
      sub r6, r6, #1
      ldrb r6, [r7, r6]
      strb r6, [r0], #1
      b for_numToStr

    return_numToStr
    ldmfd sp!, {r4-r11, pc}

@ Arguments: r0 = number to convert
@ Return : r0 = char in ASCII
numToChar:
  stmfd sp!, {r4-r11, lr}

  ldr r4, =num_map
  ldr r0, [r4, r0]

  ldmfd sp!, {r4-r11, pc}

    .align 4
    .global numToOctHexStr
    .type numToOctHexStr, %function

@ This function converts a number to an Hex or Octal string
@ if r2 == 0xf and r3 == 4 converts to hexa
@ if r2 == 0x7 and r3 == 3 converts to octal
@ Arguments: r0 = pointer to the end of the buffer
@            r1 = number to convert
@            r2 = mask
@            r3 = shift
@            stack -- int_size
@ Return: r0 = pointer to the end of the buffer
@         r1 = number of elements added to the buffer
numToOctHexStr:
  stmfd sp!, {r4-r11, lr}
   
  mov r4, #0            @ Number of elements added to the buffer
  ldr r5, =num_map      @ Pointer to table
  mov r6, #0            @ shift iterator
  ldr r7, =aux_buffer 

  for_num_1:
    and r8, r2, r1
    mov r2, r2, lsl r3
    cmp r2, #0
    beq end_for_num_1
    mov r8, r8, lsr r6
    add r6, r6, r3
    ldrb r8, [r5, r8]
    strb r8, [r7], #1
    add r4, r4, #1
    b for_num_1
  end_for_num_1:
  
  for_num_2:
    cmp r4, #0
    beq for_num_3
    ldrb r5, [r7, #-1]!
    sub r4, r4, #1
    cmp r5, #'0'
    beq for_num_2

  mov r1, #0
  for_num_3:
    cmp r4, #-1
    beq return_num
    ldrb r5, [r7], #-1
    strb r5, [r0], #1
    add r1, r1, #1
    sub r4, r4, #1
    b for_num_3
  
  @ Return from function
  return_num:
  ldmfd sp!, {r4-r11, pc}
  
  .align 4
  .global numToDecStr
  .type numToDecStr, %function

@ This function converts a number to a decimal string
@ Arguments: r0 = pointer to the end of the buffer
@            r1 = number to convert
@ Return: r0 = pointer to the end of the buffer
@         r1 = number of elements added to the buffer
numToDecStr:
  stmfd sp!, {r4-r11, lr}

  mov r4, #0            @ Number of elements added to the buffer
  ldr r5, =num_map      @ Pointer to table
  ldr r6, =division_map
  mov r7, #0            @ Iterator
  mov r9, #0            @ Chars added

  for_dec:
    stmfd sp!, {r0-r3}    @ Store in stack
    mov r0, r1            @ Number in r0
    ldr r1, [r6], #4      @ Divisor in r1
    bl divide
    ldrb r8, [r5, r0]     @ Loads Char
    mov r10, r0
    add r7, r7, #1        @ Refresh iterator
    cmp r9, #0            @ if added a number to buffer
    ldmfd sp!, {r0-r3}
    bne end_if_dec
      cmp r7, #10         @ check iterator
      beq end_if_dec
        cmp r8, #'0'       @ if r8 == '0'
        beq for_dec
    end_if_dec:
    ldr r11, [r6, #-4]
    mul r10, r11, r10
    sub r1, r1, r10
    strb r8, [r0], #1
    add r9, r9, #1
    cmp r7, #10
    bne for_dec

  return_dec:
  mov r1, r9
  @ Return from function
  ldmfd sp!, {r4-r11, pc}

@ Returns in r0 the result of r0 % r1
mod:
  stmfd sp!, {r4-r11, lr}

  for_mod:
    sub r0, r0, r1
    cmp r0, #0
    bge for_mod

  add r0, r0, r1
  ldmfd sp!, {r4-r11, pc}

@ Arguments: r0 = number to divide
@            r1 = divisor
@            r2 = address of the division map
@ Return : r0 = mod
divide:
  stmfd sp!, {r4-r11, lr}

  mov r5, #0
  for_divide:
    sub r0, r0, r1
    cmp r0, #0
    blt return_divide
    add r5, r5, #1
    b for_divide

  @ Return from function
  return_divide:
  mov r0, r5
  ldmfd sp!, {r4-r11, pc}

  .align 4
  .global strToNum
  .type strToNum, %function

@ Arguments: r0 = pointer to the end of the buffer
@ Return: r1 = coverted number
strToNum:
  stmfd sp!, {r4-r11, lr}

  ldr r4, =num_map
  ldrb r5, [r0], #1
  mov r1, #0        @ num buffer
  mov r7, #10       @ constant 10
  for_count:
    sub r5, r5, #'0'
    cmp r5, #10
    bge return_str_to_num
    mul r1, r7, r1
    add r1, r1, r5
    ldrb r5, [r0], #1
    b for_count
    
  return_str_to_num:
  sub r0, r0, #2
  @ Return from function
  ldmfd sp!, {r4-r11, pc}

  .align 4
  .data
num_map: 
  .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
division_map_dec:
  .word 1000000000, 0, 100000000, 0, 10000000, 0, 1000000, 0, 100000, 0, 10000, 0, 1000, 0, 100, 0, 10, 0, 1, 0, 1000000000, 0, 100000000, 0, 10000000, 0, 1000000, 0, 100000, 0, 10000, 0, 1000, 0, 100, 0, 10, 0, 1, 2, 2

division_map_hex:
  .word 0x10000000, 0, 0x1000000, 0, 0x100000, 0, 0x10000, 0, 0x1000, 0, 0x100, 0, 0x10, 0, 0x1, 0, 0, 0x10000000, 0, 0x1000000, 0, 0x100000, 0, 0x10000, 0, 0x1000, 0, 0x100, 0, 0x10, 0, 0x1, 2, 2

  .equ MAX_BUFFER_SIZE, 128
aux_buffer:
  .fill MAX_BUFFER_SIZE, 1, 0 
