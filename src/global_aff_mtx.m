function K = global_aff_mtx(adj1, adj2, edge_aff_fn)
% Compute edge-edge affinity matrix KQ
% then convert KQ to global affinity matrix K for graph matching.
% Note, in brain network, there is no node-node affinity and edges are undirected.
%
% Reference
% Zhou, F., De la Torre, F.: Deformable graph matching. 
% In: Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. pp. 2922-2929 (2013)
%
% INPUT
% adj1        : weighted adjacency matrix, n1 x n1
% adj2        : weighted adjacency matrix, n2 x n2
% edge_aff_fn : edge affinity function
%
% OUTPUT
% K : global affinity, nn x nn where nn = n1*n2
%
% Update history
%     November 10, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

d1 = size(adj1, 1);
d2 = size(adj2, 1);

% elements above main diagonal
g1 = triu(adj1, 1);
g2 = triu(adj2, 1);

% compute edge-edge affinity KQ
edgeAttr1 = nonzeros(g1);
edgeAttr2 = nonzeros(g2);
m1 = length(edgeAttr1); % number of edges in g1
m2 = length(edgeAttr2); % number of edges in g2
KQ1 = repmat(edgeAttr1, 1, m2);
KQ2 = repmat(edgeAttr2', m1, 1);
KQ = edge_aff_fn(KQ1, KQ2);

% indices of non-zero elements
[x1, y1] = find(g1);
[x2, y2] = find(g2);

% edge affinity, i.e., off-diagonmal of global attr
I11 = repmat(x1, 1, m2);
I12 = repmat(y1, 1, m2);
I21 = repmat(x2', m1, 1);
I22 = repmat(y2', m1, 1);

I1 = sub2ind([d1, d2], I11(:), I21(:));
I2 = sub2ind([d1, d2], I12(:), I22(:));

% add the other direction since these are undirected edges
I1u = sub2ind([d1, d2], I12(:), I21(:));
I2u = sub2ind([d1, d2], I11(:), I22(:));

ind1 = [I1; I1u];
ind2 = [I2; I2u];
globalAttr = [KQ(:); KQ(:)];

% global attr K
d = d1 * d2;
K = sparse(ind1, ind2, globalAttr, d, d);
K = K + K'; % symmetry over main diagonal

end