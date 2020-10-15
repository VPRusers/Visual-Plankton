function [xdisp,ydisp,reftime]=my_adcpdisp_noload(reftime,time,u,v,adcptime)
%function [xdisp,ydisp,reftime]=my_adcpdisp_noload(reftime,time,u,v,adcptime)
% This code computes vectors of progressive displacements due to the current
% velocity at a given depth as measured by the shipboard ADCP.  
%
% Input arguments:
% reftime (1x1) - reference time in yeardays - end time of integration
% time (1xn) - a list of times for which you want the integrated displacement
% u,v,adcptime - the adcp data which has already been extracted from the 
%                adcp database using: get_adcp.m 
% Output is xdisp,ydisp in km.
%
% The time array must be monotonically increasing, and have a start value which
% is greater than the reference time.
%
% written by Miles Sundermeyer	8/10/96
% adapted for use in CMO 1996 by CJS 8/27/96
% reftime is now AFTER all the other times and displacements are larger for
% times farther in the past

% Make sure input arguments are as expected
reftime = reftime(:);
time = time(:);

rtsave = reftime;
% make sure that the time and reference time jibe with above restrictions
if ( ~(isempty(find((time-reftime)>0))) )
   error('ERROR: All values in time array must be earlier than the reference time.');
elseif ( ~(isempty(find(diff(time)<0))) )
   error('ERROR: The time array must be monotonically increasing.') 
end

% check for reftime greater than all ADCP times
if max(adcptime) < reftime;
  reftime = adcptime(length(adcptime)-1);
  disp(['my_adcp: reftime > max(adcptime) set = to the max of ', ...
       sprintf('%8f',reftime)])
end
% check for times beyond reference time
ttt = find(time > reftime);
if length(ttt) > 0,
  time(ttt) = ones(size(ttt)) * reftime;
  disp('my_adcp: Warning! times > max(adcptime) set equal to that max')
end

% determine index of ADCP time closest to reftime ( last index needed)
refindex = find(abs(adcptime-reftime)==min(abs(adcptime-reftime)));
refindex = refindex(length(refindex)); 	% take latest index, if there are many

if abs((adcptime(refindex)-reftime)*24*60) > 1e-15,
  disp(' Time used as start of ADCP progressive displacement');
  disp([' vector differs from specified reference time by ', ...
  sprintf('%6e',(adcptime(refindex)-reftime)*24*60),' minutes (pos => later).'])
  disp(' ... interpolating back to get proper values for reftime ...');
end
% find the index just before the earliest requested time (first index needed)
index1 = find(abs(adcptime-min(time))==min(abs(adcptime-min(time))));
index1 = index1(length(index1));

% now figure out the progressive displacement between the time array and the
% reference time
% assume we have data earlier than needed

% determine indices of ADCP to use for integreation
indx = index1:refindex;
%indx = index1-1:refindex;
% did this to fix problem creating vu graph on short notice! CJS 9/19/97
%indx = index1-1:refindex+1;
adcpdelt = diff(adcptime)*24*3600;   % secs elapsed between adcp records

%adcpxdisp = fliplr([cumsum(fliplr(u(indx)) .* adcpdelt(indx))] / 1000); % km
%adcpydisp = fliplr([cumsum(fliplr(v(indx)) .* adcpdelt(indx))] / 1000); % km
% the lines above are in error - they associate the wrong time with the u
%    and v data - lines below are correct

adcpxdisp = fliplr([cumsum(fliplr(u(indx) .* adcpdelt(indx)))] / 1000); % km
adcpydisp = fliplr([cumsum(fliplr(v(indx) .* adcpdelt(indx)))] / 1000); % km

if length(indx) <= 1;
  disp(['Cannot advect patch - max adcptime: ',num2str(max(adcptime)), ...
       ' reftime = ',num2str(rtsave)])
  xdisp = ones(size(time))*nan;
  ydisp = ones(size(time))*nan;
  return
end

% now interpolate these progressive displacements onto our time array, including reftime
xdisp = interp1(adcptime(indx),adcpxdisp,[time; reftime]);
ydisp = interp1(adcptime(indx),adcpydisp,[time; reftime]);

% We have now xdisp, ydisp reference to the reftime.  We have
% interpolated the displacement vector onto our reftime, using the previous
% record, and now can subtract the interpolated displacement to get the best
% possible 'zero' for our reference time.

% Now set these xdisp,ydisp arrays to be the displacement w.r.t. reftime
xdisp = xdisp(1:length(xdisp)-1) - xdisp(length(xdisp));
ydisp = ydisp(1:length(ydisp)-1) - ydisp(length(ydisp));

return
