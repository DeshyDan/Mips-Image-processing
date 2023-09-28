 .data
    #  input file
    inputFile: .asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/test.txt" 
    inputText: .space 4096
    headerInfo: .space 1000
    outputText: .space 1000
    # output file
    outputFile:.asciiz "C:/Users/Deshy Dan/OneDrive - University of Cape Town/2023/2nd semester/CSC2002S/Mips Image processing/out.txt" 
    outputBuffer: .space 4096
    bufferLength: .word 100
    # descriptors
    inputFileDescriptor: .word 0   
    outputFileDescriptor: .word 0 
    # pixel totals 
    oldPixelTotal: .word 0   # allocate a word for the old pixel total
    newPixelTotal: .word 0   # allocate a word for the new pixel total

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
    li $a2, 4096
    syscall


    # Todo: Add code for printing the header

######################################pixel calculation project######################################
    li $t2 , 0 # original pixel total
    li $t3 , 0 # new pixel total
    li $t4 , 0 # counter
    la $t5 , inputText # input text contianer
    move $t6, $zero # stores the integer
    li $t7 , 10
    
    j computeLines
######################################Looping over each pixel in the line######################################
computeLines:
    
    lb $s0 , 0($t5)    
    addi $t5 , $t5, 1
    
    beq $s0 , 10, computePixel  # checks for end of line
  
    li $v0, 11           # load syscall for print_character
    move $a0, $s0        # move the character to $a0
    syscall  
    beq $s0 , $zero , endComputeLines # when finished looping over each pixel
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
    add $t3 , $t3 , $t6 # addding to the new pixel total
     # save the old and new pixel totals in memory
    sw $t2, oldPixelTotal  # store the old pixel total in memory
    sw $t3, newPixelTotal  # store the new pixel total in memory

    li $v0 , 1
    move $a0 , $t6 
    syscall
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

# addi $t3, $t3, 1       # Move to the next character

# # Null-terminate the string
# la $t2, $zero              # Null-terminate character (ASCII value 0)
sb $zero, ($t3)          # Store the null-terminate character in the string

# copy_loop:
#     lb $t2, ($t0)         # Load a character from the string
#     sb $t2, ($t3)         # Store the character in the buffer
#     addi $t0, $t0, 1      # Move to the next character in the string
#     addi $t3, $t3, 1      # Move to the next character in the buffer
#     beqz $t2, copy_done   # If we've reached the null-terminator, we're done
#     j copy_loop

copy_done:
   li $v0 , 4
    move $a0 , $t3
    syscall
    li $t2, 10            # Load the ASCII code for the newline character into $t2
    sb $t2, ($t3)         # Store the newline character in the buffer
    li $v0 , 4
    move $a0 , $t3
    syscall

    # Load the address of the output buffer into $a0
    la $a0, outputBuffer
    
    # # Load the length of the buffer into $a1
    # la $a1, bufferLength

    # # Load the current length of the buffer into $a2
    # la $t0, bufferLength
    # sub $a2, $t0, $a1

    # # Add the length of the value to append to the current length of the buffer
    # add $a1, $a1, $t3

    # # Append the value to the buffer
    # add $a2, $a2, $t3

  



   

    ################Writing to the output file############################
    # li $v0, 15
    # move $a0 , $t1
    # move $a1 , $t6
    # li $a2, 4
    # syscall
    ######################################################################
    move $t6, $zero # restoring the integer back to 0 
        # load the old and new pixel totals from memory
    lw $t2, oldPixelTotal  # load the old pixel total from memory
    lw $t3, newPixelTotal  # load the new pixel total from memory
    j computeLines

endComputeLines:

    lw $t1, outputFileDescriptor 

    li $v0, 15        # load syscall for write
    move $a0,$t1      # move the file descriptor to $a0
    la $a1, outputBuffer    # move the address of the string to $a1
    li $a2, 4096         # set $a2 to 4 to indicate writing 32 bytes
    syscall
    li $v0, 1
    move $a0 , $t6
    syscall
    j closeFiles
######################################String to integer function  ######################################
    
# stringToInt:
#     lb $a0 , 0($s0)
#     addi $t5 , $t5, 1
#     beq $a0, 0, endStringToInt
#     addi $s1, $a0, -48
#     mul $t6, $t6, $t7
#     add $t6, $t6, $s1
#     j stringToInt


############################################################################################################
    

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
    
