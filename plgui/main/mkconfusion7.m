function [conf] = mkconfusion7(feature_all, all_feature, trmx, taxas, cl_method, TNET, TP, PN)

% Make a confusion matrix with leave-n-out method, where n is the number of
% classes in the classifier. 
% Qiao Hu 05/15/06

% Main program for make confusion matrix with leave-one-out method.
% It is similar to mkconfusion2.m except you could select certain
% number of ROIS to build confusion matrix by define ROIS=1 in 
% set parameter file. If you want all the training ROIS to build
% confusion matrix, define ROIS=0 instead. 
% You should first setup the database for the confusion
% matrix by running Extridsize.m routine like building
% training database. You should also make a parameter file
% to set all the parameters needed for the confusion matrix
% The sample set parameter file is set_te.m

% Qiao Hu 11/03/04

% Set parameters for NN classifier
disp(['Building Confusion Matrix']);

conf=zeros(size(taxas,1),size(taxas,1));

% Select features for NN classifier
%note: that all_feature contains all of the original (shape-based) features
%whereas
%feature_all contains all the feature (including the co-occurrence
%matrix features)

% make sure each class have same number of training samples by recycling training
% samples. The minimum number of training samples for any class should be at least
% half of the maximum number of training samples in the classifier

% remove samples of 'other' category from training the classifier
otrmx = trmx; 
trmx = trmx(1:end-1); 
otr_num=sum(trmx(:));

mtrmx=max(trmx);
ctrmx=[1 cumsum(trmx)+1];
new_feature_all = [];
new_all_feature = [];
for j=1:length(trmx),
    if trmx(j) == mtrmx,
        new_feature_all = [new_feature_all; feature_all(ctrmx(j):ctrmx(j+1)-1,:)];
        new_all_feature = [new_all_feature; all_feature(ctrmx(j):ctrmx(j+1)-1,:)];
    else    
        new_feature_all = [new_feature_all; feature_all(ctrmx(j):ctrmx(j+1)-1,:); ...
                feature_all(ctrmx(j):ctrmx(j)+mtrmx-trmx(j)-1,:)];
        new_all_feature = [new_all_feature; all_feature(ctrmx(j):ctrmx(j+1)-1,:); ...
                all_feature(ctrmx(j):ctrmx(j)+mtrmx-trmx(j)-1,:)];
    end 
end


trmx=mtrmx*ones(size(trmx));
tr_num=sum(trmx(:));
ctrmx=[1 cumsum(trmx)+1];
for k= 1:mtrmx,
    ind =1:tr_num;
    te_ind=k+ctrmx(1:end-1)-1;
    ind(te_ind)=[]; tr_ind=ind;
    te_feature = new_all_feature(te_ind,:);
    te_samples = new_feature_all(te_ind,234:297);

    tr_feature = new_all_feature(tr_ind,:);
    tr_samples = new_feature_all(tr_ind,234:297);
   
    temx=ones(size(trmx));
    mx=trmx-temx;
    
    %  Training NN classifier
    
    [t1,t2,t3,t4] = training_t(cl_method,tr_feature, TNET, TP, mx, PN);
    %   if cl_method ==4, 
    %     tr_correct =t3;
    %     mship =member(t1, tr_feature, mx, mslen);
    %   end
    
    nc =length(mx);
    labels = [];
    for j =1:nc;
        labels=[labels; j*ones(mx(j),1)];
    end
    %  disp('training svm ...');
%     [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = LinearSVC(tr_samples', labels',50);
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = LinearSVC(tr_samples', labels');
    
    % classification with NN classifier
    
    [aids, neuron] = ...
        clfier_batch_fast(te_feature, t1, t2, t3, t4, temx, cl_method);
    
    % classification with 2-svm 
    %  sample = te_feature_all(234:297);
    [Label, DecisionValue]= SVMClass(te_samples', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
    
 %   if Label ~=  aids, aids = -1;  end	
    aids(aids~=Label')=size(taxas,1);
    hids = geneids(temx);
    
 %   if aids<=0, aids=size(taxas,1); end
    for kk=1:length(aids),
       conf(aids(kk),hids(kk))=conf(aids(kk),hids(kk))+1;
    end   
    disp(['Completed ' int2str(k) ' of ' int2str(mtrmx)]);
end

% Test on the 'other' samples

te_feature = all_feature(otr_num+1:sum(otrmx),:);
%temx = otrmx - [trmx 0];
temx = zeros(size(otrmx)); temx(end)=otrmx(end);
te_samples = feature_all(otr_num+1:sum(otrmx),234:297);
[aids, neuron] = ...
    clfier_batch_fast(te_feature, t1, t2, t3, t4, temx, cl_method);
[Labels, DecisionValue]= SVMClass(te_samples', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
aids(aids ~= Labels') = size(taxas,1);  
hids = geneids(temx);
conf_tmp = confusion(hids, aids);
conf =conf+conf_tmp;



