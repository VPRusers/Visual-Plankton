function [U_tmp,V_tmp,DAYS] = get_adcp(ADCPDIR,adcp_depth,scalef,Now)
% rework for old style (ie from CMO) - no accumulation!
%function [ACCUM_u,ACCUM_v,ACCUM_yd,ACCUM_lat,ACCUM_lon] = ...
%    get_adcp(ADCPDIR,fn,adcp_depth,doall)
%  to load 
% need depth to extract = adcp_depth and file name
% add call to adcp_pred to fill in blank adcp

% get file name
%[status, fn] = unix(['ls -ltr ',ADCPDIR,  ...
%                    'en*.mat | tail -1 | awk ''{print $9}'' ']);

%this parameter not input here
doall = 1;

savit = 0;
% dummy up existing vectors
ACCUM_u = [];
ACCUM_v = [];
ACCUM_yd = [];
ACCUM_lat = [];
ACCUM_lon = [];

% get new data

fn = [ADCPDIR,'en323_3']; % for vpr12
%eval(['load ',ADCPDIR,fn])
eval(['load ',fn])

% make dimensions match to avoid confusion:
if size(absu,2) == size(DAYS,1),
  DAYS=DAYS';
end
if size(absu,2) == size(nav,1),
  nav=nav';
end

% Extract depth of interest 
%   first, does the depth change?
aa = find(diff(DEPTH(size(DEPTH,1),:)) ~=0);
if ~isempty(aa),
   disp('ADCP depth scale changes - do it in chunks')
   aa = [0 aa size(DEPTH,2)];
   nchnk = size(aa,2) - 1;
else
  % one depth throught - dummy up for one chunk
  aa = [0 size(DEPTH,2)];
  nchnk = 1;   
end
U_tmp = [];
V_tmp = [];
for ichnk = 1:nchnk,
  ind = aa(ichnk)+1:aa(ichnk+1); % columns to use
  % find the bin assuming the depth we want is in the list:

  rr = find(DEPTH(:,ind(1)) == adcp_depth);
  % if the depth we want is NOT in the list find closest depth bin
  if isempty(rr),
    rr = find(abs(DEPTH(:,ind(1))-adcp_depth)  ...
	      == min(abs(DEPTH(:,ind(1))-adcp_depth)));
    rr = rr(1); % in case we're in the middle of a depth bin
  end
  % extract the data for this chunk
  U_tmp(ind) = absu(rr,ind);
  V_tmp(ind) = absv(rr,ind);
end

%  de-nan the arrays
aa = find(isnan(U_tmp));
U_tmp(aa) = [];
V_tmp(aa) = [];
DAYS(aa) = [];
%Lat_tmp(aa) = [];
%Lon_tmp(aa) = [];

if max(DAYS) < Now,
  % get predicted ADCP
   [Ufit, Vfit, t_need]=adcp_predict(U_tmp,V_tmp,DAYS,Now);
   U_tmp = [U_tmp Ufit];
   V_tmp = [V_tmp Vfit];
   DAYS = [DAYS t_need];
end

maxd = max(DAYS);
dd = floor(maxd);
hh = floor((maxd-dd)*24);
mm = (((maxd-dd)*24)-hh)*60;
disp(['ADCP data loaded: Max Time ',num2str(max(DAYS)),'(', ...
     int2str(dd),':',int2str(hh),':',int2str(mm),')'])

return
