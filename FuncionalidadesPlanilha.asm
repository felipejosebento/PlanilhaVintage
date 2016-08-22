;TITLE Planilha-Vintage-Funcionalidades(FelipeJoseBento)
;Arquivos com todas as funçoes relacionadas com manipulação de celulas


InserirCelula PROC
	 ; Procedimento para inserir um valor em uma célula
	 ; O usuário primeiramente digita a coluna que o valor seria inserido
	 ; em seguida digita a linha
	 ; Apos o usuário digita o tipo de valor que ele irá inserir (1->Inteiro , 2->String, 3->Fórmula)
	 ; RECEBE: Origem(Área de tranferencia ou Célula da Planilha) em EDI
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
	;Função que calcula a posição na mémoria em coloca o resultado em ESI
	;RECEBE: eax com a Linha da célula
	;RECEBE: ebx com a Coluna da célula
	;RECEBE: esi com o Início da TABELA
	;RETORNA: esi com o endereco da celula na memória
	push ebx
	push edx
	push eax
	push ecx

	;FORMULA PARA O ENDEREÇO DESTINO
	;Planilha[i, j] = offset Linha1 + (i * 5 *sizeof(Celula)) + (j * sizeof(Celula))
	;Tamanho da CELL é 23 bytes
	;Numero de coluna é 5

	dec eax		;Pois a memória começa na posição ZERO e não na posição 1
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

	;Calculo do Endereço da Célula
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
	;Função para excluir uma célula da planilha
	;RECEBE ESI com o endereco da celula a ser excluida
	;Após excluir, confirma a exclusão
	push eax
	push edx
	push ecx

	lea edx, (Cell  PTR[esi]).typ ; EDX endereço do tipo
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
	mov (Cell  PTR[esi]).typ, 0		;Célula Vazia
	mov eax, 0
	mov (Cell  PTR[esi]).numInt, eax
	jmp ExcluirFim

ExcluirString:
	mov (Cell  PTR[esi]).typ, 0		;Célula Vazia
	lea edx, (Cell  PTR[esi]).text	;EDX endereço com o texto a ser apagado
	mov ecx, tamTexto

	;Colocando NULL na String da célula

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
	;Procedimento que copia uma célula para Area de Transferencia (CellAux Cell <>)
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
	;Procedimento que cola uma célula da área de transferência para uma célula da planilha
	;RECEBE: Endereco de Destino em ESI

RecortarCelula ENDP

ColarCelula PROC
	;Procedimento que cola uma célula da área de transferência para uma célula da planilha
	;RECEBE: Endereco de Destino em ESI
	push edi

	mov edi, OFFSET areaTransferencia
	call InserirCelula

	pop edi
	ret
ColarCelula ENDP








