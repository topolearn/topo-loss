function gmCost = execute_baseline_algorithm(name, K, Ct, param)
% Run baseline algorithms.
%
% INPUT
% name  : algorithm names: 'ga', 'sm', 'ipfp' or 'rrwm'
% K     : global affinity
% Ct    : correspondence constraint
% param : algorithm-specified parameters
%
% OUTPUT
% gmCost: matching cost
%
% Update history
%     November 10, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

% initialization
[d1, d2] = size(Ct);
X0 = ones(d1, d2) + eps;
X0(Ct == 0) = 0;

if strcmp(name, 'ga') % graduate assignment
    X = ga(K, X0, param);
    X = hun(X, Ct, struct([]));
    gmCost = X(:)' * K * X(:);

elseif strcmp(name, 'sm') % spectral matching
    X = sm(K, Ct, param);
    X = hun(X, Ct, struct([]));
    gmCost = X(:)' * K * X(:);

elseif strcmp(name, 'ipfp') % integer projected fixed point
    % normalization
    Xsm = bistocNormalize_slack(X0, 1e-7);
    % run algorithm
    [~, gmCost] = ipfp(K, Ct, Xsm, param);

elseif strcmp(name, 'rrwm') % reweighted random walk matching
    % normalization
    Xrrwm = X0 ./ norm(X0(:));
    % run algorithm
    X = rrwm(K, Xrrwm, param);
    X = hun(X, Ct, struct([]));
    gmCost = X(:)' * K * X(:);

end
