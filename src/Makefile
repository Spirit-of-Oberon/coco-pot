CC = gcc
CFLAGS = -O2
CINCLUDES = -I$(POT)/lib -I$(POT)/lib/Core
CLIBS = $(POT)/lib/libpOt.a $(POT)/lib/Core/libpOtCore.a -lm
MODNAME = Coco
ENTRY = Compile

OBJ = CRA.o CRP.o CRS.o CRT.o CRX.o Coco.o Sets.o Coco.Compile.o

TARGET = Coco

.c.o:
	$(CC) $(CFLAGS) $(CINCLUDES) -c $<

.SUFFIXES: .c .o .h

all: $(TARGET)

clean:
	-rm -f *.o Coco

cleanall:
	-rm -f *.o Coco *.c *.h *.hi *.Cym
 
$(TARGET): ${OBJ} $(POT)/lib/libpOt.a $(POT)/lib/Core/libpOtCore.a
	$(CC) -o $(TARGET) $(CFLAGS) $(OBJ) $(CLIBS)

$(MODNAME).$(ENTRY).c : $(POT)/lib/Core/main.tpl
	sed -e "s/<ModName>/${MODNAME}/g" -e "s/<Command>/${ENTRY}/g" < $(POT)/lib/Core/main.tpl > ${MODNAME}.${ENTRY}.c

$(MODNAME).$(ENTRY).o: $(MODNAME).$(ENTRY).c $(MODNAME).h 
# DO NOT DELETE THIS LINE -- make depend depends on it.

CRA.o: CRA.c Sets.h CRS.h CRT.h CRA.hi
CRP.o: CRP.c CRS.h CRT.h CRA.h CRX.h Sets.h CRP.hi
CRS.o: CRS.c CRS.hi
CRT.o: CRT.c Sets.h CRT.hi
CRX.o: CRX.c Sets.h CRS.h CRT.h CRX.hi
Coco.o: Coco.c CRS.h CRP.h CRT.h Coco.hi
Sets.o: Sets.c Sets.hi
