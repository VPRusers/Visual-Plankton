function ns=tree(D,trflag)

% function ns=tree(D,trflag)
% 
% Generates a sorted distance tree of the distances specified in
% D, and graphs the associated tree unless trflag is 0 (defaults
% to 1).
%
% Uses the recursive function treerc.m.
%
% WARNING: this function is recursive!  Some matrices may crash the
% matlab process.

disp('WARNING: this function is recursive!')
disp('Some matrices may crash the matlab process.')
disp('Press any key to continue or ^C to break now.')

pause

if nargin<2
	trflag=1;
end

l=size(D);
if l(1)~=l(2)
	error('Distance matrix not square')
end

if sum(sum(D-D'))~=0 
	error('Not a distance matrix - check diagonals and transpose')
end

len=length(D);         
D(find(D==0))=max(D(:))*len*ones(size(find(D==0)));

id=find(D(:)==min(D(:)));
idc=ceil(id/len);
idr=id-len*(idc-1);

i=1;
while max(D(:))~=min(D(:))

	id=find(D(:)==min(D(:)));
	idc=ceil(id/len);
	idr=id-len*(idc-1);
	n(i,:)=[idc(1) idr(1) min(D(:))];

	D(idr,:)=(D(idr,:)+D(idc,:))/2;
	D(:,idr)=(D(:,idr)+D(:,idc))/2;

	D(idc,:)=D(idr,:);
	D(:,idc)=D(:,idr);

	i=i+1;

end

[y,i]=sort(n(:,1));
n=n(i,:);
ns=n;

if trflag
	yset=max(n(:,3))/30;

	axis([0 length(n)+2 -2*yset max(n(:,3))*1.1])
	set(gca,'XTick',[],'XTicklabels',[]);
	hold on
	ln=length(n(:,1));
	n(:,4:5)=zeros(ln,2);

	xid=1;
	np=1;

	while xid<(ln+2)
		[n,xid,np]=treerc(n,xid,yset,np);
	end
end
