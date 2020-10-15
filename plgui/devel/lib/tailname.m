function s = tailname(str);

% To get the tail of a full file name: /dir/file.m to m

% Created   X. Tang, 8/18/95
%****************************************

ind = find(str == '.');
if ind
  s = str(max(ind)+1:length(str));
else
  error('no tail of file name excist');
end
