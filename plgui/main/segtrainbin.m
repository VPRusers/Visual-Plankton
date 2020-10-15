function [tr_feature, faxis_max, t1, t2, t3, t4, mship, x_mean, x_std, ax_mat, axind, ...
	x_mean2, x_std2 ] = ...
	segtrainbin(cl_dir, tname, tows, cruise, discmat, taxas, combind, taxas_orig, types, type_len, ...
domaintr, flen, select_type, TNET, TP, PN, cl_method, mslen,  groupind, c1,c2)

% Main function for classification
%keyboard
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

if exist('groupind') %this is not running in default settings
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
    %selects a subset excluding last 64 columns of features 
    %flen decides how many features columns are output
    
end

% Training single NN classifier (uses "other" category)
%uses only selected features
[t1, t2, t3, t4] = training_t(cl_method, tr_feature, TNET, TP, trmx, PN);
if cl_method == 4, 
    tr_correct = t3; 
    mship = member(t1, tr_feature, trmx, mslen);	% neuron member ****
end
taxas=char(taxas);
%save single NN classifier parameter file
com = ['save ',cl_dir, tname,'nn faxis_max t1 t2 t3 t4 mship x_mean x_std tows discmat taxas combind taxas_orig types type_len select_type cl_method flen TNET TP PN mslen domaintr']
eval(com);

% % Training single SVM classifier (uses "other" category); this is where I
% started commenting this out here - KS
%see: https://github.com/cjlin1/libsvm/blob/master/README for help with
%training options
%linear svm options%
training_options = '-t 0, -d 1, -r 1 -c 16';


nc =length(trmx);
%test with all sample features
%tr_samples = tr_feature_all; 


%dissect features by type
%types = str2mat('geo', 'coo');
%fea = orig_tr_feature_all;
    %gra = fea(1:GRA_LEN); unsure where these are in tr fetaure all
    %dst = fea(GRA_LEN+1:GRA_LEN+CONT_LEN/4);
    %geo = fea(:,205: 233); 
    %calculated assuming same number of geo features as in classification section
    %coo = fea(:,234:end); %
    %geo = geo(:,12:20);
    
%tr_samples = [geo coo];

%normalize with correct dimensions

%[tr_samples_norm x_mean_svm x_std_svm] = normalize(tr_samples);

  
tr_samples = tr_feature_all(:,234:297); %default sample subset
labels = [];
for j =1:nc;
    labels=[labels; j*ones(trmx(j),1)];
end   
disp('training svm ...');


%E Chisholm %
%%%==================================%%%
%grid search for best parameters (uncomment to use)
%for rbf kernel
%https://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f803
% keyboard
% 
% bestcv = 0;
% x = [];
% i = 1;
% for log2c = -5:30, %range of c values to test
%   for log2g = -30:7, %range of gamma to test
%     cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)]; 
%     %-v option means output is only cross validation accuracy not whole model
%     %number after v is n, for number of folds used in cross validation
%     cv = mex_svmtrain(labels, tr_samples, cmd);
%     x(i,:) = [2^log2c 2^log2g cv];
%     i = i+1;
%     if (cv >= bestcv), %find best cv accuracy level (c and gamma)
%       bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
%     end
%     fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
%   end
% end
% 
% keyboard
% 
% %save cv accuracy over range as array (for plotting)
% com = ['save ',cl_dir, tname,'cv x'];
% eval(com);

%quit debugging and exit run
%%%===========================%%%


%%%==================================%%%
%grid search for best parameters
%for linear kernel
%https://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f803
% keyboard
% %combine selected and default
% %tr_featsamp = [tr_feature  tr_samples];
% 
% bestcv = 0;
% x = [];
% i = 1;
% for log2c = -40:40, %range of c values to test
%     cmd = ['-t 0 -v 5 -c ', num2str(2^log2c)]; 
%     %-v option means output is only cross validation accuracy not whole model
%     %number after v is n, for number of folds used in cross validation
%     
% %default
%     cv = mex_svmtrain(labels, tr_samples, cmd)
% %all features
%       %cv = mex_svmtrain(labels, tr_feature_all, cmd);
% %selected features
%       %cv = mex_svmtrain(labels, tr_feature, cmd);
% %combine default and selected
%       %cv = mex_svmtrain(labels, tr_featsamp, cmd);
%                                                                         
%     x(i,:) = [2^log2c cv];
%     i = i+1;
%     if (cv >= bestcv), %find best cv accuracy level (c )
%       bestcv = cv; bestc = 2^log2c; 
%     end
%     fprintf('%g %g  (best c=%g, rate=%g)\n', log2c, cv, bestc, bestcv);
%   end
% 
% 
% keyboard
% % % % 
% % % %save cv accuracy over range as array (for plotting)
%     com = ['save ',cl_dir, tname,'cv x'];
%     eval(com);

