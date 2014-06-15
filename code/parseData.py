'''
Author : Vaibhav Malpani 
Uni: vom2102
Course: Biometrics E6737
Final Project - Research Paper Classification using Abstract Text

This script was used to convert the given dataset (cora.vectors) into libsvm format.
We generate 'svmForm.txt' file which will be used throughout our analysis.
Run this script to regenerate 'svmForm.txt' in case of any issues.

In case of any trouble, pls go through the README file.
'''

print 'Parsing Text Data...'
idx_lbl = [labels.strip().split() for labels in open('cora.categories')]
idx_dict = {}
for i in idx_lbl:
	idx_dict[int(i[0])] = int(i[1])

class_dict = {}
for k,v in idx_dict.items():
	if v in class_dict.keys():
		class_dict[v].append(k)
	else:
		class_dict[v] = [k]

lines = [line.strip().split() for line in open('cora.vectors')]
data_tuples = []
labels = []
vec_len = []

# replace doc number with its appropriate class to generate data in libsvm format
# for further processing
with open('cora.vectors') as read_f, open('svmForm.txt','w') as out_f:
	for line in read_f:
		tmp = line.split()
		if len(tmp) > 1:
			a = []
			sort_features = []
			for i in tmp[1:]:
				a.append(int((i.split(':'))[0]))
			sort_idx = [i[0] for i in sorted(enumerate(a), key=lambda x:x[1])]
			for i in sort_idx:	
				sort_features.append(tmp[i+1])
			out = ' '.join(sort_features)
			out_f.write(str(idx_dict[int(tmp[0])])+ ' ' + out)
			out_f.write('\n')	

# generate list of tuples [(doc dict, class), (doc dict, class), (doc dict, class)....]
# data_tuples can then be passed to nltk directly to classify data
# we won't be using nltk for classification 
# scikit has a more optimized version of all classification algorithms for text mining
for i in lines:
	out = {}
	label = idx_dict[int(i[0])]
	labels.append(label)
	vec_len.append(len(i))
	for j in range(1,len(i)):
		tmp = i[j].split(':')
		out[tmp[0]] = float(tmp[1])
	data_tuples.append((out,str(label)))

sum = 0
for k,v in class_dict.items():
	sum += len(v)
	print str(k)+  " : " + str(len(v))