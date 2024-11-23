	.file	"shell.c"
	.text
.globl Strip_Leading_Whitespace
	.type	Strip_Leading_Whitespace, @function
Strip_Leading_Whitespace:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movzbl	(%eax), %edx
	cmpb	$32, %dl
	je	.L7
	cmpb	$9, %dl
	jne	.L2
.L7:
	addl	$1, %eax
	movzbl	(%eax), %edx
	cmpb	$32, %dl
	je	.L7
	cmpb	$9, %dl
	je	.L7
.L2:
	popl	%ebp
	.p2align 4,,2
	ret
	.size	Strip_Leading_Whitespace, .-Strip_Leading_Whitespace
.globl Copy_Token
	.type	Copy_Token, @function
Copy_Token:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	8(%ebp), %ebx
	movl	12(%ebp), %eax
	movzbl	(%eax), %edx
	cmpb	$32, %dl
	je	.L20
	cmpb	$9, %dl
	jne	.L9
.L20:
	addl	$1, %eax
	movzbl	(%eax), %edx
	cmpb	$32, %dl
	je	.L20
	cmpb	$9, %dl
	je	.L20
.L9:
	movzbl	(%eax), %edx
	testb	%dl, %dl
	je	.L12
	cmpb	$32, %dl
	.p2align 4,,3
	je	.L12
	cmpb	$9, %dl
	.p2align 4,,3
	je	.L12
	movl	%ebx, %ecx
.L14:
	movb	%dl, (%ecx)
	addl	$1, %ecx
	addl	$1, %eax
	movzbl	(%eax), %edx
	testb	%dl, %dl
	je	.L13
	cmpb	$32, %dl
	je	.L13
	cmpb	$9, %dl
	jne	.L14
	.p2align 4,,7
	.p2align 3
	jmp	.L13
.L12:
	movl	%ebx, %ecx
.L13:
	movb	$0, (%ecx)
	cmpb	$1, (%ebx)
	sbbl	%edx, %edx
	notl	%edx
	andl	%edx, %eax
	popl	%ebx
	popl	%ebp
	ret
	.size	Copy_Token, .-Copy_Token
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	"Error: pipes not supported yet\n"
	.align 4
.LC1:
	.string	"Error: I/O redirection not supported yet\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"Could not spawn process: %s\n"
.LC3:
	.string	"Exit code was %d\n"
	.text
.globl Spawn_Single_Command
	.type	Spawn_Single_Command, @function
Spawn_Single_Command:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	cmpl	$1, 12(%ebp)
	jle	.L22
	movl	$.LC0, (%esp)
	call	Print
	jmp	.L26
.L22:
	testb	$3, (%eax)
	je	.L24
	movl	$.LC1, (%esp)
	call	Print
	jmp	.L26
.L24:
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	244(%eax), %edx
	movl	%edx, 4(%esp)
	addl	$4, %eax
	movl	%eax, (%esp)
	call	Spawn_With_Path
	testl	%eax, %eax
	jns	.L25
	movl	%eax, (%esp)
	call	Get_Error_String
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	Print
	jmp	.L26
.L25:
	movl	%eax, (%esp)
	call	Wait
	cmpl	$0, exitCodes
	je	.L26
	movl	%eax, 4(%esp)
	movl	$.LC3, (%esp)
	call	Print
.L26:
	leave
	ret
	.size	Spawn_Single_Command, .-Spawn_Single_Command
	.section	.rodata.str1.1
.LC4:
	.string	"<>|"
	.section	.rodata.str1.4
	.align 4
.LC5:
	.string	"Error: invalid input redirection\n"
	.align 4
.LC6:
	.string	"Error: invalid output redirection\n"
	.section	.rodata.str1.1
.LC7:
	.string	"Error: invalid command\n"
.LC8:
	.string	""
	.section	.rodata.str1.4
	.align 4
.LC9:
	.string	"Error: too many commands in pipeline\n"
	.align 4
.LC10:
	.string	"Error: input redirection only allowed for first command\n"
	.align 4
.LC11:
	.string	"Error: output redirection only allowed for last command\n"
	.section	.rodata.str1.1
.LC12:
	.string	"Error: unterminated pipeline\n"
	.text
