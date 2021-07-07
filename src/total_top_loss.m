function totalCost = total_top_loss(adj1, adj2)
% Compute topological matching cost/loss.
%
% INPUT
% adj1, adj2 : weighted adjacency matrix
%
% OUTPUT
% totalCost : topological matching cost/loss
%
% Update history:
%     August 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

%% Compute set of births and set of deaths

G1 = graph(adj1, 'upper', 'omitselfloops');
G2 = graph(adj2, 'upper', 'omitselfloops');

% set of births
birthMtx1 = conncomp_birth(adj1);
birthMtx2 = conncomp_birth(adj2);
% number of births
nBirth1 = size(birthMtx1, 1);
nBirth2 = size(birthMtx2, 1);

% set of deaths
deathMtx1 = rmedge(G1, birthMtx1(:, 1), birthMtx1(:, 2)).Edges{:, :};
deathMtx2 = rmedge(G2, birthMtx2(:, 1), birthMtx2(:, 2)).Edges{:, :};
% sorting by weights in descending order
deathMtx1 = sortrows(deathMtx1, -3);
deathMtx2 = sortrows(deathMtx2, -3);
% number of deaths
nDeath1 = size(deathMtx1, 1);
nDeath2 = size(deathMtx2, 1);

%% Compute optimal matching through data augmentation

% \tau_0* between two sets of births
if nBirth1 > nBirth2
    birthArr2 = zeros(nBirth1, 1);
    if nBirth2 ~= 0
        birthArr2(1:nBirth2) = birthMtx2(:, 3);
        birthArr2(nBirth2+1:end) = max(birthMtx2(:, 3));
    end
    birthArr1 = birthMtx1(:, 3);

elseif nBirth1 < nBirth2
    birthArr1 = zeros(nBirth2, 1);
    if nBirth1 ~= 0
        birthArr1(1:nBirth1) = birthMtx1(:, 3);
        birthArr1(nBirth1+1:end) = max(birthMtx1(:, 3));
    end
    birthArr2 = birthMtx2(:, 3);

else
    birthArr1 = birthMtx1(:, 3);
    birthArr2 = birthMtx2(:, 3);

end

% \tau_1* between two sets of deaths
if nDeath1 > nDeath2
    deathArr2 = zeros(nDeath1, 1);
    if nDeath2 ~= 0
        deathArr2(1:nDeath2) = deathMtx2(:, 3);
        deathArr2(nDeath2+1:end) = min(deathMtx2(:, 3));
    end
    deathArr1 = deathMtx1(:, 3);

elseif nDeath1 < nDeath2
    deathArr1 = zeros(nDeath2, 1);
    if nDeath1 ~= 0
        deathArr1(1:nDeath1) = deathMtx1(:, 3);
        deathArr1(nDeath1+1:end) = min(deathMtx1(:, 3));
    end
    deathArr2 = deathMtx2(:, 3);

else
    deathArr1 = deathMtx1(:, 3);
    deathArr2 = deathMtx2(:, 3);

end

%% Compute topological loss

totalCost = sum((deathArr1-deathArr2).^2) + sum((birthArr1-birthArr2).^2);

end