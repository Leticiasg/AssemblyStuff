AS=arm-elf-as
LD=arm-elf-ld
AS_FLAGS= -g
LD_FLAGS= -g -Ttext=0x0

USER_OBJ=UserCode/user.o UserCode/syswrapper.o UserCode/divsi3.o UserCode/modsi3.o
SOS_OBJ=SOS/interuptions.o SOS/exit.o SOS/fork.o SOS/getpid.o SOS/scheduler.o SOS/structs.o SOS/write.o SOS/config.o
OUTPUT=prog

all: prog

prog:	sos_obj user_obj
	$(LD) $(LD_FLAGS) $(SOS_OBJ) $(USER_OBJ) -o $(OUTPUT)

sos:	sos_obj
	$(LD) $(LD_FLAGS) $(SOS_OBJ) -o sos

user:	user_obj
	$(LD) -g -Ttext=0x8000  $(USER_OBJ) -o user

sos_obj:
	cd SOS; make

user_obj:
	cd UserCode; make

clean:
	cd SOS; make clean
	cd UserCode; make clean
	rm $(OUTPUT)

gdbtarget: all
	arm-sim --load=user -degub-core -enable-gdb -gdb-port=3000

gdbhost: all
	armv5e-elf-gdb prog

run: all
	arm-sim --load=prog

run2:	sos	user
	arm-sim --load-sys=sos --load=user

gdbtarget2: sos	user
	arm-sim --load=./sos -degub-core -enable-gdb -gdb-port=3000

gdbhost2: sos user
	armv5e-elf-gdb ./sos
