#[]-----------------------------------------------------------------[]
#|   Makefile -- makefile					     |
#[]-----------------------------------------------------------------[]
#
# $Copyright: 2005$
# $Revision: 1.1.1.1 $
#
BIN=zclkernl.dll
SRC=memutils.asm zclkernl.asm
OBJ=$(SRC:.asm=.o) # replaces the .asm from SRC with .o
DEF=$(BIN:.dll=.def)
OBJDIR=..\\obj
#OBJDIR=../obj
BINDIR=..\\bin
LIB=
OS=WIN32

AS=nasm
LD=ilink32
#AFLAGS=-f coff -O2
AFLAGS=-f obj -O4
#LLFLAGS=-m -M -s    #Link loggings flags with ilink32
LFLAGS=-mi386pe -call_shared --disable-stdcall-fixup   --export-all-symbols    #Link flags with gcc
#LFLAGS=-mi386pe -call_shared --disable-stdcall-fixup  -E   #Link flags with gcc
LFLAGS = -c -Tpd -aa -x -Gn -Gi -v -b:0x340000 #Link flags with ilink32

%.o: %.asm
	$(AS) $(AFLAGS) -l $(OBJDIR)/$(<:.asm=.lst) -o $(OBJDIR)/$@ $< -E $(OBJDIR)/$(@:.o=.err) -d$(OS)

.PHONY : all	 # .PHONY ignores files named all
all: $(BIN)	 # all is dependent on $(EXE) to be complete

$(BIN): $(OBJ) $(DEF) $(RES) # $(EXE) is dependent on all of the files in $(OBJ) to exist
	$(LD)  $(LFLAGS) $(LLFLAGS) -j$(OBJDIR) $(OBJ) , $(BINDIR)\\$@,, $(LIB), $(DEF), $(RES)
#	 -rm /c/winnt/system32/$@
#	 cp ../bin/$@  ../../strings/bin/
#	 cp ../bin/$@  /c/windows/system32/
#	 $(MAKE) -C ../obj/ all

.PHONY : clean	 # .PHONY ignores files named clean
clean:
	-$(RM) -f $(OBJ) *.lst *.err   # '-' causes errors not to exit the process


