% Run full test to demonstrate algorithm chain for source size calculation.
%--------------------------------------------------------------------------
% Date: 2013-12-20
% Author: Goran Lovric
% License: GPL 3 (see LICENSE file in root folder)
%--------------------------------------------------------------------------
close all;clc;clear;

%--------------------------------------------------------------------------
% 1.) create "fake" experimental data (takes ~5min)
%--------------------------------------------------------------------------
run synthetic_data

%--------------------------------------------------------------------------
% 2.) Apply the fitting algorithm from G. Lovric et. al. (submitted)
%--------------------------------------------------------------------------
if ~exist('results.mat', 'file')
    run fitting
end

%--------------------------------------------------------------------------
% 3.) Calculate uncertainties
%--------------------------------------------------------------------------
run uncertainty_calc

%--------------------------------------------------------------------------
% 4.) Print all results
%--------------------------------------------------------------------------
run print_all