%quit debugging and exit run
%%%===========================%%%


%try with selected features
%svm_model = mex_svmtrain(labels, tr_feature, training_options);

%default/all
svm_model = mex_svmtrain(labels, tr_samples, training_options);

%combine default and selected
% tr_featsamp = [tr_feature  tr_samples];
%svm_model = mex_svmtrain(labels, tr_featsamp, training_options);


%com = ['save ',cl_dir, tname,'svm AlphaY  SVs  Bias Parameters nSV nLabel taxas'];
com = ['save ',cl_dir, tname,'svm svm_model taxas x_mean x_std']; %added taxas for classification reqs
        %added x_mean and x_std for feature normalization  in clf
eval(com);

% trmx is the number of training samples in each taxon
% strmx is the row indices of tr_feature for the taxa
% here we remove the rows (=features) in tr_feature for "other" category
for j=1:size(taxas,1),
    if strcmpi('other',deblank(taxas(j,:))),
        oi=j;
    end
end

%%%% note: EC
%%%% you will get an error here about not having an object oi
%%%% if you have set your minimum threshold above the number of ROIs in
%%%% the 'other' category. If the 'other' category is excluded, analysis
%%%% will not continue



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
%EC: think this step is selecting features... 
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
%run for all features
%tr_samples = tr_feature_dual_all;
%default subset
tr_samples = tr_feature_dual_all(:,234:297);
%try with selected features
%tr_samples = tr_feature_dual;

%combine default and selected
%tr_featsamp = [tr_feature  tr_samples];


labels = [];
for j =1:nc;
    labels=[labels; j*ones(trmx(j),1)];
end   
disp('training svm ...');

%combine default and selected
%svm_model = mex_svmtrain(labels, tr_featsamp, training_options);

%default
svm_model = mex_svmtrain(labels, tr_samples, training_options); %The 'training_options' arguement was previously the 'Parameters' argument

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
com = ['save ',cl_dir, tname,'dual faxis_max t1 t2 t3 t4 mship x_mean x_std tows discmat taxas combind taxas_orig types type_len select_type cl_method flen TNET TP PN mslen domaintr svm_model']
eval(com);

% 
%confusion matrix for dual classifier
[conf, conf_unkn] = mkconfusion7([tr_feature_dual_all; otr_feature_all], [tr_feature_dual; otr_feature], [trmx otrmx], str2mat(taxas,'other'), cl_method, TNET, TP, PN, training_options); %#ok<NASGU>
com = ['save ',cl_dir, tname,'dualconf conf'];
eval(com);
com = ['save ',cl_dir, tname,'dualunknconf conf_unkn'];
eval(com);
%%addition E. Chisholm April 26, 2019
%make confusion matrix for svm and nn classifiers separately 


%%NN matrix
conf = confusionNN([tr_feature_all; otr_feature_all], [tr_feature; otr_feature], [trmx otrmx], str2mat(taxas,'other'), cl_method, TNET, TP, PN, training_options); %#ok<NASGU>
com = ['save ',cl_dir, tname,'NNconf conf'];
eval(com);

%%SVM matrix
conf = confusionSVM([tr_feature_all; otr_feature_all], [tr_feature; otr_feature], [trmx otrmx], str2mat(taxas,'other'), cl_method, TNET, TP, PN, training_options); %#ok<NASGU>
com = ['save ',cl_dir, tname,'SVMconf conf'];
eval(com);

%%save taxa names for conf matrix 
%EC 29/04/2019
com = ['save ',cl_dir, tname,'conf_taxas taxas'];
eval(com);






