!**********************************************************************************************************************************
!**********************************************************************************************************************************
!
!  ParaMonte: plain powerful parallel Monte Carlo library.
!
!  Copyright (C) 2012-present, The Computational Data Science Lab
!
!  This file is part of ParaMonte library. 
!
!  ParaMonte is free software: you can redistribute it and/or modify
!  it under the terms of the GNU Lesser General Public License as published by
!  the Free Software Foundation, version 3 of the License.
!
!  ParaMonte is distributed in the hope that it will be useful,
!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!  GNU Lesser General Public License for more details.
!
!  You should have received a copy of the GNU Lesser General Public License
!  along with ParaMonte.  If not, see <https://www.gnu.org/licenses/>.
!
!**********************************************************************************************************************************
!**********************************************************************************************************************************

module ParaDRAMProposalSymmetric_mod
  
    use ParaDRAMProposal_mod, only: Proposal_type
    use ParaMonte_mod, only: Image_type
    use Constants_mod, only: IK, RK
    use String_mod, only: IntStr_type
    use Err_mod, only: Err_type

    implicit none

    !private
    !public :: ProposalSymmetric_type

    character(*), parameter         :: MODULE_NAME = "@ParaDRAMProposalSymmetric_mod"

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    type                            :: AccRate_type
        real(RK)                    :: sumUpToLastUpdate
        real(RK)                    :: target
    end type AccRate_type

    type, extends(Proposal_type)    :: ProposalSymmetric_type
        !type(AccRate_type)          :: AccRate
    contains
        procedure   , nopass        :: getNew
        procedure   , nopass        :: doAdaptation
        procedure   , nopass        :: readRestartFile
        procedure   , nopass        :: writeRestartFile
#if defined CAF_ENABLED || defined MPI_ENABLED
        procedure   , nopass        :: getAdaptation
#endif
    end type ProposalSymmetric_type

    interface ProposalSymmetric_type
        module procedure :: constructProposalSymmetric
    end interface ProposalSymmetric_type

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    ! Covariance Matrix of the proposal distribution. Last index belongs to delayed rejection

#if defined CAF_ENABLED
    real(RK)    , allocatable, save :: comv_CholDiagLower(:,:,:)[:]
#else
    real(RK)    , allocatable, save :: comv_CholDiagLower(:,:,:)
#endif

#if defined MPI_ENABLED
    integer(IK)     , save                  :: mc_ndimSqPlusNdim
#endif
    type(Image_type), save                  :: mc_Image
    integer(IK)     , save                  :: mc_ndim
    integer(IK)     , save                  :: mc_logFileUnit
    integer(IK)     , save                  :: mc_restartFileUnit
    logical         , save                  :: mc_scalingRequested
    real(RK)        , save                  :: mc_defaultScaleFactorSq
    integer(IK)     , save                  :: mc_DelayedRejectionCount
    integer(IK)     , save                  :: mc_MaxNumDomainCheckToWarn
    integer(IK)     , save                  :: mc_MaxNumDomainCheckToStop
    logical         , save                  :: mc_delayedRejectionRequested
    real(RK)        , save                  :: mc_ndimInverse
    real(RK)        , save                  :: mc_targetAcceptanceRate
   !real(RK)        , save                  :: mc_maxScaleFactor != 2._RK
   !real(RK)        , save                  :: mc_maxScaleFactorSq != mc_maxScaleFactor**2
    real(RK)        , save  , allocatable   :: mc_DelayedRejectionScaleFactorVec(:)
    real(RK)        , save  , allocatable   :: mc_DomainLowerLimitVec(:)
    real(RK)        , save  , allocatable   :: mc_DomainUpperLimitVec(:)
    character(:)    , save  , allocatable   :: mc_MaxNumDomainCheckToWarnMsg
    character(:)    , save  , allocatable   :: mc_MaxNumDomainCheckToStopMsg
    character(:)    , save  , allocatable   :: mc_negativeHellingerDistSqMsg
    character(:)    , save  , allocatable   :: mc_restartFileFormat
    character(:)    , save  , allocatable   :: mc_methodBrand
    character(:)    , save  , allocatable   :: mc_methodName
    logical         , save                  :: mc_isNormal

    ! the following had to be defined globally for the sake of restart file generation

    real(RK)        , save  , allocatable   :: mv_MeanOld_save(:)
    real(RK)        , save                  :: mv_logSqrtDetOld_save
    real(RK)        , save                  :: mv_adaptiveScaleFactorSq_save    ! = 1._RK
    integer(IK)     , save                  :: mv_sampleSizeOld_save            ! = 0_IK
    type(Err_type)  , save                  :: mv_Err

!***********************************************************************************************************************************
!***********************************************************************************************************************************

