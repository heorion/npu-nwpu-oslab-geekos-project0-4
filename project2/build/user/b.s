	.file	"b.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"I am the b program\n"
.LC1:
	.string	"Arg %d is %s\n"
	.text
.globl main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$20, %esp
	movl	8(%ebp), %edi
	movl	12(%ebp), %esi
	movl	$.LC0, (%esp)
	call	Print_String
	testl	%edi, %edi
	jle	.L2
	movl	$0, %ebx
.L3:
	movl	(%esi,%ebx,4), %eax
	movl	%eax, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	$.LC1, (%esp)
	call	Print
	addl	$1, %ebx
	cmpl	%ebx, %edi
	jg	.L3
.L2:
	movl	$1, %eax
	addl	$20, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
