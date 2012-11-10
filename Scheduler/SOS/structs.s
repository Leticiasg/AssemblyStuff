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
usr_registers:
  .word  usr1_registers,usr2_registers,usr3_registers,usr4_registers,usr5_registers,usr6_registers,usr7_registers,usr8_registers
  .global usr_registers

@ Apontador para o vetor de registradores do modo supervisor
svc_registers: 
  .word svc1_registers,svc2_registers,svc3_registers,svc4_registers,svc5_registers,svc6_registers,svc7_registers,svc8_registers
  .global svc_registers

@ Vetor de registers do modo user
usr1_registers: 
  .fill 13, 4, 0   @ salva r0-r12 
  .word USR_STACK1 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
usr2_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK2 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
usr3_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK3 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
usr4_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK4 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
usr5_registers:  
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK5 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
usr6_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK6 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
usr7_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK7 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr
usr8_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK8 @ inicializa o sp (r13)
  .fill 3, 4, 0    @ salva r14-r15 e cpsr

  .global usr1_registers
  .global usr2_registers
  .global usr3_registers
  .global usr4_registers
  .global usr5_registers
  .global usr6_registers
  .global usr7_registers
  .global usr8_registers
        
@ vetor de registers do modo supervisor
svc1_registers: 
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK1 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
svc2_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK2 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
svc3_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK3 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
svc4_registers: 
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK4 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
svc5_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK5 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
svc6_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK6 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
svc7_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK7 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr
svc8_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK8 @ inicializa o sp (r13) para o modo supervisor
  .fill 4, 4, 0    @ salva r14, r15, cpsr, spsr

  .global svc1_registers
  .global svc2_registers
  .global svc3_registers
  .global svc4_registers
  .global svc5_registers
  .global svc6_registers
  .global svc7_registers
  .global svc8_registers
