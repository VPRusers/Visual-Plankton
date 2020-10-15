%   bugplot.m
%  This is a program to look at the abundance of various taxa from
%   VPR tows.  You can look at any one of the 30 taxa that have been
%   placed in the e###v##all.mat file.  The program will run iteratively
%  until you answer "no".     CJA  1/25/96

vn=input('Enter VPR tow number:   ','s');
eval(['load zeb' vn 'all']);
eval(['bugsnall=zeb' vn 'all;'])';
eval(['clear zeb' vn 'all;'])';

vdist=bugsnall(:,8);
%press=(-1)*bugsnall(:,4);
press=bugsnall(:,4);

temptz=[vdist press bugsnall(:,5)];
save temptz.dat temptz -ascii

%Run mgridder

   load temptz.grd
   temptz(find(temptz==-1))=NaN*ones(size(temptz(find(temptz==-1))));
   temptz(find(temptz<0))=zeros(size(temptz(find(temptz<0))));
   
  cs=[10:2:22];  %full length
  
 ptitle1=input('Enter plot title (taxon1):   ','s');

 ptitle2=input('Enter plot title (taxon2):   ','s');

 ptitle3=input('Enter plot title (taxon3):   ','s');
 
   %Create ascii file for gridding

   taxon1=input('Enter taxon number number 1:   ');
   taxon2=input('Enter taxon number number 2:   ');
   taxon3=input('Enter taxon number number 3:   ');

   
   bugtz1=[vdist press bugsnall(:,(taxon1+8))];
%   bugtz1=[vdist press bugsnall(:,taxon1)];
   save bugtz1.dat bugtz1 -ascii;

   bugtz2=[vdist press (bugsnall(:,18)+bugsnall(:,11))];
%     bugtz2=[vdist press bugsnall(:,taxon2)];
   save bugtz2.dat bugtz2 -ascii;

%   bugtz3=[vdist press bugsnall(:,(taxon3+8))];
   bugtz3=[vdist press bugsnall(:,taxon3+8)];
   save bugtz3.dat bugtz3 -ascii;


   %Here we go out and run mgridder....

   






