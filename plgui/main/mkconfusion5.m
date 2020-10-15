function [conf] = mkconfusion5(feature_all, all_feature, trmx, taxas, cl_method, TNET, TP, PN, training_options)

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

otrmx = trmx; trmx = trmx(1:end-1);
tr_num=sum(trmx(:));
ctrmx=[1 cumsum(trmx)+1];

for i= 1:tr_num
    te_feature = all_feature(i,:);
    te_samples = feature_all(i,234:297);
    %   ind=1;
    %   for j=1:size(ctrmx,2), 
    %         if i>ctrmx(j) ind=j+1;end
    %   end
    ind=find(histc(i,ctrmx));
    if i==1 
        tr_feature = all_feature(2:tr_num,:);
        tr_samples = feature_all(2:tr_num,234:297);
    elseif i==tr_num
        tr_feature = all_feature(1:tr_num-1,:);
        tr_samples = feature_all(1:tr_num-1,234:297);
    else 
        tr_feature = all_feature([1:i-1,i+1:tr_num],:);
        tr_samples = feature_all([1:i-1,i+1:tr_num],234:297);
    end
    temx=zeros(size(trmx));
    temx(ind)=1;
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
    %[AlphaY, SVs, Bias, Parameters, nSV, nLabel] = LinearSVC(tr_samples', labels',50); %edit to default value of 1 to test (orig C = 50) no change
    %KS workaround for svm model
    svm_model = mex_svmtrain(labels, tr_samples, training_options);
    
    % classification with NN classifier
    
    [aids, neuron] = ...
        clfier_batch_fast(te_feature, t1, t2, t3, t4, temx, cl_method);
    
    % classification with 2-svm 
    %  sample = te_feature_all(234:297);
    %[Label, DecisionValue]= SVMClass(te_samples', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
    %KS workaround for svm model
    [Label, DecisionValue]= SVMClass(te_samples, svm_model);
    
    
    if Label ~=  aids, aids = -1;  end	%ec
    hids = geneids(temx); %ec
    
    
    
    if aids<=0, aids=size(taxas,1); end %ec
    conf(aids,hids)=conf(aids,hids)+1;
    disp(['Completed ' int2str(i) ' of ' int2str(tr_num)]);
end

% Test on the 'other' samples

te_feature = all_feature(tr_num+1:sum(otrmx),:);
temx = otrmx - [trmx 0];  
te_samples = feature_all(tr_num+1:sum(otrmx),234:297);
[aids, neuron] = ...
    clfier_batch_fast(te_feature, t1, t2, t3, t4, temx, cl_method);
%[Labels, DecisionValue]= SVMClass(te_samples', AlphaY, SVs, Bias, Parameters, nSV, nLabel);
[Label, DecisionValue]= SVMClass(te_samples, svm_model); %KS workaround from mk7

%aids(aids ~= Labels') = size(taxas,1);  
aids(aids ~= Label) = size(taxas,1); %KS edit from mk7
hids = geneids(temx);
conf_tmp = confusion(hids, aids);
conf =conf+conf_tmp;



