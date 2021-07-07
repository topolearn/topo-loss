function birthMtx = conncomp_birth(adj)
% Compute a set of increasing birth values for 0D barcode
%
% INPUT
% adj      : weighted adjacency matrix
%
% OUTPUT
% birthMtx : matrix whose 1st and 2nd columns are end nodes (no duplicates)
%            and 3rd column is weight (in ascending order, i.e., 1st row is
%            smallest)
%
% Update history:
%     August 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

g = graph(-adj, 'upper', 'omitselfloops'); % minus weights to find max spanning tree
gTree = minspantree(g); % find max spanning tree of -adj
gTreeMtx = gTree.Edges{:, :}; % edge info.
gTreeMtx(:, 3) = gTreeMtx(:, 3) * -1; % reverse back to positive weights
birthMtx = sortrows(gTreeMtx, 3);

end