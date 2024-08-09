.text
.global main

main:
    # Push to the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    LDR r0, =promptFile
    BL printf

    LDR r0, =inputFormat
    LDR r1, =input_file
    BL scanf

    LDR r0, =input_file
    LDR r1, =file_read_mode
    BL fopen

    LDR r1, =file_read_pointer
    STR r0, [r1]
    MOV r1, #0
    CMP r0, r1
    BEQ invalid_file
        LDR r0, =outputFileFormat
        LDR r1, =input_file
        BL printf

        # Initialize write file pointer
        LDR r0, =output_file_name
        LDR r1, =file_write_mode
        BL fopen
        LDR r1, =file_write_pointer
        STR r0, [r1]
        
        B read_loop

    read_loop:
        MOV r1, #-1
        LDR r0, =file_read_pointer
        LDR r0, [r0]
        BL fgetc
        CMP r0, r1
        BEQ end_read_loop

            LDR r1, =file_content
            STR r0, [r1]

            # Process file content character by character
            # Logic to encrypt character goes here
            # ........
            # ........

            LDR r0, =file_write_pointer
            LDR r0, [r0]
            LDR r1, =writeFileContentFormat
            LDR r2, =file_content
            LDR r2, [r2]
            BL fprintf

            LDR r1, =file_content
            LDR r1, [r1]
            LDR r0, =outputFileContentFormat
            BL printf

            B read_loop
        
    end_read_loop:
        B close_file

    close_file:
        LDR r0, =file_read_pointer
        LDR r0, [r0]
        BL fclose
        LDR r0, =file_write_pointer
        LDR r0, [r0]
        BL fclose
        B done

    invalid_file:
        LDR r0, =errorInvalidFile
        BL printf

    done:

    LDR r0, =outputNextLineFormat
    BL printf

    # Pop from stack and return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    promptFile: .asciz "Enter the file to read: "
    inputFormat: .asciz "%s"
    input_file: .space 50
    outputFileFormat: .asciz "Content of the file [%s] is: "
    outputFileContentFormat: .asciz "%c"
    outputNextLineFormat: .asciz "\n"

    writeFileContentFormat: .asciz "%c"

    errorInvalidFile: .asciz "\nError: File doesn't exist or access denied\n"
    file_content: .space 40

    file_read_pointer: .word 0
    file_write_pointer: .word 0
    file_read_mode: .asciz  "r"
    file_write_mode: .asciz  "w"
    output_file_name: .asciz "encrypted.txt"
