function name = loadname(file, domain, rowlen)

% load feauture files
% start is the starting line
% the feature is stored row by row

% 2/10/97, Xiaoou Tang

global MACHINE
if MACHINE == 2
2
  fid = fopen(file,'r');
  if nargin < 3
    dum = fscanf(fid,'%c',200);
    rowlen = min(find(dum==10));
    if nargin < 2
      domain = [0,1];
    end
  end

  fseek(fid, 0, 'eof');		% goto end of file
  len = ftell(fid);		% get length of file in bytes
  rownum = len/rowlen;
  start = 1+fix(domain(1)*rownum);  	% starting row number, start from 1
  endd = fix(domain(2)*rownum);    	% end max length

  fseek(fid, (start-1)*rowlen, 'bof');		% character is one byte
  name = fscanf(fid, '%c', [rowlen, endd-start+1]);
  name = str2mat(name');
  fclose(fid);
else
  if nargin < 2
    domain = [0,1];
  end
  fid = fopen(file,'r');
  name = fscanf(fid, '%c'); 
  i1=[0 find(name==10)];
  rowlen = min(diff(i1));
  i2=i1(find(diff(i1)==rowlen)+1);
  name(i2)=blanks(length(i2));  % set the '/n' to blank for short file name
  name=name(name~=setstr(10)); % remove the '/n' from long file name
  rownum = length(name)/rowlen;
  name = reshape(name,rowlen, rownum)';

  start = 1+fix(domain(1)*rownum);  	% starting row number, start from 1
  endd = fix(domain(2)*rownum);    	% end max length
  name = name(start:endd, :);
  fclose(fid);
end