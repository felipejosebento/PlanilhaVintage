;TITLE Planilha-Vintage-ControladorFormulas(FelipeJoseBento)
;Arquivo que controla as formulas utilizadas pelo usuário

controladorFormula PROC
	;Procedimento para verificar a formula inserida pelo usuário
	;Atualiza a planilha
	;RECEBE: Endereço da CELULA que contem a formula em EDI
	;FORMULAS SÃO DO TIPO: =XN*XN ,
	; onde X é uma coluna 
	; onde N é uma linha
	; onde * é um operador que pode ser (* , + , - ) 
	
	;Guardando valores dos registradores
	push edx
	push esi
	push eax
	push ebx
	push ecx


	lea edx, (Cell  PTR[edi]).formula

	mov ebx, 0
	mov bl, [edx+1] ; Coluna do primeiro membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+2] ; Linha do primeiro membro
	sub al, 30h

	mov esi, OFFSET Linha1
	call EnderecoCelula

	lea esi, (Cell  PTR[esi]).numInt
	push [esi]		; Operando 1 na pilha

	mov ebx, 0
	mov bl, [edx+4] ; Coluna do primeiro membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+5] ; Linha do primeiro membro
	sub al, 30h

	mov esi, OFFSET Linha1
	call EnderecoCelula

	lea esi, (Cell  PTR[esi]).numInt
	push [esi]		; Operando 2 na pilha

	;;FORMULA 
	mov eax, 0
	mov al, [edx+2] ;OPERADOR

	pop ebx
	pop eax
	mul ebx

	mov (Cell  PTR[edi]).numInt, eax

	;Recuperando valroes dos registradores
	pop ecx
	pop ebx
	pop eax
	pop esi
	pop edx

	ret
controladorFormula ENDP