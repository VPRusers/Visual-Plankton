% Only change lines marked with %****.

%clear all
%      [disc, cruise, tow]  
%tows = [1 2; 1 4; 1 5];              	%****
%cruise = str2mat('an9703'); 		%****
%discmat = str2mat('c:\data');	%****

% the above three matrices are used to identify training rois in several
% different tows, for program to combine together for training.
% For example, to combine tow 0 of cruise an9803 on disc '/files2/' and tow 8
% of cruise e001 on disc '/dark/data/', choose:
%
% tows = [1 0; 2 8];  % where 1 means first disc in discmat, 
%				and first cruise in cruise name matrix
%				2 means second disc, 0 & 8 means
%				tow #.           	
% cruise = str2mat('an9803', 'e001'); 		
% discmat = str2mat('/files2/', '/dark/data/');	
						
%taxas = str2mat('BARNACLE','CENTROPAGE','COPE_UID','DIAT_CHAET','FUZZY','OITHONA','OITHWEGGS','PHAEOCYSTIS','UNIDENTIFIED')  %****
% please only pick taxas that are clearly distinct.

dblen = size(tows,1) * size(taxas,1)
types = str2mat('gra','dst','geo','coo');
type_len = [160, 128, 29, 64];
select_type = 2;
cl_method = 4;
COMBINE = 0;
combind = []; 
taxas_orig = taxas;

if COMBINE
  combind = [1 6;7 7;8 8;9 9;10 10;11 11];
  taxacomb = str2mat('COPLARBARPTER','CTENOPHORE','DIAT_CHAET','DIATOM_ROD','NONCOPE','FUZZY');
  global COMBINE combind
%  dblen = size(tows,1) * size(taxacomb,1)
end

trperc = 1;	
%domtr = ones(1,size(taxas,1)*size(tows,1));
%domtr = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]  %****
domaintr = [zeros(1,dblen); domtr*trperc];

% domaintr is used to decide how many rois in each taxa to use for training.
% for example if the above taxas = ['DIAT_CHSOC', 'MARINESNOW', 'OTHER'];
% and there are 1000, 200, 500, rois in each of taxa, but you want to 
% pick only 200 rois for each of them, then set domaintr = [0 0 0; .2 1 .4];
% For above example combining two tows, use domtr = [1 1 .2 1 1 .5];
% the first three numbers are for first tow, second three numbers are for
% the second tow. Then domaintr= [0 0 0 0 0 0; 1 1 .2  1 1 .5];


flen = 30				%feature length 20-40 
TNET=min([TNET,20*size(taxas,1)])
%TNET = 300 				%neural number = roi_num/4,200-500
TP = [40, 200, 0.05, .99] 		%[display freq, max cycle, step, bias]
					%[50, 200-500, 0.05-0.2, .99] 
PN = TNET/2;				
mslen = 20;% fix(TNET/10);		%neighbor number for confidence level