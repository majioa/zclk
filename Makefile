AS=nasm
CC=bcc32
RM=rm

.PHONY : all	 # .PHONY ignores files named all
all:	  # all is dependent on $(EXE) to be complete
	$(MAKE) -C src all
#	 $(MAKE) -C obj all

.PHONY : clean	 # .PHONY ignores files named clean
clean:
	-$(RM) -f $(OBJ) *.lst	  # '-' causes errors not to exit the process