

CC = g++
ACC = arm-linux-gnueabi-g++

SYSC_PATH= ${SYSTEMC_HOME}
CFLAGS=-I$(SYSC_PATH)/include -L$(SYSC_PATH)/lib-linux64 -Wl,-rpath=$(SYSC_PATH)/lib-linux64 -lsystemc -lm

INCLUDE=-I/includes
TOGGLE=-DAXI_DMA

OBJDIR=out_make
MKDIR = mkdir -p



all : $(OBJDIR) sysc_gemm axi_gemm

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

sysc_gemm: sample_prog.cc
	$(CC) -o $(OBJDIR)/sysc_gemm sample_prog.cc accelerator.sc.cc $(CFLAGS) $(INCLUDE)

axi_gemm: 
	$(ACC) -o $(OBJDIR)/axi_gemm sample_prog.cc $(INCLUDE) $(TOGGLE)


clean:
	rm -rf $(OBJDIR)