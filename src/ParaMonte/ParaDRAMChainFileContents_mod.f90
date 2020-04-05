!**********************************************************************************************************************************
!**********************************************************************************************************************************
!
!  ParaMonte: plain powerful parallel Monte Carlo library.
!
!  Copyright (C) 2012-present, The Computational Data Science Lab
!
!  This file is part of the ParaMonte library. 
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

module ParaDRAMChainFileContents_mod

    use, intrinsic :: iso_fortran_env, only: output_unit
    use Constants_mod, only: IK, RK
    use Err_mod, only: Err_type
    use JaggedArray_mod, only: CharVec_type
    implicit none

    character(*), parameter :: MODULE_NAME = "@ParaDRAMChainFileContents_mod"

    integer(IK) , parameter :: NUM_DEF_COL = 7_IK   ! number of columns in the chain file other than the State columns

    character(*), parameter :: COL_HEADER_DEFAULT(NUM_DEF_COL) =    [ "ProcessID            " &
                                                                    , "DelayedRejectionStage" &
                                                                    , "MeanAcceptanceRate   " &
                                                                    , "AdaptationMeasure    " &
                                                                    , "BurninLocation       " &
                                                                    , "SampleWeight         " &
                                                                    , "SampleLogFunc        " &
                                                                    ]

    type :: Count_type
        integer(IK) :: compact = 0_IK   ! number of unique (weighted) points in the chain
        integer(IK) :: verbose = 0_IK   ! number of points (weight=1) in the MCMC chain
        integer(IK) :: resized = 0_IK   ! size of the allocations for the Chain components
    end type Count_type

    type                                    :: ChainFileContents_type
        integer(IK)                         :: ndim = 0_IK
        integer(IK)                         :: lenHeader = 0_IK
        integer(IK)                         :: numDefCol = NUM_DEF_COL
        type(Count_type)                    :: Count
        integer(IK)         , allocatable   :: ProcessID(:)     ! the vector of the ID of the images whose function calls haven been accepted
        integer(IK)         , allocatable   :: DelRejStage(:)   ! delayed rejection stages at which the proposed states were accepted
        real(RK)            , allocatable   :: Adaptation(:)    ! the vector of the adaptation measures at the MCMC accepted states.
        real(RK)            , allocatable   :: MeanAccRate(:)   ! the vector of the average acceptance rates at the given point in the chain
        integer(IK)         , allocatable   :: BurninLoc(:)     ! the burnin locations at the given locations in the chains
        integer(IK)         , allocatable   :: Weight(:)        ! the vector of the weights of the MCMC accepted states.
        real(RK)            , allocatable   :: LogFunc(:)       ! the vector of LogFunc values corresponding to the MCMC states.
        real(RK)            , allocatable   :: State(:,:)       ! the (nd,chainSize) MCMC chain of accepted proposed states
        type(CharVec_type)  , allocatable   :: ColHeader(:)     ! column headers of the chain file
        character(:)        , allocatable   :: delimiter        ! delimiter used to separate objects in the chain file
        type(Err_type)                      :: Err
    contains
        procedure, pass :: nullify => nullifyChainFileContents
        procedure, pass :: get => getChainFileContents
        procedure, pass :: writeChainFile
        procedure, pass :: getLenHeader
        procedure, pass :: writeHeader
    end type ChainFileContents_type

    interface ChainFileContents_type
        module procedure :: constructChainFileContents
    end interface ChainFileContents_type

!***********************************************************************************************************************************
!***********************************************************************************************************************************

contains

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    ! if chainFilePath is given, the rest of the optional arguments must be also given
    function constructChainFileContents(ndim,variableNameList,chainFilePath,chainSize,chainFileForm,lenHeader,delimiter,resizedChainSize) result(CFC)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: constructChainFileContents
