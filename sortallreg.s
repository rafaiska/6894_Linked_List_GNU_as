# Funcao que ordena uma lista de registros
# Parametros passados por pilha:
#	PONTEIRO DA LISTA
#	CAMPO DE ORDENACAO (0 para nome, 1 para data de nascimento)
.global sortallreg
.data
	reg_inicial: .int 0
	ant_reg_inicial: .int 0
	reg_anterior: .int 0
	reg_atual: .int 0
	maior_reg: .int 0
	ant_maior_reg: .int 0
	endret: .int 0
	opcao_sort: .int 0
	aux_pointer: .int 0
.text
sortallreg:
	popl %eax
	movl %eax, endret

	movl (%esp), %eax
	movl %eax, reg_inicial
	movl $0, ant_reg_inicial

	movl 4(%esp), %eax
	movl %eax, opcao_sort

sortallreg_iter:
	cmpl $0, reg_inicial
	jz sortallreg_end

	pushl reg_inicial
	movl $0, ant_maior_reg
	movl reg_inicial, %eax
	movl %eax, reg_anterior		# anterior = reg_inicial
	movl 88(%eax), %eax		# eax = reg_inicial->prox
	movl %eax, reg_atual		# atual = reg_inicial->prox

sortallreg_buscamaior:
	cmpl $0, reg_atual
	jz sortallreg_buscamaior_end	#chegou ao fim da lista

	pushl reg_atual
	cmpl $1, opcao_sort
	jz sortallreg_buscamaior_pordata

	call comparastring
	addl $4, %esp
	cmpl $2, %edi
	jz sortallreg_buscamaior_ismaior
	jmp sortallreg_buscamaior_continua

sortallreg_buscamaior_pordata:
	call comparadata
	addl $4, %esp
	cmpl $2, %edi
	jnz sortallreg_buscamaior_continua

sortallreg_buscamaior_ismaior:
	addl $4, %esp
	movl reg_anterior, %eax
	movl %eax, ant_maior_reg
	pushl reg_atual

sortallreg_buscamaior_continua:
	movl reg_atual, %eax
	movl %eax, reg_anterior		# anterior = atual
	movl 88(%eax), %eax		# eax = atual->prox
	movl %eax, reg_atual		# atual = atual->prox
	jmp sortallreg_buscamaior
 
sortallreg_buscamaior_end:
	popl %eax
	movl %eax, maior_reg
	cmpl $0, ant_maior_reg
	jz sortallreg_iter_end		# maior elemento eh o primeiro da iteracao

sortallreg_iter_swap:
	cmpl $0, ant_reg_inicial
	jz sortallreg_iter_swap_israiz

	movl ant_reg_inicial, %eax
	movl maior_reg, %ebx
	movl %ebx, 88(%eax)		# ant_reg_inicial->prox = maior_reg
	jmp sortallreg_iter_swap_c

sortallreg_iter_swap_israiz:
	movl maior_reg, %eax
	movl %eax, (%esp)		# grava nova raiz no parametro

sortallreg_iter_swap_c:
	movl maior_reg, %eax
	movl 88(%eax), %eax
	movl %eax, aux_pointer		# salva maior_reg->prox em um ponteiro auxiliar

	movl reg_inicial, %eax
	movl 88(%eax), %eax
	movl maior_reg, %ebx
	cmpl %eax, %ebx			# verifica se maior_reg == reg_inicial->prox
	jz sortallreg_iter_swap_seq

	movl maior_reg, %eax
	movl reg_inicial, %ebx
	movl 88(%ebx), %ebx
	movl %ebx, 88(%eax)		# maior_reg->prox = reg_inicial->prox

	movl ant_maior_reg, %eax
	movl reg_inicial, %ebx
	movl %ebx, 88(%eax)		# ant_maior_reg->prox = reg_inicial
	jmp sortallreg_iter_swap_cc

sortallreg_iter_swap_seq:
	movl maior_reg, %eax
	movl reg_inicial, %ebx
	movl %ebx, 88(%eax)		# maior_reg->prox = reg_inicial

sortallreg_iter_swap_cc:
	movl reg_inicial, %eax
	movl aux_pointer, %ebx
	movl %ebx, 88(%eax)		# reg_inicial->prox = maior_reg->prox (guardado em um auxiliar)

sortallreg_iter_end:
	movl maior_reg, %eax
	movl %eax, ant_reg_inicial	# ant_reg_inicial = reg_inicial
	movl 88(%eax), %eax
	movl %eax, reg_inicial		# reg_inicial = reg_inicial->prox
	jmp sortallreg_iter

sortallreg_end:
	pushl endret
	ret
