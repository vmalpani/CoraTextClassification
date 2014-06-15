from __future__ import division
'''
Author : Vaibhav Malpani 
Uni: vom2102
Course: Biometrics E6737
Final Project - Research Paper Classification using Abstract Text

Dataset already pickled. 
Appropriate 'svmForm.txt', 'data.p' and 'label.p' files supplied.
Keep them in current directory before execution.
Enter path to python interface of liblinear when prompted.
Required third party libraries -
1. nltk
2. scikit-learn
3. LibLinear
4. numpy
5. scipy
6. matplotlib

In case of any trouble, pls go through the README file.
'''
import os
import sys
import cPickle

from numpy import *

from sklearn.datasets import load_svmlight_file
from sklearn import preprocessing
from sklearn.feature_selection import chi2, SelectKBest

from sklearn.neighbors import NearestCentroid
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import Perceptron
from sklearn.linear_model import ElasticNet
from sklearn.svm import LinearSVC
from sklearn.svm import SVC

from sklearn import cross_validation
from sklearn import metrics

if not (os.path.isfile("data.p") and os.path.isfile("label.p")):
	print'\nLoading svm light file...'
	x,y = load_svmlight_file('svmForm2.txt')
	cPickle.dump(x, open( "data.p", "wb"))
	cPickle.dump(y, open( "label.p", "wb"))

print '\nLoading pickled data from disk...'
x = cPickle.load(open( "data.p", "rb"))
y = cPickle.load(open( "label.p", "rb"))

# feature selection
# print '\nDo you need to select top features?'
# isSelect = raw_input('Enter 1 = Yes, 2 = No: ')
# if isSelect == '1':
# 	num_features = raw_input('Enter Number of Features: ')
# 	ch2 = SelectKBest(chi2, k=int(num_features))
# 	x = ch2.fit_transform(preprocessing.MinMaxScaler(x), y)
	
# classification	
print "\nChoose a classifier:"
print "1. Rocchio"
print "2. kNN"
print "3. Stochastic Gradient Descent"
print "4. Linear SVC"
print "5. LibLinear SVM(LibLinear Required)"
print "6. Perceptron"
# print "7. RBF SVM"
# print "8. Poly SVM"

idx = raw_input('Enter your choice: ')

if idx == '1':
	clf = NearestCentroid()
elif idx == '2':
	clf = KNeighborsClassifier(n_neighbors=20)
elif idx == '3':
	penalty = 'elasticnet'
	clf = SGDClassifier(alpha=0.0001, n_iter=50, penalty=penalty)
elif idx == '4':
	penalty = 'l1'
	clf = LinearSVC(loss='l2', penalty=penalty, dual=False, tol=1e-3)
elif idx == '5':
# 	Update to add path to your location of liblinear
	print 'Code requires installing nltk, scikit and liblinear!\n'
	print 'Enter path to python interface of liblinear:  '
	print 'Eg. /Users/Ampersund/Documents/MATLAB/liblinear-1.94/python'
	path = raw_input('Enter path: ')
	if path == '':
		path = '/Users/Ampersund/Documents/MATLAB/liblinear-1.94/python'
	sys.path.append(path)
	
	from liblinearutil import *
	
	print '\nUsing LibLinear for linear SVM classification!'
	y, x = svm_read_problem('svmForm.txt')
elif idx == '6':
	clf = Perceptron(alpha=0.0001,n_iter=50)
# elif idx == '7':
# 	clf = SVC()
# elif idx == '8':
# 	clf = SVC(kernel='poly')
else:
	print 'Incorrect Input!\n'
	print 'Default Classifier: Linear SVM\n'
	penalty = 'elasticnet'
	clf = LinearSVC(loss='l2', penalty=penalty, dual=False, tol=1e-3)

print '\nSplitting data into train and test...\n'
acc = 0
# f1 = 0
# pr = 0
fold = 0
skf = cross_validation.StratifiedKFold(y,n_folds=4)
for train_index, test_index in skf:
	fold += 1
	if idx =='5':
		train_data = []
		train_label = []
		test_data = []
		test_label = []
		for i in train_index:
			train_data.append(x[i])
			train_label.append(y[i])
		for j in test_index:
			test_data.append(x[j])
			test_label.append(y[j])	
		
		print "\nBuilding model for classification...\n"
		model_ = train(train_label, train_data)
		
		print '\nPredicting output labels for fold', str(fold), '\n'
		pred, p_acc, p_vals = predict(test_label, test_data, model_)
		acc += p_acc[0]/100
	else:
		train_data, test_data = x[train_index], x[test_index]
		train_label, test_label = y[train_index], y[test_index]
		
		print "Building model for classification..."
		clf.fit(train_data, train_label)

		print 'Predicting output labels for fold', str(fold), '\n'
		pred = clf.predict(test_data)
		
		acc += metrics.accuracy_score(test_label, pred)
# 		f1 += metrics.f1_score(test_label, pred)
# 		pr += metrics.precision_score(test_label, pred)

if idx != '5':	
# 	print "Precision: ", str((pr*100)/4) + "%"
# 	print "F1 Score: ", str((f1*100)/4) + "%"
	print(metrics.classification_report(test_label, pred))

print "Avg Accuracy: ", str((acc*100)/4) + "%\n"