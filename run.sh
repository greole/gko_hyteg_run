#!/bin/bash
#SBATCH -J Tokamak
#SBATCH -o %x-%j.out
#SBATCH -t 00:05:00
#SBATCH -N 1
#SBATCH -n 16

module purge

module load devel/cmake/3.18
module load toolkit/rocm/4.3.1
module add compiler/gnu/11  mpi/openmpi/4.1 devel/cmake

unset OMPI_CFLAGS OMPI_CXXFLAGS OMPI_FCFLAGS OMPI_FFLAGS

unset CFLAGS CXXFLAGS FCFLAGS FFLAGS

unset CC CXX FC F77


PETSC_DIR=/hkfs/home/project/hk-project-test-fine/eq4036/data/code/petsc/.install
PETSC_ARCH=""

cd $HOME/tmp/hyteg/build/apps/2021-tokamak/
srun ./Tokamak Tokamak.prm -Parameters.minLevel=3 -Parameters.maxLevel=6 -Parameters.coarseGridSolverType=cg_ginkgo \
  -Parameters.gkoExecutor=hip -Parameters.useAgglomeration=false -Parameters.cgHytegVerbose=true -Parameters.precomputeElementMatrices=true \
  -Parameter.relativeResidualReduction=1e-6 -Parameters.jsonFileName=TokamakTiming-PA-gingko-3-6.json \
  >TokamakLog-PA-gingko-3-6
