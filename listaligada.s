.section .data

titgeral: .asciz "\n*** APLICACAO DE FILA ***\n\n"
titemp: .asciz "\nENFILEIRAMENTO:\n"
titdesemp: .asciz "\nDESENFILEIRAMENTO:\n"
titmostra: .asciz "\nELEMENTOS DA FILA:\n"
titreg: .asciz "\Registro no %d:"

menu: .asciz "\nESCOLHA A OPCAO:\n1 - EFILEIRAR\n2 - DESENFILEIRAR\n3 - MOSTRA\n4 - FIM\n> "

msgerro: .asciz "\nOPCAO INCORRETA!\n"
msgvazia: .asciz "\nPILHA VAZIA!\n"
msgremov: .asciz "\nREGISTRO DESENFILEIRADO!\n"
msginser: .asciz "\nREGISTRO ENFILEIRADO!\n"
pedenome: .asciz "\nDigite o nome: "
pedera: .asciz "Digite o RA: "
pedesexo: .asciz "Qual o sexo, <F>eminino ou <M>asculino?: "
pedecurso: .asciz "Digite o nome do curso: "
pederua: .asciz "Digite o nome da rua: "
pedenumero: .asciz "Digite o numero da casa: "
pedebairro: .asciz "Digite o nome do bairro: "

mostranome: .asciz "\nNome: %s"
mostrara: .asciz "\nRA: %d"
mostrasexo: .asciz "\nSexo: %c"
mostracurso: .asciz "\nCurso: %s\n"

mostrapt: .asciz "\nptreg = %d\n"

formastr: .asciz "%s"
formach: .asciz "%c"
formanum: .asciz "%d"

pulalinha: .asciz "\n"

NULL: .int 0

opcao: .int 0

nome: .space 44
ra: .space 8
sexo: .space 4
curso: .space 24
rua: .space 25
numero: .int 0
bairro: .space 15
prox: .int NULL

naloc: .int 128
ptpilha: .int NULL
ptreg: .int NULL

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

	pushl $pedera
	call printf
	addl $4, %esp
	pushl $formanum
	call scanf
	addl $4, %esp

	popl %edi
	addl $8, %edi
	pushl %edi

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

	pushl $formach
	call scanf
	addl $4, %esp

	pushl $pedecurso
	call printf
	addl $4, %esp
	#pushl $formastr
	call gets
	#addl $4, %esp

	popl %edi
	addl $24, %edi
	movl $NULL, (%edi)

	subl $80, %edi

	RET

mostra_dados:
	pushl %edi

	pushl $mostranome
	call printf
	addl $4, %esp

	popl %edi
	addl $44, %edi
	pushl %edi

	pushl (%edi)
	pushl $mostrara
	call printf
	addl $8, %esp

	popl %edi
	addl $8, %edi
	pushl %edi

	pushl (%edi)
	pushl $mostrasexo
	call printf
	addl $8, %esp

	popl %edi
	addl $4, %edi
	pushl %edi

	pushl $mostracurso
	call printf
	addl $4, %esp

	popl %edi

	subl $56, %edi

	RET

empilha:
	pushl $titemp
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
	jnz gotolast

	movl %edi, ptpilha
	movl $NULL, 80(%edi)
	jmp endinserte

gotolast:
	movl %eax, %ebx
	movl 80(%ebx), %eax
	cmpl $NULL, %eax
	jnz gotolast

	movl %edi, 80(%ebx)
	movl %eax, 80(%edi)

endinserte:
	pushl $msginser

	call printf
	addl $4, %esp

	jmp menuop

desempilha:
	pushl $titdesemp
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

mostrapilha:
	pushl $titmostra
	call printf

	movl ptpilha, %edi
	cmpl $NULL, %edi
	jnz continua2

	pushl $msgvazia
	call printf
	addl $4, %esp

	jmp menuop

continua2:
	movl ptpilha, %edi
	movl $1, %ecx

volta:
	cmpl $NULL, %edi
	#cmpl $3, %ecx
	jz menuop

	pushl %edi

	pushl %ecx
	pushl $titreg
	call printf
	addl $4, %esp

	movl 4(%esp), %edi
	call mostra_dados

	popl %ecx
	incl %ecx
	popl %edi
	movl 80(%edi), %edi

	jmp volta

	jmp menuop

menuop:
	pushl $menu
	call printf

	pushl $opcao
	pushl $formanum
	call scanf

	addl $12, %esp

	pushl $formach
	call scanf
	addl $4, %esp

	cmpl $1, opcao
	jz empilha
	cmpl $2, opcao
	jz desempilha
	cmpl $3, opcao
	jz mostrapilha
	cmpl $4, opcao
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
