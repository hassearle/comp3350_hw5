;Author: Ash Searle 
;Username: kss0024 
;Homework #5
 

 
.386 
.model flat, stdcall 
.stack 4096 
ExitProcess PROTO, dwExitCode:DWORD 
.data 
 
.code 
  main PROC 
								 
    invoke ExitProcess, 0 
  main endp 
end main
