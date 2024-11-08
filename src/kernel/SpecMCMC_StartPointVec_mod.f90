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

module SpecMCMC_StartPointVec_mod

    use Constants_mod, only: RK
    implicit none

    character(*), parameter         :: MODULE_NAME = "@SpecMCMC_StartPointVec_mod"

    real(RK), allocatable           :: startPointVec(:) ! namelist input

    type                            :: StartPointVec_type
        real(RK), allocatable       :: Val(:)
        real(RK)                    :: null
        character(:), allocatable   :: desc
    contains
        procedure, pass             :: set, checkForSanity, nullifyNameListVar
    end type StartPointVec_type

    interface StartPointVec_type
        module procedure            :: construct
    end interface StartPointVec_type

    private :: construct, set, checkForSanity, nullifyNameListVar

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contains

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function construct() result(self)
#if INTEL_COMPILER_ENABLED && defined DLL_ENABLED && (OS_IS_WINDOWS || defined OS_IS_DARWIN)
        !DEC$ ATTRIBUTES DLLEXPORT :: construct
#endif
        use Constants_mod, only: NULL_RK
        use String_mod, only: num2str
        implicit none
        type(StartPointVec_type) :: self
        self%null   = NULL_RK
        self%desc   = &
        "startPointVec is a 64bit real-valued vector of length ndim (the dimension of the domain of the input objective function). &
        &For every element of startPointVec that is not provided as input, the default value will be the center of the domain of &
        &startPointVec as specified by domainLowerLimitVec and domainUpperLimitVec input variables. &
        &If the input variable randomStartPointRequested=TRUE (or true or t, all case-insensitive), then the missing &
        &elements of startPointVec will be initialized to values drawn randomly from within the corresponding &
        &ranges specified by the input variables randomStartPointDomainLowerLimitVec and randomStartPointDomainUpperLimitVec."
    end function construct

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    subroutine nullifyNameListVar(self,nd)
#if INTEL_COMPILER_ENABLED && defined DLL_ENABLED && (OS_IS_WINDOWS || defined OS_IS_DARWIN)
        !DEC$ ATTRIBUTES DLLEXPORT :: nullifyNameListVar
#endif
        use Constants_mod, only: IK
        implicit none
        class(StartPointVec_type), intent(in)   :: self
        integer(IK), intent(in)                 :: nd
        if (allocated(startPointVec)) deallocate(startPointVec)
        allocate(startPointVec(nd), source = self%null)
    end subroutine nullifyNameListVar

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pure subroutine set(self, startPointVec)
#if INTEL_COMPILER_ENABLED && defined DLL_ENABLED && (OS_IS_WINDOWS || defined OS_IS_DARWIN)
        !DEC$ ATTRIBUTES DLLEXPORT :: set
#endif
        use Constants_mod, only: IK, RK
        implicit none
        class(StartPointVec_type), intent(inout)    :: self
        real(RK), intent(in), optional              :: startPointVec(:)
        if (present(startPointVec)) self%Val = startPointVec
    end subroutine set

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    subroutine checkForSanity(self, Err, methodName, SpecBase, randomStartPointRequested, randomStartPointDomainLowerLimitVec, randomStartPointDomainUpperLimitVec)
#if INTEL_COMPILER_ENABLED && defined DLL_ENABLED && (OS_IS_WINDOWS || defined OS_IS_DARWIN)
        !DEC$ ATTRIBUTES DLLEXPORT :: checkForSanity
#endif
        use SpecBase_mod, only: SpecBase_type
        use Constants_mod, only: IK, RK
        use String_mod, only: num2str
        use Err_mod, only: Err_type
        implicit none
        class(StartPointVec_type), intent(inout)    :: self
        type(Err_type), intent(inout)               :: Err
        type(SpecBase_type), intent(in)             :: SpecBase
        character(*), intent(in)                    :: methodName
        logical, intent(in)                         :: randomStartPointRequested
        real(RK), intent(in)                        :: randomStartPointDomainLowerLimitVec(:)
        real(RK), intent(in)                        :: randomStartPointDomainUpperLimitVec(:)
        character(*), parameter                     :: PROCEDURE_NAME = "@checkForSanity()"
        real(RK)                                    :: unifrnd
        integer(IK)                                 :: i
        do i = 1, size(self%Val)
            if (self%Val(i)==self%null) then
                if (randomStartPointRequested) then
                    call random_number(unifrnd)
                    self%Val(i) = randomStartPointDomainLowerLimitVec(i) + unifrnd * (randomStartPointDomainUpperLimitVec(i)-randomStartPointDomainLowerLimitVec(i))
                else
                    self%Val(i) = 0.5_RK * ( SpecBase%DomainLowerLimitVec%Val(i) + SpecBase%DomainUpperLimitVec%Val(i) )
                end if
            elseif ( self%Val(i)<SpecBase%DomainLowerLimitVec%Val(i) .or. self%Val(i)>SpecBase%DomainUpperLimitVec%Val(i) ) then
                Err%occurred = .true.
                Err%msg =   Err%msg // &
                            MODULE_NAME // PROCEDURE_NAME // ": Error occurred. &
                            &The input requested value for the component " // num2str(i) // " of the vector startPointVec (" // &
                            num2str(self%Val(i)) // ") must be within the range of the sampling Domain defined &
                            &in the program: (" // &
                            num2str(SpecBase%DomainLowerLimitVec%Val(i)) // "," // & ! LCOV_EXCL_LINE
                            num2str(SpecBase%DomainUpperLimitVec%Val(i)) // & ! LCOV_EXCL_LINE
                            "). If you don't know an appropriate value for startPointVec, drop it from the input list. " // &
                            methodName // " will automatically assign an appropriate value to it.\n\n"
            end if
        end do
        deallocate(startPointVec)
    end subroutine checkForSanity

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end module SpecMCMC_StartPointVec_mod ! LCOV_EXCL_LINE