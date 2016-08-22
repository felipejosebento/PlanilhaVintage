	;TITLE Planilha-Vintage-Interface(FelipeJoseBento)
;Arquivos com todas as funçoes relacionadas com a interface com o usuário da Planilha
;Sendo que essas funçoes são controladas por um controlador

ImprimePlanilha PROC 

; Imprime toda a tabela na Tela para o usuário
; RECEBE: ESI: Offset endereço da primeira linha da tabela

;Imprimit a planilha toda 
	mov esi, offset Linha1	; Início da Planilha
	mov ecx, 5				; Numero de Colunas
	mov edx, 0				; Utilizado em gotoXY
	mov dl, (tamTexto+4)	; Início das Colunas
	mov eax, 0				; Utilizado em WriteChar
	mov al, 41h				; Charactere "A"
	call GotoXY 
COLUNAS:
	call WriteChar			;Imprimir um caractere
	inc al					;Posicao
	add dl,(tamTexto+4)		;A Imprimir	
	call GotoXY				;Mudar Cursor 
	loop COLUNAS			

	mov ecx, 9				; Numero de Colunas
	mov edx, 0				; Utilizado em gotoXY
	mov dl, 5
	mov dh, 1				; Início das Colunas
	mov eax, 0				; Utilizado em WriteChar
	mov al, 1h				; Charactere "A"
	call GotoXY 
LINHA:						;Agora colocando cabeçalhos nas linhas
	call WriteDec
	inc al
	add dh, 2
	call GotoXY 
	loop LINHA

	;;PRENCHENDO VALORES (Buscando da memória)
	;;O preenchemento é feito por linhas, coluna a coluna

	mov esi, OFFSET Linha1
	mov ecx, 9
	mov edx, 0
	mov dh, 1
PLINHA:	
	mov ebx, ecx
	mov ecx, 5
	mov dl, (tamTexto)
PCOLUNA:
	;EDX está com a POSICAO
	;ESI está com a célula
	;Chmando ImprimeCélula
	call ImprimeCelula

	add dl,(tamTexto+4)		;Nova posição da coluna
	add esi, TYPE CELL		;Novo endereco da célula
	loop PCOLUNA			;Preencher nova coluna
	add dh, 2				;Nova posica da linha
	mov ecx, ebx			;Retornando contador
	loop PLINHA 
	

	ret	;Retorna ao arquivo principal

ImprimePlanilha ENDP

ImprimeCelula PROC 

; Procedimento que imprime uma celula na tela 
; Recebe a posicao em EDX 
; Recebe o endereco da célula em ESI
; Utiliza o ecx, sem perder o valor que estava
	push edi
	push eax
	push ecx

	call GoToXY

	lea edi, (Cell  PTR[esi]).typ
	mov al,0
	cmp [edi], al
	je CELLVAZIA
	inc al
	cmp [edi], al
	je CELLINT
	inc al
	cmp [edi], al
	je CELLTEXT
	inc al
	cmp [edi], al
	je CELLFORMULA

CELLVAZIA:
	mov ecx, tamTexto
	mov eax, 0
	mov al, "-"
CVaux:
	call WriteChar
	loop CVaux
	jmp FIMIC

CELLINT:
	lea edi, (Cell  PTR[esi]).numInt
	mov eax, [edi]
	call WriteInt
	jmp FIMIC

CELLTEXT:
	lea edi, (Cell  PTR[esi]).text
	push edx
	mov edx, edi
	call StrLength	;Returna o numero de characteres não nulos
	pop edx
	mov ecx, eax
	push edi
CTaux:
	mov eax, 0
	mov al, [edi]
	call WriteChar
	inc edi
	loop CTaux
	pop edi
	jmp FIMIC

CELLFORMULA:
	;Formula digitada pelo usuário
	;Aqui imprime apenas o resultado que está na formula
	push edi
	mov edi, esi
	call controladorFormula
	pop edi
	lea edi, (Cell  PTR[esi]).numInt
	mov eax, [edi]
	call WriteInt

FIMIC:
	pop ecx
	pop eax
	pop edi
	ret 
ImprimeCelula ENDP

CentralizaCelula PROC
; Função que altera a posição na tela, deixando o valor
; da célula centralizado sem alterar o valor de nenhum registrador
; Recebe a posição do inicio da célula em EDX 
; Recebe a posicao do valor a ser centralizado em EDI
; Retorna em EAX o numero de dígitos que a célula tem

	push edx
	push edi
	push ebx
	push ecx

	mov eax, 0
	mov ebx, 0
	
CentralizaCelula ENDP

