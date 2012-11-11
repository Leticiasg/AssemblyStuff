@ This file starts external modules of the ARM processor
@ and starts os related things like the stack

@---------------------------------@
@                                 @
@           CONSTANTS             @
@                                 @
@---------------------------------@

  .align 4

@ Registers of GPT
.equ GPT_CR, 0x53FA0000
.equ GPT_OCR1, 0x53FA0010
.equ GPT_IR, 0x53FA000C
.equ GPT_SR, 0x53FA0008

@ GPT Controler Constants
.equ ENABLE_GPT_CR, 0x00000041
.equ MAX_CYCLES, 100

@ TZIC control constants
.equ TZIC_BASE, 0x0FFFC000
.equ TZIC_INTCTRL, 0x0
.equ TZIC_INTSEC1, 0x84 
.equ TZIC_ESET1, 0x104
.equ TZIC_PRIOMASK, 0xC
.equ TZIC_PRIORITY9, 0x424

@ Configurable STACK values for each ARM core operation mode
@.equ UND_STACK, 0x7900
@.equ ABT_STACK, 0x7A00
@.equ IRQ_STACK, 0x7B00
@.equ FIQ_STACK, 0x7C00
@.equ USR_STACK1, 0x00010000 @ Begin of the stack from PID 1
@.equ SVC_STACK1, 0x0000F800 @ Begin of the stack from supervisor mode of PID 1
@.equ USR_STACK2, 0x0000F000 @ Begin of the stack from PID 2
@.equ SVC_STACK2, 0x0000E800 @ Begin of the stack from supervisor mode of PID 2
@.equ USR_STACK3, 0x0000E000 @ Begin of the stack from PID 3
@.equ SVC_STACK3, 0x0000D800 @ Begin of the stack from supervisor mode of PID 3
@.equ USR_STACK4, 0x0000D000 @ Begin of the stack from PID 4
@.equ SVC_STACK4, 0x0000C800 @ Begin of the stack from supervisor mode of PID 4
@.equ USR_STACK5, 0x0000C000 @ Begin of the stack from PID 5
@.equ SVC_STACK5, 0x0000B800 @ Begin of the stack from supervisor mode of PID 5
@.equ USR_STACK6, 0x0000B000 @ Begin of the stack from PID 6
@.equ SVC_STACK6, 0x0000A800 @ Begin of the stack from supervisor mode of PID 6
@.equ USR_STACK7, 0x0000A000 @ Begin of the stack from PID 7
@.equ SVC_STACK7, 0x00009800 @ Begin of the stack from supervisor mode of PID 7
@.equ USR_STACK8, 0x00009000 @ Begin of the stack from PID 8
@.equ SVC_STACK8, 0x00008800 @ Begin of the stack from supervisor mode of PID 8
  
UND_STACK:
  .fill 0x100, 1, 0
ABT_STACK:
  .fill 0x100, 1, 0
IRQ_STACK:
  .fill 0x100, 1, 0
FIQ_STACK:
  .fill 0x100, 1, 0
USR_STACK1:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 1
SVC_STACK1:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 1
USR_STACK2:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 2
SVC_STACK2:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 2
USR_STACK3:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 3
SVC_STACK3:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 3
USR_STACK4:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 4
SVC_STACK4:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 4
USR_STACK5:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 5
SVC_STACK5:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 5
USR_STACK6:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 6
SVC_STACK6:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 6
USR_STACK7:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 7
SVC_STACK7:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 7
USR_STACK8:
  .fill 0x800, 1, 0 @ Begin of the stack from PID 8
SVC_STACK8:
  .fill 0x800, 1, 0 @ Begin of the stack from supervisor mode of PID 8
        
.global USR_STACK1
.global SVC_STACK1
.global USR_STACK2
.global SVC_STACK2
.global USR_STACK3
.global SVC_STACK3
.global USR_STACK4
.global SVC_STACK4
.global USR_STACK5
.global SVC_STACK5
.global USR_STACK6
.global SVC_STACK6
.global USR_STACK7
.global SVC_STACK7
.global USR_STACK8
.global SVC_STACK8
       
@ UART control Constants
.equ UART1_UTXD, 0x53FBC040
.equ UART1_UCR1, 0x53FBC080
.equ UART1_UCR2, 0x53FBC084
.equ UART1_UCR3, 0x53FBC088
.equ UART1_UCR4, 0x53FBC08C
.equ UART1_UFCR, 0x53FBC090
.equ UART1_UBIR, 0x53FBC0A4
.equ UART1_UBMR, 0x53FBC0A8
.equ UART1_USR1, 0x53FBC094
.equ UART1_TRDY, 0x2000

@ Global constants
.global GPT_SR
.global UART1_USR1
.global UART1_TRDY
.global UART1_UTXD

