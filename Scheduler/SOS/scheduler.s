@ this file contains the implementation for the 
@ scheduler using round robin

  .text
  .global scheduler
        
scheduler:
  @ recebe em r0 o apontador para os registradores salvos na pilha
  stmfd sp!, {lr}
  bl  _save_context @ salva o contexto do processo atual
  ldmfd sp!, {lr}
  mov sp, r0 @ desempilha r0-r12 e lr
  ldr r0, =current_pid
  ldr r0, [r0]
  ldr r1, =process_status
  ldr r2, =READY
  strb r2, [r1, r0] @ deixa o processo escalonado

  movs pc, lr
  
__loop_search_pid:
  add r0, r0, #1
  cmp r0, #8
  eoreq r0, r0, r0
  ldrb r2, [r1, r0]
  ldr r3, =READY
  cmp r2, r3
  bne __loop_search_pid

  ldr r3, =current_pid
  str r0, [r3]
  ldr r2, =RUNNING
  strb r2, [r1, r0]

@ funcao que salva o contexto do processo
@ recebe em r0 o ponteiro para os registradores a serem salvos
@ retorna o endereco atual da pilha
_save_context:
  ldr r1, =usr_registers
  ldr r2, =svc_registers
  ldr r3, =current_pid
  ldr r3, [r3]
  ldr r1, [r1, r3] @ r1 = apontador para o vetor de registers do user
  ldr r2, [r2, r3] @ r2 = apontador para o veotr de registers do supervisor
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
  
        
@-----------------------------------@
@                                   @
@            variaveis              @
@                                   @
@-----------------------------------@

  .data
        
current_pid: @ variavel local (global somente para o escalonador)
  .word 0  @ contem o PID-1 do processo que esta sendo executado