.MODEL small
.STACK 100h
.DATA

 ulinp db 13, 0, 14 DUP('$') 

 wlmsg db "                                    ", 10, 13 
   db "        ********************************* ", 10, 13
   db "        *       WELCOME TO GALAXY       * ", 10, 13 
   db "        *********************************", 10, 13, "$"
 
 linea db "------------------------------------------------------------------------------",13,10,"$"
 wlmsg2 db "        Please login...        ", 10, 13, "$"   
 wlmsg3 db "        Press any key..        ", 10, 13, "$"   

 umsg db "Username: ", 10, 13, "$"       
 
 user db "Ready to play?", 10,13,"$"
 
 reset_key db "R: Reset$"
 quit_key db "Q: Quit$"
 
 msgG db "Game over$"
 msgW db "You Win$"
 
 nave db 030                
 navex db 39
 navey db 21
 
 bala db 015
 balax db 39
 balay db 20
 
 contador_puntos db 0
 score db 00h
 unidades db 0
 decenas db 0
 centenas db 0
  
 enemigo db '¾','$'
 aliado db 'è','$'
 
 posisionEneX db ?
 posisionEneY db ?
 posisionAliX db ?
 posisionAliY db ?
 contadorE dw ?
 contadorA dw ?
 
 vidaX db 1
 vidaY db 74
 
 vida1 db 003,"$"
 vida2 db 003,"$"
 vida3 db 003,"$"
 vida4 db 003,"$"
 vida5 db 003,"$"
 contador_vidas db 5 




 
.CODE
limpiar macro xi,yi,xf,yf ;macro para limpiar pantalla y pintar el fondo
    mov ah,06h
    mov al,00h
    mov bh,1111b                ;especificar color
    mov ch,yi                   ;eje y inicial
    mov cl,xi                   ;eje x inicial
    mov dh,xf                   ;eje x final
    mov dl,yf                   ;eje y final
    int 10h
endm  
 
seteo macro ejey, ejex  
    mov ah, 02 
    mov bh, 00
    mov dh, ejey
    mov dl, ejex 
    int 10h
endm

limpiar_registros macro
    xor ax,ax
    xor bx,bx 
    xor cx,cx
    xor dx,dx
endm

impFigura macro caracter,color
    mov al,caracter ; Caracter
    mov bh, 00  ; Pagina 0
    mov bl,color  ; Color
    mov cx,1      ;Cantidad
    mov ah, 09h
    int 10h
endm

imprimirFigura macro figura,color
        mov al,figura
        mov bl,color
        mov cx,1
        mov ah,09h
        int 10h
    endm


imprimir_score macro
    seteo 1,39
    mov al,score
    aam
    
    mov unidades, al
    mov al,ah
    aam
    
    mov centenas, ah
    mov decenas, al
    mov ah,02h
    
    mov dl,centenas
    add dl,30h
    int 21h
    
    mov dl,decenas
    add dl,30h
    int 21h
    
    mov dl,unidades
    add dl,30h
    int 21h
    
    endm

detectar_impresion_ene macro 
    mov ah,08h
    mov bh,00
    int 10h
    
    cmp al,enemigo
    je enemigos
    
endm

detectar_impresion_eneS macro 
    mov ah,08h
    mov bh,00
    int 10h
    
    cmp al,enemigo
    je bala_inicio
    jmp lanzar_bala 

    
endm

detectar_impresion_ali macro 
    mov ah,08h
    mov bh,00
    int 10h
    
    cmp al,aliado
    je aliados
    cmp al,enemigo
    je aliados  
    
endm

imprimir_nombre macro
    seteo 1,1
    mov dx, offset ulinp+2
    mov ah,09h
    int 21h
endm

imprimir_linea macro ejey
    seteo ejey,1
    mov dx, offset linea
    mov ah,09h
    int 21h
endm
;Macro para imprimir vidas
imprimir_vidas macro
    seteo 1,74
    imprimirFigura vida1,1100b
    
    seteo 1,75
    imprimirFigura vida2,1100b
    
    seteo 1,76
    imprimirFigura vida3,1100b
    
    seteo 1,77
    imprimirFigura vida4,1100b
    
    seteo 1,78
    imprimirFigura vida5,1100b
    
    
