# Image processing is the manipulation of images

## Getting Started

Operating system used: Windows

## How to run the program

The process of running the program increase_brightness and greysale is the same.

1. Specify the path to the original images as shows below:

***Note:*** The original images are in the folder: images/original

```asm
.data
    #  input file
    inputFile: .asciiz "path from root/Mips Image processing/images/original/jet_64_in_ascii_crlf.ppm"

```

2. Specify the path to the output images as shows below:

***Note:*** The output images will be in the folder: images/output

```asm
  # output file
    outputFile:.asciiz "path from the root/Mips Image processing/wow.ppm" 
```

## Outputs 
The outputs of the program are in the folder: images/output