module load devel/cmake/3.18
#CPATH=/opt/intel/compilers_and_libraries_2020/linux/mkl/include:/home/hk-project-test-fine/eq4036/.local/lib:/home/hk-project-test-fine/eq4036/.local/petsc-3.15.0/include:/home/hk-project-test-fine/eq4036/.local/petsc-3.15.0/include
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/petsc-3.15.0/lib

module purge

module add compiler/gnu/11 mpi/openmpi/4.1 devel/cmake

unset OMPI_CFLAGS OMPI_CXXFLAGS OMPI_FCFLAGS OMPI_FFLAGS

unset CFLAGS CXXFLAGS FCFLAGS FFLAGS

unset CC CXX FC F77

export PETSC_DIR=/hkfs/home/project/hk-project-test-fine/eq4036/data/code/petsc/

export PETSC_ARCH=arch-linux-c-opt

./configure \
	--prefix="${PETSC_DIR}.install" \
	--with-debugging=0 \
	--with-mpi=1 \
	--with-mpi-compilers=1 \
	--CXXOPTFLAGS="-O3 -march=native" \
	--FOPTFLAGS="-O3 -march=native" \
	--COPTFLAGS="-O3 -march=native" \
	--with-cuda=0 \
	--HIPOPTFLAGS="-O3 -march=native" \
	--download-blis=1 \
	--download-f2cblaslapack

make all
make check
make install
