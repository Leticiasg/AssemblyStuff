AS=arm-elf-as
LD=arm-elf-ld
AS_FLAGS= -g
LD_FLAGS= -g -Ttext=0x0

USER_OBJ=UserCode/usuario.o
SOS_OBJ=$(wildcard SOS/*.o)
OUTPUT=prog

all: prog

prog:	sos_obj user_obj
	$(LD) $(LD_FLAGS) $(SOS_OBJ) $(USER_OBJ) -o $(OUTPUT)

sos_obj:
	cd SOS; make

user_obj:
	cd UserCode; make

clean:
	cd SOS; make clean
	cd UserCode; make clean
	rm $(OUTPUT)

gdbtarget: all
	arm-sim --load=$(OUTPUT) -degub-core -enable-gdb -cycles=1000

gdbhost: all
	armv5e-elf-gdb $(OUTPUT)

run: $(OUTPUT)
	arm-sim --load=$(OUTPUT) -cycles=1000
