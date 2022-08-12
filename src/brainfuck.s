.data

ARR:	.zero 100000

.text

.global brainfuck

format_str: .asciz "We should be executing the following code:\n%s"
aasa: .asciz "AAAAAAAAA"
FORMAT: 	.asciz "%c"

# The brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
brainfuck:
	pushq 	%rbp
	movq 	%rsp, %rbp

	pushq  	%r15
	pushq	%r14 
	pushq 	%r13			# We'll be using %r13 to hold the instruction pointed at by %r15
	pushq 	%r12			# We'll be using %r12 as a flag register
	#pushq 	%r11			# We'll be using %r11 as the loop nest counter
	#pushq 	%r10

	movq 	$0, %r10
	movq 	$0, %r11
	movq 	$0, %r12
	movq 	%rdi, %r15 		# We'll be using %r15 as our instruction pointer
	movq 	$ARR, %r14		# We'll be using %r14 as our data pointer


	scanInstruction:
	movq 	(%r15), %r13

	cmp 	$0x5B, %r13b
	je 		beginLoop
	cmp		$0x5D, %r13b
	je 		endLoop
	
	cmp 	$0, %r12
	jg		endScanInstruction
	
	cmp		$0x00, %r13b
	je 		endRoutine
	cmp		$0x3E, %r13b
	je  	moveRight
	cmp 	$0x3C, %r13b
	je 		moveLeft
	cmp		$0x2B, %r13b
	je		incrementCell
	cmp		$0x2D, %r13b
	je		decrementCell
	cmp		$0x2E, %r13b
	je 		outputDataPointer
	cmp 	$0x2C, %r13b
	je 		inputDataPointer
	jmp		endScanInstruction

	endScanInstruction:
	incq 	%r15
	je 	yes
	jmp 	scanInstruction

	moveRight:
	incq 	%r14
	jmp		endScanInstruction

	moveLeft:
	decq	%r14
	jmp		endScanInstruction

	incrementCell:
	addq	$1, (%r14)
	jmp 	endScanInstruction

	decrementCell:
	cmpq 	$0, (%r14)
	je 		endScanInstruction
	subq	$1, (%r14)
	jmp		endScanInstruction

	outputDataPointer:
	movq 	(%r14), %rsi
	shl 	$56, %rsi
	shr 	$56, %rsi
	movq 	$FORMAT, %rdi
	movq 	$0, %rax
	pushq 	%r11
	call 	printf
	popq 	%r11
	jmp 	endScanInstruction

	inputDataPointer:
	
	movq $0, %rax
	movq 	%rbp, %r12
	subq %rsp, %r12
	movq 	%r12, %rax
	movq 	$0, %r12
	movq 	$0, %rdx
	movq 	$16, %r12
	idiv 	%r12
	movq 	$0, %r12
	cmpq $0, %rdx
	jne   insertY
	aaadd:
	subq $16, %rsp
	movq $FORMAT, %rdi
	#pushq %r11
	leaq 8(%rsp), %rsi
	#movq $0, %rsi
	movq $0, %rax
	call scanf

	movq 8(%rsp), %rsi
	movq %rsi, %r10
	addq $16, %rsp
	cmpq $0, %r12
	jne revert

	thened:
	movq %r10, (%r14)
	jmp endScanInstruction

	insertY:
	movq $1, %r12
	pushq %r12
	jmp aaadd

	revert:
	popq %r12
	movq $0, %r12
	jmp thened

	beginLoop:
	addq 	$1, %r11
	cmpq 	$0, %r12
	jg		endScanInstruction
	movq 	(%r14), %r13
	cmp 	$0x00, %r13b
	je 		skipLoop
	subq 	$1, %r15
	pushq 	%r15
	addq 	$1, %r15
	jmp 	endScanInstruction
	 				
	skipLoop:
	movq 	%r11, %r12				# Get the "loop index" of the loop to know when to stop skipping instructions; %r12 != 0 means the "skip" flag is true
	jmp 	endScanInstruction

	endLoop:
	cmpq 	$0, %r12
	jg	 	skipEndLoop
	movq 	(%r14), %r13
	cmp 	$0, %r13b
	je		endLoopNormal
	popq	%r12				# This will be the address of the instruction we have to go to in order to begin the loop again
	movq 	%r12, %r15
	movq 	$0, %r12
	subq	$1, %r11
	jmp 	endScanInstruction

	skipEndLoop:
	cmpq 	%r12, %r11
	je 		endLoopSkip
	subq	$1, %r11
	jmp endScanInstruction

	endLoopNormal:
	popq	%r12				# This will be the address of the instruction we have to go to in order to begin the loop again
	movq 	$0, %r12
	subq	$1, %r11
	jmp 	endScanInstruction

	endLoopSkip:
	movq 	$0, %r12
	subq	$1, %r11
	jmp		endScanInstruction


	yes:
	movq 	$aasa, %rdi
	movq 	$0, %rax
	call printf
	jmp		endScanInstruction

	endRoutine:
	popq 	%r12
	popq 	%r13
	popq 	%r14
	popq 	%r15

	movq 	%rbp, %rsp
	popq 	%rbp
	ret
