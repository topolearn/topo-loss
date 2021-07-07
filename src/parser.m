function val = parser(param, fieldName, default)
% Parse the parameter specified in a struct.
%
% INPUT
%   param     : struct containing graph matching parameters
%   fieldName : field name
%   default   : default field value
%
% OUTPUT
%   val : field value
%
% Update history
%     November 11, 2020 created - Tananun Songdechakraiwut (songdechakra@wisc.edu)

if isfield(param, fieldName)
    val = param.(fieldName);
else
    val = default;
end
