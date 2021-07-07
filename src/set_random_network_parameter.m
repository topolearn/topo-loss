function [nSetting, nNode, nModule1, nModule2, p] = set_random_network_parameter(ind)
% Output parameters used in the simulation study.
%
% INPUT
% ind : linear index
%
% OUTPUT
% nSetting          : number of parameter setups for the simulation study
% nNode             : number of nodes
% nModule1,nModule2 : number of clusters/modules for each group
% p                 : overall probability of attachment within-group
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)


% parameters used in the simulation study
nodeArr = [12, 18, 24];
ModuleArr = ["23", "26", "36", "22", "33", "66"];
pArr = [.7, .8];
% default to 36 parameter setups for the simulation study
nSetting = length(pArr) * length(ModuleArr) * length(nodeArr);

if ind < 1 || ind > nSetting
    error('Error. Input must be an integer between 1 and %d.', nSetting);
end

[i, j, k] = ind2sub([length(pArr), length(ModuleArr), length(nodeArr)], ind);

nNode = nodeArr(k);
c = char(ModuleArr(j));
nModule1 = str2num(c(1));
nModule2 = str2num(c(2));
p = pArr(i);

end