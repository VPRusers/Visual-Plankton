function A = matpold(x,y,pd,iop)
%  function  A = matpold(x,y,nd,iop)
%
% Constructs a model matrix A (m,n) for a 2-D polynomial basis function.
% m is the length of x & y, and n is the number of terms in the
% polynomial.
%
% it also outputs the first (iop=1) and second (iop=2) derivatives.
%
x = x(:); y = y(:); m = length(x); nd = (pd+1)*(pd+2)/2;
A = zeros(m,nd); A(:,1) = ones(m,1);
jb = 1;
for j = 1:pd
   for k = 0:j
	jb = jb + 1; l = j - k; A(:,jb) = x.^l .* y.^k;
   end
end

% first derivatives

 if iop > 0, Ax = zeros(m,nd); Ay=Ax;
jb = 1;
for j = 1:pd
   for k = 0:j
	jb = jb + 1; l = j - k;
        Ax(:,jb) = l.* x.^(l-1) .* y.^k;
        Ay(:,jb) = k.* x.^l .* y.^(k-1);
   end
end
 A = [A;Ax;Ay]; end

% second derivatives

 if iop > 1, Axx = zeros(m,nd); Ayy=Axx; Axy=Axx;
 if pd < 2, '$$$ WARNING DEGREE INSUFICIENT FOR SECOND DERIVATIVE',end
jb = 1;
for j = 1:pd
   for k = 0:j
	jb = jb + 1; l = j - k;
        Axx(:,jb) = l.*(l-1).* x.^(l-2) .* y.^k;
        Ayy(:,jb) = k.*(k-1).* x.^l .* y.^(k-2);
        Axy(:,jb) = k.*l.* x.^(l-1) .* y.^(k-1);
   end
end
 A = [A;Ax;Ay;Axx;Ayy;Axy]; end