# _*_ coding: utf-8 _*_
import os
import struct
import tensorflow as tf
import scipy.signal
from tensorflow.python import pywrap_tensorflow
from tensorflow.python.framework import graph_util
import scipy.io as sio
from skimage import io,transform
import glob

from tensorflow.examples.tutorials.mnist import input_data
import matplotlib.pyplot as plt

from PIL import Image
import numpy as np

np.set_printoptions(suppress=True)
np.set_printoptions(threshold=np.inf) 


def load_mnist():
	images_path = os.path.join('/home/ggjiji/GitHub/mnist/t10k-images.idx3-ubyte')
	binfile =  open(images_path, 'rb')
	buf = binfile.read()

	index = 0
	magic,num,rows,cols = struct.unpack_from('>IIII',buf,index)	# read the first four bytes data
	index += struct.calcsize('>IIII')
	image_data = struct.unpack_from('>784B',buf,index)	# read the next 784 bytes data
	index += struct.calcsize('>784B')
	#images = np.fromfile(imgpath,dtype=np.uint8).reshape(1000,784)
	binfile.close()
	im = np.array(image_data)
	im = im.reshape(28,28)
	#print im
	im_pad = np.pad(im,((2,2),(2,2)),'constant',constant_values=(0,0))
	#print im_pad

	new_im = np.transpose(im_pad.tolist())

	# fig = plt.figure()
	# plotwindow = fig.add_subplot(111)
	# plt.axis('off')
	# plt.imshow(im,cmap='gray')
	# #plt.savefig("test_7.png")
	# plt.show()
	
	return new_im

def load_model():
	checkpoint_path = os.path.join("./model.ckpt-10")
	reader = pywrap_tensorflow.NewCheckpointReader(checkpoint_path)
	var_to_shape_map = reader.get_variable_to_shape_map()

	w_conv1 = reader.get_tensor('layer1-conv1/weight')
	b_conv1 = reader.get_tensor('layer1-conv1/bias')

	w_conv2 = reader.get_tensor('layer3-conv2/weight')
	b_conv2 = reader.get_tensor('layer3-conv2/bias')

	w_fc1 	= reader.get_tensor('layer5-fc1/weight')
	b_fc1 	= reader.get_tensor('layer5-fc1/bias')

	w_fc2 	= reader.get_tensor('layer6-fc2/weight')
	b_fc2 	= reader.get_tensor('layer6-fc2/bias')

	w_fc3 	= reader.get_tensor('layer7-fc3/weight')
	b_fc3 	= reader.get_tensor('layer7-fc3/bias')	
	return w_conv1,b_conv1,w_conv2,b_conv2,w_fc1,b_fc1,w_fc2,b_fc2,w_fc3,b_fc3

train_path = "/home/ggjiji/GitHub/lenet5/mnist/train/6/00018.png"

image = io.imread(train_path)

input_data = np.pad(image,((2,2),(2,2)),'constant',constant_values=(255,255))
#sio.savemat('./input_data.mat',{'input_data':input_data})

#input_data = load_mnist().reshape((1,32,32,1))
input_data = input_data.reshape((1,32,32,1)).astype(float)
w_conv1,b_conv1,w_conv2,b_conv2,w_fc1,b_fc1,w_fc2,b_fc2,w_fc3,b_fc3 = load_model()

conv1 = tf.nn.conv2d(input_data,w_conv1,strides=[1,1,1,1],padding='VALID')
conv1 = tf.floor(conv1)
relu1 = tf.nn.relu(tf.nn.bias_add(conv1,b_conv1))

pool1 = tf.nn.max_pool(relu1,ksize=[1,2,2,1],strides=[1,2,2,1],padding='SAME')
pool1 = tf.floor(pool1)

conv2 = tf.nn.conv2d(pool1,w_conv2,strides=[1,1,1,1],padding='VALID')
conv2 = tf.floor(conv2)
relu2 = tf.nn.relu(tf.nn.bias_add(conv2,b_conv2))

# pool2 = tf.nn.max_pool(relu2,ksize=[1,2,2,1],strides=[1,2,2,1],padding='SAME')
# pool2 = tf.floor(pool2)

#sio.savemat('./lenet_5_new.mat',{'conv1_w':w_conv1,'conv1_b':b_conv1,'conv2_w':w_conv2,'conv2_b':b_conv2})
#sio.savemat('./pool_result.mat',{'reshaped':reshaped})
mat_data = sio.loadmat('./pool_result.mat')
pool2 = mat_data['hdpool2']

# pool_shape = pool2.get_shape().as_list()
# nodes = pool_shape[1]*pool_shape[2]*pool_shape[3]
reshaped = tf.reshape(pool2,[-1,400])

fc1 = tf.nn.relu(tf.matmul(tf.cast(reshaped,tf.float32),w_fc1) + b_fc1)

fc2 = tf.nn.relu(tf.matmul(fc1,w_fc2) + b_fc2)

fc3 = tf.matmul(fc2,w_fc3) + b_fc3

result = tf.nn.softmax(logits=fc3)
# print(input_data[0,:,:,0])
# print(w_conv1[:,:,0,0])
sess = tf.Session()
#print(sess.run(reshaped))
print(sess.run(result))
