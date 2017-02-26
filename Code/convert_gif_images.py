#!/usr/bin/env python
#-*- encoding:utf-8 -*-
from PIL import ImageGrab # from PIL
import time
import string
from PIL import Image, ImageChops
from PIL.GifImagePlugin import getheader, getdata
import os ,sys

def intToBin(i):
    """ ��������ת��Ϊ˫�ֽ� """
    # �ȷֳ�������,��8λ�͵�8λ
    i1 = i % 256
    i2 = int( i/256)
    # �ϳ�С�˶�����ַ���
    return chr(i1) + chr(i2)
def getheaderAnim(im):
    """ ���ɶ����ļ�ͷ """
    bb = "GIF89a"
    bb += intToBin(im.size[0])
    bb += intToBin(im.size[1])
    bb += "\x87\x00\x00"  #ʹ��ȫ����ɫ��
    return bb
def getAppExt(loops=0):
    """ Ӧ����չ,Ĭ��Ϊ0,Ϊ0�Ǳ�ʾ����������ֹͣ
    """
    bb = "\x21\xFF\x0B"  # application extension
    bb += "NETSCAPE2.0"
    bb += "\x03\x01"
    if loops == 0:
        loops = 2**16-1
    bb += intToBin(loops)
    bb += '\x00'  # end
    return bb


def getGraphicsControlExt(duration=0.1):
    """ ���ö���ʱ���� """
    bb = '\x21\xF9\x04'
    bb += '\x08'  # no transparancy
    bb += intToBin( int(duration*100) ) # in 100th of seconds
    bb += '\x00'  # no transparant color
    bb += '\x00'  # end
    return bb



def _writeGifToFile(fp, images, durations, loops):
    """ ��һϵ��ͼ��ת��Ϊ�ֽڲ������ļ�����
    """
    # ��ʼ��
    frames = 0
    previous = None
    for im in images:
        if not previous:
            # ��һ��ͼ��
            # ��ȡ�������
            palette = getheader(im)[1]  #ȡ��һ��ͼ��ĵ�ɫ��
            data = getdata(im)
            imdes, data = data[0], data[1:]            
            header = getheaderAnim(im)
            appext = getAppExt(loops)
            graphext = getGraphicsControlExt(durations[0])
            
            # д��ȫ��ͷ
            fp.write(header) 
            fp.write(palette)
            fp.write(appext)
            
            # д��ͼ��
            fp.write(graphext)
            fp.write(imdes)
            for d in data:
                fp.write(d)
            
        else:
            # ��ȡ�������          
            data = getdata(im) 
            imdes, data = data[0], data[1:]       
            graphext = getGraphicsControlExt(durations[frames])
            
            # д��ͼ��
            fp.write(graphext)
            fp.write(imdes)
            for d in data:
                fp.write(d)   
        # ׼����һ���غ�
        previous = im.copy()        
        frames = frames + 1

    fp.write(";")  # д�����
    return frames

def writeGif(filename, images, duration=0.1, loops=0, dither=1):
    """ writeGif(filename, images, duration=0.1, loops=0, dither=1)
    �������ͼ�������д���GIF����
    images ��һ��PIL Image [] ���� Numpy Array
    """
    images2 = []
    # �Ȱ�ͼ��ת��ΪPIL��ʽ
    for im in images:
        
        if isinstance(im,Image.Image): #�����PIL Image
            images2.append( im.convert('P',dither=dither) )
            
        elif np and isinstance(im, np.ndarray): #�����Numpy��ʽ
            if im.dtype == np.uint8:
                pass
            elif im.dtype in [np.float32, np.float64]:
                im = (im*255).astype(np.uint8)
            else:
                im = im.astype(np.uint8)
            # ת��
            if len(im.shape)==3 and im.shape[2]==3:
                im = Image.fromarray(im,'RGB').convert('P',dither=dither)
            elif len(im.shape)==2:
                im = Image.fromarray(im,'L').convert('P',dither=dither)
            else:
                raise ValueError("ͼ���ʽ����ȷ")
            images2.append(im)
            
        else:
            raise ValueError("δ֪ͼ���ʽ")
    
    # ��鶯������ʱ��
    durations = [duration for im in images2]
    # ���ļ�
    fp = open(filename, 'wb')
    # д��GIF
    try:
        n = _writeGifToFile(fp, images2, durations, loops)
    finally:
        fp.close()
    return n

############################################################
## ����֡λͼ�ϳ�Ϊһ��gifͼ��
def images2gif( images, giffile, durations=0.05, loops = 1):
    seq = []
    for i in range(len(images)):
        im = Image.open(images[i])
        background = Image.new('RGB', im.size, (255,255,255))
        background.paste(im, (0,0))
        seq.append(background)
    frames = writeGif( giffile, seq, durations, loops)
    print frames, 'images has been merged to', giffile

## ��gifͼ��ÿһ֡��ɶ�����λͼ 
def gif2images( filename, distDir = '.', type = 'bmp' ):
    if not os.path.exists(distDir):
        os.mkdir(distDir)
    print 'spliting', filename,
    im  = Image.open( filename )
    im.seek(0)  # skip to the second frame
    cnt = 0
    type = string.lower(type)
    mode = 'RGB'  # image modea
    if type == 'bmp' or type == 'png':
        mode = 'P'    # image mode 
    im.convert(mode).save(distDir+'/%d.'%cnt+type )
    cnt = cnt+1
    try:
        while 1:
            im.seek(im.tell()+1)
            im.convert(mode).save(distDir+'/%d.'%cnt+type)
            cnt = cnt+1
    except EOFError:
        pass # end of sequence
    white = (255,255,255)
    preIm = Image.open(distDir+'/%d.'%0+type).convert('RGB')
    size = preIm.size
    prePixs = preIm.load()
    for k in range (1,cnt):
        print '.',
        im = Image.open(distDir+'/%d.'%k+type).convert('RGB')
        pixs = im.load()
        for i in range(size[0]):
            for j in range(size[1]):
                if pixs[i,j] == white:
                    pixs[i,j] = prePixs[i,j]
        preIm = im
        prePixs = preIm.load()
        im.convert(mode).save(distDir+'/%d.'%k+type)
    print '\n', filename, 'has been splited to directory: [',distDir,']'
    return cnt      # ��֡��

##############################################################
if __name__ == '__main__':
	params=sys.argv[:]
	if len(params)<4:
		print 'Error,number of parameters not match,Usage:'
		print '>>>convert gif2images: convert_git_images.py gif2img Source.gif DestDir [type=jpg(defualt)]'
		print '>>>convert images2gif: convert_git_images.py img2gif SourceDire Des.gif [type=jpg(defualt)]'
	type='jpg'
	if len(params)>4:
		type=params[4]
	
	if params[1]=='gif2img':
		frames = gif2images(filename=params[2],distDir=params[3],type=type)
	elif params[1]=='img2gif':
		files=os.listdir(params[2])
		ext='.'+type;
		images=[]
		for x in files:
			if os.path.splitext(x)[1]==ext:
				imgpath=os.path.join(params[2],x)
				images.append(imgpath)
		frames=len(images)
		print images
		for i in range(frames-1,-1,-1):
			images2gif(images,params[3], durations = 0.05)
	else:
		print 'only gif2img and img2gif supported!'
