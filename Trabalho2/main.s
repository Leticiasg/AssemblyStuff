@ Main function 

  .text
  .align  4
  .global main
  .type main, %function

main:
  ldr r0, =mystring
  ldr r1, =otherstring2
  mov r2, #'1'
  mov r3, #10
  bl  myprintf
__mainend:
  mov r7, #1
  svc 0

  .data
  .align  4
mystring:
  .asciz  "%s My first string has only %c %d modifier.\n"
  .asciz  "garbage"
otherstring:
  .asciz "1"
otherstring2:
  .asciz "Fuck Life !!!!"
