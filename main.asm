;Author: Ash Searle 
;Username: kss0024 
;Homework #5
 

 
.386 
.model flat, stdcall 
.stack 4096 
ExitProcess PROTO, dwExitCode:DWORD 
.data 
	pt byte	"ASH"							; plain text array
	key byte ?, lengthof pt - 1				; key array (one less length of pt)
	ct byte lengthof pt DUP(?)				; cyphertext

.code 

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
main PROC 
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	mov eax, 0
	
						
	invoke ExitProcess, 0 
main endp 


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
encrypt PROC
;
;	uses Vigenère cipher to encrypt text
;	
;	INPUT: plaintext, encryption key
;	OUTPUT: cyphertext
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

encrypt endp


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
decrypt PROC
;
;	uses Vigenère cipher to decrypt text
;	
;	INPUT: cyphertext, encryption key
;	OUTPUT: plaintext
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

decrypt endp


end main
