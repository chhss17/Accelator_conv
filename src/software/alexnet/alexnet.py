# _*_ coding: utf-8 _*_
from skimage import io,transform
import os
import glob
import numpy as np
import tensorflow as tf

tf.reset_default_graph()

np.set_printoptions(suppress=True)
np.set_printoptions(threshold=np.inf) 

train_path = "/home/ggjiji/GitHub/alexnet/Picture/train/"
test_path = "/home/ggjiji/GitHub/alexnet/Picture/test/"

def read_image(path):
    label_dir = [path+x for x in os.listdir(path) if os.path.isdir(path+x)]
    images = []
    labels = []
    for index,folder in enumerate(label_dir):
        for img in glob.glob(folder+'/*.jpg'):
            print("reading the image:%s"%img)
            image = io.imread(img)
            images.append(image)
            labels.append(index)
    return np.asarray(images,dtype=np.float32),np.asarray(labels,dtype=np.int32)


def print_tensor_info(tensor):
	print("tensor name:",tensor.op.name," -tensor shape:",tensor.get_shape().as_list())

def Alexnet(input_tensor,train,regularizer):
	#	conv1
	with tf.variable_scope('conv1'):
		conv1_weights 	= 	tf.get_variable('weight',[11,11,3,64],initializer=tf.truncated_normal_initializer(stddev=0.1))
		conv1_bias 		= 	tf.get_variable('bias',[64],initializer=tf.constant_initializer(0.0))
		conv1 			= 	tf.nn.conv2d(input_tensor,conv1_weights,strides=[1,4,4,1],padding='SAME')
        relu1 			= 	tf.nn.relu(tf.nn.bias_add(conv1,conv1_bias))
        #	print information
        print_tensor_info(relu1)

    #	pool1
	with tf.variable_scope('pool1'):
		pool1 			=	tf.nn.max_pool(relu1,ksize=[1,2,2,1],strides=[1,2,2,1],padding='VALID')
    	#	print information
    	print_tensor_info(pool1)

    #	conv2
	with tf.variable_scope('conv2'):
		conv2_weights 	= 	tf.get_variable('weight',[5,5,64,192],initializer=tf.truncated_normal_initializer(stddev=0.1))
		conv2_bias 		= 	tf.get_variable('bias',[192],initializer=tf.constant_initializer(0.0))
		conv2 			= 	tf.nn.conv2d(pool1 ,conv2_weights,strides=[1,1,1,1],padding='SAME')
        relu2 			= 	tf.nn.relu(tf.nn.bias_add(conv2,conv2_bias))
        #	print information
        print_tensor_info(relu2)

    # 	pool2
	with tf.variable_scope('pool2'):
		pool2 			=	tf.nn.max_pool(relu2,ksize=[1,2,2,1],strides=[1,2,2,1],padding='VALID')
    	#	print information
    	print_tensor_info(pool2)

    # 	conv3
	with tf.variable_scope('conv3'):
		conv3_weights 	= 	tf.get_variable('weight',[3,3,192,384],initializer=tf.truncated_normal_initializer(stddev=0.1))
		conv3_bias 		= 	tf.get_variable('bias',[384],initializer=tf.constant_initializer(0.0))
		conv3 			= 	tf.nn.conv2d(pool2,conv3_weights,strides=[1,1,1,1],padding='SAME')
        relu3 			= 	tf.nn.relu(tf.nn.bias_add(conv3,conv3_bias))
        #	print information
        print_tensor_info(relu3)

	# 	conv4
	with tf.variable_scope('conv4'):
		conv4_weights 	= 	tf.get_variable('weight',[3,3,384,256],initializer=tf.truncated_normal_initializer(stddev=0.1))
		conv4_bias 		= 	tf.get_variable('bias',[256],initializer=tf.constant_initializer(0.0))
		conv4 			= 	tf.nn.conv2d(relu3,conv4_weights,strides=[1,1,1,1],padding='VALID')
        relu4 			= 	tf.nn.relu(tf.nn.bias_add(conv4,conv4_bias))
        print_tensor_info(relu4)

   	# 	conv5
	with tf.variable_scope('conv5'):
		conv5_weights 	= 	tf.get_variable('weight',[3,3,256,256],initializer=tf.truncated_normal_initializer(stddev=0.1))
		conv5_bias 		= 	tf.get_variable('bias',[256],initializer=tf.constant_initializer(0.0))
		conv5 			= 	tf.nn.conv2d(relu4,conv5_weights,strides=[1,1,1,1],padding='SAME')
        relu5 			= 	tf.nn.relu(tf.nn.bias_add(conv5,conv5_bias))
        print_tensor_info(relu5)

    # 	pool5
	with tf.variable_scope('pool5'):
		pool5 			=	tf.nn.max_pool(relu5,ksize=[1,2,2,1],strides=[1,2,2,1],padding='VALID')
    	#	print information
    	print_tensor_info(pool5)

    # 	reshaped
	reshaped 	=	tf.reshape(pool5,[-1,6*6*256])

    # 	fc1
	with tf.variable_scope('fc1'):
		fc1_weights 	=	tf.get_variable('weight',[6*6*256,4096],initializer=tf.truncated_normal_initializer(stddev=0.1))
		if regularizer != None:
			tf.add_to_collection('losses',regularizer(fc1_weights))
    	# fc1_bias  		=	tf.get_variable('bias',[4096],initializer=tf.constant_initializer(0.0))
    	fc1_bias 		=	tf.Variable(tf.constant(0.0,dtype=tf.float32,shape=[4096]),name='bias')
    	fc1 			=	tf.nn.relu(tf.matmul(reshaped,fc1_weights) + fc1_bias)
    	if train:
            fc1 		= 	tf.nn.dropout(fc1,0.5)

    #	fc2
	with tf.variable_scope('fc2'):
		fc2_weights 	=	tf.get_variable('weight',[4096,4096],initializer=tf.truncated_normal_initializer(stddev=0.1))
		if regularizer != None:
			tf.add_to_collection('losses',regularizer(fc2_weights))
    	# fc2_bias  		=	tf.get_variable('bias_2',[4096],initializer=tf.constant_initializer(0.0))
    	fc2_bias 		=	tf.Variable(tf.constant(0.0,dtype=tf.float32,shape=[4096]),name='bias')
    	fc2 			=	tf.nn.relu(tf.matmul(fc1,fc2_weights) + fc2_bias)
    	if train:
    		fc2 		= 	tf.nn.dropout(fc2,0.5)

    # 	fc3
	with tf.variable_scope('fc3'):
		fc3_weights 	=	tf.get_variable('weight',[4096,1000],initializer=tf.truncated_normal_initializer(stddev=0.1))
		if regularizer != None:
			tf.add_to_collection('losses',regularizer(fc3_weights))
    	fc3_bias 		=	tf.Variable(tf.constant(0.0,dtype=tf.float32,shape=[1000]),name='bias')
    	fc3 			=	tf.nn.relu(tf.matmul(fc2,fc3_weights) + fc3_bias)
    	if train:
    		fc3 		=	tf.nn.dropout(fc3,0.5)

    # 	fc4
	with tf.variable_scope('fc4'):
		fc4_weights 	=	tf.get_variable('weight',[1000,5],initializer=tf.truncated_normal_initializer(stddev=0.1))
		if regularizer != None:
			tf.add_to_collection('losses',regularizer(fc4_weights))
    	fc4_bias 		=	tf.Variable(tf.constant(0.0,dtype=tf.float32,shape=[5]),name='bias')
    	logit 			=	tf.matmul(fc3,fc4_weights) + fc4_bias

	return logit

