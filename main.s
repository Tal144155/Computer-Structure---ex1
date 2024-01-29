##326529138 Tal Ariel Ziv
.extern printf
.extern scanf
.extern srand
.extern rand

.section .data
user_seed:
    .int 0x0
user_number:
    .int 0x0    

.section .rodata
user_seed_choice:
    .string "Enter configuration seed: "
user_guess_line:
    .string "What is your guess? "
won:
    .string "Congratz! You won!\n"
incorrect:
    .string "Incorrect.\n"
lost:
    .string "Game over, you lost :(. The correct answer was %d\n"
scanf_fmt:
    .string "%d"

.section .text
.globl main
.type	main, @function
main:
    # Enter
    pushq %rbp
    movq %rsp, %rbp

    # Print the entring line
    movq $user_seed_choice, %rdi #line inside rdi
    xorq %rax, %rax #return value register set to zero
    call printf #print func called

    # Read the number
    movq $scanf_fmt, %rdi
    movq $user_seed, %rsi
    xorq %rax, %rax
    call scanf

    #reset seed for random
    movq user_seed, %rdi
    xorq %rax, %rax
    call srand

    #get random number to %rax
    xorq %rax, %rax
    call rand

    #modulu number by 10
    xorq %rdx, %rdx #preparing the higher bits to be zero
    movq $10, %rbx
    divq %rbx

    #prepare counter for loop
    movq $0, %r12

    ##moving random number to r13
    movq %rdx, %r13

.loop:
    ##check loop condition
    cmpq $0x5, %r12
    je .done_loop

    ##print line to get user guess
    movq $user_guess_line, %rdi
    xorq %rax, %rax 
    call printf

    ##scan user guess
    movq $scanf_fmt, %rdi
    movq $user_number, %rsi
    xorq %rax, %rax
    call scanf

    ##compare number user entered and random one
    cmpq user_number, %r13
    je .good_guess

    ##guess was wrong, print message
    movq $incorrect, %rdi
    xorq %rax, %rax
    call printf

    #increment counter by one
    incq %r12
    jmp .loop


.good_guess:
    movq $won, %rdi
    xorq %rax, %rax
    call printf
    jmp .exit

.done_loop:
    # Print lost line
    movq $lost, %rdi
    movq %r13, %rsi
    xorq %rax, %rax
    call printf
    jmp .exit

.exit:
    # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
    