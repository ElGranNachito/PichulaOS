org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

main:

;Inicializamos primeros ds, es. Para ello utilizamos ax pues en 16bits
;no es posible escribir a estos registros directamente usando una constante

mov ax, 0             
mov ds, ax  
mov es, ax

;Ahora inicializamos el stack. Inicializaremos el puntero del stack a la direccion
;en la que se encuentra nuestro SO puesto que el stack crece hacia abajo y no queremos
;que escriba sobre la memoria en la que corre el SO

mov ss, ax
mov sp, 0x7C00

;Mostramos el mensaje de bienvenida
mov si, mensaje

call print

.halt:
    hlt
    jmp .halt

;Muestra un mensaje en pantalla.
;Parametros:
;   Mensaje = ds:[si]
;Notar: El mensaje debe terminar con NULL, sino la funcion no retornara
print:

push si
push ax

;Loop hasta imprimir todos los caracteres.
.loop:

lodsb
or al, al
jz .finished

;Interrupt para pedirle a la BIOS que imprima el caracter actual
mov ah, 0x0e
mov bh, 0
int 0x10

jmp .loop

.finished:

pop ax
pop si

ret

mensaje: db 'Bienvenido a PichulaOS', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h