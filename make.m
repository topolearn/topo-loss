% Makefile
% Run make to compile and link C++ source files for graph matching algorithms.
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

basePath = cd;

cd './lib/cpp';
mex assignmentoptimal.cpp -outdir './mex';
mex mex_normalize_bistochastic.cpp -outdir './mex';
cd(basePath);