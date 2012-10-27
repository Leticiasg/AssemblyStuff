@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

@ Auxiliary functions

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
    mov r8, #0
    for_numToStr:
      mov r6, #0            @ Digit Counter
      ldr r4, [r3], #4
      ldr r5, [r3], #4
      cmp r4, #0x42
      beq return_numToStr
      mov r9, r1
      mov r10, r2
      do_numToStr:
        @ 64bit Subtraction
        subs r9, r9, r5
        sbc r10, r10, r4
        add r6, r6, #1
        cmp r10, #0
        bge do_numToStr
      @ Stores number
      sub r6, r6, #1
      adds r1, r9, r5
      adc r2, r10, r4
      orr r8, r6, r8
      cmp r8, #0
      beq for_numToStr
      ldrb r6, [r7, r6]
      strb r6, [r0], #1
      b for_numToStr

    return_numToStr:
    ldmfd sp!, {r4-r11, pc}

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
  
  .global division_map_dec
division_map_dec:
  .word 0x8AC72304, 0x89E80000, 0xDE0B6B3, 0xA7640000, 0x1634578, 0x5D8A0000, 0x2386F2, 0x6FC10000, 0x38D7E,0xA4C68000, 0x5AF3, 0x107A4000, 0x918, 0x4E72A000, 0xE8, 0xD4A51000, 0x17, 0x4876E800, 0x2, 0x540BE400, 0x3, 0xB9ACA00, 0x0, 0x5F5E100, 0x0, 0x989680, 0x0, 0xF4240, 0x0, 0x186A0, 0x0, 0x2710, 0x0, 0x3E8, 0x0, 0x64, 0x0, 0xA, 0x0, 0x1, 0x42, 0x42
  
  .global division_map_hex
division_map_hex:
  .word 0x10000000, 0x0, 0x1000000, 0x0, 0x100000, 0x0, 0x10000, 0x0, 0x1000, 0x0, 0x100, 0x0, 0x10, 0x0, 0x1, 0x0, 0x0, 0x10000000, 0x0, 0x1000000, 0x0, 0x100000, 0x0, 0x10000, 0x0, 0x1000, 0x0, 0x100, 0x0, 0x10, 0x0, 0x1, 0x42, 0x42

  .global division_map_octal
division_map_octal:
  .word 0x80000000, 0x0, 0x10000000, 0x0, 0x2000000, 0x0, 0x400000, 0x0, 0x80000, 0x0, 0x10000, 0x0, 0x2000, 0x0, 0x400, 0x0, 0x80, 0x0, 0x10, 0x0, 0x2, 0x0, 0x0, 0x40000000, 0x0, 0x8000000, 0x0, 0x1000000, 0x0, 0x200000, 0x0, 0x40000, 0x0, 0x8000, 0x0, 0x1000, 0x0, 0x200, 0x0, 0x40, 0x0, 0x8, 0x0, 0x1, 0x42, 0x42


  .equ MAX_BUFFER_SIZE, 128
aux_buffer:
  .fill MAX_BUFFER_SIZE, 1, 0 
