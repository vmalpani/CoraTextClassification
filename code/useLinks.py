import cPickle
import operator

'''
Author : Vaibhav Malpani 
Uni: vom2102
Course: Biometrics E6737
Final Project - Research Paper Classification using Abstract Text

This script hasn't been used for experimentation. 
It would be a part of future work when we include citation 
and shared author relation for better classification.

In case of any trouble, pls go through the README file.
'''
print 'Parsing Text Data...'
idx_lbl = [labels.strip().split() for labels in open('cora.categories')]
idx_dict = {}
# Mapping Doc Number --> Class
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
# generate list of tuples [(doc dict, class), (doc dict, class), (doc dict, class)....]
for i in lines:
	out = {}
	label = idx_dict[int(i[0])]
	labels.append(label)
	for j in range(len(i)):
		if j > 0:
			tmp = i[j].split(':')
			out[int(tmp[0])] = float(tmp[1])
	data_tuples.append((out,label))

edges = [edge.strip().split() for edge in open('cora.edges')]
count_edges = 0
edges_dict = {}
# Three level dictionary mapping
# Doc --> Connected Docs --> [Edge Weights]
for i in edges:
	count_edges += 1
	i[0] = int(i[0])
	i[1] = int(i[1])
	if i[0] in edges_dict.keys():
		if i[1] in edges_dict[i[0]].keys():
			for j in range(2,len(i)):
				tmp = map(int,i[j].split(':'))
				if tmp[0] in edges_dict[i[0]][i[1]].keys():
					edges_dict[i[0]][i[1]][tmp[0]].append(tmp[1])
				else:
					edges_dict[i[0]][i[1]][tmp[0]] = [tmp[1]]
		else:
			edges_dict[i[0]][i[1]] = {}
			for j in range(2,len(i)):
				tmp = map(int,i[j].split(':'))
				if tmp[0] in edges_dict[i[0]][i[1]].keys():
					edges_dict[i[0]][i[1]][tmp[0]].append(tmp[1])
				else:
					edges_dict[i[0]][i[1]][tmp[0]] = [tmp[1]]
	else:
		edges_dict[i[0]] = {}
		if i[1] in edges_dict[i[0]].keys():
			for j in range(2,len(i)):
				tmp = map(int,i[j].split(':'))
				if tmp[0] in edges_dict[i[0]][i[1]].keys():
					edges_dict[i[0]][i[1]][tmp[0]].append(tmp[1])
				else:
					edges_dict[i[0]][i[1]][tmp[0]] = [tmp[1]]
		else:
			edges_dict[i[0]][i[1]] = {}
			for j in range(2,len(i)):
				tmp = map(int,i[j].split(':'))
				if tmp[0] in edges_dict[i[0]][i[1]].keys():
					edges_dict[i[0]][i[1]][tmp[0]].append(tmp[1])
				else:
					edges_dict[i[0]][i[1]][tmp[0]] = [tmp[1]]
	if count_edges % 50000 == 0:
		print "Indexing Files..."

# Store data to disk
print "\nIndex Stored: dict_edges.p"
cPickle.dump(edges_dict, open('dict_edges.p', 'wb'))

# Load data from disk
print "\nIndex Loaded: dict_edges.p\n"
edges_dict = cPickle.load(open('dict_edges.p', 'rb'))
sorted_dict = sorted(edges_dict.iteritems(), key=operator.itemgetter(1))

sum = 0
for k,v in class_dict.items():
	sum += len(v)
	print 'Class ' +str(k)+  " : " + str(len(v))
print 'Total Docs: ' + str(sum)