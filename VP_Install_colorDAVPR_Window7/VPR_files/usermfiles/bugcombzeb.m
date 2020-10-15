%   bugcomb.m
%   This program loads in the vpr ctd data file to which the lat and long
%   have been added previously and also loads in the bug count file for
%   that tow.  For all 30 taxa, the number of observations in each time
%   interval in the vpr ctd data is determined and the number of bugs
%    per L is calculated.  The data from the 30 taxa are then output
%     along with the ctd data into a master file which contains 10 columns
%    of ctd data (time, lat, long, press. ptemp, sal, sigma, fl. atte,
%     along-track distance (kn)) and 30 columns of the abundance of the 30 taxa
%     CJA  1/26/96

vn=input('Enter VPR tow number:   ','s');

%eval(['load e259v' vn 'comb;']);
%eval(['vlatlon=e259v' vn 'comb(:,2:3);']);
%eval(['vtime=e259v' vn 'comb(:,1);']);

load zeb12a.edt;
vtime=zeb12a(:,1);
vlatlon=zeb12a(:,19:20);

eval(['load zeb' vn 'darkbugs.dat']);
eval(['bugs=zeb' vn 'darkbugs;'])';
eval(['clear zeb' vn 'darkbugs']);

%Convert the time code in the bug file to the real time code
   t=find(bugs(:,1)==0);
   s=find(bugs(:,1)~=0);
   bugtime(t)=((bugs(t,1)+bugs(t,2)/60+bugs(t,3)/3600)/24)-((bugs(1,1)+bugs(1,2)/60+bugs(1,3)/3600)/24)...
                  +((19+40/60+04/3600)/24);
   bugtime(s)=((bugs(s,1)+bugs(s,2)/60+bugs(s,3)/3600)/24)-((bugs(s(1),1)+bugs(s(1),2)/60+bugs(s(1),3)/3600)/24)...
                  +((20+40/60+6/3600)/24);

   bugtime=bugtime+205;

i=find(vtime<max(bugtime) & vtime>min(bugtime));

[RANGE,AF,AR]=dist(vlatlon(i,1),vlatlon(i,2));
RANGE=[0 RANGE/1000];
vdist=cumsum(RANGE');

%eval(['zeb' vn 'all=zeros(length(vlatlon(i,:)),40);']);
eval(['zeb' vn 'all=zeros(length(i),38);']);
var=[2 4 13 14];
eval(['zeb' vn 'all(:,1:8)=[vtime(i) vlatlon(i,1:2) zeb12a(i,var) vdist];']);

zeb12all(:,4)=(zeb12all(:,4)+abs((min(zeb12all(:,4)))))*(-1);   %Correction for depth offset
%zeb12all(:,4)=(zeb12all(:,4)+mean(abs(zeb12all(1:20,4))))*(-1);   %Correction for depth offset

%  Calculate volume sampled in each 2s interval, assuming no overlap of successive 
%  imaged volumes
%  Total volume in 2 seconds = 120 possible frames * volume imaged per frame
%  Volume imaged = width * height * depth of field 
%   **for e259, w=0.036 meters, h=0.026 meters, depth=0.042 meters**

%ivol=0.036*0.026*0.042;
ivol=22;                       %volume imaged for each frame (ml)
vol=(120*ivol)/1000;            %total volume in 2 seconds, in L

R=input('How many mocness-time code calibration points do you have?      ');
for j=1:R
 tcode(j,:)=input('Enter time code at moc-tc calibration (hh mm ss):     ','s');
 mtime(j,:)=input('Enter moc  time at moc-tc calibration (hh mm ss):     ','s');
 end

moctime=(str2num(mtime(:,1:2))+(str2num(mtime(:,4:5))/60)+(str2num(mtime(:,7:8))/3600))/24;
tctime=(str2num(tcode(:,1:2))+(str2num(tcode(:,4:5))/60)+(str2num(tcode(:,7:8))/3600))/24;
clear tcode; clear mtime;

%Time code  - Moc time offsets
[dt]=polyfit(moctime,tctime,1);  %dt(1) is the slope of the line, dt(2) is y-interc

%Make bugtime the same as vtime (mocness time) by adding 50 seconds to the bugtime
bugtime=((1/dt(1))*(bugtime-fix(bugtime)))+fix(bugtime);

h=find(bugs(:,6)~=0);   %Eliminate observations for which the idspconv2.f program called "0"
tmp=[bugtime(h), bugs(h,6:7)];

%Sort matrix by taxon
[y,index]=sort(tmp(:,2));
tmp2=tmp(index,:);

%Use hist to determine where in tmp2 each taxon is located
[nn,xx]=hist(tmp2(:,2),1:30);ns=cumsum(nn');

for taxon=1:30;

 %use hist to determine the range of rows in tmp2 for each taxa
 %[nn,xx]=hist(tmp2(:,2),1:30);ns=cumsum(nn');
  n1=ns(taxon)-nn(taxon)+1;n2=ns(taxon);

  %next use hist to bin these rows by vtime (ctdtime) (2 s bins)
  if n2>n1
  [n,x]=hist(tmp2(n1:n2,1),vtime(i));
  else n=zeros(size(i));
  end

  %Now you have the number of bugs per each 2 second interval in time
  % for that taxon. convert that into the number of bugs per L
   if sum(n)~=0
     n=n'/vol;                %# of bugs / L

     %put data for that taxon in the "all" file
     eval(['zeb' vn 'all(:,(8+taxon))=n;']);
    
     end  %end if sum
   clear n;
   
   end    %End for taxon loop

eval(['save zeb' vn 'all zeb' vn 'all;']);
    





