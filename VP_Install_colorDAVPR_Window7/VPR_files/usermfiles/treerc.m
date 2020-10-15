function [n,xid,np]=treerc(n,xid,yset,np)

if(n(1,4)>0)
	n(find(n(:,4)==n(1,4)),4)=(np(1))*...
		ones(length(find(n(:,4)==n(1,4))),1);	
	txid=n(1,4);
	tyid=n(1,5);
	n(find(n(:,5)==n(1,5)),5)=n(1,3)*...
		ones(length(find(n(:,5)==n(1,5))),1);	
else
	txid=xid;
	xid=xid+1;
	tyid=n(1,5);
	h=text(txid,-1*yset,num2str(n(1)));
	set(h,'HorizontalAlignment','center','FontSize',10)
	n(find(n(:,1)==n(1)),4)=(xid-1)*...
		ones(length(find(n(:,1)==n(1))),1);	
	n(find(n(:,1)==n(1)),5)=n(1,3)*...
		ones(length(find(n(:,1)==n(1))),1);	
end

plot([txid txid],[tyid n(1,3)],'-')

nid=find(n(:,1)==n(1,2));

if nid~=[]
	for i=1:length(nid)
		l=length(n(:,1));
		ntemp=n(1:nid(1)-1,:);
		[n,xid,np]=treerc(n(nid(1):l,:),xid,yset,np);
		n=[ntemp;n];
	end
	plot([np(1) np(1) ntemp(1,4)],...
		[np(2) ntemp(1,3) ntemp(1,5)],'-')
	np=[(np(1)+ntemp(1,4))/2 ntemp(1,5)];
else
	h=text(xid,-1*yset,num2str(n(1,2)));
	set(h,'HorizontalAlignment','center','FontSize',10)
	plot([xid xid n(1,4)],[0 n(1,3) n(1,5)],'-')
	np=[(xid+n(1,4))/2 n(1,5)];
	xid=xid+1;
end

n=n(2:length(n(:,1)),:); 