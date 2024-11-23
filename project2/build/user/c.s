	.file	"c.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"I am the c program\n"
	.text
.globl main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$16, %esp
	movl	$.LC0, (%esp)
	call	Print_String
	movl	$-1, %eax
#APP
# 15 "../src/user/c.c" 1
	int $0x90
# 0 "" 2
#NO_APP
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
