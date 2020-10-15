function area=barea(cont)
% This is a function to calculate the bug area in mm22.
% Input: 
% cont: contour of the bug
% Output:
% area: area of bug in mm2.
% By Qiao Hu 05/03/00
% modified by csd for new digital camera with square pixels 9/01

if nargin <1, error('Not enough arguments.');end   
 
%if cam ==4 
%   xmm=.0156;ymm=.0292; 
%else
%   xmm=.0459;ymm=.0875; xymm=.0988;
%end 
%xymm=.0331;

[x,y]=bsize(cont);
area =length(x);
