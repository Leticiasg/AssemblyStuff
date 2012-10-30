@ Main function 

  .text
  .align  4
  .global main
  .type main, %function

main:
  ldr r0, =scanfstring
  ldr r1, =res
  ldr r2, =res2
  ldr r3, =res3
  bl  myscanf
  ldr r0, =mystring
  ldr r2, =res
  ldr r2, [r2]
  ldr r3, =res2
  ldr r3, [r3]
  ldr r4, =res3
  ldrb r4, [r4]
  stmfd sp!, {r4}
  bl  myprintf
  mov r0, #0
__mainend:
  mov r7, #1
  svc 0

  .data
  .align  4
mystring:
  .asciz "%lld is the %cumber that myscanf returned\n"
scanfstring:
  .asciz "%Ld %c"
res:
  .word 0
res2:
  .word 0
res3:
  .byte 0
