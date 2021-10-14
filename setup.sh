#! /usr/bin/env bash
module purge

module load devel/cmake/3.18
module load toolkit/rocm/4.3.1
module add compiler/gnu/11  mpi/openmpi/4.1 devel/cmake

unset OMPI_CFLAGS OMPI_CXXFLAGS OMPI_FCFLAGS OMPI_FFLAGS

unset CFLAGS CXXFLAGS FCFLAGS FFLAGS

unset CC CXX FC F77


PETSC_DIR=/hkfs/home/project/hk-project-test-fine/eq4036/data/code/petsc/.install
PETSC_ARCH=""

git clone -b mpi-for-hyteg-with-rm --single-branch https://github.com/ginkgo-project/ginkgo.git
git clone -b koch/ginkgo-integration  --single-branch --recurse-submodules --shallow-submodules https://i10git.cs.fau.de/hyteg/hyteg.git

mkdir hyteg/build
mkdir ginkgo/build

pushd ginkgo/build || exit
GINKGO_DIR=$(pwd)
cmake -DCMAKE_BUILD_TYPE=Release -DGINKGO_BUILD_MPI=ON -DGINKGO_BUILD_HIP=ON  -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpic++ -DGINKGO_BUILD_HWLOC=OFF ..
make ginkgo -j $(nproc --all --ignore=1)
popd || exit

pushd hyteg/build || exit
git checkout 50d8406e
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpic++ -DHYTEG_BUILD_WITH_PETSC=ON  -DPETSC_DIR=$PETSC_DIR -DHYTEG_BUILD_WITH_GINKGO=ON -DGinkgo_DIR="$GINKGO_DIR" -DGinkgo_RM_DIR="$GINKGO_DIR/../extension/resource_manager/include" ..
make Tokamak -j $(nproc --all --ignore=1)
popd || exit
