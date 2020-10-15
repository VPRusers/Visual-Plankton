function f=coocfeat(filename)

%  Calculate 14 features from co-occurrence matrix
%  Input: filename of the image 
%  Output: feature vector of 14 features of the texture
%   Qiao Hu
%   09/29/03
 
%   R. M. Haralick, K. Shanmugam, and I. Dinstein
%   Texture Feature for Image Classification 
%   IEEE Trans. on Systems, Man Cybernetics, vol. 3, pp. 610-621, 1973. 
%
    N=16; M=8; L=8;
    epsilon=1e-8; 
    img=imread(filename);
    
    [r,c]=size(img);
    row=(1:fix(r/2))*2;
    img=img(row,:);       % To remove every other line for digital camera.  
%    img=histeq(img,N);   % histogram equatization make the feature worse.
    if isa(img,'uint8'),    % normal 8-bitimages     
       img=fix(double(img)/256*N);
    end
    if isa(img,'uint16'),   % 10-bit images saved as 16-bit images with most significant 6 bit set to 0  
      img=fix(double(img)/256/4*N);  
   end
    fea1=cooc(img,N,1);
    fea2=cooc(img,N,2);
    fea3=cooc(img,N,4);
    fea4=cooc(img,N,8);

    mrfeat(:,:,1)=mean(fea1,3);
    mrfeat(:,:,2)=max(fea1,[],3)-min(fea1,[],3);
    mrfeat(:,:,3)=mean(fea2,3);
    mrfeat(:,:,4)=max(fea2,[],3)-min(fea2,[],3);
    mrfeat(:,:,5)=mean(fea3,3);
    mrfeat(:,:,6)=max(fea3,[],3)-min(fea3,[],3);
    mrfeat(:,:,7)=mean(fea4,3);
    mrfeat(:,:,8)=max(fea4,[],3)-min(fea4,[],3);

  f=zeros(M*L,1); 
  px=zeros(N,L); py=zeros(N,L);
  pxpy=zeros(2*N,L); pxmy=zeros(N,L); 
  ind=[1:N]';
  for l=1:L,
%    co-occurrence matrix is symmetric   
     px(:,l)=sum(mrfeat(:,:,l),1)';
%     py(:,l)=sum(mrfeat(:,:,l),2);
     mx(l)=sum(px(:,l).*ind); 
%     my(l)=sum(py(:,l).*ind);
     sx(l)=sqrt(sum(px(:,l).*((ind-mx(l)).^2)));
%     sy(l)=sqrt(sum(py(:,l).*(ind-my(l))));
     
     for j=1:N,
        for k=1:N,
	   % probability density function p_(x+y)(k), p_(x-y)(k)	
           pxpy(j+k-1,l)=pxpy(j+k-1,l)+mrfeat(j,k,l);
	   pxmy(abs(j-k)+1,l)=pxmy(abs(j-k)+1,l)+mrfeat(j,k,l); 	
           % energy 
           f((l-1)*M+1)=f((l-1)*M+1)+mrfeat(j,k,l)*mrfeat(j,k,l);
           % contrast
	   f((l-1)*M+2)=f((l-1)*M+2)+(j-k)*(j-k)*mrfeat(j,k,l);
           % Inverse difference moment
           f((l-1)*M+4)=f((l-1)*M+4)+1/(1+(j-k)*(j-k))*mrfeat(j,k,l);
           % entropy
%           if mrfeat(j,k,l) > epsilon,  f(l*M)=f(l*M)-mrfeat(j,k,l)*log(mrfeat(j,k,l)); end
           f(l*M)=f(l*M)-mrfeat(j,k,l)*log(mrfeat(j,k,l)+epsilon);
        end
           % correlation
           f((l-1)*M+3)=f((l-1)*M+3)+j*px(j,l);
           % variance
           f((l-1)*M+5)=f((l-1)*M+5)+(j-mx(l))^2*px(j,l);
     end
    f((l-1)*M+3)= (f((l-1)*M+3)-mx(l)*mx(l))/sx(l)/sx(l);
    f((l-1)*M+6)=-sum(pxpy(:,l).*log(pxpy(:,l)+epsilon));
    f((l-1)*M+7)=-sum(pxmy(:,l).*log(pxmy(:,l)+epsilon));
  end




