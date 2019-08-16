from n2v.models import N2V
import numpy as np
from matplotlib import pyplot as plt
from tifffile import imread
from csbdeep.io import save_tiff_imagej_compatible
import sys,io,os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
model_name = 'n2v_3D'
basedir = 'models'
model = N2V(config=None, name=model_name, basedir=basedir)


folderName = sys.argv[1]
imList = os.listdir(folderName)

for image in imList:

    jobName = folderName.split('/')
    jobName = str(jobName[1])
    outName = image
    outName = outName.split('.')
    outName = str(outName[0])
    imgName = folderName+'/'+image
    img = imread(imgName)

    pred = model.predict(img, axes='ZYX', n_tiles=(2,4,4))

    if not os.path.isdir('./job_output'):
        os.mkdir('./job_output')
    if not os.path.isdir('./job_output/'+jobName):
        os.mkdir('./job_output/'+jobName)


    save_tiff_imagej_compatible('./job_output/'+jobName+'/'+outName+'_deNoised.tif', pred, 'ZYX')
