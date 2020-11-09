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
!!!!       https://github.com/cdslaborg/paramonte/blob/master/ACKNOWLEDGMENT.md
!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!> \brief This module contains the classes and procedures for various statistical computations.
!> \author Amir Shahmoradi

module Statistics_mod

    use Constants_mod, only: RK, IK

    implicit none

!logical, save :: paradramPrintEnabled = .false.
!logical, save :: paradisePrintEnabled = .false.

    character(len=*), parameter :: MODULE_NAME = "@Statistics_mod"

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getMean
        module procedure :: getMean_2D
    end interface getMean

    interface getNormData
        module procedure :: getNormData_2D
    end interface getNormData

    interface getVariance
        module procedure :: getVariance_1D, getVariance_2D
    end interface getVariance

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getLogProbLogNorm
        module procedure :: getLogProbLogNormS, GetLogProbLogNormMP
    end interface getLogProbLogNorm

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface GetLogProbNormSP
        module procedure :: getLogProbNormSP_RK, getLogProbNormSP_CK
    end interface GetLogProbNormSP

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface GetLogProbNormMP
        module procedure :: GetLogProbNormMP_RK, GetLogProbNormMP_CK
    end interface GetLogProbNormMP

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getProbMVNSP
        module procedure :: getProbMVNSP_RK, getProbMVNSP_CK
    end interface getProbMVNSP

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getProbMVNV
        module procedure :: getProbMVNMP_RK, getProbMVNMP_CK
    end interface getProbMVNV

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getLogProbMVNSP
        module procedure :: getLogProbMVNSP_RK, getLogProbMVNSP_CK
    end interface getLogProbMVNSP

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getLogProbMVNMP
        module procedure :: getLogProbMVNMP_RK, getLogProbMVNMP_CK
    end interface getLogProbMVNMP

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getLogProbNorm
        module procedure :: getLogProbNormSP_RK, GetLogProbNormMP_RK
        module procedure :: getLogProbNormSP_CK, GetLogProbNormMP_CK
    end interface getLogProbNorm

    interface getProbMVN
        module procedure :: getProbMVNSP_RK, getProbMVNMP_RK
        module procedure :: getProbMVNSP_CK, getProbMVNMP_CK
    end interface getProbMVN

    interface getLogProbMVN
        module procedure :: getLogProbMVNSP_RK, getLogProbMVNMP_RK
        module procedure :: getLogProbMVNSP_CK, getLogProbMVNMP_CK
    end interface getLogProbMVN

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getLogProbGausMixSDSP
        module procedure :: getLogProbGausMixSDSP_RK, getLogProbGausMixSDSP_CK
    end interface getLogProbGausMixSDSP

    interface getLogProbGausMixSDMP
        module procedure :: getLogProbGausMixSDMP_RK, getLogProbGausMixSDMP_CK
    end interface getLogProbGausMixSDMP

    interface getLogProbGausMixMDSP
        module procedure :: getLogProbGausMixMDSP_RK, getLogProbGausMixMDSP_CK
    end interface getLogProbGausMixMDSP

    interface getLogProbGausMixMDMP
        module procedure :: getLogProbGausMixMDMP_RK, getLogProbGausMixMDMP_CK
    end interface getLogProbGausMixMDMP

    interface getLogProbGausMix_RK
        module procedure :: getLogProbGausMixSDSP_RK, getLogProbGausMixSDMP_RK, getLogProbGausMixMDSP_RK, getLogProbGausMixMDMP_RK
    end interface getLogProbGausMix_RK

    interface getLogProbGausMix
        module procedure :: getLogProbGausMixSDSP_RK, getLogProbGausMixSDMP_RK, getLogProbGausMixMDSP_RK, getLogProbGausMixMDMP_RK
        module procedure :: getLogProbGausMixSDSP_CK, getLogProbGausMixSDMP_CK, getLogProbGausMixMDSP_CK, getLogProbGausMixMDMP_CK
    end interface getLogProbGausMix

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getMahalSqSP
        module procedure :: getMahalSqSP_RK, getMahalSqSP_CK
    end interface getMahalSqSP

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getMahalSqMP
        module procedure :: getMahalSqMP_RK, getMahalSqMP_CK
    end interface getMahalSqMP

    !%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    interface getMahalSq
        module procedure :: getMahalSqSP_RK, getMahalSqMP_RK
        module procedure :: getMahalSqSP_CK, getMahalSqMP_CK
    end interface getMahalSq

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contains

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    !> \brief
    !> Return the square of Mahalanobis distance for a single point. The output is a scalar variable.
    !>
    !> \param[in]   nd          :   The number of dimensions of the input `Point`.
    !> \param[in]   MeanVec     :   The mean vector of the sample.
    !> \param[in]   InvCovMat   :   The inverse covariance matrix of the sample.
    !> \param[in]   Point       :   The `Point` whose distance from the sample is to computed.
    !>
    !> \return
    !> `mahalSq` : The Mahalanobis distance squared of the point from
    !> the sample characterized by the input `MeanVec` and `InvCovMat`.
    pure function getMahalSqSP_RK(nd,MeanVec,InvCovMat,Point) result(mahalSq)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getMahalSqSP_RK
#endif
        use Constants_mod, only: IK, RK
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: InvCovMat(nd,nd)        ! Inverse of the covariance matrix
        real(RK)   , intent(in) :: Point(nd)               ! input data points
        real(RK)                :: mahalSq
        real(RK)                :: NormedPoint(nd)
        NormedPoint = Point - MeanVec
        mahalSq = dot_product( NormedPoint , matmul(InvCovMat,NormedPoint) )
    end function getMahalSqSP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the square of Mahalanobis distances for an row-wise array of points.
    !>
    !> \param[in]   nd          :   The number of dimensions of the input `Point` array.
    !> \param[in]   np          :   The number of points in the input input `Point` array.
    !> \param[in]   MeanVec     :   The mean vector of length `nd` of the sample.
    !> \param[in]   InvCovMat   :   The inverse covariance matrix `(nd,nd)` of the sample.
    !> \param[in]   Point       :   The `(nd,np)` array of points whose distances squared from the sample are to computed.
    !>
    !> \return
    !> `MahalSq` : A vector of length `np` containing the squares of the Mahalanobis distances
    !> of the input points from the sample characterized by the input `MeanVec` and `InvCovMat`.
    !>
    !> \warning
    !> For the sake of preserving the purity and computational efficiency of the function,
    !> if the computation fails at any stage, the first element of output will be returned negative.
    pure function getMahalSqMP_RK(nd,np,MeanVec,InvCovMat,Point) result(MahalSq)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getMahalSqMP_RK
#endif
        use Constants_mod, only: IK, RK
        implicit none
        integer(IK), intent(in) :: nd,np
        real(RK), intent(in)    :: MeanVec(nd)
        real(RK), intent(in)    :: InvCovMat(nd,nd) ! Inverse of the covariance matrix
        real(RK), intent(in)    :: Point(nd,np)     ! input data points
        real(RK)                :: MahalSq(np)      ! function return
        real(RK)                :: NormedPoint(nd)
        integer(IK)             :: ip
        do ip = 1,np
            NormedPoint = Point(1:nd,ip) - MeanVec
            MahalSq(ip) = dot_product( NormedPoint , matmul(InvCovMat,NormedPoint) )
            if (MahalSq(ip)<0._RK) then
                MahalSq(1) = -1._RK
                return
            end if
        end do
    end function getMahalSqMP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the square of Mahalanobis distance for a single complex point. The output is a scalar variable.
    !>
    !> \param[in]   nd              :   The number of dimensions of the input `Point`.
    !> \param[in]   MeanVec_CK      :   The mean vector of the sample.
    !> \param[in]   InvCovMat_CK    :   The inverse covariance matrix of the sample.
    !> \param[in]   Point_CK        :   The `Point` whose distance from the sample is to computed.
    !>
    !> \return
    !> `mahalSq` : The Mahalanobis distance squared of the point from
    !> the sample characterized by the input `MeanVec` and `InvCovMat`.
    pure function getMahalSqSP_CK(nd,MeanVec_CK,InvCovMat_CK,Point_CK) result(mahalSq)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getMahalSqSP_CK
#endif
        use Constants_mod, only: IK, RK, CK
        implicit none
        integer(IK), intent(in)  :: nd
        complex(CK), intent(in)  :: MeanVec_CK(nd)
        complex(CK), intent(in)  :: InvCovMat_CK(nd,nd) ! Inverse of the covariance matrix
        complex(CK), intent(in)  :: Point_CK(nd)        ! input data points
        complex(CK)              :: mahalSq             ! function return
        mahalSq = sum( (Point_CK-MeanVec_CK) * matmul(InvCovMat_CK,Point_CK-MeanVec_CK) )
    end function getMahalSqSP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the square of Mahalanobis distances for an row-wise array of complex-valued points.
    !>
    !> \param[in]   nd              :   The number of dimensions of the input `Point` array.
    !> \param[in]   np              :   The number of points in the input input `Point` array.
    !> \param[in]   MeanVec_CK      :   The mean vector of length `nd` of the sample.
    !> \param[in]   InvCovMat_CK    :   The inverse covariance matrix `(nd,nd)` of the sample.
    !> \param[in]   Point_CK        :   The `(nd,np)` array of points whose distances squared from the sample are to computed.
    !>
    !> \return
    !> `MahalSq` : A vector of length `np` containing the squares of the Mahalanobis distances
    !> of the input points from the sample characterized by the input `MeanVec` and `InvCovMat`.
    !>
    !> \warning
    !> For the sake of preserving the purity and computational efficiency of the function,
    !> if the computation fails at any stage, the first element of output will be returned negative.
    pure function getMahalSqMP_CK(nd,np,MeanVec_CK,InvCovMat_CK,Point_CK) result(MahalSq)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getMahalSqMP_CK
#endif
        use Constants_mod, only: IK, RK, CK
        implicit none
        integer(IK), intent(in)  :: nd,np
        complex(CK), intent(in)  :: MeanVec_CK(nd)
        complex(CK), intent(in)  :: InvCovMat_CK(nd,nd) ! Inverse of the covariance matrix
        complex(CK), intent(in)  :: Point_CK(nd,np)     ! input data points
        complex(CK)              :: MahalSq(np)         ! function return
        integer(IK)              :: ip
        do ip = 1,np
            MahalSq(ip) = sum( (Point_CK(1:nd,ip)-MeanVec_CK) * &
            matmul(InvCovMat_CK,Point_CK(1:nd,ip)-MeanVec_CK) )
            if (real(MahalSq(ip))<0._RK) then
                MahalSq(1) = (-1._RK, -1._RK)
                return
            end if
        end do
    end function getMahalSqMP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pure function getLogProbNormSP_RK(mean,inverseVariance,logSqrtInverseVariance,point) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbNormSP_RK
#endif
        use Constants_mod, only: RK, LOGINVSQRT2PI
        implicit none
        real(RK), intent(in) :: mean,inverseVariance,logSqrtInverseVariance,point
        real(RK)             :: logProbNorm
        logProbNorm = LOGINVSQRT2PI + logSqrtInverseVariance - 0.5_RK * inverseVariance * (point-mean)**2
    end function getLogProbNormSP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pure function GetLogProbNormMP_RK(np,mean,inverseVariance,logSqrtInverseVariance,Point) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: GetLogProbNormMP_RK
#endif
        use Constants_mod, only: LOGINVSQRT2PI
        implicit none
        integer(IK), intent(in) :: np
        real(RK)   , intent(in) :: mean,inverseVariance,logSqrtInverseVariance,Point(np)
        real(RK)                :: logProbNorm(np)
        logProbNorm = LOGINVSQRT2PI + logSqrtInverseVariance - 0.5_RK * inverseVariance * (Point-mean)**2
    end function GetLogProbNormMP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! NOTE: if MahalSq computation fails, output probability will be returned as NullVal%RK from module Constant_mod.
    pure function getProbMVNSP_RK(nd,MeanVec,InvCovMat,sqrtDetInvCovMat,Point) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getProbMVNSP_RK
#endif
        use Constants_mod, only: INVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: InvCovMat(nd,nd)
        real(RK)   , intent(in) :: sqrtDetInvCovMat
        real(RK)   , intent(in) :: Point(nd)
        real(RK)                :: logProbNorm, dummy
        dummy = getMahalSqSP_RK(nd,MeanVec,InvCovMat,Point)
        if (dummy<0._RK) then
            logProbNorm = NullVal%RK
        else
            logProbNorm = INVSQRT2PI**nd * sqrtDetInvCovMat * exp( -0.5_RK * dummy )
        end if
    end function getProbMVNSP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! NOTE: if MahalSq computation fails, output probability will be returned as NullVal%RK from module Constant_mod.
    pure function getProbMVNMP_RK(nd,np,MeanVec,InvCovMat,sqrtDetInvCovMat,Point) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getProbMVNMP_RK
#endif
        use Constants_mod, only: INVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd,np
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: InvCovMat(nd,nd)
        real(RK)   , intent(in) :: sqrtDetInvCovMat
        real(RK)   , intent(in) :: Point(nd,np)
        real(RK)                :: logProbNorm(np), Dummy(np)
        Dummy = getMahalSqMP_RK(nd,np,MeanVec,InvCovMat,Point)
        if (Dummy(1)<0._RK) then
            logProbNorm = NullVal%RK
        else
            logProbNorm = INVSQRT2PI**nd * sqrtDetInvCovMat * exp( -0.5_RK * Dummy )
        end if
    end function getProbMVNMP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! NOTE: if MahalSq computation fails, output probability will be returned as NullVal%RK from module Constant_mod.
    pure function getLogProbMVNSP_RK(nd,MeanVec,InvCovMat,logSqrtDetInvCovMat,Point) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbMVNSP_RK
#endif
        use Constants_mod, only: LOGINVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: InvCovMat(nd,nd)
        real(RK)   , intent(in) :: logSqrtDetInvCovMat
        real(RK)   , intent(in) :: Point(nd)
        real(RK)                :: logProbNorm, dummy
        dummy = getMahalSqSP_RK(nd,MeanVec,InvCovMat,Point)
        if (dummy<0._RK) then
            logProbNorm = NullVal%RK
        else
            logProbNorm = nd*LOGINVSQRT2PI + logSqrtDetInvCovMat - 0.5_RK * dummy
        end if
    end function getLogProbMVNSP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! NOTE: if MahalSq computation fails, output probability will be returned as NullVal%RK from module Constant_mod.
    pure function getLogProbMVNMP_RK(nd,np,MeanVec,InvCovMat,logSqrtDetInvCovMat,Point) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbMVNMP_RK
#endif
        use Constants_mod, only: LOGINVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd,np
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: InvCovMat(nd,nd)
        real(RK)   , intent(in) :: logSqrtDetInvCovMat
        real(RK)   , intent(in) :: Point(nd,np)
        real(RK)                :: logProbNorm(np), Dummy(np)
        Dummy = getMahalSqMP_RK(nd,np,MeanVec,InvCovMat,Point)
        if (Dummy(1)<0._RK) then
            logProbNorm = NullVal%RK
        else
            logProbNorm = nd*LOGINVSQRT2PI + logSqrtDetInvCovMat - 0.5_RK * Dummy
        end if
    end function getLogProbMVNMP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getLogProbNormSP_CK(mean_CK,inverseVariance_CK,logSqrtInverseVariance_CK,point_CK) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbNormSP_CK
