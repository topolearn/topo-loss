function lossMtx = compute_loss_mtx(name, g1, g2, param)
% Compute loss matrix whose entries are pair-wise losses/distances. 
% It is used in rapid transposition test
%
% INPUT
% name    : algorithm name
% g1,g2   : two groups of networks
% param   : parameters for baseline algorithms
%
% OUTPUT
% lossMtx : loss matrix 
%
% Update history
%     November 10, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

g = [g1; g2];
d = length(g);
lossMtx = zeros(d);
if strcmp(name, 'top') % topological loss
    for i = 1:d
        adj1 = g{i};
        for j = i + 1:d
            adj2 = g{j};
            totalTop = total_top_loss(adj1, adj2);
            lossMtx(i, j) = totalTop;
            lossMtx(j, i) = totalTop;
        end
    end

elseif strcmp(name, 'ga') || strcmp(name, 'sm') ...
        || strcmp(name, 'ipfp') || strcmp(name, 'rrwm')
    % baseline graph matching algorithms
    for i = 1:d
        adj1 = g{i};
        for j = i + 1:d
            adj2 = g{j};
            d1 = size(adj1, 1);
            d2 = size(adj2, 1);
            K = global_aff_mtx(adj1, adj2, @edge_aff_fn); % global affinity
            Ct = ones(d1, d2); % default a mapping constraint to ones' matrix

            % execute baseline algorithm
            gmCost = execute_baseline_algorithm(name, K, Ct, param);
            if strcmp(name, 'ga') % existing ga implementation is not symmetric
                K1 = global_aff_mtx(adj2, adj1, @edge_aff_fn);
                gmCost1 = execute_baseline_algorithm(name, K1, Ct, param);
                gmCost = (gmCost + gmCost1) / 2;
            end

            lossMtx(i, j) = gmCost;
            lossMtx(j, i) = gmCost;
        end
    end
end

end