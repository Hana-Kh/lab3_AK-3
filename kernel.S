.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

#define A #2
#define B #4
#define C #5

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector

vtable_kernel:
	.word __stack_start
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel

.section .rodata

	data: .asciz "kernel started!\n"
	final: .asciz "Result value in register #3: "
    
.section .text

__kernel_reset__:
	ldr r0, =data
	bl dbgput_line

// calculate
	mov r0, A
	add r0, B	// A + B
	lsr r1, r0, #1	// (A + B)/2
	mov r0, #1
	mov r2, C
	bl f_func 	// C!
	add r3, r0, r1	// (A + B)/2 + C!

	ldr r0, =final
	bl dbgput
	mov r0, r3
	bl dbgput_num
    
end:
	b end
	
f_func:
	push {lr}
.start:
	mul r0, r2
	subs r2, #1
	bne .start
	pop {pc}
