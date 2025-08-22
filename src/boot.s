SECTION .multiboot
align 4
  dd 0x1BADB002           ; magic number
  dd 0x00                 ; flags
  dd -(0x1BADB002 + 0x00) ; checksum

SECTION .text 
global _start
_start:
  ; Set up stack 
  mov esp, stack_top

  ; Call kernel main 
  extern kernel_main
  call kernel_main

.hang:
  hlt
  jmp .hang

SECTION .bss
align 16
stack_bottom:             ; 16kb stack
  resb 16384              
stack_top:
