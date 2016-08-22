;TITLE Planilha-Vintage-Funcionalidades(FelipeJoseBento)
;Arquivos com todas as fun�oes relacionadas com manipula��o de celulas


InserirCelula PROC
	 ; Procedimento para inserir um valor em uma c�lula
	 ; O usu�rio primeiramente digita a coluna que o valor seria inserido
	 ; em seguida digita a linha
	 ; Apos o usu�rio digita o tipo de valor que ele ir� inserir (1->Inteiro , 2->String, 3->F�rmula)
	 ; RECEBE: Origem(�rea de tranferencia ou C�lula da Planilha) em EDI
	 ; RECEBE: Destino em ESI
	
	;Guardando valores dos registradores
	push esi
	push ecx
	push edx
	push eax

	;Inserindo Valor
	mov eax, 0
	mov eax, (Cell  PTR[edi]).numInt
	mov (Cell  PTR[esi]).numInt, eax  
	mov eax, 0
	mov al, (Cell  PTR[edi]).typ
	mov (Cell  PTR[esi]).typ, al
	mov eax, 0
	mov ecx, tamTexto
	lea edx, (Cell  PTR[edi]).text
	push ebx
	lea ebx, (Cell  PTR[esi]).text
LoopInsere:
	mov eax, 0
	mov al, [edx]
	mov [ebx], al
	inc edx
	inc ebx
	loop LoopInsere 
	mov ecx, tamTexto
	lea edx, (Cell  PTR[edi]).formula
	lea ebx, (Cell  PTR[esi]).formula
LoopInsere2:
	mov eax, 0
	mov al, [edx]
	mov [ebx], al
	inc edx
	inc ebx
	loop LoopInsere2
	pop ebx
	
	;Recuperando Valores
	pop eax
	pop edx
	pop ecx 
	pop esi

	ret
	
InserirCelula ENDP

EnderecoCelula PROC
	;Fun��o que calcula a posi��o na m�moria em coloca o resultado em ESI
	;RECEBE: eax com a Linha da c�lula
	;RECEBE: ebx com a Coluna da c�lula
	;RECEBE: esi com o In�cio da TABELA
	;RETORNA: esi com o endereco da celula na mem�ria
	push ebx
	push edx
	push eax
	push ecx

	;FORMULA PARA O ENDERE�O DESTINO
	;Planilha[i, j] = offset Linha1 + (i * 5 *sizeof(Celula)) + (j * sizeof(Celula))
	;Tamanho da CELL � 23 bytes
	;Numero de coluna � 5

	dec eax		;Pois a mem�ria come�a na posi��o ZERO e n�o na posi��o 1
	mov edx, 5	
	;Multiplicando Linha*5
	;Pois quando pula uma linha
	;Na verdade pula 5 colunas
	mul edx		
	push eax	
	mov edx, 0
	mov eax, ebx
	mov ebx, 0Ah
	div ebx
	mov ebx, edx
	pop eax

	;Calculo do Endere�o da C�lula
	mov esi, OFFSET Linha1
	mov edx, 0
	mov ecx, TYPE CELL
	mul ecx
	add esi, eax

	mov eax, ebx
	mul ecx
	add esi, eax
	
	pop ecx
	pop eax
	pop edx
	pop ebx

	ret
EnderecoCelula ENDP

ExcluirCelula PROC
	;Fun��o para excluir uma c�lula da planilha
	;RECEBE ESI com o endereco da celula a ser excluida
	;Ap�s excluir, confirma a exclus�o
	push eax
	push edx
	push ecx

	lea edx, (Cell  PTR[esi]).typ ; EDX endere�o do tipo
	mov eax, 0
	cmp eax, [edx]
	je ExcluirFim
	inc eax
	cmp eax, [edx]
	je ExcluirInt
	inc eax
	cmp eax, [edx]
	je ExcluirString
	inc eax
	cmp eax, [edx]
	je ExcluirFormula

ExcluirInt:
	mov (Cell  PTR[esi]).typ, 0		;C�lula Vazia
	mov eax, 0
	mov (Cell  PTR[esi]).numInt, eax
	jmp ExcluirFim

ExcluirString:
	mov (Cell  PTR[esi]).typ, 0		;C�lula Vazia
	lea edx, (Cell  PTR[esi]).text	;EDX endere�o com o texto a ser apagado
	mov ecx, tamTexto

	;Colocando NULL na String da c�lula

ExluirStringAux:
	mov eax,0
	mov [edx], al
	inc edx
	loop ExluirStringAux
	jmp ExcluirFim

ExcluirFormula:
	jmp ExcluirFim

ExcluirFim:
	;recuperando valores 
	pop ecx
	pop edx
	pop eax

	ret
ExcluirCelula ENDP



CopiarCelula PROC
	;Procedimento que copia uma c�lula para Area de Transferencia (CellAux Cell <>)
	;RECEBE: Endereco da celula a ser copiada em ESI
	
	push edi
	push edx
	
	mov edx, OFFSET areaTransferencia
	mov edi, esi ;ORIGEM (Recebida em ESI)
	push esi
	mov esi, edx ;DESTINO

	call InserirCelula
	;Recuperando valores 
	pop esi
	pop edx
	pop edi
	
	ret
CopiarCelula ENDP



RecortarCelula PROC
	;Procedimento que cola uma c�lula da �rea de transfer�ncia para uma c�lula da planilha
	;RECEBE: Endereco de Destino em ESI

RecortarCelula ENDP

ColarCelula PROC
	;Procedimento que cola uma c�lula da �rea de transfer�ncia para uma c�lula da planilha
	;RECEBE: Endereco de Destino em ESI
	push edi

	mov edi, OFFSET areaTransferencia
	call InserirCelula

	pop edi
	ret
ColarCelula ENDP








