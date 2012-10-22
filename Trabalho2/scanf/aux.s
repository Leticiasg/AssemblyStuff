@---------------------------------@
@                                 @
@ Author: Tiago Lobato Gimenes    @
@                                 @
@ Contact: tlgimenes@gmail.com    @
@                                 @
@---------------------------------@

  .text

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
