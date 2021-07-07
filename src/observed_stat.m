function observed = observed_stat(lossMtx, nGroup1, nGroup2, rstat_fn)
% Compute observed ratio statistic.
%
% INPUT
% lossMtx          : matrix whose entries are pair-wise losses/distances
% nGroup1, nGroup2 : sample size
% rstat_fn         : ratio statistic definition, i.e., between_over_within
%                    or within_over_between
%
% OUTPUT
% observed : observed p-value
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

% within groups
within = 0;
% sum of pair-wise distances within groups
for i = 1:nGroup1 % group 1
    for j = i + 1:nGroup1
        within = within + lossMtx(i, j);
    end
end
for i = nGroup1 + 1:nGroup1 + nGroup2 % group 2
    for j = i + 1:nGroup1 + nGroup2
        within = within + lossMtx(i, j);
    end
end

% between groups
% sum of pair-wise distances between groups
between = 0;
for i = 1:nGroup1
    for j = nGroup1 + 1:nGroup1 + nGroup2
        between = between + lossMtx(i, j);
    end
end

% denomGroup1 = (nGroup1*(nGroup1-1) + nGroup2*(nGroup2-1))/2;
% denomGroup2 = nGroup1*nGroup2;
observed = rstat_fn(between, within); % * (denomGroup1 / denomGroup2);

end