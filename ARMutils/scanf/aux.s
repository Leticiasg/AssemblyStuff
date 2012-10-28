@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

  .text

@----------------------------------------------@

  .align 4
  .global mul64
  .type mul64, %function

@ This function multiples a 32bit register by 
@ two 32bit register and stores on them the result
@ Arguments: r0 = first Register
@            r1 = highest part of the number
@            r2 = lowest part of the number
@ Return r0 = highest part of the number
@        r1 = lowest part of the number
mul64:
  stmfd sp!, {r4-r11, lr}

  @ long long multiplication
  umulls r4, r5, r2, r0       @ r4 -- low part, r5 -- high part
  mul r1, r0, r1
  add r1, r5, r1

  mov r0, r1
  mov r1, r4

  ldmfd sp!, {r4-r11, pc}

@----------------------------------------------@

  .align 4
  .global charToNum
  .type charToNum, %function

@ This function converts a char to a number
@ Arguments:  r0 = Pointer to char
@ Return:     r0 = number
@             r1 = 1 if char '-' is found
charToNum:
  stmfd sp!, {r4-r11, lr}

  mov r1, #0
  ldrb r0, [r0]   @ Loads char
  mov r4, r0      @ auxiliary register
  cmp r0, #'-'
  beq minus
  sub r0, r0, #'0'
  cmp r0, #10
  blt return_charToNum
  mov r0, r4
  sub r0, r0, #'A'
  cmp r0, #6
  add r0, r0, #10
  blt return_charToNum
  mov r0, r4
  sub r0, r0, #'a'
  cmp r0, #6
  add r0, r0, #10
  blt return_charToNum

  minus:
    mov r0, #0
    mov r1, #1

  return_charToNum:
  ldmfd sp!, {r4-r11, pc}
