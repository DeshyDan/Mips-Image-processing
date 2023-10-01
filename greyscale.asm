.data
    # input file
    inputFile: .asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/images/original/jet_64_in_ascii_crlf.ppm"
    # output file
    outputFile: .asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/images/output/output.ppm"
    inputText: .space  100000
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
    move $s0, $v0       

    #  opening the output file
    li $v0, 13
    la $a0, outputFile
    li $a1, 1 
    li $a2, 0
    syscall
    move $s1, $v0

    #reading the input text into a buffer
    li $v0, 14
    move $a0, $s0
    la $a1, inputText
    li $a2, 100000
    syscall

##################Initilizing the variables##################
    la $s2, inputText 
    la $s3, outputText
    la $s4, outputText
    li $t1, 1 
    
    li $t2, 80  
    sb $t2, ($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 1
    li $t2, 50
    sb $t2, ($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 1

    # adding a new line 
    li $t2, 10
    sb $t2, ($s3)
    addi $s2, $s2, 1
    addi $s3, $s3, 1



##################Reading the header##################
readHeader:
    lb $t2,($s2)
    sb $t2,($s3)

    addi $s3,$s3,1
    addi $s2,$s2,1

    #beq $t2,13,newline
    beq $t2,10,computeLine
    j readHeader

computeLine:
    addi $t1,$t1,1 # count the number of lines
    beq $t1,4,pixelCompute #start reading the pixel values

    j readHeader

pixelCompute:
    li $t4, 0 
    li $t1, 0 
    li $t3, 0 
    li $t5, 0 
    li $t6, 0 

stringToInt:

    lb $t2,($s2)

    beq $t2,10,Line # if the value is a new line
    beq $t2,0,writeHeader # if the value is a null terminator
    sub $t2, $t2, 48
    mul $t4, $t4, 10
    add $t4, $t4, $t2
    addi $s2, $s2, 1
    j stringToInt


Line:
    addi $s2, $s2, 1
    addi $t3, $t3, 1
    add $t5, $t5, $t4
    li $t4,0

    beq $t3, 3, calcAvg
    j stringToInt

    calcAvg:
    addi $t6, $t6, 1
    beq $t6, 4097, writeHeader

    divu$t5,$t5,3
    mflo $t4

    blt $t4 ,100 ,ADD1
    addi $s3 , $s3, 3 
    li $t8 ,10
    sb $t8 ,($s3)
    j intToString

    ADD1:
    blt $t4,10,nAD # if the value is less than 10
    addi $s3,$s3,2 
    li $t8,10 # adding a new line
    sb $t8,($s3) 
    j intToString

    nADD:
    addi $s3,$s3,1 # moving the pointer to the left
    li $t8,10   # adding a new line
    sb $t8,($s3) # adding a new line
    j intToString # convert the integer to a string


intToString:
    beqz $t4, end   
    divu $t4, $t4, 10     
    mfhi $t3             
    addi $t3, $t3, 48 
    sb $t3, -1($s3)       
    addi $s3, $s3, -1 # moving the pointer to the left
    addi $t1,$t1,1

    j intToString


end:
    add $s3,$s3,$t1
    addi $s3,$s3,1
    li $t1,0
    li$t3,0
    li $t5,0

    j stringToInt

writeHeader:
    sb $t2,($s3)
    sub $s4,$s3,$s4

    # writing the output file
    li $v0, 15
    move $a0, $s1
    la $a1, outputText
    move $a2, $s4
    syscall

close:
# closing the ifles
    li $v0, 16        
    move $a0, $s0     
    syscall

    li $v0, 16         
    move $a0, $s1       
    syscall
    j exit

exit:
    li $v0, 10          
    syscall