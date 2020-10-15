function [Bnan] = inside(xx,yy,xb,yb)
%
% function to blank a region outside a defined polygon whose vertices are
% defined by the (xb,yb) coordinates;
%
%           JC iv/93

 nb = length(xb);
 x = xx(:); y = yy(:); 
 np = length(x); pnt = zeros(size(x));
 xprev = x(np); uno=0;
 if np==1, x(2)=x(1)+x(1)*1.e-6; y(2)=y(1)+y(1)*1.e-6; np=2;
pnt = zeros(size(x)); uno=1; end

for p=1:np,
 
 if(x(p)-xprev) ~=0,
  xprev = x(p);
  nc = 0; k=1; 
  while k <= nb 
   kp1 = fix(k+1 -fix(k * fix((k/nb))));
   kw = k; iop=1;
    xdif = xb(k)-xb(kp1);
      if xdif == 0, iop = 0;, 
       elseif xdif < 0, ke = k + kp1 - kw;
       elseif xdif > 0, kw = kp1; ke = k + kp1 - kw;
      end
   if iop,
     xdiff = x(p)-xb(ke);
      if xdiff > 0, iop=0;end
       if iop,
	if xdiff == 0,
           nc = nc + 1;
           slope = (yb(ke)-yb(kw))/(xb(ke)-xb(kw));
           yc(nc) = yb(kw) + (x(p) - xb(kw)) * slope;
           iop = 0;
	  end
       if xdiff < 0, 
        if (x(p)-xb(kw)) <= 0, iop=0;
         else    
           nc = nc + 1;
           slope = (yb(ke)-yb(kw))/(xb(ke)-xb(kw));
           yc(nc) = yb(kw) + (x(p) - xb(kw)) * slope;
           iop = 0;
         end,
       end
       end
      
       if iop,
        nc = nc + 1;
        slope = (yb(ke)-yb(kw))/(xb(ke)-xb(kw));
        yc(nc) = yb(kw) + (x(p) - xb(kw)) * slope;
        iop = 0;
       end
  end
   k = k + 1;
  end
  ind = 0;
   if nc > 0,
	for kk=1:nc 
		if (yc(kk)-y(p)) < 0, ind = 1-ind; end
         end
   end

 else

  ind = 0;
  if nc > 0, 
	for kk=1:nc
		if (yc(kk)-y(p)) < 0, ind = 1-ind; end
         end

  end
 end
  pnt(p) = ind;
end

if uno, Bnan = zeros(size(x)); Bnan(:) = pnt; n =find(Bnan ~= 1);
        Bnan(n) = nan * ones(size(n)); Bnan=Bnan(2); 
else
        Bnan = zeros(size(xx)); Bnan(:) = pnt; n =find(Bnan ~= 1);
        Bnan(n) = nan * ones(size(n));
end