.globl Build_Pipeline
	.type	Build_Pipeline, @function
Build_Pipeline:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	8(%ebp), %eax
	movl	12(%ebp), %edi
	movl	$0, %esi
.L43:
	movl	%edi, -32(%ebp)
	movl	$0, (%edi)
	movl	%eax, (%esp)
	call	Strip_Leading_Whitespace
	movl	%eax, %ebx
	cmpb	$0, (%eax)
	je	.L28
	movl	$.LC4, 4(%esp)
	movl	%eax, (%esp)
	call	strpbrk
	testl	%eax, %eax
	je	.L29
	cmpb	$60, (%eax)
	jne	.L30
	orl	$1, (%edi)
	movb	$0, (%eax)
	addl	$1, %eax
	movl	%eax, 4(%esp)
	movl	-32(%ebp), %eax
	addl	$84, %eax
	movl	%eax, (%esp)
	call	Copy_Token
	testl	%eax, %eax
	jne	.L31
	movl	$.LC5, (%esp)
	call	Print
	movl	$-1, %esi
	jmp	.L32
.L31:
	movl	%eax, (%esp)
	call	Strip_Leading_Whitespace
	movl	%eax, -28(%ebp)
	movzbl	(%eax), %eax
	cmpb	$62, %al
	je	.L53
	cmpb	$124, %al
	jne	.L33
.L53:
	cmpl	$0, -28(%ebp)
	jne	.L35
	.p2align 4,,7
	.p2align 3
	jmp	.L33
.L30:
	movzbl	(%eax), %edx
	cmpb	$62, %dl
	sete	%cl
	.p2align 4,,3
	je	.L51
	movl	%ebx, -28(%ebp)
	cmpb	$124, %dl
	jne	.L33
.L51:
	movl	(%edi), %edx
	testb	%cl, %cl
	je	.L38
	orl	$2, %edx
	movl	%edx, (%edi)
	movb	$0, (%eax)
	addl	$1, %eax
	movl	%eax, 4(%esp)
	movl	-32(%ebp), %eax
	addl	$164, %eax
	movl	%eax, (%esp)
	call	Copy_Token
	testl	%eax, %eax
	je	.L39
	movl	%eax, -28(%ebp)
	jmp	.L33
.L39:
	movl	$.LC6, (%esp)
	call	Print
	movl	$-1, %esi
	jmp	.L32
.L33:
	movl	%ebx, 244(%edi)
	movl	%ebx, 4(%esp)
	movl	-32(%ebp), %eax
	addl	$4, %eax
	movl	%eax, (%esp)
	call	Copy_Token
	testl	%eax, %eax
	jne	.L40
	movl	$.LC7, (%esp)
	call	Print
	movl	$-1, %esi
	jmp	.L32
.L40:
	movl	$.LC8, %eax
	cmpl	%ebx, -28(%ebp)
	je	.L42
	movl	-28(%ebp), %eax
.L42:
	addl	$1, %esi
	addl	$264, %edi
	cmpl	$5, %esi
	jne	.L43
	cmpb	$0, (%eax)
	je	.L45
	jmp	.L55
.L28:
	testl	%esi, %esi
	.p2align 4,,7
	.p2align 3
	jg	.L45
	.p2align 4,,9
	.p2align 3
	jmp	.L32
.L55:
	movl	$.LC9, (%esp)
	call	Print
	movl	$-1, %esi
	jmp	.L32
.L50:
	movl	%edx, %ebx
	testl	%eax, %eax
	jle	.L46
	testb	$1, (%edx)
	.p2align 4,,3
	je	.L46
	movl	$.LC10, (%esp)
	call	Print
	movl	$-1, %esi
	jmp	.L32
.L45:
	movl	12(%ebp), %edx
	addl	$264, %edx
	movl	12(%ebp), %ebx
	movl	$0, %eax
	leal	-1(%esi), %ecx
	jmp	.L47
.L46:
	addl	$264, %edx
.L47:
	cmpl	%eax, %ecx
	jle	.L48
	testb	$2, (%ebx)
	je	.L48
	movl	$.LC11, (%esp)
	call	Print
	movl	$-1, %esi
	jmp	.L32
