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
