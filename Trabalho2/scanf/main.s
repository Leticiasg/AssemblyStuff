@ Main function 

  .text
  .align  4
  .global main
  .type main, %function

main:
  ldr r0, =scanfstring
  ldr r1, =res
  ldr r2, =res2
  bl  myscanf
  ldr r9, =res
  ldrb r9, [r9]
  ldr r9, =res2
  ldr r9, [r9]
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
  .asciz "as %hhx %x"
res:
  .word 123
res2:
  .word 123
