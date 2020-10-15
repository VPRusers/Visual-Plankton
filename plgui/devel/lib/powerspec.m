function [ps] = powerspec(x)
% POWERSPEC  computes half matrix of power spectrum
% ***************************************************************************
% Inputs:
%    X,  an rectangular image neighborhood
% Outputs:
%    PS, the half matrix power spectrum as a row vector
% Usage:
%    [ps] = powerspec(x)

% History:       
%	5/04/95, X. Tang	Created. Extracted from fextract_freq.m
%***************************************************************************

xf = fftshift(fft2(x-mean(mean(x))));
dm_half = floor(size(x,2)/2) + 1;                   % half size + 1
xf_half = xf(:, 1:dm_half); % use half data

ps = abs(xf_half(:)'); 			            % power