ImprimeMenu PROC
 ; Função que imprime o menu com as funcionalidades presentes na planilha
 ; RETORNA: a opção escolhida em EAX
 ; Opçoes do Menu
 ; 1 - INSERIR VALOR EM UMA CELULA
 ; 2 - DELETAR VALOR DE UMA UMA CELULA 
 ; 3 - COPIAR VALOR DE UMA CÉLULA PARA OUTRA 
 ; 4 - RECORTAR VALOR DE UMA CÉLULA PARA OUTRA 
 ; 5 - DELETAR UMA COLUNA 
 ; 6 - DELETAR UMA LINHA
 ; 7 - FUNÇÃO MODO
 ; 8 - Cont.NUM
 ; 9 - FUNÇÃO MAIOR

	call Crlf
	call Crlf
	push edx

	; Imprimindo o MENU
	; Com as opçoes 

	;menu BYTE "PlanilhaVintage - Menu",0
	mov edx, OFFSET menu
	call WriteString
	call Crlf
	
	;menuOp1 BYTE "1 - INSERIR VALOR OU FORMULA EM UMA CELULA.",0
	mov edx, OFFSET menuOp1
	call WriteString
	call Crlf
	
	;menuOp2 BYTE "2 - DELETAR VALOR DE UMA UMA CELULA.",0 
	mov edx, OFFSET menuOp2
	call WriteString
	call Crlf
	
	;menuOp3 BYTE "3 - COPIAR VALOR DE UMA CELULA PARA OUTRA.",0 
	mov edx, OFFSET menuOp3
	call WriteString
	call Crlf

	;menuOp4 BYTE "4 - RECORTAR VALOR DE UMA CELULA PARA OUTRA.",0 
	mov edx, OFFSET menuOp4
	call WriteString
	call Crlf

	;menuOp5 BYTE "5 - SELECIONAR UMA CELULA.", 0
	mov edx, OFFSET menuOp5
	call WriteString
	call Crlf

	;menuOp5 BYTE "6 - FUNCAO MAIOR.",0
	mov edx, OFFSET menuOp6
	call WriteString
	call Crlf

	;menuOp6 BYTE "7 - FUNCAO MENOr.",0  
	mov edx, OFFSET menuOp7
	call WriteString
	call Crlf

	;menuOp6 BYTE "8 - FUNCAO CONT.NUM.",0  
	mov edx, OFFSET menuOp8
	call WriteString
	call Crlf

	;menuOp6 BYTE "7 - COPIAR FORMULA .",0  
	mov edx, OFFSET menuOp9
	call WriteString
	call Crlf
	
	;menuMsg1 BYTE "Digite uma opcao: ",0
	mov edx, OFFSET menuMsg1
	call WriteString 
	
	;Recendo uma entrada do usuário
	;Tratando possiveis entradas invalidas

LeituraOpMenu:  
	call ReadInt
    jo  EntradaInvalida
	push ebx
	mov ebx, 1

	cmp eax, ebx
	je EntradaValida
	inc ebx
	
	cmp eax, ebx
	je EntradaValida
	inc ebx

	cmp eax, ebx
	je EntradaValida
	inc ebx

	cmp eax, ebx
	je EntradaValida
	inc ebx

	cmp eax, ebx
	je EntradaValida
	inc ebx

	cmp eax, ebx
	je EntradaValida
	inc ebx

	cmp eax, ebx
	je EntradaValida
	inc ebx

	cmp eax, ebx
	je EntradaValida
	inc ebx

	cmp eax, ebx
	je EntradaValida

EntradaInvalida:
    mov  edx,OFFSET menuMsgErro
    call WriteString
    jmp  LeituraOpMenu

EntradaValida:
	pop ebx
	pop edx
	ret
ImprimeMenu ENDP

MenorUser PROC

	;Procedimento com o intuito de passar os parametros 
	;para a funcao Modo
	;Quando o usuario digita o intervalo

	pushad
	mov esi, OFFSET Linha1
	mov eax,0
	
	;funcaoMsg1 BYTE "Digite a coluna no qual deseja inserir a funcao: ", 0
	mov edx, OFFSET funcaoMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	push eax		 ; Posição da Coluna na Pilha

	;funcaoMsg2 BYTE "Digite a linha na qual deseja inserir a funca: ", 0
	mov edx, OFFSET funcaoMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA
	
	push eax		 ;Posição da Linha na Pilha

	;Preenchendo célula Aux com os dados do usuário
	;Utilizando o tipo de entrada preencher a célula
	mov edi, OFFSET areaTransferencia
	
	;inserirMsg10 BYTE "Digite o intervalo para calcular o MENOR, (Ex: M=B4:B8): ",0
	mov edx, OFFSET inserirMsg10
	call WriteString
	
	;Inserindo Formula
	mov (Cell  PTR[edi]).typ, 3
	lea edx, (Cell  PTR[edi]).formula		; EDX endereço de onde sera salvo
	mov ecx, tamTexto						; Tamanho máximo digitado
	call ReadString							; Salvando direto na memoria

	;Recuperando a posição da linha e da coluna
	pop eax		;Linha
	pop ebx		;Coluna

	;CHAMANDO A FUNCAO INSERE 
	call EnderecoCelula
	call InserirCelula

	;Receuperando valores originais dos registradores
	popad

	ret

