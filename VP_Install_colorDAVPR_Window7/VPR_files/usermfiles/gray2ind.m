function [a,cm] = gray2ind(b,n)
%GRAY2IND Convert intensity image to indexed image.
%   GRAY2IND scales, then rounds, an intensity image to produce
%   an equivalent indexed image.
%
%   [X,MAP] = GRAY2IND(I,N) converts the intensity image I to an
%   indexed image X with colormap GRAY(N). If N is omitted, it
%   defaults to 64.
%
%   Class Support
%   -------------
%   The input image I can be of class uint8 or double. The class
%   of the output image X is uint8 if the colormap length is less
%   than or equal to 256. If the colormap length is greater than
%   256, X is of class double.
%
%   See also IND2GRAY.

%   Clay M. Thompson 10-5-92
%   modified by Chris Griffin, 5-6-96
%   Copyright 1993-1998 The MathWorks, Inc.  All Rights Reserved.
%   $Revision: 5.7 $  $Date: 1997/11/24 15:35:01 $

    
if nargin<1, error('Not enough input arguments.'); end

if nargin==1,
    n = 64;      % Default colormap size
end

if islogical(b)  % is it a binary image?
    if nargin == 1,   % n not specified
       a = uint8(b ~= 0);
       cm = [0 0 0; 1 1 1];
    else
       if n <= 256,  % we can still output uint8's
          a = uint8(b~=0);
          a ( a == 1 ) = n-1;
          cm = gray(n);
       elseif n > 256,   % output doubles
          a = double(b~=0);
          a ( a == 1 ) = n;
          a ( a == 0 ) = 1;
          cm = gray(n);
       end
    end
    return;
elseif isa(b, 'uint8')
    b = double(b)/255;     % Scale down to [0,1]
end

a = round(b*(n-1));  % The right answer for uint8 indexing
cm = gray(n);

if n <= 256,   % 256 or less colors, we can output uint8
    a = uint8(a);
else 
    a = a+1;   % The right answer for normal indexing (doubles)
end
