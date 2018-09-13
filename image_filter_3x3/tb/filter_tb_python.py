from skimage.io import imread, imsave, imshow
from skimage.transform import resize
import  skimage as ski
import numpy as np
from numpy.fft import fft2, fftshift
import matplotlib.pyplot as plt
from math import pi, exp
from numpy import array
from scipy.signal import convolve2d
from skimage import img_as_ubyte

#-----------------------------




img   = imread('raw_bw.png')

fig, (ax0, ax1) = plt.subplots(1, 2)
ax0.imshow(img, cmap='gray')
ax1.imshow(img, cmap ='gray')


imsave ('raw_bw.bmp', img)
