%{ 
    Author : Vaibhav Malpani 
	Research Paper Classification using Abstract Text
%}

To get started, please read the ``Quick Start'' section first.
For running the code samples, please check the ``Usage Examples'' section.

Table of Contents
=================

- Quick Start
- Installation
- Usage Examples
- Additional Information

Quick Start
===========

See the section ``Installation'' for setting up the required third party libraries.

Dataset already pickled.

Code can be accessed from CourseWorks.

Once you have both code and data in place, create a new folder (say 'codata') 
and keep all the files from code and data in one single folder.

We worked with the following configuration to generate results in the report:
(MAC OS X 10.9)
1. MATLAB_R2013a
2. Python 2.7.6
3. liblinear-1.94
4. libsvm-3.17
5. nltk-2.0.4
6. sklearn-0.15

Installation
============

Kindly install the following packages before running any script in ``Usage Examples''. 
After each step, verify if the installation was successful using the instructions 
given in the respective readMe.txt

1. LibSVM (MATLAB and Python Interface)

Installation Link:
http://www.csie.ntu.edu.tw/~cjlin/libsvm/#download

2. LibLinear (MATLAB and Python Interface)

Installation Link:
http://www.csie.ntu.edu.tw/~cjlin/liblinear/#download

3. NLTK (Python)

Installation Link:
http://nltk.org/install.html

4. Scikit-Learn (Python)
	4.1 numpy, scipy, matplotlib (generally installed as a part of scikit)

Installation Link:	
http://scikit-learn.org/stable/install.html

Usage Examples
==============

Enter path to python/MATLAB interface of liblinear when prompted else it would pick up 
our system path giving errors.

(i) PYTHON

> python classifyCora.py

Generates classification report for the following algorithms:
1. Rocchio
2. kNN
3. Stochastic Gradient Descent
4. Linear SVC
5. LibLinear SVM
6. Perceptron

> python parseData.py

Generates 'svmForm.txt' from cora.vectors. 
'svmForm.txt' file is in libsvm format and is used for all our analysis. 
It is supplied as a part of data.tar.gz. 
In case of any problem with 'svmForm.txt', run the above script.

> python useLinks.py

Generates graph structure of the cora dataset.
To be used in future work. Not required right now.

(ii) MATLAB

>> classifyRocchio

This script implements rocchio text classifier using cosine similarity. 

>> classifySVM

This script uses libsvm and generates classification report for the following kernels:
1. RBF Kernel(one-vs-one) 
2. RBF Kernel(one-vs-rest) 
3. Polynomial Kernel(one-vs-one) 
4. Sigmoid Kernel(one-vs-one) 
5. Linear SVM(LibLinear required) 

Additional Information
======================

If you have any trouble, please drop an email to vom2102@columbia.edu