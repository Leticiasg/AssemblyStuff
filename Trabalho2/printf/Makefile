AS=as
LD=ld
AS_FLAGS=-g
LD_FLAGS=-g 
SRC=main.s strProcessor.s myPrintf.s myScanf.s aux.s
OBJ=$(SRC:.s=.o)
OUTPUT=main

all: main

main: $(OBJ)
	$(LD) $(LD_FLAGS) $(RUNTIME) $(OBJ) -o $(OUTPUT)

%.o: %.s
	$(AS) $(AS_FLAGS) $< -o $@

clean:
	rm $(OBJ) main

gdb: main
	gdb $(OUTPUT)

run: main
	./$(OUTPUT)
