function s = rootname(str);

% To get the root of a full file name: /dir/file.m to /dir/file

% Created   X. Tang, 8/18/95
%****************************************

ind = find(str == '.');
if ind
  s = str(1:max(ind)-1);
else
  s = str;
end
