function [jd] = julian(d,mo,y,h,m,s);
%function [jd] = julian(d,mo,y,h,m,s)
%
%Returns Julian time from input of day, month (numerical), year,
%  and time of day in hours, minutes, and seconds (scalars or arrays)
%Julian time is in decimal days since 0000 on Jan 1.
%Julian time starts at 0.
%Leap year is taken into account.

%                       (CSD - April 8, 1996)
%                       (modified for vectors 8/4/96 - CSD)

ly=(y/4==floor(y/4));

t=h/24.*ones(size(d))+m/(24*60).*ones(size(d))+s/(24*60*60).*ones(size(d));

md=[0 31 59 90 120 151 181 212 243 273 304 334]';

d=d-1;

jd=md(mo)+d+t;

jd(mo>2)=jd(mo>2)+ly(mo>2);