contains

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    ! This interface madness is a result of the internal compiler bug in GFortran as of Jan 2020, which diagnoses a ParaDRAM_type 
    ! argument as circular dependency due to this constructor appearing the type-bound setup procedure of ParaDRAM_type.
    ! Intel does not complain. Until GFortran comes up with a fix, we have to live with this interface.
    function constructProposalSymmetric ( ndim &
                                        , SpecBase &
                                        , SpecDRAM &
                                        , Image &
                                        , name &
                                        , brand &
                                        , LogFile &
                                        , RestartFile &
                                        ) result(Proposal)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: constructProposalSymmetric
#endif

        use Constants_mod, only: IK, RK, NULL_RK
        use ParaMonte_mod, only: Image_type
        use ParaMonte_mod, only: LogFile_type
        use ParaMonte_mod, only: RestartFile_type
        use SpecBase_mod, only: SpecBase_type
        use SpecDRAM_mod, only: SpecDRAM_type
        use ParaDRAM_mod, only: ParaDRAM_type
        use String_mod, only: num2str
        use Err_mod, only: abort

        implicit none

        integer(IK)             , intent(in)    :: ndim
        type(SpecBase_type)     , intent(in)    :: SpecBase
        type(SpecDRAM_type)     , intent(in)    :: SpecDRAM
        type(Image_type)        , intent(in)    :: Image
        character(*)            , intent(in)    :: name
        character(*)            , intent(in)    :: brand
        type(LogFile_type)      , intent(in)    :: LogFile
        type(RestartFile_type)  , intent(in)    :: RestartFile

        type(ProposalSymmetric_type)            :: Proposal

        character(*), parameter                 :: PROCEDURE_NAME = MODULE_NAME // "@constructProposalSymmetric()"
        integer                                 :: i, j

        !***************************************************************************************************************************
        ! setup sampler update global save variables
        !***************************************************************************************************************************

        if (allocated(mv_MeanOld_save)) deallocate(mv_MeanOld_save); allocate(mv_MeanOld_save(ndim))
        mv_MeanOld_save(1:ndim) = NULL_RK
        mv_logSqrtDetOld_save   = NULL_RK
        mv_sampleSizeOld_save   = 0_IK
        mv_adaptiveScaleFactorSq_save = 1._RK

        !***************************************************************************************************************************
        ! setup general ParaDRAMProposalSymmetric specifications
        !***************************************************************************************************************************

#if defined MPI_ENABLED
        mc_ndimSqPlusNdim                   = ndim*(ndim+1_IK)
#endif
        mc_ndim                             = ndim
        mc_DomainLowerLimitVec              = SpecBase%DomainLowerLimitVec%Val
        mc_DomainUpperLimitVec              = SpecBase%DomainUpperLimitVec%Val
        mc_DelayedRejectionScaleFactorVec   = SpecDRAM%delayedRejectionScaleFactorVec%Val
        mc_isNormal                         = SpecDRAM%ProposalModel%isNormal
        mc_Image                            = Image
        mc_methodName                       = name
        mc_methodBrand                      = brand
        mc_logFileUnit                      = LogFile%unit
        mc_restartFileUnit                  = RestartFile%unit
        mc_restartFileFormat                = RestartFile%format
        mc_defaultScaleFactorSq             = SpecDRAM%ScaleFactor%val**2
       !Proposal%AccRate%sumUpToLastUpdate  = 0._RK
        mc_maxNumDomainCheckToWarn          = SpecBase%MaxNumDomainCheckToWarn%val
        mc_maxNumDomainCheckToStop          = SpecBase%MaxNumDomainCheckToStop%val
        mc_delayedRejectionCount            = SpecDRAM%DelayedRejectionCount%val
        mc_delayedRejectionRequested        = mc_DelayedRejectionCount > 0_IK
        mc_scalingRequested                 = SpecBase%TargetAcceptanceRate%scalingRequested

        if (mc_scalingRequested) then
            mc_targetAcceptanceRate         = SpecBase%TargetAcceptanceRate%val
        else
            mc_targetAcceptanceRate         = 1._RK !0.234_RK
        end if
        mc_ndimInverse                      = 1._RK/real(ndim,kind=RK)
       !mc_maxScaleFactorSq                 = 4._RK**mc_ndimInverse
       !mc_maxScaleFactor                   = sqrt(mc_maxScaleFactorSq)

        !***************************************************************************************************************************
        ! setup ProposalSymmetric specifications
        !***************************************************************************************************************************

        ! setup covariance matrix

        if (allocated(comv_CholDiagLower)) deallocate(comv_CholDiagLower)
#if defined CAF_ENABLED
        ! on the second dimension, the zeroth index refers to the Diagonal elements of the Cholesky lower triangular matrix
        ! This rearrangement was done for more efficient communication of the matrix across processes.
        allocate( comv_CholDiagLower(ndim,0:ndim,0:mc_DelayedRejectionCount)[*] )
