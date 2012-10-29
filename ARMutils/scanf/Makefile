AS=as
LD=ld
AS_FLAGS=-g
LD_FLAGS=-g 
SRC=main.s myScanf.s aux.s
LIB= ../printf/myPrintf.o ../printf/aux.o ../printf/strProcessor.o
OBJ=$(SRC:.s=.o)
OUTPUT=main

all: main

main: $(OBJ)
	$(LD) $(LD_FLAGS) $(OBJ) $(LIB) -o $(OUTPUT)

%.o: %.s
	$(AS) $(AS_FLAGS) $< -o $@

clean:
	rm $(OBJ) main

gdb: main
	gdb $(OUTPUT)

run: main
	./$(OUTPUT)
