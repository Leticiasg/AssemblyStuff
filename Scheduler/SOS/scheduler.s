@ this file contains the implementation for the 
@ scheduler using round robin

  .text
  .global scheduler
        
scheduler:
  @ recebe em r0 o apontador para os registradores salvos na pilha
  ldr r1, =process_status
  ldr r2, =current_pid
  ldr r2, [r2]
  ldrb r1, [r1, r2]
  ldr r2, =WAITING
  cmp r1, r2
  beq __process_already_dead
  bl  _save_context @ salva o contexto do processo atual
  mov sp, r0 @ desempilha r0-r12 e lr
  ldr r0, =current_pid
  ldr r0, [r0]
  ldr r1, =process_status
  ldr r2, =READY
  strb r2, [r1, r0] @ deixa o processo escalonado
  b   __loop_search_pid

__process_already_dead:
  ldr r0, =current_pid
  ldr r0, [r0]
  ldr r1, =process_status
  
__loop_search_pid:
  add r0, r0, #1
  cmp r0, #8        @ anda no vetor de um em um, ciclicamanete , ate a posicao 8
  eoreq r0, r0, r0  @ se o vetor terminou, volta para o inicio
  ldrb r2, [r1, r0] @ pega o byte de status referente ao pid r0+1
  ldr r3, =READY   
  cmp r2, r3        @ se o processo nao estiver escalonado
  bne __loop_search_pid @ continua o ciclo

  ldr r3, =current_pid
  str r0, [r3]
  ldr r2, =RUNNING
  strb r2, [r1, r0]

  
  bl   _recupera_contexto
  ldmfd sp!, {lr}
  movs pc, lr

_save_context:

@ funcao que salva o contexto do processo
@ recebe em r0 o ponteiro para os registradores a serem salvos
@ retorna o endereco atual da pilha
        
  ldr r1, =usr_registers
  ldr r2, =svc_registers
  ldr r3, =current_pid
  ldr r3, [r3]
  ldr r1, [r1, r3, lsl #2] @ r1 = apontador para o vetor de registers do user
  ldr r2, [r2, r3, lsl #2] @ r2 = apontador para o veotr de registers do supervisor
  eor r4, r4, r4   @ contador

__laco_save_usr_registers:      
  ldr r5, [r0], #4
  str r5, [r1], #4 @ grava r0-r12 no vetor de registers de user
  str r5, [r2], #4 @ grava r0-r12 no vetor de registers de supervisor
  add r4, r4, #1
  cmp r4, #13
  blt __laco_save_usr_registers

  mrs r5, SPSR
  str r5, [r1, #12] @ salva as flags do processo na posicao 16 do vetor usr
  str r5, [r2, #12] @ salva as flags do processo na posicao 16 do vetor svc
  ldr r5, [r0], #4  @ recupera o lr

  @ muda para o modo supervisor, desabilitando interrupcoes      
  msr CPSR_c, #0xd3 
  str r13, [r2], #4 @ salva o sp_svc
  str r14, [r2], #4 @ salva o lr_svc
  str r5, [r2], #4  @ salva o pc
  mrs r6, SPSR      @ salva em r6 o valor de spsr_svc
  str r6, [r2, #4]  

  @ muda para o modo system, desabilitando interrupcoes
  msr CPSR_c, #0xdf
  str r13, [r1], #4 @ salva o sp_usr
  str r14, [r1], #4 @ salva o lr_usr
  str r5, [r1], #4  @ salva o pc

  @ volta para o modo IRQ
  msr CPSR_c, #0xd2

  mov pc, lr

_recupera_contexto:     
@ recupera o contexto do processo a ser executado
@ recebe em r0 o valor pid-1 do processo

   ldr r1, =usr_registers
   ldr r1, [r1, r0, lsl #2]   @ apontador para usr_registers do processo atual
   ldr r2, [r1, #60]  @ pega o valor de pc estorado
   stmfd sp!, {r2}    @ salva pc do processo na pilha
   ldr r3, =svc_registers
   ldr r3, [r3, r0, lsl #2] @ apontador para svc_registers do processo atual
   ldr r4, =exec_mode
   ldrb r4, [r4, r0] @ pega o modo do processo
   ldr r5, =USR_MODE
   cmp r4, r5 
   ldreq r2, [r1, #64]  @ passa o valor de cpsr do processo para r2
   ldrne r2, [r3, #64]
   msr SPSR, r2       @ salva cpsr em spsr
   ldr r2, [r1, #28]
   stmfd sp!, {r2}    @ empilha r7
   ldr r2, [r1, #24]
   stmfd sp!, {r2}    @ empilha r6
   ldr r2, [r1, #20]
   stmfd sp!, {r2}    @ empilha r5
   ldr r2, [r1, #16]
   stmfd sp!, {r2}    @ empilha r4
   ldr r2, [r1, #12]
   stmfd sp!, {r2}    @ empilha r3
   ldr r2, [r1, #8]
   stmfd sp!, {r2}    @ empilha r2
   ldr r2, [r1, #4]
   stmfd sp!, {r2}    @ empilha r1
   ldr r2, [r1]
   stmfd sp!, {r2}    @ empilha r0
        
   @ muda para modo system
   msr CPSR_c, #0xdf

   ldr r8, [r1, #32]
   ldr r9, [r1, #36]
   ldr r10, [r1, #40]
   ldr r11, [r1, #44]
   ldr r12, [r1, #48]
   ldr r13, [r1, #52]
   ldr r14, [r1, #56]

   @ muda para modo supervisor
   msr CPSR_c, 0xd3

   ldr r1, =svc_registers
   ldr r1, [r1, r0, lsl #2]  @ apontador para registers de svc
   ldr sp, [r1, #52] @ recupera o sp de svc
   ldr r2, [r1, #68]
   msr SPSR, r2      @ recupera o spsr de svc

   @ volta para o modo irq
   msr CPSR_c, 0xd2
   ldmfd sp!, {r0-r7}

   mov pc, lr
        
@-----------------------------------@
@                                   @
@            variaveis              @
@                                   @
@-----------------------------------@

  .data
        
current_pid: @ variavel local (global somente para o escalonador)
  .word 0  @ contem o PID-1 do processo que esta sendo executado
