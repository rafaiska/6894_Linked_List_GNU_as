.section .data

titgeral: .asciz "\n*** LISTA LIGADA DE REGISTROS ***\n\n"
titins: .asciz "\nINSERCAO:\n"
titrem: .asciz "\nREMOCAO:\n"
titcon: .asciz "\nBUSCA POR REGISTRO\n"
titmos: .asciz "\nMOSTRANDO TODOS OS REGISTROS:\n"
titreg: .asciz "\Registro no %d:"
titalt: .asciz "\nALTERACAO DE REGISTRO:\n"

menu: .asciz "\nESCOLHA A OPCAO:\n1 - INSERIR REGISTRO\n2 - REMOVER REGISTRO\n3 - BUSCAR REGISTRO\n4 - LISTAR TODOS\n5 - ALTERAR REGISTRO\n6 - ALTERAR ORDENACAO\n7 - SAIR\n> "
menucatalogacao: .asciz "\nComo voce deseja catalogar os registros?\n1 - Por nome\n2 - Por idade\n> "

msgalterar: .asciz "Registro encontrado! Entre com novos dados:\n"
msgerro: .asciz "\nOPCAO INCORRETA!\n"
msgvazia: .asciz "\nLISTA VAZIA!\n"
msgremov: .asciz "\nREGISTRO REMOVIDO!\n"
msginser: .asciz "\nREGISTRO INSERIDO!\n"
msgnencontrado: .asciz "\nREGISTRO NAO ENCONTRADO\n"
msgencontrado: .asciz "\nREGISTRO ENCONTRADO:\n"
pedenome: .asciz "\nDigite o nome: "
pededia: .asciz "Digite o dia de nascimento: "
pedemes: .asciz "Digite o mes de nascimento: "
pedeano: .asciz "Digite o ano de nascimento: "
pedesexo: .asciz "Qual o sexo, <F>eminino ou <M>asculino?: "
pedeprofissao: .asciz "Digite a profissao: "
pedesalario: .asciz "Digite o salario: "

mostranome: .asciz "\nNome: %s"
mostranasc: .asciz "\nData de Nasc.: %2d/%2d/%2d"
mostrasexo: .asciz "\nSexo: %c"
mostraprof: .asciz "\nProfissao: %s"
mostrasala: .asciz "\nSalario: %.2f\n"

mostrapt: .asciz "\nptreg = %d\n"

formastr: .asciz "%s"
formach: .asciz "%c"
formanum: .asciz "%d"
formaflt: .asciz "%f"

pulalinha: .asciz "\n"

opcao: .int 0
#Essa variavel controla o modo de classificacao dos registros
#	0: Ordenados por nome
#	1: Ordenados por data de nascimento
opcao_sort: .int 0

nome: .space 44
dian: .int 0
mesn: .int 0
anon: .int 0
sexo: .space 4
profissao: .space 24
salario: .float 0
prox: .int 0

naloc: .int 92
ptpilha: .int 0
ptreg: .int 0
ptprox: .int 0
ptant: .int 0
endret: .int 0

.section .text
.globl _start
_start:
	jmp main

#FUNCAO QUE MUDA O METODO DE CATALOGACAO DOS REGISTROS
mudar_catalogacao:
	pushl $menucatalogacao
	call printf
	addl $4, %esp

	pushl $opcao
	pushl $formanum
	call scanf
	addl $8, %esp

	#para limpar o buffer:
	pushl $formach
	call scanf
	addl $4, %esp

	cmpl $1, opcao
	jz mudar_catalogacao_pornome

	cmpl $2, opcao
	jz mudar_catalogacao_pordata
	
	pushl $msgerro
	call printf
	addl $4, %esp

	jmp menuop

mudar_catalogacao_pornome:
	movl $0, opcao_sort
	jmp mudar_catalogacao_sort

mudar_catalogacao_pordata:
	movl $1, opcao_sort

mudar_catalogacao_sort:
	pushl opcao_sort
	pushl ptpilha
	call sortallreg
	popl %eax
	movl %eax, ptpilha
	addl $4, %esp
	jmp menuop

