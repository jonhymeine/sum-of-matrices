.data

  matrixA: .word 0:100
  matrixB: .word 1:100
  matrixC: .word 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99
  
  askIndexMsg: .asciz "\nEntre com o tamanho do índice das matrizes (máx. = 10 e mín = 2): "
  incorrectValueMsg: .asciz "\nValor inválido. Tente novamente."
  traverseMethodMsg: .asciz "\nEscolha o método para percorrer a matriz: \n0 - Linha-coluna\n1 - Coluna-linha\nOpção: "
  tab: .asciz "\t"
  newLine: .asciz "\n"

.text
  askIndex:
    # Ask for the index size
    addi a7, zero, 4
    la a0, askIndexMsg
    ecall

    # Get the index size
    addi a7, zero, 5
    ecall
    
    # Check if the index size is valid
    addi s1, zero, 11
    blt a0, s1, checkIfGreaterOrEqualValue
    addi a7, zero, 4
    la a0, incorrectValueMsg
    ecall
    jal zero, askIndex

  checkIfGreaterOrEqualValue:
    # Check if the index size is valid
    addi s2, zero, 2
    bge a0, s2, continue
    addi a7, zero, 4
    la a0, incorrectValueMsg
    ecall
    jal zero, askIndex
    
  continue:
    # Receives value of the input
    add s0, zero, a0

  askMethod:
    addi a7, zero, 4
    la a0, traverseMethodMsg
    ecall

    addi a7, zero, 5
    ecall
  
    # Check if the option is valid
    add t2, zero, a0
    beq a0, zero, sumMatrices
    addi s1, zero, 1
    beq a0, s1, sumMatrices
    addi a7, zero, 4
    la a0, incorrectValueMsg
    ecall

    jal zero, askMethod

    sumMatrices:
      # Load adresses of the matrices
      la s1, matrixA
      la s2, matrixB
      la s3, matrixC
      
      # j = Column
      addi t0, zero, 0
      # i = Row
      addi t1, zero, 0
      # Value (s4) used to walk between matrices index
      addi s4, zero, 4

      add s5, zero, s1
      add s6, zero, s2
      add s7, zero, s3
      
    bne t2, zero, columnRow
    
    rowColumn:
      beq t1, s0, end
      blt t0, s0, nextColumn
      mul t2, s0, s4
      add s5, s5, t2
      add s6, s6, t2
      add s7, s7, t2
      
      # Go back to the start of the column
      add t0, zero, zero
      # Add t1++ to go the next row
      addi t1, t1, 1
      
      jal zero, rowColumn

      nextColumn:
        # t2 = j * 4
        slli t2, t0, 2
        
        # Load the value of the matrixA to t4
        add t3, s6, t2
        lw t4, 0(t3)
        
        # Load the value of the matrixC to t5
        add t3, s7, t2
        lw t5, 0(t3)

        # Store the result in matrixA
        add t6, t4, t5
        add t3, s5, t2
        sw t6, 0(t3)
      
        # Increment j++
        addi t0, t0, 1
        jal zero, rowColumn

    columnRow:
      beq t0, s0, end
      blt t1, s0, nextRow
      add s5, s5, s4
      add s6, s6, s4
      add s7, s7, s4
      
      # Add t0++ to go the next column
      addi t0, t0, 1
      # Go back to the start of the column
      add t1, zero, zero
      
      jal zero, columnRow

      nextRow:
        # t2 = i * 4
        slli t2, t1, 2

        mul s8, s0, t2
        
        # Load the value of the matrixA to t4
        add t3, s6, s8
        lw t4, 0(t3)
        
        # Load the value of the matrixC to t5
        add t3, s7, s8
        lw t5, 0(t3)

        # Store the result in matrixA
        add t6, t4, t5
        add t3, s5, s8
        sw t6, 0(t3)
      
        # Increment i++
        addi t1, t1, 1
        jal zero, columnRow
        
  end:
    add t0, zero, zero
    add t1, zero, zero
    la t3, tab
    la t4, newLine

    add s5, zero, s1
    
  print:
    beq t1, s0, endPrint
    blt t0, s0, nextColumnPrint
    mul t2, s0, s4
    add s5, s5, t2

    addi a7, zero, 4
    add a0, zero, t4
    ecall
    
    # Go back to the start of the column
    add t0, zero, zero
    # Add t1++ to go the next row
    addi t1, t1, 1

    jal zero, print
    
    nextColumnPrint:
      lw a0, 0(s1)
      addi a7, zero, 1
      ecall

      addi a7, zero, 4
      add a0, zero, t3
      ecall
      
      addi s1, s1, 4
      addi t0, t0, 1
      
      jal zero, print
  endPrint: