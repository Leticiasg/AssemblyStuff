@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

@  This file contais functions that will process the string. This is
@ valid for scanf and printf

  .text

@----------------------------------------------@

  .align 4
  .global processStr
  .type processStr, %function

@ Arguments: r0 = pointer to string
@            first element to pop = pointer to specific flag handler
@            r1-r3 and stack = aguments of the string
@ Return : r2 = pointer to the final element of the buffer
@          r0 = number string processed
processStr:
  @ Stores registers in stack
  stmfd sp!, {r4-r11, lr}

  ldr r6, [sp, #36] @ Pointer to format handler
  ldr r2, [sp, #40] @ Pointer the buffer

  mov r1, #4    @ Argument iterator
  ldrb r5, [r0]  @ Firs element of the string in r5
  cmp r5, #0
  mov r3, #0
  mov r7, #0
  beq while_1
  do_1:
    cmp r5, #'%' @ Compares the r5 with the % character
    bne if_1
      stmfd sp!, {r1,r3}
      blx r6
      ldmfd sp!, {r1,r3}
      add r1, r1, #4
      b end_if_1
    if_1:
      strb r5, [r2]
      add r2, r2, #1
    end_if_1:
    
    @ Check the condition of the do-while statement
    ldrb r5, [r0, #1]!
    cmp r5, #0 @ if = "\0"
    bne do_1
  while_1:

  @ Return from function
  ldmfd sp!, {r4-r11, pc}

  .align 4
  .global getSize
  .type getSize, %function

@----------------------------------------------@

@ Arguments: r0 = pointer to the string
@ Return : r0 = number of masks
getSize:
  stmfd sp!, {r4-r11, lr}
  
  mov r5, #0        @ Counter
  ldrb r4, [r0]
  cmp r4, #'\0'
  beq return_getSize
  for_getSize:
    cmp r4, #'%'
    bne endif_getSize
      add r5, r5, #1
      while_getSize:
        ldrb r4, [r0, #1]!
        cmp r4, #' '
        beq endif_getSize
        cmp r4, #'\n'
        beq endif_getSize
        cmp r4, #'\t'
        beq endif_getSize
        add r5, r5, #1
        b while_getSize
    endif_getSize:
    ldrb r4, [r0], #1
    cmp r4, #'\0'
    beq return_getSize
    b for_getSize

  return_getSize:
  mov r0, r5
  ldmfd sp!, {r4-r11, pc}
