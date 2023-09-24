 .data
    fileName: .asciiz "hey.txt" 
    buffer: .space 1024

.text 
main:
## opening the file for reading
    li $v0 , 13     # opening the file
    la $a0 , fileName
    li $a1 , 2      # reading the file
    li $a2 , 0
    syscall

    # savinghte file descriptor
    move $s0 , $v0 

    # reading from the file
    # li $v0 , 14     # call to read from file
    # move $a0 , $s0 
    # la $a1 , buffer 
    # li $a2 , 1024
    # syscall
    
    # Writing to the file
    # print the buffer
    li $v0 , 4
    la $a0 , buffer
    syscall

    j closeFile

closeFile:
li $v0 , 16
syscall
    