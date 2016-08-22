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
	

	;VERIFICANDO SE É UMA FUNCAO
	;MA-> MAIOR
	;CN -> Cont.Numero
	
	pushad 
	push edi

	;FUNCAO
	mov ebx, 0
	mov bl, [edx]
	cmp ebx, 4Dh
	je MAIOR
	cmp ebx, 4Eh
	je MENOR
	cmp ebx, 043h
	je CONT
	

	;FORMULA
	jmp FORMULA

MAIOR:
	mov ebx, 0
	mov bl, [edx+2] ; Coluna do primeiro membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+3] ; Linha do primeiro membro
	sub al, 30h

	mov esi, OFFSET Linha1
	call EnderecoCelula
	
	;EDI ENDERECO CELULA INICIAL
	mov edi, esi
	
	;CONTADOR INICIAL ECX
	lea esi, (Cell  PTR[esi]).numInt
	mov ecx, [esi]

	mov ebx, 0
	mov bl, [edx+5] ; Coluna do segundo membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+6] ; Linha do segundo membro
	sub al, 30h

	mov esi, OFFSET Linha1
	;ESI COM ENDERECO DO FIM
	call EnderecoCelula
	
	mov edx, edi
	;EDX INICIO
	;ESI FIM
L1:	cmp edx, esi
	je FL1
	add edx, (TYPE CELL)*5		;Novo endereco da célula
	lea ebx, (Cell  PTR[edx]).numInt
	mov eax, [ebx]
	cmp ecx, eax
	ja T1 
	mov ecx, eax
T1:
	jmp L1
FL1:
	pop edi
	mov (Cell  PTR[edi]).numInt, ecx
	popad
	jmp S1

MENOR:
	mov ebx, 0
	mov bl, [edx+2] ; Coluna do primeiro membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+3] ; Linha do primeiro membro
	sub al, 30h

	mov esi, OFFSET Linha1
	call EnderecoCelula
	
	;EDI ENDERECO CELULA INICIAL
	mov edi, esi
	
	;CONTADOR INICIAL ECX
	lea esi, (Cell  PTR[esi]).numInt
	mov ecx, [esi]

	mov ebx, 0
	mov bl, [edx+5] ; Coluna do segundo membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+6] ; Linha do segundo membro
	sub al, 30h

	mov esi, OFFSET Linha1
	;ESI COM ENDERECO DO FIM
	call EnderecoCelula
	
	mov edx, edi
	;EDX INICIO
	;ESI FIM
	push edx
VERIFICA:
	lea eax, (Cell  PTR[edx]).typ
	mov ebx, 0
	mov bl, [eax]
	cmp ebx, 0
	jne INI
	cmp edx, esi
	je NT
	add edx, (TYPE CELL)*5		;Novo endereco da célula
	jmp VERIFICA
INI:
	lea ebx, (Cell  PTR[edx]).numInt
	mov ecx, [ebx]
	pop edx
INI2:
	mov ebx, 0
	lea eax, (Cell  PTR[edx]).typ
	mov ebx, 0
	mov bl, [eax]
	cmp ebx, 0
	je COMP
	lea eax, (Cell  PTR[edx]).numInt
	mov ebx, 0
	mov ebx, [eax]
	cmp ecx, ebx
	jna COMP
	mov ecx, ebx
	cmp edx, esi
	je SALVA
	add edx, (TYPE CELL)*5	
	jmp INI2

COMP:
	cmp edx, esi
	je SALVA
	add edx, (TYPE CELL)*5	
	jmp INI2

NT:
	pop edx
	pop edi
	mov (Cell  PTR[edi]).numInt, 0
	popad
	jmp S1

SALVA:
	pop edi
	mov (Cell  PTR[edi]).numInt, ecx
	popad
	jmp S1

;;CONT.NUM
	CONT: 
	mov ebx, 0
	mov bl, [edx+2] ; Coluna do primeiro membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+3] ; Linha do primeiro membro
	sub al, 30h

	mov esi, OFFSET Linha1
	call EnderecoCelula
	
	;EDI ENDERECO CELULA INICIAL
	mov edi, esi
	
	;CONTADOR INICIAL ECX
	lea esi, (Cell  PTR[esi]).numInt
	mov ecx, [esi]

	mov ebx, 0
	mov bl, [edx+5] ; Coluna do segundo membro
	sub bl, 37h
	mov eax, 0
	mov al, [edx+6] ; Linha do segundo membro
	sub al, 30h

	mov esi, OFFSET Linha1
	;ESI COM ENDERECO DO FIM
	call EnderecoCelula
	
	mov edx, edi
	;EDX INICIO
	;ESI FIM
	mov ecx, 0
CONT1:
	lea ebx, (Cell  PTR[edx]).typ
	mov eax, 0
	mov al, [ebx]

	cmp al, 1
	je INCR
	cmp al, 3
	je INCR
	jmp SALT
INCR:
	inc ecx
SALT:
	cmp esi, edx
	je FIMC
	add edx, (TYPE CELL)*5	
	jmp CONT1
FIMC:	
	;;FIM
	pop edi
	mov (Cell  PTR[edi]).numInt, ecx
	popad
	jmp S1

;;CONT.NUM
	
FORMULA:
	pop edi
	popad
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

	pop ebx ; -> Primeiro da Formula
	pop eax ; -> Segunda da Formula

	;Verificando qual operação será feita
	mov ecx, 0
	mov cl, [edx+3] ; OPERADOR
	cmp cl, 2Ah
	je MULTI
	cmp  cl, 2Bh
	je SOMA
	cmp cl, 2Fh
	je DIVISAO
	cmp cl, 2Dh
	je SUBE
	jmp NOPE
MULTI:
	mul ebx
	mov (Cell  PTR[edi]).numInt, eax
	jmp S1
DIVISAO:
	cmp ebx, 0
	je NOPE
	mov edx, 0
	div ebx
	mov (Cell  PTR[edi]).numInt, eax
	jmp S1
SOMA:
	add eax, ebx
	mov (Cell  PTR[edi]).numInt, eax
	jmp S1
SUBE:
	sub eax, ebx
	mov (Cell  PTR[edi]).numInt, eax
	jmp S1
NOPE:
	mov eax, 0
	mov (Cell  PTR[edi]).numInt, eax
S1:
	;Recuperando valroes dos registradores
	pop ecx
	pop ebx
	pop eax
	pop esi
	pop edx

	ret
controladorFormula ENDP