#else
        allocate( comv_CholDiagLower(ndim,0:ndim,0:mc_DelayedRejectionCount) )
#endif

        if ( SpecDRAM%ProposalStartCovMat%isPresent ) then
            comv_CholDiagLower(1:ndim,1:ndim,0) = SpecDRAM%ProposalStartCovMat%Val
        else
            block
                use Statistics_mod, only: getCovMatFromCorMat
                comv_CholDiagLower(1:ndim,1:ndim,0) = getCovMatFromCorMat   ( nd = ndim &
                                                                            , StdVec = SpecDRAM%ProposalStartStdVec%Val &
                                                                            , CorMat = SpecDRAM%ProposalStartCorMat%Val &
                                                                            )
            end block
        end if

        ! Now scale the covariance matrix

        do j = 1, ndim
            do i = 1, j
                comv_CholDiagLower(i,j,0) = comv_CholDiagLower(i,j,0) * mc_defaultScaleFactorSq
            end do
        end do

        ! Now get the Cholesky Factor of the Covariance Matrix. Lower comv_CholDiagLower will be the CholFac

        block
            use Matrix_mod, only: getCholeskyFactor
#if defined DBG_ENABLED
            real(RK), allocatable :: Dummy(:,:)
            Dummy = comv_CholDiagLower(1:ndim,1:ndim,0)
            call getCholeskyFactor( ndim, Dummy, comv_CholDiagLower(1:ndim,0,0) )
            comv_CholDiagLower(1:ndim,1:ndim,0) = Dummy 
#else
            call getCholeskyFactor( ndim, comv_CholDiagLower(1:ndim,1:ndim,0), comv_CholDiagLower(1:ndim,0,0) )
#endif
        end block
        if (comv_CholDiagLower(1,0,0)<0._RK) then
            mv_Err%msg = mc_Image%name // PROCEDURE_NAME // ": Singular input covariance matrix by user was detected. This is strange.\nCovariance matrix lower triangle:"
            do j = 1, ndim
                do i = 1, j
                    mv_Err%msg = mv_Err%msg // "\n" // num2str(comv_CholDiagLower(1:i,j,0))
                end do
            end do
#if defined CAF_ENABLED
            sync all
#elif defined MPI_ENABLED
            block
                use mpi
                integer :: ierrMPI
                call mpi_barrier(mpi_comm_world,ierrMPI)
            end block
#endif
            call abort( Err = mv_Err, prefix = mc_methodBrand, newline = "\n", outputUnit = mc_logFileUnit )
        end if

        ! Scale the higher-stage delayed-rejection Cholesky Lower matrices

        if (mc_delayedRejectionRequested) call updateDelRejCholDiagLower()

        ! This will be used for Domain boundary checking during the simulation

        mc_negativeHellingerDistSqMsg = MODULE_NAME//"@doAdaptation(): Non-positive adaptation measure detected, possibly due to round-off error: "
        mc_MaxNumDomainCheckToWarnMsg = MODULE_NAME//"@getNew(): "//num2str(mc_MaxNumDomainCheckToWarn)//&
                                        " proposals were drawn out of the objective function's Domain without any acceptance."
        mc_MaxNumDomainCheckToStopMsg = MODULE_NAME//"@getNew(): "//num2str(mc_MaxNumDomainCheckToStop)//&
                                        " proposals were drawn out of the objective function's Domain. As per the value set for the&
                                        & simulation specification variable 'maxNumDomainCheckToStop', "//mc_methodName//" will abort now."

    end function constructProposalSymmetric

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    function getNew ( nd            &
                    , counterDRS    &
                    , StateOld      &
                    ) result (StateNew)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getNew
#endif

        use Statistics_mod, only: getRandMVN, getRandMVU
        use Constants_mod, only: IK, RK
        use Err_mod, only: warn, abort
        use ParaMonteLogFunc_mod, only: getLogFunc_proc

        implicit none
        
        character(*), parameter                         :: PROCEDURE_NAME = MODULE_NAME // "@getNew()"
        
       !class(ProposalSymmetric_type), intent(inout)    :: Proposal
        integer(IK), intent(in)                         :: nd
        integer(IK), intent(in)                         :: counterDRS
        real(RK)   , intent(in)                         :: StateOld(nd)
        real(RK)                                        :: StateNew(nd)
        integer(IK)                                     :: domainCheckCounter

        domainCheckCounter = 0

        if (mc_isNormal) then

            loopBoundaryCheckNormal: do ! Check for the support Region consistency:
#if defined DBG_ENABLED
                block
                real(RK), allocatable :: Dummy(:,:)
                Dummy = comv_CholDiagLower(1:nd,1:nd,counterDRS)
                StateNew = getRandMVN   ( nd                                        &
                                        , StateOld                                  &
                                        , Dummy                                     &
                                        , comv_CholDiagLower(1:nd,   0,counterDRS)  &
                                        )
                comv_CholDiagLower(1:nd,1:nd,counterDRS) = Dummy
                end block
