!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!
!!!!   MIT License
!!!!
!!!!   ParaMonte: plain powerful parallel Monte Carlo library.
!!!!
!!!!   Copyright (C) 2012-present, The Computational Data Science Lab
!!!!
!!!!   This file is part of the ParaMonte library.
!!!!
!!!!   Permission is hereby granted, free of charge, to any person obtaining a
!!!!   copy of this software and associated documentation files (the "Software"),
!!!!   to deal in the Software without restriction, including without limitation
!!!!   the rights to use, copy, modify, merge, publish, distribute, sublicense,
!!!!   and/or sell copies of the Software, and to permit persons to whom the
!!!!   Software is furnished to do so, subject to the following conditions:
!!!!
!!!!   The above copyright notice and this permission notice shall be
!!!!   included in all copies or substantial portions of the Software.
!!!!
!!!!   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
!!!!   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
!!!!   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
!!!!   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
!!!!   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
!!!!   OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
!!!!   OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
!!!!
!!!!   ACKNOWLEDGMENT
!!!!
!!!!   ParaMonte is an honor-ware and its currency is acknowledgment and citations.
!!!!   As per the ParaMonte library license agreement terms, if you use any parts of
!!!!   this library for any purposes, kindly acknowledge the use of ParaMonte in your
!!!!   work (education/research/industry/development/...) by citing the ParaMonte
!!!!   library as described on this page:
!!!!
!!!!       https://github.com/cdslaborg/paramonte/blob/main/ACKNOWLEDGMENT.md
!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!> \brief
!> This file contains the body of `ParaDRAM_mod` and `ParaDISE_mod` modules.
!>
!> \remark
!> This module requires preprocessing, prior to compilation.
!>
!> \author Amir Shahmoradi

!#define CAT(a,b) a##b
!#define XCAT(a,b) CAT(a,b)
#if defined PARADRAM

#define ParaDXXX_mod ParaDRAM_mod
#define ParaDXXX_type ParaDRAM_type
#define ParaDXXXProposalAbstract_mod ParaDRAMProposalAbstract_mod

#elif defined PARADISE

#define ParaDXXX_mod ParaDISE_mod
#define ParaDXXX_type ParaDISE_type
#define ParaDXXXProposalAbstract_mod ParaDISEProposalAbstract_mod

#else
#error "Unrecognized sampler in ParaDRAM_mod.inc.f90"
#endif

    use Constants_mod, only: IK, RK, CK ! LCOV_EXCL_LINE
    use ParaMonte_mod, only: ParaMonteNumFunCall_type
    use ParaMCMC_mod, only: ParaMCMC_type, ParaMCMC_Statistics_type, ParaMCMC_Chain_type
    use SpecDRAM_mod, only: SpecDRAM_type
    use ParaMonteLogFunc_mod, only: getLogFunc_proc
    use ParaDXXXProposalAbstract_mod, only: ProposalAbstract_type

    implicit none

#if defined PARADRAM
    character(*), parameter :: MODULE_NAME = "@ParaDRAM_mod"
#elif defined PARADISE
    character(*), parameter :: MODULE_NAME = "@ParaDISE_mod"
#endif

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    type, extends(ParaMonteNumFunCall_type) :: NumFunCall_type
        integer(IK)                         :: acceptedRejectedDelayed          !< accepted + rejected function calls, including the delayed rejections
        integer(IK)                         :: acceptedRejectedDelayedUnused    !< by all processes, used or unused
    end type NumFunCall_type

    type, extends(ParaMCMC_Statistics_type) :: Statistics_type
        type(ParaMCMC_Chain_type)           :: AdaptationBurninLoc              !< burning loc based on the minimum adaptation measure requested
        type(NumFunCall_type)               :: NumFunCall
    end type Statistics_type

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> The ParaDRAM_type and ParaDISE_type classes.
    type, extends(ParaMCMC_type)                    :: ParaDXXX_type
        type(SpecDRAM_type)                         :: SpecDRAM     !< Object of [SpecDRAM_type](@ref specdram_type) class containing DRAM simulation specs.
        type(Statistics_type)                       :: Stats        !< Object of [Statistics_type](@ref statistics_type) class containing simulation statistics.
        class(ProposalAbstract_type), allocatable   :: Proposal     !< Object of [ProposalAbstract_type](@ref proposalabstract_type) class representing the proposal distribution of the MCMC sampler.
       !class(ProposalAbstract_type), pointer       :: Proposal => null()
    contains
        procedure, pass, private                    :: getSpecFromInputFile
        procedure, pass, public                     :: runSampler
        procedure, pass, private                    :: runKernel
    end type ParaDXXX_type ! ParaDRAM_type or ParaDISE_type

    interface
    module subroutine getSpecFromInputFile( self, nd )
#if INTEL_COMPILER_ENABLED && defined DLL_ENABLED && (OS_IS_WINDOWS || defined OS_IS_DARWIN)
        !DEC$ ATTRIBUTES DLLEXPORT :: getSpecFromInputFile
#endif
        use Constants_mod, only: IK
        class(ParaDXXX_type), intent(inout) :: self
        integer(IK), intent(in)             :: nd
    end subroutine getSpecFromInputFile
    end interface

    interface
    module subroutine runKernel( self, getLogFunc )
#if INTEL_COMPILER_ENABLED && defined DLL_ENABLED && (OS_IS_WINDOWS || defined OS_IS_DARWIN)
        !DEC$ ATTRIBUTES DLLEXPORT :: runKernel
