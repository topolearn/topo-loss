function out = edge_aff_fn(KQ1, KQ2)
% Compute element-wise edge affinity, which is somewhat inverse of metrics.
%
% Reference
% Zhou, F., De la Torre, F.: Deformable graph matching. 
% In: Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. pp. 2922-2929 (2013)
%
% 
%
% INPUT
% KQ1, KQ2 : matrix whose entries are edge weights
%
% OUTPUT
% out : matrix whose entries are element-wise edge affinity
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

out = exp((-(KQ1 - KQ2).^2)/.15);

end