#else
                StateNew = getRandMVN   ( nd                                        &
                                        , StateOld                                  &
                                        , comv_CholDiagLower(1:nd,1:nd,counterDRS)  &
                                        , comv_CholDiagLower(1:nd,   0,counterDRS)  &
                                        )
#endif
                if ( any(StateNew<=mc_DomainLowerLimitVec) .or. any(StateNew>=mc_DomainUpperLimitVec) ) then
                    domainCheckCounter = domainCheckCounter + 1
                    if (domainCheckCounter==mc_MaxNumDomainCheckToWarn) then
                        call warn( prefix = mc_methodBrand, outputUnit = mc_logFileUnit, msg = mc_MaxNumDomainCheckToWarnMsg )
                    end if
                    if (domainCheckCounter==mc_MaxNumDomainCheckToStop) then
                        mv_Err%msg = mc_MaxNumDomainCheckToStopMsg
                        call abort( Err = mv_Err, prefix = mc_methodBrand, newline = "\n", outputUnit = mc_logFileUnit )
                    end if
                    cycle loopBoundaryCheckNormal
                end if
                exit loopBoundaryCheckNormal
            end do loopBoundaryCheckNormal

        else ! if (mc_isUniform) then

            loopBoundaryCheckUniform: do ! Check for the support Region consistency:
#if defined DBG_ENABLED
                block
                real(RK), allocatable :: Dummy(:,:)
                Dummy = comv_CholDiagLower(1:nd,1:nd,counterDRS)
                StateNew = getRandMVU   ( nd                                        &
                                        , StateOld                                  &
                                        , Dummy                                     &
                                        , comv_CholDiagLower(1:nd,   0,counterDRS)  &
                                        )
                comv_CholDiagLower(1:nd,1:nd,counterDRS) = Dummy
                end block
#else
                StateNew = getRandMVU   ( nd                                        &
                                        , StateOld                                  &
                                        , comv_CholDiagLower(1:nd,1:nd,counterDRS)  &
                                        , comv_CholDiagLower(1:nd,   0,counterDRS)  &
                                        )
