%{ 
    Author : Vaibhav Malpani 
    Uni: vom2102
    Course: Biometrics E6737
    Final Project - Research Paper Classification using Abstract Text
    
    This script implements one-vs-one as well as one-vs-rest procedure
    on the LibSVM classifier for text categorization. We check to see the 
    performance of various kernels on our task of text classification.
    Pls ensure 'svmForm.txt' is present in the current directory.
    Update the path to your matlab interface of liblinear in line 147.
    Third party libraries required -
    1. LibSVM
    2. LibLinear
    
    In case of any trouble, pls go through the README file.
%}

clc
clear all

fprintf('Reading data...\n')
[train_labels, train_features] = libsvmread('svmForm.txt');
all_labels = unique(train_labels);

% cross validation splitting data
fprintf('Generating training and test set...\n')
k_folds = 4;
indices = crossvalind('Kfold',train_labels,k_folds);
numAll = size(train_labels,1);

fprintf('1. RBF Kernel(one-vs-one) \n')
fprintf('2. RBF Kernel(one-vs-rest) \n')
fprintf('3. Polynomial Kernel(one-vs-one) \n')
fprintf('4. Sigmoid Kernel(one-vs-one) \n')
fprintf('5. Linear SVM(LibLinear required) \n')
idx = input('Enter your choice: ');

if idx == 5
    fprintf('\nPath to matlab interface of liblinear required \n')
    fprintf('Eg. /Users/Ampersund/Documents/MATLAB/liblinear-1.94/matlab \n')
    pth = input('Enter path(in quotes): ');
    addpath(pth)
end

tot_acc = [];
avg_acc = 0;
for fold = 1:4
    fprintf('\nFold %d', fold)
    fprintf('\n')
    cv_test_idx = (indices == fold); cv_train_idx = ~cv_test_idx;
    trainData = train_features(cv_train_idx,:);
    trainLabel = train_labels(cv_train_idx,:);
    testData = train_features(cv_test_idx,:);
    testLabel = train_labels(cv_test_idx,:);

    numLabels = size(unique(train_labels),1);
    numTrain = size(trainLabel,1);
    numTest = numAll - numTrain;

    %% using libsvm to build up classification model    
    if idx == 1
%     RBF Kernel (one-vs-one)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Fold 1    Fold 2    Fold 3    Fold 4
% Acc 63.6564   63.5208   62.9109   63.6856
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Avg Accuracy: 63.4434
        fprintf('Training SVM...\n')
        model = svmtrain(trainLabel, trainData, '-b 1 -h 0');

%         testing data using the model generated
        fprintf('Classifying the test data...\n')
        [predict_label, acc, prob_estimates] = svmpredict(testLabel, testData, model, '-b 1');
        tot_acc = [tot_acc acc(1)];
        fprintf('Accuracy: %f ', acc(1))
        fprintf('\n')   
    elseif idx == 2
%         RBF Kernel (one-vs-all)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Fold 1    Fold 2    Fold 3    Fold 4
%         0.6710    0.6728    0.6732    0.6595
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Avg Accuracy: 0.669122
        model = cell(numLabels,1);
        fprintf('Generating model for each class...\n')
        for k=1:numLabels
            model{k} = svmtrain(double(trainLabel==all_labels(k)), trainData, '-b 1 -h 0');
        end
%         get probability estimates of test instances using each model
%         prob = zeros(numTest,numLabels);
        fprintf('Predicting output labels...\n')
        prob = [];
        for k=1:numLabels
            [~,~,p] = svmpredict(double(testLabel==all_labels(k)), testData, model{k}, '-b 1');
%           prob(:,k) = p(:,model{k}.Label==1);    %# probability of class==k
            prob = [prob p(:,model{k}.Label==1)];
        end
%         predict the class with the highest probability
        [~,pred] = max(prob,[],2);
        out_labels = zeros(size(testLabel,1),1);
        for i = 1:size(pred,1)
            out_labels(i) = all_labels(pred(i));
        end
        C = confusionmat(testLabel, pred);                   %# confusion matrix
        acc = sum(out_labels == testLabel) ./ numel(testLabel);    %# accuracy
        tot_acc = [tot_acc acc];
        fprintf('Accuracy: %f ', acc)
        fprintf('\n')
    elseif idx == 3
%         Polynomial Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Fold 1    Fold 2    Fold 3    Fold 4
%         39.2379   39.2778   39.2343   39.2343
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Avg Accuracy: 39.246088
        fprintf('Training SVM...\n')
        model = svmtrain(trainLabel, trainData, '-b 1 -t 1 -h 0');

        % testing data using the model generated
        fprintf('Classifying the test data...\n')
        [predict_label, acc, prob_estimates] = svmpredict(testLabel, testData, model, '-b 1');
        tot_acc = [tot_acc acc(1)];
        fprintf('Accuracy: %f ', acc(1))
        fprintf('\n')
    elseif idx == 4
%         Sigmoid Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Fold 1    Fold 2    Fold 3    Fold 4
%         63.0741   64.2845   62.5551   62.3517
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Avg Accuracy: 63.066343
        fprintf('Training SVM...\n')
        model = svmtrain(trainLabel, trainData, '-b 1 -t 3 -h 0');

%         testing data using the model generated
        fprintf('Classifying the test data...\n')
        [predict_label, acc, prob_estimates] = svmpredict(testLabel, testData, model, '-b 1');
        tot_acc = [tot_acc acc(1)];
        fprintf('Accuracy: %f ', acc(1))
        fprintf('\n')         
    else
%         LibLinear (add path to matlab interface of liblinear)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Fold 1    Fold 2    Fold 3    Fold 4
%         72.6703   72.6195   73.1616   73.4756
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Avg Accuracy: 72.981746
        fprintf('Training SVM...\n')
        model = train(trainLabel, trainData);
        fprintf('Classifying the test data...\n')
        [predict_label, acc, dec_values] = predictsvm(testLabel, testData, model);   
        tot_acc = [tot_acc acc(1)];
        fprintf('Accuracy: %f ', acc(1))
        fprintf('\n')
    end
end

avg_acc = sum(tot_acc)/k_folds;
fprintf('\nAvg Accuracy: %f', avg_acc)
fprintf('\n')