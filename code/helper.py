import math

'''
Author : Vaibhav Malpani 
Uni: vom2102
Course: Biometrics E6737
Final Project - Research Paper Classification using Abstract Text

Simple script to calculate cosine similarity between two vectors.
In case of any trouble, pls go through the README file.
'''
def cos_sim(a,b):
	if len(a) != len(b):
		print 'Vector dimensions dont match!'
	else:
		norm_a = norm_b = 0
		num = 0
		for i in range(len(a)):
			num += (a[i]*b[i])
			norm_a += (a[i]*a[i])
			norm_b += (b[i]*b[i])
		try:
			out_val = num/(math.sqrt(norm_a)*math.sqrt(norm_b))
		except:
			out_val = 0
	return out