#endif
        implicit none
        integer(IK) , intent(in)            :: ndim
        character(*), intent(in), optional  :: variableNameList(ndim)
        character(*), intent(in), optional  :: chainFilePath
        character(*), intent(in), optional  :: chainFileForm
        character(*), intent(in), optional  :: delimiter
        integer(IK) , intent(in), optional  :: lenHeader, chainSize, resizedChainSize
        type(ChainFileContents_type)        :: CFC
        type(Err_type)                      :: Err
        integer(IK)                         :: icol
        Err%occurred = .false.

        CFC%ndim = ndim

        ! set up the chain file column header

        allocate(CFC%ColHeader(ndim+NUM_DEF_COL))
        do icol = 1, NUM_DEF_COL
            CFC%ColHeader(icol)%record = trim(adjustl(COL_HEADER_DEFAULT(icol)))
        end do
        if (present(variableNameList)) then
            do icol = NUM_DEF_COL + 1, NUM_DEF_COL + ndim
                CFC%ColHeader(icol)%record = trim(adjustl(variableNameList(icol-NUM_DEF_COL)))
            end do
        end if

        ! set up other variables if given

        if (present(lenHeader)) CFC%lenHeader = lenHeader
        if (present(delimiter)) CFC%delimiter = delimiter
        if (present(resizedChainSize)) CFC%Count%resized = resizedChainSize

        ! read the chain file if the path is given

        if (present(chainFilePath)) call CFC%get(chainFilePath,chainFileForm,Err,chainSize,lenHeader,ndim,delimiter,resizedChainSize)
        if (Err%occurred) then
            CFC%Err%occurred = .true.
            CFC%Err%msg = Err%msg
            return
        end if

    end function constructChainFileContents

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine getChainFileContents(CFC,chainFilePath,chainFileForm,Err,chainSize,lenHeader,ndim,delimiter,resizedChainSize)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getChainFileContents
#endif
        ! resizedChainSize: >= chainSize, used for the allocation of the chain components
        ! chainSize: <= resizedChainSize, the first chainSize elements of the Chain components will contain the Chain information read from the chain file.
        !                               , the Chain component elements beyond chainSize will be set to zero.

        use FileContents_mod, only: getNumRecordInFile
        use Constants_mod, only: IK, RK, NLC
        use String_mod, only: String_type, getLowerCase, num2str

        implicit none

        character(*), parameter                         :: PROCEDURE_NAME = MODULE_NAME // "@getChainFileContents()"

        class(ChainFileContents_type), intent(inout)    :: CFC
        character(*)    , intent(in)                    :: chainFilePath
        character(*)    , intent(in)                    :: chainFileForm
        type(Err_type)  , intent(out)                   :: Err
        character(*)    , intent(in), optional          :: delimiter
        integer(IK)     , intent(in), optional          :: chainSize, lenHeader, ndim, resizedChainSize
        logical                                         :: fileExists, fileIsOpen, delimHasBegun, delimHasEnded, isBinary, isCompact, isVerbose
        integer(IK)                                     :: chainFileUnit, i, iState, delimiterLen, chainSizeDefault
        type(String_type)                               :: Record
        character(:), allocatable                       :: chainFilePathTrimmed, thisForm

        Err%occurred = .false.
        chainFilePathTrimmed = trim(adjustl(chainFilePath))
        inquire(file=chainFilePathTrimmed,exist=fileExists,opened=fileIsOpen,number=chainFileUnit)

        blockFileExistence: if (fileExists) then

            ! set up chain file format

            isBinary = .false.
            isCompact = .false.
            isVerbose = .false.
            if (getLowerCase(chainFileForm)=="binary") then
                isBinary = .true.
            elseif (getLowerCase(chainFileForm)=="compact") then
                isCompact = .true.
            elseif (getLowerCase(chainFileForm)=="verbose") then
                isVerbose = .false.
            else
                Err%occurred = .true.
                Err%msg = PROCEDURE_NAME//": Unrecognized chain file form: "//chainFileForm
                return
            end if

            if (isBinary) then
                thisForm = "unformatted"
                if (.not. present(ndim) .or. .not. present(lenHeader) .or. .not. present(delimiter)) then
                    Err%occurred = .true.
                    Err%msg = PROCEDURE_NAME//": If the chain file is in binary form, chainSize, lenHeader, delimiter, and ndim must be provided by the user."
                    return
                end if
            else
                thisForm = "formatted"
            end if

            if (fileIsOpen) then
                if (chainFileUnit==-1) then
                    Err%occurred = .true.
                    Err%msg = PROCEDURE_NAME//": The file located at: "//chainFilePathTrimmed//NLC//"is open, but no unit is connected to the file."//NLC
                    return
                else
                    close(chainFileUnit)
                end if
            end if

            ! get the number of records in file, minus header line

            if (present(chainSize)) then
                chainSizeDefault = chainSize
            else
                if (isBinary) then
                    open(newunit=chainFileUnit,file=chainFilePathTrimmed,status="old",form=thisForm,iostat=Err%stat)
                    if (Err%stat/=0) then
                        Err%occurred = .true.
                        Err%msg = PROCEDURE_NAME//": Unable to open the file located at: "//chainFilePathTrimmed//NLC
                        return
                    end if
                    if (allocated(Record%value)) deallocate(Record%value)
                    allocate( character(lenHeader) :: Record%value )
                    read(chainFileUnit) Record%value
                    block
                        integer(IK)             :: processID
                        integer(IK)             :: delRejStage
                        real(RK)                :: meanAccRate
                        real(RK)                :: adaptation
                        integer(IK)             :: burninLoc
                        integer(IK)             :: weight
                        real(RK)                :: logFunc
                        real(RK), allocatable   :: State(:)
                        allocate(State(ndim))
                        chainSizeDefault = 0_IK
                        loopFindChainSizeDefault: do
                            read(chainFileUnit,iostat=Err%stat) processID, delRejStage, meanAccRate, adaptation, burninLoc, weight, logFunc, State
                            if (Err%stat==0_IK) then
                                chainSizeDefault = chainSizeDefault + 1_IK
                            elseif (is_iostat_end(Err%stat)) then
                                exit loopFindChainSizeDefault
                            elseif (is_iostat_eor(Err%stat)) then
                                Err%occurred = .true.
                                Err%msg = PROCEDURE_NAME//": Incomplete record detected while reading the input binary chain file at: "//chainFilePathTrimmed//NLC
                                return
                            else
                                Err%occurred = .true.
                                Err%msg = PROCEDURE_NAME//": IO error occurred while reading the input binary chain file at: "//chainFilePathTrimmed//NLC
                                return
                            end if
                        end do loopFindChainSizeDefault
                    end block
                    close(chainFileUnit)
                else
                    call getNumRecordInFile(chainFilePathTrimmed,chainSizeDefault,Err,exclude="")
                    if (Err%occurred) then
                        Err%msg = PROCEDURE_NAME//Err%msg
                        return
                    end if
                    chainSizeDefault = chainSizeDefault - 1_IK
                end if
            end if

            ! set the number of elements in the Chain components

            if (present(resizedChainSize)) then
                CFC%Count%resized = resizedChainSize
            else
                CFC%Count%resized = chainSizeDefault
            end if
            if (CFC%Count%resized<chainSizeDefault) then
                Err%occurred = .true.
                Err%msg =   PROCEDURE_NAME//": input resizedChainSize cannot be smaller than the input chainSize:" // NLC // &
                            "    resizedChainSize = " // num2str(CFC%Count%resized) // NLC // &
                            "           chainSize = " // num2str(chainSizeDefault) // NLC // &
                            "It appears that the user has manipulated the output chain file."
                return
            end if

            ! allocate Chain components

            if (allocated(CFC%ProcessID))     deallocate(CFC%ProcessID)
            if (allocated(CFC%DelRejStage))   deallocate(CFC%DelRejStage)
            if (allocated(CFC%MeanAccRate))   deallocate(CFC%MeanAccRate)
            if (allocated(CFC%Adaptation))    deallocate(CFC%Adaptation)
            if (allocated(CFC%BurninLoc))     deallocate(CFC%BurninLoc)
            if (allocated(CFC%Weight))        deallocate(CFC%Weight)
            if (allocated(CFC%LogFunc))       deallocate(CFC%LogFunc)
            if (allocated(CFC%State))         deallocate(CFC%State)
            allocate(CFC%ProcessID  (CFC%Count%resized))
            allocate(CFC%DelRejStage(CFC%Count%resized))
            allocate(CFC%MeanAccRate(CFC%Count%resized))
            allocate(CFC%Adaptation (CFC%Count%resized))
            allocate(CFC%BurninLoc  (CFC%Count%resized))
            allocate(CFC%Weight     (CFC%Count%resized))
            allocate(CFC%LogFunc    (CFC%Count%resized))

            ! find the delimiter

            blockFindDelim: if (present(delimiter)) then

                CFC%delimiter = delimiter

            else blockFindDelim

                if (allocated(CFC%delimiter)) deallocate(CFC%delimiter)
                allocate( character(1023) :: CFC%delimiter )
                if (allocated(Record%value)) deallocate(Record%value)
                allocate( character(99999) :: Record%value )

                open(newunit=chainFileUnit,file=chainFilePathTrimmed,status="old",form=thisForm,iostat=Err%stat)
                if (Err%stat/=0) then
                    Err%occurred = .true.
                    Err%msg = PROCEDURE_NAME//": Unable to open the file located at: "//chainFilePathTrimmed//"."//NLC
                    return
                end if

                read(chainFileUnit,*)   ! skip the header
                read(chainFileUnit,"(A)") Record%value  ! read the first numeric row in string format
                close(chainFileUnit)

                Record%value = trim(adjustl(Record%value))
                delimHasEnded = .false.
                delimHasBegun = .false.
                delimiterLen = 0
                loopSearchDelimiter: do i = 1, len(Record%value)-1
                    if ( Record%isDigit(Record%value(i:i)) ) then
                        if (delimHasBegun) delimHasEnded = .true.
                    elseif (Record%value(i:i)=="." .or. Record%value(i:i)=="+" .or. Record%value(i:i)=="-") then
                        if (delimHasBegun) then
                            delimHasEnded = .true.
                        else
                            Err%occurred = .true.
                            Err%msg = PROCEDURE_NAME//": The file located at: " // chainFilePathTrimmed //NLC//&
                            "has unrecognizable format. Found "//Record%value(i:i)//" in the first column, while expecting positive integer."//NLC
                            return
                        end if
                    else
                        if (i==1) then  ! here it is assumed that the first column in chain file always contains integers
                            Err%occurred = .true.
                            Err%msg = PROCEDURE_NAME//": The file located at: "//chainFilePathTrimmed//NLC//"has unrecognizable format."//NLC
                            return
                        else
                            delimHasBegun = .true.
                            delimiterLen = delimiterLen + 1
                            CFC%delimiter(delimiterLen:delimiterLen) = Record%value(i:i)
                        end if
                    end if
                    if (delimHasEnded) exit loopSearchDelimiter
                end do loopSearchDelimiter

                if (.not.(delimHasBegun.and.delimHasEnded)) then
                    Err%occurred = .true.
                    Err%msg = PROCEDURE_NAME//": The file located at: "//chainFilePathTrimmed//NLC//"has unrecognizable format. Could not identify the column delimiter."//NLC
                    return
                else
                    CFC%delimiter = trim(adjustl(CFC%delimiter(1:delimiterLen)))
                    delimiterLen = len(CFC%delimiter)
                    if (delimiterLen==0) then
                        CFC%delimiter = " "
                        delimiterLen = 1
                    end if
                end if

            end if blockFindDelim

            ! find the number of dimensions of the state (the number of function variables)

            if (present(ndim)) then
                CFC%ndim = ndim
            else
                Record%Parts = Record%SplitStr(Record%value,CFC%delimiter,Record%nPart)
                CFC%numDefCol = 0_IK
                loopFindNumDefCol: do i = 1, Record%nPart
                    if ( index(string=Record%Parts(i)%record,substring="LogFunc") > 0 ) then
                        CFC%numDefCol = i
                        exit loopFindNumDefCol
                    end if
                end do loopFindNumDefCol
                if (CFC%numDefCol/=NUM_DEF_COL .or. CFC%numDefCol==0_IK) then
                    Err%occurred = .true.
                    Err%msg = PROCEDURE_NAME//": Internal error occurred. CFC%numDefCol/=NUM_DEF_COL: " // num2str(CFC%numDefCol) // num2str(NUM_DEF_COL)
                    return
                end if
                CFC%ndim = Record%nPart - NUM_DEF_COL
            end if

            ! reopen the file to read the contents

            open(newunit=chainFileUnit,file=chainFilePathTrimmed,status="old",form=thisForm,iostat=Err%stat)
            if (Err%stat/=0) then
                Err%occurred = .true.
                Err%msg = PROCEDURE_NAME//": Unable to open the file located at: "//chainFilePathTrimmed //"."//NLC
                return
            end if

            ! first read the column headers

            if (allocated(Record%value)) deallocate(Record%value) ! set up the record string that keeps the contents of each line
            if (isBinary) then