@---------------------------------@
@                                 @
@               GPT               @
@                                 @
@---------------------------------@
  
  .align 4
  .global Start_GPT

Start_GPT:
  @ Configure
  ldr r0, =GPT_CR
  ldr r1, =ENABLE_GPT_CR
  str r1, [r0]
  
  @ Store 100 in register
  ldr r0, =GPT_OCR1
  ldr r1, =MAX_CYCLES
  str r1, [r0]

  @ Enable interuption Output Compare Channel 1
  ldr r0, =GPT_IR
  mov r1, #1
  str r1, [r0]

  mov pc, lr

@---------------------------------@
@                                 @
@              TZIC               @
@                                 @
@---------------------------------@

  .align 4
  .global Start_TZIC

Start_TZIC:
  @ Liga o controlador de interrupções
  @ R1 <= TZIC_BASE
  ldr r1, =TZIC_BASE
  @ Configura interrupção 39 do GPT como não segura
  mov r0, #(1 << 7)
  str r0, [r1, #TZIC_INTSEC1]
  @ Habilita interrupção 39 (GPT)
  @ reg1 bit 7 (gpt)
  mov r0, #(1 << 7)
  str r0, [r1, #TZIC_ESET1]
  @ Configure interrupt39 priority as 1
  @ reg9, byte 3
  ldr r0, [r1, #TZIC_PRIORITY9]
  bic r0, r0, #0xFF000000
  mov r2, #1
  orr r0, r0, r2, lsl #24
  str r0, [r1, #TZIC_PRIORITY9]
  @ Configure PRIOMASK as 0
  eor r0, r0, r0
  str r0, [r1, #TZIC_PRIOMASK]
  @ Habilita o controlador de interrupções
  mov r0, #1
  str r0, [r1, #TZIC_INTCTRL]

  mov pc, lr

@---------------------------------@
@                                 @
@              STACK              @
@                                 @
@---------------------------------@

@ Starts the stack with parameters of the process
@ of PID 1

  .align 4
  .global Start_Stack

Start_Stack:
  @ First configure stacks for all modes
  msr CPSR_c, #0x13 @ SUPERVISOR mode, IRQ/FIQ enabled
  ldr sp, =SVC_STACK1 
  msr CPSR_c, #0xDF @ Enter system mode, FIQ/IRQ disabled
  ldr sp, =USR_STACK1
  msr CPSR_c, #0xD1 @ Enter FIQ mode, FIQ/IRQ disabled
  ldr sp, =FIQ_STACK
  msr CPSR_c, #0xD2 @ Enter IRQ mode, FIQ/IRQ disabled
  ldr sp, =IRQ_STACK
  msr CPSR_c, #0xD7 @ Enter abort mode, FIQ/IRQ disabled
  ldr sp, =ABT_STACK
  msr CPSR_c, #0xDB @ Enter undefined mode, FIQ/IRQ disabled
  ldr sp, =UND_STACK
  msr CPSR_c, #0x1F @ Enter system mode, IRQ/FIQ enabled

  mov pc, lr

@---------------------------------@
@                                 @
@              UART               @
@                                 @
@---------------------------------@

  .align 4
  .global Start_UART

Start_UART:
@Enable the UART.
  ldr r0, =UART1_UCR1
  ldr r1, =0x0001
  str r1, [r0]
@Set hardware flow control, data format and enable transmitter and receiver.
  ldr r0, =UART1_UCR2
  ldr r1, =0x2127
  str r1, [r0]
@ Set UCR3[RXDMUXSEL] = 1.
  ldr r0, =UART1_UCR3
  ldr r1, =0x0704
  str r1, [r0]
@ Set CTS trigger level to 31,
  ldr r0, =UART1_UCR4
  ldr r1, =0x7C00
  str r1, [r0]
@ Set internal clock divider = 5 (divide input uart clock by 5). So the reference clock is 100MHz/5 = 20MHz.
  ldr r0, =UART1_UFCR
  ldr r1, =0x089E
  str r1, [r0]
@ Start UBIR
  ldr r0, =UART1_UBIR
  ldr r1, =0x08FF
  str r1, [r0]
@ In the above two steps, set baud rate to 921.6Kbps based on the 20MHz reference clock.
  ldr r0, =UART1_UBMR
  ldr r1, =0x0C34
  str r1, [r0]

  mov pc, lr

@---------------------------------@
@                                 @
@            Process              @
@                                 @
@---------------------------------@

  .align 4
  .global Start_process

Start_process:
  stmfd sp!, {r4-r11,lr}

  ldr r5, =process_status
  mov r4, #2
  strb r4, [r5]

  ldmfd sp!, {r4-r11, pc}
