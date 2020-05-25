.MODEL SMALL
.STACK 200H
.DATA
      STR1 DB 10 DUP('$')
      MSG1 DB 10, 13, ' Enter marks : $'
      MSG2 DB 10, 13, ' Percentage : $'
      MSGX DB ' (in hex) $'
      MSGA DB 10, 13, ' GRADE : A $'
      MSGB DB 10, 13, ' GRADE : B $'
      MSGC DB 10, 13, ' GRADE : C $'
      MSGD DB 10, 13, ' GRADE : D $'
      MSGE DB 10, 13, ' GRADE : E $'
      MSGF DB 10, 13, ' GRADE : F $'

      DISP MACRO MSG			                          ;For displaying any message
      MOV AH, 09H
      LEA DX, MSG
      INT 21H
      ENDM

.CODE
START:
      MOV AX, @DATA			                            ;Initializing data segment
      MOV DS, AX

      MOV AX, 03H
      INT 10H

      MOV CH, 05H			                              ;Initializing counter value to 5
      MOV DX, 0000H                                 ;Clearing the data segment
      LEA SI, STR1				                          
      L1: MOV BL, 00H
          CALL ACCEPT			                
          MOV [SI], BL			                        ;Storing the entered value in the array
          INC SI				              
          DEC CH				
          JNZ L1				                            ;Iterative call for the loop if CH!=0

      MOV BX, 0000H
      MOV AX, 0000H
      MOV CH, 05H
      LEA SI, STR1

      L2 : MOV AL, [SI]
           ADD BX, AX			                          ;Summation of all the entered marks
           INC SI
           DEC CH
           JNZ L2
     
      DISP MSG2				

      MOV AX, 0000H
      MOV AX, BX
      MOV BL, 5				                              ;Calculating percentage
      DIV BL
      MOV BL, AL

      MOV DL, BL
      AND DL, 0F0H
      MOV CL, 04H
      SHR DL, CL
      
      ADD DL, 30H
      CMP DL, 39H
      JLE L3
      ADD DL, 07H

      L3 : MOV AH, 02H			                        ;Displaying MSB of the percentage
           INT 21H
      
      MOV DL, BL
      AND DL, 0FH
      ADD DL, 30H
      CMP DL, 39H
      JLE L4
      ADD DL, 07H
      
      L4 : MOV AH, 02H			                        ;Displaying LSB of the percentage
           INT 21H

      MOV DL, '%'
      MOV AH, 02H			                              ;Displaying the '%' symbol
      INT 21H
      DISP MSGX

      CMP BL, 90
      JLE L_B
      DISP MSGA				                              ;Displays grade as A if percentage > 90
      JMP EXIT

      L_B : CMP BL, 80
            JLE L_C
            DISP MSGB			                          ;Displays grade as B if percentage > 80
            JMP EXIT

      L_C : CMP BL, 70
            JLE L_D
            DISP MSGC			                          ;Displays grade as C if percentage > 70
            JMP EXIT

      L_D : CMP BL, 60
            JLE L_E
            DISP MSGD			                          ;Displays grade as D if percentage > 60
            JMP EXIT

      L_E : CMP BL, 50
            JLE L_F
            DISP MSGE			                          ;Displays grade as E if percentage > 50
            JMP EXIT      
      
      L_F : DISP MSGF			                          ;Displays grade as F if percentage <= 50
            JMP EXIT

      EXIT : MOV AH, 4CH			
             INT 21H

      ACCEPT PROC NEAR			                        ;Procedure for accepting marks individually in hex
        DISP MSG1			

        MOV AH, 01H			                            ;Accepting MSB of marks
        INT 21H

        SUB AL, 30H
        CMP AL, 09H
        JLE L7
        SUB AL, 07H
        
        L7 : MOV BL, 00H
             MOV CL, 04H
             SHL AL, CL
             ADD BL, AL
     
        MOV AH, 01H			                            ;Accepting LSB of marks
        INT 21H

        SUB AL, 30H
        CMP AL, 09H
        JLE L8
        SUB AL, 07H

        L8 : ADD BL, AL
             RET				
             ACCEPT ENDP			

END START
