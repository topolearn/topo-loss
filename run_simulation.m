% Simulation study: Comparison against graph matching algorithms
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

clc;
addpath(genpath('./lib'));
addpath(genpath('./src'));

% save p-value results to filename
filename = 'pval_result.mat';

% parameters for random weights
mu = 1;
sigma = .25;

nSim = 50; % number of independent simulations
nTrans = 200000; % number of transpositions
permNo = 500; % intermix random permutation every 'permNo' transpositions

% parameters for baseline graph matching algorithms
gaParam = struct('b0', .5, 'bMax', 10);
smParam = struct('top', 'eigs');
ipfpParam = struct('deb', false);
rrwmParam = struct([]);

% number of networks in each group
nGroup1 = 10;
nGroup2 = 10;

% initialize p-value results
nSetting = set_random_network_parameter(1);
pvalTop = zeros(nSetting, nSim);
pvalGa = zeros(nSetting, nSim);
pvalSm = zeros(nSetting, nSim);
pvalIpfp = zeros(nSetting, nSim);
pvalRrwm = zeros(nSetting, nSim);

fprintf('[nNode, nModule1, nModule2, p]\n');

for ind = 1:nSetting
    % parameters used in the simulation study
    % nNode             : number of nodes
    % nModule1,nModule2 : number of clusters/modules for each group
    % p                 : overall probability of attachment within-group
    [~, nNode, nModule1, nModule2, p] = set_random_network_parameter(ind);
    fprintf(1, '%d, %d, %d, %.2f: %3d', nNode, nModule1, nModule2, p, 0);

    for i = 1:nSim
        % generate networks for within and between groups
        g1 = cell(nGroup1, 1);
        g2 = cell(nGroup2, 1);
        for k = 1:nGroup1
            g1{k} = random_modular_graph(nNode, nModule1, p, mu, sigma);
        end
        for k = 1:nGroup2
            g2{k} = random_modular_graph(nNode, nModule2, p, mu, sigma);
        end

        % transposition test
        pvalTop(ind, i) = get_pvalue('top', g1, g2, struct([]), nTrans, permNo);
        pvalGa(ind, i) = get_pvalue('ga', g1, g2, gaParam, nTrans, permNo);
        pvalSm(ind, i) = get_pvalue('sm', g1, g2, smParam, nTrans, permNo);
        pvalIpfp(ind, i) = get_pvalue('ipfp', g1, g2, ipfpParam, nTrans, permNo);
        pvalRrwm(ind, i) = get_pvalue('rrwm', g1, g2, rrwmParam, nTrans, permNo);

        fprintf(1, '\b\b\b%3d', i);
    end

    if exist(filename, 'file')
        save(filename, 'pvalTop', 'pvalGa', 'pvalSm', 'pvalIpfp', 'pvalRrwm', '-append');
    else
        save(filename, 'pvalTop', 'pvalGa', 'pvalSm', 'pvalIpfp', 'pvalRrwm');
    end

    fprintf('\n');
end