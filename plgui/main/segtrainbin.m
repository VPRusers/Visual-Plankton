function [tr_feature, faxis_max, t1, t2, t3, t4, mship, x_mean, x_std, ax_mat, axind, ...
	x_mean2, x_std2 ] = ...
	segtrainbin(cl_dir, tname, tows, cruise, discmat, taxas, combind, taxas_orig, types, type_len, ...
domaintr, flen, select_type, TNET, TP, PN, cl_method, mslen,  groupind, c1,c2)

% Main function for classification

% 11/13/96 X. Tang
% modified extensively by Q. Hu and C. Davis 

% Build training feature data matrix
[tr_feature_all, trimfiles, trmx, taxas] = ...
    buildfeamatbin(tows, cruise, discmat, types, taxas, domaintr,type_len);
orig_tr_feature_all=tr_feature_all;
taxas=char(taxas);
trmx

global COMBINE combind
if COMBINE			% combine taxas into two class
    for i = 1:size(combind,1)
        trmx_dum(i) = sum(trmx(combind(i,1):combind(i,2)))
    end
    trmx = trmx_dum
end

% Training data feature selection
NORM_ON = 1;
if NORM_ON
    disp(['feature normalization']); 
    [tr_feature_all, x_mean, x_std] = normalize(tr_feature_all);
else
    disp(['no feature normalization performed']);   
end

if exist('groupind')
    if nargout > 10 		% x_mean2, second  normalization is on
        [tr_feature, faxis_max, ax_mat, axind, x_mean2, x_std2] = ...
            selectfea(tr_feature_all, trmx, flen, select_type, groupind, c1,c2);
    else
        [tr_feature, faxis_max, ax_mat, axind] = ...
            selectfea(tr_feature_all, trmx, flen, select_type, groupind, c1,c2);
    end
else
    [tr_feature, faxis_max] = ...
        selectfea(tr_feature_all(:,1:233), trmx, flen, select_type);
end

% Training single NN classifier (uses "other" category)
[t1, t2, t3, t4] = training_t(cl_method, tr_feature, TNET, TP, trmx, PN);
if cl_method == 4, 
    tr_correct = t3; 
    mship = member(t1, tr_feature, trmx, mslen);	% neuron member ****
end
taxas=char(taxas);
%save single NN classifier parameter file
com = ['save ',cl_dir, tname,'nn faxis_max t1 t2 t3 t4 mship x_mean x_std tows discmat taxas combind taxas_orig types type_len select_type cl_method flen TNET TP PN mslen domaintr']
eval(com);

% Training single SVM classifier (uses "other" category)
nc =length(trmx);
tr_samples = tr_feature_all(:,234:297);
labels = [];
for j =1:nc;
    labels=[labels; j*ones(trmx(j),1)];
end   
disp('training svm ...');
[AlphaY, SVs, Bias, Parameters, nSV, nLabel] = LinearSVC(tr_samples', labels');
com = ['save ',cl_dir, tname,'svm AlphaY  SVs  Bias Parameters nSV nLabel taxas'];
eval(com);

% trmx is the number of training samples in each taxon
% strmx is the row indices of tr_feature for the taxa
% here we remove the rows (=features) in tr_feature for "other" category
for j=1:size(taxas,1),
    if strcmpi('other',deblank(taxas(j,:))),
        oi=j;
    end
end
strmx=[1 cumsum(trmx)];
ltrmx=size(trmx,2);%length of trmx
if oi==1,
    trmx=trmx(2:end);
    tr_feature_dual=tr_feature(strmx(2)+1:end,:);
    tr_feature_dual_all=orig_tr_feature_all(strmx(2)+1:end,:);
elseif oi==size(taxas,1),
    trmx=trmx(1:end-1);
    tr_feature_dual=tr_feature(1:strmx(oi),:);
    tr_feature_dual_all=orig_tr_feature_all(1:strmx(oi),:);
else
    trmx=trmx([1:oi-1 oi+1:ltrmx]);
    tr_feature_dual=tr_feature([1:strmx(oi) strmx(oi+1)+1:size(tr_feature,1)],:);
    tr_feature_dual_all=orig_tr_feature_all([1:strmx(oi) strmx(oi+1)+1:size(tr_feature,1)],:);
end
[tr_feature_dual_all, x_mean, x_std] = normalize(tr_feature_dual_all);
[tr_feature_dual, faxis_max] = ...
            selectfea(tr_feature_dual_all(:,1:233), trmx, flen, select_type);


% Training NN classifier for dual classifier (does not include "other" category)
[t1, t2, t3, t4] = training_t(cl_method, tr_feature_dual, TNET, TP, trmx, PN);
if cl_method == 4, 
    tr_correct = t3; 
    mship = member(t1, tr_feature_dual, trmx, mslen);	% neuron member ****
end

% Training SVM classifier for dual classifier (does not include "other" category)
nc =length(trmx);
tr_samples = tr_feature_dual_all(:,234:297);
labels = [];
for j =1:nc;
    labels=[labels; j*ones(trmx(j),1)];
end   
disp('training svm ...');
[AlphaY, SVs, Bias, Parameters, nSV, nLabel] = LinearSVC(tr_samples', labels');


% Build training feature data matrix for "other" category
[otr_feature_all, otrimfiles, otrmx, otaxas] = ...
    buildfeamatbin(tows, cruise, discmat, types, 'other', [zeros(1,size(tows,1)); ones(1,size(tows,1))],type_len);

if NORM_ON
    [otr_feature_all] = normalize(otr_feature_all,x_mean, x_std);
end

[otr_feature, ofaxis_max] = ...
    selectfea(otr_feature_all(:,1:233), otrmx, flen, select_type);
taxas(oi,:)=[];
taxas=char(taxas);
com = ['save ',cl_dir, tname,'dual faxis_max t1 t2 t3 t4 mship x_mean x_std tows discmat taxas combind taxas_orig types type_len select_type cl_method flen TNET TP PN mslen domaintr AlphaY  SVs Bias Parameters nSV nLabel']
eval(com);

conf = mkconfusion7([tr_feature_dual_all; otr_feature_all], [tr_feature_dual; otr_feature], [trmx otrmx], str2mat(taxas,'other'), cl_method, TNET, TP, PN);
com = ['save ',cl_dir, tname,'dualconf conf'];
eval(com);



