 .data
    #  input file
    inputFile: .asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/test.txt" 
    inputText: .space 11024
    # output file
    outputFile:.asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/out.txt" 
    

.text 
main:
    # opening the file
    # opening the input file 
    li $v0 , 13
    la $a0 , inputFile
    li $a1 , 0
    li $a2 , 0
    syscall

    move $t0 , $v0 

    #opening the output file
    li $v0 , 13
    la $a0 , outputFile
    li $a1 , 1
    li $a2 , 0 
    syscall

    move $t1 , $v0

    # reading input file content into inputText
    li $v0 , 14
    move $a0 , $t0 
    la $a1, inputText
    li $a2, 1024
    syscall





    # writing into output file
    li $v0 , 15
    move $a0 , $t1
    la $a1 , inputText
    li $a3 , 10 
    syscall

closeFiles:

    # closing the input file
    li      $v0, 16
    move    $a0, $t0
    syscall
    # closing the output file
    li      $v0, 16
    move 	$a0, $t1
    syscall
    j exit

exit:
    li $v0 , 10 
    syscall
    
