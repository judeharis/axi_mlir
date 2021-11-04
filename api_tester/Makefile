

# CC = g++
CC = clang++-10
ACC = arm-linux-gnueabihf-g++

SYSC_PATH= ${SYSTEMC_HOME}
SYSC_INCLUDE=-I$(SYSC_PATH)/include
SYSC_CFLAGS= -fPIC
SYSC_LINK=-I$(SYSC_PATH)/include -L$(SYSC_PATH)/lib-linux64 -Wl,-rpath=$(SYSC_PATH)/lib-linux64 -lsystemc


CFLAGS = -fPIC -DREAL



INCLUDE=-I../llvm-project/mlir/include
VERBOSE=-DVERBOSE_AXI

OBJDIR=out
SYSC_OBJDIR= sysc_out
PYNQ_OBJDIR= pynq_out
MKDIR = mkdir -p

APICC=../llvm-project/mlir/lib/ExecutionEngine/axi

ACCCXXFLAGS += \
	-march=armv7-a \
	-mfpu=neon \
	-funsafe-math-optimizations \
	-ftree-vectorize \
	-fPIC

all : $(OBJDIR) mock pynq sysc 

mock: $(OBJDIR) mock_api_v1 mock_api_v1_lib mock_unit_test

pynq: $(PYNQ_OBJDIR) pynq_api_v1 pynq_api_v1_lib pynq_unit_test pynq_benchmark

pynq_v: $(PYNQ_OBJDIR) pynq_api_v1_V pynq_api_v1_lib pynq_unit_test pynq_benchmark

sysc: $(SYSC_OBJDIR) sysc_api_4x4v1 sysc_api_4x4v2 sysc_api_4x4v3 sysc_unit_test

sysc_api_4x4v1: sysc_api_v1_4x4v1 sysc_api_v1_lib_4x4v1 sysc_tiling1_4x4v1

sysc_api_4x4v2: sysc_api_v1_4x4v2 sysc_api_v1_lib_4x4v2 sysc_tiling1_4x4v2 sysc_tiling2_4x4v2 sysc_tiling3_4x4v2

sysc_api_4x4v3: sysc_api_v1_4x4v3 sysc_api_v1_lib_4x4v3 sysc_tiling1_4x4v3 sysc_tiling2_4x4v3

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

$(PYNQ_OBJDIR):
	$(MKDIR) $(PYNQ_OBJDIR)

$(SYSC_OBJDIR):
	$(MKDIR) $(SYSC_OBJDIR)


mock_api_v1: $(OBJDIR)
	$(CC) -c -o $(OBJDIR)/api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS) $(VERBOSE)

mock_api_v1_lib: $(OBJDIR)
	$(CC) -shared -o $(OBJDIR)/libapi_v1.so $(OBJDIR)/api_v1.o

mock_unit_test: $(OBJDIR)
	$(CC) -L$(OBJDIR)/ -Wall -o $(OBJDIR)/test_real main.cc -lapi_v1 $(CFLAGS) $(INCLUDE)

#-----------------------PYNQ 
pynq_api_v1_V: $(PYNQ_OBJDIR)
	$(ACC) -c -o $(PYNQ_OBJDIR)/pynq_api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS) $(VERBOSE)

pynq_api_v1: $(PYNQ_OBJDIR)
	$(ACC) -c -o $(PYNQ_OBJDIR)/pynq_api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS)

pynq_api_v1_lib: $(PYNQ_OBJDIR)
	$(ACC) -shared -o $(PYNQ_OBJDIR)/libpynq_api_v1.so $(PYNQ_OBJDIR)/pynq_api_v1.o

pynq_unit_test: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/test_pynq_real main.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

pynq_benchmark: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/test_pynq_real_bench benchmark.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

#-----------------------

#----------------------- SYSC 
sysc_api_v1_4x4v1: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE)

sysc_api_v1_lib_4x4v1: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc4x4v1.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_unit_test: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/main main.cc -lapi_v1_sysc4x4v1 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE)

sysc_tiling1_4x4v1: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v1 tiling1_4x4v1.cc -lapi_v1_sysc4x4v1 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_api_v1_4x4v2: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE) -DACC_V2

sysc_api_v1_lib_4x4v2: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_4x4v2.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_tiling1_4x4v2: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v2 tiling1_4x4v2.cc -lapi_v1_sysc_4x4v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling2_4x4v2: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling2_4x4v2 tiling2_4x4v2.cc -lapi_v1_sysc_4x4v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling3_4x4v2: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling3_4x4v2 tiling3_4x4v2.cc -lapi_v1_sysc_4x4v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)


sysc_api_v1_4x4v3: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE) -DACC_V3

sysc_api_v1_lib_4x4v3: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_4x4v3.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_tiling1_4x4v3: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v3 tiling1_4x4v3.cc -lapi_v1_sysc_4x4v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling2_4x4v3: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling2_4x4v3 tiling2_4x4v3.cc -lapi_v1_sysc_4x4v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)



sysc_api_v1_4x4v4: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE) -DACC_V4

sysc_api_v1_lib_4x4v4: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_4x4v4.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_tiling1_4x4v4: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v4 tiling1_4x4v4.cc -lapi_v1_sysc_4x4v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling2_4x4v4: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling2_4x4v4 tiling2_4x4v4.cc -lapi_v1_sysc_4x4v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling3_4x4v4: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling3_4x4v4 tiling3_4x4v4.cc -lapi_v1_sysc_4x4v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

#-----------------------

clean: clean_real clean_pynq clean_sysc
clean_real:
	rm -rf $(OBJDIR)
clean_pynq:
	rm -rf $(PYNQ_OBJDIR)

clean_sysc:
	rm -rf $(SYSC_OBJDIR)