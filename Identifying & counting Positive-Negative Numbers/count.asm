.model small
.stack 500h
.data 
    str1 db 10 dup('$')
    str2 db 10 dup('$')
    msg0 db 10,13,'Number of positive numbers: $'
    msg1 db 10,13,'Number of negative numbers: $'
    msg2 db 10,13,'Number of zeros: $'
    msg3 db 10,13,'Enter number: $'
    msg4 db 10,13,'Negative numbers are: - $'
    pos db 00h
    ng db 00h
    zo db 00h
    disp macro msg
          mov ah,09h
          lea dx,msg
          int 21h
    endm
.code
        mov ax,@data
        mov ds,ax
    
        lea si,str1
        lea di,str2                                                               ;ACCEPTING 10 NUMBERS FROM THE USER
        mov ch,10                 
     
l2:
         disp msg3
         call accept                                                              ;CALL TO PROC ACCEPTING 2 DIGIT NUMBERS 
         mov [si],bl                                                              ;TO STORE ACCEPTED NUMBERS IN MEMORY 
         inc si
         dec ch
         jnz l2     
      
         lea si,str1            
         mov ch,10              
         mov ax,0000h                                                             ;TO CLEAR THE AX REGISTER
         mov bx,0000h      
      
l5:
         mov al,[si]                                                              ;COPYING CONTENT LOCATION TO AL
         cmp al,00h                                                               ;COMPARING WITH ZERO
         jnz pno
         inc zo
         jmp final
    
pno:
         test al,80h
         jnz nno
         inc pos
         jmp final
      
nno:
         mov [di],al
         inc di
         inc ng
         jmp final
      
      
      
final:
         inc si                                                                   ;TO INCREMENT ADDRESS BY 1
         dec ch                                                                   ;TO GET NEXT VALUE
         jnz l5              
      
         disp msg0
         mov dl,pos
         add dl,30h
         mov ah,02h
         int 21h
      
         disp msg1
         mov dl,ng
         add dl,30h
         mov ah,02h
         int 21h
         mov ch,ng
   
         lea di,str2

dispneg:                               
         disp msg4                                                                ;TO DISPLAY THE NEGATIVE NUMBERS
         int 21h
         mov bl,[di]
         call disp2                     
         inc di
         dec ch
         jnz dispneg
      
        disp msg2
        mov dl,zo
        add dl,30h
        mov ah,02h
        int 21h    
        mov ah,4ch
        int 21h      
      
accept proc near
      
        mov ah,01h
        int 21h
        
        sub al,30h  
        cmp al,09h
        jle l1 
        sub al,07h

l1:     mov bl,00h
        mov cl,04h
        shl al,cl
        mov bl,al
        
        mov ah,01h
        int 21h
        sub al,30h  
        cmp al,09h
        jle l4
        sub al,07h

l4:     add bl,al
        ret
        accept endp
        
disp2 proc near                                                                   ;TO DISPLAY THE 2 DIGIT NUMBER
         mov dl,bl
         and dl,0f0h
         mov cl,04h
         shr dl,cl
         
         add dl,30h
         cmp dl,39h
         jle l6
         add dl,07h
         l6:mov ah,02h
         int 21h        
        
         mov dl,bl
         and dl,0fh
         add dl,30h
         cmp dl,39h
         jle l7
         add dl,07h

l7:      mov ah,02h
         int 21h
         ret
    disp2 endp
    end
