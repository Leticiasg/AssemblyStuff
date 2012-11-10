AS=arm-elf-as
LD=arm-elf-ld
AS_FLAGS= -g
LD_FLAGS= -g -Ttext=0x0

#SRC=interuptions.s config.s exit.s fork.s getpid.s scheduler.s structs.s write.s
SRC=$(wildcard *.s)
OBJ=$(SRC:.s=.o)

OUTPUT=sos.o

all: sos

sos:	$(OBJ)
#	$(LD) $(LD_FLAGS) $(OBJ) -o $(OUTPUT)

%.o: %.s
	$(AS) $(AS_FLAGS) $< -o $@

clean:
#	rm $(OBJ) $(OUTPUT)
	rm $(OBJ)

