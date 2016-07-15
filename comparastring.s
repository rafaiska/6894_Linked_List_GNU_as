# Funcao para comparar duas strings (delimitadas por \0)
# Parametros passados por pilha: $s1 e $s2 (ponteiros string)
# Valor de retorno passado em %edi:	0 para strings iguais
#					1 para s1 > s2
#					2 para s2 > s1

.global comparastring
.data
	testeparam: .asciz "\nStrings comparadas: '%s' e '%s'\n"
	s1ismenora: .asciz "\n'%s' eh maior que '%s'\n"
	s2ismenora: .asciz "\n'%s' eh menor que '%s'\n"
	endret: .int 0
.text
comparastring:
	popl %eax
	movl %eax, endret
	pushl $testeparam
	call printf
	addl $4, %esp
	call strcmp
	cmpl $0, %eax
	jg s2ismenor
	jl s1ismenor

	movl $0, %edi
	jmp comparastring_ret

s1ismenor:
	pushl $s1ismenora
	call printf
	addl $4, %esp
	movl $2, %edi
	jmp comparastring_ret

s2ismenor:
	pushl $s2ismenora
	call printf
	addl $4, %esp
	movl $1, %edi

comparastring_ret:
	pushl endret
	ret
