SHELL=  /bin/bash
FC=     ifort
FFLAGS= -recursive -qopenmp -convert big_endian
LIBS=   -L/scratch2/NCEPDEV/nwprod/NCEPLIBS/compilers/intel/18.0.5.274/lib -lsp_v2.0.2_4 -lip_v2.0.0_4 -lw3nco_v2.0.6_4 -lw3emc_v2.3.0_4 -lbacio_v2.0.2_4 -lbufr_v11.3.0_4_64

ALL : mkclimn.x mkclimn_t574.x mkclimwnd.x read1x1.x rewrite.x
.PHONY: ALL

mkclimn.x      : mkclimn.o miscng.o
	$(FC) $(FFLAGS) mkclimn.o miscng.o -o ../exec/$(@) $(LIBS)
mkclimn_t574.x : mkclimn_t574.o miscng.o
	$(FC) $(FFLAGS) mkclimn_t574.o miscng.o -o ../exec/$(@) $(LIBS)
mkclimwnd.x    : mkclimwnd.o miscng.o
	$(FC) $(FFLAGS) mkclimwnd.o miscng.o -o ../exec/$(@) $(LIBS)
read1x1.x      : read1x1.o miscng.o
	$(FC) $(FFLAGS) read1x1.o miscng.o -o ../exec/$(@) $(LIBS)
rewrite.x      : rewrite.o miscng.o
	$(FC) $(FFLAGS) rewrite.o miscng.o -o ../exec/$(@) $(LIBS)
mkclimn.o      : mkclimn.f
	$(FC) $(FFLAGS) -c mkclimn.f
mkclimn_t574.o : mkclimn_t574.f
	$(FC) $(FFLAGS) -c mkclimn_t574.f
mkclimwnd.o    : mkclimwnd.f
	$(FC) $(FFLAGS) -c mkclimwnd.f
read1x1.o      : read1x1.f
	$(FC) $(FFLAGS) -c read1x1.f
rewrite.o      : rewrite.f 
	$(FC) $(FFLAGS) -c rewrite.f
miscng.o        : miscng.f
	$(FC) $(FFLAGS) -c miscng.f

clean  :
	rm *.o ../exec/*.x
