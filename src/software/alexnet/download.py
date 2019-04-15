# from urllib import request
from urllib import urlretrieve

def download(line):
	save_path = r'./train/0/%s.JPG '% line.split('/')[-1]

	urlretrieve(line,filename=save_path)

# f 		= 	open("./Url/cat.txt","r")
# line 	= 	f.readline()
# line 	= 	line[:-1]
# while line:
# 	line = f.readline()
# 	line = line[:-1]
# 	download(line)
# f.close() 
download('http://farm2.static.flickr.com/1369/1162408779_6eb2d41a35.jpg')