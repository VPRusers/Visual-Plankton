function [b_dis] = batta(c, m, p);
% BATTA   Bhattacharyya distance given class means and variances
% ***************************************************************************
% Inputs:
%    C,  Variance matrix, col # = feature #; row # = class #.
%    M,  Mean matrix,  col # = feature #; row # = class #.
%    PP, PDF. 
% Outputs:
%    B_DIS, Distance vector, each element is the distance of a feature. 
% Usage:
%    b_dis = batta(c, m);
% Defaults:
% Functions:         

%  Notes: 
%     There are two way to average multiclass distance . One is simply average
%     the Bhatta distance. The other is to average the error bound, that is to 
%     average exp(-B). We use the later one.

% Created:       8/24/94, Xiaoou Tang
% Last modified: 2/25/95, X. Tang
%***************************************************************************

[clus, dim] = size(c);
b_dis = zeros(1, dim);
for k = 1:dim                % feature dimension #
    n = 1;
    for i = 1:clus-1         % class i
        for j = i+1:clus     % class j
            b(n) = 1/4*log((c(i,k)/c(j,k)+c(j,k)/c(i,k)+2)/4)+1/4*(m(i,k)-m(j,k))^2/(c(i,k)+c(j,k));        % kth dimension's class i and j distance
            pp(n) = sqrt(p(i)*p(j));
            n = n+1;
        end
    end
    size(b);
%    b_dis(k) = sum(b)/(n-1); 
%    b_dis(k) = sum(exp(-b));
    b_dis(k) = sum(pp.*exp(-b));          % add PDF
end
b_dis = ones(size(b_dis))./(b_dis+eps);   % inverse of the error bound
