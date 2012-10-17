COMPILER=gcc
LINKER=ld
CFLAGS= -g -std=c99 -pedantic -Wall -lm
EXEC_FILE=montador-ias
LIB_FLAGS=-S
ASSEMBLER=as
SRC=$(wildcard *.c)
OBJ=$(SRC:.c=.o)
AS=$(SRC:.c=.s)

LFLAG1=--dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o -L/usr/lib/x86_64-linux-gnu
LFLAG2=-lc /usr/lib/x86_64-linux-gnu/crtn.o

all: $(EXEC_FILE)

$(EXEC_FILE): $(AS) $(OBJ)
	$(LINKER) $(LFLAG1) $(OBJ) $(LFLAG2) -o $(EXEC_FILE)

%.s: %.c
	$(COMPILER) $< $(LIB_FLAGS) $(CFLAGS) -o $@

%.o: %.s
	$(ASSEMBLER) $< -o $@

clean: 
	rm *.s
	rm *.o

zip:
	zip fonte.zip $(SRC) $(SRC:.c=.h)

run:
	./montador-ias in/arq01.s out/out01.hex
	./montador-ias in/arq02.s out/out02.hex
	./montador-ias in/arq03.s out/out03.hex
	./montador-ias in/arq04.s out/out04.hex
	./montador-ias in/arq05.s out/out05.hex
	./montador-ias in/arq06.s out/out06.hex
	./montador-ias in/arq07.s out/out07.hex
	./montador-ias in/arq08.s out/out08.hex
	./montador-ias in/arq09.s out/out09.hex
	./montador-ias in/arq10.s out/out10.hex
	./montador-ias in/arq11.s out/out11.hex
	./montador-ias in/arq12.s out/out12.hex

diff:
	diff out/out01.hex solution/arq01.res
	diff out/out02.hex solution/arq02.res
	diff out/out03.hex solution/arq03.res
	diff out/out04.hex solution/arq04.res
	diff out/out05.hex solution/arq05.res
	diff out/out06.hex solution/arq06.res
	diff out/out07.hex solution/arq07.res
	diff out/out08.hex solution/arq08.res
	diff out/out09.hex solution/arq09.res
	diff out/out10.hex solution/arq10.res
	diff out/out11.hex solution/arq11.res
	diff out/out12.hex solution/arq12.res
