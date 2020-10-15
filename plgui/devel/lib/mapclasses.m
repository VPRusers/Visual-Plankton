function [templt] = mapclasses(c, cvals)

% MAPCLASSES maps class values back to template values
% Inputs:
%    C,		A matrix of class numbers
%    CVALS,	Vector mapping each class number to actual class values 
% Outputs:
%    TEMPLT,  	The resulting templt matrix
% Usage:
%    templt = mapclasses(c,cvals)
% 
% This function is similar to ind2gray except the indexing is different.

% 
% Created:       5/18/95, X. Tang


map =  1 + [0 cvals];
templt = zeros(size(c));
templt(:) = map(c+1)-1;
