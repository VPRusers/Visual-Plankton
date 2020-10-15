function fea = loadfea(file, rowlen, domain)

% load feauture files
% start is the starting line
% the feature is stored row by row

% 2/10/97, Xiaoou Tang

if nargin < 3
  domain = [0,1];
end

fid = fopen(file,'r');
fseek(fid, 0, 'eof');		% goto end of file
len = ftell(fid);		% get length of file in bytes

rownum = len/(4*rowlen);
start = 1+fix(domain(1)*rownum);  	% starting row number, start from 1
endd = fix(domain(2)*rownum);    	% end max length

fseek(fid, 4*(start-1)*rowlen, 'bof');
fea=fread(fid,[rowlen, endd-start+1], 'float'); %read 1st row into 1st col
fea = fea'; 
fclose(fid);

%fseek(fid, 0, 'bof');	%REWIND

%fid = fopen(file,'r');
%nrows = fix(len/(4*rowlen));
%nelems = nrows*rowlen;
%[fea,count] = fread(fid,nelems,'float');
%collen = fix(count/rowlen);
%fea = reshape(fea, rowlen, collen)';
%fclose(fid);