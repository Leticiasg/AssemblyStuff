@ este arquivos contem a implementacao das estruturas referentes
@ a pilha de processos

@----------------------------@
@                            @
@        CONSTANTS           @
@                            @
@----------------------------@

.equ WAITING, 0
.equ REDAY, 1
.equ RUNNING, 2

.global WAITING
.global READY
.global RUNNING

@-----------------------------@
@                             @
@      Process Queue          @
@                             @
@-----------------------------@

  .align 4
  .data
@ Process ID dos processos
PID: 
  .byte 1,2,3,4,5,6,7,8
  .global PID

@ Status de execucao do processo
process_status: 
  .byte 0,0,0,0,0,0,0,0
  .global process_status

@ Apontadores para o vetor de registradores do modo user
_usr_registers:
  .word  _usr1_registers,_usr2_registers,_usr3_registers,_usr4_registers,_usr5_registers,_usr6_registers,_usr7_registers,_usr8_registers
  .global _usr_registers

@ Apontador para o vetor de registradores do modo supervisor
_svc_registers: 
  .word _svc1_registers,_svc2_registers,_svc3_registers,_svc4_registers,_svc5_registers,_svc6_registers,_svc7_registers,_svc8_registers
  .global _svc_registers

@ Vetor de registers do modo user
_usr1_registers: 
  .fill 13, 4, 0   @ salva r0-r12 
  .word USR_STACK1 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
_usr2_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK2 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
_usr3_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK3 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
_usr4_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK4 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
_usr5_registers:  
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK5 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
_usr6_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK6 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
_usr7_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK7 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
_usr8_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK8 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr

  .global _usr1_registers
  .global _usr2_registers
  .global _usr3_registers
  .global _usr4_registers
  .global _usr5_registers
  .global _usr6_registers
  .global _usr7_registers
  .global _usr8_registers
        
@ vetor de registers do modo supervisor
_svc1_registers: 
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK1 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
_svc2_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK2 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
_svc3_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK3 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
_svc4_registers: 
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK4 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
_svc5_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK5 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
_svc6_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK6 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
_svc7_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK7 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
_svc8_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK8 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr

  .global _svc1_registers
  .global _svc2_registers
  .global _svc3_registers
  .global _svc4_registers
  .global _svc5_registers
  .global _svc6_registers
  .global _svc7_registers
  .global _svc8_registers