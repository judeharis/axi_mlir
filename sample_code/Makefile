

CC = g++
ACC = arm-linux-gnueabi-g++

SYSTEMC_HOME= /usr/local/systemc-2.3.3
CFLAGS=-I$(SYSTEMC_HOME)/include -L$(SYSTEMC_HOME)/lib-linux64 -Wl,-rpath=$(SYSTEMC_HOME)/lib-linux64 -lsystemc -lm

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