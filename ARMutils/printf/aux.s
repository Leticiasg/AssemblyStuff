@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

@ Auxiliary functions
    
    .text

@----------------------------------------------@

    .align 4
    .global numToStr
    .type numToStr, %function

@ Arguments : r0 = pointer to the end of the buffer
@             r1 = low part of the number to convert
@             r2 = high part of the number to convert
@             r3 = address to the division map
numToStr:
    stmfd sp!, {r4-r11, lr}
  
    ldr r7, =num_map
    mov r8, r0
    sub r3, r3, #8
    for_numToStr1:          @ Get the right value to
      ldr r4, [r3, #8]!     @ compare in the vector    
      cmp r4, r2
      bhi for_numToStr1
    cmp r4, #0
    bhi for_numToStr2
    sub r3, r3, #4
    for_numToStr3:          @ If the number is small
      ldr r5, [r3, #8]!     @ Get the right value to
      cmp r5, r1            @ compare in the vector
      bhi for_numToStr3
      sub r3, r3, #4
    for_numToStr2:
      mov r6, #0            @ Digit Counter
      ldr r4, [r3], #4      @ High part of the vector of value
      ldr r5, [r3], #4      @ Low part of the vector of values
      cmp r4, #0x42         @ Answer to Life, Universe and EVERITHING
      beq return_numToStr
      do_numToStr:
        @ 64bit Subtraction
        cmp r2, r4
        addge r6, r6, #1    @ Final digit
        blt store_numToStr
        cmp r2, #0          @ if r2 == 0
        beq end_if_numToStr
          subs r1, r1, r5
          sbc r2, r2, r4
          cmp r2, r4
          bhi do_numToStr
          blo store_numToStr
          cmp r1, r5          @ I have no Idea
          bhs do_numToStr     @ what is happening 
          b store_numToStr    @ here, DO NOT TOUCH !!
        end_if_numToStr:
        cmp r1, r5
        subcc r6, r6, #1
        bcc store_numToStr
        subs r1, r1, r5
        cmp r1, r5
        bcs do_numToStr
      @ Stores number
      store_numToStr:
      ldrb r6, [r7, r6]       @ Converts to ASCII char
      strb r6, [r0], #1       @ Stores the ASCII char
      b for_numToStr2
    
    return_numToStr:
    sub r1, r0, r8      @ Number of elements added to the buffer
    ldmfd sp!, {r4-r11, pc}

@----------------------------------------------@

    .align 4
    .global mod
    .type mod, %function

@ Returns in r0 the result of r0 % r1
mod:
  stmfd sp!, {r4-r11, lr}

  for_mod:
    sub r0, r0, r1
    cmp r0, #0
    bge for_mod

  add r0, r0, r1
  ldmfd sp!, {r4-r11, pc}

@----------------------------------------------@

  .align 4
  .global strToNum
  .type strToNum, %function

@ Converts a given string to a 10 base number
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

@-----------------------------------------------@
@                                               @
@                   DATA                        @
@                                               @
@-----------------------------------------------@

  .align 4
  .data
num_map: 
  .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
  
  .global division_map_dec
division_map_dec:
  .word 0x8AC72304, 0x89E80000, 0xDE0B6B3, 0xA7640000, 0x1634578, 0x5D8A0000, 0x2386F2, 0x6FC10000, 0x38D7E,0xA4C68000, 0x5AF3, 0x107A4000, 0x918, 0x4E72A000, 0xE8, 0xD4A51000, 0x17, 0x4876E800, 0x2, 0x540BE400, 0x0, 0x3B9ACA00, 0x0, 0x5F5E100, 0x0, 0x989680, 0x0, 0xF4240, 0x0, 0x186A0, 0x0, 0x2710, 0x0, 0x3E8, 0x0, 0x64, 0x0, 0xA, 0x0, 0x1, 0x42, 0x42
  
  .global division_map_hex
division_map_hex:
  .word 0x10000000, 0x0, 0x1000000, 0x0, 0x100000, 0x0, 0x10000, 0x0, 0x1000, 0x0, 0x100, 0x0, 0x10, 0x0, 0x1, 0x0, 0x0, 0x10000000, 0x0, 0x1000000, 0x0, 0x100000, 0x0, 0x10000, 0x0, 0x1000, 0x0, 0x100, 0x0, 0x10, 0x0, 0x1, 0x42, 0x42

  .global division_map_octal
division_map_octal:
  .word 0x80000000, 0x0, 0x10000000, 0x0, 0x2000000, 0x0, 0x400000, 0x0, 0x80000, 0x0, 0x10000, 0x0, 0x2000, 0x0, 0x400, 0x0, 0x80, 0x0, 0x10, 0x0, 0x2, 0x0, 0x0, 0x40000000, 0x0, 0x8000000, 0x0, 0x1000000, 0x0, 0x200000, 0x0, 0x40000, 0x0, 0x8000, 0x0, 0x1000, 0x0, 0x200, 0x0, 0x40, 0x0, 0x8, 0x0, 0x1, 0x42, 0x42


  .equ MAX_BUFFER_SIZE, 128
aux_buffer:
  .fill MAX_BUFFER_SIZE, 1, 0 