#endif
        use Constants_mod, only: RK, CK, LOGINVSQRT2PI
        implicit none
        complex(CK), intent(in) :: mean_CK,inverseVariance_CK,logSqrtInverseVariance_CK,point_CK
        complex(CK)             :: logProbNorm
        logProbNorm = LOGINVSQRT2PI + logSqrtInverseVariance_CK - 0.5_RK * inverseVariance_CK * (point_CK-mean_CK)**2
    end function getLogProbNormSP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function GetLogProbNormMP_CK(np,mean_CK,inverseVariance_CK,logSqrtInverseVariance_CK,Point_CK) result(logProbNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: GetLogProbNormMP_CK
#endif
        use Constants_mod, only: IK, RK, CK, LOGINVSQRT2PI
        implicit none
        integer(IK), intent(in) :: np
        complex(CK)   , intent(in) :: mean_CK,inverseVariance_CK,logSqrtInverseVariance_CK,Point_CK(np)
        complex(CK)                :: logProbNorm(np)
        logProbNorm = LOGINVSQRT2PI + logSqrtInverseVariance_CK - 0.5_RK * inverseVariance_CK * (Point_CK-mean_CK)**2
    end function GetLogProbNormMP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getProbMVNSP_CK(nd,MeanVec_CK,InvCovMat_CK,sqrtDetInvCovMat_CK,Point_CK) result(probMVN)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getProbMVNSP_CK
#endif
        use Constants_mod, only: IK, RK, CK, INVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd
        complex(CK)   , intent(in) :: MeanVec_CK(nd)
        complex(CK)   , intent(in) :: InvCovMat_CK(nd,nd)
        complex(CK)   , intent(in) :: sqrtDetInvCovMat_CK
        complex(CK)   , intent(in) :: Point_CK(nd)
        complex(CK)                :: probMVN, dummy
        dummy = getMahalSqSP_CK(nd,MeanVec_CK,InvCovMat_CK,Point_CK)
        if (real(dummy)<0._RK) then
            probMVN = NullVal%RK
        else
            probMVN = INVSQRT2PI**nd * sqrtDetInvCovMat_CK * exp( -0.5_RK * dummy )
        end if
    end function getProbMVNSP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getProbMVNMP_CK(nd,np,MeanVec_CK,InvCovMat_CK,sqrtDetInvCovMat_CK,Point_CK) result(probMVN)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getProbMVNMP_CK
#endif
        use Constants_mod, only: IK, RK, CK, INVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd,np
        complex(CK), intent(in) :: MeanVec_CK(nd)
        complex(CK), intent(in) :: InvCovMat_CK(nd,nd)
        complex(CK), intent(in) :: sqrtDetInvCovMat_CK
        complex(CK), intent(in) :: Point_CK(nd,np)
        complex(CK)             :: probMVN(np), Dummy(np)
        Dummy = getMahalSqMP_CK(nd,np,MeanVec_CK,InvCovMat_CK,Point_CK)
        if (real(Dummy(1))<0._RK) then
            probMVN = NullVal%RK
        else
            probMVN = INVSQRT2PI**nd * sqrtDetInvCovMat_CK * exp( -0.5_RK * Dummy )
        end if
    end function getProbMVNMP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getLogProbMVNSP_CK(nd,MeanVec_CK,InvCovMat_CK,logSqrtDetInvCovMat_CK,Point_CK) result(logProbMVN)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbMVNSP_CK
#endif
        use Constants_mod, only: IK, RK, CK, LOGINVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd
        complex(CK), intent(in) :: MeanVec_CK(nd)
        complex(CK), intent(in) :: InvCovMat_CK(nd,nd)
        complex(CK), intent(in) :: logSqrtDetInvCovMat_CK
        complex(CK), intent(in) :: Point_CK(nd)
        complex(CK)             :: logProbMVN, dummy
        dummy = getMahalSqSP_CK(nd,MeanVec_CK,InvCovMat_CK,Point_CK)
        if (real(dummy)<0._RK) then
            logProbMVN = NullVal%RK
        else
            logProbMVN  = nd*LOGINVSQRT2PI + logSqrtDetInvCovMat_CK - 0.5_RK * dummy
        end if
    end function getLogProbMVNSP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getLogProbMVNMP_CK(nd,np,MeanVec_CK,InvCovMat_CK,logSqrtDetInvCovMat_CK,Point_CK) result(logProbMVN)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbMVNMP_CK
#endif
        use Constants_mod, only: IK, RK, CK, LOGINVSQRT2PI, NullVal
        implicit none
        integer(IK), intent(in) :: nd,np
        complex(CK), intent(in) :: MeanVec_CK(nd)
        complex(CK), intent(in) :: InvCovMat_CK(nd,nd)
        complex(CK), intent(in) :: logSqrtDetInvCovMat_CK
        complex(CK), intent(in) :: Point_CK(nd,np)
        complex(CK)             :: logProbMVN(np), Dummy(np)
        Dummy = getMahalSqMP_CK(nd,np,MeanVec_CK,InvCovMat_CK,Point_CK)
        if (real(Dummy(1))<0._RK) then
            logProbMVN = NullVal%RK
        else
            logProbMVN  = nd*LOGINVSQRT2PI + logSqrtDetInvCovMat_CK - 0.5_RK * Dummy
        end if
    end function getLogProbMVNMP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! SDSP stands for Single-Dimensional Gaussian mixture with Single Point input
    function getLogProbGausMixSDSP_RK(nmode,nd,np,LogAmplitude,MeanVec,InvCovMat,LogSqrtDetInvCovMat,point) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixSDSP_RK
#endif
        use Constants_mod, only: IK, RK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        real(RK)   , intent(in) :: LogAmplitude(nmode),MeanVec(nmode)
        real(RK)   , intent(in) :: InvCovMat(nmode),LogSqrtDetInvCovMat(nmode)
        real(RK)   , intent(in) :: point
        real(RK)                :: logProbGausMix
        real(RK)                :: normFac,LogProb(nmode)
        integer(IK)             :: imode
        do imode = 1, nmode
            LogProb(imode)  = LogAmplitude(imode) + getLogProbNormSP_RK(MeanVec(imode),InvCovMat(imode),LogSqrtDetInvCovMat(imode),point)
        end do
        normFac = maxval(LogProb)
        LogProb = LogProb - normFac
        where(LogProb<LOGTINY_RK)
            LogProb = 0._RK
        elsewhere
            LogProb = exp(LogProb)
        end where
        logProbGausMix = normFac + log(sum(LogProb))
    end function getLogProbGausMixSDSP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function getLogProbGausMixSDMP_RK(nmode,nd,np,LogAmplitude,MeanVec,InvCovMat,LogSqrtDetInvCovMat,Point) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixSDMP_RK
#endif
        use Constants_mod, only: IK, RK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        real(RK)   , intent(in) :: LogAmplitude(nmode),MeanVec(nmode)
        real(RK)   , intent(in) :: InvCovMat(nmode),LogSqrtDetInvCovMat(nmode)
        real(RK)   , intent(in) :: Point(np)
        real(RK)                :: logProbGausMix(np)
        real(RK)                :: NormFac(np),LogProb(nmode,np)
        integer(IK)             :: imode, ip
        do imode = 1, nmode
            LogProb(imode,1:np) = LogAmplitude(imode) + getLogProbNormMP_RK(np,MeanVec(imode),InvCovMat(imode),LogSqrtDetInvCovMat(imode),Point)
        end do
        NormFac = maxval(LogProb,dim=1)
        do ip = 1,np
            LogProb(1:nmode,ip) = LogProb(1:nmode,ip) - NormFac(ip)
            do imode = 1,nmode
                if ( LogProb(imode,ip) < LOGTINY_RK ) then
                    LogProb(imode,ip) = 0._RK
                else
                    LogProb(imode,ip) = exp( LogProb(imode,ip) )
                end if
            end do
            logProbGausMix(ip) = NormFac(ip) + log(sum(LogProb(1:nmode,ip)))
        end do
    end function getLogProbGausMixSDMP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getLogProbGausMixMDSP_RK(nmode,nd,np,LogAmplitude,MeanVec,InvCovMat,LogSqrtDetInvCovMat,Point) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixMDSP_RK
#endif
        use Constants_mod, only: IK, RK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        real(RK)   , intent(in) :: LogAmplitude(nmode), MeanVec(nd,nmode)
        real(RK)   , intent(in) :: InvCovMat(nd,nd,nmode), LogSqrtDetInvCovMat(nmode)
        real(RK)   , intent(in) :: Point(nd)
        real(RK)                :: logProbGausMix
        real(RK)                :: normFac,LogProb(nmode)
        integer(IK)             :: imode
        do imode = 1, nmode
            LogProb(imode) = LogAmplitude(imode) + getLogProbMVNSP_RK(nd,MeanVec(1:nd,imode),InvCovMat(1:nd,1:nd,imode),LogSqrtDetInvCovMat(imode),Point)
        end do
        normFac = maxval(LogProb)
        LogProb = LogProb - normFac
        where(LogProb<LOGTINY_RK)
            LogProb = 0._RK
        elsewhere
            LogProb = exp(LogProb)
        end where
        logProbGausMix = normFac + log(sum(LogProb))
    end function getLogProbGausMixMDSP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function getLogProbGausMixMDMP_RK(nmode,nd,np,LogAmplitude,MeanVec,InvCovMat,LogSqrtDetInvCovMat,Point) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixMDMP_RK
#endif
        use Constants_mod, only: IK, RK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        real(RK)   , intent(in) :: LogAmplitude(nmode),MeanVec(nd,nmode)
        real(RK)   , intent(in) :: InvCovMat(nd,nd,nmode), LogSqrtDetInvCovMat(nmode)
        real(RK)   , intent(in) :: Point(nd,np)
        real(RK)                :: logProbGausMix(np)
        real(RK)                :: NormFac(np),LogProb(nmode,np)
        integer(IK)             :: imode, ip
        do imode = 1, nmode
            LogProb(imode,1:np) = LogAmplitude(imode) + &
            getLogProbMVNMP_RK(nd,np,MeanVec(1:nd,imode),InvCovMat(1:nd,1:nd,imode),LogSqrtDetInvCovMat(imode),Point)
        end do
        NormFac = maxval(LogProb,dim=1)
        do ip = 1,np
            LogProb(1:nmode,ip) = LogProb(1:nmode,ip) - NormFac(ip)
            do imode = 1,nmode
                if ( LogProb(imode,ip)<LOGTINY_RK ) then
                    LogProb(imode,ip) = 0._RK
                else
                    LogProb(imode,ip) = exp( LogProb(imode,ip) )
                end if
            end do
        logProbGausMix(ip) = NormFac(ip) + log(sum(LogProb(1:nmode,ip)))
        end do
    end function getLogProbGausMixMDMP_RK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! SDSP stands for 1-dimensional Gaussian mixture with scalar input point
    function getLogProbGausMixSDSP_CK(nmode,nd,np,LogAmplitude_CK,MeanVec_CK,InvCovMat_CK,LogSqrtDetInvCovMat_CK,point_CK) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixSDSP_CK
#endif
        use Constants_mod, only: IK, RK, CK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        complex(CK), intent(in) :: LogAmplitude_CK(nmode),MeanVec_CK(nmode)
        complex(CK), intent(in) :: InvCovMat_CK(nmode),LogSqrtDetInvCovMat_CK(nmode)
        complex(CK), intent(in) :: point_CK
        complex(CK)             :: logProbGausMix
        complex(CK)             :: normFac_CK,LogProb_CK(nmode)
        integer(IK)             :: imode
        do imode = 1, nmode
            LogProb_CK(imode) = LogAmplitude_CK(imode) + &
            getLogProbNormSP_CK(MeanVec_CK(imode),InvCovMat_CK(imode),LogSqrtDetInvCovMat_CK(imode),point_CK)
        end do
        normFac_CK = maxval(real(LogProb_CK))
        LogProb_CK = LogProb_CK - normFac_CK
        where(real(LogProb_CK)<LOGTINY_RK)
            LogProb_CK = 0._RK
        elsewhere
            LogProb_CK = exp(LogProb_CK)
        end where
        logProbGausMix = normFac_CK + log(sum(LogProb_CK))
    end function getLogProbGausMixSDSP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getLogProbGausMixSDMP_CK(nmode,nd,np,LogAmplitude_CK,MeanVec_CK,InvCovMat_CK,LogSqrtDetInvCovMat_CK,Point_CK) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixSDMP_CK
#endif
        use Constants_mod, only: IK, RK, CK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        complex(CK), intent(in) :: LogAmplitude_CK(nmode),MeanVec_CK(nmode)
        complex(CK), intent(in) :: InvCovMat_CK(nmode),LogSqrtDetInvCovMat_CK(nmode)
        complex(CK), intent(in) :: Point_CK(np)
        complex(CK)             :: logProbGausMix(np)
        complex(CK)             :: normFac_CK(np),LogProb_CK(nmode,np)
        integer(IK)             :: imode, ip
        do imode = 1, nmode
            LogProb_CK(imode,1:np) = LogAmplitude_CK(imode) + &
            getLogProbNormMP_CK(np,MeanVec_CK(imode),InvCovMat_CK(imode),LogSqrtDetInvCovMat_CK(imode),Point_CK)
        end do
        normFac_CK = maxval(real(LogProb_CK),dim=1)
        do ip = 1,np
            LogProb_CK(1:nmode,ip) = LogProb_CK(1:nmode,ip) - normFac_CK(ip)
            do imode = 1,nmode
                if ( real(LogProb_CK(imode,ip)) < LOGTINY_RK ) then
                    LogProb_CK(imode,ip) = 0._RK
                else
                    LogProb_CK(imode,ip) = exp( LogProb_CK(imode,ip) )
                end if
            end do
            logProbGausMix(ip) = normFac_CK(ip) + log(sum(LogProb_CK(1:nmode,ip)))
        end do
    end function getLogProbGausMixSDMP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function getLogProbGausMixMDSP_CK(nmode,nd,np,LogAmplitude_CK,MeanVec_CK,InvCovMat_CK,LogSqrtDetInvCovMat_CK,Point_CK) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixMDSP_CK
#endif
        use Constants_mod, only: IK, RK, CK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        complex(CK), intent(in) :: LogAmplitude_CK(nmode), MeanVec_CK(nd,nmode)
        complex(CK), intent(in) :: InvCovMat_CK(nd,nd,nmode), LogSqrtDetInvCovMat_CK(nmode)
        complex(CK), intent(in) :: Point_CK(nd)
        complex(CK)             :: logProbGausMix
        complex(CK)             :: normFac_CK,LogProb_CK(nmode)
        integer(IK)             :: imode
        do imode = 1, nmode
            LogProb_CK(imode) = LogAmplitude_CK(imode) + &
            getLogProbMVNSP_CK(nd,MeanVec_CK(1:nd,imode),InvCovMat_CK(1:nd,1:nd,imode)&
                                ,LogSqrtDetInvCovMat_CK(imode),Point_CK)
        end do
        normFac_CK = maxval(real(LogProb_CK))
        LogProb_CK = LogProb_CK - normFac_CK
        where(real(LogProb_CK)<LOGTINY_RK)
            LogProb_CK = 0._RK
        elsewhere
            LogProb_CK = exp(LogProb_CK)
        end where
        logProbGausMix = normFac_CK + log(sum(LogProb_CK))
    end function getLogProbGausMixMDSP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function getLogProbGausMixMDMP_CK(nmode,nd,np,LogAmplitude_CK,MeanVec_CK,InvCovMat_CK,LogSqrtDetInvCovMat_CK,Point_CK) result(logProbGausMix)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGausMixMDMP_CK
#endif
        use Constants_mod, only: IK, RK, CK, LOGTINY_RK
        implicit none
        integer(IK), intent(in) :: nmode,nd,np
        complex(CK), intent(in) :: LogAmplitude_CK(nmode),MeanVec_CK(nd,nmode)
        complex(CK), intent(in) :: InvCovMat_CK(nd,nd,nmode), LogSqrtDetInvCovMat_CK(nmode)
        complex(CK), intent(in) :: Point_CK(nd,np)
        complex(CK)             :: logProbGausMix(np)
        complex(CK)             :: normFac_CK(np),LogProb_CK(nmode,np)
        integer(IK)             :: imode, ip
        do imode = 1, nmode
            LogProb_CK(imode,1:np) = LogAmplitude_CK(imode) + &
            getLogProbMVNMP_CK(nd,np,MeanVec_CK(1:nd,imode),InvCovMat_CK(1:nd,1:nd,imode),LogSqrtDetInvCovMat_CK(imode),Point_CK)
        end do
        normFac_CK = maxval(real(LogProb_CK),dim=1)
        do ip = 1,np
            LogProb_CK(1:nmode,ip) = LogProb_CK(1:nmode,ip) - normFac_CK(ip)
            do imode = 1,nmode
                if ( real(LogProb_CK(imode,ip))<LOGTINY_RK ) then
                    LogProb_CK(imode,ip) = 0._RK
                else
                    LogProb_CK(imode,ip) = exp( LogProb_CK(imode,ip) )
                end if
            end do
            logProbGausMix(ip) = normFac_CK(ip) + log(sum(LogProb_CK(1:nmode,ip)))
        end do
    end function getLogProbGausMixMDMP_CK

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !include "Statistics_mod@MahalSq_RK.inc.f90"
    !include "Statistics_mod@MahalSq_CK.inc.f90"
    !include "Statistics_mod@LogProbGaus_RK.inc.f90"
    !include "Statistics_mod@LogProbGaus_CK.inc.f90"
    !include "Statistics_mod@LogProbGausMix_RK.inc.f90"
    !include "Statistics_mod@LogProbGausMix_CK.inc.f90"

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the mean of a sample of multidimensional points.
    !>
    !> \param[in]       nd      :   The number of dimensions of the input sample.
    !> \param[in]       np      :   The number of points in the sample.
    !> \param[in]       Point   :   The array of shape `(nd,np)` containing the sample.
    !> \param[in]       Weight  :   The vector of length `np` containing the weights of points in the sample (optional, default = vector of ones).
    !>
    !> \return
    !> `Mean` : The output mean vector of length `nd`.
    pure function getMean_2D(nd,np,Point,Weight) result(Mean)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getMean_2D
#endif
        ! the implementation for one-dimension is very concise and nice: mean = sum(Weight*Point) / sum(Weight)
        implicit none
        integer(IK), intent(in)             :: np,nd            ! np: number of observations, nd: number of variables for each observation
        real(RK)   , intent(in)             :: Point(nd,np)     ! Point is the data matrix
        integer(IK), intent(in), optional   :: Weight(nd,np)    ! sample weight
        real(RK)                            :: Mean(nd)         ! output mean vector
        integer(IK)                         :: ip, SumWeight(nd)
        Mean = 0._RK
        if (present(Weight)) then
            SumWeight = 0._IK
            do ip = 1,np
                SumWeight = SumWeight + Weight(1:nd,ip)
                Mean = Mean + Weight(1:nd,ip) * Point(1:nd,ip)
            end do
            Mean = Mean / real(SumWeight,kind=RK)
        else
            do ip = 1,np
                Mean = Mean + Point(1:nd,ip)
            end do
            Mean = Mean / real(np,kind=RK)
        end if
    end function getMean_2D

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the normalized data with respect to the input mean vector of length `nd`.
    !>
    !> \param[in]       nd      :   The number of dimensions of the input sample.
    !> \param[in]       np      :   The number of points in the sample.
    !> \param[in]       Mean    :   The mean vector of length `nd`.
    !> \param[in]       Point   :   The array of shape `(nd,np)` containing the sample.
    !>
    !> \return
    !> `NormData` : The output normalized points array of shape `(np,nd)`.
    !>
    !> \remark
    !> Note the difference in the shape of the input `Point` vs. the output `NormedData`.
    pure function getNormData_2D(nd,np,Mean,Point) result(NormData)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getNormData_2D
#endif
        implicit none
        integer(IK), intent(in)  :: np,nd           ! np is the number of observations, nd is the number of parameters for each observation
        real(RK)   , intent(in)  :: Mean(nd)        ! Mean vector
        real(RK)   , intent(in)  :: Point(nd,np)    ! Point is the matrix of the data, CovMat contains the elements of the sample covariance matrix
        real(RK)                 :: NormData(np,nd)
        integer(IK)              :: i
        do i = 1,np
            NormData(i,1:nd) = Point(1:nd,i) - Mean
        end do
    end function getNormData_2D

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the variance of the input vector of values of length `np`.
    !>
    !> \param[in]       np          :   The number of points in the sample.
    !> \param[in]       mean        :   The mean of the vector.
    !> \param[in]       Point       :   The array of shape `np` containing the sample.
    !> \param[in]       Weight      :   The vector of weights of the points in the sample (optional).
    !> \param[in]       sumWeight   :   The sum of the vector of weights (optional, if `Weight` is also missing).
    !>
    !> \return
    !> `variance` : The variance of the input sample.
    !>
    !> \warning
    !> If `Weight` is present, then `SumWeight` must be also present.
    !> Why? if mean is already given, it implies that SumWeight is also computed a priori.
    !>
    !> \remark
    !> One also use the concise Fortran syntax to achieve the same goal as this function:
    !> ```
    !> mean = sum(Weight*Point) / sum(Weight)
    !> variance = sum( (Weight*(Point-mean))**2 ) / (sum(Weight)-1)
    !> ```
    !> But the above concise version will be slightly slower as it involves three loops instead of two.
    pure function getVariance_1D(np,mean,Point,Weight,sumWeight) result(variance)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getVariance_1D
#endif
        implicit none
        integer(IK), intent(in)             :: np                       ! np is the number of observations (points) whose variance is to be computed
        real(RK)   , intent(in)             :: mean                     ! the mean value of the vector Point
        real(RK)   , intent(in)             :: Point(np)                ! Point is the vector of data
        integer(IK), intent(in), optional   :: Weight(np), sumWeight    ! sample weight
        real(RK)                            :: variance                 ! output mean vector
        integer(IK)                         :: ip
        variance = 0._RK
        if (present(Weight)) then
            do ip = 1,np
                variance = variance + Weight(ip) * ( Point(ip) - mean )**2
            end do
            variance = variance / real(sumWeight-1_IK,kind=RK)
        else
            do ip = 1,np
                variance = variance + ( Point(ip) - mean )**2
            end do
            variance = variance / real(np-1_IK,kind=RK)
        end if
    end function getVariance_1D

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the vector of variance of a set of `np` points of `nd` dimensions.
    !>
    !> \param[in]       nd          :   The number of dimensions of the input sample.
    !> \param[in]       np          :   The number of points in the sample.
    !> \param[in]       Mean        :   The mean vector of the sample.
    !> \param[in]       Point       :   The array of shape `(nd,np)` containing the sample.
    !> \param[in]       Weight      :   The vector of weights of the points in the sample of shape `(nd,np)` (optional).
    !>
    !> \return
    !> `Variance` : The vector of length `nd` of the variances of the input sample.
    pure function getVariance_2D(nd,np,Mean,Point,Weight) result(Variance)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getVariance_2D
#endif
        ! returns the variance of each row in Point weighted by the corresponding Weight if provided
        ! pass the Mean vector by calling getMean() or getMean_2D()
        implicit none
        integer(IK), intent(in)             :: nd, np           ! np is the number of observations (points) whose variance is to be computed
        real(RK)   , intent(in)             :: Mean(nd)         ! the Mean value of the vector Point
        real(RK)   , intent(in)             :: Point(nd,np)     ! Point is the vector of data
        integer(IK), intent(in), optional   :: Weight(nd,np)    ! sample weight
        real(RK)                            :: Variance(nd)     ! output Mean vector
        integer(IK)                         :: ip, SumWeight(nd)
        Variance = 0._RK
        if (present(Weight)) then
            SumWeight = 0._IK
            do ip = 1,np
                SumWeight = SumWeight + Weight(1:nd,ip)
                Variance = Variance + Weight(1:nd,ip) * ( Point(1:nd,ip) - Mean )**2
            end do
            Variance = Variance / real(SumWeight-1_IK,kind=RK)
        else
            do ip = 1,np
                Variance = Variance + ( Point(1:nd,ip) - Mean )**2
            end do
            Variance = Variance / real(np-1_IK,kind=RK)
        end if
    end function getVariance_2D

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the lower triangle Cholesky Factor of the covariance matrix of a set of points in the lower part of `CholeskyLower`.
    ! The upper part of `CholeskyLower`, including the diagonal elements of it, will contain the covariance matrix of the sample.
    ! The output argument `Diagonal`, contains the diagonal terms of Cholesky Factor.
    !>
    !> \param[in]       nd              :   The number of dimensions of the input sample.
    !> \param[in]       np              :   The number of points in the sample.
    !> \param[in]       Mean            :   The mean vector of the sample.
    !> \param[in]       Point           :   The array of shape `(nd,np)` containing the sample.
    !> \param[out]      CholeskyLower   :   The output matrix of shape `(nd,nd)` whose lower triangle contains elements of the Cholesky factor.
    !>                                      The upper triangle of the matrix contains the covariance matrix of the sample.
    !> \param[out]      Diagonal        :   The diagonal elements of the Cholesky factor.
    !>
    !> @todo
    !> The efficiency of this code can be further improved.
    subroutine getSamCholFac(nd,np,Mean,Point,CholeskyLower,Diagonal)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getSamCholFac
#endif
        use Matrix_mod, only: getCholeskyFactor
        implicit none
        integer(IK), intent(in)  :: nd,np                  ! np is the number of observations, nd is the number of parameters for each observation
        real(RK)   , intent(in)  :: Mean(nd)               ! Mean vector
        real(RK)   , intent(in)  :: Point(nd,np)           ! Point is the matrix of the data, CovMat contains the elements of the sample covariance matrix
        real(RK)   , intent(out) :: CholeskyLower(nd,nd)   ! Lower Cholesky Factor of the covariance matrix
        real(RK)   , intent(out) :: Diagonal(nd)           ! Diagonal elements of the Cholesky factorization
        real(RK)                 :: NormedData(np,nd), npMinusOneInverse
        integer(IK)              :: i,j

        do i = 1,np
            NormedData(i,1:nd) = Point(1:nd,i) - Mean
        end do

        ! Only upper half of CovMat is needed
        npMinusOneInverse = 1._RK / real(np-1,kind=RK)
        do j = 1,nd
            do i = 1,j
                ! Get the covariance matrix elements: only the upper half of CovMat is needed
                CholeskyLower(i,j) = dot_product( NormedData(1:np,i) , NormedData(1:np,j) ) * npMinusOneInverse
            end do
        end do

        ! XXX: The efficiency can be improved by merging it with the above loops
        call getCholeskyFactor(nd,CholeskyLower,Diagonal)

  end subroutine getSamCholFac

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the sample mean, covariance matrix, the Mahalanobis distances squared of the points with respect to the sample,
    !> and the square root of the determinant of the inverse covariance matrix of the sample.
    !>
    !> \param[in]       nd                  :   The number of dimensions of the input sample.
    !> \param[in]       np                  :   The number of points in the sample.
    !> \param[in]       Point               :   The array of shape `(np,nd)` containing the sample.
    !> \param[out]      CovMat              :   The output matrix of shape `(nd,nd)` representing the covariance matrix of the input data.
    !> \param[out]      Mean                :   The output mean vector of the sample.
    !> \param[out]      MahalSq             :   The output Mahalanobis distances squared of the points with respect to the sample (optional).
    !> \param[out]      InvCovMat           :   The output inverse covariance matrix of the input data (optional).
    !> \param[out]      sqrtDetInvCovMat    :   The output square root of the determinant of the inverse covariance matrix of the sample (optional).
    !>
    !> \warning
    !> If `sqrtDetInvCovMat` is present, then `MahalSq` and `InvCovMat` must be also present.
    !>
    !> \remark
    !> Note the shape of the input `Point(np,nd)`.
    !>
    !> \remark
    !> See also, [getSamCovMeanTrans](@ref getsamcovmeantrans).
    !>
    !> \remark
    !> For more information, see Geisser & Cornfield (1963) "Posterior distributions for multivariate normal parameters".
    !> Also, Box and Tiao (1973), "Bayesian Inference in Statistical Analysis" Page 421.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    subroutine getSamCovMean(np,nd,Point,CovMat,Mean,MahalSq,InvCovMat,sqrtDetInvCovMat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getSamCovMean
#endif
        use Matrix_mod, only: getInvPosDefMatSqrtDet
        implicit none
        integer(IK), intent(in)             :: np,nd                  ! np is the number of observations, nd is the number of parameters for each observation
        real(RK)   , intent(in)             :: Point(np,nd)           ! Point is the matrix of the data, CovMat contains the elements of the sample covariance matrix
        real(RK)   , intent(out)            :: CovMat(nd,nd)          ! Covariance matrix of the input data
        real(RK)   , intent(out)            :: Mean(nd)               ! Mean vector
        real(RK)   , intent(out), optional  :: MahalSq(np)            ! Vector of Mahalanobis Distances Squared, with respect to the mean position of the sample
        real(RK)   , intent(out), optional  :: InvCovMat(nd,nd)       ! Inverse Covariance matrix of the input data
        real(RK)   , intent(out), optional  :: sqrtDetInvCovMat       ! sqrt determinant of the inverse covariance matrix
        real(RK)                            :: NormedData(np,nd)
        real(RK)                            :: DummyVec(nd)
        integer(IK)                         :: i,j

        do j = 1,nd
            Mean(j) = sum(Point(1:np,j)) / real(np,kind=RK)
            NormedData(1:np,j) = Point(1:np,j) - Mean(j)
        end do
        do i = 1,nd
            do j = 1,nd
                CovMat(i,j) = dot_product(NormedData(1:np,i),NormedData(1:np,j))/real(np-1,kind=RK)
            end do
        end do

        if (present(sqrtDetInvCovMat)) then   ! Calculate InCovMat, MahalSq, and sqrt Determinant of InCovMat
            do j = 1,nd
                do i = 1,j
                InvCovMat(i,j) = CovMat(i,j)    ! Only the upper half of CovMat is needed
                end do
            end do
            call getInvPosDefMatSqrtDet(nd,InvCovMat,sqrtDetInvCovMat)
            do i = 1,np
                do j = 1,nd
                DummyVec(j) = dot_product(InvCovMat(1:nd,j),NormedData(i,1:nd))
                end do
                MahalSq(i) = dot_product(NormedData(i,1:nd),DummyVec)
            end do
        end if

    end subroutine getSamCovMean

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the sample mean, covariance matrix, the Mahalanobis distances squared of the points with respect to the sample,
    !> and the square root of the determinant of the inverse covariance matrix of the sample.
    !>
    !> \param[in]       nd                  :   The number of dimensions of the input sample.
    !> \param[in]       np                  :   The number of points in the sample.
    !> \param[in]       Point               :   The array of shape `(nd,np)` containing the sample.
    !> \param[out]      CovMat              :   The output matrix of shape `(nd,nd)` representing the covariance matrix of the input data.
    !> \param[out]      Mean                :   The output mean vector of the sample.
    !> \param[out]      MahalSq             :   The output Mahalanobis distances squared of the points with respect to the sample (optional).
    !> \param[out]      InvCovMat           :   The output inverse covariance matrix of the input data (optional).
    !> \param[out]      sqrtDetInvCovMat    :   The output square root of the determinant of the inverse covariance matrix of the sample (optional).
    !>
    !> \warning
    !> If `sqrtDetInvCovMat` is present, then `MahalSq` and `InvCovMat` must be also present.
    !>
    !> \remark
    !> Note the shape of the input `Point(nd,np)`.
    !>
    !> \remark
    !> This subroutine has the same functionality as [getSamCovMean](@ref getsamcovmean), with the only difference that input data is transposed here on input.
    !> Based on the preliminary benchmarks with Intel 2017 ifort, `getSamCovMean()` is slightly faster than `getSamCovMeanTrans()`.
    !>
    !> \remark
    !> For more information, see Geisser & Cornfield (1963) "Posterior distributions for multivariate normal parameters".
    !> Also, Box and Tiao (1973), "Bayesian Inference in Statistical Analysis" Page 421.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    subroutine getSamCovMeanTrans(np,nd,Point,CovMat,Mean,MahalSq,InvCovMat,sqrtDetInvCovMat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getSamCovMeanTrans
#endif

        use Matrix_mod, only: getInvPosDefMatSqrtDet
        implicit none
        integer(IK), intent(in)            :: np,nd                  ! np is the number of observations, nd is the number of parameters for each observation
        real(RK)   , intent(in)            :: Point(nd,np)           ! Point is the matrix of the data, CovMat contains the elements of the sample covariance matrix
        real(RK)   , intent(out)           :: CovMat(nd,nd)          ! Covariance matrix of the input data
        real(RK)   , intent(out)           :: Mean(nd)               ! Mean vector
        real(RK)   , intent(out), optional :: MahalSq(np)            ! Vector of Mahalanobis Distances Squared, with respect to the mean position of the sample
        real(RK)   , intent(out), optional :: InvCovMat(nd,nd)       ! Inverse Covariance matrix of the input data
        real(RK)   , intent(out), optional :: sqrtDetInvCovMat       ! sqrt determinant of the inverse covariance matrix
        real(RK)   , dimension(nd)         :: DummyVec
        real(RK)   , dimension(nd,np)      :: NormedData
        integer(IK)                        :: i,j

        Mean = 0._RK
        do i = 1,np
            do j = 1,nd
                Mean(j) = Mean(j) + Point(j,i)
            end do
        end do
        Mean = Mean / real(np,kind=RK)

        do i = 1,np
            NormedData(1:nd,i) = Point(1:nd,i) - Mean
        end do

        do i = 1,nd
            do j = 1,nd
                CovMat(i,j) = dot_product(NormedData(i,1:np),NormedData(j,1:np)) / real(np-1,kind=RK)
            end do
        end do

        if (present(sqrtDetInvCovMat)) then   ! Calculate InCovMat, MahalSq, and sqrt Determinant of InCovMat
            do j = 1,nd
                do i = 1,j
                InvCovMat(i,j) = CovMat(i,j)    ! Only the upper half of CovMat is needed
                end do
            end do
            call getInvPosDefMatSqrtDet(nd,InvCovMat,sqrtDetInvCovMat)
            do i = 1,np
                do j = 1,nd
                DummyVec(j) = dot_product(InvCovMat(1:nd,j),NormedData(1:nd,i))
                end do
                MahalSq(i) = dot_product(NormedData(1:nd,i),DummyVec)
                !MahalSq = dot_product(NormedData(1:nd,i),DummyVec)
                !if (maxMahal<MahalSq) maxMahal = MahalSq
            end do
            !maxMahal = maxval(MahalSq)
        end if

    end subroutine getSamCovMeanTrans

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the sample mean and the upper triangle of the covariance matrix of the input sample.
    !>
    !> \param[in]       nd                  :   The number of dimensions of the input sample.
    !> \param[in]       np                  :   The number of points in the sample.
    !> \param[in]       Point               :   The array of shape `(nd,np)` containing the sample.
    !> \param[out]      CovMatUpper         :   The output matrix of shape `(nd,nd)` whose upper triangle represents the covariance matrix of the input data.
    !> \param[out]      Mean                :   The output mean vector of the sample.
    !>
    !> \remark
    !> Note the shape of the input `Point(nd,np)`.
    !>
    !> \remark
    !> This subroutine has the same functionality as [getSamCovMeanTrans](@ref getsamcovmeantrans), with the only difference
    !> only the upper triangle of the covariance matrix is returned. Also, optional arguments are not available.
    !> This subroutine is specifically optimized for use in the ParaMonte samplers.
    !>
    !> \remark
    !> For more information, see Geisser & Cornfield (1963) "Posterior distributions for multivariate normal parameters".
    !> Also, Box and Tiao (1973), "Bayesian Inference in Statistical Analysis" Page 421.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    subroutine getSamCovUpperMeanTrans(np,nd,Point,CovMatUpper,Mean)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getSamCovUpperMeanTrans
#endif
        use Matrix_mod, only: getInvPosDefMatSqrtDet
        implicit none
        integer(IK), intent(in)            :: np,nd                  ! np is the number of observations, nd is the number of parameters for each observation
        real(RK)   , intent(in)            :: Point(nd,np)           ! Point is the matrix of the data, CovMatUpper contains the elements of the sample covariance matrix
        real(RK)   , intent(out)           :: CovMatUpper(nd,nd)     ! Covariance matrix of the input data
        real(RK)   , intent(out)           :: Mean(nd)               ! Mean vector
        real(RK)                           :: npMinusOneInvReal, NormedData(nd,np)
        integer(IK)                        :: i,j

        Mean = 0._RK
        do i = 1,np
            do j = 1,nd
                Mean(j) = Mean(j) + Point(j,i)
            end do
        end do
        Mean = Mean / real(np,kind=RK)

        do i = 1,np
            NormedData(1:nd,i) = Point(1:nd,i) - Mean
        end do

        npMinusOneInvReal = 1._RK / real(np-1,kind=RK)
        do j = 1,nd
            do i = 1,j
                CovMatUpper(i,j) = dot_product(NormedData(i,1:np),NormedData(j,1:np)) * npMinusOneInvReal
            end do
        end do

  end subroutine getSamCovUpperMeanTrans

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the mean and the upper triangle of the covariance matrix of the input *weighted* sample.
    !>
    !> \param[in]       nd                  :   The number of dimensions of the input sample.
    !> \param[in]       sumWeight           :   The sum of all sample weights.
    !> \param[in]       np                  :   The number of points in the sample.
    !> \param[in]       Point               :   The array of shape `(nd,np)` containing the sample.
    !> \param[in]       Weight              :   The integer array of length `np`, representing the weights of individual points in the sample.
    !> \param[out]      CovMatUpper         :   The output matrix of shape `(nd,nd)` whose upper triangle represents the covariance matrix of the input data.
    !> \param[out]      Mean                :   The output mean vector of the sample.
    !>
    !> \remark
    !> Note the shape of the input `Point(nd,np)`.
    !>
    !> \remark
    !> This subroutine has the same functionality as [getSamCovUpperMeanTrans](@ref getsamcovuppermeantrans), with the only difference
    !> only the upper triangle of the covariance matrix is returned. Also, optional arguments are not available.
    !> This subroutine is specifically optimized for use in the ParaMonte samplers.
    !>
    !> \remark
    !> For more information, see Geisser & Cornfield (1963) "Posterior distributions for multivariate normal parameters".
    !> Also, Box and Tiao (1973), "Bayesian Inference in Statistical Analysis" Page 421.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    subroutine getWeiSamCovUppMeanTrans(np,sumWeight,nd,Point,Weight,CovMatUpper,Mean)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getWeiSamCovUppMeanTrans
#endif

        use Matrix_mod, only: getInvPosDefMatSqrtDet
        implicit none
        integer(IK), intent(in)             :: np,nd,sumWeight        ! np is the number of observations, nd is the number of parameters for each observation
        integer(IK), intent(in)             :: Weight(np)             ! weights of the points
        real(RK)   , intent(in)             :: Point(nd,np)           ! Point is the matrix of the data, CovMatUpper contains the elements of the sample covariance matrix
        real(RK)   , intent(out)            :: CovMatUpper(nd,nd)     ! Covariance matrix of the input data
        real(RK)   , intent(out)            :: Mean(nd)               ! Mean vector
        real(RK)                            :: sumWeightMinusOneInvReal
        real(RK)                            :: NormedData(nd,np)
        integer(IK)                         :: i,j,ip

        Mean = 0._RK
        do i = 1,np
            do j = 1,nd
                Mean(j) = Mean(j) + Weight(i)*Point(j,i)
            end do
        end do
        Mean = Mean / real(sumWeight,kind=RK)

        do i = 1,np
            NormedData(1:nd,i) = Point(1:nd,i) - Mean
        end do

        sumWeightMinusOneInvReal = 1._RK / real(sumWeight-1,kind=RK)
        do j = 1,nd
            do i = 1,j
                CovMatUpper(i,j) = 0
                do ip = 1,np
                    CovMatUpper(i,j) = CovMatUpper(i,j) + Weight(ip)*NormedData(i,ip)*NormedData(j,ip)
                end do
                CovMatUpper(i,j) = CovMatUpper(i,j) * sumWeightMinusOneInvReal
            end do
        end do

    end subroutine getWeiSamCovUppMeanTrans

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Given two input sample means and covariance matrices, return the combination of them as a single mean and covariance matrix.
    !>
    !> \param[in]       nd          :   The number of dimensions of the input sample.
    !> \param[in]       npA         :   The number of points in sample `A`.
    !> \param[in]       MeanA       :   The mean vector of sample `A`.
    !> \param[in]       CovMatA     :   The covariance matrix of sample `A`.
    !> \param[in]       npB         :   The number of points in sample `B`.
    !> \param[in]       MeanB       :   The mean vector of sample `B`.
    !> \param[in]       CovMatB     :   The covariance matrix of sample `B`.
    !> \param[out]      Mean        :   The output mean vector of the combined sample.
    !> \param[out]      CovMat      :   The output covariance matrix of the combined sample.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    ! This subroutine uses a recursion equation similar to http://stats.stackexchange.com/questions/97642/how-to-combine-sample-means-and-sample-variances
    ! See also: https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Covariance
    ! See also: https://stats.stackexchange.com/questions/43159/how-to-calculate-pooled-variance-of-two-groups-given-known-group-variances-mean
    subroutine combineCovMean(nd,npA,MeanA,CovMatA,npB,MeanB,CovMatB,Mean,CovMat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: combineCovMean
#endif
        implicit none
        integer(IK), intent(in)       :: nd
        integer(IK), intent(in)       :: npA,npB
        real(RK)   , intent(in)       :: MeanA(nd),CovMatA(nd,nd)
        real(RK)   , intent(in)       :: MeanB(nd),CovMatB(nd,nd)
        real(RK)   , intent(out)      :: Mean(nd),CovMat(nd,nd)
        real(RK)   , dimension(nd,1)  :: MatMeanA,MatMeanB,MatMean
        real(RK)                      :: npABinverse

        npABinverse = 1._RK / real(npA + npB, kind=RK)
        MatMeanA(1:nd,1) = MeanA
        MatMeanB(1:nd,1) = MeanB

        ! First find the Mean

        Mean = ( real(npA,kind=RK)*MeanA + real(npB,kind=RK)*MeanB ) * npABinverse
        MatMean(1:nd,1) = Mean

        ! Now find new Covariance matrix

        CovMat  = real(npA,kind=RK) * ( CovMatA + matmul(MatMeanA,transpose(MatMeanA)) ) &
                + real(npB,kind=RK) * ( CovMatB + matmul(MatMeanB,transpose(MatMeanB)) )
        CovMat  = npABinverse * CovMat - matmul(MatMean,transpose(MatMean))

    end subroutine combineCovMean

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Given two input sample means and covariance matrices, return the combination of them as a single mean and covariance matrix.
    !>
    !> \param[in]       nd              :   The number of dimensions of the input sample.
    !> \param[in]       npA             :   The number of points in sample `A`.
    !> \param[in]       MeanVecA        :   The mean vector of sample `A`.
    !> \param[in]       CovMatUpperA    :   The upper triangle of the covariance matrix of sample `A`.
    !> \param[in]       npB             :   The number of points in sample `B`.
    !> \param[in]       MeanVecB        :   The mean vector of sample `B`.
    !> \param[in]       CovMatUpperB    :   The upper triangle of the covariance matrix of sample `B`.
    !> \param[out]      MeanVec         :   The output mean vector of the combined sample.
    !> \param[out]      CovMatUpper     :   The output upper triangle of the covariance matrix of the combined sample.
    !>
    !> @todo
    !> The efficiency of this algorithm might still be improved by converting the upper triangle covariance matrix to a packed vector.
    !>
    !> \remark
    !> This subroutine is the same as [combineCovMean](@ref combinecovmean), with the **important difference** that only the
    !> upper triangles and diagonals of the input covariance matrices need to be given by the user: `CovMatUpperA`, `CovMatUpperB`
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    subroutine combineMeanCovUpper(nd,npA,MeanVecA,CovMatUpperA,npB,MeanVecB,CovMatUpperB,MeanVec,CovMatUpper)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: combineMeanCovUpper
#endif

        implicit none
        integer(IK), intent(in)  :: nd
        integer(IK), intent(in)  :: npA,npB
        real(RK)   , intent(in)  :: MeanVecA(nd),CovMatUpperA(nd,nd)
        real(RK)   , intent(in)  :: MeanVecB(nd),CovMatUpperB(nd,nd)
        real(RK)   , intent(out) :: MeanVec(nd),CovMatUpper(nd,nd)
        real(RK)                 :: npAreal, npBreal, npABinverse, npA2npAB, npB2npAB
        integer(IK)              :: i,j

        npAreal = real(npA,kind=RK)
        npBreal = real(npB,kind=RK)
        npABinverse = 1._RK / (npAreal + npBreal)
        npA2npAB = npAreal * npABinverse
        npB2npAB = npBreal * npABinverse

        do j = 1, nd
            MeanVec(j) = npA2npAB * MeanVecA(j) + npB2npAB * MeanVecB(j) ! First find MeanVec
            do i = 1, j ! Now find new Covariance matrix
                CovMatUpper(i,j) = ( npA2npAB * ( CovMatUpperA(i,j) + MeanVecA(i) * MeanVecA(j) ) &
                                   + npB2npAB * ( CovMatUpperB(i,j) + MeanVecB(i) * MeanVecB(j) ) &
                                   ) - MeanVec(i) * MeanVec(j)
            end do
        end do

    end subroutine combineMeanCovUpper

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Given two input sample means and covariance matrices, return the combination of them as a single mean and covariance matrix.
    !>
    !> \param[in]       nd              :   The number of dimensions of the input sample.
    !> \param[in]       npA             :   The number of points in sample `A`.
    !> \param[in]       MeanVecA        :   The mean vector of sample `A`.
    !> \param[in]       CovMatUpperA    :   The upper triangle of the covariance matrix of sample `A`.
    !> \param[in]       npB             :   The number of points in sample `B`.
    !> \param[inout]    MeanVecB        :   The mean vector of sample `B` and the merged mean on return.
    !> \param[inout]    CovMatUpperB    :   The upper triangle of the covariance matrix of sample `B` on input and
    !>                                      the output upper triangle of the covariance matrix of the combined sample on return.
    !>
    !> @todo
    !> The efficiency of this algorithm might still be improved by converting the upper triangle covariance matrix to a packed vector.
    !>
    !> \remark
    !> This subroutine is the same as [combineMeanCovUpper](@ref combinemeancovupper), with the **important difference** that
    !> the resulting `MeanVec` and `CovMatUpper` are now returned as `MeanB` and `CovMatB`.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    subroutine mergeMeanCovUpper(nd,npA,MeanVecA,CovMatUpperA,npB,MeanVecB,CovMatUpperB)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: mergeMeanCovUpper
#endif

        implicit none
        integer(IK), intent(in)     :: nd
        integer(IK), intent(in)     :: npA,npB
        real(RK)   , intent(in)     :: MeanVecA(nd),CovMatUpperA(nd,nd)
        real(RK)   , intent(inout)  :: MeanVecB(nd),CovMatUpperB(nd,nd)
        real(RK)                    :: MeanVec(nd)
        real(RK)                    :: npABinverse, npA2npAB, npB2npAB
        integer(IK)                 :: i,j

        npABinverse = 1._RK / real(npA + npB,kind=RK)
        npA2npAB = real(npA,kind=RK) * npABinverse
        npB2npAB = real(npB,kind=RK) * npABinverse

        do j = 1, nd
            MeanVec(j) = npA2npAB * MeanVecA(j) + npB2npAB * MeanVecB(j)
            do i = 1, j
                CovMatUpperB(i,j)   = npA2npAB * ( CovMatUpperA(i,j) + MeanVecA(i) * MeanVecA(j) ) &
                                    + npB2npAB * ( CovMatUpperB(i,j) + MeanVecB(i) * MeanVecB(j) ) &
                                    - MeanVec(i) * MeanVec(j)
            end do
        end do
        MeanVecB = MeanVec

    end subroutine mergeMeanCovUpper

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a random standard Gaussian deviate with zero mean and unit variance.
    !>
    !> \return
    !> `randGaus` : The random standard Gaussian deviate with zero mean and unit variance.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    function getRandGaus() result(randGaus)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandGaus
#endif

        implicit none
        integer(IK), save :: iset=0
        real(RK)   , save :: gset
        real(RK)          :: fac,rsq,vec(2)
        real(RK)          :: randGaus

        if (iset == 0_IK) then
            do
                !block
                !integer :: i, n
                !real(RK) :: unifrnd(30)
                !!integer, dimension(:), allocatable :: seed
                !if (paradramPrintEnabled .or. paradisePrintEnabled) then
                !    !do i = 1, 22
                !    call random_number(unifrnd)
                !    write(*,"(*(g0,:,'"//new_line("a")//"'))") unifrnd
                !    !end do
                !    !call random_seed(size = n); allocate(seed(n))
                !    !call random_seed(get = seed)
                !    !write(*,"(*(g0,:,' '))") seed
                !    !write(*,"(*(g0,:,' '))") StateOld
                !    !write(*,"(*(g0,:,' '))") StateNew
                !    !write(*,"(*(g0,:,' '))") CholeskyLower
                !    !write(*,"(*(g0,:,' '))") domainCheckCounter
                !    paradisePrintEnabled = .false.
                !    paradramPrintEnabled = .false.
                !end if
                !end block
                call random_number(vec)
                vec = 2._RK*vec - 1._RK
                rsq = vec(1)**2 + vec(2)**2
                if ( rsq > 0._RK .and. rsq < 1._RK ) exit
            end do
            fac = sqrt(-2._RK*log(rsq)/rsq)
            gset = vec(1)*fac
            randGaus = vec(2)*fac
            iset = 1_IK
        else
            randGaus = gset
            iset = 0_IK
        endif

    end function getRandGaus

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a random Gaussian deviate with the given mean and standard deviation.
    !>
    !> \param[in]       mean    :   The mean of the Gaussian distribution.
    !> \param[in]       std     :   The standard deviation of the Gaussian distribution.
    !>
    !> \return
    !> `randNorm` : A normally distributed deviate with the given mean and standard deviation.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    function getRandNorm(mean,std) result(randNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandNorm
#endif
        implicit none
        real(RK), intent(in)    :: mean, std
        real(RK)                :: randNorm
        randNorm = mean + std*getRandGaus()
    end function getRandNorm

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a log-normally distributed deviate with the given mean and standard deviation.
    !>
    !> \param[in]       mean    :   The mean of the Lognormal distribution.
    !> \param[in]       std     :   The standard deviation of the Lognormal distribution.
    !>
    !> \return
    !> `randLogn` : A Lognormally distributed deviate with the given mean and standard deviation.
    !>
    !> \author
    !> Amir Shahmoradi, Oct 16, 2009, 11:14 AM, Michigan
    function getRandLogn(mean,std) result(randLogn)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandLogn
#endif
        implicit none
        real(RK), intent(in) :: mean, std
        real(RK)       :: randLogn
        randLogn = exp( mean + std*getRandGaus() )
    end function getRandLogn

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! This subroutine is legacy and slow. use getRandMVN() in this same module.
    ! Given the mean vector MeanVec and the covariance matrix CovMat, this subroutine generates a random vector x (of length nd>=2)
    ! from an nd-dimensional multivariate normal distribution.
    ! First a vector of nd standard normal random deviates is generated,
    ! then this vector is multiplied by the Cholesky decomposition of the covariance matrix,
    ! then the vector MeanVec is added to the resulting vector, and is stored in the output vector x.
    ! ATTENTION: Only the upper half of the covariance matrix (plus the diagonal terms) need to be given in the input.
    ! in the ouput, the upper half and diagonal part will still be the covariance matrix, while the lower half will be
    ! the Cholesky decomposition elements (excluding its diagonal terms that are provided only in the vector Diagonal).
    ! USES choldc.f90, getRandGaus.f90
    ! Amir Shahmoradi, March 22, 2012, 2:21 PM, IFS, UTEXAS
    subroutine getMVNDev(nd,MeanVec,CovMatIn,X)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getMVNDev
#endif

        use Matrix_mod, only: getCholeskyFactor

        implicit none
        integer(IK), intent(in)  :: nd
        real(RK)   , intent(in)  :: MeanVec(nd), CovMatIn(nd,nd)
        real(RK)   , intent(out) :: X(nd)
        real(RK)                 :: CovMat(nd,nd), Diagonal(nd), DummyVec(nd)
        integer(IK)              :: i

        CovMat = CovMatIn
        call getCholeskyFactor(nd,CovMat,Diagonal)
        if (Diagonal(1)<0._RK) then
            write(*,*) 'getCholeskyFactor() failed in getMVNDev()'
            stop
        end if
        do i=1,nd
            DummyVec(i) = getRandGaus()
            x(i) = DummyVec(i) * Diagonal(i)
        end do
        do i=2,nd
            x(i) = x(i) + dot_product(CovMat(i,1:i-1),DummyVec(1:i-1))
        end do
        x = x + MeanVec

  end subroutine getMVNDev

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ! This subroutine is legacy and slow. use getRandMVU() in this same module.
    ! Given the mean vector MeanVec and the covariance matrix CovMat, this subroutine generates a random vector X (of length nd>=2)
    ! from an nd-dimensional multivariate ellipsoidal uniform distribution, such that getMVUDev() is randomly distributed inside the nd-dimensional ellipsoid.
    ! ATTENTION: Only the upper half of the covariance matrix (plus the diagonal terms) need to be given in the input.
    ! in the ouput, the upper half and diagonal part will still be the covariance matrix, while the lower half will be
    ! the Cholesky decomposition elements (excluding its diagonal terms that are provided only in the vector Diagonal).
    ! USES getCholeskyFactor.f90, getRandGaus.f90
    ! Amir Shahmoradi, April 25, 2016, 2:21 PM, IFS, UTEXAS
    subroutine getMVUDev(nd,MeanVec,CovMatIn,X)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getMVUDev
#endif

        use Matrix_mod, only: getCholeskyFactor

        implicit none
        integer(IK), intent(in)  :: nd
        real(RK)   , intent(in)  :: MeanVec(nd)
        real(RK)   , intent(in)  :: CovMatIn(nd,nd)
        real(RK)   , intent(out) :: X(nd)
        real(RK)                 :: Diagonal(nd), DummyVec(nd), CovMat(nd,nd), dummy
        integer(IK)              :: i

        CovMat = CovMatIn
        call getCholeskyFactor(nd,CovMat,Diagonal)
        if (Diagonal(1)<0._RK) then
            error stop
            !call abortProgram( output_unit , 1 , 1 , 'Statitistics@getMVUDev()@getCholeskyFactor() failed.' )
        end if
        do i=1,nd
            DummyVec(i) = getRandGaus()
        end do
        call random_number(dummy)
        dummy = (dummy**(1._RK/real(nd,kind=RK)))/norm2(DummyVec)  ! Now DummyVec is a uniformly drawn point from inside of nd-D sphere.
        DummyVec = dummy*DummyVec

        ! Now transform this point to a point inside the ellipsoid.
        do i=1,nd
            X(i) = DummyVec(i)*Diagonal(i)
        end do

        do i=2,nd
            X(i) = X(i) + dot_product(CovMat(i,1:i-1),DummyVec(1:i-1))
        end do

        X = X + MeanVec

    end subroutine getMVUDev

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a MultiVariate Normal (MVN) random vector with the given mean and
    !> covariance matrix represented by the the input Cholesky factorization.
    !>
    !> \param[in]   nd              :   The number of dimensions of the MVN distribution.
    !> \param[in]   MeanVec         :   The mean vector of the MVN distribution.
    !> \param[in]   CholeskyLower   :   The Cholesky lower triangle of the covariance matrix of the MVN distribution.
    !> \param[in]   Diagonal        :   The Diagonal elements of the Cholesky lower triangle of the covariance matrix of the MVN distribution.
    !>
    !> \return
    !> `RandMVN` : The randomly generated MVN vector.
    !>
    !> \author
    !> Amir Shahmoradi, April 23, 2017, 12:36 AM, ICES, UTEXAS
    function getRandMVN(nd,MeanVec,CholeskyLower,Diagonal) result(RandMVN)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandMVN
#endif
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: CholeskyLower(nd,nd), Diagonal(nd)   ! Cholesky lower triangle and its diagonal terms, calculated from the input CovMat.
        real(RK)                :: RandMVN(nd), dummy
        integer(IK)             :: j,i
        RandMVN = MeanVec
        do j = 1,nd
            dummy = getRandGaus()
            RandMVN(j) = RandMVN(j) + Diagonal(j) * dummy
            do i = j+1,nd
                RandMVN(i) = RandMVN(i) + CholeskyLower(i,j) * dummy
            end do
        end do
    end function getRandMVN

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

!    ! Given an input Mean vector of length nd, Covariance Matrix of dimension (nd,nd), as well as a vector of integers representing
!    ! the variables (corresponding to CovMat columns) that are given
!    ! This subroutine gives out a conditional Multivariate Normal Random deviate.
!    ! random p-tivariate normal deviate, given that the first pg variables x1 are given (i.e. fixed).
!    ! For a review of Multivariate Normal distribution: Applied Multivariate Statistical Analysis, Johnson, Wichern, 1998, 4th ed.
!    ! Amir Shahmoradi, Oct 20, 2009, 9:12 PM, MTU
!    function getCondRandMVN(nd,MeanVec,CovMat,nIndIndx,IndIndx) result(CondRandMVN)
!        use Matrix_mod, only: getRegresCoef
!        implicit none
!        integer(IK), intent(in) :: nd, nIndIndx, IndIndx(nIndIndx)
!        real(RK)   , intent(in) :: MeanVec(nd), CovMat(nd,nd)
!        real(RK)                :: CondRandMVN(nd),
!        integer(IK)             :: j, i
!    end function getCondRandMVN

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Given the Cholesky Lower triangle and diagonals of a given covariance matrix, this function return one point uniformly
    !> randomly drawn from inside of an `nd`-ellipsoid, whose `nd` elements `RandMVU(i), i=1:nd` are guaranteed
    !> to be in the range:
    !> ```
    !> MeanVec(i) - sqrt(CovMat(i,i)) < RandMVU(i) < MeanVec(i) + sqrt(CovMat(i,i))
    !> ```
    !>
    !> \param[in]   nd              :   The number of dimensions of the MVU distribution.
    !> \param[in]   MeanVec         :   The mean vector of the MVU distribution.
    !> \param[in]   CholeskyLower   :   The Cholesky lower triangle of the covariance matrix of the MVU distribution.
    !> \param[in]   Diagonal        :   The Diagonal elements of the Cholesky lower triangle of the covariance matrix of the MVU distribution.
    !>
    !> \return
    !> `RandMVU` : The randomly generated MVU vector.
    !>
    !> \author
    !> Amir Shahmoradi, April 23, 2017, 1:36 AM, ICES, UTEXAS
    function getRandMVU(nd,MeanVec,CholeskyLower,Diagonal) result(RandMVU)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandMVU
#endif
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: CholeskyLower(nd,nd) ! Cholesky lower triangle, calculated from the input CovMat.
        real(RK)   , intent(in) :: Diagonal(nd)         ! Cholesky diagonal terms, calculated from the input CovMat.
        real(RK)                :: RandMVU(nd), dummy, DummyVec(nd), sumSqDummyVec
        integer(IK)             :: i,j
        sumSqDummyVec = 0._RK
        do j=1,nd
            DummyVec(j) = getRandGaus()
            sumSqDummyVec = sumSqDummyVec + DummyVec(j)**2
        end do
        call random_number(dummy)
        dummy = dummy**(1._RK/nd) / sqrt(sumSqDummyVec)
        DummyVec = DummyVec * dummy  ! a uniform random point from inside of nd-sphere
        RandMVU = MeanVec
        do j = 1,nd
            RandMVU(j) = RandMVU(j) + Diagonal(j) * DummyVec(j)
            do i = j+1,nd
                RandMVU(i) = RandMVU(i) + CholeskyLower(i,j) * DummyVec(j)
            end do
        end do
    end function getRandMVU

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return `.true.` if the input `NormedPoint` (normalized with respect to the center of the target ellipsoid) is
    !> within or on the boundary of the ellipsoid whose boundary is described by the representative matrix
    !> \f$ \Sigma \f$ (`RepMat`), such that,
    !> \f{equation}{
    !> X^T ~ \Sigma^{-1} ~ X = 1 ~,
    !> \f}
    !> for all \f$X\f$ on the boundary.
    !>
    !> \param[in]   nd          :   The number of dimensions of the ellipsoid (the size of `NormedPoint`).
    !> \param[in]   NormedPoint :   The input point, normalized with respect to the center of the ellipsoid,
    !>                                  whose location with respect to the ellipsoid boundary is to be determined.
    !> \param[in]   InvRepMat   :   The inverse of the representative matrix of the target ellipsoid.
    !>
    !> \return
    !> `isInsideEllipsoid` : The logical value indicating whether the input point is inside or on the boundary of the target ellipsoid.
    !>
    !> \remark
    !> Note that the input matrix is the inverse of `RepMat`: `InvRepMat`.
    !>
    !> \author
    !> Amir Shahmoradi, April 23, 2017, 1:36 AM, ICES, UTEXAS
    pure function isInsideEllipsoid(nd,NormedPoint,InvRepMat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: isInsideEllipsoid
#endif
        use Math_mod, only: getLogVolEllipsoid
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: NormedPoint(nd)
        real(RK)   , intent(in) :: InvRepMat(nd,nd)
        logical                 :: isInsideEllipsoid
        isInsideEllipsoid = dot_product(NormedPoint,matmul(InvRepMat,NormedPoint)) <= 1._RK
    end function isInsideEllipsoid

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the natural logarithm of the probability density function value of a point uniformly distributed within an ellipsoid,
    !> whose logarithm of the square root of the determinant of the inverse of its representative matrix is given by `logSqrtDetInvCovMat`.
    !>
    !> \param[in]   nd                  :   The number of dimensions of the MVU distribution.
    !> \param[in]   logSqrtDetInvCovMat :   The logarithm of the square root of the determinant of
    !>                                      the inverse of the representative covariance matrix of the ellipsoid.
    !>
    !> \return
    !> `logProbMVU` :   The natural logarithm of the probability density function value
    !>                  of a point uniformly distributed within the target ellipsoid.
    !>
    !> \author
    !> Amir Shahmoradi, April 23, 2017, 1:36 AM, ICES, UTEXAS
    pure function getLogProbMVU(nd,logSqrtDetInvCovMat) result(logProbMVU)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbMVU
#endif
        use Math_mod, only: getLogVolEllipsoid
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: logSqrtDetInvCovMat
        real(RK)                :: logProbMVU
        logProbMVU = -getLogVolEllipsoid(nd,logSqrtDetInvCovMat)
    end function getLogProbMVU

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a random point on the target ellipsoid by projecting a random point uniformly distributed within the ellipsoid on its boundary.
    !>
    !> \param[in]   nd              :   The number of dimensions of the ellipsoid.
    !> \param[in]   MeanVec         :   The mean vector (center) of the ellipsoid.
    !> \param[in]   CholeskyLower   :   The Cholesky lower triangle of the representative covariance matrix of the ellipsoid.
    !> \param[in]   Diagonal        :   The Diagonal elements of the Cholesky lower triangle of the representative covariance matrix of the ellipsoid.
    !>
    !> \return
    !> `RandPointOnEllipsoid` : A random point on the target ellipsoid by projecting a random
    !>                          point uniformly distributed within the ellipsoid on its boundary.
    !>
    !> \remark
    !> This is algorithm is similar to [getRandMVU](@ref getrandmvu), with the only difference that
    !> points are drawn randomly from the surface of the ellipsoid instead of inside of its interior.
    !>
    !> \remark
    !> Note that the distribution of points on the surface of the ellipsoid is **NOT** uniform.
    !> Regions of high curvature will have more points randomly sampled from them.
    !> Generating uniform random points on arbitrary-dimension ellipsoids is not a task with trivial solution!
    !>
    !> @todo
    !> The performance of this algorithm can be further improved.
    !>
    !> \author
    !> Amir Shahmoradi, April 23, 2017, 1:36 AM, ICES, UTEXAS
    function getRandPointOnEllipsoid(nd,MeanVec,CholeskyLower,Diagonal) result(RandPointOnEllipsoid)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandPointOnEllipsoid
#endif
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: MeanVec(nd)
        real(RK)   , intent(in) :: CholeskyLower(nd,nd) ! Cholesky lower triangle, calculated from the MVN CovMat.
        real(RK)   , intent(in) :: Diagonal(nd)         ! Cholesky diagonal terms, calculated from the MVN CovMat.
        real(RK)                :: RandPointOnEllipsoid(nd), DummyVec(nd), sumSqDummyVec
        integer(IK)             :: i,j
        sumSqDummyVec = 0._RK
        do j=1,nd
            DummyVec(j) = getRandGaus()
            sumSqDummyVec = sumSqDummyVec + DummyVec(j)**2
        end do
        DummyVec = DummyVec / sqrt(sumSqDummyVec)    ! DummyVec is a random point on the surface of nd-sphere.
        RandPointOnEllipsoid = 0._RK
        do j = 1,nd
            RandPointOnEllipsoid(j) = RandPointOnEllipsoid(j) + Diagonal(j) * DummyVec(j)
            do i = j+1,nd
                RandPointOnEllipsoid(i) = RandPointOnEllipsoid(i) + CholeskyLower(i,j) * DummyVec(j)
            end do
        end do
        RandPointOnEllipsoid = RandPointOnEllipsoid + MeanVec
    end function getRandPointOnEllipsoid

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the single-precision complementary Error function with fractional error everywhere less than \f$ 1.2 \times 10^{-7} \f$.
    !>
    !> \param[in]   x   :   The input real value.
    !>
    !> \return
    !> `erfcc` : The complementary Error function for the input value `x`.
    !>
    !> \remark
    !> There is no need to use this algorithm as the Fortran intrinsic function `erf()` can achieve the goal.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function erfcc(x)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: erfcc
#endif
        implicit none
        real(RK), intent(in) :: x
        real(RK)             :: erfcc
        real(RK)             :: t,z
        z = abs(x)
        t = 1._RK/(1._RK+0.5_RK*z)
        erfcc = t*exp(-z*z-1.26551223_RK+t*(1.00002368_RK+t*(.37409196_RK+t*&
                (.09678418_RK+t*(-.18628806_RK+t*(.27886807_RK+t*(-1.13520398_RK+t*&
                (1.48851587_RK+t*(-.82215223_RK+t*.17087277_RK)))))))))
        if (x < 0._RK) erfcc = 2._RK - erfcc
    end function erfcc

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the natural logarithm of the Lognormal probability density function.
    !>
    !> \param[in]   logMean                 :   The mean of the Lognormal distribution.
    !> \param[in]   inverseVariance         :   The inverse variance of the Lognormal distribution.
    !> \param[in]   logSqrtInverseVariance  :   The natural logarithm of the square root of the inverse variance of the Lognormal distribution.
    !> \param[in]   logPoint                :   The natural logarithm of the point at which the Lognormal PDF must be computed.
    !>
    !> \return
    !> `logProbLogNorm` : The natural logarithm of the Lognormal probability density function.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getLogProbLogNormS(logMean,inverseVariance,logSqrtInverseVariance,logPoint) result(logProbLogNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbLogNormS
#endif
        use Constants_mod, only: LOGINVSQRT2PI
        implicit none
        real(RK), intent(in) :: logMean,inverseVariance,logSqrtInverseVariance,logPoint
        real(RK)             :: logProbLogNorm
        logProbLogNorm = LOGINVSQRT2PI + logSqrtInverseVariance - logPoint - 0.5_RK * inverseVariance * (logPoint-logMean)**2
    end function getLogProbLogNormS

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the natural logarithm of the Lognormal probability density function.
    !>
    !> \param[in]   np                      :   The size of the input vector of points represented by `LogPoint`.
    !> \param[in]   logMean                 :   The mean of the Lognormal distribution.
    !> \param[in]   inverseVariance         :   The inverse variance of the Lognormal distribution.
    !> \param[in]   logSqrtInverseVariance  :   The natural logarithm of the square root of the inverse variance of the Lognormal distribution.
    !> \param[in]   LogPoint                :   The natural logarithm of the vector of points at which the Lognormal PDF must be computed.
    !>
    !> \return
    !> `logProbLogNorm` : The natural logarithm of the Lognormal probability density function.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function GetLogProbLogNormMP(np,logMean,inverseVariance,logSqrtInverseVariance,LogPoint) result(logProbLogNorm)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: GetLogProbLogNormMP
#endif
        use Constants_mod, only: LOGINVSQRT2PI
        implicit none
        integer(IK), intent(in) :: np
        real(RK)   , intent(in) :: logMean,inverseVariance,logSqrtInverseVariance,LogPoint(np)
        real(RK)                :: logProbLogNorm(np)
        logProbLogNorm = LOGINVSQRT2PI + logSqrtInverseVariance - LogPoint - 0.5_RK * inverseVariance * (LogPoint-logMean)**2
    end function GetLogProbLogNormMP

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a single-precision uniformly-distributed random real-valued number in the range `[0,1]`.
    !>
    !> \param[inout]    idum    :   The input integer random seed with the `save` attribute.
    !>
    !> \return
    !> `randRealLecuyer`        :   A single-precision uniformly-distributed random real-valued number in the range `[0,1]`.
    !>
    !> \warning
    !> Do not change the value of `idum` between calls.
    !>
    !> \remark
    !> This routine is guaranteed to random numbers with priodicity larger than `~2*10**18` random numbers.
    !> For more info see Press et al. (1990) Numerical Recipes.
    !>
    !> \remark
    !> This routine is solely kept for backward compatibility reasons.
    !> The Fortran intrinsic subroutine `random_number()` is recommended to be used against this function.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandRealLecuyer(idum) result(randRealLecuyer)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandRealLecuyer
#endif
        implicit none
        integer(IK), intent(inout) :: idum
        integer(IK), parameter     :: im1=2147483563, im2=2147483399, imm1=im1-1, ia1=40014, ia2=40692
        integer(IK), parameter     :: iq1=53668, iq2=52774, ir1=12211, ir2=3791, ntab=32, ndiv=1+imm1/ntab
        real(RK)   , parameter     :: am=1._RK/real(im1,kind=RK), eps=1.2e-7_RK, rnmx=1._RK-eps
        real(RK)                   :: randRealLecuyer
        integer(IK)                :: idum2,j,k,iv(ntab),iy
        save                       :: iv, iy, idum2
        data idum2/123456789/, iv/ntab*0/, iy/0/
        if (idum <= 0) then
            idum = max(-idum,1)
            idum2 = idum
            do j = ntab+8,1,-1
                k = idum/iq1
                idum = ia1*(idum-k*iq1)-k*ir1
                if (idum < 0) idum = idum+im1
                if (j <= ntab) iv(j) = idum
            end do
            iy = iv(1)
        endif
        k = idum/iq1
        idum = ia1*(idum-k*iq1)-k*ir1
        if (idum < 0) idum=idum+im1
        k = idum2/iq2
        idum2 = ia2*(idum2-k*iq2)-k*ir2
        if (idum2 < 0) idum2=idum2+im2
        j = 1+iy/ndiv
        iy = iv(j)-idum2
        iv(j) = idum
        if(iy < 1)iy = iy+imm1
        randRealLecuyer = min(am*iy,rnmx)
    end function getRandRealLecuyer

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return an integer uniformly-distributed random integer-valued number in the range `[lowerBound , upperBound]`.
    !>
    !> \param[in]       lowerBound  :   The inclusive integer lower bound of the integer uniform distribution.
    !> \param[in]       upperBound  :   The inclusive integer upper bound of the integer uniform distribution.
    !> \param[inout]    idum        :   The input integer random seed with the `save` attribute.
    !>
    !> \return
    !> `randRealLecuyer`    : A uniformly-distributed random integer-valued number in the range `[lowerBound , upperBound]`.
    !>
    !> \warning
    !> Do not change the value of `idum` between calls.
    !>
    !> \remark
    !> This routine is guaranteed to random numbers with priodicity larger than `~2*10**18` random numbers.
    !> For more info see Press et al. (1990) Numerical Recipes.
    !>
    !> \remark
    !> This routine is solely kept for backward compatibility reasons.
    !> The [getRandInt](@ref getrandint) is recommended to be used against this routine.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandIntLecuyer(lowerBound,upperBound,idum)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandIntLecuyer
#endif
        implicit none
        integer(IK), intent(in)    :: lowerBound,upperBound
        integer(IK), intent(inout) :: idum
        integer(IK)                :: getRandIntLecuyer
        getRandIntLecuyer = lowerBound + nint( getRandRealLecuyer(idum)*real(upperBound-lowerBound,kind=RK) )
    end function getRandIntLecuyer

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return an integer uniformly-distributed random integer-valued number in the range `[lowerBound , upperBound]`.
    !>
    !> \param[in]       lowerBound  :   The lower bound of the integer uniform distribution.
    !> \param[in]       upperBound  :   The upper bound of the integer uniform distribution.
    !>
    !> \return
    !> `randInt` : A uniformly-distributed random integer-valued number in the range `[lowerBound , upperBound]`.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandInt(lowerBound,upperBound) result(randInt)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandInt
#endif
        implicit none
        integer(IK), intent(in) :: lowerBound,upperBound
        real(RK)                :: dummy
        integer(IK)             :: randInt
        call random_number(dummy)
        randInt = lowerBound + nint( dummy*real(upperBound-lowerBound,kind=RK) )
    end function getRandInt

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return an integer uniformly-distributed random integer-valued number in the range `[lowerBound , upperBound]` using
    !> the built-in random number generator of Fortran.
    !>
    !> \param[in]       lowerBound  :   The lower bound of the integer uniform distribution.
    !> \param[in]       upperBound  :   The upper bound of the integer uniform distribution.
    !>
    !> \return
    !> `randUniform`    : A uniformly-distributed random real-valued number in the range `[lowerBound , upperBound]`.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandUniform(lowerBound,upperBound) result(randUniform)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandUniform
#endif
        implicit none
        real(RK), intent(in)    :: lowerBound, upperBound
        real(RK)                :: randUniform
        call random_number(randUniform)
        randUniform = lowerBound + randUniform * (upperBound - lowerBound)
    end function getRandUniform

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a Gamma-distributed random number, following the prescription in the GSL library.
    !>
    !> \param[in]       alpha   :   The shape parameter of the Gamma distribution.
    !>
    !> \return
    !> `randGamma`    : A Gamma-distributed random real-valued number in the range `[0,+Infinity]`.
    !>
    !> \warning
    !> The condition `alpha > 0` must hold, otherwise the negative value `-1` will be returned to indicate the occurrence of error.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandGamma(alpha) result(randGamma)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandGamma
#endif
        implicit none
        real(RK), intent(in) :: alpha
        real(RK)             :: randGamma
        real(RK)             :: c,u,v,z
        if (alpha<=0._RK) then  ! illegal value of alpha
            randGamma = -1._RK
            return
        else
            randGamma = alpha
            if (randGamma<1._RK) randGamma = randGamma + 1._RK
            randGamma = randGamma - 0.3333333333333333_RK
            c = 3._RK*sqrt(randGamma)
            c = 1._RK / c
            do
                do
                    z = getRandGaus()
                    v = 1._RK + c*z
                    if (v<=0._RK) cycle
                    exit
                end do
                v = v**3
                call random_number(u)
                if ( log(u) >= 0.5_RK * z**2 + randGamma * ( 1._RK - v + log(v) ) ) cycle
                randGamma = randGamma * v
                exit
            end do
            if (alpha<1._RK) then
                call random_number(u)
                randGamma = randGamma * u**(1._RK/alpha)
            end if
        end if
    end function getRandGamma

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a Gamma-distributed random number, whose shape parameter `alpha` is an integer.
    !>
    !> \param[in]       alpha   :   The shape integer parameter of the Gamma distribution.
    !>
    !> \return
    !> `randGamma`    : A Gamma-distributed random real-valued number in the range `[0,+Infinity]`.
    !>
    !> \warning
    !> The condition `alpha > 1` must hold, otherwise the negative value `-1` will be returned to indicate the occurrence of error.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandGammaIntShape(alpha) result(randGamma)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandGammaIntShape
#endif
        implicit none
        integer(IK), intent(in) :: alpha
        real(RK)                :: randGamma
        real(RK)                :: am,e,h,s,x,y,Vector(2),Array(5)
        if (alpha < 1) then  ! illegal value of alpha
            randGamma = -1._RK
            return
        elseif (alpha < 6) then
            call random_number(Array(1:alpha))
            x = -log(product(Array(1:alpha)))
        else    ! use rejection sampling
            do
                call random_number(Vector)
                Vector(2) = 2._RK*Vector(2)-1._RK
                if (dot_product(Vector,Vector) > 1._RK) cycle
                y = Vector(2) / Vector(1)
                am = alpha - 1
                s = sqrt(2._RK*am + 1._RK)
                x = s*y + am
                if (x <= 0.0) cycle
                e = (1._RK+y**2) * exp(am*log(x/am)-s*y)
                call random_number(h)
                if (h <= e) exit
            end do
        end if
        randGamma = x
    end function getRandGammaIntShape

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a random Beta-distributed variable.
    !>
    !> \param[in]       alpha   :   The first shape parameter of the Beta distribution.
    !> \param[in]       beta    :   The second shape parameter of the Beta distribution.
    !>
    !> \return
    !> `randBeta`   : A Beta-distributed random real-valued number in the range `[0,1]`.
    !>
    !> \warning
    !> The conditions `alpha > 0` and `beta > 0` must hold, otherwise the negative
    !> value `-1` will be returned to indicate the occurrence of error.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandBeta(alpha,beta) result(randBeta)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandBeta
#endif
        implicit none
        real(RK), intent(in) :: alpha,beta
        real(RK)             :: randBeta
        real(RK)             :: x
        if ( alpha>0._RK .and. beta>0._RK ) then
            x = getRandGamma(alpha)
            randBeta = x / ( x + getRandGamma(beta) )
        else ! illegal value of alpha or beta
            randBeta = -1._RK
        end if
    end function getRandBeta

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a random Exponential-distributed value whose inverse mean is given as input.
    !>
    !> \param[in]   invMean :   The inverse of the mean of the Exponential distribution.
    !>
    !> \return
    !> `randExp` : An Exponential-distributed random real-valued number in the range `[0,+Infinity]` with mean `1 / invMean`.
    !>
    !> \warning
    !> It is the user's onus to ensure `invMean > 0` on input. This condition will NOT be checked by this routine.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandExpWithInvMean(invMean) result(randExp)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandExpWithInvMean
#endif
        implicit none
        real(RK), intent(in)    :: invMean
        real(RK)                :: randExp
        call random_number(randExp)
        randExp = -log(randExp) * invMean
    end function getRandExpWithInvMean

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a random Exponential-distributed value whose mean is \f$\lambda = 1\f$.
    !>
    !> \return
    !> `randExp` : A random Exponential-distributed value whose mean \f$\lambda = 1\f$.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandExp() result(randExp)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandExp
#endif
        implicit none
        real(RK) :: randExp
        call random_number(randExp)
        randExp = -log(randExp)
    end function getRandExp

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a random correlation matrix.
    !>
    !> \param[in]   nd  :   The rank of the correlation matrix.
    !> \param[in]   eta :   The parameter that roughly represents the shape parameters of the Beta distribution.
    !>                      The larger the value of `eta` is, the more homogeneous the correlation matrix will look.
    !>                      In other words, set this parameter to some small number to generate strong random correlations
    !>                      in the output random correlation matrix.
    !>
    !> \return
    !> `RandCorMat` : A random correlation matrix.
    !>
    !> \warning
    !> The conditions `nd > 1` and `eta > 0.0` must hold, otherwise the first element of
    !> output, `getRandCorMat(1,1)`, will be set to `-1` to indicate the occurrence of an error.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandCorMat(nd,eta) result(RandCorMat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandCorMat
#endif
        use Matrix_mod, only: getCholeskyFactor
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: eta
        real(RK)                :: RandCorMat(nd,nd), dummy
        real(RK)                :: beta,sumSqDummyVec,DummyVec(nd-1),W(nd-1),Diagonal(nd-1)
        integer(IK)             :: m,j,i

        if (nd<2_IK .or. eta<=0._RK) then  ! illegal value for eta.
            RandCorMat(1,1) = -1._RK
            return
        end if

        do m = 1,nd
            RandCorMat(m,m) = 1._RK
        end do
        beta = eta + 0.5_RK*(nd-2._RK)
        dummy = getRandBeta(beta,beta)
        if (dummy<=0._RK .or. dummy>=1._RK) then
            error stop
            !call abortProgram( output_unit , 1 , 1 , 'Statitistics@getRandCorMat() failed. Random Beta variable out of bound: ' // num2str(dummy) )
        end if
        RandCorMat(1,2) = 2._RK * dummy - 1._RK ! for the moment, only the upper half of RandCorMat is needed, the lower half will contain cholesky lower triangle.

        do m = 2,nd-1
            beta = beta - 0.5_RK
            sumSqDummyVec = 0._RK
            do j=1,m
                DummyVec(j) = getRandGaus()
                sumSqDummyVec = sumSqDummyVec + DummyVec(j)**2
            end do
            DummyVec(1:m) = DummyVec(1:m) / sqrt(sumSqDummyVec)   ! DummyVec is now a uniform random point from inside of m-sphere
            dummy = getRandBeta(0.5e0_RK*m,beta)
            W(1:m) = sqrt(dummy) * DummyVec(1:m)
            call getCholeskyFactor(m,RandCorMat(1:m,1:m),Diagonal(1:m))
            if (Diagonal(1)<0._RK) then
                error stop
                !call abortProgram( output_unit , 1 , 1 , 'Statitistics@getRandCorMat()@getCholeskyFactor() failed.' )
            end if
            DummyVec(1:m) = 0._RK
            do j = 1,m
                DummyVec(j) = DummyVec(j) + Diagonal(j) * W(j)
                do i = j+1,m
                    DummyVec(i) = DummyVec(i) + RandCorMat(i,j) * DummyVec(j)
                end do
            end do
            RandCorMat(1:m,m+1) = DummyVec(1:m)
        end do
        do i=1,nd-1
            RandCorMat(i+1:nd,i) = RandCorMat(i,i+1:nd)
        end do
  end function getRandCorMat

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

!  function getRandCorMat(nd,eta)    ! based on the idea of LKJ (2007). But there is something wrong with this routine
!    use Matrix_mod, only: getCholeskyFactor
!    implicit none
!    !integer, intent(in) :: nd,eta
!    integer, intent(in) :: nd
!    real(RK), intent(in) :: eta
!    integer :: m,mNew,j,i
!    real(RK) :: getRandCorMat(nd,nd), dummy, failureCounter
!    real(RK) :: beta,sumSqDummyVec,DummyVec(nd-1),W(nd-1),Diagonal(nd-1)
!
!    if (nd<2 .or. eta<=0._RK) then  ! illegal value for eta. set getRandCorMat=0, return
!      getRandCorMat = -1._RK
!      return
!    end if
!
!    do m = 1,nd
!      getRandCorMat(m,m) = 1._RK
!    end do
!    beta = eta + 0.5_RK*(nd-2._RK)
!
!    do
!      dummy = getRandBeta(beta,beta)
!      if (dummy>0._RK .and. dummy<1._RK) exit
!      write(*,*) "**Warning** random Beta variable out of bound.", dummy
!      write(*,*) "Something is wrong with getRandBeta()."
!      cycle
!    end do
!    getRandCorMat(1,2) = 2._RK * dummy - 1._RK    ! for the moment, only the upper half of getRandCorMat is needed, the lower half will contain cholesky lower triangle.
!
!    m = 2
!    call getCholeskyFactor(m,getRandCorMat(1:m,1:m),Diagonal(1:m))
!
!    failureCounter = 0
!    onionLayer: do
!
!      beta = beta - 0.5_RK
!
!      sumSqDummyVec = 0._RK
!      do j=1,m
!        DummyVec(j) = getRandGaus()
!        sumSqDummyVec = sumSqDummyVec + DummyVec(j)**2
!      end do
!      DummyVec(1:m) = DummyVec(1:m) / sqrt(sumSqDummyVec)   ! DummyVec is now a uniform random point from inside of m-sphere
!
!      mNew = m + 1
!      posDefCheck: do
!
!        do
!          dummy = getRandBeta(0.5_RK*m,beta)
!          if (dummy>0._RK .and. dummy<1._RK) exit
!          write(*,*) "**Warning** random Beta variable out of bound.", dummy
!          write(*,*) "Something is wrong with getRandBeta()."
!          read(*,*)
!          cycle
!        end do
!        W(1:m) = sqrt(dummy) * DummyVec(1:m)
!
!        getRandCorMat(1:m,mNew) = 0._RK
!        do j = 1,m
!          getRandCorMat(j,mNew) = getRandCorMat(j,mNew) + Diagonal(j) * W(j)
!          do i = j+1,m
!            getRandCorMat(i,mNew) = getRandCorMat(i,mNew) + getRandCorMat(i,j) * getRandCorMat(j,mNew)
!          end do
!        end do
!
!
!        call getCholeskyFactor(mNew,getRandCorMat(1:mNew,1:mNew),Diagonal(1:mNew))  ! Now check if the new matrix is positive-definite, then proceed with the next layer
!        if (Diagonal(1)<0._RK) then
!          failureCounter = failureCounter + 1
!          cycle posDefCheck
!          !write(*,*) "Cholesky factorization failed in getRandCorMat()."
!          !write(*,*) m
!          !write(*,*) getRandCorMat(1:m,1:m)
!          !stop
!        end if
!        exit posDefCheck
!
!      end do posDefCheck
!
!      if (mNew==nd) exit onionLayer
!      m = mNew
!
!    end do onionLayer
!
!    if (failureCounter>0) write(*,*) 'failureRatio: ', dble(failureCounter)/dble(nd-2)
!    do i=1,nd-1
!      getRandCorMat(i+1:nd,i) = getRandCorMat(i,i+1:nd)
!    end do
!
!  end function getRandCorMat

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Returns a random correlation matrix using Monte Carlo rejection method.
    !>
    !> \param[in]   nd      :   The rank of the correlation matrix.
    !> \param[in]   minRho  :   The minimum correlation coefficient to be expected in the output random correlation matrix.
    !> \param[in]   maxRho  :   The maximum correlation coefficient to be expected in the output random correlation matrix.
    !>
    !> \return
    !> `RandCorMat` : A random correlation matrix. Only the upper half of
    !> `RandCorMat` is the correlation matrix, lower half is NOT set on output.
    !>
    !> \warning
    !> The conditions `nd >= 1` must hold.
    !>
    !> \remark
    !> This subroutine is very slow for high matrix dimensions ( `nd >~ 10` ).
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getRandCorMatRejection(nd,minRho,maxRho) result(RandCorMat)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getRandCorMatRejection
#endif
        use Matrix_mod, only: isPosDef
        implicit none
        integer(IK), intent(in) :: nd
        real(RK)   , intent(in) :: minRho,maxRho
        real(RK)                :: RandCorMat(nd,nd), RhoVec(nd*(nd-1))
        integer(IK)             :: i,j,irho
        if (maxRho<minRho .or. nd<1) then
            error stop
            !call abortProgram( output_unit , 1 , 1 , 'Statitistics@getRandCorMatRejection() failed: Invalid input values.' )
        end if
        if (nd==1_IK) then
          RandCorMat = 1._RK
        else
            rejection: do
                call random_number(RhoVec)
                RhoVec = minRho + RhoVec*(maxRho-minRho)
                irho = 0
                do j=1,nd
                    RandCorMat(j,j) = 1._RK
                    do i=1,j-1
                        irho = irho + 1
                        RandCorMat(i,j) = RhoVec(irho)
                    end do
                end do
                if (isPosDef(nd,RandCorMat)) exit rejection
                cycle rejection
            end do rejection
        end if
        do j=1,nd-1
            RandCorMat(j+1:nd,j) = RandCorMat(j,j+1:nd)
        end do
  end function getRandCorMatRejection

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Convert the upper-triangle covariance matrix to the upper-triangle correlation matrix.
    !>
    !> \param[in]   nd          :   The rank of the covariance matrix.
    !> \param[in]   CovMatUpper :   The upper-triangle covariance matrix. The lower-triangle will not be used.
    !>
    !> \return
    !> `CorMatUpper` : An upper-triangle correlation matrix. The lower-triangle will NOT be set.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getUpperCorMatFromUpperCovMat(nd,CovMatUpper) result(CorMatUpper)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getUpperCorMatFromUpperCovMat
#endif
        implicit none
        integer(IK)  , intent(in) :: nd
        real(RK)     , intent(in) :: CovMatUpper(nd,nd)
        real(RK)                  :: CorMatUpper(nd,nd)
        real(RK)                  :: InverseStdVec(nd)
        integer(IK)               :: i,j
        do j=1,nd
            InverseStdVec(j) = 1._RK / sqrt(CovMatUpper(j,j))
            do i=1,j
                CorMatUpper(i,j) = CovMatUpper(i,j) * InverseStdVec(j) * InverseStdVec(i)
            end do
        end do
    end function getUpperCorMatFromUpperCovMat

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Convert the upper-triangle correlation matrix to the upper-triangle covariance matrix.
    !>
    !> \param[in]   nd          :   The rank of the correlation matrix.
    !> \param[in]   StdVec      :   The input standard deviation vector of length `nd`.
    !> \param[in]   CorMatUpper :   The upper-triangle correlation matrix. The lower-triangle will not be used.
    !>
    !> \return
    !> `CovMatUpper` : An upper-triangle covariance matrix. The lower-triangle will NOT be set.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getUpperCovMatFromUpperCorMat(nd,StdVec,CorMatUpper) result(CovMatUpper)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getUpperCovMatFromUpperCorMat
#endif
        implicit none
        integer(IK)  , intent(in) :: nd
        real(RK)     , intent(in) :: StdVec(nd), CorMatUpper(nd,nd)
        real(RK)                  :: CovMatUpper(nd,nd)
        integer(IK)               :: i,j
        do j=1,nd
            do i=1,j
                CovMatUpper(i,j) = CorMatUpper(i,j) * StdVec(j) * StdVec(i)
            end do
        end do
    end function getUpperCovMatFromUpperCorMat

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Convert the lower-triangle correlation matrix to the upper-triangle covariance matrix.
    !>
    !> \param[in]   nd          :   The rank of the correlation matrix.
    !> \param[in]   StdVec      :   The input standard deviation vector of length `nd`.
    !> \param[in]   CorMatLower :   The lower-triangle correlation matrix. The upper-triangle will not be used.
    !>
    !> \return
    !> `CovMatUpper` : An upper-triangle covariance matrix. The lower-triangle will NOT be set.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getUpperCovMatFromLowerCorMat(nd,StdVec,CorMatLower) result(CovMatUpper)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getUpperCovMatFromLowerCorMat
#endif
        implicit none
        integer(IK)  , intent(in) :: nd
        real(RK)     , intent(in) :: StdVec(nd), CorMatLower(nd,nd)
        real(RK)                  :: CovMatUpper(nd,nd)
        integer(IK)               :: i,j
        do j=1,nd
            CovMatUpper(j,j) = StdVec(j)**2
            do i=1,j-1
                CovMatUpper(i,j) = CorMatLower(j,i) * StdVec(j) * StdVec(i)
            end do
        end do
    end function getUpperCovMatFromLowerCorMat

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Convert the upper-triangle correlation matrix to the lower-triangle covariance matrix.
    !>
    !> \param[in]   nd          :   The rank of the correlation matrix.
    !> \param[in]   StdVec      :   The input standard deviation vector of length `nd`.
    !> \param[in]   CorMatUpper :   The upper-triangle correlation matrix. The lower-triangle will not be used.
    !>
    !> \return
    !> `CovMatLower` : An lower-triangle covariance matrix. The upper-triangle will NOT be set.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getLowerCovMatFromUpperCorMat(nd,StdVec,CorMatUpper) result(CovMatLower)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLowerCovMatFromUpperCorMat
#endif
        implicit none
        integer(IK)  , intent(in) :: nd
        real(RK)     , intent(in) :: StdVec(nd), CorMatUpper(nd,nd)
        real(RK)                  :: CovMatLower(nd,nd)
        integer(IK)               :: i,j
        do j=1,nd
            CovMatLower(j,j) = StdVec(j)**2
            do i=1,j-1
                CovMatLower(j,i) = CorMatUpper(i,j) * StdVec(j) * StdVec(i)
            end do
        end do
    end function getLowerCovMatFromUpperCorMat

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Convert the lower-triangle correlation matrix to the lower-triangle covariance matrix.
    !>
    !> \param[in]   nd          :   The rank of the correlation matrix.
    !> \param[in]   StdVec      :   The input standard deviation vector of length `nd`.
    !> \param[in]   CorMatLower :   The lower-triangle correlation matrix. The upper-triangle will not be used.
    !>
    !> \return
    !> `CovMatLower` : An lower-triangle covariance matrix. The upper-triangle will NOT be set.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getLowerCovMatFromLowerCorMat(nd,StdVec,CorMatLower) result(CovMatLower)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLowerCovMatFromLowerCorMat
#endif
        implicit none
        integer(IK)  , intent(in) :: nd
        real(RK)     , intent(in) :: StdVec(nd), CorMatLower(nd,nd)
        real(RK)                  :: CovMatLower(nd,nd)
        integer(IK)               :: i,j
        do j=1,nd
            CovMatLower(j,j) = StdVec(j)**2
            do i=1,j-1
                CovMatLower(j,i) = CorMatLower(j,i) * StdVec(j) * StdVec(i)
            end do
        end do
    end function getLowerCovMatFromLowerCorMat

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Convert the input correlation matrix to the output covariance matrix.
    !>
    !> \param[in]   nd          :   The rank of the correlation matrix.
    !> \param[in]   StdVec      :   The input standard deviation vector of length `nd`.
    !> \param[in]   CorMatUpper :   The upper-triangle correlation matrix. The lower-triangle will not be used.
    !>
    !> \return
    !> `CovMatFull` : The full covariance matrix.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getCovMatFromCorMatUpper(nd,StdVec,CorMatUpper) result(CovMatFull)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getCovMatFromCorMatUpper
#endif
        implicit none
        integer(IK)  , intent(in) :: nd
        real(RK)     , intent(in) :: StdVec(nd), CorMatUpper(nd,nd)   ! only upper half needed
        real(RK)                  :: CovMatFull(nd,nd)
        integer(IK)               :: i,j
        do j=1,nd
            CovMatFull(j,j) = StdVec(j)**2
            do i=1,j-1
                CovMatFull(i,j) = CorMatUpper(i,j) * StdVec(j) * StdVec(i)
                CovMatFull(j,i) = CovMatFull(i,j)
            end do
        end do
    end function getCovMatFromCorMatUpper

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the Geometric distribution PDF values for a range of trials, starting at index `1`.
    !> If the probability of success on each trial is `successProb`, then the probability that
    !> the `k`th trial (out of `k` trials) is the first success is `GeoLogPDF(k)`.
    !>
    !> \param[in]   successProb     :   The probability of success.
    !> \param[in]   logPdfPrecision :   The precision value below which the PDF is practically considered to be zero (optional).
    !> \param[in]   minSeqLen       :   The minimum length of the range of `k` values for which the PDF will be computed (optional).
    !> \param[in]   seqLen          :   The length of the range of `k` values for which the PDF will be computed (optional).
    !>                                  If provided, it will overwrite the the output sequence length as inferred from
    !>                                  the combination of `minSeqLen` and `logPdfPrecision`.
    !>
    !> \return
    !> `GeoLogPDF`  :   An allocatable representing the geometric PDF over a range of `k` values, whose length is
    !>                  `seqLen`, or if not provided, is determined from the values of `logPdfPrecision` and `minSeqLen`.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getGeoLogPDF_old(successProb,logPdfPrecision,minSeqLen,seqLen) result(GeoLogPDF)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getGeoLogPDF_old
#endif
        use Constants_mod, only: IK, RK
        implicit none
        real(RK)    , intent(in)            :: successProb
        real(RK)    , intent(in), optional  :: logPdfPrecision
        integer(IK) , intent(in), optional  :: minSeqLen
        integer(IK) , intent(in), optional  :: seqLen
        real(RK)    , allocatable           :: GeoLogPDF(:)
        real(RK)    , parameter             :: LOG_PDF_PRECISION = log(0.001_RK)
        real(RK)                            :: logProbFailure
        integer(IK)                         :: lenGeoLogPDF, i
        logProbFailure = log(1._RK - successProb)
        if (present(seqLen)) then
            lenGeoLogPDF = seqLen
        else
            if (present(logPdfPrecision)) then
                lenGeoLogPDF = ceiling(  logPdfPrecision / logProbFailure)
            else
                lenGeoLogPDF = ceiling(LOG_PDF_PRECISION / logProbFailure)
            end if
            if (present(minSeqLen)) lenGeoLogPDF = max(minSeqLen,lenGeoLogPDF)
        end if
        allocate(GeoLogPDF(lenGeoLogPDF))
        GeoLogPDF(1) = log(successProb)
        do i = 2, lenGeoLogPDF
            GeoLogPDF(i) = GeoLogPDF(i-1) + logProbFailure
        end do
    end function getGeoLogPDF_old

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the Geometric distribution PDF values for the input number of trials,
    !> the trials at which first success happens, and the success probability.
    !>
    !> \param[in]   numTrial    :   The number of trials.
    !> \param[in]   SuccessStep :   The vector of trials of length `numTrial` at which the first success happens.
    !> \param[in]   successProb :   The probability of success.
    !>
    !> \return
    !> `LogProbGeo` :   An output vector of length `numTrial` representing the geometric PDF values.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getLogProbGeo(numTrial, SuccessStep, successProb) result(LogProbGeo)
        use Constants_mod, only: IK, RK
        implicit none
        integer(IK) , intent(in)    :: numTrial
        integer(IK) , intent(in)    :: SuccessStep(numTrial)
        real(RK)    , intent(in)    :: successProb
        real(RK)                    :: LogProbGeo(numTrial)
        real(RK)                    :: logProbSuccess, logProbFailure
        logProbSuccess = log(successProb)
        logProbFailure = log(1._RK - successProb)
        LogProbGeo = logProbSuccess + (SuccessStep-1_IK) * logProbFailure
    end function getLogProbGeo

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a fit of the Geometric distribution PDF to the input natural logarithm of a sequence of Counts,
    !> the `i`th element of which represents the number of successes after `SuccessStep(i)` tries in a Bernoulli trail.
    !>
    !> \param[in]   numTrial    :   The number of trials. The length of the input vector `LogCount`.
    !> \param[in]   SuccessStep :   The vector of trials of length `numTrial` at which the first success happens.
    !> \param[in]   LogCount    :   A vector of real values representing the natural logarithms of the counts
    !>                              of success at each Bernoulli trial, sequentially, from `1` to `numTrial`.
    !>
    !> \return
    !> `PowellMinimum`  :   An object of class [PowellMinimum_type](@ref optimization_mod::powellminimum_type) containing
    !>                      the best-fit successProb and the normalization constant of the fit in the vector component `xmin`.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function fitGeoLogPDF_old(numTrial, SuccessStep, LogCount) result(PowellMinimum)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: fitGeoLogPDF_old
#endif
        use Optimization_mod, only: PowellMinimum_type
        use Constants_mod, only: IK, RK, POSINF_RK, NEGINF_RK
        implicit none
        integer(IK) , intent(in)    :: numTrial
        integer(IK) , intent(in)    :: SuccessStep(numTrial)
        real(RK)    , intent(in)    :: LogCount(numTrial)
        type(PowellMinimum_type)    :: PowellMinimum

        real(RK)                    :: BestFitSuccessProbNormFac(2) ! vector of the two parameters
        real(RK)    , parameter     :: SUCCESS_PROB_INIT_GUESS = 0.23_RK
        real(RK)    , parameter     :: FISHER_TRANS_SUCCESS_PROB_INIT_GUESS = atanh(2*(SUCCESS_PROB_INIT_GUESS - 0.5_RK))

        ! do Fisher transformation to make the limits infinity
        BestFitSuccessProbNormFac = [FISHER_TRANS_SUCCESS_PROB_INIT_GUESS, LogCount(1)]

        PowellMinimum = PowellMinimum_type  ( ndim = 2_IK &
                                            , getFuncMD = getSumDistSq &
                                            , StartVec = BestFitSuccessProbNormFac &
                                            )
        if (PowellMinimum%Err%occurred) return
        PowellMinimum%xmin(1) = 0.5_RK * tanh(PowellMinimum%xmin(1)) + 0.5_RK ! reverse Fisher-transform

    contains

        function getSumDistSq(ndim,successProbFisherTransNormFac) result(sumDistSq)
            !use Constants_mod, only: IK, RK
            implicit none
            integer(IK) , intent(in)    :: ndim
            real(RK)    , intent(in)    :: successProbFisherTransNormFac(ndim)
            real(RK)                    :: sumDistSq, successProb
            successProb = 0.5_RK*tanh(successProbFisherTransNormFac(1)) + 0.5_RK ! reverse Fisher-transform
            !sumDistSq = sum( (LogCount - getGeoLogPDF(successProb=successProb,seqLen=numTrial) - successProbFisherTransNormFac(2) )**2 )
            sumDistSq = sum(    ( LogCount &
                                - numTrial * successProbFisherTransNormFac(2) &
                                - getLogProbGeo(numTrial = numTrial, SuccessStep = SuccessStep, successProb = successProb) &
                                )**2 &
                            )
        end function getSumDistSq

    end function fitGeoLogPDF_old

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Compute the natural logarithm of the Geometric distribution PDF of a limited range of Bernoulli trials,
    !> starting at index `1` up to `maxNumTrial`. In other words, upon reaching the trial `maxNumTrial`,
    !> the Bernoulli trials count restart from index `1`. This Cyclic Geometric distribution is
    !> particularly useful in the parallelization studies of Monte Carlo simulation.
    !>
    !> \param[in]   successProb :   The probability of success.
    !> \param[in]   maxNumTrial :   The maximum number of trails possible.
    !>                              After `maxNumTrial` tries, the Geometric distribution restarts from index `1`.
    !> \param[in]   numTrial    :   The length of the array `SuccessStep`. Note that `numTrial < maxNumTrial` must hold.
    !> \param[in]   SuccessStep :   A vector of length `(1:numTrial)` of integers that represent
    !>                              the steps at which the Bernoulli successes occur.
    !>
    !> \return
    !> `LogProbGeoCyclic`       :   A real-valued vector of length `(1:numTrial)` whose values represent the probabilities
    !>                              of having Bernoulli successes at the corresponding SuccessStep values.
    !>
    !> \warning
    !> Any value of SuccessStep must be an integer numbers between `1` and `maxNumTrial`.
    !> The onus is on the user to ensure this condition holds.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getLogProbGeoCyclic(successProb,maxNumTrial,numTrial,SuccessStep) result(LogProbGeoCyclic)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getLogProbGeoCyclic
#endif
        use Constants_mod, only: IK, RK, NEGLOGINF_RK
        implicit none
        real(RK)    , intent(in)    :: successProb
        integer(IK) , intent(in)    :: maxNumTrial
        integer(IK) , intent(in)    :: numTrial
        integer(IK) , intent(in)    :: SuccessStep(numTrial)
        real(RK)                    :: LogProbGeoCyclic(numTrial)
        real(RK)                    :: failureProb, logProbSuccess, logProbFailure, logDenominator, exponentiation
        integer(IK)                 :: i
        if (successProb>0._RK .and. successProb<1._RK) then
            failureProb = 1._RK - successProb
            logProbSuccess = log(successProb)
            logProbFailure = log(failureProb)
            exponentiation = maxNumTrial * logProbFailure
            if (exponentiation<NEGLOGINF_RK) then
                logDenominator = 0._RK
            else
                logDenominator = log(1._RK-exp(exponentiation))
            end if
            LogProbGeoCyclic = logProbSuccess + (SuccessStep-1) * logProbFailure - logDenominator
        elseif (successProb==0._RK) then
            LogProbGeoCyclic = -log(real(maxNumTrial,kind=RK))
        elseif (successProb==1._RK) then
            LogProbGeoCyclic(1) = 0._RK
            LogProbGeoCyclic(2:numTrial) = NEGLOGINF_RK
        else
            LogProbGeoCyclic = NEGLOGINF_RK
        end if
    end function getLogProbGeoCyclic

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return a fit of the Cyclic Geometric distribution PDF to the input natural logarithm of a sequence of Counts,
    !> the `i`th element of which represents the number of successes after `SuccessStep(i)` tries in a Bernoulli trail.
    !>
    !> \param[in]   maxNumTrial :   The maximum number of trails possible. After `maxNumTrial` tries,
    !                               the Geometric distribution restarts from index `1`.
    !> \param[in]   numTrial    :   The length of the array `SuccessStep` and `LogCount`.
    !>                              Note that `numTrial < maxNumTrial` must hold.
    !> \param[in]   SuccessStep :   A vector of length `(1:numTrial)` of integers that represent
    !>                              the steps at which the Bernoulli successes occur.
    !> \param[in]   LogCount    :   A real-valued vector of length `(1:numTrial)` representing the natural logarithms of the
    !>                              counts of success at the corresponding Bernoulli trials specified by elements of `SuccessStep`.
    !>
    !> \return
    !> `PowellMinimum`          :   An object of class [PowellMinimum_type](@ref optimization_mod::powellminimum_type) containing
    !>                              the best-fit successProb and the normalization constant of the fit in the vector component `xmin`.
    !>
    !> \warning
    !> Any value of SuccessStep must be an integer numbers between `1` and `maxNumTrial`.
    !> The onus is on the user to ensure this condition holds.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function fitGeoCyclicLogPDF(maxNumTrial, numTrial, SuccessStep, LogCount) result(PowellMinimum)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: fitGeoLogPDF
#endif
        use Optimization_mod, only: PowellMinimum_type
        use Constants_mod, only: IK, RK, POSINF_RK, NEGINF_RK
        implicit none
        integer(IK) , intent(in)    :: maxNumTrial
        integer(IK) , intent(in)    :: numTrial
        integer(IK) , intent(in)    :: SuccessStep(numTrial)
        real(RK)    , intent(in)    :: LogCount(numTrial)
        type(PowellMinimum_type)    :: PowellMinimum

        real(RK)                    :: BestFitSuccessProbNormFac(2) ! vector of the two parameters
        real(RK)    , parameter     :: SUCCESS_PROB_INIT_GUESS = 0.23_RK
        real(RK)    , parameter     :: FISHER_TRANS_SUCCESS_PROB_INIT_GUESS = atanh(2*(SUCCESS_PROB_INIT_GUESS - 0.5_RK))

        ! do Fisher transformation to make the limits infinity.
        BestFitSuccessProbNormFac = [FISHER_TRANS_SUCCESS_PROB_INIT_GUESS, 0._RK] ! LogCount(1)]

        PowellMinimum = PowellMinimum_type  ( ndim = 2_IK &
                                            , getFuncMD = getSumDistSq &
                                            , StartVec = BestFitSuccessProbNormFac &
                                            )
        if (PowellMinimum%Err%occurred) return
        PowellMinimum%xmin(1) = 0.5_RK * tanh(PowellMinimum%xmin(1)) + 0.5_RK ! reverse Fisher-transform

    contains

        pure function getSumDistSq(ndim,successProbFisherTransNormFac) result(sumDistSq)
            !use Constants_mod, only: IK, RK
            implicit none
            integer(IK) , intent(in)    :: ndim
            real(RK)    , intent(in)    :: successProbFisherTransNormFac(ndim)
            real(RK)                    :: sumDistSq, successProb
            successProb = 0.5_RK * tanh(successProbFisherTransNormFac(1)) + 0.5_RK ! reverse Fisher-transform
            !sumDistSq = sum( (LogCount - getGeoLogPDF(successProb=successProb,seqLen=numTrial) - successProbFisherTransNormFac(2) )**2 )
            sumDistSq = sum(    ( LogCount &
                                - getLogProbGeoCyclic(successProb=successProb, maxNumTrial=maxNumTrial, numTrial=numTrial, SuccessStep=SuccessStep) &
                                - successProbFisherTransNormFac(2) &
                                )**2 &
                            )
        end function getSumDistSq

    end function fitGeoCyclicLogPDF

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the standard normal distribution PDF value.
    !>
    !> \param[in]   z   :   The input value at which the PDF will be computed.
    !>
    !> \return
    !> `snormPDF`   :   The standard normal distribution PDF value.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getSNormPDF(z) result(snormPDF)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getSNormPDF
#endif
        use Constants_mod, only: INVSQRT2PI
        implicit none
        real(RK), intent(in) :: z
        real(RK)             :: snormPDF
        snormPDF = INVSQRT2PI * exp( -0.5_RK*z**2 )
    end function getSNormPDF

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the non-standard normal distribution PDF value.
    !>
    !> \param[in]   mean        :   The mean of the Normal distribution.
    !> \param[in]   stdev       :   The standard deviation of the Normal distribution.
    !> \param[in]   variance    :   The variance of the Normal distribution.
    !> \param[in]   x           :   The point at which the PDF will be computed.
    !>
    !> \return
    !> `normPDF`   :   The normal distribution PDF value at the given input point.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getNormPDF(mean,stdev,variance,x) result(normPDF)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getNormPDF
#endif
        use Constants_mod, only: INVSQRT2PI
        implicit none
        real(RK), intent(in) :: mean,stdev,variance,x
        real(RK)             :: normPDF
        normPDF = INVSQRT2PI * exp( -(x-mean)**2/(2._RK*variance) ) / stdev
    end function getNormPDF

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the non-standard normal distribution Cumulative Probability Density function (CDF) value.
    !>
    !> \param[in]   mean        :   The mean of the Normal distribution.
    !> \param[in]   stdev       :   The standard deviation of the Normal distribution.
    !> \param[in]   x           :   The point at which the PDF will be computed.
    !>
    !> \return
    !> `normCDF`   :   The normal distribution CDF value at the given input point.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getNormCDF(mean,stdev,x) result(normCDF)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getNormCDF
#endif
        use Constants_mod, only: SPR,SQRT2
        implicit none
        real(RK), intent(in) :: mean,stdev,x
        real(RK)             :: normCDF
        normCDF = 0.5_RK * ( 1._RK + erf( real((x-mean)/(SQRT2*stdev),kind=SPR) ) )
    end function getNormCDF

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the standard normal distribution Cumulative Probability Density function (CDF) value.
    !>
    !> \param[in]   x           :   The point at which the PDF will be computed.
    !>
    !> \return
    !> `normCDF`   :   The normal distribution CDF value at the given input point.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getSNormCDF(x)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getSNormCDF
#endif
        use Constants_mod, only: SPR,SQRT2
        implicit none
        real(RK), intent(in) :: x
        real(RK)             :: getSNormCDF
        getSNormCDF = 0.5_RK * ( 1._RK + erf( real(x/SQRT2,kind=SPR) ) )
    end function getSNormCDF

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the Beta distribution Cumulative Probability Density function (CDF) value.
    !>
    !> \param[in]   alpha   :   The first shape parameter of the Beta distribution.
    !> \param[in]   beta    :   The second shape parameter of the Beta distribution.
    !> \param[in]   x       :   The point at which the CDF will be computed.
    !>
    !> \return
    !> `betaCDF`   :   The Beta distribution CDF value at the given input point.
    !>
    !> \warning
    !> If `x` is not in the range `[0,1]`, a negative value for `getBetaCDF` will be returned to indicate the occurrence of error.
    !>
    !> \todo
    !> The efficiency of this code can be improved by making `x` a vector on input.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getBetaCDF(alpha,beta,x) result(betaCDF)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getBetaCDF
#endif
        use Constants_mod, only : SPR
        implicit none
        real(RK), intent(in) :: alpha,beta,x
        real(RK)             :: bt
        real(RK)             :: betaCDF
        if (x < 0._RK .or. x > 1._RK) then
            betaCDF = -1._RK
            return
        end if
        if (x == 0._RK .or. x == 1._RK) then
            bt = 0._RK
        else
            bt = exp( log_gamma(real(alpha+beta,kind=SPR)) - log_gamma(real(alpha,kind=SPR)) - log_gamma(real(beta,kind=SPR)) &
               + alpha*log(x) + beta*log(1._RK-x) )
        end if
        if ( x < (alpha+1._RK) / (alpha+beta+2._RK) ) then
            betaCDF = bt * getBetaContinuedFraction(alpha,beta,x) / alpha
        else
            betaCDF = 1._RK - bt * getBetaContinuedFraction(beta,alpha,1._RK-x) / beta
        end if
    end function getBetaCDF

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the Beta Continued Fraction (BCF).
    !>
    !> \param[in]   alpha   :   The first shape parameter of the Beta distribution.
    !> \param[in]   beta    :   The second shape parameter of the Beta distribution.
    !> \param[in]   x       :   The point at which the BCF will be computed.
    !>
    !> \return
    !> `betaCDF`   :   The BCF value at the given input point.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    function getBetaContinuedFraction(alpha,beta,x)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getBetaContinuedFraction
#endif
        implicit none
        real(RK)   , intent(in) :: alpha,beta,x
        real(RK)   , parameter  :: eps = epsilon(x), fpmin = tiny(x)/eps
        integer(IK), parameter  :: maxit = 100
        real(RK)                :: aa,c,d,del,qab,qam,qap
        real(RK)                :: getBetaContinuedFraction
        integer(IK)             :: m,m2
        qab = alpha+beta
        qap = alpha+1._RK
        qam = alpha-1._RK
        c = 1._RK
        d = 1._RK-qab*x/qap
        if (abs(d) < fpmin) d = fpmin
        d = 1._RK/d
        getBetaContinuedFraction = d
        do m = 1,maxit
            m2 = 2*m
            aa = m*(beta-m)*x/((qam+m2)*(alpha+m2))
            d = 1._RK+aa*d
            if (abs(d) < fpmin) d = fpmin
            c = 1._RK+aa/c
            if (abs(c) < fpmin) c = fpmin
            d = 1._RK/d
            getBetaContinuedFraction = getBetaContinuedFraction*d*c
            aa = -(alpha+m)*(qab+m)*x/((alpha+m2)*(qap+m2))
            d = 1._RK+aa*d
            if (abs(d) < fpmin) d = fpmin
            c = 1._RK+aa/c
            if (abs(c) < fpmin) c = fpmin
            d = 1._RK/d
            del = d*c
            getBetaContinuedFraction = getBetaContinuedFraction*del
            if (abs(del-1._RK) <=  eps) exit
        end do
        if (m > maxit) then
            error stop
            !call abortProgram( output_unit , 1 , 1 , &
            !'Statitistics@getBetaContinuedFraction() failed: alpha or beta too big, or maxit too small.' )
        end if
    end function getBetaContinuedFraction

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the one-sample Kolmogorov–Smirnov (KS) test results.
    !>
    !> \param[in]       np      :   The number of points in the input vector `Point`.
    !> \param[inout]    Point   :   The sample. On return, this array will be sorted in Ascending order.
    !> \param[in]       getCDF  :   The function returning the Cumulative Distribution Function (CDF) of the sample.
    !> \param[out]      statKS  :   The KS test statistic.
    !> \param[out]      probKS  :   The `p`-value of the test, returned as a scalar value in the range `[0,1]`.
    !>                              The output `probKS` is the probability of observing a test statistic as extreme as,
    !>                              or more extreme than, the observed value under the null hypothesis.
    !>                              Small values of `probKS` cast doubt on the validity of the null hypothesis.
    !> \param[out]      Err     :   An object of class [Err_type](@ref err_mod::err_type) containing information
    !>                              about the occurrence of any error during the KS test computation.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    subroutine doKS1(np,Point,getCDF,statKS,probKS,Err)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: doKS1
#endif
        use Sort_mod, only : sortAscending
        use Err_mod, only: Err_type

        implicit none

        integer(IK)     , intent(in)    :: np
        real(RK)        , intent(out)   :: statKS,probKS
        real(RK)        , intent(inout) :: Point(np)
        type(Err_type)  , intent(out)   :: Err

        character(*)    , parameter     :: PROCEDURE_NAME = MODULE_NAME//"@doKS1"
        real(RK)                        :: npSqrt
        real(RK)                        :: cdf,cdfObserved,dt,frac
        integer(IK)                     :: j

        interface
            function getCDF(x)
                use Constants_mod, only: RK
                real(RK), intent(in) :: x
                real(RK)             :: getCDF
            end function getCDF
        end interface

        call sortAscending(np,Point,Err)
        if (Err%occurred) then
            Err%msg = PROCEDURE_NAME//Err%msg
            return
        end if

        statKS = 0._RK
        cdfObserved = 0._RK
        npSqrt = np
        do j = 1,np
            frac = j/npSqrt
            cdf = getCDF(Point(j))
            dt = max( abs(cdfObserved-cdf) , abs(frac-cdf) )
            if( dt > statKS ) statKS = dt
            cdfObserved = frac
        end do
        npSqrt = sqrt(npSqrt)
        probKS = getProbKS( (npSqrt+0.12_RK+0.11_RK/npSqrt)*statKS )

    end subroutine doKS1

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the one-sample Kolmogorov–Smirnov (KS) test results under the assumption that the
    !> points originate from a uniform distribution in [0,1]. So, all Point must be in [0,1] on input.
    !>
    !> \param[in]       np      :   The number of points in the input vector `Point`.
    !> \param[inout]    Point   :   The sample. On return, this array will be sorted in Ascending order.
    !> \param[out]      statKS  :   The KS test statistic.
    !> \param[out]      probKS  :   The `p`-value of the test, returned as a scalar value in the range `[0,1]`.
    !>                              The output `probKS` is the probability of observing a test statistic as extreme as,
    !>                              or more extreme than, the observed value under the null hypothesis.
    !>                              Small values of `probKS` cast doubt on the validity of the null hypothesis.
    !> \param[out]      Err     :   An object of class [Err_type](@ref err_mod::err_type) containing information
    !>                              about the occurrence of any error during the KS test computation.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure subroutine doUniformKS1(np,Point,statKS,probKS,Err)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: doUniformKS1
#endif
        use Sort_mod, only : sortAscending
        use Err_mod, only: Err_type

        implicit none

        integer(IK)     , intent(in)    :: np
        real(RK)        , intent(out)   :: statKS,probKS
        real(RK)        , intent(inout) :: Point(np)
        type(Err_type)  , intent(out)   :: Err

        character(*)    , parameter     :: PROCEDURE_NAME = MODULE_NAME//"@doUniformKS1"
        real(RK)                        :: npSqrt
        real(RK)                        :: cdf,cdfObserved,dt,frac
        integer(IK)                     :: j

        call sortAscending(np,Point,Err)
        if (Err%occurred) then
            Err%msg = PROCEDURE_NAME//Err%msg
            return
        end if

        statKS = 0._RK
        cdfObserved = 0._RK
        npSqrt = np
        do j = 1,np
            frac = j/npSqrt
            cdf = Point(j)
            dt = max( abs(cdfObserved-cdf) , abs(frac-cdf) )
            if( dt > statKS ) statKS = dt
            cdfObserved = frac
        end do
        npSqrt = sqrt(npSqrt)
        probKS = getProbKS( (npSqrt+0.12_RK+0.11_RK/npSqrt)*statKS )
    end subroutine doUniformKS1

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the one-sample Kolmogorov–Smirnov (KS) test results under the assumption that the
    !> points originate from a uniform distribution in [0,1]. So, all Point must be in [0,1] on input.
    !>
    !> \param[in]       np1             :   The number of points in the input vector `SortedPoint1`.
    !> \param[in]       np2             :   The number of points in the input vector `SortedPoint2`.
    !> \param[inout]    SortedPoint1    :   The first input sorted sample. On input, it must be sorted in ascending-order.
    !> \param[inout]    SortedPoint2    :   The second input sorted sample. On input, it must be sorted in ascending-order.
    !> \param[out]      statKS          :   The KS test statistic.
    !> \param[out]      probKS          :   The `p`-value of the test, returned as a scalar value in the range `[0,1]`.
    !>                                      The output `probKS` is the probability of observing a test statistic as extreme as,
    !>                                      or more extreme than, the observed value under the null hypothesis.
    !>                                      Small values of `probKS` cast doubt on the validity of the null hypothesis.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    subroutine doSortedKS2(np1,np2,SortedPoint1,SortedPoint2,statKS,probKS)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: doSortedKS2
#endif
        integer(IK) , intent(in)    :: np1, np2
        real(RK)    , intent(in)    :: SortedPoint1(np1), SortedPoint2(np2)
        real(RK)    , intent(out)   :: statKS, probKS
        real(RK)                    :: dummy1,dummy2,dt,np1_RK,np2_RK,npEffective,cdf1,cdf2
        integer(IK)                 :: j1,j2
        np1_RK = np1
        np2_RK = np2
        j1 = 1_IK
        j2 = 1_IK
        cdf1 = 0._RK
        cdf2 = 0._RK
        statKS = 0._RK
        do
            if ( j1<=np1 .and. j2<=np2 )then
                dummy1 = SortedPoint1(j1)
                dummy2 = SortedPoint2(j2)
                if( dummy1 <= dummy2 ) then
                  cdf1 = j1 / np1_RK
                  j1 = j1 + 1
                endif
                if( dummy2 <= dummy1 ) then
                  cdf2 = j2 / np2_RK
                  j2 = j2 + 1_IK
                endif
                dt = abs(cdf2-cdf1)
                if (dt>statKS) statKS = dt
                cycle
            end if
            exit
        end do
        npEffective = sqrt( np1_RK * np2_RK / ( np1_RK + np2_RK ) )
        probKS = getProbKS( ( npEffective + 0.12_RK + 0.11_RK / npEffective ) * statKS )
    end subroutine doSortedKS2

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the Kolmogorov–Smirnov (KS) probability.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getProbKS(lambda) result(probKS)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getProbKS
#endif
        implicit none
        real(RK)   , intent(in) :: lambda
        real(RK)   , parameter  :: EPS1 = 0.001_RK, EPS2 = 1.e-8_RK
        integer(IK), parameter  :: NITER = 100
        integer(IK)             :: j
        real(RK)                :: a2,fac,term,termbf
        real(RK)                :: probKS
        a2 = -2._RK*lambda**2
        fac = 2._RK
        probKS = 0._RK
        termbf = 0._RK
        do j = 1, NITER
            term = fac*exp(a2*j**2)
            probKS = probKS+term
            if (abs(term) <= EPS1*termbf .or. abs(term) <= EPS2*probKS) return
            fac = -fac
            termbf = abs(term)
        end do
        probKS = 1._RK
    end function getProbKS

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Returns the uniform CDF on support [0,1). This is rather redundant, aint it? but sometimes, needed.
    !>
    !> \param[in] x : The point at which the CDF must be computed.
    !>
    !> \author
    !> Amir Shahmoradi, Monday March 6, 2017, 3:22 pm, ICES, The University of Texas at Austin.
    pure function getUniformCDF(x)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getUniformCDF
#endif
        implicit none
        real(RK), intent(in) :: x
        real(RK)             :: getUniformCDF
        getUniformCDF = x
    end function getUniformCDF

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the 1-D histogram (Density plot) of the input vector `X`.
    !> The number of bins in the `X` range (`nxbin`) is determined by the user.
    !> The range of `X`, `[xmin, xmax]`, should be also given by the user.
    !> The program returns two arrays of `Xbin` and `Density(x)` as output.
    !>
    !> \param[in]       method          :   The method by which the hist count should be returned:
    !>                                      + `"pdf"`   : Return the probability density function histogram.
    !>                                      + `"count"` : Return the count histogram.
    !> \param[in]       xmin            :   The minimum of the histogram binning.
    !> \param[in]       xmax            :   The maximum of the histogram binning.
    !> \param[in]       nxbin           :   The number of histogram bins.
    !> \param[in]       np              :   The length of input vector `X`.
    !> \param[in]       X               :   The vector of length `nxbin` of values to be binned.
    !> \param[out]      Xbin            :   The vector of length `nxbin` of values representing the bin centers.
    !> \param[out]      Density         :   The vector of length `nxbin` of values representing the densities in each bin.
    !> \param[out]      errorOccurred   :   The logical output flag indicating whether error has occurred.
    !>
    !> \author
    !> Amir Shahmoradi, Sep 1, 2017, 12:30 AM, ICES, UT Austin
    subroutine getHist1d(method,xmin,xmax,nxbin,np,X,Xbin,Density,errorOccurred)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getHist1d
#endif
        implicit none
        character(*), intent(in)  :: method
        integer(IK) , intent(in)  :: np,nxbin
        real(RK)    , intent(in)  :: xmin,xmax
        real(RK)    , intent(in)  :: X(np)
        real(RK)    , intent(out) :: Xbin(nxbin),Density(nxbin)
        logical     , intent(out) :: errorOccurred
        real(RK)                  :: xbinsize
        integer(IK)               :: i,ip,thisXbin

        errorOccurred = .false.
        Density = 0._RK
        xbinsize = (xmax-xmin) / real(nxbin,kind=RK)
        Xbin = [ (xmin+real(i-1,kind=RK)*xbinsize,i=1,nxbin) ]

        do ip = 1,np
            thisXbin = getBin(X(ip),xmin,nxbin,xbinsize)
            Density(thisXbin) = Density(thisXbin) + 1._RK
        end do

        Xbin = Xbin + 0.5_RK * xbinsize
       !method = getLowerCase(trim(adjustl(histType)))
        if(method=='pdf') then
            Density = Density / real(np,kind=RK)
        elseif(method=='count') then
            return
        else
            errorOccurred = .true.
        end if
    end subroutine getHist1d

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the 2-D histogram (Density plot) of a set of data points with (X,Y) coordinates.
    !> The number of bins in the `X` and `Y` directions (`[nxbin, nybin]`) are determined by the user.
    !> The range of `X` and `Y` (`xmin`,`xmax`,`ymin`,`ymax`) should also be given by the user.
    !> The program returns three arrays of `Xbin`, `Ybin`, and `Density(y,x)` as the output.
    !>
    !> \param[in]       histType        :   The method by which the normalization of the histogram counts should be done:
    !>                                      + `"count"`     : Return the count histogram.
    !>                                      + `"pdf"`       : Return the probability density function (PDF) histogram.
    !>                                      + `"pdf(y|x)"`  : Return the conditional PDF of `y` given `x` histogram.
    !>                                      + `"pdf(x|y)"`  : Return the conditional PDF of `x` given `y` histogram.
    !> \param[in]       xmin            :   The minimum of the histogram binning along the x-axis.
    !> \param[in]       xmax            :   The maximum of the histogram binning along the x-axis.
    !> \param[in]       ymin            :   The minimum of the histogram binning along the y-axis.
    !> \param[in]       ymax            :   The maximum of the histogram binning along the y-axis.
    !> \param[in]       nxbin           :   The number of histogram bins along the x-axis.
    !> \param[in]       nybin           :   The number of histogram bins along the y-axis.
    !> \param[in]       np              :   The length of input vector `X`.
    !> \param[in]       X               :   The vector of length `nxbin` of values to be binned.
    !> \param[in]       Y               :   The vector of length `nybin` of values to be binned.
    !> \param[out]      Xbin            :   The vector of length `nxbin` of values representing the bin centers.
    !> \param[out]      Ybin            :   The vector of length `nybin` of values representing the bin centers.
    !> \param[out]      Density         :   The array of shape `(nybin,nxbin)` of values representing the densities per bin.
    !>
    !> \author
    ! Amir Shahmoradi, Sep 1, 2017, 12:00 AM, ICES, UT Austin
    subroutine getHist2d(histType,xmin,xmax,ymin,ymax,nxbin,nybin,np,X,Y,Xbin,Ybin,Density)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getHist2d
#endif
        !use, intrinsic :: iso_fortran_env, only: output_unit
        use String_mod, only: getLowerCase
        implicit none
        character(*), intent(in)  :: histType
        integer(IK) , intent(in)  :: np,nxbin,nybin
        real(RK)    , intent(in)  :: xmin,xmax,ymin,ymax
        real(RK)    , intent(in)  :: X(np),Y(np)
        real(RK)    , intent(out) :: Xbin(nxbin),Ybin(nybin),Density(nybin,nxbin)
        character(:), allocatable :: method
        real(RK)                  :: xbinsize,ybinsize
        integer(IK)               :: i,ip,thisXbin,thisYbin

        Density = 0._RK
        xbinsize = (xmax-xmin) / real(nxbin,kind=RK)
        ybinsize = (ymax-ymin) / real(nybin,kind=RK)
        Xbin = [ (xmin+real(i-1,kind=RK)*xbinsize,i=1,nxbin) ]
        Ybin = [ (ymin+real(i-1,kind=RK)*ybinsize,i=1,nybin) ]

        do ip = 1,np
            thisXbin = getBin(X(ip),xmin,nxbin,xbinsize)
            thisYbin = getBin(Y(ip),ymin,nybin,ybinsize)
            Density(thisYbin,thisXbin) = Density(thisYbin,thisXbin) + 1._RK
        end do

        Xbin = Xbin + 0.5_RK * xbinsize
        Ybin = Ybin + 0.5_RK * ybinsize
        method = getLowerCase(trim(adjustl(histType)))
        if(method=='pdf') then
            Density = Density / real(np,kind=RK)
        elseif(method=='pdf(y|x)') then
            do i = 1,nxbin
                Density(1:nybin,i) = Density(1:nybin,i) / sum(Density(1:nybin,i))
            end do
        elseif(method=='pdf(x|y)') then
            do i = 1,nybin
                Density(i,1:nxbin) = Density(i,1:nxbin) / sum(Density(i,1:nxbin))
            end do
        elseif(method=='count') then
            return
        else
            error stop
            !call abortProgram( output_unit , 1 , 1 , 'Statistics@getHist2d() failed. The requested histType does not exist.' )
        end if

    end subroutine getHist2d

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Given the range of the variable `x`, `xmin:xmin+binsize*nbin`, and the number of bins, `nbin`, with which
    !> this range is divided, find which bin the input value `x` falls among `[1:nbin]` bins.
    !> The output `ibin` is the number that identifies the bin.
    !>
    !> \param[in]       x               :   The input value whose bin ID is to be found.
    !> \param[in]       lowerBound      :   The lower limit on the value of `x`.
    !> \param[in]       nbin            :   The number of bins to be considered starting from `lowerBound`.
    !> \param[in]       binsize         :   The size of the bins. It must be exactly `(xmax - xmin) / nbin`.
    !>
    !> \return
    !> `ibin` : The ID of the bin to which the input value `x` belongs.
    !>
    !> \warning
    !> If `x <= xmin` or `x xmin + nbin * binsize`, then `ibin = -1` will be returned to indicate error.
    !>
    !> \remark
    !> If `bmin < x <= bmax` then `x` belongs to this bin.
    !>
    !> \author
    !> Version 3.0, Sep 1, 2017, 11:12 AM, Amir Shahmoradi, ICES, The University of Texas at Austin.
    pure function getBin(x,lowerBound,nbin,binsize) result(ibin)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getBin
#endif

        implicit none
        integer(IK), intent(in) :: nbin
        real(RK)   , intent(in) :: x,lowerBound,binsize
        real(RK)                :: xmin,xmid
        integer(IK)             :: ibin,minbin,midbin,maxbin

        if (x<lowerBound .or. x>=lowerBound+nbin*binsize) then
            ibin = -1_IK
            return
        end if

        minbin = 1
        maxbin = nbin
        xmin = lowerBound
        loopFindBin: do
            midbin = (minbin+maxbin) / 2
            xmid = xmin + midbin*binsize
            if (x<xmid) then
                if (minbin==midbin) then
                    ibin = minbin
                    exit loopFindBin
                end if
                maxbin = midbin
                cycle loopFindBin
            else
                if (minbin==midbin) then
                    ibin = maxbin
                    exit loopFindBin
                end if
                minbin = midbin
                cycle loopFindBin
            end if
        end do loopFindBin

    end function getBin

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    !> \brief
    !> Return the quantiles of an input sample of points, given the input quantile probabilities.
    !>
    !> \param[in]       np                          :   The number of points in the input sample.
    !> \param[in]       nq                          :   The number of output quantiles.
    !> \param[in]       SortedQuantileProbability   :   A sorted ascending-order vector of probabilities at which the quantiles will be returned.
    !> \param[in]       Point                       :   The vector of length `np` representing the input sample.
    !> \param[in]       Weight                      :   The vector of length `np` representing the weights of the points in the input sample.
    !> \param[in]       sumWeight                   :   The sum of the vector weights of the points: `sum(Weight)`.
    !>
    !> \return
    !> `Quantile` : The output vector of length `nq`, representing the quantiles corresponding to the input `SortedQuantileProbability` probabilities.
    !>
    !> \author
    ! Amir Shahmoradi, Sep 1, 2017, 12:00 AM, ICES, UT Austin
    pure function getQuantile(np,nq,SortedQuantileProbability,Point,Weight,sumWeight) result(Quantile)
#if defined DLL_ENABLED && !defined CFI_ENABLED
        !DEC$ ATTRIBUTES DLLEXPORT :: getQuantile
#endif
        use Constants_mod, only: IK, RK, NEGINF_RK
        use Sort_mod, only: indexArray
        use Err_mod, only: Err_type
        implicit none
        integer(IK) , intent(in)            :: np, nq
        real(RK)    , intent(in)            :: SortedQuantileProbability(nq), Point(np)
        integer(IK) , intent(in), optional  :: Weight(np), sumWeight
        real(RK)                            :: Quantile(nq)
        real(RK)                            :: probability
        integer(IK)                         :: ip, iq, iw, weightCounter, Indx(np), SortedQuantileDensity(nq)
        type(Err_type)                      :: Err
        iq = 1_IK
        Quantile = 0._RK
        probability = 0._RK
        weightCounter = 0_IK
        call indexArray(np,Point,Indx,Err)
        if (Err%occurred) then
            Quantile = NEGINF_RK
            return
        end if
        if (present(sumWeight)) then
            SortedQuantileDensity = nint( SortedQuantileProbability * sumWeight )
            loopWeighted: do ip = 1, np
                do iw = 1, Weight(Indx(ip))
                    weightCounter = weightCounter + 1_IK
                    if (weightCounter>=SortedQuantileDensity(iq)) then
                        Quantile(iq) = Point(Indx(ip))
                        iq = iq + 1_IK
                        if (iq>nq) exit loopWeighted
                    end if
                end do
            end do loopWeighted
        else
            SortedQuantileDensity = nint( SortedQuantileProbability * np )
            loopNonWeighted: do ip = 1, np
                if (ip>=SortedQuantileDensity(iq)) then
                    Quantile(iq) = Point(Indx(ip))
                    iq = iq + 1_IK
                    if (iq>nq) exit loopNonWeighted
                end if
            end do loopNonWeighted
        end if
    end function getQuantile

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end module Statistics_mod