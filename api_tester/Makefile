

# CC = g++
CC = clang++-10
ACC = arm-linux-gnueabi-g++

SYSC_PATH= ${SYSTEMC_HOME}

CFLAGS=-I$(SYSC_PATH)/include -fPIC -DSYSC

CFLAGS2=-I$(SYSC_PATH)/include -L$(SYSC_PATH)/lib-linux64 -Wl,-rpath=$(SYSC_PATH)/lib-linux64 -lsystemc -fPIC 

INCLUDE=-I../llvm-project/mlir/include
TOGGLE=-DVERBOSE_AXI

OBJDIR=out
MKDIR = mkdir -p

APICC=../llvm-project/mlir/lib/ExecutionEngine/axi


all : $(OBJDIR) api_v1 api_v1_lib api_sp

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

api_v1: $(OBJDIR)
	$(CC) -c -o $(OBJDIR)/api_v1.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(CFLAGS) $(TOGGLE)

api_v1_lib: $(OBJDIR)
	$(CC) -shared -o $(OBJDIR)/libapi_v1.so $(OBJDIR)/api_v1.o

api_sp: $(OBJDIR)
	$(CC) -L$(OBJDIR)/ -Wall -o $(OBJDIR)/test main.cc -lapi_v1 $(CFLAGS2) $(INCLUDE) -DSYSC

clean:
	rm -rf $(OBJDIR)