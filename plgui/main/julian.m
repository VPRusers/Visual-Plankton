%convert from date to julian day
function [day,hour] = julian(date)
	monthnames = {'Jan','Feb','Mar','Apr','May','Jun','Jul',...
				  'Aug','Sep','Oct','Nov','Dec'};
	monthdays = [0 31 28 31 30 31 30 31 31 30 31 30 31; ...
				 0 31 29 31 30 31 30 31 31 30 31 30 31];

	day = str2num(date(1:2))-1;
	monthstr = date(4:6);
	year = str2num(date(8:11));
	hour = str2num(date(13:14));

	leap = (mod(year,4) == 0) & (mod(year,100) ~= 0) | (mod(year,400) == 0);
	leap = leap+1;

	for i = 1:12
		day = day+monthdays(leap,i);
		if (monthstr == monthnames{i})
			break;
		end
	end