le_dados:
	pushl %edi

	pushl $pedenome
	call printf
	addl $4, %esp
	call gets

	popl %edi
	addl $44, %edi
	pushl %edi

	pushl $pedeano
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $pedemes
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $pededia
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	#limpando buffer
	pushl $formach
	call scanf
	addl $4, %esp

	pushl $pedesexo
	call printf
	addl $4, %esp
	pushl $formach
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	#limpando buffer
	pushl $formach
	call scanf
	addl $4, %esp

	pushl $pedeprofissao
	call printf
	addl $4, %esp
	call gets

	popl %edi
	addl $24, %edi
	pushl %edi

	pushl $pedesalario
	call printf
	addl $4, %esp
	pushl $formaflt
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi

	#limpando buffer
	pushl $sexo
	pushl $formach
	call scanf
	addl $8, %esp

	movl $0, (%edi)
	subl $88, %edi

	RET

mostra_dados:
	pushl %edi

	pushl $mostranome
	call printf
	addl $4, %esp

	popl %edi
	addl $44, %edi
	pushl %edi

	#push dia
	pushl (%edi)
	addl $4, %edi

	#push mes
	pushl (%edi)
	addl $4, %edi

	#push ano
	pushl (%edi)
	
	pushl $mostranasc
	call printf
	addl $16, %esp

	popl %edi
	addl $12, %edi
	pushl %edi

	pushl (%edi)
	pushl $mostrasexo
	call printf
	addl $8, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $mostraprof
	call printf
	addl $4, %esp

	popl %edi
	addl $24, %edi
	pushl %edi

	movl (%edi), %esi
	movl %esi, salario
	flds salario
	subl $8, %esp
	fstpl (%esp)
	pushl $mostrasala
	call printf
	addl $12, %esp

	#foram percorridos 84 bytes (92 - 4 do salario - 4 do ponteiro)
	popl %edi
	subl $84, %edi

	RET

inserir:
	pushl $titins
	call printf

	movl naloc, %ecx
	pushl %ecx
	call malloc
	movl %eax, ptreg

	pushl ptreg
	pushl $mostrapt
	call printf

	addl $16, %esp

	movl ptreg, %edi
	call le_dados

	movl ptpilha, %eax
	cmpl $0, %eax
	jnz insereemordem

	#a lista esta vazia, inserir primeiro
	movl %edi, ptpilha
	jmp endinserte

insereemordem:
	movl %eax, ptprox
	pushl ptreg
	pushl ptprox

	cmpl $1, opcao_sort
	jz insereemordem_bydata

	call comparastring
	jmp insereemordem_continua

insereemordem_bydata:
	call comparadata

insereemordem_continua:
	addl $8, %esp
	cmpl $2, %edi 
	jz insereemordem_l1

	movl ptreg, %eax
	movl ptpilha, %ebx
	movl %ebx, 88(%eax)
	movl %eax, ptpilha
	jmp endinserte

insereemordem_l1:
	movl ptprox, %eax
	movl %eax, ptant
	movl 88(%eax), %ebx
	movl %ebx, ptprox
	cmpl $0, %ebx
	jz insereemordem_end

	pushl ptreg
	pushl ptprox

	cmpl $1, opcao_sort
	jz insereemordem_l1_bydata

	call comparastring
	jmp insereemordem_l1_continua

insereemordem_l1_bydata:
	call comparadata

insereemordem_l1_continua:
	addl $8, %esp
	cmpl $2, %edi
	jz insereemordem_l1

insereemordem_end:
	movl ptant, %eax
	movl ptreg, %ebx
	movl %ebx, 88(%eax)
	movl ptprox, %eax
	movl %eax, 88(%ebx)

endinserte:
	pushl $msginser
	call printf
	addl $4, %esp

	jmp menuop

#FUNCAO REMOVER
#remove um registro de nome especifico da lista
#o ponteiro para a string contendo o nome do removido deve ser
#passado pelo registrador %edi
remover:
	pushl $titrem
	call printf
	addl $4, %esp

	pushl $pedenome
	call printf
	addl $4, %esp

	pushl $nome
	call gets
	call buscarreg
	addl $4, %esp

	cmpl $0, %edi
	jnz remover_c

	pushl $msgnencontrado
	call printf
	addl $4, %esp

	jmp menuop

