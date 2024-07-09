%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%   MIT License
%%%%
%%%%   ParaMonte: plain powerful parallel Monte Carlo library.
%%%%
%%%%   Copyright (C) 2012-present, The Computational Data Science Lab
%%%%
%%%%   This file is part of the ParaMonte library.
%%%%
%%%%   Permission is hereby granted, free of charge, to any person obtaining a 
%%%%   copy of this software and associated documentation files (the "Software"), 
%%%%   to deal in the Software without restriction, including without limitation 
%%%%   the rights to use, copy, modify, merge, publish, distribute, sublicense, 
%%%%   and/or sell copies of the Software, and to permit persons to whom the 
%%%%   Software is furnished to do so, subject to the following conditions:
%%%%
%%%%   The above copyright notice and this permission notice shall be 
%%%%   included in all copies or substantial portions of the Software.
%%%%
%%%%   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
%%%%   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
%%%%   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
%%%%   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
%%%%   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
%%%%   OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
%%%%   OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%
%%%%   ACKNOWLEDGMENT
%%%%
%%%%   ParaMonte is an honor-ware and its currency is acknowledgment and citations.
%%%%   As per the ParaMonte library license agreement terms, if you use any parts of 
%%%%   this library for any purposes, kindly acknowledge the use of ParaMonte in your 
%%%%   work (education/research/industry/development/...) by citing the ParaMonte 
%%%%   library as described on this page:
%%%%
%%%%       https://github.com/cdslaborg/paramonte/blob/main/ACKNOWLEDGMENT.md
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear MATLAB space

clc;
clear all;
close all;
clear classes;
format compact; format long;

% set path to the ParaMonte library

pmlibRootDir = './'; % set this path to the paramonte library root dir
addpath(genpath(pmlibRootDir));

% change MATLAB's working directory to the folder containing this script

filePath = mfilename('fullpath');
[currentDir,fileName,fileExt] = fileparts(filePath); cd(currentDir); % Change working directory to source code directory.
cd(fileparts(mfilename('fullpath'))); % Change working directory to source code directory.

% define the objective function

NDIM = 2; % number of dimensions of the distribution

% create a ParaMonte object

pm = paramonte(); % use paramonte("matlab") to use the MATLAB kernel instead of interface

% create a ParaDRAM simulation object

pmpd = pm.ParaDRAM();

pmpd.mpiEnabled = false;
pmpd.buildMode = "release";
pmpd.spec.randomSeed = 31731;
pmpd.spec.outputFileName = "./RosenBrock/";
pmpd.spec.sampleRefinementCount = 1;
pmpd.spec.outputDelimiter = ",";
pmpd.spec.chainSize = 15000;
pmpd.spec.sampleSize = -100;
pmpd.spec.targetAcceptanceRate = [0.01,0.3];
pmpd.spec.proposalStartStdVec = [2,2];

getNegLogRosen = @(point) -log( 100.0 * (point(2)-point(1)^2)^2 + (point(1)-1.0)^2 );

pmpd.runSampler ( NDIM              ... number of dimensions of the objective function
                , getNegLogRosen    ... the objective function
                );

function logFunc = getLogFunc(point)
    logFunc = -log( 100.0 * (point(2)-point(1)^2)^2 + (point(1)-1.0)^2 );
end
