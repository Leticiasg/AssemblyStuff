@ Main function 

  .text
  .align  4
  .global main
  .type main, %function

main:
  @ldr r0, =mystring
  @ldr r1, =otherstring2
  @ldr r2, =0x142
  @ldr r3, =0xfffff
  @bl  myprintf
  ldr r0, =scanfstring
  ldr r1, =res
  bl  myscanf
  ldr r9, =res
__mainend:
  mov r7, #1
  svc 0

  .data
  .align  4
mystring:
  .asciz  "%s My first string has only %lld modifier.\n"
  .asciz  "garbage"
otherstring:
  .asciz "1"
otherstring2:
  .asciz "Fuck Life !!!!"
scanfstring:
  .asciz "as %c"
res:
  .fill 1234, 1, 0
