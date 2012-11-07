
arm-as=arm-elf-as
arm-ld=arm-elf-ld
arm-cc=arm-elf-gcc
asflags=-g
ldflags=-g
cflags=-g -O0

all:	usuario.o

usuario.o: user.o modsi3.o divsi3.o syswrapper.o
	$(arm-ld) $(ldflags) -r user.o syswrapper.o modsi3.o divsi3.o -o usuario.o

user.s: user.c
	$(arm-cc) -c -S $(cflags) user.c -o user.s
	sed -ie '/ldm/s/\^//' user.s

divsi3.o: divsi3.s
	$(arm-as) $(asflags) divsi3.s -o divsi3.o

modsi3.o: modsi3.s
	$(arm-as) $(asflags) modsi3.s -o modsi3.o

syswrapper.o: syswrapper.s
	$(arm-as) $(asflags) syswrapper.s -o syswrapper.o

user.o: user.s
	$(arm-as) $(asflags) user.s -o user.o

user-ia32: user.c
	gcc user.c -o user-ia32

clean:
	-rm *.o

