% Register two images with SIFT and RANSAC
% run this before use: run('VLFEATROOT/toolbox/vl_setup')
% more directions here: http://www.vlfeat.org/install-matlab.html
run('~/vlfeat-0.9.20/toolbox/vl_setup');

% set dimensions of input images to be resized to
dim = [256 256];

% read in unregistered image
unregistered = imresize(imread('pics/cantilever1_2.jpg'), dim);
% allow user to crop image
%[unregistered,~] = imcrop(unregistered);
%unregistered
%figure, imshow(unregistered)

% read in reference image
reference = imresize(imread('pics/cantilever_layout1e.bmp'), dim);
% allow user to crop image
%[reference,~] = imcrop(reference);
%reference
%figure, imshow(reference)

im1 = rgb2gray(reference);
size(im1)
im2 = rgb2gray(unregistered);
size(im2)
patchsize = 8; % half of the window size for computing SIFT
gridspacing = 1; % sampling step
SiftIm1=iat_dense_sift(im2double(im1),patchsize,gridspacing);
SiftIm2=iat_dense_sift(im2double(im2),patchsize,gridspacing); 
figure;imshow(iat_sift2rgb(SiftIm1));title('SIFT image 1');
figure;imshow(iat_sift2rgb(SiftIm2));title('SIFT image 2');

SIFTflowpara.alpha=0.01;
SIFTflowpara.d=0.2;
SIFTflowpara.gamma=0.001;
SIFTflowpara.nlevels=4;
SIFTflowpara.wsize=3;
SIFTflowpara.topwsize=10;
SIFTflowpara.nIterations=60;
[vx, vy, energylist] = iat_SIFTflow(SiftIm1, SiftIm2, SIFTflowpara);

newIm2 = im2(patchsize/2+1:end-patchsize/2, patchsize/2+1:end-patchsize/2);
[warpedIm2, support] = iat_pixel_warping(newIm2, vx, vy);
newIm1 = im1(patchsize/2+1:end-patchsize/2, patchsize/2+1:end-patchsize/2);
[~, grayerror] = iat_error2gray(newIm1,warpedIm2,support);
figure;imshow(newIm1);title('Image1');
figure;imshow(uint8(warpedIm2)); title('Warped Image2');
figure;imshow(grayerror); title('Registration error'); 

figure;imshow(iat_error2rgb(uint8(newIm1),uint8(warpedIm2)));title('Colorized alignment error');