MenorUser ENDP

MaiorUser PROC
	;Procedimento com o intuito de passar os parametros 
	;para a funcao Modo
	;Quando o usuario digita o intervalo

	pushad
	mov esi, OFFSET Linha1
	mov eax,0
	
	;funcaoMsg1 BYTE "Digite a coluna no qual deseja inserir: ", 0
	mov edx, OFFSET funcaoMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	push eax		 ; Posição da Coluna na Pilha

	;funcaoMsg2 BYTE "Digite a linha na qual deseja inserir: ", 0
	mov edx, OFFSET funcaoMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA
	
	push eax		 ;Posição da Linha na Pilha

	;Preenchendo célula Aux com os dados do usuário
	;Utilizando o tipo de entrada preencher a célula
	mov edi, OFFSET areaTransferencia
	
	;inserirMsg9 BYTE "Digite o intervalo para calcular o MODO "Ex: =MODO(A2:A4)": ",0
	mov edx, OFFSET inserirMsg9
	call WriteString
	
	;Inserindo Formula
	mov (Cell  PTR[edi]).typ, 3
	lea edx, (Cell  PTR[edi]).formula		; EDX endereço de onde sera salvo
	mov ecx, tamTexto						; Tamanho máximo digitado
	call ReadString							; Salvando direto na memoria

	;Recuperando a posição da linha e da coluna
	pop eax		;Linha
	pop ebx		;Coluna

	;CHAMANDO A FUNCAO INSERE 
	call EnderecoCelula
	call InserirCelula

	;Receuperando valores originais dos registradores
	popad

	ret

MaiorUser ENDP

ContNumUser PROC

	;Essa formula tem como objetivo contar o número de células que estão preenchidas em um determinado intervalo de uma coluna.
	
	pushad
	mov esi, OFFSET Linha1
	mov eax,0
	
	;funcaoMsg1 BYTE "Digite a coluna no qual deseja inserir a funcao: ", 0
	mov edx, OFFSET funcaoMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	push eax		 ; Posição da Coluna na Pilha

	;funcaoMsg2 BYTE "Digite a linha na qual deseja inserir a funcao: ", 0
	mov edx, OFFSET funcaoMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA
	
	push eax		 ;Posição da Linha na Pilha

	;Preenchendo célula Aux com os dados do usuário
	;Utilizando o tipo de entrada preencher a célula
	mov edi, OFFSET areaTransferencia
	
	;inserirMsg11 BYTE "Digite o intervalo para CONT.NUM, (Ex: C=E1:B5): ",0
	mov edx, OFFSET inserirMsg11
	call WriteString
	
	;Inserindo Formula
	mov (Cell  PTR[edi]).typ, 3
	lea edx, (Cell  PTR[edi]).formula		; EDX endereço de onde sera salvo
	mov ecx, tamTexto						; Tamanho máximo digitado
	call ReadString							; Salvando direto na memoria

	;Recuperando a posição da linha e da coluna
	pop eax		;Linha
	pop ebx		;Coluna

	;CHAMANDO A FUNCAO INSERE 
	call EnderecoCelula
	call InserirCelula

	;Receuperando valores originais dos registradores
	popad

	ret

ContNumUser ENDP

