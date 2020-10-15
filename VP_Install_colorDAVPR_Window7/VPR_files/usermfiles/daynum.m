function [dn]=daynum(yr,mn,dy)

% function [dn]=daynum(yr,mn,dy)
%
% This function returns the daynumber of the days specified, and can
% be called with either (year,yearday) or (year,month,day).  The
% daynumber is referenced to 1900 if all values are after 1900, or to
% (nonexistent) 0 AD for values between 100 and 1900 AD.
%
% Events that occur on January 1st should be given yearday 0.XXXX.
%
% Two digit years are assumed to be in the year 19XX.
%
% There is a constraint on leap years that centuries not divisable by
% 400 are not leap years.

% CVL (12/7/95)

if nargin==2
	dy=mn;
	mn=ones(size(mn));
end
yr(find(yr<100))=yr(find(yr<100))+1900;

dy=dy(:);
mn=mn(:);
yr=yr(:);

dn=(mn>2)&((yr/4==floor(yr/4))-...
	(yr/100==floor(yr/100))+(yr/400==floor(yr/400)));
mr=cumsum([0 31 28 31 30 31 30 31 31 30 31 30])';
mn=mr(mn);

dn=dn+yr*365+ceil(yr/4)-ceil(yr/100)+ceil(yr/400)+mn+dy;

if min(dn)>693962
	dn=dn-693962;
end
