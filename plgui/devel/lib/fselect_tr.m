function [y,faxis,dist,sdist_ind,evec_mat,evalue_x] = ...
                             fselect_tr(x,mx,flen, type, evec_mat, evalue_x)
% FSELECT_TR   Feature selection.
% ***************************************************************************
% Inputs:
%    X,    feature vector matrix, each row is an feature vector observation.
%    MX,   class count vector, or class number if same length
%    TYPE, feature selection method switch, 1 = Bhattacharyya, 2 = KLT, 
%          3 = Bha. + KLT, 4 = KLT + Bha.
%    FLEN, length of selected features. 
%    EVEC_MAT eigen vector matrix.
%    EVALUE_X eigen value vector. 
% Outputs:
%    Y,    selected feature vector matix, with FLEN colums and same rows as X.
%    FAXIS selected feature axis
%    DIST  full distance vector
%    SDIST_IND selected feature index, also index for DIST
%    EVEC_MAT eigen vector matrix.
%    EVALUE_X eigen value vector.
% Usage:
%    [y, faxis] = fselect_tr(x, mx);
%    [y, faxis] = fselect_tr(x, mx, flen);
%    [y,faxis,dist,sdist_ind,evec_mat,evalue_x]
%                     = fselect_tr(x,mx,flen, type, evec_mat, evalue_x)
% Defaults:
%    FLEN = min (3, colum # of X).
%    TYPE = 2.
% Functions:         
%    batta_4_select, eigen, 

% Created:       2/24/95,   Xiaoou Tang
% Modified:      3/27/95,   X. Tang        add evec output
% Last modified: 9/8/95,    X. Tang        remove type output, add cn check 
%                                          add dist output
% ***************************************************************************
evec_mat=[]; evalue_x=[];
[xr,xc] = size(x);
if nargin == 2
   flen = min(3, xc); type = 2;
elseif nargin == 3
   type = 2;
elseif nargin > 6
   error('Too many arguments.')
end

if flen > min(size(x)),
   error('Selected feature vector length can not exceed original data')
end 

if length(mx) == 1          % if input class number
   mx = ones(mx,1)*xr/mx;
end

if type == 1
   dist = batta_4_select(x, mx);
elseif type == 2
%   x_i = x(1:mx(1),:); size(x_i)
   [evec_mat, evalue_x] = eigen(x);
   dist = evalue_x;
elseif type == 3
   if nargin <6                           % no input from type 2
      [evec_mat, evalue_x] = eigen(x);
   end   
   x = x*evec_mat;                        % project training data
   dist = batta_4_select(x, mx);
elseif type == 4
   if nargin <6
      [evec_mat, evalue_x] = eigen(x);
   end
   dist = evalue_x;
   [sdist, sdist_ind] = sort(dist);
   sdist_ind = flipud(sdist_ind(:));      % largest first
   sdist_ind = sdist_ind(1:flen);         % only use the first FLEN features 
   faxis1 = evec_mat(:, sdist_ind);
   x = x*faxis1;                          % project training data
   dist = batta_4_select(x, mx); % select among top flen 
end

[sdist, sdist_ind] = sort(dist);
sdist_ind = flipud(sdist_ind(:));        % largest first
sdist_ind = sdist_ind(1:flen);           % only use the first FLEN features 

if type == 1
   y = x(:, sdist_ind);
   faxis = sdist_ind';
elseif type == 2
   faxis = evec_mat(:, sdist_ind);
   y = x*faxis;
elseif type == 3
   y = x(:, sdist_ind);    
   faxis = evec_mat(:, sdist_ind);
elseif type == 4
   y = x(:, sdist_ind);    
   faxis = faxis1(:, sdist_ind);
end   
