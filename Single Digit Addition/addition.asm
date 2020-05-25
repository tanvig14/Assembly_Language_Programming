.model small
.stack 200h
.data

msg1 db 10, 13, 'Enter the frist number : $'
msg2 db 10, 13, 'Enter the second number : $'
msg3 db 10, 13, 'The result is : $'

.code
start:
        mov ax,@data
        mov ds,ax

        mov ax,03h
        int 10h

        mov ah,09h                                ;Display msg1
        lea dx,msg1
        int 21h

        mov ah,01h                                ;Accept first number
        int 21h
        sub al,30h             
        cmp al,09h
        jle L1
        sub al,07h

L1:     mov bl,al
          mov ah,09h                              ;Display msg2
          lea dx,msg2
          int 21h

         mov ah,01h                               ;Accept second number
         int 21h
         sub al,30h             
         cmp al,09h
         jle L2
         sub al,07h

L2:     add bl,al
          mov ah,09h                              ;Display msg3
          lea dx,msg3
          int 21h

         mov al,bl              
         mov bl,10
         mov ah,00h
         div bl                  

        mov dl,al
        mov bl,ah

         add dl,30h
         cmp dl,39h
         jle L3                  
         add dl,07h

L3:     mov ah,02h                                ;Display MSB
        int 21h

        mov dl,bl
        add dl,30h
        cmp dl,39h
        jle L4
        add dl,07h

L4 :    mov ah,02h                                ;Display MSB
          int 21h

         mov ah,4ch             
         int 21H
end start
