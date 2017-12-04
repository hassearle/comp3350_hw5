;Author: Ash Searle 
;Username: kss0024 
;Homework #5
 

 
.386 
.model flat, stdcall 
.stack 4096 
ExitProcess PROTO, dwExitCode:DWORD 

.data 
	pt byte	"MEMORY"						; plain text array
	key byte "BAD"							; key array (one less length of pt)
	ct byte lengthof pt DUP(?)				; cyphertext
	ctSize byte ?							; length of cyphertext
	ash byte lengthof pt DUP(?)				; key repeated length of pt

	input byte "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	output byte lengthof input DUP(?)
	shift dword ?

	et byte 26 * 26 dup(0)					; encryption table

.code 

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
main PROC 
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov esi, 0
	mov edi, 0
	
	call TranslateKey
	call EncryptTable
	call Encrypt
	call Decrypt
						
	invoke ExitProcess, 0 
main ENDP 

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
TranslateKey PROC uses eax edi esi ebx ecx
;
;	fills in remainder of key at the length of pt
;	
;	INPUT: 
;	OUTPUT: 
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	pushad									; save registers

	mov al, 0
	mov edi, lengthof key					; lengthof key[high]
	mov esi, 0								; total length of key[low]
	mov ebx, 0								; temp length of key[low]
	mov ecx, lengthof pt					; pt count

	Loop1:									; loops thru length of pt
		mov ebx, 0							; reset temp length of key[low]
		Loop2:								; loops through length of key
			cmp  edi, ebx					; if end of key, start over
			jz Loop1						; starts over loop of key
						
			mov al, key[ebx]				; get first runoff character from source
			mov ash[esi], al				; store it in begining of target
			inc ebx							; next char in key[]
			inc esi							; next char in ash[]
		loop Loop2
		cmp ecx, 0							; if end of pt, break loop
		jz EOL								; breaks out of loops
	loop Loop1
	EOL:									; End Of Loop

	popad
	ret
TranslateKey ENDP


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
EncryptTable PROC uses eax edi esi ebx ecx edx
;
;	fills in remainder of key at the length of pt
;	
;	INPUT: 
;	OUTPUT: 
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	mov shift, 0
	mov esi, 0
	mov ebx, 0
	mov edx, 0
	mov ecx, 26
	FirstLoop:						; makes et[0]: A-Z
		mov bl, input[edx]
		mov et[esi], bl
		inc edx
		inc esi
	loop FirstLoop

	mov shift, 1					; where to start the alphabet
	mov ebx, 0						; holder for output
	mov edx, 0						; loop thu output
	mov ecx, 26						; Number of columns
	mov edi, 0						; row counter
	mov esi, 26						; position
	OuterLoop:
		call ShiftAlpha				; remakes output
		
		InnerLoop:					; makes new row of et[]
			mov bl, output[edx]
			mov et[esi], bl
			inc edx
			inc esi
		loop InnerLoop
	cmp edi, 24
	jz Done
	inc edi
	mov ecx, 26
	mov edx, 0
	inc shift
	jmp OuterLoop
	
	Done:
	
	ret
EncryptTable ENDP


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
ShiftAlpha PROC USES eax ebx ecx esi 
;
;	makes Vigenère text
;	
;	INPUT: 
;	OUTPUT: 
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	pushad								; save registers

	mov ebx, lengthof input				; length of input
	sub ebx, shift						; length of input - shift
	mov esi, 0
	;sub ebx, 1
	mov ecx, shift
	L2:
		mov al, input[esi]				; get first runoff character from source
		mov output[ebx], al				; store it in begining of target
		
		inc esi
		inc ebx							; move to next character in input[]
	loop L2
	
	mov esi, 0							; current index
	mov ebx, shift
	mov ecx, lengthof input				; counter == input[]
	sub ecx, shift
	L1:
		mov al, input[ebx]				; get a character from source
		mov output[esi], al				; store it in the target
			
		inc esi							; move to next character in output[]
		inc ebx
	loop L1

	popad
	ret

ShiftAlpha ENDP


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Encrypt PROC uses eax ebx ecx edx esi edi
;
;	uses Vigenère cipher to encrypt text
;	
;	INPUT: plaintext, encryption key
;	OUTPUT: cyphertext
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	pushad
	
	mov edi, 0							; ScanCount address
	mov edx, 0							; var for ScanCount
	mov eax, 0
	mov ebx, 0							; holds nums for mult
	mov esi, 0							; loop thu pt[low]/ash[low]
	mov ecx, lengthof pt
	EncryptLoop:
		mov al, pt[esi]					; pt letter
		call ScanCount					; pt + (how many letters till esi)
		mov dh, bl						; (how many letters till esi)

		mov al, ash[esi]				; ash letter
		call ScanCount					; ash + (how many letters till esi)
		mov dl, bl						; (how many letters till esi)

		mov eax, 26						; 26
		mul dl							; 26 * ash[esi]
		add al, dh						; 26 * ash[esi] + pt[esi]
		mov edi, eax					; mov to reg cuz asm is dumb
		mov dl, [et + edi]				; letter in EncryptionTable
		mov ct[esi], dl
		inc esi
	loop EncryptLoop
	
	popad
	ret
Encrypt ENDP

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
ScanCount PROC uses ecx edi
;
;	scans string for match
;	
;	INPUT: string
;	OUTPUT: int (EAX)
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	mov ebx, lengthof input
	mov edi, OFFSET input					; EDI points to the string
	;mov al,'F'								; search for the letter F
	mov ecx, LENGTHOF input					; set the search count
	cld										; direction = forward
	repne scasb								; repeat while not equal
	jnz quit								; quit if letter not found
	dec edi									; found: back up EDI
	inc ecx
	quit: 
	sub ebx, ecx
	ret

ScanCount ENDP

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Decrypt PROC
;
;	uses Vigenère cipher to decrypt text
;	
;	INPUT: cyphertext, encryption key
;	OUTPUT: plaintext
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Decrypt ENDP


end main
