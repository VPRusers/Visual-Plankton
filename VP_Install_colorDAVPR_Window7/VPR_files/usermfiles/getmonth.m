function [month]=getmonth(n)
%outputs 3-letter abbreviation for the month of year 
%corresponding to inputs from 1 to 12

months=['January  ';'February ';'March    ';'April    ';'May      '; ...
        'June     ';'July     ';'August   ';'September';'October  '; ...
        'November ';'December ';];

month=sscanf(months(n,:),'%s');