#endif
                if ( any(StateNew<=mc_DomainLowerLimitVec) .or. any(StateNew>=mc_DomainUpperLimitVec) ) then
                    domainCheckCounter = domainCheckCounter + 1
                    if (domainCheckCounter==mc_MaxNumDomainCheckToWarn) then
                        call warn( prefix = mc_methodBrand, outputUnit = mc_logFileUnit, msg = mc_MaxNumDomainCheckToWarnMsg )
                    end if
                    if (domainCheckCounter==mc_MaxNumDomainCheckToStop) then
                        mv_Err%msg = mc_MaxNumDomainCheckToStopMsg
                        call abort( Err = mv_Err, prefix = mc_methodBrand, newline = "\n", outputUnit = mc_logFileUnit )
                    end if
                    cycle loopBoundaryCheckUniform
                end if
                exit loopBoundaryCheckUniform
            end do loopBoundaryCheckUniform

        end if

    end function getNew

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    ! ATTN: This routine may need further correction for the delayed rejection method
    subroutine doAutoTune   ( hellingerDistSq   &
                            , AutoTuneScaleSq   &
                            )
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: doAutoTune
#endif
        use Matrix_mod, only: getLogSqrtDetPosDefMat
        use Constants_mod, only: RK, IK
        use Err_mod, only: abort
        implicit none
        character(*), parameter                         :: PROCEDURE_NAME = MODULE_NAME // "@doAutoTune()"
       !class(ProposalSymmetric_type), intent(inout)    :: Proposal
        real(RK)   , intent(in)                         :: AutoTuneScaleSq(1)
        real(RK)   , intent(inout)                      :: hellingerDistSq
        real(RK)                                        :: logSqrtDetNew, logSqrtDetSum, mv_logSqrtDetOld_save
        real(RK)                                        :: CovMatUpperOld(1,1), CovMatUpperCurrent(1,1)
        logical                                         :: singularityOccurred

        CovMatUpperOld = comv_CholDiagLower(1:mc_ndim,1:mc_ndim,0)
        mv_logSqrtDetOld_save = sum(log( comv_CholDiagLower(1:mc_ndim,0,0) ))

        if (AutoTuneScaleSq(1)==0._RK) then
            comv_CholDiagLower(1,1,0) = 0.25_RK*comv_CholDiagLower(1,1,0)
            comv_CholDiagLower(1,0,0) = sqrt(comv_CholDiagLower(1,1,0))
        else
            comv_CholDiagLower(1,1,0) = AutoTuneScaleSq(1)
            comv_CholDiagLower(1,0,0) = sqrt(AutoTuneScaleSq(1))
        end if

        ! compute the adaptivity

        logSqrtDetNew = sum(log( comv_CholDiagLower(1:mc_ndim,0,0) ))
        CovMatUpperCurrent = 0.5_RK * ( comv_CholDiagLower(1:mc_ndim,1:mc_ndim,0) + CovMatUpperOld )
        call getLogSqrtDetPosDefMat(1_IK,CovMatUpperCurrent,logSqrtDetSum,singularityOccurred)
        if (singularityOccurred) then
            mv_Err%msg =    PROCEDURE_NAME // &
                            ": Error occurred while computing the Cholesky factorization of &
                            &a matrix needed for the computation of the proposal distribution's adaptation measure. &
                            &Such error is highly unusual, and requires an in depth investigation of the case. &
                            &Restarting the simulation might resolve the error."
            call abort( Err = mv_Err, prefix = mc_methodBrand, newline = "\n", outputUnit = mc_logFileUnit )
            return
        end if
        hellingerDistSq = 1._RK - exp( 0.5_RK*(mv_logSqrtDetOld_save+logSqrtDetNew) - logSqrtDetSum )

    end subroutine doAutoTune

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine doAdaptation ( nd                        &
                            , chainSize                 &
                            , Chain                     &
                            , ChainWeight               &
                            , samplerUpdateIsGreedy     &
                            , meanAccRateSinceStart     &
                            , samplerUpdateSucceeded    &
                            , hellingerDistSq           &
                            )
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: doAdaptation
#endif

        use Statistics_mod, only: getSamCovUpperMeanTrans, getWeiSamCovUppMeanTrans, combineMeanCovUpper
        use Matrix_mod, only: getCholeskyFactor, getLogSqrtDetPosDefMat
        use Constants_mod, only: RK, IK, EPS_RK
        use String_mod, only: num2str
        use Err_mod, only: abort, warn
        implicit none

        character(*), parameter                         :: PROCEDURE_NAME = MODULE_NAME // "@doAdaptation()"

       !class(ProposalSymmetric_type), intent(inout)    :: Proposal
        integer(IK), intent(in)                         :: nd
        integer(IK), intent(in)                         :: chainSize
        real(RK)   , intent(in)                         :: Chain(nd,chainSize)
        integer(IK), intent(in)                         :: ChainWeight(chainSize)
        logical    , intent(in)                         :: samplerUpdateIsGreedy
        real(RK)   , intent(in)                         :: meanAccRateSinceStart
        logical    , intent(out)                        :: samplerUpdateSucceeded
        real(RK)   , intent(inout)                      :: hellingerDistSq

        integer(IK)                                     :: i, j
        real(RK)                                        :: MeanNew(nd)
        real(RK)                                        :: MeanCurrent(nd)
        real(RK)                                        :: CovMatUpperOld(nd,nd)
        real(RK)                                        :: CovMatUpperCurrent(nd,nd)
        real(RK)                                        :: logSqrtDetNew
        real(RK)                                        :: logSqrtDetSum
        real(RK)                                        :: adaptiveScaleFactor
        logical                                         :: hellingerComputationNeeded ! only used to avoid redundant Hellinger computation, if no update occurs
        logical                                         :: singularityOccurred, scalingNeeded
        integer(IK)                                     :: sampleSizeOld, sampleSizeCurrent

        scalingNeeded = .false.
        sampleSizeOld = mv_sampleSizeOld_save ! this is kept only for restoration of mv_sampleSizeOld_save, if needed.
        mv_logSqrtDetOld_save = sum(log( comv_CholDiagLower(1:nd,0,0) ))

        ! First if there are less than nd+1 points for new covariance computation, then just scale the covariance and return

        blockSufficientSampleSizeCheck: if (chainSize>nd) then

            ! get the new sample's upper covariance matrix and Mean

            if (samplerUpdateIsGreedy) then
                sampleSizeCurrent = chainSize
                call getSamCovUpperMeanTrans(sampleSizeCurrent,nd,Chain,CovMatUpperCurrent,MeanCurrent)
            else
                sampleSizeCurrent = sum(ChainWeight)
                call getWeiSamCovUppMeanTrans(chainSize,sampleSizeCurrent,nd,Chain,ChainWeight,CovMatUpperCurrent,MeanCurrent)
            end if

            !***********************************************************************************************************************

            ! combine old and new covariance matrices if both exist

            blockMergeCovMat: if (mv_sampleSizeOld_save==0) then

                ! There is no prior old Covariance matrix to combine with the new one from the new chain

                mv_MeanOld_save(1:nd) = MeanCurrent
                mv_sampleSizeOld_save = sampleSizeCurrent

                ! copy and then scale the new covariance matrix by the default scale factor, which will be then used to get the Cholesky Factor

                do j = 1, nd
                    do i = 1, j
                        CovMatUpperOld(i,j) = comv_CholDiagLower(i,j,0)   ! This will be used to recover the old covariance in case of update failure, and to compute the adaptation measure
                        comv_CholDiagLower(i,j,0) = CovMatUpperCurrent(i,j) * mc_defaultScaleFactorSq
                    end do
                end do

            else blockMergeCovMat

                ! first scale the new covariance matrix by the default scale factor, which will be then used to get the Cholesky Factor

                do j = 1, nd
                    do i = 1, j
                        CovMatUpperOld(i,j) = comv_CholDiagLower(i,j,0)   ! This will be used to recover the old covariance in case of update failure, and to compute the adaptation measure
                        CovMatUpperCurrent(i,j) = CovMatUpperCurrent(i,j) * mc_defaultScaleFactorSq
                    end do
                end do

                ! now combine it with the old covariance matrix

