%{ 
    Author : Vaibhav Malpani 
    Uni: vom2102
    Course: Biometrics E6737
    Final Project - Research Paper Classification using Abstract Text
    
    This script implements Rocchio algorithm for text categorization.
    Pls ensure 'svmForm.txt' is present in the current directory.
    Third party libraries required -
    1. LibSVM
    2. LibLinear
    
    In case of any trouble, pls go through the README file.
%}

% Sample Output
% Fold 1
% Generating prototype vectors for each class...
% Scaling prototype vectors...
% Calculating cosine similarity...
% Accuracy: 0.560000 
% 
% Fold 2
% Generating prototype vectors for each class...
% Scaling prototype vectors...
% Calculating cosine similarity...
% Accuracy: 0.620000 
% 
% Fold 3
% Generating prototype vectors for each class...
% Scaling prototype vectors...
% Calculating cosine similarity...
% Accuracy: 0.500000 
% 
% Fold 4
% Generating prototype vectors for each class...
% Scaling prototype vectors...
% Calculating cosine similarity...
% Accuracy: 0.440000 
% 
% Avg Accuracy: 0.530000

clc
clear all

%%
fprintf('Reading data...\n')
[train_labels, train_features] = libsvmread('svmForm.txt');
all_labels = unique(train_labels);

% cross validation split data
fprintf('Generating training and test set...\n')
numAll = size(train_labels,1);
tot_acc = [];
avg_acc = 0;
k_folds = 4;
indices = crossvalind('Kfold',train_labels,k_folds);
for fold = 1:k_folds
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

    %%
    count = zeros(1,size(all_labels,1));
    prototype = [];
    fprintf('Generating prototype vectors for each class...\n')
    for i = 1: numTrain
        if trainLabel(i) == 2
            count(1) = count(1) + 1;
            if count(1) == 1
                prototype(1,:) = trainData(i,:);
            end
            prototype(1,:) = prototype(1,:) + trainData(i,:);

        elseif trainLabel(i) == 4
            count(2) = count(2) + 1;
            if count(2) == 1
                prototype(2,:) = trainData(i,:);
            end
            prototype(2,:) = prototype(2,:) + trainData(i,:);

        elseif trainLabel(i) == 7
            count(3) = count(3) + 1;
            if count(3) == 1
                prototype(3,:) = trainData(i,:);
            end
            prototype(3,:) = prototype(3,:) + trainData(i,:);

        elseif trainLabel(i) == 10
            count(4) = count(4) + 1;
            if count(4) == 1
                prototype(4,:) = trainData(i,:);
            end
            prototype(4,:) = prototype(4,:) + trainData(i,:);

        elseif trainLabel(i) == 12
            count(5) = count(5) + 1;
            if count(5) == 1
                prototype(5,:) = trainData(i,:);
            end
            prototype(5,:) = prototype(5,:) + trainData(i,:);

        elseif trainLabel(i) == 20
            count(6) = count(6) + 1;
            if count(6) == 1
                prototype(6,:) = trainData(i,:);
            end
            prototype(6,:) = prototype(6,:) + trainData(6,:);

        elseif trainLabel(i) == 22
            count(7) = count(7) + 1;
            if count(7) == 1
                prototype(7,:) = trainData(i,:);
            end
            prototype(7,:) = prototype(7,:) + trainData(i,:);

        elseif trainLabel(i) == 28
            count(8) = count(8) + 1;
            if count(8) == 1
                prototype(8,:) = trainData(i,:);
            end
            prototype(8,:) = prototype(8,:) + trainData(i,:);

        elseif trainLabel(i) == 31
            count(9) = count(9) + 1;
            if count(9) == 1
                prototype(9,:) = trainData(9,:);
            end
            prototype(9,:) = prototype(9,:) + trainData(9,:);

        elseif trainLabel(i) == 36
            count(10) = count(10) + 1;
            if count(10) == 1
                prototype(10,:) = trainData(10,:);
            end
            prototype(10,:) = prototype(10,:) + trainData(10,:);
        end 
    end

    %%
    fprintf('Scaling prototype vectors...\n')
    scaled_prototype = zeros(size(prototype,1),size(prototype,2));
    for j = 1:size(all_labels,1)
        scaled_prototype(j,:) = prototype(j,:)./count(j);
%         scaled_prototype(j,:) = prototype(j,:);
    end

    %%
    fprintf('Calculating cosine similarity...\n')
    [D,I] = pdist2(scaled_prototype,testData(1:50,:),'cosine','smallest',1);

    count_correct = 0;
    for k = 1: size(I,2)
        if all_labels(I(k)) == testLabel(k)
            count_correct = count_correct + 1;
        end
    end

    %%
    acc = count_correct/size(I,2);
    tot_acc = [tot_acc acc];
    fprintf('Accuracy: %f ', acc)
    fprintf('\n')
end

avg_acc = sum(tot_acc)/k_folds;
fprintf('\nAvg Accuracy: %f', avg_acc)
fprintf('\n')