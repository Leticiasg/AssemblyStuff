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
  ldr r4, =res4
  stmfd sp!, {r4}
  bl  myscanf
  ldmfd sp!, {r4}
  ldr r0, =mystring
  ldr r2, =res
  ldr r2, [r2]
  ldr r3, =res2
  ldr r3, [r3]
  ldr r4, =res3
  ldrb r4, [r4]
  ldr r5, =res4
  stmfd sp!, {r4,r5}
  bl  myprintf
  mov r0, #0
__mainend:
  mov r7, #1
  svc 0

  .data
  .align  4
mystring:
  .asciz "%lld is the %cumber %s myscanf returned\n"
scanfstring:
  .asciz "%Ld %c %s"
res:
  .word 0
res2:
  .word 0
res3:
  .byte 0
res4:
  .word 1, 1
