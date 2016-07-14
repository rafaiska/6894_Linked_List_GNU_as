.section .data

titgeral: .asciz "\n*** LISTA LIGADA DE REGISTROS ***\n\n"
titins: .asciz "\nINSERCAO:\n"
titrem: .asciz "\nREMOCAO:\n"
titcon: .asciz "\nBUSCA POR REGISTRO %s:\n"
titmos: .asciz "\nMOSTRANDO TODOS OS REGISTROS:\n"
titreg: .asciz "\Registro no %d:"

menu: .asciz "\nESCOLHA A OPCAO:\n1 - INSERIR REGISTRO\n2 - REMOVER REGISTRO\n3 - BUSCAR REGISTRO\n4 - LISTAR TODOS\n5 - SAIR\n> "

msgerro: .asciz "\nOPCAO INCORRETA!\n"
msgvazia: .asciz "\nLISTA VAZIA!\n"
msgremov: .asciz "\nREGISTRO REMOVIDO!\n"
msginser: .asciz "\nREGISTRO INSERIDO!\n"
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
mostrasala: .asciz "\nSalario: %d\n"

mostrapt: .asciz "\nptreg = %d\n"

formastr: .asciz "%s"
formach: .asciz "%c"
formanum: .asciz "%d"
formaflt: .asciz "%d"

pulalinha: .asciz "\n"

NULL: .int 0

opcao: .int 0

nome: .space 44
dian: .int 0
mesn: .int 0
anon: .int 0
sexo: .space 4
profissao: .space 24
salario: .float 0
prox: .int NULL

naloc: .int 92
ptpilha: .int NULL
ptreg: .int NULL
ptprox: .int NULL
ptant: .int NULL

.section .text
.globl _start
_start:
	jmp main

le_dados:
	pushl %edi

	pushl $pedenome
	call printf
	addl $4, %esp
	call gets

	popl %edi
	addl $44, %edi
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

	pushl $pedemes
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $4, %edi
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

	movl $NULL, (%edi)
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

	pushl (%edi)
	pushl $mostrasala
	call printf
	addl $8, %esp

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
	cmpl $NULL, %eax
	jnz insereemordem

	#a lista esta vazia, inserir primeiro
	movl %edi, ptpilha
	jmp endinserte

insereemordem:
	#TODO: implementar insercao em ordem aqui

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
	#TODO: implementar remocao
	pushl $titrem
	call printf
	addl $4, %esp

	movl ptpilha, %edi
	cmpl $NULL, %edi
	jnz continua

	pushl $msgvazia
	call printf
	addl $4, %esp

	jmp menuop

continua:
	movl ptpilha, %edi
	pushl %edi
	movl 80(%edi), %edi
	movl %edi, ptpilha

	pushl $msgremov
	call printf
	addl $4, %esp

	call free
	addl $4, %esp

	jmp menuop

#FUNCAO PARA BUSCAR UM REGISTRO
#retorna o ponteiro para o registro procurado em %edi
#e o ponteiro do registro anterior a ele em %esi
#(caso o registro em %edi seja o primeiro, %esi sera NULL) 
buscarreg:
	#TODO: implementar busca

#Essa funcao eh chamada pelo menu. Ela invoca buscarreg para
#encontrar um registro e o mostra na tela, caso encontrar
buscar:
	#TODO: implementar interface de busca

#Mostra todos os registros da lista
mostratudo:
	#TODO: implementar mostra tudo
	movl ptpilha, %edi
	cmpl $NULL, %edi
	jz listavazia

mostraelemento:
	call mostra_dados
	movl 88(%edi), %edi
	cmpl $NULL, %edi
	jnz mostraelemento
	jmp menuop
	
listavazia:
	pushl $msgvazia
	call printf
	jmp menuop	

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
