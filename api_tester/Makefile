
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/Crucial/WorkspaceB/AXI4MLIR/axi4mlir/api_tester/sysc_out

# CC = g++
CC = clang++-10
# ACC = arm-linux-gnueabihf-g++
ACC = /home/jude/Workspace/PYNQCC/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++

SYSC_PATH= ${SYSTEMC_HOME}
SYSC_INCLUDE=-I$(SYSC_PATH)/include
SYSC_CFLAGS= -fPIC -DCPU_MM
SYSC_LINK=-I$(SYSC_PATH)/include -L$(SYSC_PATH)/lib-linux64 -Wl,-rpath=$(SYSC_PATH)/lib-linux64 -lsystemc

SRC=./src
ACC_SRC=./accelerators

CFLAGS = -fPIC -DREAL -DACC_NEON
# CFLAGS = -fPIC -DREAL -DCPU_MM


INCLUDE=-I../llvm-project/mlir/include
VERBOSE=-DVERBOSE_AXI

OBJDIR=out
SYSC_OBJDIR= sysc_out
PYNQ_OBJDIR= pynq_out
MKDIR = mkdir -p

APICC=../llvm-project/mlir/lib/ExecutionEngine/axi

ACCCXXFLAGS += \
	-marm \
	-mfloat-abi=hard \
	-march=armv7-a \
	-mfpu=neon \
	-funsafe-math-optimizations \
	-ftree-vectorize \
	-fPIC

all : $(OBJDIR) mock pynq sysc 

mock: $(OBJDIR) mock_api_v1 mock_api_v1_lib mock_unit_test

pynq: $(PYNQ_OBJDIR) pynq_api_v1 pynq_api_v1_lib pynq_unit_test pynq_benchmark

pynq_exp: $(PYNQ_OBJDIR) pynq_api_v1 pynq_api_v1_lib pynq_accv1 pynq_accv2 pynq_accv3 pynq_accv4 pynq_accv5 

pynq_conv: $(PYNQ_OBJDIR) pynq_api_v1 pynq_api_v1_lib pynq_conv_v3

pynq_accv1 : pynq_tiling1_4x4v1

pynq_accv2 : pynq_tiling1_4x4v2 pynq_tiling2_4x4v2 pynq_tiling3_4x4v2

pynq_accv3 : pynq_tiling1_4x4v3 pynq_tiling2_4x4v3

pynq_accv4 : pynq_tiling1_4x4v4 pynq_tiling2_4x4v4 pynq_tiling3_4x4v4

pynq_accv5 : pynq_tiling1_4x4v5 

pynq_conv_v2 : pynq_conv2

pynq_conv_v3 : pynq_conv3

pynq_test: $(PYNQ_OBJDIR) pynq_api_v1 pynq_api_v1_lib pynq_mmv1_ts1 pynq_mmv1_ts1_prof pynq_mmv1_ts1_hwc pynq_conv_v1

pynq_v: $(PYNQ_OBJDIR) pynq_api_v1_V pynq_api_v1_lib pynq_unit_test pynq_benchmark

# sysc: $(SYSC_OBJDIR) sysc_api_4x4v1 sysc_api_4x4v2 sysc_api_4x4v3 sysc_api_4x4v5 sysc_unit_test

sysc: $(SYSC_OBJDIR)  sysc_api_4x4v1

sysc_api_4x4v1: sysc_api_v1_4x4v1 sysc_api_v1_lib_4x4v1 sysc_tiling1_4x4v1

sysc_api_4x4v2: sysc_api_v1_4x4v2 sysc_api_v1_lib_4x4v2 sysc_tiling1_4x4v2 sysc_tiling2_4x4v2 sysc_tiling3_4x4v2

# sysc_api_4x4v4: sysc_api_v1_4x4v4 sysc_api_v1_lib_4x4v4 sysc_tiling1_4x4v4 sysc_tiling2_4x4v4 sysc_tiling3_4x4v4

sysc_api_4x4v4: sysc_api_v1_4x4v4 sysc_api_v1_lib_4x4v4 sysc_tiling3_4x4v4

sysc_api_4x4v3: sysc_api_v1_4x4v3 sysc_api_v1_lib_4x4v3 sysc_tiling1_4x4v3 sysc_tiling2_4x4v3

sysc_api_4x4v5: sysc_api_v1_4x4v5 sysc_api_v1_lib_4x4v5 sysc_tiling1_4x4v5

sysc_test: $(SYSC_OBJDIR) sysc_api_conv_v3

sysc_api_conv_v1 : sysc_api_v1_conv_v1 sysc_api_v1_lib_conv_v1 sysc_conv_v1_t1

sysc_api_conv_v2 : sysc_api_v1_conv_v2 sysc_api_v1_lib_conv_v2 sysc_conv_v2_t1