#if defined DBG_ENABLED
                block
                real(RK), allocatable :: Dummy(:,:)
                Dummy = comv_CholDiagLower(1:nd,1:nd,0)
                call combineMeanCovUpper( nd            = nd                                &
                                        , npA           = mv_sampleSizeOld_save             &
                                        , MeanVecA      = mv_MeanOld_save                   &
                                        , CovMatUpperA  = CovMatUpperOld                    &
                                        , npB           = sampleSizeCurrent                 &
                                        , MeanVecB      = MeanCurrent                       &
                                        , CovMatUpperB  = CovMatUpperCurrent                &
                                        , MeanVec       = MeanNew                           &
                                        , CovMatUpper   = Dummy                             &
                                        )
                comv_CholDiagLower(1:nd,1:nd,0) = Dummy
                end block
#else
                call combineMeanCovUpper( nd            = nd                                &
                                        , npA           = mv_sampleSizeOld_save             &
                                        , MeanVecA      = mv_MeanOld_save                   &
                                        , CovMatUpperA  = CovMatUpperOld                    &
                                        , npB           = sampleSizeCurrent                 &
                                        , MeanVecB      = MeanCurrent                       &
                                        , CovMatUpperB  = CovMatUpperCurrent                &
                                        , MeanVec       = MeanNew                           &
                                        , CovMatUpper   = comv_CholDiagLower(1:nd,1:nd,0)   &
                                        )
#endif
                mv_MeanOld_save(1:nd) = MeanNew

            end if blockMergeCovMat

            !***********************************************************************************************************************

            ! now get the Cholesky factorization

#if defined DBG_ENABLED
            block
                real(RK), allocatable :: Dummy(:,:)
                Dummy = comv_CholDiagLower(1:nd,1:nd,0)
                call getCholeskyFactor( nd, Dummy, comv_CholDiagLower(1:nd,0,0) )
                comv_CholDiagLower(1:nd,1:nd,0) = Dummy
            end block
#else
            call getCholeskyFactor( nd, comv_CholDiagLower(1:nd,1:nd,0), comv_CholDiagLower(1:nd,0,0) )
