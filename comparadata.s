# Funcao para comparar dois registros por data de nascimento
# Parametros passados por pilha: $rA e $rB (ponteiros dos registros)
# Valor de retorno passado em %edi:	0 para datas iguais
#					1 para rA > rB
#					2 para rB > rA

.global comparadata
.data
	endret: .int 0
	valorA: .int 0
	valorB: .int 0
	registroA: .int 0
	registroB: .int 0
.text
comparadata:
	popl %eax
	movl %eax, endret

	movl (%esp), %eax
	movl %eax, registroA
	movl 4(%esp), %eax
	movl %eax, registroB

comparaano:
	movl registroA, %eax
	addl $44, %eax
	movl (%eax), %eax

	movl registroB, %ebx
	addl $44, %ebx
	movl (%ebx), %ebx

	cmpl %eax, %ebx
	jg Bismenor
	Jl Aismenor

comparames:
	movl registroA, %eax
	addl $48, %eax
	movl (%eax), %eax

	movl registroB, %ebx
	addl $48, %ebx
	movl (%ebx), %ebx

	cmpl %eax, %ebx
	jg Bismenor
	Jl Aismenor

comparadia:
	movl registroA, %eax
	addl $52, %eax
	movl (%eax), %eax

	movl registroB, %ebx
	addl $52, %ebx
	movl (%ebx), %ebx

	cmpl %eax, %ebx
	jg Bismenor
	Jl Aismenor

isigual:
	movl $0, %edi
	jmp comparadata_ret

Aismenor:
	movl $2, %edi
	jmp comparadata_ret

Bismenor:
	movl $1, %edi

comparadata_ret:
	pushl endret
	ret