sysc_api_conv_v3 : sysc_api_v1_conv_v3 sysc_api_v1_lib_conv_v3 sysc_conv_v3_t1



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
	$(CC) -L$(OBJDIR)/ -Wall -o $(OBJDIR)/test_real $(SRC)/main.cc -lapi_v1 $(CFLAGS) $(INCLUDE)

#-----------------------PYNQ 
pynq_api_v1_V: $(PYNQ_OBJDIR)
	$(ACC) -c -o $(PYNQ_OBJDIR)/pynq_api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS) $(VERBOSE)

pynq_api_v1: $(PYNQ_OBJDIR)
	$(ACC) -c -o $(PYNQ_OBJDIR)/pynq_api_v1.o $(APICC)/api_v1.cpp $(INCLUDE)  $(CFLAGS) $(ACCCXXFLAGS)

pynq_api_v1_lib: $(PYNQ_OBJDIR)
	$(ACC) -shared -o $(PYNQ_OBJDIR)/libpynq_api_v1.so $(PYNQ_OBJDIR)/pynq_api_v1.o

pynq_unit_test: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/test_pynq_real $(SRC)/main.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

pynq_benchmark: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/test_pynq_real_bench $(SRC)/benchmark.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

# ----------------v1----------------

pynq_tiling1_4x4v1: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling1_4x4v1 $(SRC)/tiling1_4x4v1.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)
	
pynq_mmv1_ts1: $(PYNQ_OBJDIR)
	for tile_S in 4 8 16 ; do \
		$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_mmv1_ts1_$$tile_S $(SRC)/mmv1_ts1.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS) -Dtile_M=$$tile_S -Dtile_N=$$tile_S -Dtile_K=$$tile_S; \
	done
	
pynq_mmv1_ts1_prof: $(PYNQ_OBJDIR)
	for tile_S in 4 8 16 ; do \
		$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_prof_mmv1_ts1_$$tile_S $(SRC)/mmv1_ts1.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS) -Dtile_M=$$tile_S -Dtile_N=$$tile_S -Dtile_K=$$tile_S -Dpenable; \
	done
	
pynq_mmv1_ts1_hwc: $(PYNQ_OBJDIR)
	for tile_S in 4 8 16 ; do \
		$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_hwc_mmv1_ts1_$$tile_S $(SRC)/mmv1_ts1.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS) -Dtile_M=$$tile_S -Dtile_N=$$tile_S -Dtile_K=$$tile_S -DHW_Counters; \
	done

pynq_conv_v1: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_conv_v1 $(SRC)/conv_v1_t1.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

# ----------------v2----------------

pynq_tiling1_4x4v2: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling1_4x4v2 $(SRC)/tiling1_4x4v2.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

pynq_tiling2_4x4v2: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling2_4x4v2 $(SRC)/tiling2_4x4v2.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

pynq_tiling3_4x4v2: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling3_4x4v2 $(SRC)/tiling3_4x4v2.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)


# ----------------v3----------------

pynq_tiling1_4x4v3: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling1_4x4v3 $(SRC)/tiling1_4x4v3.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

pynq_tiling2_4x4v3: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling2_4x4v3 $(SRC)/tiling2_4x4v3.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)


# ----------------v4----------------


pynq_tiling1_4x4v4: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling1_4x4v4 $(SRC)/tiling1_4x4v4.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)


# pynq_tiling1_4x4v4: $(PYNQ_OBJDIR)
# 	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling1_4x4v4 tiling1_4x4v4.cc $(APICC)/api_v1.cpp $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)


pynq_tiling2_4x4v4: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling2_4x4v4 $(SRC)/tiling2_4x4v4.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

pynq_tiling3_4x4v4: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling3_4x4v4 $(SRC)/tiling3_4x4v4.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)



#-----------------------

# ----------------v5----------------

pynq_tiling1_4x4v5: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/pynq_tiling1_4x4v5 $(SRC)/tiling1_4x4v5.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

#-----------------------

# ----------------ConvV2----------------

pynq_conv2: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/conv_v2_t1 $(SRC)/conv_v2_t1.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)

# ----------------ConvV3----------------

pynq_conv3: $(PYNQ_OBJDIR)
	$(ACC) -L$(PYNQ_OBJDIR)/ -Wall -o $(PYNQ_OBJDIR)/conv_v3_t1 $(SRC)/conv_v3_t1.cc -lpynq_api_v1 $(CFLAGS) $(INCLUDE) $(ACCCXXFLAGS)




#----------------------- SYSC 
sysc_api_v1_4x4v1: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE)

sysc_api_v1_lib_4x4v1: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc4x4v1.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_unit_test: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/main $(SRC)/main.cc -lapi_v1_sysc4x4v1 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE)

sysc_tiling1_4x4v1: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v1 $(SRC)/tiling1_4x4v1.cc -lapi_v1_sysc4x4v1 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

#-----------------------

sysc_api_v1_4x4v2: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE) -DACC_V2

