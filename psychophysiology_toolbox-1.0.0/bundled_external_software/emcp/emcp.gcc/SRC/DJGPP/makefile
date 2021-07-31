CC = gcc -g -O2
COPTS = -Wall
INC = ../allocate.h ../compute.h ../emcp.h ../files.h ../selectc.h ../sethead.h

djemcp:	selectc.o files.o emcp.o scard.o allocate.o compute.o
	$(CC) -o djemcp allocate.o emcp.o selectc.o scard.o files.o compute.o  $(COPTS) -lm

selectc.o: ../selectc.c $(INC)
	$(CC) -c ../selectc.c $(COPTS)

allocate.o: ../allocate.c $(INC)
	$(CC) -c ../allocate.c $(COPTS)

emcp.o: ../emcp.c $(INC)
	$(CC) -c ../emcp.c -o emcp.o $(COPTS)

scard.o: ../scard.c $(INC)
	$(CC) -c ../scard.c $(COPTS)

compute.o: ../compute.c $(INC)
	$(CC) -c ../compute.c -o compute.o $(COPTS)

files.o: ../files.c $(INC)
	$(CC) -c ../files.c -o files.o $(COPTS)

clean:
	del *.o
	del *.obj
	del *.sng
	del *.log
	del *.cav
	del *.bak
	del *.~de
	del *.csm

