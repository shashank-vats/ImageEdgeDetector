@@@ SOBEL OPERATION @@

@@@ Change the size of matrix in data section as indicated @@@

@@@ Input text file is generated from image and again image is generated from text file using Matlab. @@@
@@@ The Matlab script is included with this file. @@@

@@@ Written in ARMv7 on ARMSim# @@@

@@@ takes an image in form of matrix as input, performs Sobel operation, and returns resultant image matrix
    .equ SWI_Open, 0x66            @ open a file
    .equ SWI_Close, 0x68           @ close a file
    .equ SWI_PrChr, 0x00           @ Write an ASCII char to Stdout
    .equ SWI_PrStr, 0x69           @ Write a null-ending string
    .equ SWI_PrStr, 0x69           @ Write a null-ending string
    .equ SWI_PrInt,0x6b            @ Write an Integer
    .equ SWI_RdInt,0x6c            @ Read an Integer from a file
    .equ Stdout, 1                 @ Set output target to be Stdout
    .equ SWI_Exit, 0x11            @ Stop execution
    
    
.global _start
.text

_start:
@ indicate that the program is started
    MOV R0,#Stdout                     @ print an initial message
    LDR R1, =Message1                  @ load address of Message1 label
    SWI SWI_PrStr                      @ display message to Stdout

@ == Open an input file for reading =============================
@ if problems, print message to Stdout and exit
TakeInput:
        LDR R0,=InFileName                 @ set Name for input file
        MOV R1,#0                          @ mode is input
        SWI SWI_Open                       @ open file for input
        BCS InFileError                    @ Check Carry-Bit (C): if= 1 then ERROR

    @ Save the file handle in memory:
        LDR R1,=InputFileHandle            @ if OK, load input file handle
        STR R0,[R1]                        @ save the file handle

    @ == Read size of matrix =============================
        LDR R9,=InputFileHandle
        LDR R9,[R9]
        MOV R0, R9                         @ load input file handle
        SWI SWI_RdInt                      @ read the integer into R0
        BCS CloseInputFile                 @ Check Carry-Bit (C): if= 1 then EOF reached

        LDR R1,=Length                     @ load length of matrix
        STR R0,[R1]                        @ save the length

        MOV R0, R9                         @ load input file handle
        SWI SWI_RdInt                      @ read the integer into R0
        BCS CloseInputFile                 @ Check Carry-Bit (C): if= 1 then EOF reached

        LDR R1,=Breadth                    @ load breadth of matrix
        STR R0,[R1]                        @ save the breadth


    @ == Read the matrix ==========================================
        LDR R5,=Length
        LDR R5,[R5]                        @ [R5] = length
        LDR R6,=Breadth                    @ [R6] = breadth
        LDR R6,[R6]
        LDR R8,=Mat
        MOV R3, #0                         @ [R3] = i = 0

        LoopOuter:
            CMP R3, R5                         @ compare R3 with length
            BEQ CloseInputFile                 @ if R3 equal to 0, jump to EofReached
            MOV R4, #0                         @ [R4] = j = 0

        LoopInner:
            CMP R4, R6                         @ compare R4 with breadth
            BEQ LoopInnerEnd                   @ if R4 equal to 0, jump to LoopInnerEnd
            MUL R7, R3, R6                     @ [R7] = i*breadth
            ADD R7, R7, R4                     @ [R7] = i*breadth + j
            @LSL R7, R7, #2                     @ [R7] = shift

            MOV R0, R9
            SWI SWI_RdInt                      @ [R0] = mat[i][j]
            ADD R7, R8, R7
            STRB R0, [R7]                       @ store R0 into mat[i][j]

            ADD R4, R4, #1                     @ j++
            B LoopInner

        LoopInnerEnd:
            ADD R3, R3, #1                     @ i++
            B LoopOuter

    @ == Close a file ===============================================
    CloseInputFile:
        LDR R0, =InputFileHandle           @ get address of file handle
        LDR R0, [R0]                       @ get value at address
        SWI SWI_Close

