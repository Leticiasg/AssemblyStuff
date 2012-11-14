@ este arquivos contem a implementacao das estruturas referentes
@ a pilha de processos

@----------------------------@
@                            @
@        CONSTANTS           @
@                            @
@----------------------------@

.equ WAITING, 0
.equ READY, 1
.equ RUNNING, 2

.global WAITING
.global READY
.global RUNNING
 

.equ SVC_MODE, 0
.equ USR_MODE, 1

.global SVC_MODE
.global USR_MODE

  .align 4
  .data

@ Vector of pointers to the beginning of the user stack pointer
usr_sp:
  .word USR_STACK1, USR_STACK2, USR_STACK3, USR_STACK4, USR_STACK5,USR_STACK6, USR_STACK7, USR_STACK8
.global usr_sp

@ Vector of pointers to the beginning of the supervisor stack pointer
svc_sp:
  .word SVC_STACK1, SVC_STACK2, SVC_STACK3, SVC_STACK4, SVC_STACK5,  SVC_STACK6, SVC_STACK7, SVC_STACK8
.global svc_sp

@-----------------------------@
@                             @
@      Process Queue          @
@                             @
@-----------------------------@

  .align 4
  .global exec_mode
exec_mode:
  .byte USR_MODE, USR_MODE, USR_MODE, USR_MODE, USR_MODE, USR_MODE, USR_MODE, USR_MODE

  .align 4
  .global PID
@ Process ID dos processos
PID: 
  .byte 1,2,3,4,5,6,7,8

        
  .align 4
  .global process_status
@ Status de execucao do processo
process_status: 
  .byte 0,0,0,0,0,0,0,0

  .align 4
  .global usr_registers
@ Apontadores para o vetor de registradores do modo user
usr_registers:
  .word  usr1_registers,usr2_registers,usr3_registers,usr4_registers,usr5_registers,usr6_registers,usr7_registers,usr8_registers
  
   .global svc_registers
@ Apontador para o vetor de registradores do modo supervisor
svc_registers: 
  .word svc1_registers,svc2_registers,svc3_registers,svc4_registers,svc5_registers,svc6_registers,svc7_registers,svc8_registers

  .global usr1_registers
  .global usr2_registers
  .global usr3_registers
  .global usr4_registers
  .global usr5_registers
  .global usr6_registers
  .global usr7_registers
  .global usr8_registers     
@ Vetor de registers do modo user
usr1_registers: 
  .fill 13, 4, 0   @ salva r0-r12 
  .word USR_STACK1 @ inicializa o sp (r13)
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
usr2_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK2 @ inicializa o sp (r13)
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
usr3_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK3 @ inicializa o sp (r13)
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
usr4_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK4 @ inicializa o sp (r13)
   .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
usr5_registers:  
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK5 @ inicializa o sp (r13)
   .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
usr6_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK6 @ inicializa o sp (r13)
   .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
usr7_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK7 @ inicializa o sp (r13)
   .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
usr8_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word USR_STACK8 @ inicializa o sp (r13)  
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10    @ salva cpsr
    
  .global svc1_registers
  .global svc2_registers
  .global svc3_registers
  .global svc4_registers
  .global svc5_registers
  .global svc6_registers
  .global svc7_registers
  .global svc8_registers       
@ vetor de registers do modo supervisor
svc1_registers: 
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK1 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
svc2_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK2 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
svc3_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK3 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
svc4_registers: 
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK4 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
svc5_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK5 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
svc6_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK6 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
svc7_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK7 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
svc8_registers:
  .fill 13, 4, 0   @ salva r0-r12
  .word SVC_STACK8 @ inicializa o sp (r13) para o modo supervisor
  .fill 1, 4, 0    @ salva r14
  .word main       @ salva pc
  .word 0x10
  .fill 1, 4, 0    @ salva cpsr, spsr
