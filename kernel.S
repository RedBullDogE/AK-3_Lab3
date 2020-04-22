.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

#define A #3
#define B #17
#define C #7

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
	result: .asciz "Result value in R0: "

.section .text
__kernel_reset__:
	mov r0, #0
	ldr r0, =data
	bl dbgput_line
	
	// Calculation
	mov r1, A
	mov r2, B
	mov r3, C
	
	sub r4, r1, r2		// (a-b)
	cmp r4, #0			

	ite ge				// if (a-b) >= 0
	addGE r0, r1, r2	// res = a + b
	subLT r0, r1, r2	// res = a - b

	sdiv r4, r0, r3		// res = res / c

	ldr r0, =result
	bl dbgput
	mov r0, r4
	bl dbgput_num

	end:
	b end