@ == Open an output file for writing =============================
@ if problems, print message to Stdout and exit
    LDR R0,=OutFileName                @ set name for output file
    MOV R1, #1                         @ set write mode
    SWI SWI_Open                       @ open the file
    LDR R1, =OutputFileHandle
    STR R0, [R1]                       @ save OutputFileHandle


initVerticalMask:
    LDR R0,=VerticalMask
    MOV R1, #-1
    STR R1, [R0, #0]
    MOV R1, #0
    STR R1, [R0, #4]
    MOV R1, #1
    STR R1, [R0, #8]
    MOV R1, #-2
    STR R1, [R0, #12]
    MOV R1, #0
    STR R1, [R0, #16]
    MOV R1, #2
    STR R1, [R0, #20]
    MOV R1, #-1
    STR R1, [R0, #24]
    MOV R1, #0
    STR R1, [R0, #28]
    MOV R1, #1
    STR R1, [R0, #32]

initHorizontalMask:
    LDR R0,=HorizontalMask
    MOV R1, #-1
    STR R1, [R0, #0]
    MOV R1, #-2
    STR R1, [R0, #4]
    MOV R1, #-1
    STR R1, [R0, #8]
    MOV R1, #0
    STR R1, [R0, #12]
    MOV R1, #0
    STR R1, [R0, #16]
    MOV R1, #0
    STR R1, [R0, #20]
    MOV R1, #1
    STR R1, [R0, #24]
    MOV R1, #2
    STR R1, [R0, #28]
    MOV R1, #1
    STR R1, [R0, #32]

Transform:
        LDR R4, =Length
        LDR R4, [R4]                   @ [R4] = length
        LDR R5, =Breadth
        LDR R5, [R5]                   @ [R5] = breadth
        @LDR r10, =Mat                  @ r10 = mat base address
        @LDR R11, =VerticalMask         @ R11 = Vertical Mask
        @LDR R12, =HorizontalMask       @ R12 = HorizontalMask
        MOV R0, #0                     @ i = 0
    SLoop1:
        MOV R1, #0                     @ j = 0
    SLoop2:
        MOV R7, #0                     @ sumX = 0
        MOV R8, #0                     @ sumY = 0
        SUB R2, R0, #1                @ k = i - 1
    SLoop3:
        SUB R3, R1, #1                @ m = j - 1
    SLoop4:
        SUBS R9, R2, #0
        BLT SLoop4End
        SUBS R9, R2, R4
        BGE SLoop4End 
        SUBS R9, R3, #0
        BLT SLoop4End
        SUBS R9, R3, R5
        BGE SLoop4End                  @ if (k < 0 or k >= length or m < 0 or m >= breadth)
                                       @ continue
        
        MUL R9, R2, R5                 @ k*breadth
        ADD R9, R9, R3                 @ k*breadth + m
        @LSL R9, R9, #2                 @ [R9] = position in matrix
        LDR r10, =Mat
        ADD R9, R9, r10                @ R9 = addr. of mat[k][m]
        LDRB R6, [R9]                   @ [R6] = mat[k][m]
        SUB R9, R2, R0                 @ [R9] = k - i
        ADD R9, R9, R9                 @ [R9] = 2*(k - i)
        ADD R9, R9, R2
        SUB R9, R9, R0                 @ [R9] = 3*(k - i)
        ADD R9, R9, R3
        SUB R9, R9, R1
        ADD R9, R9, #4                 @ [R9] = shift for [k - i + 1][m - j + 1]
        LSL R9, R9, #2
        LDR R11, =VerticalMask
        ADD R9, R9, R11                @ [R9] = addr. of VerticalMask[k - i + 1][m - j + 1]
        LDR R9, [R9]                   @ [R9] =  VerticalMask[k - i + 1][m - j + 1]
        MUL R9, R6, R9                 @ [R9] = Mat[k][m]*VerticalMask[k - i + 1][m - j + 1]
        ADD R7, R7, R9                 @ sumX += Mat[k][m]*VerticalMask[k - i + 1][m - j + 1]

        SUB R9, R2, R0                 @ [R9] = k - i
        ADD R9, R9, R9                 @ [R9] = 2*(k - i)
        ADD R9, R9, R2
        SUB R9, R9, R0                 @ [R9] = 3*(k - i)
        ADD R9, R9, R3
        SUB R9, R9, R1
        ADD R9, R9, #4                 @ [R9] = shift for [k - i + 1][m - j + 1]
        LSL R9, R9, #2
        LDR R12, =HorizontalMask
        ADD R9, R9, R12                @ [R9] = addr. of HorizontalMask[k - i + 1][m - j + 1]
        LDR R9, [R9]                   @ [R9] =  HorizontalMask[k - i + 1][m - j + 1]
        MUL R9, R6, R9                 @ [R9] = Mat[k][m]*HorizontalMask[k - i + 1][m - j + 1]
        ADD R8, R8, R9                 @ sumY += Mat[k][m]*HorizontalMask[k - i + 1][m - j + 1]

    SLoop4End:
        ADD R3, R3, #1                 @ m++
        ADD R9, R1, #1                 @ [R9] = j + 1
        SUBS R9, R3, R9
        BLE SLoop4                     @ if (m <= j + 1), loop

    SLoop3End:
        ADD R2, R2, #1                 @ k++
        ADD R9, R0, #1                 @ [R9] = i + 1
        SUBS R9, R2, R9
        BLE SLoop3                     @ if (k <= i + 1), loop
        
        MUL R7, R7, R7                 @ [R7] = sumX^2
        MUL R8, R8, R8                 @ [R8] = sumY^2
        ADD R7, R8, R7                 @ [R7] = sumX^2 + sumY^2
        VMOV S0, R7                    
        VCVT.F64.S32 D0, S0            @ [D0] = sumX^2 + sumY^2
        VSQRT.F64 D1, D0               @ [D1] = sqrt(sumX^2 + sumY^2)
        VCVT.S32.F64 S0, D1
        VMOV R8, S0                    @ [R8] = sqrt(sumX^2 + sumY^2)
        ADD R3, R1, #0                 @ [R3] = j
        ADD R2, R0, #0                 @ [R2] = i
        LDR R0, =OutputFileHandle
        LDR R0, [R0]
        SUBS R9, R8, #255
        BGE MO
        ADD R1, R8, #0
        B Pr
    MO:
        MOV R1, #255
    Pr:
        SWI SWI_PrInt
        LDR R1, =Space
        SWI SWI_PrStr                  @ print "MatOut[i][j] "
        ADD R0, R2, #0
        ADD R1, R3, #0                 @ restore R0 and R1

    SLoop2End:
        ADD R1, R1, #1                 @ j++
        SUBS R9, R5, R1                @ if (j < breadth)
        BGT SLoop2

        ADD R9, R0, #0
        LDR R0, =OutputFileHandle
        LDR R0, [R0]
        LDR R1, =NL 
        SWI SWI_PrStr
        ADD R0, R9, #0

    SLoop1End:
        ADD R0, R0, #1                 @ i++
        SUBS R9, R4, R0                @ if (i < length)
        BGT SLoop1


    CloseOutputFile:
        LDR R0, =OutputFileHandle
        SWI SWI_Close                      @ close output file

EofReached:
    MOV R0, #Stdout                    @ print last message
    LDR R1, =EndOfFileMsg
    SWI SWI_PrStr

Exit:
    SWI SWI_Exit                       @ stop executing
InFileError:
    MOV R0, #Stdout
    LDR R1, =FileOpenInpErrMsg
    SWI SWI_PrStr
    BAL Exit                           @ give up, go to end
    
    
    
.data
.align
Length:             .skip       4
Breadth:            .skip       4
InputFileHandle:    .skip       4
OutputFileHandle:   .skip       4
Mat:                .skip       307200             @ l*b
VerticalMask:       .skip       36
HorizontalMask:     .skip       36
InFileName:         .asciz      "input.txt"
OutFileName:         .asciz     "output.txt"
FileOpenInpErrMsg:  .asciz      "Failed to open input file \n"
EndOfFileMsg:       .asciz      "End of file reached\n"
ColonSpace:         .asciz      ": "
NL:                 .asciz      "\n "   @ new line
Message1:           .asciz      "Starting Operation \n"
Space:              .asciz      " "
.end