#endif
        use ParaMonteLogFunc_mod, only: getLogFunc_proc
        class(ParaDXXX_type), intent(inout) :: self
        procedure(getLogFunc_proc)          :: getLogFunc
    end subroutine runKernel
    end interface

    interface
    module subroutine runSampler( self                                  &
                                , ndim                                  &
                                , getLogFunc                            &
                                , inputFile                             &
                                ! ParaMonte variables
                                , sampleSize                            &
                                , randomSeed                            &
                                , description                           &
                                , outputFileName                        &
                                , outputDelimiter                       &
                                , chainFileFormat                       &
                                , variableNameList                      &
                                , restartFileFormat                     &
                                , outputColumnWidth                     &
                                , overwriteRequested                    &
                                , outputRealPrecision                   &
                                , silentModeRequested                   &
                                , domainLowerLimitVec                   &
                                , domainUpperLimitVec                   &
                                , parallelizationModel                  &
                                , progressReportPeriod                  &
                                , TargetAcceptanceRate                  &
                                , mpiFinalizeRequested                  &
                                , maxNumDomainCheckToWarn               &
                                , maxNumDomainCheckToStop               &
                                ! ParaMCMC variables
                                , chainSize                             &
                                , startPointVec                         &
                                , sampleRefinementCount                 &
                                , sampleRefinementMethod                &
                                , randomStartPointRequested             &
                                , randomStartPointDomainLowerLimitVec   &
                                , randomStartPointDomainUpperLimitVec   &
                                ! ParaDRAM variables
                                , scaleFactor                           &
                                , proposalModel                         &
                                , proposalStartStdVec                   &
                                , proposalStartCorMat                   &
                                , proposalStartCovMat                   &
                                , adaptiveUpdateCount                   &
                                , adaptiveUpdatePeriod                  &
                                , greedyAdaptationCount                 &
                                , delayedRejectionCount                 &
                                , burninAdaptationMeasure               &
                                , delayedRejectionScaleFactorVec        &
                                ) ! result(self)
#if INTEL_COMPILER_ENABLED && defined DLL_ENABLED && (OS_IS_WINDOWS || defined OS_IS_DARWIN)
        !!DEC$ ATTRIBUTES DLLEXPORT :: ParaDXXX_type
        !DEC$ ATTRIBUTES DLLEXPORT :: runSampler
#endif
        use ParaMonteLogFunc_mod, only: getLogFunc_proc
        use Constants_mod, only: IK, RK

        implicit none

        ! self
        class(ParaDXXX_type), intent(inout) :: self

        ! mandatory variables
        integer(IK) , intent(in)            :: ndim
        procedure(getLogFunc_proc)          :: getLogFunc

        character(*), intent(in), optional  :: inputFile

        ! ParaMonte variables
        integer(IK) , intent(in), optional  :: sampleSize
        integer(IK) , intent(in), optional  :: randomSeed
        character(*), intent(in), optional  :: description
        character(*), intent(in), optional  :: outputFileName
        character(*), intent(in), optional  :: outputDelimiter
        character(*), intent(in), optional  :: chainFileFormat
        character(*), intent(in), optional  :: variableNameList(ndim)
        character(*), intent(in), optional  :: restartFileFormat
        integer(IK) , intent(in), optional  :: outputColumnWidth
        logical     , intent(in), optional  :: overwriteRequested
        integer(IK) , intent(in), optional  :: outputRealPrecision
        logical     , intent(in), optional  :: silentModeRequested
        real(RK)    , intent(in), optional  :: domainLowerLimitVec(ndim)
        real(RK)    , intent(in), optional  :: domainUpperLimitVec(ndim)
        character(*), intent(in), optional  :: parallelizationModel
        integer(IK) , intent(in), optional  :: progressReportPeriod
        real(RK)    , intent(in), optional  :: TargetAcceptanceRate(2)
        logical     , intent(in), optional  :: mpiFinalizeRequested
        integer(IK) , intent(in), optional  :: maxNumDomainCheckToWarn
        integer(IK) , intent(in), optional  :: maxNumDomainCheckToStop

        ! ParaMCMC variables
        integer(IK) , intent(in), optional  :: chainSize
        real(RK)    , intent(in), optional  :: startPointVec(ndim)
        integer(IK) , intent(in), optional  :: sampleRefinementCount
        character(*), intent(in), optional  :: sampleRefinementMethod
        logical     , intent(in), optional  :: randomStartPointRequested
        real(RK)    , intent(in), optional  :: randomStartPointDomainLowerLimitVec(ndim)
        real(RK)    , intent(in), optional  :: randomStartPointDomainUpperLimitVec(ndim)

        ! ParaDRAM variables
        character(*), intent(in), optional  :: scaleFactor
        character(*), intent(in), optional  :: proposalModel
        real(RK)    , intent(in), optional  :: proposalStartStdVec(ndim)
        real(RK)    , intent(in), optional  :: proposalStartCorMat(ndim,ndim)
        real(RK)    , intent(in), optional  :: proposalStartCovMat(ndim,ndim)
        integer(IK) , intent(in), optional  :: adaptiveUpdateCount
        integer(IK) , intent(in), optional  :: adaptiveUpdatePeriod
        integer(IK) , intent(in), optional  :: greedyAdaptationCount
        integer(IK) , intent(in), optional  :: delayedRejectionCount
        real(RK)    , intent(in), optional  :: burninAdaptationMeasure
        real(RK)    , intent(in), optional  :: delayedRejectionScaleFactorVec(:)

    end subroutine runSampler
    end interface

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#if defined PARADISE
#elif defined PARADRAM
#endif

#undef ParaDXXX_mod
#undef ParaDXXX_type
#undef ParaDXXXProposalAbstract_mod

