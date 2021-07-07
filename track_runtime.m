% Simulation study: Run time.
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

addpath(genpath('./lib'));
addpath(genpath('./src'));

% parameters for random modular network
nModule1 = 1;
nModule2 = 1;
p = .5;
mu = 1;
sigma = .25;

% output filename
filename = 'runtime_result.mat';

% parameters for baseline graph matching algorithms
gaParam = struct('b0', .5, 'bMax', 10);
smParam = struct('top', 'eigs');
ipfpParam = struct('deb', false);
rrwmParam = struct([]);

% if number of nodes is too small, then a graph might be edgeless
% and some implementation of baseline graph matching algorithms might crash.
nodeArr = [10:1:50, 52:2:100, 110:10:180];

% initialize run-time
runTime = zeros(5, length(nodeArr));

fprintf(1, 'Complete: %3d %%', 0);
for i = 1:length(nodeArr)
    % generate random network
    adj1 = random_modular_graph(nodeArr(i), nModule1, p, mu, sigma);
    adj2 = random_modular_graph(nodeArr(i), nModule2, p, mu, sigma);
    d1 = size(adj1, 1);
    d2 = size(adj2, 1);

    K = global_aff_mtx(adj1, adj2, @edge_aff_fn); % global affinity
    Ct = ones(d1, d2); % default a mapping constraint to one matrix)

    % measure the time required to execute baseline algorithm
    gafn = @() execute_baseline_algorithm('ga', K, Ct, gaParam);
    smfn = @() execute_baseline_algorithm('sm', K, Ct, smParam);
    ipfpfn = @() execute_baseline_algorithm('ipfp', K, Ct, ipfpParam);
    rrwmfn = @() execute_baseline_algorithm('rrwm', K, Ct, rrwmParam);
    topfn = @() total_top_loss(adj1, adj2);

    runTime(1, i) = timeit(gafn);
    runTime(2, i) = timeit(smfn);
    runTime(3, i) = timeit(ipfpfn);
    runTime(4, i) = timeit(rrwmfn);
    runTime(5, i) = timeit(topfn);

    save(filename, 'runTime');
    fprintf(1, '\b\b\b\b\b%3d %%', round(i * 100 / length(nodeArr)));

end

fprintf('\n');
