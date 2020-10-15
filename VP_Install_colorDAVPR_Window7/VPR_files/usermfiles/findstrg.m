function [i,v] = findstrg(s,ss)

%function [i,v] = findstrg(s,ss)
%
%finds the rows i in the string matrix s that are the same
%as the search string ss, 
%and also returns a length(s) vector v of ones and zeros, ones
%in the rows where the string ss was found, zeros elsewhere
%eg. if s is a list of names, findstrng will give the
%rows where the name ss is found.
%the number of columns in s has to match the number of
%characters in ss, including trailing spaces
%if s or ss are null strings, i=[] and v=[] are returned.

% CSD, 4/10/96

if isempty(s) | isempty(ss), i=[]; v=[]; return; end;

c=ones(size(s,1),1);

for i=1:length(ss);
   c=c & (s(:,i)==ss(i));
end;

i=find(c);
v=c;