#endif

            blockPosDefCheck: if (comv_CholDiagLower(1,0,0)>0._RK) then

                singularityOccurred = .false.
                samplerUpdateSucceeded = .true.
                hellingerComputationNeeded = .true.
                mv_sampleSizeOld_save = mv_sampleSizeOld_save + sampleSizeCurrent

            else blockPosDefCheck

                ! it may be a good idea to add a warning message printed out here for the singularity occurrence

                singularityOccurred = .true.
                samplerUpdateSucceeded = .false.
                hellingerComputationNeeded = .false.
                mv_sampleSizeOld_save = sampleSizeOld

                ! recover the old upper covariance matrix

                do j = 1, nd
                    do i = 1, j
                        comv_CholDiagLower(i,j,0) = CovMatUpperOld(i,j)
                    end do
                end do

                ! ensure the old Cholesky factorization can be recovered

                !j = 0_IK
                !do
                    call getCholeskyFactor( nd, comv_CholDiagLower(1:nd,1:nd,0), comv_CholDiagLower(1:nd,0,0) )
                    if (comv_CholDiagLower(1,0,0)<0._RK) then
                        mv_Err%msg =    PROCEDURE_NAME // &
                                        ": Error occurred while attempting to compute the Cholesky factorization of the &
                                        &covariance matrix of the proposal distribution of " // mc_methodName // "'s sampler. &
                                        &This is highly unusual, and can be indicative of some major underlying problems.\n&
                                        &It may also be due to a runtime computational glitch, in particular, for high-dimensional simulations. &
                                        &In such case, consider increasing the value of the input variable adaptiveUpdatePeriod.\n&
                                        &Restarting the simulation might resolve the error."
                        call abort( Err = mv_Err, prefix = mc_methodBrand, newline = "\n", outputUnit = mc_logFileUnit )
               !        call warn( prefix = mc_methodBrand, outputUnit = mc_logFileUnit, msg = mv_Err%msg )
               !        j = j + 1_IK
               !        do i = 1, nd
               !            write(mc_logFileUnit,
               !            comv_CholDiagLower(i,i,0) = comv_CholDiagLower(i,i,0) + 2_IK**j * EPS_RK
               !        end do
                    end if
               !    exit
               !end do

            end if blockPosDefCheck

            !***********************************************************************************************************************

            !! perform global adaptive scaling is requested
            !if (mc_scalingRequested) then
            !    if (meanAccRateSinceStart<mc_targetAcceptanceRate) then
            !        mv_adaptiveScaleFactorSq_save = mc_maxScaleFactorSq**((mc_targetAcceptanceRate-meanAccRateSinceStart)/mc_targetAcceptanceRate)
            !    else
            !        mv_adaptiveScaleFactorSq_save = mc_maxScaleFactorSq**((mc_targetAcceptanceRate-meanAccRateSinceStart)/(1._RK-mc_targetAcceptanceRate))
            !    end if
            !    mv_adaptiveScaleFactorSq_save = mv_adaptiveScaleFactorSq_save * (meanAccRateSinceStart/mc_targetAcceptanceRate)**mc_ndimInverse
            !end if
            if (mc_scalingRequested) scalingNeeded = .true.

        else blockSufficientSampleSizeCheck

            ! singularity has occurred. If the first covariance merging has not occurred yet, set the scaling factor appropriately to shrink the covariance matrix.

            samplerUpdateSucceeded = .false.
            if (mv_sampleSizeOld_save==0 .or. mc_scalingRequested) then
                scalingNeeded = .true.
                hellingerComputationNeeded = .true.
                ! save the old covariance matrix for the computation of the adaptation measure
                do j = 1, nd
                    do i = 1,j
                        CovMatUpperOld(i,j) = comv_CholDiagLower(i,j,0)
                    end do
                end do
            else
                hellingerComputationNeeded = .false.
            end if


        end if blockSufficientSampleSizeCheck

        ! adjust the scale of the covariance matrix and the Cholesky factor, if needed

        if (scalingNeeded) then
            mv_adaptiveScaleFactorSq_save = (meanAccRateSinceStart/mc_targetAcceptanceRate)**mc_ndimInverse
            adaptiveScaleFactor = sqrt(mv_adaptiveScaleFactorSq_save)
            do j = 1, nd
                ! update the Cholesky diagonal elements
                comv_CholDiagLower(j,0,0) = comv_CholDiagLower(j,0,0) * adaptiveScaleFactor
                ! update covariance matrix
                do i = 1,j
                    comv_CholDiagLower(i,j,0) = comv_CholDiagLower(i,j,0) * mv_adaptiveScaleFactorSq_save
                end do
                ! update the Cholesky factorization
                do i = j+1, nd
                    comv_CholDiagLower(i,j,0) = comv_CholDiagLower(i,j,0) * adaptiveScaleFactor
                end do
            end do
        end if

        ! compute the adaptivity only if any updates has occurred

        if (hellingerComputationNeeded) then
            logSqrtDetNew = sum(log( comv_CholDiagLower(1:nd,0,0) ))
            do j = 1, nd
                do i = 1,j
                    CovMatUpperCurrent(i,j) = 0.5_RK * ( comv_CholDiagLower(i,j,0) + CovMatUpperOld(i,j) )
                end do
            end do
            call getLogSqrtDetPosDefMat(nd,CovMatUpperCurrent,logSqrtDetSum,singularityOccurred)
            if (singularityOccurred) then
                mv_Err%msg =    PROCEDURE_NAME // &
                                ": Error occurred while computing the Cholesky factorization of &
                                &a matrix needed for the computation of the Adaptation measure. &
                                &Such error is highly unusual, and requires an in depth investigation of the case.\n&
                                &It may also be due to a runtime computational glitch, in particular, for high-dimensional simulations. &
                                &In such case, consider increasing the value of the input variable adaptiveUpdatePeriod.\n&
                                &It may also be that your input objective function may have been correctly implemented.\n&
                                &Restarting the simulation might resolve the error."
                call abort( Err = mv_Err, prefix = mc_methodBrand, newline = "\n", outputUnit = mc_logFileUnit )
                return
            end if
            hellingerDistSq = 1._RK - exp( 0.5_RK*(mv_logSqrtDetOld_save+logSqrtDetNew) - logSqrtDetSum )
            if (hellingerDistSq<0._RK) then
                call warn   ( prefix = mc_methodBrand &
                            , outputUnit = mc_logFileUnit &
                            , msg = mc_negativeHellingerDistSqMsg//num2str(hellingerDistSq) )
                hellingerDistSq = 0._RK
            end if
            ! update the higher-stage delayed-rejection Cholesky Lower matrices
            if (mc_delayedRejectionRequested) call updateDelRejCholDiagLower()
        end if

    end subroutine doAdaptation

!***********************************************************************************************************************************
!***********************************************************************************************************************************

#if defined CAF_ENABLED

    ! Note: based on some benchmarks with ndim = 1, the new design with merging cholesky diag and lower is faster than the original
    ! Note: double communication. Here are some timings on 4 images:
    ! Note: new single communication:
    ! Note: image 2: avgTime =  6.960734060198531E-006
    ! Note: image 3: avgTime =  7.658279491640721E-006
    ! Note: image 4: avgTime =  9.261191328273417E-006
    ! Note: avg(avgTime): 7.960068293370891e-06
    ! Note: old double communication:
    ! Note: image 4: avgTime =  1.733505615104837E-005
    ! Note: image 3: avgTime =  1.442608268140151E-005
    ! Note: image 2: avgTime =  1.420345299036357E-005
    ! Note: avg(avgTime): 1.532153060760448e-05
    ! Note: avg(speedup): 1.924798889020109
    ! Note: One would expect this speed up to diminish as ndim goes to infinity, 
    ! Note: since data transfer will dominate communication overhead.
    subroutine getAdaptation()
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getAdaptation
#endif
        implicit none
        comv_CholDiagLower(1:mc_ndim,0:mc_ndim,0) = comv_CholDiagLower(1:mc_ndim,0:mc_ndim,0)[1]
        if (mc_delayedRejectionRequested) call updateDelRejCholDiagLower()  ! update the higher-stage delayed-rejection Cholesky Lower matrices
    end subroutine getAdaptation

#elif defined MPI_ENABLED

    subroutine getAdaptation()
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getAdaptation
#endif
        use mpi
        implicit none
        integer :: ierrMPI
        call mpi_bcast  ( comv_CholDiagLower    &   ! buffer: XXX: first element is not needed to be shared. This may need a fix in future
                        , mc_ndimSqPlusNdim     &   ! count
                        , mpi_double_precision  &   ! datatype
                        , 0                     &   ! root: broadcasting rank
                        , mpi_comm_world        &   ! comm
                        , ierrMPI               &   ! ierr
                        )
        if (mc_Image%isNotMaster .and. mc_delayedRejectionRequested) call updateDelRejCholDiagLower()
    end subroutine getAdaptation

#endif

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    ! the performance of this update could be improved by only updating the higher-stage covariance, only when needed.
    ! but the gain will be likely minimal, especially in low-dimensions.
    subroutine updateDelRejCholDiagLower()
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: updateDelRejCholDiagLower
#endif
        implicit none
        integer(IK) :: j, istage
        ! update the Cholesky factor of the delayed-rejection-stage proposal distributions
        do istage = 1, mc_DelayedRejectionCount
            comv_CholDiagLower(1:mc_ndim,0,istage) = comv_CholDiagLower(1:mc_ndim,0,istage-1) * mc_DelayedRejectionScaleFactorVec(istage)
            do j = 1, mc_ndim 
                comv_CholDiagLower(j+1:mc_ndim,j,istage) = comv_CholDiagLower(j+1:mc_ndim,j,istage-1) * mc_DelayedRejectionScaleFactorVec(istage)
            end do
        end do
        ! There is no need to check for positive-definiteness of the comv_CholDiagLower, it's already checked on the first image.
    end subroutine updateDelRejCholDiagLower

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine writeRestartFile()
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: writeRestartFile
#endif
        implicit none
        write( mc_restartFileUnit, mc_restartFileFormat ) "sampleSizeOld" &
                                                        , mv_sampleSizeOld_save &
                                                        , "logSqrtDetOld" &
                                                        , mv_logSqrtDetOld_save &
                                                        , "adaptiveScaleFactorSq" &
                                                        , mv_adaptiveScaleFactorSq_save &
                                                        , "MeanOld(1:ndim)" &
                                                        , mv_MeanOld_save(1:mc_ndim) &
                                                        , "CholDiagLower(1:ndim,0:ndim,0)" &
                                                        , comv_CholDiagLower(1:mc_ndim,0:mc_ndim,0)
        flush(mc_restartFileUnit)
    end subroutine writeRestartFile

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine readRestartFile()
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: readRestartFile
#endif
        implicit none
        integer(IK) :: i
        do i = 1, 8 + mc_ndim * (mc_ndim+2)
            !read( mc_restartFileUnit, mc_restartFileFormat )
            read( mc_restartFileUnit, * )
        end do
    end subroutine readRestartFile

!***********************************************************************************************************************************
!***********************************************************************************************************************************

end module ParaDRAMProposalSymmetric_mod
