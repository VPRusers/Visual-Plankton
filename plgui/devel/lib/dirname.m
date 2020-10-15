function s = dirname(str);

% To get the tail of a full file name: /dir/file.m to /dir/

% Created X. Tang, 9/30/95
%****************************************

ind = find(str == '/');
if ind
   s = str(1:max(ind));
else
   s = [];
   disp('Empty output of dirname function');
end