@---------------------------------@
@                                 @
@            SYSCALLS             @
@        IMPLEMENTATIONS          @
@                                 @
@---------------------------------@

  .align 4
  .global Sos_write

Sos_write:
  stmfd sp!, {r4-r11, lr}
  
  ldr r4, =UART1_USR1     @ is queue read
  ldr r5, =UART1_TRDY     @ maks
  ldr r6, =UART1_UTXD     @ queue
  add r9, r1, r2

__is_queue_ready:
  ldr r7, [r4]
  and r8, r5, r7
  cmp r8, r5
  bne __is_queue_ready

@ Push the queue
  ldrb r7, [r1], #1
  strb r7, [r6]
  cmp r1, r9
  bne __is_queue_ready

  ldmfd sp!, {r4-r11, pc}

@------------------------------------------------@

  .align 4
  .global Sos_exit

@ FINISH !!!

Sos_exit:
  mov r0, #0
  b Sos_exit
