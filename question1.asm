.data
    #  input file
    inputFile: .asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/images/house_64_in_ascii_crlf.ppm" 
    inputText: .space 80000
    headerInfo: .space 19
    outputText: .space 1000
    # output file
    outputFile:.asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/hello.ppm" 
    # descriptors
    inputFileDescriptor: .word 0   
    outputFileDescriptor: .word 0 
    # pixel totals 
    oldPixelTotal: .word 1   # allocate a word for the old pixel total
    newPixelTotal: .word 1   # allocate a word for the new pixel total

.text 
main:
    # opening the file
    # opening the input file 
    li $v0 , 13
    la $a0 , inputFile
    li $a1 , 0
    li $a2 , 0
    syscall

    sw $v0, inputFileDescriptor

    #opening the output file
    li $v0 , 13
    la $a0 , outputFile
    li $a1 , 1
    li $a2 , 0 
    syscall

    sw $v0, outputFileDescriptor

    # reading input file content into inputText
    lw $t0, inputFileDescriptor 
    li $v0 , 14
    move $a0 , $t0 
    la $a1, inputText
    li $a2, 80000
    syscall

    la $t5 , inputText # input text contianer
    # Todo: Add code for printing the header
    # Reading and writing the header
    li $t4 , 0 # counter
    la $t6, headerInfo

readHeader:
   beq $t4, 4, endReadHeader # when finished looping over header information
    lb $s0, 0($t5)     # load byte at memory address $t5 into $s0
    sb $s0, ($t6)      # store the character in $s0 at the memory address pointed to by $t6
    # print character in $so 
    li $v0, 11           # load syscall for print_character
    move $a0, $s0        # move the character to $a0
    syscall
    
    addi $t5, $t5, 1   # increment $t5 to move to next byte in memory
beq $s0, 10, writeHeader # checking for end of line
    addi $t6, $t6, 1   # increment $t6 to move to next byte in memory
    
    j readHeader
    
  

writeHeader:
    addi $t6, $t6, 1   # increment $t6 to move to next byte in memory
    li $t2, 0x0A            # Load the ASCII code for the newline character into $t2
    sb $t2, ($t6)         # Store the newline character in the buffer

    addi $t4, $t4 , 1 # increment counter
   
    j readHeader


endReadHeader:
sb $zero, ($t6)          # Store the null-terminate character in the string
 lw $t0, outputFileDescriptor 
    li $v0, 15          # system call for writing to a file
    move $a0, $t0    # move file descriptor to $a0
    la $a1, headerInfo     # load address of buffer to $a1
    li $a2, 18          # write 4 bytes (assuming $t3 contains a word)
    syscall             # write to the file
######################################pixel calculation project######################################
    li $t2 , 0 # original pixel total
    li $t3 , 0 # new pixel total
    li $t4 , 0 # counter
    move $t6, $zero # stores the integer
    li $t7 , 10
    
    j computeLines
######################################Looping over each pixel in the line######################################
computeLines:
    
    lb $s0 , 0($t5)    
    addi $t5 , $t5, 1
    beq $t4 , 12288 , endComputeLines
    beq $s0 , $zero , endComputeLines # when finished looping over each pixel
    beq $s0 , 10, computePixel  # checks for end of line
    beq $s0, -1, endComputeLines 
    li $v0, 11           # load syscall for print_character
    move $a0, $s0        # move the character to $a0
    syscall  
    
    addi $s1, $a0, -48
    mul $t6, $t6, $t7
    add $t6, $t6, $s1

    
    j computeLines

computePixel:
    addi $t4, $t4 , 1 # increment counter
    li $v0 , 1
    move $a0 , $t6 
    syscall
    
    add $t2 , $t2 , $t6  # adding to the original pixel total
    addi $t6 , $t6 , 10  
    bgt $t6, 255, limitValue
    j continueExecution

    limitValue:
    li $t6, 255

continueExecution:

    add $t3 , $t3 , $t6 # addding to the new pixel total
     # save the old and new pixel totals in memory
    sw $t2, oldPixelTotal  # store the old pixel total in memory
    sw $t3, newPixelTotal  # store the new pixel total in memory

    li $v0 , 1
    move $a0 , $t6 
    syscall
    nop 
    nop 
    bgt $t6, 100, greaterThanHundred
    li $t9 ,3
    j intToString

greaterThanHundred:
    li $t9 , 4
    j intToString

    intToString:
    # #####################Turning $t6 into string####################
    # Allocate space for the string
    li $v0, 9          # Load syscall for sbrk
    li $a0, 12         # Allocate 12 bytes for the string (assuming a 32-bit integer)
    syscall
    move $t0, $v0      # Save the address of the string in $t0
    addi $t3, $t0, 11  # Initialize $t3 to the last character in the string

    # Convert the integer to a string
    addi $t1, $zero, 10   # Initialize $t1 to 10
    addi $t2, $zero, 0    # Initialize $t2 to 0

intToString_loop:
    div $t6, $t1       # Divide $t6 by 10
    mfhi $t2            # Get the remainder
    addi $t2, $t2, 48   # Convert the remainder to an ASCII digit
    sb $t2, ($t3)       # Store the digit in the string
    addi $t3, $t3, -1   # Move to the next character
    mflo $t6
    bnez $t6, intToString_loop  # Repeat until $t6 is zero
# sb $zero, ($t3)          # Store the null-terminate character in the string
copy_done:
   li $v0 , 4
    move $a0 , $t3
    syscall
    li $t2, 0x0A            # Load the ASCII code for the newline character into $t2
    sb $t2, ($t3)         # Store the newline character in the buffer
    li $v0 , 4
    move $a0 , $t3
    syscall
    lw $t0, outputFileDescriptor 
    li $v0, 15          # system call for writing to a file
    move $a0, $t0    # move file descriptor to $a0
    la $a1, ($t3)       # load address of buffer to $a1
    move $a2, $t9           # write 4 bytes (assuming $t3 contains a word)
    syscall             # write to the file
    
    move $t6, $zero # restoring the integer back to 0 
        # load the old and new pixel totals from memory
    lw $t2, oldPixelTotal  # load the old pixel total from memory
    lw $t3, newPixelTotal  # load the new pixel total from memory
    j computeLines

endComputeLines:

   
    j closeFiles

    

closeFiles:
    lw $t0, inputFileDescriptor 
    lw $t1, outputFileDescriptor 
   
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