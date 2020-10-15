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

eval(['load e259v' vn 'comb;']);
eval(['vlatlon=e259v' vn 'comb(:,2:3);']);
eval(['vtime=e259v' vn 'comb(:,1);']);

eval(['load v' vn 'cam2bugs.dat']);
eval(['bugs=v' vn 'cam2bugs;'])';
eval(['clear v' vn 'cam2bugs']);

[RANGE,AF,AR]=dist(vlatlon(:,1),vlatlon(:,2));
RANGE=[0 RANGE/1000];
vdist=cumsum(RANGE');

eval(['e259v' vn 'all=zeros(length(vlatlon),40);']);
eval(['e259v' vn 'all(:,1:10)=[e259v' vn 'comb(:,1:9) vdist];']);

%  Calculate volume sampled in each 2s interval, assuming no overlap of successive 
%  imaged volumes
%  Total volume in 2 seconds = 120 possible frames * volume imaged per frame
%  Volume imaged = width * height * depth of field 
%   **for e259, w=0.036 meters, h=0.026 meters, depth=0.042 meters**

ivol=0.036*0.026*0.042;         %volume imaged for each frame (m3)
vol=(120*ivol)/1000;            %total volume in 2 seconds, in L

R=input('How many mocness-time code calibration points do you have?      ');
for i=1:R
 tcode(i,:)=input('Enter time code at moc-tc calibration (hh mm ss):     ','s');
 mtime(i,:)=input('Enter moc  time at moc-tc calibration (hh mm ss):     ','s');
 end

moctime=(str2num(mtime(:,1:2))+(str2num(mtime(:,4:5))/60)+(str2num(mtime(:,7:8))/3600))/24;
tctime=(str2num(tcode(:,1:2))+(str2num(tcode(:,4:5))/60)+(str2num(tcode(:,7:8))/3600))/24;
clear tcode; clear mtime;

%Time code  - Moc time offsets
[dt]=polyfit(moctime,tctime,1);  %dt(1) is the slope of the line, dt(2) is y-interc

bugtime=fix(vtime(1))+(1/dt(1))*((bugs(:,1)+(bugs(:,2)/60)+((bugs(:,3)+(bugs(:,4)/100))/3600))/24);

i=find(bugs(:,6)~=0);   %Eliminate observations for which the idspconv2.f program called "0"
tmp=[bugtime(i), bugs(i,6:7)];

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
  [n,x]=hist(tmp2(n1:n2,1),vtime);

  %Now you have the number of bugs per each 2 second interval in time
  % for that taxon. convert that into the number of bugs per L
   if sum(n)~=0
     n=n'/vol;                %# of bugs / L

     %put data for that taxon in the "all" file
     eval(['e259v' vn 'all(:,(10+taxon))=n;']);
    
     end  %end if sum
   clear n;
   
   end    %End for taxon loop

eval(['save e259v' vn 'all e259v' vn 'all;']);
    