endm
;Macro para imprimir opciones
imprimir_opciones macro
    seteo 23,71
    mov dx, offset reset_key
    mov ah,09h
    int 21h
    
     seteo 23,1
    mov dx, offset quit_key
    mov ah,09h
    int 21h
    endm
    


    
    

mov ax, @data                   
mov ds, ax

limpiar 0,0,24,79
call Welcome

;imprime todo lo de la interfaz
game:
imprimir_score
imprimir_nombre
imprimir_linea 2
imprimir_linea 22

imprimir_vidas
imprimir_opciones

    
seteo navey, navex
impFigura nave,1100b

seteo balay,balax
impFigura bala, 1001b

mouse:
mov ax,0003 ;Mouse
int 33h
cmp bx,1
je lanzar_bala
jmp movimiento

movimiento:

mov ah, 01h;Espera por una tecla
int 16h

cmp ah, 4Dh; compara con la tecla derecha
je mover_derecha

cmp ah,4Bh
je mover_izquierda

cmp ah, 39h
je lanzar_bala



cmp ah,13h
je reset

cmp ah,10h
je quit

cmp ah,01
jnz sonido

jmp mouse

;Se mueve hacia la derecha
mover_derecha:
mov ax, 0c00h
mov cx, 1
int 21h
seteo navey, navex
impFigura nave,0000b
inc navex
seteo balay,balax
impFigura bala, 0000b
inc balax

seteo navey, navex
impFigura nave,1100b
seteo balay,balax
impFigura bala, 1001b

cmp navex,80
je posisionarNaveI

call mouse

;Se mueve hacia la izquierda
mover_izquierda:
mov ax, 0c00h
mov cx, 1
int 21h
seteo navey, navex
impFigura nave,0000b
dec navex
seteo balay,balax
impFigura bala, 0000b
dec balax

seteo navey, navex
impFigura nave,1100b
seteo balay,balax
impFigura bala, 1001b

cmp navex,-1
je posisionarNave


call mouse

;Posiciona la nave cuando se sale de la pantalla
posisionarNaveI:
   seteo balay,balax
   impFigura bala, 0000b
   dec balax
   seteo navey, navex
   impFigura nave,0000b
   mov balay, 20
   mov balax, 0
   mov navey, 21
   mov navex, 0
   seteo navey, navex
   impFigura nave,1100b
   seteo balay,balax
   impFigura bala, 1001b
call mouse

;Posiciona la nave cuando se sale de la pantalla
posisionarNave:
   seteo balay,balax
   impFigura bala, 0000b
   dec balax
   seteo navey, navex
   impFigura nave,0000b
   mov balay, 20
   mov balax, 79
   mov navey, 21
   mov navex, 79
   seteo navey, navex
   impFigura nave,1100b
   seteo balay,balax
   impFigura bala, 1001b
call mouse

;Etiqueta para volver a empezar el juego   
reset:
mov contador_puntos, 0
mov contador_vidas, 0
mov unidades, 0
mov decenas,0
mov centenas, 0
mov score,00h
limpiar 0,0,24,79
sub ulinp, 1
call Welcome
.exit

;Etiqueta para finalizar juego
quit:
limpiar 0,0,24,79
seteo 12,34
lea dx,msgG
mov ah,09h
int 21h
mov ah, 00h;Espera por una tecla
int 16h
.exit 

;Sonido al presionar una tecla distinta
sonido:
mov ax, 0c00h
mov cx, 1
int 21h
        mov ah,2
        mov dl,07h
        int 21h
        jmp mouse

;Perder
GO:
limpiar 0,0,24,79
seteo 12,34
lea dx,msgG
mov ah,09h
int 21h
mov ah, 00h;Espera por una tecla
int 16h
mov ah, 01h   ; Espera que el usuario precione una tecla
int 21h
limpiar 0,0,24,79
seteo 1,1        
call Welcome

;Ganar
win:
limpiar 0,0,24,79
seteo 12,34
lea dx,msgW
mov ah,09h
int 21h
mov ah, 00h;Espera por una tecla
int 16h
mov ah, 01h   ; Espera que el usuario precione una tecla
int 21h 
limpiar 0,0,24,79
seteo 1,1       
call Welcome

