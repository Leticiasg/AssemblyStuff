@---------------------------------@
@                                 @
@          Developed by           @
@       Tiago Lobato Gimenes      @
@                                 @
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

  ldmfd sp!, {r4-r11, lr}
  movs pc, lr

@------------------------------------------------@

  .align 4
  .global Sos_exit

Sos_exit:
  stmfd sp!, {r4-r11, lr}

  ldr r5, =process_status
  mov r4, r5
__get_running:
  ldrb r6, [r5, #1]!
  cmp r6, RUNNING
  bne __get_running

  sub r4, r5, r4        @ Index is in r4
  
  mov r6, WAITING
  strb r6, [r5, r4]

  ldmfd sp!, {r4-r11, lr}
  movs pc, lr
