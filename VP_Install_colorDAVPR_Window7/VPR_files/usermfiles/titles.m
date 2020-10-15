function [titlestring]=titles(vn,b)
%automatically generates a title for vpr pcolor plots
%optional inputs include string for tow #  (eg. '10')
%and full data matrix (eg. e266v8.edt) for getting the dates and times

if nargin==0,vn=input('Enter VPR tow number:   ','s');end;

if nargin<2,
   eval(['load /home/davis/vprdat/e267/ctdft/e267v' vn '.edt']);
   eval(['b=e267v' vn ';']);eval(['clear e267v' vn ';']);
end;

lb=length(b);
numdate=b(1,19)*30+b(1,18);%crude julian day for daylight savings time switching
if numdate>81 & numdate<261,
   b(1,15)=b(1,15)-4;
   b(lb,15)=b(lb,15)-4;
   tz='(EDT)';
else,
   b(1,15)=b(1,15)-5;
   b(lb,15)=b(lb,15)-5;
   tz='(EST)';
end;

if b(1,15)<0,
  b(1,15)=b(1,15)+24;
  b(1,18)=b(1,18)-1;
end;

if b(lb,15)<0,
  b(lb,15)=b(lb,15)+24;
  b(1,18)=b(1,18)-1;
end;

starttime=[int2str(zeros(2-length(int2str(b(1,15))))) int2str(b(1,15))...
            int2str(zeros(2-length(int2str(b(1,16))))) int2str(b(1,16))];
startday=int2str(b(1,18));
startmonth=getmonth(b(1,19));
year=int2str(b(1,20));

endtime=[int2str(zeros(2-length(int2str(b(lb,15))))) int2str(b(lb,15))...
            int2str(zeros(2-length(int2str(b(lb,16))))) int2str(b(lb,16))];
endday=int2str(b(lb,18));
endmonth=getmonth(b(lb,19));

if startday==endday,
  titlestring=[startmonth ' ' startday ', 1995  ' starttime ' - ' endtime ' ' tz ' VPR ' vn];
else,
  titlestring=[startmonth ' ' startday '-' endday ', 1995  ' starttime ' - ' endtime ' ' tz ' VPR ' vn];
end;
