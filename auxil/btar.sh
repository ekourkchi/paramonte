#!/bin/bash
####################################################################################################################################
####################################################################################################################################
####
####   MIT License
####
####   ParaMonte: plain powerful parallel Monte Carlo library.
####
####   Copyright (C) 2012-present, The Computational Data Science Lab
####
####   This file is part of the ParaMonte library.
####
####   Permission is hereby granted, free of charge, to any person obtaining a 
####   copy of this software and associated documentation files (the "Software"), 
####   to deal in the Software without restriction, including without limitation 
####   the rights to use, copy, modify, merge, publish, distribute, sublicense, 
####   and/or sell copies of the Software, and to permit persons to whom the 
####   Software is furnished to do so, subject to the following conditions:
####
####   The above copyright notice and this permission notice shall be 
####   included in all copies or substantial portions of the Software.
####
####   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
####   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
####   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
####   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
####   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
####   OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
####   OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
####
####   ACKNOWLEDGMENT
####
####   ParaMonte is an honor-ware and its currency is acknowledgment and citations.
####   As per the ParaMonte library license agreement terms, if you use any parts of 
####   this library for any purposes, kindly acknowledge the use of ParaMonte in your 
####   work (education/research/industry/development/...) by citing the ParaMonte 
####   library as described on this page:
####
####       https://github.com/cdslaborg/paramonte/blob/main/ACKNOWLEDGMENT.md
####
####################################################################################################################################
####################################################################################################################################
#
# Usage:
#
#   ./auxil/btar.sh --dir ./bin/
#
#
####################################################################################################################################
# auxil
####################################################################################################################################

reportBadValue()
{
    echo >&2 ""
    echo >&2 "-- ParaMonte - FATAL: The requested input value $2 specified with "
    echo >&2 "-- ParaMonte - FATAL: the input flag $1 is not supported."
    if ! [ -z ${3+x} ]; then
    echo >&2 "-- ParaMonte - FATAL: $3"
    fi
    echo >&2 ""
    echo >&2 "-- ParaMonte - gracefully exiting."
    echo >&2 ""
    echo >&2 ""
    exit 1
}

####################################################################################################################################
# parse arguments
####################################################################################################################################

#sourceFileDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sourceFileDir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
workingDir=$(pwd)
targetDir="${sourceFileDir}/../bin/"

echo >&2 
echo >&2 "-- ParaMonte -    btar.sh file directory: ${sourceFileDir}"
echo >&2 "-- ParaMonte - current working directory: ${workingDir}"
echo >&2 

unset LANG_LIST # must be all lower case

while [ "$1" != "" ]; do
    case $1 in
        -d | --dir )    shift
                        targetDir=$1
                        ;;
        -L | --lang )   shift
                        LANG_LIST="$1"
                        ;;
        -h | --help )   #usage
                        echo >&2 "-- ParaMonte - Sadly, there is no help here, because you should not be here if you do not know why you are here."
                        exit
                        ;;
        * )             echo >&2 "-- ParaMonte - FATAL: the input flag is not recognized: $1"
                        #usage
                        exit 1
    esac
    shift
done

if ! ([ -z ${LANG_LIST+x} ] || [ "${LANG_LIST}" = "all" ]); then
    ALL_ENABLED=false
    for LANG in "${LANG_LIST}"; do
        if  [[ $LANG == [cC] ]]; then C_ENABLED=true; else C_ENABLED=false; fi
        if  [[ $LANG == "c++" || $LANG == "C++" ]]; then CPP_ENABLED=true; else CPP_ENABLED=false; fi
        if  [[ $LANG == [fF][oO][rR][tT][rR][aA][nN] ]]; then Fortran_ENABLED=true; else Fortran_ENABLED=false; fi
        if  [[ $LANG == [mM][aA][tT][lL][aA][bB] ]]; then MATLAB_ENABLED=true; else MATLAB_ENABLED=false; fi
        if  [[ $LANG == [pP][yY][tT][hH][oO][nN] ]]; then Python_ENABLED=true; else Python_ENABLED=false; fi

        #echo ${LANG}
        #echo ${LANG_LIST}
        #echo ${C_ENABLED}
        #echo ${CPP_ENABLED}
        #echo ${Fortran_ENABLED}
        #echo ${MATLAB_ENABLED} 
        #echo ${Python_ENABLED} 

        if [ ${C_ENABLED} = "false" ] \
        && [ ${CPP_ENABLED} = "false" ] \
        && [ ${Fortran_ENABLED} = "false" ] \
        && [ ${MATLAB_ENABLED} = "false" ] \
        && [ ${Python_ENABLED} = "false" ]; then
            reportBadValue "-L or --lang" $LANG
        fi
    done
    if [ "${LANG_LIST}" = "" ]; then
        unset LANG_LIST
    #else
    #    LANG_LIST="$(getLowerCase $LANG_LIST)"
    fi
else
    ALL_ENABLED=true
fi


if [ -d "${targetDir}" ]; then
    echo >&2
    echo >&2 "-- ParaMonte - compressing all subdirectories in the directory: ${targetDir}"
    echo >&2
    cd "${targetDir}"
    for subdir in ./*; do
        if [ -d "${subdir}" ]; then
            compressionEnabled=false
            if [ "${ALL_ENABLED}" = "true" ]; then compressionEnabled=true; fi
            if [[ "${C_ENABLED}" == "true" && "${subdir}" =~ .*"_c_".* ]]; then compressionEnabled=true; fi
            if [[ "${CPP_ENABLED}" == "true" && "${subdir}" =~ .*"_cpp_".* ]]; then compressionEnabled=true; fi
            if [[ "${Fortran_ENABLED}" == "true" && "${subdir}" =~ .*"_fortran_".* ]]; then compressionEnabled=true; fi
            if [[ "${MATLAB_ENABLED}" == "true" && "${subdir}" =~ .*"_MATLAB".* ]]; then compressionEnabled=true; fi
            if [[ "${MATLAB_ENABLED}" == "true" && "${subdir}" =~ .*"_MatDRAM".* ]]; then compressionEnabled=true; fi
            if [[ "${Python_ENABLED}" == "true" && "${subdir}" =~ .*"_Python".* ]]; then compressionEnabled=true; fi
            if [ "${compressionEnabled}" = "true" ]; then
                tarfile="${subdir}.tar.gz"
                #cd "${subdir}"
                if [ -f "${tarfile}" ]; then
                    echo >&2 "-- ParaMonte - WARNING: compressed subdirectory already exists: ${tarfile}"
                    echo >&2 "-- ParaMonte - WARNING: skipping..."
                else
                    echo >&2 "-- ParaMonte - compressing subdirectory: ${subdir}"
                    tar -zcvf ${tarfile} --exclude="${subdir}/setup.sh" "${subdir}" || {
                        echo >&2
                        echo >&2 "-- ParaMonte - FATAL: compression failed for subdirectory: ${subdir}"
                        echo >&2 "-- ParaMonte - FATAL: gracefully exiting."
                        echo >&2
                        exit 1
                    }
                    #cd ..
                fi
            fi
        else
            echo >&2 "-- ParaMonte - WARNING: non-directory object detected: ${subdir}"
        fi
    done
else
    echo >&2
    echo >&2 "-- ParaMonte - FATAL: The requested input target directory ${targetDir} specified" 
    echo >&2 "-- ParaMonte - FATAL: with the input flag --dir does not exist."
    echo >&2
    exit 1
fi
