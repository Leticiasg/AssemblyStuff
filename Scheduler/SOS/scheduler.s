@ this file contains the implementation for the 
@ scheduler using round robin

  .text
  .global scheduler
        
scheduler:
  stmfd sp!, {r0-r12, lr}
  mov   r0, sp
  bl    _salva_contexto
  ldmfd sp!, {r0-r12, lr}


_salva_contexto:
  ldr r1, =usr_registers
  ldr r2, =current_pid
  ldr r2, [r2]
  ldr r1, [r1, r2] @ r1 = apontador para o vetor de registers do user
  
        

@-----------------------------------@
@                                   @
@            variaveis              @
@                                   @
@-----------------------------------@

  .data
        
current_pid: @ variavel local (global somente para o escalonador)
  .word 0  @ contem o PID-1 do processo que esta sendo executado