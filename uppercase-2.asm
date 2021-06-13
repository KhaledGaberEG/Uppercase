; Executable Name : uppercasser
; Date	 	  : 14/9/2020

section .data

section .bss

	BUFFER_LENGTH equ 1024
	Buffer resb BUFFER_LENGTH
	
section .text
global _start
_start:
	
	READ: mov eax, 3		; choose sys_read
	      mov ebx, 0		; file descriptor stdin	
	      mov ecx, Buffer		; pass address of buffer
	      mov edx, BUFFER_LENGTH	; set buffer length 
	      int 80h			; call read()
	      cmp eax, 0		; check if there is error reading
	      jb EXIT			; if -1 exit
	      je EXIT			; if  0 exit
	
	mov esi, eax			; safe keeping number of bytes_read
	mov ebp, Buffer		; Store address of Buffer in ebp
	add ebp, esi			; ebp Now point to it's buffer end
	dec ebp			; adjust offset
	
		; Now Start The Loop and Change Characters Needed

	LOOP: cmp byte[ebp], 61h	; Check if it's equal to 'a'
	      jb NEXT			; GO to Next Character 
	      cmp byte[ebp], 7Ah	; Check if it's equal to 'z'
	      ja NEXT			; Go to next Character
	      
	      sub byte[ebp], 20h	; ELSE convert to uppercase then go to next automatically
	          	 
	 NEXT: dec ebp			; Decryment ebp "to point to previous Character"
	       dec esi			; Decrement esi 'Counter'
	       jnz LOOP		; Go To the loop again to check Next Character until ZERO
	       
	       ; Once Reached Zero The ZF flag is set and write complete as Normal

	WRITE: mov edx, eax		; pass how many bytes to be written
	       mov eax, 4		; specify sys_write call
	       mov ebx, 1		; specify file descriptor
	       mov ecx, Buffer		; pass buffer address "changed letter"
	       int 80h			; make write call
	       jmp READ		; Go to read again to read NEXT Chunk
	       
	 EXIT: mov eax, 1		; specify sys_exit
	       mov ebx, 0		; specify return value
      	       int 80h			; make sys_exit call	
