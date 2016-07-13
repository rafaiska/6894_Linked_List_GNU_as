# Funcao para comparar duas strings (delimitadas por \0)
# Parametros passados por pilha: $s1 e $s2 (ponteiros string)
# Valor de retorno passado em %edi:	0 para strings iguais
#					1 para s1 > s2
#					2 para s2 > s1

.global comparastring
.data

.text
comparastring:
	
