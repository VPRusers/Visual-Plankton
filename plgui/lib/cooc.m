function [fea]=cooc(img,num,d)

% Co-occurrence matrices(d=1, alpha =0, 45, 90, 135 respectively) 
% Input: 
%    IMG---image array, NUM -- size of the co-occurrence matrix, 
%    
% Output:
%    COFEA1--COFEA4 
%    normalized co-occurrence matrices, normalized by the summation of 
%    the matrix. 
%            
% By Qiao Hu
% 09/28/03
%   
%   R, M. Haralick, K. Shanmugam, and I. Dinstein
%   Texture Feature for Image Classification
%   IEEE Trans. Systems, Man, and Cybernetics, 1972


%     neighborhood of a pixel X with d=1,
%     -------------
%     | 6 | 7 | 8 |
%     ------------
%     | 5 | X | 1 |
%     ------------
%     | 4 | 3 | 2 |
%     ------------
 
 if nargin < 2, num =max(img(:))+1;  
 elseif nargin <3, d=1; 
  end
epsilon = .0001;  
[row,col]=size(img);
cofea0=zeros(num); cofea45=zeros(num);
cofea90=zeros(num); cofea135=zeros(num);
  img=img+1;

  for i=1:row,
     for j=1:col,
        val = img(i,j); 
        if j < col-d+1,
            val1=img(i,j+d);
            cofea0(val,val1)=cofea0(val,val1)+1;
        end 
        if j>d, 
            val5=img(i,j-d);    
            cofea0(val,val5)=cofea0(val,val5)+1;
        end
        if i < row-d+1,
            val3=img(i+d,j);
            cofea90(val,val3)=cofea90(val,val3)+1;
        end 
        if i>d, 
            val7=img(i-d,j);    
            cofea90(val,val7)=cofea90(val,val7)+1;
        end
        if i >d & j >d,
           val6=img(i-d,j-d);
           cofea135(val,val6)=cofea135(val,val6)+1;
        end
        if i <row-d+1 & j <col-d+1,
           val2=img(i+d,j+d);
           cofea135(val,val2)=cofea135(val,val2)+1;
        end
        if i >d & j <col-d+1,
           val4=img(i-d,j+d);
           cofea45(val,val4)=cofea45(val,val4)+1;
        end
        if i <row-d+1 & j >d,
           val8=img(i+d,j-d);
           cofea45(val,val8)=cofea45(val,val8)+1;
        end
   
     end
  end
 
%cofea1=cofea0; cofea2=cofea45; 
%cofea3=cofea90; cofea4=cofea135;
fea(:,:,1)=cofea0/(sum(cofea0(:))+epsilon); fea(:,:,2)=cofea45/(sum(cofea45(:))+epsilon); 
fea(:,:,3)=cofea90/(sum(cofea90(:))+epsilon); fea(:,:,4)=cofea135/(sum(cofea135(:))+epsilon);
