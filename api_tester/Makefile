

# CC = g++
CC = clang++-10
ACC = arm-linux-gnueabihf-g++

SYSC_PATH= ${SYSTEMC_HOME}
SYSC_INCLUDE=-I$(SYSC_PATH)/include
SYSC_CFLAGS= -fPIC -DSYSC
SYSC_LINK=-I$(SYSC_PATH)/include -L$(SYSC_PATH)/lib-linux64 -Wl,-rpath=$(SYSC_PATH)/lib-linux64 -lsystemc


CFLAGS = -fPIC -DREAL



INCLUDE=-I../llvm-project/mlir/include
VERBOSE=-DVERBOSE_AXI

OBJDIR=out
SYSC_OBJDIR= sys_out
PYNQ_OBJDIR= pynq_out
MKDIR = mkdir -p

APICC=../llvm-project/mlir/lib/ExecutionEngine/axi

ACCCXXFLAGS += \
	-march=armv7-a \
	-mfpu=neon \
	-funsafe-math-optimizations \
	-ftree-vectorize \
	-fPIC

all : $(OBJDIR) api_v1_sysc api_v1_lib_sysc api_test_sysc api_v1 api_v1_lib api_test pynq_api_v1 pynq_api_v1_lib pynq_api_test

real: $(OBJDIR) api_v1 api_v1_lib api_test

pynq: $(PYNQ_OBJDIR) pynq_api_v1 pynq_api_v1_lib pynq_api_test pynq_api_bench

pynq_v: $(PYNQ_OBJDIR) pynq_api_v1_V pynq_api_v1_lib pynq_api_test pynq_api_bench

sysc: $(SYSC_OBJDIR) api_v1_sysc api_v1_lib_sysc api_test_sysc


$(OBJDIR):
	$(MKDIR) $(OBJDIR)

$(PYNQ_OBJDIR):
	$(MKDIR) $(PYNQ_OBJDIR)

$(SYSC_OBJDIR):
	$(MKDIR) $(SYSC_OBJDIR)


api_v1: $(OBJDIR)
	$(CC) -c -o $(OBJDIR)/api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS) $(VERBOSE)

api_v1_lib: $(OBJDIR)
	$(CC) -shared -o $(OBJDIR)/libapi_v1.so $(OBJDIR)/api_v1.o

api_test: $(OBJDIR)
	$(CC) -L$(OBJDIR)/ -Wall -o $(OBJDIR)/test_real main.cc -lapi_v1 $(CFLAGS) $(INCLUDE)

#-----------------------PYNQ 
pynq_api_v1_V: $(PYNQ_OBJDIR)
	$(ACC) -c -o $(PYNQ_OBJDIR)/pynq_api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS) $(VERBOSE)

pynq_api_v1: $(PYNQ_OBJDIR)
	$(ACC) -c -o $(PYNQ_OBJDIR)/pynq_api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS)

pynq_api_v1_lib: $(PYNQ_OBJDIR)
	$(ACC) -shared -o $(PYNQ_OBJDIR)/libpynq_api_v1.so $(PYNQ_OBJDIR)/pynq_api_v1.o

pynq_api_test: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/test_pynq_real main.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

pynq_api_bench: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/test_pynq_real_bench benchmark.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

#-----------------------

api_v1_sysc: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE)

api_v1_lib_sysc: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc.so $(SYSC_OBJDIR)/api_v1_sysc.o

api_test_sysc: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/test main.cc -lapi_v1_sysc $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE)


clean: clean_real clean_pynq clean_sysc
clean_real:
	rm -rf $(OBJDIR)
clean_pynq:
	rm -rf $(PYNQ_OBJDIR)

clean_sysc:
	rm -rf $(SYSC_OBJDIR)