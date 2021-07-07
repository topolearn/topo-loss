function pval = get_pvalue(name, g1, g2, param, nTrans, permNo)
% Perform transposition test.
%
% Reference
% Songdechakraiwut, T., Chung, M.K.: Topological learning for brain networks. arXiv preprint arXiv:2012.00675 (2020)
%
% INPUT
% name   : algorithm name e.g. 'top', 'ga', 'sm', 'ipfp' and 'rrwm'
% g1, g2 : two groups of networks
% param  : parameters for baseline algorithms
% nTrans : number of transpositions
% permNo : intermix random permutation every 'permNo' transpositions
%
% OUTPUT
% pval : p-value
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

% sample size
nGroup1 = length(g1);
nGroup2 = length(g2);

% compute loss matrix whose entries are pair-wise distances
lossMtx = compute_loss_mtx(name, g1, g2, param);
% figure; imagesc(lossMtx); colorbar;

% compute p-value through transposition procedure
if strcmp(name, 'top')
    observed = observed_stat(lossMtx, nGroup1, nGroup2, @between_over_within);
    [transStat, ~] = transposition_test(lossMtx, nGroup1, nGroup2, nTrans, ...
        permNo, @between_over_within);
else
    observed = observed_stat(lossMtx, nGroup1, nGroup2, @within_over_between);
    [transStat, ~] = transposition_test(lossMtx, nGroup1, nGroup2, nTrans, ...
        permNo, @within_over_between);
end

transPval = iterative_pval(transStat, observed);
pval = transPval(end);

end