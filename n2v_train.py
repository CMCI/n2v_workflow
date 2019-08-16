from n2v.models import N2VConfig, N2V
import numpy as np
from csbdeep.utils import plot_history
from n2v.utils.n2v_utils import manipulate_val_data
from n2v.internals.N2V_DataGenerator import N2V_DataGenerator
from matplotlib import pyplot as plt
import urllib
import os
import zipfile
# create a folder for our data
if not os.path.isdir('./data'):
    os.mkdir('./data')

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'


# check if data has been downloaded already
#zipPath='data/flywing-data.zip'
#if not os.path.exists(zipPath):
#    #download and unzip data
#    data = urllib.request.urlretrieve('https://cloud.mpi-cbg.de/index.php/s/RKStdwKo4FlFrxE/download', zipPath)
#    with zipfile.ZipFile(zipPath, 'r') as zip_ref:
#        zip_ref.extractall('data')
datagen = N2V_DataGenerator()
imgs = datagen.load_imgs_from_directory(directory = "data/", dims='ZYX')
patches = datagen.generate_patches_from_list(imgs[:1], shape=(32, 64, 64))

scal = int(np.floor(0.8*patches.shape[0]))

X = patches[:scal]
X_val = patches[scal:]

config = N2VConfig(X, unet_kern_size=3, 
                   train_steps_per_epoch=100,train_epochs=10, train_loss='mse', batch_norm=True, 
                   train_batch_size=4, n2v_perc_pix=1.6, n2v_patch_shape=(32, 64, 64), 
                   n2v_manipulator='uniform_withCP', n2v_neighborhood_radius=5)

# a name used to identify the model
model_name = 'n2v_3D'
# the base directory in which our model will live
basedir = 'models'
# We are now creating our network model.
model = N2V(config=config, name=model_name, basedir=basedir)
history = model.train(X, X_val)

model.export_TF()
