DIROBJETO=./obj
AS=as
LD=ld
ASFLAGS= -32 -g
LDFLAGS= -m elf_i386 -l c -dynamic-linker /lib/ld-linux.so.2

_OBJETO = listaligada.o comparastring.o
OBJETO = $(patsubst %,$(DIROBJETO)/%,$(_OBJETO))

$(DIROBJETO)/%.o: %.s
	@mkdir -p obj
	$(AS) -o $@ $< $(ASFLAGS)

listaligada.out: $(OBJETO)
	@mkdir -p bin
	$(LD) -o ./bin/$@ $^ $(LDFLAGS)
