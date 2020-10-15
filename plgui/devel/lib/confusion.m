function c = confusion(target, result)
% CONFUSION Compute the comfution matrix
% ***************************************************************************
% Inputs:
%    TARGET true class label, which doesn't have to be consecutive number.
%    RESULT classified label. 
% Outputs:
%    C, the comfution matrix. Row is the target. Column is the result.
% Usage:
%    c = confusion(target, result)
% Defaults:
% Functions:         

% Created:       5/5/95, Xiaoou Tang
% modified by CSD and QHU
%**************************************************************************
% mincl = min([target;result]);
mincl = 1;
maxcl = max([target;result]);

clcount =mincl:maxcl;
k =length(clcount);
c = zeros(k);
if 0
    k = 0;
    for i = mincl:maxcl
        [dumy, ind] = find(target == i);
        if ind 
            k = k+1;
            clcount(k) = i;
        end
    end
end %0

for j = 1:k
    for i = 1:k
        c(i,j) = sum((target == clcount(j)) & (result == clcount(i)));
    end
end

%for j = 1:k
%   [targetj, ind] = find(target == clcount(j));   
%   for i = 1:k
%      c(i,j) = sum(result(ind) == clcount(i));
%   end
%end