InserirUser PROC
	;Função com o intuito de passar os parametros 
	;para a funcao InserirCelula
	;Quando o usuário digita os valores
	;RECEBE: ESI com o inicio da Tabela 
	;No caso a linha e a coluna a se inserir
	;quando o usuário digita esses valores
	push eax
	push edx
	push edi
	push ebx
	push ecx
	push esi

	mov eax,0

	;inserirMsg1 BYTE "Digite a coluna no qual deseja inserir: ", 0

	mov edx, OFFSET inserirMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	push eax		 ; Posição da Coluna na Pilha

	;inserirMsg2 BYTE "Digite a linha na qual deseja inserir: ", 0

	mov edx, OFFSET inserirMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA
	
	push eax		 ;Posição da Linha na Pilha

	;inserirMsg3 BYTE "Digite o tipo de entrada: (1)Int, (2)String, (3)Formula: ", 0

	mov edx, OFFSET inserirMsg3
	call WriteString
	call ReadHex	 ;EAX = Tipo de Entrada

	;Preenchendo célula Aux com os dados do usuário
	;Utilizando o tipo de entrada preencher a célula
	mov edi, OFFSET areaTransferencia
	
	mov ebx, 1
	cmp ebx, eax
	je InsereUserInt
	mov ebx, 2
	cmp ebx, eax
	je InsereUserString
	mov ebx, 3
	cmp ebx, eax
	je InsereUserFormula

InsereUserInt: 
	;inserirMsg6 BYTE "Digite o INTEIRO: ",0
	mov edx, OFFSET inserirMsg6
	call WriteString
	call ReadInt	 ;EAX = ENTRADA
	mov (Cell  PTR[edi]).numInt, eax
	mov (Cell  PTR[edi]).typ, 1
	mov ecx, eax	 ;ECX = ENTRADA

	jmp FimUserInsere

InsereUserString:
	;inserirMsg7 BYTE "Digite uma STRING(Maximo 8 digitos): ",0
	mov edx, OFFSET inserirMsg7
	call WriteString
	
	;Inserindo String
	mov (Cell  PTR[edi]).typ, 2
	lea edx, (Cell  PTR[edi]).text ; EDX endereço de onde sera salvo
	mov ecx, tamTexto			   ; Tamanho máximo digitado
	call ReadString				   ; Salvando direto na memoria	
	jmp FimUserInsere

InsereUserFormula:
	;inserirMsg8 BYTE "Digite uma FORMULA(Ex: =A4*A5): ",0
	mov edx, OFFSET inserirMsg8
	call WriteString
	
	;Inserindo Formula
	mov (Cell  PTR[edi]).typ, 3
	lea edx, (Cell  PTR[edi]).formula		; EDX endereço de onde sera salvo
	mov ecx, tamTexto						; Tamanho máximo digitado
	call ReadString							; Salvando direto na memoria
	
	call controladorFormula	
	
	jmp FimUserInsere

FimUserInsere:
	;Recuperando a posição da linha e da coluna
	pop eax		;Linha
	pop ebx		;Coluna

	;CHAMANDO A FUNCAO INSERE 
	call EnderecoCelula
	call InserirCelula

	;Receuperando valores originais dos registradores
	pop esi
	pop ecx
	pop ebx
	pop edi
	pop edx
	pop eax

	ret

InserirUser ENDP

ExcluirUser PROC
	;Função com o intuito de passar os parametros 
	;para a funcao excluir
	;RECEBE: ESI com o inicio da Tabela
	;No caso a linha e a coluna a se excluir
	;quando o usuário digita esses valores

	push edx
	push eax
	push ebx
	;Recebendo os valores do usuário

	mov edx, OFFSET excluirMsg1
	call WriteString
	call ReadHex	;EAX = COLUNA
	push eax		;Coluna na pilha

	mov edx, OFFSET excluirMsg2
	call WriteString
	call ReadHex	;EAX = Linha
	push eax		;Linha na PILHA

	pop eax
	pop ebx
	
	push esi
	call EnderecoCelula
	call ExcluirCelula
	pop esi

	;Recuperando valores iniciais 

	pop ebx
	pop eax
	pop edx

	ret

ExcluirUser ENDP

CopiarUser PROC
	;Procedimento que executa a funcionalida(Copiar/Colar) com o usuario
	;Solicita a Celula a ser copiada
	;Solicita o destino a ser colado
	;Executa a ação Copiar/Colar
	push esi
	push eax
	push edx
	push ebx

	mov eax,0

	;copiarMsg1	BYTE "Digite a coluna da celula que deseja copiar: ",0

	mov edx, OFFSET copiarMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	mov ebx, eax	 ; EBX recebe a COLUNA

	;copiarMsg2	BYTE "Digite a linha da celula que deseja copiar: ", 0

	mov edx, OFFSET copiarMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA

	mov esi, OFFSET Linha1
	call EnderecoCelula
	call CopiarCelula

	;copiarMsg3	BYTE "Digite a coluna da celula para onde deseja colar: ",0

	mov edx, OFFSET copiarMsg3
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	mov ebx, eax	 ; EBX recebe a COLUNA

	;copiarMsg4	BYTE "Digite a linha da celula para onde  deseja colar: ", 0

	mov edx, OFFSET copiarMsg4
	call WriteString
	call ReadHex	 ;EAX = LINHA

	mov esi, OFFSET Linha1
	call EnderecoCelula
	call ColarCelula

	;Recuperando Registradores
	pop ebx
	pop edx
	pop eax
	pop esi

	ret
