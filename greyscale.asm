.data

    # input file
    inputFile: .asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/images/original/jet_64_in_ascii_crlf.ppm"
    inputText: .space  100000
    # output file
    outputFile: .asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/images/output/output.ppm"
    outputText: .space 100000  
  
.text
.globl main

main:
    # opening the file
    # opening the input file 
        li $v0, 13        
        la $a0, inputFile
        li $a1, 0 
        li $a2,0          
        syscall
        move $s0, $v0       # Save file descriptor in $s0

    # opening the output file
    li $v0, 13
    la $a0, outputFile
    li $a1, 1
    li $a2, 0
    syscall
    move $s1, $v0 

    # reading input file content into inputText
    li $v0, 14
    move $a0, $s0
    la $a1, inputText
    li $a2, 100000
    syscall

    #   initialize the variables
    la $s2, inputText 
    la $s3, outputText
    la $s4, outputText
    li $t1, 1 # Counter
