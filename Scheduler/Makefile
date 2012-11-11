AS=arm-elf-as
LD=arm-elf-ld
AS_FLAGS= -g
LD_FLAGS= -g -Ttext=0x0

USER_OBJ=$(wildcard UserCode/*.o)
SOS_OBJ=SOS/interuptions.o SOS/exit.o SOS/fork.o SOS/getpid.o SOS/scheduler.o SOS/structs.o SOS/write.o SOS/config.o
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
