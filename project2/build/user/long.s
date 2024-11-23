	.file	"long.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Start Long\n"
.LC1:
	.string	"End Long\n"
	.text
.globl main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	pushl	%ebx
	subl	$28, %esp
	movl	$.LC0, (%esp)
	call	Print
	movl	$0, %ebx
.L2:
	call	Get_PID
	addl	$1, %ebx
	cmpl	$400, %ebx
	jne	.L2
	movl	$.LC1, (%esp)
	call	Print
	movl	$0, %eax
	addl	$28, %esp
	popl	%ebx
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
