;TITLE Planilha-Vintage-Controlador(FelipeJoseBento)
;Arquivo que controla as entradas do usuário e os procedimentos da InterfacePlanilha

controladorPrincipal PROC 
	;Primeiro procedimento iniciado na aplicação 
	push eax
	push ebx
	push esi
InicioControlador:
	mov esi, OFFSET Linha1	;Temos aqui o início da Planilha

	call Clrscr
	call ImprimePlanilha ;Imprime Planilha na tela
	call ImprimeMenu	 ;Imprime Menu para o usuario(Retorna Opçao em EAX)
	; Opçoes do Menu
	; 1 - INSERIR VALOR EM UMA CELULA
	; 2 - DELETAR VALOR DE UMA UMA CELULA 
	; 3 - COPIAR VALOR DE UMA CÉLULA PARA OUTRA 
	; 4 - RECORTAR VALOR DE UMA CÉLULA PARA OUTRA 
	; 5 - SELECIONAR CELULA
	; 6 - DELETAR UMA COLUNA 
	; 7 - DELETAR UMA LINHA

	;Vendo a opçao selecionada
	mov ebx,1
	cmp ebx, eax
	je controladorInsere
	inc ebx
	
	cmp ebx, eax
	je controladorDeleta
	inc ebx

	cmp ebx, eax
	je controladorCopia
	inc ebx

	cmp ebx, eax
	je controladorRecorta
	inc ebx

	cmp ebx, eax
	je controladorSelecionaCelula
	inc ebx

	cmp ebx, eax
	je controladorFuncaoMaior
	inc ebx

	cmp ebx, eax
	je controladorFuncaoMenor
	inc ebx

	cmp ebx, eax
	je controladorcNum
	inc ebx

	cmp ebx, eax
	je controladorCopiaFormula
	
	jmp FimControlador

;1
controladorInsere:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call InserirUser
	jmp FimControlador

;2
controladorDeleta:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call ExcluirUser
	jmp FimControlador

;3
controladorCopia:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call CopiarUser
	jmp FimControlador

;4
controladorRecorta:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call RecortarUser
	jmp FimControlador

;5
controladorSelecionaCelula:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call SelecionaCelula
	call Crlf
	call WaitMsg
	jmp FimControlador

;6
controladorFuncaoMaior:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call MaiorUser
	jmp FimControlador

;7
controladorFuncaoMenor:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call MenorUser
	jmp FimControlador

;8
controladorcNum:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call ContNumUser
	jmp FimControlador

;9
controladorCopiaFormula:
	call Clrscr
	call ImprimePlanilha
	call Crlf
	call Crlf
	call CopiaFormulaUser
	jmp FimControlador

FimControlador:
	jmp InicioControlador
	pop esi
	pop ebx
	pop eax
	ret
controladorPrincipal ENDP






