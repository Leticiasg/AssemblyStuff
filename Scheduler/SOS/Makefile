AS=arm-elf-as
LD=arm-elf-ld
AS_FLAGS= -g
LD_FLAGS= -g -Ttext=0x0

SRC=$(wildcard *.s)
OBJ=$(SRC:.s=.o)

OUTPUT=sos

all: sos

sos:	$(OBJ)
	$(LD) $(LD_FLAGS) $(OBJ) -o $(OUTPUT)

%.o: %.s
	$(AS) $(AS_FLAGS) $< -o $@

clean:
	rm $(OBJ) $(OUTPUT)

gdbtarget: all
	arm-sim --load-sys=$(OUTPUT) -degub-core -enable-gdb -cycles=1000

gdbhost: all
	armv5e-elf-gdb $(OUTPUT)

run: $(OUTPUT)
	arm-sim --load=$(OUTPUT) -cycles=1000
