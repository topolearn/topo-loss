function pval = iterative_pval(rStats, observed)
% Compute p-value sequentially.
%
% Reference
% Chung, Moo K., et al. "Rapid acceleration of the permutation test via transpositions." 
% International Workshop on Connectomics in Neuroimaging. Springer, 2019.
%
% (C) 2020 Moo K. Chung, Universtiy of Wisconsin-Madison   
%     mkchung@wisc.edu

n = length(rStats);
pval = zeros(1, n);

pval(1) = rStats(1) >= observed;
for i = 2:n
    pval(i) = (pval(i - 1) * (i - 1) + (rStats(i) >= observed)) / i;
end

end