sysc_api_v1_lib_4x4v2: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_4x4v2.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_tiling1_4x4v2: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v2 $(SRC)/tiling1_4x4v2.cc -lapi_v1_sysc_4x4v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling2_4x4v2: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling2_4x4v2 $(SRC)/tiling2_4x4v2.cc -lapi_v1_sysc_4x4v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling3_4x4v2: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling3_4x4v2 $(SRC)/tiling3_4x4v2.cc -lapi_v1_sysc_4x4v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

#-----------------------

sysc_api_v1_4x4v3: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE) -DACC_V3

sysc_api_v1_lib_4x4v3: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_4x4v3.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_tiling1_4x4v3: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v3 $(SRC)/tiling1_4x4v3.cc -lapi_v1_sysc_4x4v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling2_4x4v3: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling2_4x4v3 $(SRC)/tiling2_4x4v3.cc -lapi_v1_sysc_4x4v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

#-----------------------

sysc_api_v1_4x4v4: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE) -DACC_V4

sysc_api_v1_lib_4x4v4: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_4x4v4.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_tiling1_4x4v4: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v4 $(SRC)/tiling1_4x4v4.cc -lapi_v1_sysc_4x4v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling2_4x4v4: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling2_4x4v4 $(SRC)/tiling2_4x4v4.cc -lapi_v1_sysc_4x4v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

sysc_tiling3_4x4v4: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling3_4x4v4 $(SRC)/tiling3_4x4v4.cc -lapi_v1_sysc_4x4v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

#-----------------------


sysc_api_v1_4x4v5: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(VERBOSE) -DACC_V5

sysc_api_v1_lib_4x4v5: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_4x4v5.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_tiling1_4x4v5: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/tiling1_4x4v5 $(SRC)/tiling1_4x4v5.cc -lapi_v1_sysc_4x4v5 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

#-----------------------

sysc_api_v1_conv_v1: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) -DCONV_V1

sysc_api_v1_lib_conv_v1: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_conv_v1.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_conv_v1_t1: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/conv_v1_t1 $(SRC)/conv_v1_t1.cc -lapi_v1_sysc_conv_v1 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)

#-----------------------

sysc_api_v1_conv_v3: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc.o $(APICC)/api_v1_sysc.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS) -DCONV_V3

sysc_api_v1_lib_conv_v3: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_sysc_conv_v3.so $(SYSC_OBJDIR)/api_v1_sysc.o

sysc_conv_v3_t1: $(SYSC_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/conv_v3_t1 $(SRC)/conv_v3_t1.cc -lapi_v1_sysc_conv_v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE)


#-----------------------

sysc_api_v1_conv_v2: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc_2.o $(APICC)/api_v1_sysc_2.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS)

sysc_api_v1_lib_conv_v2: $(SYSC_OBJDIR)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_2_sysc_conv_v2.so $(SYSC_OBJDIR)/api_v1_sysc_2.o


sysc_convV2_acc: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/convV2acc.o $(ACC_SRC)/convV2/accelerator.sc.cc   $(SYSC_INCLUDE) $(SYSC_CFLAGS)


sysc_conv_v2_t1: $(SYSC_OBJDIR) sysc_convV2_acc
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/conv_v2_t1 $(SRC)/conv_v2_t1.cc $(SYSC_OBJDIR)/convV2acc.o -I../ -lapi_v1_2_sysc_conv_v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE) -DSYSC

#-----------------------


#-----------------------

# sysc_api_v1_conv_v3: $(SYSC_OBJDIR)
# 	$(CC) -c -o $(SYSC_OBJDIR)/api_v1_sysc_2.o $(APICC)/api_v1_sysc_2.cpp $(INCLUDE)  $(SYSC_INCLUDE) $(SYSC_CFLAGS)

# sysc_api_v1_lib_conv_v3: $(SYSC_OBJDIR)
# 	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_v1_2_sysc_conv_v3.so $(SYSC_OBJDIR)/api_v1_sysc_2.o


# sysc_convV3_acc: $(SYSC_OBJDIR)
# 	$(CC) -c -o $(SYSC_OBJDIR)/convV3acc.o $(ACC_SRC)/convV3/accelerator.sc.cc   $(SYSC_INCLUDE) $(SYSC_CFLAGS)


# sysc_conv_v3_t1: $(SYSC_OBJDIR) sysc_convV3_acc
# 	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(SYSC_OBJDIR)/conv_v3_t1 $(SRC)/conv_v3_t1.cc $(SYSC_OBJDIR)/convV3acc.o -I../ -lapi_v1_2_sysc_conv_v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(SYSC_CFLAGS) $(INCLUDE) $(VERBOSE) -DSYSC

#-----------------------

clean: clean_real clean_pynq clean_sysc
clean_real:
	rm -rf $(OBJDIR)
clean_pynq:
	rm -rf $(PYNQ_OBJDIR)

clean_sysc:
	rm -rf $(SYSC_OBJDIR)