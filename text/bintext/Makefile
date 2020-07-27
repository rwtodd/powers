# Set these variables for your system
LUABASE ?= /usr/local
PREFIX ?= $(LUABASE)
LIBDIR = $(PREFIX)/lib/lua/5.4
CC ?= cc

INC=-I$(LUABASE)/include
OPT=-march=native -O2
ifeq ($(shell uname -s),Linux)
  LOPT=-shared -fpic
else
  LOPT=-shared -fpic -undefined dynamic_lookup
endif

.PHONY: all libs pgms install clean

all: libs pgms

libs: bintext.so 

pgms: 

bintext.o: bintext.c 
	$(CC) $(OPT) $(INC) -fpic -c -o $@ $<

bintext.so: bintext.o 
	$(CC) $(OPT) $(LOPT) -o $@ $< 

install: all
	-mkdir -p $(LIBDIR)
	cp bintext.so $(LIBDIR)
	-mkdir -p $(PREFIX)/man/man3l
	cp bintext.3l $(PREFIX)/man/man3l

clean:
	-rm bintext.so bintext.o 