%   mean of range matrix of co-occurrence matrix
if 0
     mf1=mean(fea1,3);
     rf1=max(fea1,[],3)-min(fea1,[],3);
 
     mf2=mean(fea2,3);
     rf2=max(fea2,[],3)-min(fea2,[],3);

     mf3=mean(fea3,3);
     rf3=max(fea3,[],3)-min(fea3,[],3);


     mf4=mean(fea4,3);
     rf4=max(fea4,[],3)-min(fea4,[],3);
  
%    px=sum(pxy,2); py=sum(pxy,1); 
%     mx=my=mean2(pxy); 
%     stdx=std(px); stdy=std(py);  
%  14*2 feature from co-occurrence matrix
%  first calculate 5*2 features for test efficiency
  f=zeros(40,1);
  for j=1:N,
     for k=1:N,
%  Energy / Angular Second Moment in Harlick's paper
        f(1)=f(1)+mf1(j,k)*mf1(j,k);
        f(6)=f(6)+rf1(j,k)*rf1(j,k);
        f(11)=f(11)+mf2(j,k)*mf2(j,k);
        f(16)=f(16)+rf2(j,k)*rf2(j,k);
        f(21)=f(21)+mf3(j,k)*mf3(j,k);
        f(26)=f(26)+mf3(j,k)*mf3(j,k);
        f(31)=f(31)+rf4(j,k)*rf4(j,k);
        f(36)=f(36)+rf4(j,k)*rf4(j,k);
%  Contrast
        f(2)=f(2)+(j-k)*(j-k)*mf1(j,k);
        f(7)=f(7)+(j-k)*(j-k)*mf1(j,k);
        f(12)=f(12)+(j-k)*(j-k)*mf2(j,k);
        f(17)=f(17)+(j-k)*(j-k)*mf2(j,k);
        f(22)=f(22)+(j-k)*(j-k)*mf3(j,k);
        f(27)=f(27)+(j-k)*(j-k)*mf3(j,k);
        f(32)=f(32)+(j-k)*(j-k)*mf4(j,k);
        f(37)=f(37)+(j-k)*(j-k)*mf4(j,k);
%  Correlation(different from Harlick's paper)  
        f(3)=f(3)+j*k*mf1(j,k);
        f(8)=f(8)+j*k*rf1(j,k);
        f(13)=f(13)+j*k*mf2(j,k);
        f(18)=f(18)+j*k*rf2(j,k);
        f(23)=f(23)+j*k*mf3(j,k);
        f(28)=f(28)+j*k*rf3(j,k);
        f(33)=f(33)+j*k*mf4(j,k);
        f(38)=f(38)+j*k*rf4(j,k);

% Inverse Difference Moment        
        f(4)=f(4)+1/(1+(j-k)*(j-k))*mf1(j,k);
        f(9)=f(9)+1/(1+(j-k)*(j-k))*rf1(j,k);
        f(14)=f(14)+1/(1+(j-k)*(j-k))*mf2(j,k);
        f(19)=f(19)+1/(1+(j-k)*(j-k))*rf2(j,k);
        f(24)=f(24)+1/(1+(j-k)*(j-k))*mf3(j,k);
        f(29)=f(29)+1/(1+(j-k)*(j-k))*rf3(j,k);
        f(34)=f(34)+1/(1+(j-k)*(j-k))*mf4(j,k);
        f(39)=f(39)+1/(1+(j-k)*(j-k))*rf4(j,k);
% Entropy
        if mf1(j,k) > epsilon,  f(5)=f(5)-mf1(j,k)*log(mf1(j,k)); end
        if rf1(j,k) > epsilon,  f(10)=f(10)-rf1(j,k)*log(rf1(j,k)); end
        if mf2(j,k) > epsilon,  f(15)=f(15)-mf2(j,k)*log(mf2(j,k)); end
        if rf2(j,k) > epsilon,  f(20)=f(20)-rf2(j,k)*log(rf2(j,k)); end
        if mf3(j,k) > epsilon,  f(25)=f(25)-mf3(j,k)*log(mf3(j,k)); end
        if rf3(j,k) > epsilon,  f(30)=f(30)-rf3(j,k)*log(rf3(j,k)); end
        if mf4(j,k) > epsilon,  f(35)=f(35)-mf4(j,k)*log(mf4(j,k)); end
        if rf4(j,k) > epsilon,  f(40)=f(40)-rf4(j,k)*log(rf4(j,k)); end
     end 
 end
  
end % end 0     
          