!write(*,*) "lenHeader: ", lenHeader
                allocate( character(lenHeader) :: Record%value )
                read(chainFileUnit) Record%value
            else
                allocate( character(99999) :: Record%value )    ! such huge allocation is rather redundant
                read(chainFileUnit, "(A)" ) Record%value
            end if
            CFC%ColHeader = Record%SplitStr(trim(adjustl(Record%value)),CFC%delimiter)
            do i = 1,size(CFC%ColHeader)
                CFC%ColHeader(i)%record = trim(adjustl(CFC%ColHeader(i)%record))
            end do

            ! read the chain

            allocate(CFC%State(CFC%ndim,CFC%Count%resized))
            CFC%Count%verbose = 0_IK
            if (isBinary) then
                do iState = 1, chainSizeDefault
                    read(chainFileUnit  ) CFC%ProcessID                (iState)    &
                                        , CFC%DelRejStage              (iState)    &
                                        , CFC%MeanAccRate              (iState)    &
                                        , CFC%Adaptation               (iState)    &
                                        , CFC%BurninLoc                (iState)    &
                                        , CFC%Weight                   (iState)    &
                                        , CFC%LogFunc                  (iState)    &
                                        , CFC%State         (1:CFC%ndim,iState)
                    CFC%Count%verbose = CFC%Count%verbose + CFC%Weight(iState)
                end do
            elseif (isCompact) then
                do iState = 1, chainSizeDefault
                    read(chainFileUnit, "(A)" ) Record%value
                    Record%Parts = Record%SplitStr(trim(adjustl(Record%value)),CFC%delimiter,Record%nPart)
                    read(Record%Parts(1)%record,*) CFC%ProcessID    (iState)
                    read(Record%Parts(2)%record,*) CFC%DelRejStage  (iState)
                    read(Record%Parts(3)%record,*) CFC%MeanAccRate  (iState)
                    read(Record%Parts(4)%record,*) CFC%Adaptation   (iState)
                    read(Record%Parts(5)%record,*) CFC%BurninLoc    (iState)
                    read(Record%Parts(6)%record,*) CFC%Weight       (iState)
                    read(Record%Parts(7)%record,*) CFC%LogFunc      (iState)
                    do i = 1, CFC%ndim
                        read(Record%Parts(7+i)%record,*) CFC%State  (i,iState)
                    end do
                    CFC%Count%verbose = CFC%Count%verbose + CFC%Weight(iState)
                end do
            else ! is verbose form
                if (chainSizeDefault>0_IK) then
                    CFC%Count%compact = 1_IK
                    block
                        logical                 :: newUniqueSampleDetected
                        integer(IK)             :: processID
                        integer(IK)             :: delRejStage
                        real(RK)                :: meanAccRate
                        real(RK)                :: adaptation
                        integer(IK)             :: burninLoc
                        integer(IK)             :: weight
                        real(RK)                :: logFunc
                        real(RK), allocatable   :: State(:)
                        allocate(State(ndim))
                        ! read the first sample
                        read(chainFileUnit, "(A)" ) Record%value
                        Record%Parts = Record%SplitStr(trim(adjustl(Record%value)),CFC%delimiter)
                        read(Record%Parts(1)%record,*) CFC%ProcessID(CFC%Count%compact)
                        read(Record%Parts(2)%record,*) CFC%DelRejStage(CFC%Count%compact)
                        read(Record%Parts(3)%record,*) CFC%MeanAccRate(CFC%Count%compact)
                        read(Record%Parts(4)%record,*) CFC%Adaptation(CFC%Count%compact)
                        read(Record%Parts(5)%record,*) CFC%BurninLoc(CFC%Count%compact)
                        read(Record%Parts(6)%record,*) CFC%Weight(CFC%Count%compact)
                        read(Record%Parts(7)%record,*) CFC%LogFunc(CFC%Count%compact)
                        do i = 1, CFC%ndim
                            read(Record%Parts(7+i)%record,*) CFC%State(i,CFC%Count%compact)
                        end do
                        ! read the rest of samples beyond the first, if any exist
                        newUniqueSampleDetected = .false.
                        do iState = 2, chainSizeDefault
                            read(chainFileUnit, "(A)" ) Record%value
                            Record%Parts = Record%SplitStr(trim(adjustl(Record%value)),CFC%delimiter)
                            read(Record%Parts(1)%record,*) ProcessID
                            read(Record%Parts(2)%record,*) DelRejStage
                            read(Record%Parts(3)%record,*) MeanAccRate
                            read(Record%Parts(4)%record,*) Adaptation
                            read(Record%Parts(5)%record,*) BurninLoc
                            read(Record%Parts(6)%record,*) Weight
                            read(Record%Parts(7)%record,*) LogFunc
                            do i = 1, CFC%ndim
                                read(Record%Parts(7+i)%record,*) State(i)
                            end do
                            newUniqueSampleDetected =    LogFunc        /= CFC%LogFunc    (CFC%Count%compact) &
                                                    .or. MeanAccRate    /= CFC%MeanAccRate(CFC%Count%compact) &
                                                    .or. Adaptation     /= CFC%Adaptation (CFC%Count%compact) &
                                                    .or. BurninLoc      /= CFC%BurninLoc  (CFC%Count%compact) &
                                                    .or. Weight         /= CFC%Weight     (CFC%Count%compact) &
                                                    .or. DelRejStage    /= CFC%DelRejStage(CFC%Count%compact) &
                                                    .or. ProcessID      /= CFC%ProcessID  (CFC%Count%compact) &
                                                    .or. any(CFC%State(1:CFC%ndim,CFC%Count%compact)    /= CFC%State(1:CFC%ndim,CFC%Count%compact))
                            if (newUniqueSampleDetected) then
                                CFC%Count%compact = CFC%Count%compact + 1_IK
                                CFC%LogFunc         (CFC%Count%compact) = LogFunc
                                CFC%MeanAccRate     (CFC%Count%compact) = MeanAccRate
                                CFC%Adaptation      (CFC%Count%compact) = Adaptation
                                CFC%BurninLoc       (CFC%Count%compact) = BurninLoc
                                CFC%Weight          (CFC%Count%compact) = Weight
                                CFC%DelRejStage     (CFC%Count%compact) = DelRejStage
                                CFC%ProcessID       (CFC%Count%compact) = ProcessID
                                CFC%State(1:CFC%ndim,CFC%Count%compact) = State(1:CFC%ndim)
                            else
                                CFC%Weight(CFC%Count%compact) = CFC%Weight(CFC%Count%compact) + 1_IK
                            end if
                        end do
                    end block
                else
                    CFC%Count%compact = 0_IK
                    CFC%Count%verbose = 0_IK
                end if
            end if

            if (isBinary .or. isCompact) then
                CFC%Count%compact = chainSizeDefault
            else
                CFC%Count%verbose = chainSizeDefault
                if (CFC%Count%verbose/=sum(CFC%Weight(1:CFC%Count%compact))) then
                    Err%occurred = .true.
                    Err%msg =   PROCEDURE_NAME//": Internal error occurred. CountVerbose/=sum(Weight): "// &
                                num2str(CFC%Count%verbose) // num2str(sum(CFC%Weight(1:CFC%Count%compact)))
                    return
                else
                    CFC%ProcessID     = CFC%ProcessID   (1:CFC%Count%compact)
                    CFC%DelRejStage   = CFC%DelRejStage (1:CFC%Count%compact)
                    CFC%MeanAccRate   = CFC%MeanAccRate (1:CFC%Count%compact)
                    CFC%Adaptation    = CFC%Adaptation  (1:CFC%Count%compact)
                    CFC%BurninLoc     = CFC%BurninLoc   (1:CFC%Count%compact)
                    CFC%Weight        = CFC%Weight      (1:CFC%Count%compact)
                    CFC%LogFunc       = CFC%LogFunc     (1:CFC%Count%compact)
                    CFC%State         = CFC%State       (1:CFC%ndim,1:CFC%Count%compact)
                end if
            end if

            close(chainFileUnit)

            ! set the rest of elements to zero
            if (CFC%Count%resized>chainSizeDefault) call CFC%nullify(startIndex=CFC%Count%compact+1_IK, endIndex=CFC%Count%resized)

        else blockFileExistence

            Err%occurred = .true.
            Err%msg = PROCEDURE_NAME//": The chain file does not exist in the given file path: "//chainFilePathTrimmed
            return

        end if blockFileExistence

    end subroutine getChainFileContents

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine nullifyChainFileContents(CFC,startIndex,endIndex)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: nullifyChainFileContents
#endif
        implicit none
        class(ChainFileContents_type), intent(inout)    :: CFC
        integer(IK), intent(in)                         :: startIndex, endIndex
        CFC%ProcessID   (startIndex:endIndex) = -huge(0_IK)
        CFC%DelRejStage (startIndex:endIndex) = -huge(0_IK)
        CFC%MeanAccRate (startIndex:endIndex) = -huge(0._RK)
        CFC%Adaptation  (startIndex:endIndex) = -huge(0._RK)
        CFC%BurninLoc   (startIndex:endIndex) = -huge(0_IK)
        CFC%Weight      (startIndex:endIndex) = 0_IK
        CFC%LogFunc     (startIndex:endIndex) = -huge(0._RK)
        CFC%State       (1:CFC%ndim,startIndex:endIndex) = -huge(0._RK)
    end subroutine nullifyChainFileContents

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine getLenHeader(CFC,ndim,isBinary,chainFileFormat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLenHeader
#endif
        use Constants_mod, only: IK
        use Err_mod, only: abort
        implicit none
        class(ChainFileContents_type), intent(inout)    :: CFC
        integer(IK) , intent(in)                        :: ndim
        logical     , intent(in)                        :: isBinary
        character(*), intent(in), optional              :: chainFileFormat
        character(*), parameter                         :: PROCEDURE_NAME = MODULE_NAME//"@getLenHeader()"
        character(:), allocatable                       :: record
        integer(IK)                                     :: i
        CFC%Err%occurred = .false.
        allocate( character(99999) :: record )
        if (isBinary) then
            write( record , "(*(g0,:,','))" ) (CFC%ColHeader(i)%record, i=1,CFC%numDefCol+ndim)
        else
            if ( present(chainFileFormat) ) then
                write(record,chainFileFormat) (CFC%ColHeader(i)%record, i=1,CFC%numDefCol+ndim)
            else
                CFC%Err%occurred = .true.
                CFC%Err%msg = PROCEDURE_NAME//"Internal error occurred. For formatted chain files, chainFileFormat must be given."
                call abort(CFC%Err)
            end if
        end if
        CFC%lenHeader = len_trim(adjustl(record))
        deallocate(record)
    end subroutine getLenHeader

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine writeHeader(CFC,ndim,chainFileUnit,isBinary,chainFileFormat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: writeHeader
#endif
        use Constants_mod, only: IK
        use Err_mod, only: abort
        implicit none
        class(ChainFileContents_type), intent(inout)    :: CFC
        integer(IK) , intent(in)                        :: ndim, chainFileUnit
        logical     , intent(in)                        :: isBinary
        character(*), intent(in), optional              :: chainFileFormat
        character(*), parameter                         :: PROCEDURE_NAME = MODULE_NAME//"@writeHeader()"
        character(:), allocatable                       :: record
        integer(IK)                                     :: i
        CFC%Err%occurred = .false.
        if (isBinary) then
            allocate( character(99999) :: record )
            write( record , "(*(g0,:,','))" ) (CFC%ColHeader(i)%record, i=1,CFC%numDefCol+ndim)
            write(chainFileUnit) trim(adjustl(record))
            deallocate(record)
        else
            if ( present(chainFileFormat) ) then
                write(chainFileUnit,chainFileFormat) (CFC%ColHeader(i)%record, i=1,CFC%numDefCol+ndim)
            else
                CFC%Err%occurred = .true.
                CFC%Err%msg = PROCEDURE_NAME//"Internal error occurred. For formatted chain files, chainFileFormat must be given."
                call abort(CFC%Err)
            end if
        end if
    end subroutine writeHeader

!***********************************************************************************************************************************
!***********************************************************************************************************************************

    subroutine writeChainFile(CFC,ndim,compactStartIndex,compactEndIndex,chainFileUnit,chainFileForm,chainFileFormat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: writeChainFile
#endif
        use Constants_mod, only: IK
        use Err_mod, only: abort
        implicit none
        class(ChainFileContents_type), intent(inout)    :: CFC
        integer(IK) , intent(in)                        :: ndim, compactStartIndex, compactEndIndex, chainFileUnit
        character(*), intent(in)                        :: chainFileForm
        character(*), intent(in), optional              :: chainFileFormat
        character(*), parameter                         :: PROCEDURE_NAME = MODULE_NAME//"@writeChainFile()"
        logical                                         :: isBinary, isCompact, isVerbose
        integer(IK)                                     :: i,j

        CFC%Err%occurred = .false.

        isBinary = .false.
        isCompact = .false.
        isVerbose = .false.
        if (chainFileForm=="binary") then
            isBinary = .true.
        elseif (chainFileForm=="compact") then
            isCompact = .true.
        elseif (chainFileForm=="verbose") then
            isVerbose = .true.
        else
            CFC%Err%occurred = .true.
            CFC%Err%msg = PROCEDURE_NAME//"Internal error occurred. Unknown chain file format: "//chainFileForm
        end if

        if ( .not. isBinary .and. .not. present(chainFileFormat) ) then
                CFC%Err%occurred = .true.
                CFC%Err%msg = PROCEDURE_NAME//"Internal error occurred. For formatted chain files, chainFileFormat must be given."
        end if
        if (CFC%Err%occurred) call abort(CFC%Err)

        call CFC%writeHeader(ndim,chainFileUnit,isBinary,chainFileFormat)

        if (compactStartIndex<=compactEndIndex) then
            if (isCompact) then
                do i = compactStartIndex, compactEndIndex
                    write(chainFileUnit,chainFileFormat     ) CFC%ProcessID(i)     &
                                                            , CFC%DelRejStage(i)   &
                                                            , CFC%MeanAccRate(i)   &
                                                            , CFC%Adaptation(i)    &
                                                            , CFC%BurninLoc(i)     &
                                                            , CFC%Weight(i)        &
                                                            , CFC%LogFunc(i)       &
                                                            , CFC%State(1:ndim,i)
                end do
            elseif (isBinary) then
                do i = compactStartIndex, compactEndIndex
                    write(chainFileUnit                     ) CFC%ProcessID(i)     &
                                                            , CFC%DelRejStage(i)   &
                                                            , CFC%MeanAccRate(i)   &
                                                            , CFC%Adaptation(i)    &
                                                            , CFC%BurninLoc(i)     &
                                                            , CFC%Weight(i)        &
                                                            , CFC%LogFunc(i)       &
                                                            , CFC%State(1:ndim,i)
                end do
            elseif (isVerbose) then
                do i = compactStartIndex, compactEndIndex
                    do j = 1, CFC%Weight(i)
                        write(chainFileUnit,chainFileFormat ) CFC%ProcessID(i)     &
                                                            , CFC%DelRejStage(i)   &
                                                            , CFC%MeanAccRate(i)   &
                                                            , CFC%Adaptation(i)    &
                                                            , CFC%BurninLoc(i)     &
                                                            , 1_IK                 &
                                                            , CFC%LogFunc(i)       &
                                                            , CFC%State(1:ndim,i)
                    end do
                end do
            end if
        end if
        flush(chainFileUnit)
    end subroutine writeChainFile

!***********************************************************************************************************************************
!***********************************************************************************************************************************

end module ParaDRAMChainFileContents_mod