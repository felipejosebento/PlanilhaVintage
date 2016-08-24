TITLE Planilha-Vintage(FelipeJoseBento)

INCLUDE Irvine32.inc
  
tamTexto = 8 
       
;Criãção de uma Struct, a célula no caso          
Cell STRUCT          
	typ BYTE 0h			 				; Tipo da célula, onde 0->Vazia 1 ->Inteiro, 2->String, 3->Formula (De padrão - VAZIA)
	numInt DWORD 00000000h				; Um inteiro terá um tamanho máximo de (2^32)/2 , sendo positivo ou negativo
	text BYTE tamTexto DUP(?),0			; Um título em uma célula ou texto, terá no máximo 8 characteres ASCII
	formula BYTE tamTexto DUP(?),0		; Uma fórmula terá tamanho máximo de 10 characteres ASCII 
Cell ENDS  
   

TotalColunas = 5 ; Total de colunas que terá a planilha, sendo (A,B,C,D,E) 
TotalLinhas= 11	 ; Total de linha que terá a planilha, sendo de 1 até TotalLinhas 

.data   
;Linhas, onde cada elemento é uma Struct(CELL)
Linha1  Cell TotalColunas DUP(<>)   
Linha2  Cell TotalColunas DUP(<>)
Linha3  Cell TotalColunas DUP(<>)
Linha4  Cell TotalColunas DUP(<>) 
Linha5  Cell TotalColunas DUP(<>)   
Linha6  Cell TotalColunas DUP(<>) 
Linha7  Cell TotalColunas DUP(<>)  
Linha8  Cell TotalColunas DUP(<>) 
Linha9  Cell TotalColunas DUP(<>)   
menu BYTE "PlanilhaVintage - Menu",0
menuOp1 BYTE "1 - INSERIR VALOR OU FORMULA EM UMA CELULA.",0 
menuOp2 BYTE "2 - DELETAR VALOR DE UMA UMA CELULA.",0    
menuOp3 BYTE "3 - COPIAR VALOR OU FORMULA DE UMA CELULA PARA OUTRA.",0  
menuOp4 BYTE "4 - RECORTAR  VALOR DE UMA CELULA PARA OUTRA.",0 
menuOp5 BYTE "5 - SELECIONAR UMA CELULA.", 0 
menuOp6 BYTE "6 - Funcao MAIOR.",0
menuOp7 BYTE "7 - Funcao MENOR.",0 
menuOp8 BYTE "8 - Funcao CONT.VALORES.",0 
menuOp9 BYTE "9 - Arrastar Formula.",0 
menuMsg1 BYTE "Digite uma opcao: ",0
menuMsgErro BYTE "Entrada Invalida, por favor digite novamente: ", 0 
inserirMsg1 BYTE "Digite a coluna no qual deseja inserir: ", 0
inserirMsg2 BYTE "Digite a linha na qual deseja inserir: ", 0 
inserirMsg3 BYTE "Digite o tipo de entrada: (1)Int, (2)String, (3)Formula: ", 0
inserirMsg5 BYTE "Digite a entrada: ", 0 
inserirMsg6 BYTE "Digite o INTEIRO: ",0   
inserirMsg7 BYTE "Digite uma STRING(Maximo 8 digitos): ",0
inserirMsg8 BYTE "Digite uma FORMULA(Ex: =A4*A5): ",0
inserirMsg9 BYTE "Digite o intervalo para calcular o MAIOR, (Ex: M=A2:A6): ",0
inserirMsg10 BYTE "Digite o intervalo para calcular o MENOR, (Ex: N=B4:B8): ",0
inserirMsg11 BYTE "Digite o intervalo para CONT.NUM, (Ex: C=E1:B5): ",0
funcaoMsg1	BYTE "Digite o coluna que deseja inserir a funcao: ",0
funcaoMsg2 BYTE "Digite a linha na qual deseja inserir a funcao: ", 0
excluirMsg1 BYTE "Digite a coluna da celula que deseja excluir: ", 0
excluirMsg2 BYTE "Digite a linha da celula que deseja excluir: ",0
excluirMsg3 BYTE "Celula excluida com sucesso!", 0   
copiarMsg1	BYTE "Digite a coluna da celula que deseja copiar: ",0    
copiarMsg2	BYTE "Digite a linha da celula que deseja copiar: ", 0  
copiarMsg3	BYTE "Digite a coluna da celula para onde deseja colar: ",0 
copiarMsg4	BYTE "Digite a linha da celula para onde  deseja colar: ", 0
recortarMsg1 BYTE "Digite a coluna da celula que deseja recortar: ",0  
recortarMsg2 BYTE "Digite a linha da celula que deseja recortar: ",0  
recortarMsg3 BYTE "Digite a coluna da celula onde deseja colar: ",0 
recortarMsg4 BYTE "Digite a linha da celula onde  deseja colar: ", 0
selecionarMsg1 BYTE "Digite a coluna da celula que deseja selecionar: ", 0
selecionarMsg2 BYTE "Digite a linha da celula que deseja selecionar: ", 0  
selecionarMsg3 BYTE "Barra de formulas: ",0
  
areaTransferencia Cell <> ;AREA DE TRANSFERENCIA   

formulaEntrada DWORD ?  
 
.code   
INCLUDE InterfacePlanilha.asm 
INCLUDE FuncionalidadesPlanilha.asm
INCLUDE ControladorPlanilha.asm 
INCLUDE ControladorFormulas.asm
 
main PROC
	 
	call controladorPrincipal  
	
	exit
main ENDP

END main    