.L48:
	cmpl	%ecx, %eax
	jne	.L49
	testb	$4, (%ebx)
	.p2align 4,,5
	je	.L49
	movl	$.LC12, (%esp)
	call	Print
	movl	$-1, %esi
	jmp	.L32
.L49:
	addl	$1, %eax
	cmpl	%esi, %eax
	jl	.L50
.L32:
	movl	%esi, %eax
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L29:
	movl	%ebx, -28(%ebp)
	jmp	.L33
.L38:
	orl	$4, %edx
	movl	%edx, (%edi)
	movb	$0, (%eax)
	addl	$1, %eax
	movl	%eax, -28(%ebp)
	jmp	.L33
.L35:
	movl	-28(%ebp), %eax
	cmpb	$62, (%eax)
	sete	%cl
	jmp	.L51
	.size	Build_Pipeline, .-Build_Pipeline
.globl Trim_Newline
	.type	Trim_Newline, @function
Trim_Newline:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$10, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	strchr
	testl	%eax, %eax
	je	.L58
	movb	$0, (%eax)
.L58:
	leave
	ret
	.size	Trim_Newline, .-Trim_Newline
	.section	.rodata.str1.1
.LC13:
	.string	"\033[37m"
.LC14:
	.string	"\033[1;36m$\033[37m "
.LC15:
	.string	"exit"
.LC16:
	.string	"pid"
.LC17:
	.string	"%d\n"
.LC18:
	.string	"exitCodes"
.LC19:
	.string	"path="
.LC20:
	.string	"DONE!\n"
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
	subl	$1508, %esp
	movl	$792355631, 24(%esp)
	movl	$97, 28(%esp)
	leal	32(%esp), %edi
	movl	$18, %ecx
	movl	$0, %eax
	rep stosl
	movl	$.LC13, (%esp)
	call	Print
.L66:
	movl	$.LC14, (%esp)
	call	Print
	movl	$80, 4(%esp)
	leal	1424(%esp), %eax
	movl	%eax, (%esp)
	call	Read_Line
	leal	1424(%esp), %edx
	movl	%edx, (%esp)
	call	Strip_Leading_Whitespace
	movl	%eax, %ebx
	movl	%eax, (%esp)
	call	Trim_Newline
	movl	%ebx, %esi
	movl	$.LC15, %edi
	movl	$5, %ecx
	repz cmpsb
	seta	%dl
	setb	%al
	cmpb	%al, %dl
	je	.L60
	movl	%ebx, %esi
	movl	$.LC16, %edi
	movl	$4, %ecx
	repz cmpsb
	seta	%dl
	setb	%al
	cmpb	%al, %dl
	jne	.L61
	call	Get_PID
	movl	%eax, 4(%esp)
	movl	$.LC17, (%esp)
	call	Print
	jmp	.L66
.L61:
	movl	%ebx, %esi
	movl	$.LC18, %edi
	movl	$10, %ecx
	repz cmpsb
	seta	%dl
	setb	%al
	cmpb	%al, %dl
	jne	.L63
	movl	$1, exitCodes
	jmp	.L66
.L63:
	movl	%ebx, %esi
	movl	$.LC19, %edi
	movl	$5, %ecx
	repz cmpsb
	seta	%dl
	setb	%al
	cmpb	%al, %dl
	jne	.L64
	addl	$5, %ebx
	movl	%ebx, 4(%esp)
	leal	24(%esp), %eax
	movl	%eax, (%esp)
	call	strcpy
	jmp	.L66
.L64:
	cmpb	$0, (%ebx)
	je	.L66
	leal	104(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%ebx, (%esp)
	call	Build_Pipeline
	testl	%eax, %eax
	jle	.L66
	leal	24(%esp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	leal	104(%esp), %eax
	movl	%eax, (%esp)
	call	Spawn_Single_Command
	jmp	.L66
.L60:
	movl	$.LC20, (%esp)
	call	Print_String
	movl	$0, %eax
	addl	$1508, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	main, .-main
.globl exitCodes
	.bss
	.align 4
	.type	exitCodes, @object
	.size	exitCodes, 4
exitCodes:
	.zero	4
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
