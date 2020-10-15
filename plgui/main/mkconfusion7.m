function [conf, conf_unkn] = mkconfusion7(feature_all, all_feature, trmx, taxas, cl_method, TNET, TP, PN, training_options)

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
%create unknown tally
conf_unkn=zeros(size(taxas,1),size(taxas,1));

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

mtrmx=max(trmx); %max sample size 
ctrmx=[1 cumsum(trmx)+1]; %vector of size = taxas +1 , each element is sample size
new_feature_all = [];
new_all_feature = [];
for j=1:length(trmx),
    if trmx(j) == mtrmx, %if sample size of taxa is equal to max sample size
        new_feature_all = [new_feature_all; feature_all(ctrmx(j):ctrmx(j+1)-1,:)];
        new_all_feature = [new_all_feature; all_feature(ctrmx(j):ctrmx(j+1)-1,:)];
    else    %if not, make up difference to create uniform sample size
        new_feature_all = [new_feature_all; feature_all(ctrmx(j):ctrmx(j+1)-1,:); ...
                feature_all(ctrmx(j):ctrmx(j)+mtrmx-trmx(j)-1,:)];
        new_all_feature = [new_all_feature; all_feature(ctrmx(j):ctrmx(j+1)-1,:); ...
                all_feature(ctrmx(j):ctrmx(j)+mtrmx-trmx(j)-1,:)];
    end 
end

trmx=mtrmx*ones(size(trmx)); %uniform sample size for each taxa
tr_num=sum(trmx(:)); % sum of sample sizes for total number of rois
ctrmx=[1 cumsum(trmx)+1]; %cumulative sum vector of sample size , where element 2 equals last index of first taxa
for k= 1:mtrmx,  %index through each roi 
    ind =1:tr_num;
    te_ind=k+ctrmx(1:end-1)-1;
    ind(te_ind)=[]; tr_ind=ind;
    te_feature = new_all_feature(te_ind,:);
    te_samples = new_feature_all(te_ind,234:297);

    tr_feature = new_all_feature(tr_ind,:);
    tr_samples = new_feature_all(tr_ind,234:297);
   
    temx=ones(size(trmx)); %creates array of ones, size of sample size vector
    mx=trmx-temx; % -1 from each element of sample size vector
    
    %  Training NN classifier
    %training_t in plgui/devel/batch
    %batches through different training function based on cl_method
    %specified, outputs matrix of training data
    [t1,t2,t3,t4] = training_t(cl_method,tr_feature, TNET, TP, mx, PN);
  
    nc =length(mx); %number of taxa
    labels = [];
    for j =1:nc;
        labels=[labels; j*ones(mx(j),1)]; %creates index array to label each taxa
    end
   
    %combine default and selected features
    %tr_featsamp = [tr_feature tr_samples];
        %svm_model = mex_svmtrain(labels, tr_featsamp, training_options);

    %run svm model from plgui/osu_svm (default)
    svm_model = mex_svmtrain(labels, tr_samples, training_options);
    
    % classification with NN classifier
    %batches through NN classifier
    [aids, neuron] = ...
        clfier_batch_fast(te_feature, t1, t2, t3, t4, temx, cl_method);
    %output: aids = actual ids of rois, neuron = class label
    
    
    % classification with 2-svm 
   %combine selected and default
   %te_featsamp = [te_feature te_samples];
       %[Label, DecisionValue]= SVMClass(te_featsamp, svm_model);

       %default
    [Label, DecisionValue]= SVMClass(te_samples, svm_model);
    %outputs: label = predicted labels, DecisionValue: the output of the 
                %decision function (only meaningful for 2-class problem)


%find disagreement between NN and SVM
    aids_unkn = aids;
    aids_unkn(aids == Label) = size(taxas,1);
    aids(aids~=Label)=size(taxas,1);
    hids = geneids(temx);
    
    

    %create Conf Mat for all taxas 
    % (not including unknown/other)
    for kk=1:length(aids),
       conf(aids(kk),hids(kk))=conf(aids(kk),hids(kk))+1;
       %creates a confusion matrix for unknown samples
       conf_unkn(aids_unkn(kk), Label(kk)) = conf(aids_unkn(kk),Label(kk))+1;
    end   
    disp(['Completed ' int2str(k) ' of ' int2str(mtrmx)]);
end




% Test on the 'other' samples

te_feature = all_feature(otr_num+1:sum(otrmx),:);

temx = zeros(size(otrmx)); temx(end)=otrmx(end);
te_samples = feature_all(otr_num+1:sum(otrmx),234:297);

%test with NN
[aids, neuron] = ...
    clfier_batch_fast(te_feature, t1, t2, t3, t4, temx, cl_method);

%test with SVM (default)
[Label, DecisionValue]= SVMClass(te_samples, svm_model);
%combine default and selected
%te_featsamp = [te_feature te_samples];
%[Label, DecisionValue]= SVMClass(te_featsamp, svm_model);

%test disagreement on 'other' samples
%for classified samples and unknown group
aids_unkn = aids;
aids_unkn(aids == Label) = size(taxas,1);
aids(aids ~= Label) = size(taxas,1);
hids = geneids(temx);
%create conf mat for other samples (known and unknown)
conf_tmp = confusion(hids, aids);
conf_tmp_unkn = confusion(Label, aids_unkn);

%combine conf mat for all taxas and other samples
conf =conf+conf_tmp;
conf_unkn = conf_unkn+conf_tmp_unkn;