CopiarUser ENDP

CopiaFormulaUser PROC
	;Procedimento que executa a funcionalida(Copiar/Colar) com o usuario
	;Solicita a Celula a ser copiada
	;Solicita o destino a ser colado
	;Executa a ação Copiar/Colar
	push esi
	push eax
	push edx
	push ebx

	mov eax,0

	;copiarMsg1	BYTE "Digite a coluna da celula que deseja copiar: ",0

	mov edx, OFFSET copiarMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	mov ebx, eax	 ; EBX recebe a COLUNA

	;copiarMsg2	BYTE "Digite a linha da celula que deseja copiar: ", 0

	mov edx, OFFSET copiarMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA

	mov esi, OFFSET Linha1
	call EnderecoCelula
	call CopiarCelula

	;copiarMsg3	BYTE "Digite a coluna da celula para onde deseja colar: ",0

	mov edx, OFFSET copiarMsg3
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	mov ebx, eax	 ; EBX recebe a COLUNA

	;copiarMsg4	BYTE "Digite a linha da celula para onde  deseja colar: ", 0

	mov edx, OFFSET copiarMsg4
	call WriteString
	call ReadHex	 ;EAX = LINHA

	;VAMOS MODIFICAR A COLUNA
	push edx
	push ebx
	push edi
	add bl, 37h
	mov edi, OFFSET areaTransferencia
	lea edx,(CELL PTR[edi]).formula
	mov [edx+1], bl
	mov [edx+4], bl
	pop edi
	pop ebx
	pop edx

	mov esi, OFFSET Linha1
	call EnderecoCelula
	call ColarCelula

	;Recuperando Registradores
	pop ebx
	pop edx
	pop eax
	pop esi

	ret
CopiaFormulaUser ENDP

RecortarUser PROC
	;Procedimento que executa a funcionalida(Recortar/Colar) com o usuario
	;Solicita a Celula a ser recortado
	;Solicita o destino a ser colado
	;Executa a ação Recortar/Colar

	push esi
	push eax
	push edx
	push ebx

	mov eax,0

	;recortarMsg1 BYTE "Digite a coluna da celula que deseja recortar: ",0

	mov edx, OFFSET recortarMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	mov ebx, eax	 ; EBX recebe a COLUNA

	;recortarMsg2 BYTE "Digite a linha da celula que deseja recortar: ",0

	mov edx, OFFSET recortarMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA

	mov esi, OFFSET Linha1
	call EnderecoCelula
	call CopiarCelula
	call ExcluirCelula
	
	;recortarMsg3 BYTE "Digite a coluna da celula onde deseja colar: ",0
	mov edx, OFFSET recortarMsg3
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	mov ebx, eax	 ; EBX recebe a COLUNA

	;copiarMsg4	BYTE "Digite a linha da celula para onde  deseja colar: ", 0

	mov edx, OFFSET recortarMsg4
	call WriteString
	call ReadHex	 ;EAX = LINHA

	mov esi, OFFSET Linha1
	call EnderecoCelula
	call ColarCelula

	;Recuperando Registradores
	pop ebx
	pop edx
	pop eax
	pop esi

	ret
RecortarUser ENDP

SelecionaCelula PROC
	;Procedimento para imprimir a Barra de Formulas 
	;Mostrando assim a fórmula de uma determinada célula

	;Guardando valores primitivos dos registradores
	push eax
	push ebx
	push esi
	push edx

	;selecionarMsg1 BYTE "Digite a coluna da celula que deseja selecionar: ", 0

	mov edx, OFFSET selecionarMsg1
	call WriteString
	call ReadHex	 ; EAX = COLUNA
	mov ebx, eax	 ; EBX recebe a COLUNA

	;selecionarMsg2 BYTE "Digite a linha da celula que deseja selecionar: ", 0

	mov edx, OFFSET selecionarMsg2
	call WriteString
	call ReadHex	 ;EAX = LINHA

	mov esi, OFFSET Linha1
	call EnderecoCelula

	;selecionarMsg3 BYTE "Barra de formulas: ",0
	
	mov edx, OFFSET selecionarMsg3
	call Crlf
	call WriteString

	lea edx,(CELL PTR[esi]).formula
	call WriteString
	call Crlf

	;Recuperando valores
	pop edx
	pop esi
	pop ebx
	pop eax
		
	ret
SelecionaCelula ENDP








