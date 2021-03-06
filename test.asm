org 7C00h

section .text

start:
	mov ax, 3
	int 10h

again:
	jmp showmenu
select:
	mov bl, al
	cmp al, 48
	jz showhello
	mov al, bl
	cmp al, 49
	jz showmode13
	cmp al, 50
	jz kernelload
	jmp again

done:
	jmp 0xFFFFFFFF

readchar:
	mov ah, 0
	int 16h
	ret

writestring:
	push bp
	mov bp, sp

	push ds
	pop es

	mov cx, [bp+6]
	mov bl, 7
	mov bh, 0
	mov dh, [bp+10]
	mov dl, [bp+8]
	mov ax, 1300h
	mov di, bp
	mov bp, [bp+4]
	int 10h

	mov bp, di
	mov sp, bp
	pop bp
	ret

showmenu:
	mov ax, 3
	int 10h
	push 12
	push 30
	push menulen
	push menu
	call writestring
	call readchar
	jmp select

showhello:
	push 0
	push 0
	push hellolen
	push hello
	call writestring
	call readchar
	jmp again

showmode13:
	mov ax, 13h
	int 10h
	mov cx, 64000
	mov di, 0xa000
	mov es, di
loopstart:
	mov di, cx
	mov byte [es:di], ch
	dec cx
	jnz loopstart
	call readchar
	mov ax, 3
	int 10h
	jmp again

kernelload:
	push 0
	push 0
	push kernellen
	push kernel
	call writestring
	call readchar

	mov ah, 2
	mov al, 1
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 80h
	xor bx, bx
	mov es, bx
	mov bx, 7e00h
	int 13h

	jmp 0x0000:0x7e00

section .data

menu db '[0]: Hello [1]: Mode 13h [2]: Kernel'
menulen equ $-menu
hello db 'Hello, world'
hellolen equ $-hello
kernel db 'I am kernel.'
kernellen equ $-kernel

