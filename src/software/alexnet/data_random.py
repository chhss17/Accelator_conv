import random
import os

def changemode(number):
	result = str(number)
	if(len(result) == 1):
		return '00' + result + '.jpg'
	elif(len(result) == 2):
		return '0' + result + '.jpg'
	else:
		return result + '.jpg'

li = [i for i in range(200)]
random.shuffle(li)
for i in range(200):
	print(i,li[i])

path = ['./0/','./1/','./2/','./3/','./4/']
name = ['/home/ggjiji/GitHub/alexnet/Picture/train/0/','/home/ggjiji/GitHub/alexnet/Picture/train/1/','/home/ggjiji/GitHub/alexnet/Picture/train/2/','/home/ggjiji/GitHub/alexnet/Picture/train/3/','/home/ggjiji/GitHub/alexnet/Picture/train/4/']

txt = open('./data_train.txt','w')
for i in range(5):
	files = os.listdir(path[i])
	n = 0 
	for j in files:
		print(path[i],j,files[n])
		n = n + 1
		rename = changemode(li[i*40 + n - 1])
		print(i*40 + n,rename)
		# txts = name[i] + files[n - 1] + '\r'
		txts = name[i] + rename  + ' ' + name[i][42] + '\r'
		txt.write(txts)
		os.rename(os.path.join(path[i],j),os.path.join(path[i],rename))