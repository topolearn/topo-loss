function adj = random_modular_graph(d, c, p, mu, sigma)
% Generate random modular network.
%
% INPUT
% d : number of nodes
% c : number of clusters/modules
% p : probability of attachment within module
% mu, sigma : used for random edge weights
%
% OUTPUT
% adj : adjacency matrix
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)


% adjacency matrix
adj = zeros(d);

% nodes are even distributed among modules
modules = cell(c, 1);
for k = 1:c
    modules{k} = round((k-1)*d/c+1):round(k*d/c);
end

for i = 1:d
    for j = i + 1:d
        module_i = ceil(c*i/d); % the module of node i
        module_j = ceil(c*j/d); % the module of node j

        % check if nodes i and j belongs to the same module
        if module_i == module_j
            % probability of attachment within module
            if rand <= p
                w = normrnd(mu, sigma);
                adj(i, j) = max(w, 0);
                adj(j, i) = max(w, 0);
            else
                % noise
                w = normrnd(0, sigma);
                adj(i, j) = max(w, 0);
                adj(j, i) = max(w, 0);
            end

        else
            % probability of attachment between modules
            if rand <= 1 - p
                w = normrnd(mu, sigma);
                adj(i, j) = max(w, 0);
                adj(j, i) = max(w, 0);
            else
                % noise
                w = normrnd(0, sigma);
                adj(i, j) = max(w, 0);
                adj(j, i) = max(w, 0);
            end

        end
    end
end

end