function s = firstname(str);

% To get the first name of a full file name: /dir/file.etc.m to /dir/file

% Created X. Tang, 8/18/95
%****************************************

ind = find(str == '.');
if ind
  s = str(1:min(ind)-1);
else
  s = str;
end
