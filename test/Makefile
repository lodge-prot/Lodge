ifeq ($(shell uname),Darwin)
	$(shell exit)
endif

CC        = /usr/bin/gcc
PROGRAM   = flock_and_sort
TARGET    = flock_and_sort.c

CFLAGS  := $(CFLAGS) -g -W -Wall -Wno-unused-parameter
BUILD_DIR := $(shell pwd)
VERBOSE   := 0

.PHONY: all

all:
	$(CC)  $(CFLAGS) -o $(PROGRAM) $(TARGET)

clean:
	rm -f a.out flock_and_sort *.o