remover_c:
	cmpl $0, %esi
	jz remover_inicio

	movl 88(%edi), %eax
	movl %eax, 88(%esi)

	jmp remover_fim

remover_inicio:
	movl 88(%edi), %eax
	movl %eax, ptpilha

remover_fim:
	pushl %edi
	call free
	addl $4, %esp

	pushl $msgremov
	call printf
	addl $4, %esp
	jmp menuop

#FUNCAO PARA BUSCAR UM REGISTRO
#Parametro empilhado: string do registro a ser buscado
#
#Retorna o ponteiro para o registro procurado em %edi
#e o ponteiro do registro anterior a ele em %esi
#(caso o registro em %edi seja o primeiro, %esi sera NULL)
#(caso o registro nao seja encontrado, retorna NULL em %edi)
buscarreg:
	popl %edi
	movl %edi, endret	
	movl ptpilha, %edi
	pushl %edi
	movl $0, %esi

buscarreg_l1:
	cmpl $0, %edi
	jz buscarreg_ret
	call comparastring
	cmpl $0, %edi
	jz buscarreg_ret

	popl %esi
	movl 88(%esi), %edi
	pushl %edi
	jmp buscarreg_l1

buscarreg_ret:
	popl %edi
	pushl endret
	ret

#Essa funcao eh chamada pelo menu. Ela invoca buscarreg para
#encontrar um registro e o mostra na tela, caso encontrar
buscar:
	pushl $titcon
	call printf
	addl $4, %esp

	pushl $pedenome
	call printf
	addl $4, %esp

	pushl $nome
	call gets
	call buscarreg
	addl $4, %esp

	cmpl $0, %edi
	jz buscar_notfound

	pushl $msgencontrado
	call printf
	addl $4, %esp
	call mostra_dados
	jmp buscar_fim

buscar_notfound:
	pushl $msgnencontrado
	call printf
	addl $4, %esp
	jmp buscar_fim

buscar_fim:
	jmp menuop

#Mostra todos os registros da lista
mostratudo:
	movl ptpilha, %edi
	cmpl $0, %edi
	jz listavazia

mostraelemento:
	call mostra_dados
	movl 88(%edi), %edi
	cmpl $0, %edi
	jnz mostraelemento
	jmp menuop
	
listavazia:
	pushl $msgvazia
	call printf
	addl $4, %esp
	jmp menuop	

alterar:
	pushl $titalt
	call printf
	addl $4, %esp

	pushl $pedenome
	call printf
	addl $4, %esp

	pushl $nome
	call gets
	call buscarreg
	addl $4, %esp

	cmpl $0, %edi
	jnz alterar_c

	pushl $msgnencontrado
	call printf
	addl $4, %esp
	jmp menuop

alterar_c:
	pushl $msgalterar
	call printf
	addl $4, %esp

	addl $44, %edi
	pushl %edi

	pushl $pedeano
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $pedemes
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $pededia
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	#limpando buffer
	pushl $formach
	call scanf
	addl $4, %esp

	pushl $pedesexo
	call printf
	addl $4, %esp
	pushl $formach
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	#limpando buffer
	pushl $formach
	call scanf
	addl $4, %esp

	pushl $pedeprofissao
	call printf
	addl $4, %esp
	call gets

	popl %edi
	addl $24, %edi
	pushl %edi

	pushl $pedesalario
	call printf
	addl $4, %esp
	pushl $formaflt
	call scanf
	addl $8, %esp

	#limpando buffer
	pushl $sexo
	pushl $formach
	call scanf
	addl $8, %esp

menuop:
	pushl $menu
	call printf

	pushl $opcao
	pushl $formanum
	call scanf

	addl $12, %esp

	#para limpar o buffer:
	pushl $formach
	call scanf
	addl $4, %esp

	cmpl $1, opcao
	jz inserir
	cmpl $2, opcao
	jz remover
	cmpl $3, opcao
	jz buscar
	cmpl $4, opcao
	jz mostratudo
	cmpl $5, opcao
	jz alterar
	cmpl $6, opcao
	jz mudar_catalogacao
	cmpl $7, opcao
	jz fim

	pushl $msgerro
	call printf
	addl $4, %esp

	jmp menuop

main:
	pushl $titgeral
	call printf
	jmp menuop

fim:
	pushl $0
	call exit