def get_batch(data,label,batch_size):
    for start_index in range(0,len(data)-batch_size+1,batch_size):
        slice_index = slice(start_index,start_index+batch_size)
        yield data[slice_index],label[slice_index]

if __name__ == "__main__":
	
	#	read the train/test image and labels
	train_data,	train_label = 	read_image(train_path)
	test_data,	test_label  = 	read_image(test_path)
	
	#	reorder the train/test data
	train_image_num 	=	len(train_data)
	train_image_index 	=	np.arange(train_image_num)
	np.random.shuffle(train_image_index)
	train_data			=	train_data[train_image_index]
	train_label			=	train_label[train_image_index]
	test_image_num 		=	len(test_data)
	test_image_index 	=	np.arange(test_image_num)
	np.random.shuffle(test_image_index)
	test_data			=	test_data[test_image_index]
	test_label			=	test_label[test_image_index]
	
	#	built the CNN
	x 			=	tf.placeholder(tf.float32,[None,224,224,3],name='x')
	y_ 			=	tf.placeholder(tf.int32,[None],name='y_')

	#	regularizer
	regularizer 		=	tf.contrib.layers.l2_regularizer(0.001)
	y  					=	Alexnet(x,True,regularizer)
	cross_entropy 		=	tf.nn.sparse_softmax_cross_entropy_with_logits(logits=y,labels=y_)
	cross_entropy_mean 	=	tf.reduce_mean(cross_entropy)
	loss 				=	cross_entropy_mean + tf.add_n(tf.get_collection('losses'))
	train_op 			=	tf.train.AdamOptimizer(0.001).minimize(loss)
	correct_prediction 	=	tf.equal(tf.cast(tf.argmax(y,1),tf.int32),y_)
	accuracy  			=	tf.reduce_mean(tf.cast(correct_prediction,tf.float32))

	#	create the session
	saver 		= 	tf.train.Saver()
	with tf.Session() as sess:
		sess.run(tf.global_variables_initializer())

		train_num  	= 	10
		batch_size	=	5

   		for i in range(train_num):
   			train_loss,train_acc,batch_num = 0, 0, 0
			for train_data_batch,train_label_batch in get_batch(train_data,train_label,batch_size):
				_,err,acc = sess.run([train_op,loss,accuracy],feed_dict={x:train_data_batch,y_:train_label_batch})
				train_loss+=err;train_acc+=acc;batch_num+=1
			print("train loss:",train_loss/batch_num)
			print("train acc:",train_acc/batch_num)

			test_loss,test_acc,batch_num = 0, 0, 0
			for test_data_batch,test_label_batch in get_batch(test_data,test_label,batch_size):
				err,acc = sess.run([loss,accuracy],feed_dict={x:test_data_batch,y_:test_label_batch})
				test_loss+=err;test_acc+=acc;batch_num+=1
			print("test loss:",test_loss/batch_num)
			print("test acc:",test_acc/batch_num)
		saver.save(sess, './model.ckpt', global_step=train_num)		