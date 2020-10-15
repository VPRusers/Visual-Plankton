function s = basename(str);

% To get the tail of a full file name: /dir/file.m to file.m

% Created X. Tang, 8/18/95
%****************************************

ind = find(str == filesep);
if ind
   s = str(max(ind)+1:length(str));
else
   s = str;
end