;Etiqueta para realizar el disparo de la bala
lanzar_bala: 
mov ax, 0c00h
mov cx, 1
int 21h
seteo balay,balax
impFigura bala, 0000b
dec balay
cmp balay, 4
jbe bala_inicio

seteo balay,balax
impFigura bala, 1001b
seteo balay,balax
impFigura bala, 0000b
dec balay
seteo balay,balax

mov ah,08h
mov bh,00h           
int 10h
 
                                                         
mov bh,1110b    
cmp al,enemigo
cmp ah,bh          
je  sumar

mov bh,1011b
cmp al,aliado  
cmp ah,bh
je restar
 

inc balay 
seteo balay,balax
impFigura bala, 0000b
dec balay 


jmp lanzar_bala

;Regresa la bala
regresar:
seteo balay,balax
impFigura bala, 0000b
dec balay
jmp bala_inicio

;Coloca la bala en el inicio
bala_inicio:
seteo balay,balax
impFigura bala, 0000b
mov balay,20
seteo balay,balax
impFigura bala, 1001b
call mouse

;Entra a esta etiqueta si golpea un enemigo
sumar:
inc contador_puntos
cmp contador_puntos, 24
add score,10
limpiar_registros
imprimir_score
cmp score, 160
je win
jmp regresar


;Ingresa a esta etiqueta si golpea un aliado
restar:  
seteo vidaX, vidaY
impFigura ' ', 0000b 
inc vidaY
cmp vidaY, 79
je GO

cmp score, 00h
je GO

cmp score, 10
je res10

;Quita 20 puntos por golpear un aliado
sub score,20
limpiar_registros
imprimir_score
call saltarAli

;Etiqueta para restar 10 puntos
res10:
sub score, 10
imprimir_score
jmp saltarAli

;Etiqueta para no borrar la nave aliada  
saltarAli:
dec balay
seteo balay, balax
impFigura bala, 0000b
jmp lanzar_bala                




    





                                   


Welcome:

seteo 0,0
mov dx, offset wlmsg   ; Primer mensaje
mov ah, 09h
int 21h

mov dx, offset wlmsg2   ; Segundo mensaje
mov ah, 09h
int 21h

mov dx, offset wlmsg3 ; Tercer mensaje
mov ah, 09h
int 21h

mov ah, 01h   ; Espera que el usuario precione una tecla
int 21h       ;
call Login

Login: 
limpiar 0,0,24,79
seteo 1,1               ; Limpia la pantalla

mov dx, offset umsg    ;
mov ah, 09h            ;   Imprime el usuario
int 21h                ;

seteo 1,10

mov dx, offset ulinp  ;
mov ah, 0Ah           ;   Lee el usuario 
int 21h               ;



limpiar 0,0,24,79
call Ene


clear:
mov ah, 06h       ;
mov al, 00h       ;
mov bh, 0Fh       ;
mov cx, 0         ; Limpia la pantalla
mov dh, 100       ;
mov dl, 40        ;
int 10h           ;

mov dx, 0         ;
mov bh, 0         ; Pone el cursor (0,0)
mov ah, 02h       ; 
int 10h 

ret               
int 20h             

;Etiqueta para la impresion de los enemigos
Ene: 
mov contadorE,26
    enemigos:
            mov ah,2ch
            int 21h
            
            mov posisionEneX,dl
            mov posisionEneY,dh
            cmp posisionEneX,80
            jge enemigos
            cmp posisionEneY,7
            jge enemigos
            cmp posisionEneY,4
            jl enemigos
            seteo posisionEneY,posisionEneX
            detectar_impresion_ene 
            imprimirFigura enemigo,1110b
            dec contadorE
            mov cx,contadorE
         loop enemigos
         
;Etiqueta para la impresion de los aliados         
mov contadorA,6     
    aliados:
            mov ah,2ch
            int 21h
            
            mov posisionAliX,dl
            mov posisionAliY,dh
            cmp posisionAliX,80
            jge aliados
            cmp posisionAliY,7
            jge aliados
            cmp posisionAliY,4
            jl aliados
            seteo posisionAliY,posisionAliX
            detectar_impresion_ali
            imprimirFigura aliado,1011b            
            dec contadorA
            mov cx,contadorA
         loop aliados   
         
      call game        

