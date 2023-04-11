CC = clang++-10
ACC = arm-linux-gnueabihf-g++


SYSC_PATH= ${SYSTEMC_HOME}
SYSC_INCLUDE=-I$(SYSC_PATH)/include -fPIC -DSYSC_T
SYSC_LINK=-I$(SYSC_PATH)/include -L$(SYSC_PATH)/lib-linux64 -Wl,-rpath=$(SYSC_PATH)/lib-linux64 -lsystemc

CFLAGS = -fPIC -DREAL -DACC_NEON
VERBOSET=-DVERBOSE_AXI -DVERBOSE_ACC
VERBOSE=
ACCCXXFLAGS += \
	-marm \
	-mfloat-abi=hard \
	-march=armv7-a \
	-mfpu=neon \
	-funsafe-math-optimizations \
	-ftree-vectorize \
	-fPIC


SRC=./src
APICC=../../llvm-project/mlir/lib/ExecutionEngine/axi
INCLUDE=-I../../llvm-project/mlir/include


OBJDIR=out
APPS_OBJDIR= $(OBJDIR)/apps_out
SYSC_OBJDIR= $(OBJDIR)/sysc_out
PYNQ_OBJDIR= $(OBJDIR)/pynq_out
MKDIR = mkdir -p

# MMPROB=-DM=$(M) -DN=$(N) -DK=$(K) -DDBG=0 -DTEST=1
DBG=0
TILES=
MMPROB=$(PROB) $(TILES) -DDBG=$(DBG) -DTEST=1

all : $(OBJDIR) sysc_libs sysc_apps

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

$(PYNQ_OBJDIR):
	$(MKDIR) $(PYNQ_OBJDIR)

$(SYSC_OBJDIR):
	$(MKDIR) $(SYSC_OBJDIR)

$(APPS_OBJDIR):
	$(MKDIR) $(APPS_OBJDIR)


sysc_libs: $(SYSC_OBJDIR) sysc_v1 sysc_v2 sysc_v3 sysc_v4

sysc_v1: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_sysc_v1.o $(APICC)/api_v1_sysc.cpp $(INCLUDE) $(SYSC_INCLUDE) $(VERBOSE)
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_sysc_v1.so $(SYSC_OBJDIR)/api_sysc_v1.o

sysc_v2: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_sysc_v2.o $(APICC)/api_v1_sysc.cpp $(INCLUDE) $(SYSC_INCLUDE) $(VERBOSE) -DACC_V2
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_sysc_v2.so $(SYSC_OBJDIR)/api_sysc_v2.o

sysc_v3: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_sysc_v3.o $(APICC)/api_v1_sysc.cpp $(INCLUDE) $(SYSC_INCLUDE) $(VERBOSE) -DACC_V3
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_sysc_v3.so $(SYSC_OBJDIR)/api_sysc_v3.o

sysc_v4: $(SYSC_OBJDIR)
	$(CC) -c -o $(SYSC_OBJDIR)/api_sysc_v4.o $(APICC)/api_v1_sysc.cpp $(INCLUDE) $(SYSC_INCLUDE) $(VERBOSE) -DACC_V4
	$(CC) -shared -o $(SYSC_OBJDIR)/libapi_sysc_v4.so $(SYSC_OBJDIR)/api_sysc_v4.o


sysc_apps: $(eval PROB=-DM=16 -DN=16 -DK=16) sysc_app_v1 sysc_app_v2 sysc_app_v3 sysc_app_v4 echo_ld_cmd

sysc_app_v1: $(APPS_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v1_Ns $(SRC)/matmul_driver_v3.cc -lapi_sysc_v1 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv1Ns $(MMPROB)

sysc_app_v2: $(APPS_OBJDIR)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v2_Ns $(SRC)/matmul_driver_v3.cc -lapi_sysc_v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv2Ns $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v2_As $(SRC)/matmul_driver_v3.cc -lapi_sysc_v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv2As $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v2_Bs $(SRC)/matmul_driver_v3.cc -lapi_sysc_v2 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv2Bs $(MMPROB)

sysc_app_v3: $(SYSC_OBJDIR)
	$(eval DBG=0) $(eval PROB=-DM=32 -DN=64 -DK=16)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v3_Ns $(SRC)/matmul_driver_v3.cc -lapi_sysc_v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv3Ns $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v3_As $(SRC)/matmul_driver_v3.cc -lapi_sysc_v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv3As $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v3_Bs $(SRC)/matmul_driver_v3.cc -lapi_sysc_v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv3Bs $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v3_Cs $(SRC)/matmul_driver_v3.cc -lapi_sysc_v3 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv3Cs $(MMPROB)

sysc_app_v4: $(APPS_OBJDIR)
	$(eval DBG=0) $(eval PROB=-DM=512 -DN=1024 -DK=64) $(eval TILES=-Dblock_M=64 -Dblock_N=64 -Dblock_K=64)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v4_As $(SRC)/matmul_driver_v3.cc -lapi_sysc_v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv4As $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v4_Bs $(SRC)/matmul_driver_v3.cc -lapi_sysc_v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv4Bs $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v4_Cs $(SRC)/matmul_driver_v3.cc -lapi_sysc_v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv4Cs $(MMPROB)
	$(CC) -L$(SYSC_OBJDIR)/ -Wall -o $(APPS_OBJDIR)/v4_Ns $(SRC)/matmul_driver_v3.cc -lapi_sysc_v4 $(SYSC_LINK) $(SYSC_INCLUDE) $(INCLUDE) $(VERBOSE) -DACCv4Ns $(MMPROB)

echo_ld_cmd : $(APPS_OBJDIR)
	@echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/working_dir/api_tester/matmul_driver_v3/out/sysc_out"

run: run_all_sysc

run_all_sysc: sysc_apps
	env LD_LIBRARY_PATH=D_LIBRARY_PATH:/working_dir/api_tester/matmul_driver_v3/out/sysc_out
	$(APPS_OBJDIR)/v1_Ns
	$(APPS_OBJDIR)/v2_Ns
	$(APPS_OBJDIR)/v2_As
	$(APPS_OBJDIR)/v2_Bs
	$(APPS_OBJDIR)/v3_Ns
	$(APPS_OBJDIR)/v3_As
	$(APPS_OBJDIR)/v3_Bs
	$(APPS_OBJDIR)/v3_Cs
	$(APPS_OBJDIR)/v4_As
	$(APPS_OBJDIR)/v4_Bs
	$(APPS_OBJDIR)/v4_Cs
	$(APPS_OBJDIR)/v4_Ns

run_v4: sysc_v4 sysc_app_v4
	env LD_LIBRARY_PATH=D_LIBRARY_PATH:/working_dir/api_tester/matmul_driver_v3/out/sysc_out
	$(APPS_OBJDIR)/v4_As
	# $(APPS_OBJDIR)/v4_Bs
	# $(APPS_OBJDIR)/v4_Cs
	# $(APPS_OBJDIR)/v4_Ns